package led

import wishbone._

import spinal.core._
import spinal.lib._

case class riscv_config(
    busWishBoneConfig: WishBoneConfig
)

class led_top extends Component {
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

  val LED = out( Reg( Bits( 8 bits ) ) )
  val bus = slave( WishBone( config.busWishBoneConfig ) )

  val busReq = WishBoneReq( config.busWishBoneConfig )
  busReq := bus.req.ReverseEndian() //Little to Big Endian

  val busRsp = Reg( WishBoneRsp( config.busWishBoneConfig ) )
  bus.rsp := busRsp.ReverseEndian() //Big to Little Endian
  busRsp.ack init ( False)

  val busStall = Reg( Bool )
  bus.stall := busStall
  busStall init ( False)

  LED init ( B"xAA")
  LED := LED

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
        when( busReq.we ) {
          when( busReq.sel( 0 ) ) {
            LED := busReq.data( 7 downto 0 )
          }
        } otherwise {
          when( busReq.sel( 0 ) ) {
            busRsp.data( 7 downto 0 ) := LED
          }
        }
      }
    }
  }

  val asserts = new ledAsserts();
}

class ledAsserts() extends Component {
  import spinal.core.GenerationFlags._
  import spinal.core.Formal._

  //Signal toggles after initial reset, nothing matters before the first reset
  var reset_seen = Reg( Bool )
  reset_seen := reset_seen
  when( clockDomain.isResetActive ) {
    reset_seen := True
  }

  GenerationFlags.formal {
    when( reset_seen ) {}
  }

}

//Define a custom SpinalHDL configuration with synchronous reset instead of the default asynchronous one. This configuration can be resued everywhere
object led_config
    extends SpinalConfig(
      defaultConfigForClockDomains = ClockDomainConfig(
        resetKind        = SYNC,
        resetActiveLevel = HIGH
      ),
      targetDirectory              = "../../../output"
    )

//Generate the riscv's Verilog using the above custom configuration.
object led_top {
  def main( args: Array[String] ) {
    led_config.includeFormal.generateVerilog( new led_top )
    led_config.includeFormal.generateSystemVerilog( new led_formal )
  }
}
