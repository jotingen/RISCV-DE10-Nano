package keys

import wishbone._

import spinal.core._
import spinal.lib._

case class riscv_config(
    busWishBoneConfig: WishBoneConfig
)

class keys_top extends Component {
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

  val KEY = in( Bits( 2 bits ) )
  val bus = slave( WishBone( config.busWishBoneConfig ) )

  val busReq = WishBoneReq( config.busWishBoneConfig )
  busReq := bus.req.ReverseEndian() //Little to Big Endian

  val busRsp = Reg( WishBoneRsp( config.busWishBoneConfig ) )
  bus.rsp := busRsp.ReverseEndian() //Big to Little Endian
  busRsp.ack init ( False)

  val busStall = Reg( Bool )
  bus.stall := busStall
  busStall init ( False)

  def debounce( in: Bool ): Bool = {
    val NDELAY = 1000000;

    val count = Reg( UInt( log2Up( NDELAY ) bits ) )
    val xnew = Reg( Bool )
    val out = Reg( Bool )

    xnew init ( in)
    out init ( in)
    count init ( 0)

    when( in =/= xnew ) {
      xnew := in
      count := 0
    } elsewhen ( count === NDELAY) {
      out := xnew
    } otherwise {
      count := count + 1
    }

    return out
  }

  val BUTTON = Reg( Bits( 2 bits ) )
  BUTTON( 1 ) := debounce( ~KEY( 1 ) )
  BUTTON( 0 ) := debounce( ~KEY( 0 ) )

  busStall := False

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
        when( busReq.we ) {} otherwise {
          when( busReq.sel( 0 ) ) {
            busRsp.data( 0 ) := BUTTON( 0 )
          }
        }
      }
      is( 1 ) {
        when( busReq.we ) {} otherwise {
          when( busReq.sel( 0 ) ) {
            busRsp.data( 0 ) := BUTTON( 1 )
          }
        }
      }
    }
  }

}

//Define a custom SpinalHDL configuration with synchronous reset instead of the default asynchronous one. This configuration can be resued everywhere
object keys_config
    extends SpinalConfig(
      defaultConfigForClockDomains = ClockDomainConfig( resetKind = SYNC ),
      targetDirectory              = "../../../output"
    )

//Generate the riscv's Verilog using the above custom configuration.
object keys_top {
  def main( args: Array[String] ) {
    keys_config.generateVerilog( new keys_top )
  }
}
