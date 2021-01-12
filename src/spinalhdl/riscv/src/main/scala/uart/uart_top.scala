package uart

import wishbone._

import spinal.core._
import spinal.lib._

case class riscv_config(
    busWishBoneConfig: WishBoneConfig
)

object UartRxState extends SpinalEnum {
  val sRxReset, sRxIdle, sRxStart, sRxD0, sRxD1, sRxD2, sRxD3, sRxD4, sRxD5,
      sRxD6, sRxD7, sRxP0, sRxStop = newElement()
}

object UartTxState extends SpinalEnum {
  val sTxReset, sTxIdle, sTxStart, sTxD0, sTxD1, sTxD2, sTxD3, sTxD4, sTxD5,
      sTxD6, sTxD7, sTxP0, sTxStop = newElement()
}

case class UartBuffEntry() extends Bundle {
  val Vld = Bool
  val Data = Bits( 8 bits )
}

case class UartBuff() extends Bundle {
  var SIZE = 16

  val wrNdx = Reg( UInt( log2Up( SIZE ) bits ) )
  val wrDataNdx = Reg( UInt( log2Up( SIZE ) bits ) )
  val rdNdx = Reg( UInt( log2Up( SIZE ) bits ) )
  val buffer = Vec( Reg( UartBuffEntry() ), SIZE )

  wrNdx init ( 0)
  wrDataNdx init ( 0)
  rdNdx init ( 0)
  for (entry <- buffer) {
    entry.Vld init ( False)
  }

  def Clear(): Unit = {
    wrDataNdx := wrNdx
    rdNdx := wrNdx
    for (entry <- buffer) {
      entry.Vld := False
    }
  }

  def Push( data: Bits ): Unit = {
    buffer( wrNdx ).Vld := True
    buffer( wrNdx ).Data := data
    wrNdx := wrNdx + 1
  }

  def Pull(): Bits = {
    val data = Bits( 8 bits )
    data := buffer( rdNdx ).Data
    buffer( rdNdx ).Vld := False
    rdNdx := rdNdx + 1
    return data
  }

  //Empty if first entry is invalid,
  //or if first entry is normal op and second entry invalid
  def Empty(): Bool = ~buffer( rdNdx ).Vld

  def Full(): Bool = buffer( wrNdx ).Vld

  def Count(): UInt = {
    var count = UInt( 32 bits );
    count := 0
    for (entry <- buffer) {
      when( entry.Vld ) {
        count \= count + 1
      }
    }
    return count
  }

}

class uart_top extends Component {
  import UartRxState._
  import UartTxState._

  val config = riscv_config(
    busWishBoneConfig = WishBoneConfig(
      adrWidth  = 32,
      selWidth  = 4,
      dataWidth = 32,
      tgaWidth  = 1,
      tgdWidth  = 1,
      tgcWidth  = 4
    )
  )

  val GND = out( Bool )
  val TXD = out( Bool )
  val RXD = in( Bool )
  val CTS = in( Bool )
  val RTS = out( Bool )

  val IRQ = out( Bool )

  val bus = slave( WishBone( config.busWishBoneConfig ) )

  val busReq = WishBoneReq( config.busWishBoneConfig )
  busReq := bus.req.ReverseEndian() //Little to Big Endian

  val busRsp = Reg( WishBoneRsp( config.busWishBoneConfig ) )
  bus.rsp := busRsp.ReverseEndian() //Big to Little Endian
  busRsp.ack init ( False)

  val busStall = Reg( Bool )
  bus.stall := busStall
  busStall init ( False)

  val baudRate = Reg( Bits( 32 bits ) )

  val rxBuf = UartBuff()
  val txBuf = UartBuff()

  GND := False

  baudRate := baudRate

  //Send stall if the TX buffer is filled
  busStall := txBuf.Full()

  //Set IRQ if RX buffer is not empty
  IRQ := ~rxBuf.Empty()

  busRsp.ack := False
  busRsp.err := False
  busRsp.rty := False
  busRsp.data := busRsp.data
  busRsp.tga := busRsp.tga
  busRsp.tgd := busRsp.tgd
  busRsp.tgc := busRsp.tgc

  when( busReq.cyc && busReq.stb ) {
    busRsp.ack := True
    busRsp.err := False
    busRsp.rty := False
    busRsp.data := 0
    busRsp.tga := busReq.tga
    busRsp.tgd := busReq.tgd
    busRsp.tgc := busReq.tgc

    switch( busReq.adr.asBits.resizeLeft( busReq.adr.getWidth - 2 ) ) {
      is( 0 ) {
        when( busReq.we ) {
          when( busReq.sel( 0 ) ) {
            txBuf.Push( busReq.data( 7 downto 0 ) )
          }
        } otherwise {
          when( ~rxBuf.Empty() ) {
            when( busReq.sel( 0 ) ) {
              busRsp.data( 7 downto 0 ) := rxBuf.Pull()
            }
          }
        }
      }
      is( 1 ) {
        when( busReq.we ) {
          when( busReq.sel( 3 ) ) {
            baudRate( 31 downto 24 ) := busReq.data( 31 downto 24 )
          }
          when( busReq.sel( 2 ) ) {
            baudRate( 23 downto 16 ) := busReq.data( 23 downto 16 )
          }
          when( busReq.sel( 1 ) ) {
            baudRate( 15 downto 8 ) := busReq.data( 15 downto 8 )
          }
          when( busReq.sel( 0 ) ) {
            baudRate( 7 downto 0 ) := busReq.data( 7 downto 0 )
          }
        } otherwise {
          when( busReq.sel( 3 ) ) {
            busRsp.data( 31 downto 24 ) := baudRate( 31 downto 24 )
          }
          when( busReq.sel( 2 ) ) {
            busRsp.data( 23 downto 16 ) := baudRate( 23 downto 16 )
          }
          when( busReq.sel( 1 ) ) {
            busRsp.data( 15 downto 8 ) := baudRate( 15 downto 8 )
          }
          when( busReq.sel( 0 ) ) {
            busRsp.data( 7 downto 0 ) := baudRate( 7 downto 0 )
          }
        }
      }
      is( 2 ) {
        when( busReq.we ) {} otherwise {
          val rxBufCount = UInt( 32 bits )
          rxBufCount := rxBuf.Count()
          when( busReq.sel( 3 ) ) {
            busRsp.data( 31 downto 24 ) := B( rxBufCount( 31 downto 24 ) )
          }
          when( busReq.sel( 2 ) ) {
            busRsp.data( 23 downto 16 ) := B( rxBufCount( 23 downto 16 ) )
          }
          when( busReq.sel( 1 ) ) {
            busRsp.data( 15 downto 8 ) := B( rxBufCount( 15 downto 8 ) )
          }
          when( busReq.sel( 0 ) ) {
            busRsp.data( 7 downto 0 ) := B( rxBufCount( 7 downto 0 ) )
          }
        }
      }
    }
  }

  //RX State Machine

  val rxState = Reg( UartRxState() )
  rxState init ( sRxReset)

  val rxCounter = Reg( UInt( 32 bits ) )
  rxCounter init ( 0)

  val rxData = Reg( Bits( 8 bits ) )

  //Disable RX if the RX buffer is filled
  RTS := rxBuf.Full()
  rxCounter := rxCounter + 1
  rxState := rxState
  switch( rxState ) {
    is( sRxReset ) {
      RTS := False
      rxBuf.Clear()
      rxState := sRxIdle
    }
    is( sRxIdle ) {
      rxCounter := 0
      when( RXD === False ) {
        rxState := sRxStart
      }
    }
    is( sRxStart ) {
      when( B( rxCounter ) === baudRate ) {
        rxCounter := 0
        rxState := sRxD0
      }
    }
    is( sRxD0 ) {
      when( B( rxCounter ) === 1 ) {
        rxData( 0 ) := RXD
      }
      when( B( rxCounter ) === baudRate ) {
        rxCounter := 0
        rxState := sRxD1
      }
    }
    is( sRxD1 ) {
      when( B( rxCounter ) === 1 ) {
        rxData( 1 ) := RXD
      }
      when( B( rxCounter ) === baudRate ) {
        rxCounter := 0
        rxState := sRxD2
      }
    }
    is( sRxD2 ) {
      when( B( rxCounter ) === 1 ) {
        rxData( 2 ) := RXD
      }
      when( B( rxCounter ) === baudRate ) {
        rxCounter := 0
        rxState := sRxD3
      }
    }
    is( sRxD3 ) {
      when( B( rxCounter ) === 1 ) {
        rxData( 3 ) := RXD
      }
      when( B( rxCounter ) === baudRate ) {
        rxCounter := 0
        rxState := sRxD4
      }
    }
    is( sRxD4 ) {
      when( B( rxCounter ) === 1 ) {
        rxData( 4 ) := RXD
      }
      when( B( rxCounter ) === baudRate ) {
        rxCounter := 0
        rxState := sRxD5
      }
    }
    is( sRxD5 ) {
      when( B( rxCounter ) === 1 ) {
        rxData( 5 ) := RXD
      }
      when( B( rxCounter ) === baudRate ) {
        rxCounter := 0
        rxState := sRxD6
      }
    }
    is( sRxD6 ) {
      when( B( rxCounter ) === 1 ) {
        rxData( 6 ) := RXD
      }
      when( B( rxCounter ) === baudRate ) {
        rxCounter := 0
        rxState := sRxD7
      }
    }
    is( sRxD7 ) {
      when( B( rxCounter ) === 1 ) {
        rxData( 7 ) := RXD
      }
      when( B( rxCounter ) === baudRate ) {
        rxCounter := 0
        rxState := sRxP0
      }
    }
    is( sRxP0 ) {
      when( B( rxCounter ) === 1 ) {
        rxBuf.Push( rxData )
      }
      when( B( rxCounter ) === baudRate ) {
        rxCounter := 0
        rxState := sRxStop
      }
    }
    is( sRxStop ) {
      when( B( rxCounter ) === baudRate ) {
        rxCounter := 0
        rxState := sRxIdle
      }
    }
  }

  //TX State Machine

  val txState = Reg( UartTxState() )
  txState init ( sTxReset)

  val txCounter = Reg( UInt( 32 bits ) )
  txCounter init ( 0)

  val txData = Reg( Bits( 8 bits ) )

  TXD := True
  txCounter := txCounter + 1
  txState := txState
  switch( txState ) {
    is( sTxReset ) {
      txBuf.Clear()
      txState := sTxIdle
    }
    is( sTxIdle ) {
      txCounter := 0
      when( CTS && ~txBuf.Empty() ) {
        txData := txBuf.Pull()
        txState := sTxStart
      }
    }
    is( sTxStart ) {
      TXD := False
      when( B( txCounter ) === baudRate ) {
        txCounter := 0
        txState := sTxD0
      }
    }
    is( sTxD0 ) {
      TXD := txData( 0 )
      when( B( txCounter ) === baudRate ) {
        txCounter := 0
        txState := sTxD1
      }
    }
    is( sTxD1 ) {
      TXD := txData( 1 )
      when( B( txCounter ) === baudRate ) {
        txCounter := 0
        txState := sTxD2
      }
    }
    is( sTxD2 ) {
      TXD := txData( 2 )
      when( B( txCounter ) === baudRate ) {
        txCounter := 0
        txState := sTxD3
      }
    }
    is( sTxD3 ) {
      TXD := txData( 3 )
      when( B( txCounter ) === baudRate ) {
        txCounter := 0
        txState := sTxD4
      }
    }
    is( sTxD4 ) {
      TXD := txData( 4 )
      when( B( txCounter ) === baudRate ) {
        txCounter := 0
        txState := sTxD5
      }
    }
    is( sTxD5 ) {
      TXD := txData( 5 )
      when( B( txCounter ) === baudRate ) {
        txCounter := 0
        txState := sTxD6
      }
    }
    is( sTxD6 ) {
      TXD := txData( 6 )
      when( B( txCounter ) === baudRate ) {
        txCounter := 0
        txState := sTxD7
      }
    }
    is( sTxD7 ) {
      TXD := txData( 7 )
      when( B( txCounter ) === baudRate ) {
        txCounter := 0
        txState := sTxP0
      }
    }
    is( sTxP0 ) {
      TXD := txData.xorR
      when( B( txCounter ) === baudRate ) {
        txCounter := 0
        txState := sTxStop
      }
    }
    is( sTxStop ) {
      TXD := True
      when( B( txCounter ) === baudRate ) {
        txCounter := 0
        txState := sTxIdle
      }
    }
  }
}

//Define a custom SpinalHDL configuration with synchronous reset instead of the default asynchronous one. This configuration can be resued everywhere
object uart_config
    extends SpinalConfig(
      defaultConfigForClockDomains = ClockDomainConfig( resetKind = SYNC ),
      targetDirectory              = "../../../output"
    )

//Generate the riscv's Verilog using the above custom configuration.
object uart_top {
  def main( args: Array[String] ) {
    uart_config.generateVerilog( new uart_top )
  }
}
