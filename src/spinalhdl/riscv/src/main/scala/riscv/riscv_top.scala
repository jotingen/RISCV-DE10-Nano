package riscv

import wishbone._

import spinal.core._
import spinal.lib._


//Hardware definition
class riscv_top extends Component {
  val busInst = master(WishBone())
  val busData = master(WishBone())

  val ifu = new riscv_ifu(32)
  val idu = new riscv_idu()
  val exu = new riscv_exu()

  ifu.freeze  <> exu.freeze
  ifu.busInst <> busInst

  idu.freeze  <> exu.freeze
  idu.inst <> ifu.inst

  exu.instDecoded <> idu.instDecoded

  val busDataReq = Reg(WishBoneReq()) 
  busDataReq.cyc  init(False)
  busDataReq.stb  init(False)
  busDataReq.we   init(False)
  busDataReq.adr  init(0)
  busDataReq.sel  init(0)
  busDataReq.data init(0)
  busDataReq.tga  init(0)
  busDataReq.tgd  init(0)
  busDataReq.tgc  init(0)
  busDataReq.cyc := ~busDataReq.cyc
  busDataReq.stb := ~busDataReq.cyc
  busDataReq.adr := U(busData.rsp.data)
  busData.req <> busDataReq
}

//Define a custom SpinalHDL configuration with synchronous reset instead of the default asynchronous one. This configuration can be resued everywhere
object riscv_config extends SpinalConfig(defaultConfigForClockDomains = ClockDomainConfig(resetKind = SYNC),targetDirectory="../../../output")

//Generate the riscv's Verilog using the above custom configuration.
object riscv_top {
  def main(args: Array[String]) {
    riscv_config.generateVerilog(new riscv_top)
  }
}

