package led

import wishbone._

import spinal.core._
import spinal.lib._

class led_formal extends Component {
  import spinal.core.GenerationFlags._
  import spinal.core.Formal._

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

  val LED = out( Bits( 8 bits ) )
  val bus = slave( WishBone( config.busWishBoneConfig ) )

  val led = new led_top()
  led.LED <> LED
  led.bus <> bus

  val assumesWBSlave = new WishBoneSlaveAssumes( config.busWishBoneConfig );
  assumesWBSlave.req := bus.req
  assumesWBSlave.stall := bus.stall
  assumesWBSlave.rsp := bus.rsp

  GenerationFlags.formal {
    when( initstate() ) {
      assume( clockDomain.isResetActive )
    }
  }
}

////Generate the riscv's Verilog using the above custom configuration.
//object led_formal {
//  def main( args: Array[String] ) {
//    led_config.includeFormal.generateSystemVerilog( new led_formal )
//  }
//}
