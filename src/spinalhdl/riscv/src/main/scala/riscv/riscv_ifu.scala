package riscv

import wishbone._

import spinal.core._
import spinal.lib._

case class Inst() extends Bundle {
  val Vld = Bool
  val Adr = UInt( 32 bits )
  val AdrNext = UInt( 32 bits )
  val Data = Bits( 32 bits )
}

case class InstBuffEntry() extends Bundle {
  val Vld = Bool
  val Adr = UInt( 32 bits )
  val Data = Bits( 16 bits )
}

case class InstBuff( config: riscv_config ) extends Bundle {
  val wrNdx = Reg( UInt( log2Up( config.bufferSize ) bits ) )
  val wrDataNdx = Reg( UInt( log2Up( config.bufferSize ) bits ) )
  val rdNdx = Reg( UInt( log2Up( config.bufferSize ) bits ) )
  val buffer = Vec( Reg( InstBuffEntry() ), config.bufferSize )

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
  def PushAdr( adr: UInt, number: UInt ): Unit = {
    when( number === U"2'd2" ) {
      buffer( wrNdx ).Adr := adr
      buffer( wrNdx + 1 ).Adr := adr + 2
      wrNdx := wrNdx + 2
    } otherwise {
      buffer( wrNdx ).Adr := adr
      wrNdx := wrNdx + 1
    }
  }
  def PushData( data: Bits ): Unit = {
    //Unaligned
    when( buffer( wrDataNdx ).Adr( 1 ) ) {
      buffer( wrDataNdx ).Vld := True
      buffer( wrDataNdx ).Data := data( 31 downto 16 )
      wrDataNdx := wrDataNdx + 1
      //Aligned
    } otherwise {
      buffer( wrDataNdx ).Vld := True
      buffer( wrDataNdx + 1 ).Vld := True
      buffer( wrDataNdx ).Data := data( 15 downto 0 )
      buffer( wrDataNdx + 1 ).Data := data( 31 downto 16 )
      wrDataNdx := wrDataNdx + 2
    }
  }
  def Pull(): Inst = {
    val inst = Inst()
    inst.Vld := buffer( rdNdx ).Vld
    inst.Adr := buffer( rdNdx ).Adr
    inst.Data( 15 downto 0 ) := buffer( rdNdx ).Data
    //Normal instruction
    when( buffer( rdNdx ).Data( 1 downto 0 ) === B"2'b11" ) {
      inst.Data( 31 downto 16 ) := buffer( rdNdx + 1 ).Data
      inst.AdrNext :=
        buffer(
          rdNdx + 2
        ).Adr //Buffer always being filled, this should have been written
      buffer( rdNdx ).Vld := False
      buffer( rdNdx + 1 ).Vld := False
      rdNdx := rdNdx + 2
      //Compressed instruction
    } otherwise {
      inst.Data( 31 downto 16 ) := 0
      inst.AdrNext :=
        buffer(
          rdNdx + 1
        ).Adr //Buffer always being filled, this should have been written
      buffer( rdNdx ).Vld := False
      rdNdx := rdNdx + 1
    }
    return inst
  }

  //Emtpy if first entry is invalid,
  //or if first entry is normal op and second entry invalid
  def Empty(): Bool =
    ~buffer( rdNdx ).Vld ||
      ( buffer( rdNdx ).Data( 1 downto 0 ) === B"2'b11" &&
        ~buffer( rdNdx + 1 ).Vld)
  def Full(): Bool =
    buffer( wrNdx ).Vld ||
      buffer( wrNdx + 1 ).Vld
}

//Hardware definition
class riscv_ifu( config: riscv_config ) extends Component {
  val misfetch = in( Bool )
  val misfetchAdr = in( UInt( 32 bits ) )
  val freeze = in( Bool )
  val idle = in( Bool )
  val inst = out( Reg( Inst() ) )
  val busInst = master( WishBone( config.busWishBoneConfig ) )

  val busInstReq = Reg( WishBoneReq( config.busWishBoneConfig ) )
  busInst.req <> busInstReq

  busInstReq.cyc init ( False)
  busInstReq.stb init ( False)
  busInstReq.we init ( False)
  busInstReq.adr init ( 0)
  busInstReq.sel init ( 0)
  busInstReq.data init ( 0)
  busInstReq.tga init ( 0)
  busInstReq.tgd init ( 0)
  busInstReq.tgc init ( 0)

  val token = Reg( UInt( 4 bits ) )
  token init ( 0)

  val PC = Reg( UInt( 32 bits ) )
  PC init ( 0)

  val buf = InstBuff( config )
  val bufFull = Bool
  bufFull := buf.Full()

  busInstReq.cyc := False
  busInstReq.stb := False
  when( ~busInst.stall & ~buf.Full() ) {
    busInstReq.cyc := True
    busInstReq.stb := True
    busInstReq.we := False
    busInstReq.data := 0
    busInstReq.tga := 0
    busInstReq.tgd := 0
    when( misfetch ) {
      busInstReq.adr := misfetchAdr
      busInstReq.tgc := B( token + 1 )
      token := token + 1
      //Unaligned
      when( misfetchAdr( 1 ) ) {
        busInstReq.sel := B"4'b0011"
        buf.PushAdr( misfetchAdr, U"2'd1" )
        PC := misfetchAdr + 2
        //Aligned
      } otherwise {
        busInstReq.sel := B"4'b1111"
        buf.PushAdr( misfetchAdr, U"2'd2" )
        PC := misfetchAdr + 4
      }
    } otherwise {
      busInstReq.adr := PC
      busInstReq.tgc := B( token )
      //Unaligned
      when( PC( 1 ) ) {
        busInstReq.sel := B"4'b0011"
        buf.PushAdr( PC, U"2'd1" )
        PC := PC + 2
        //Aligned
      } otherwise {
        busInstReq.sel := B"4'b1111"
        buf.PushAdr( PC, U"2'd2" )
        PC := PC + 4
      }
    }
  } otherwise {
    when( misfetch ) {
      token := token + 1
      PC := misfetchAdr
    }
  }

  when( busInst.stall ) {
    busInst.req.cyc := False
    busInst.req.stb := False
  }

  when( busInst.rsp.ack && ( U( busInst.rsp.tgc ) === token) && ~misfetch ) {
    //Convert incoming little endian data to big endian to work with
    buf.PushData( EndiannessSwap( busInst.rsp.data ) )
  }

  when( misfetch ) {
    inst.Vld := False
    buf.Clear()
  } elsewhen
    ( freeze) {
      inst := inst
    } elsewhen
    ( ~buf.Empty()) {
      if (config.oneShotInst) {
        when( ~idle ) {
          inst.Vld := False
        } otherwise {
          inst := buf.Pull()
        }
      } else {
        inst := buf.Pull()
      }
    } otherwise {
      inst.Vld := False
    }

}
