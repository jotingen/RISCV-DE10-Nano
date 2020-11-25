package riscv

import rvfimon._
import wishbone._

import spinal.core._
import spinal.lib._

case class riscv_config( bufferSize: Int, oneShotInst: Boolean )

//Hardware definition
class riscv_top extends Component {
  val busInst = master( WishBone() )
  val busData = master( WishBone() )

  val rvfi = out( Vec( RvfiMon(), 6 ) )

  val config = riscv_config( bufferSize = 32, oneShotInst = true )

  val ifu = new riscv_ifu( config )
  val idu = new riscv_idu()
  val exu = new riscv_exu()

  val idle = Bool()
  idle := ~ifu.inst.Vld &
    ~idu.instDecoded.Vld &
    exu.idle

  ifu.misfetch <> exu.misfetch
  ifu.misfetchAdr <> exu.misfetchAdr
  ifu.freeze <> exu.freeze
  ifu.busInst <> busInst
  ifu.idle <> idle

  idu.misfetch <> exu.misfetch
  idu.freeze <> exu.freeze
  idu.inst <> ifu.inst

  exu.instDecoded <> idu.instDecoded
  exu.busData <> busData
  exu.rvfi <> rvfi

}

//Define a custom SpinalHDL configuration with synchronous reset instead of the default asynchronous one. This configuration can be resued everywhere
object riscv_config
    extends SpinalConfig(
      defaultConfigForClockDomains = ClockDomainConfig( resetKind = SYNC ),
      targetDirectory              = "../../../output"
    )

//Generate the riscv's Verilog using the above custom configuration.
object riscv_top {
  def main( args: Array[String] ) {
    riscv_config.generateVerilog( new riscv_top )
  }
}
