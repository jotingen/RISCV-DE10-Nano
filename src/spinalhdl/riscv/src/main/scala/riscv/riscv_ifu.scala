package riscv

import wishbone._

import spinal.core._
import spinal.lib._

case class Inst() extends Bundle {
  val Vld        = Bool
  val Adr        = UInt(32 bits)
  val AdrNext    = UInt(32 bits)
  val Data       = Bits(32 bits)
}

case class InstBuffEntry() extends Bundle {
  val Vld   = Bool
  val Adr   = UInt(32 bits)
  val Data  = Bits(32 bits)
}

case class InstBuff(bufferSize : Int) extends Bundle {
  val wrNdx = Reg(UInt(log2Up(bufferSize) bits))
  val wrDataNdx = Reg(UInt(log2Up(bufferSize) bits))
  val rdNdx = Reg(UInt(log2Up(bufferSize) bits))
  val buffer = Vec(Reg(InstBuffEntry()), bufferSize)

  wrNdx     init(0)
  wrDataNdx init(0)
  rdNdx     init(0)
  for(entry <- buffer) {
    entry.Vld init(False)
  }

  def Clear() : Unit = {
    wrDataNdx := wrNdx
    rdNdx := wrNdx
    for(entry <- buffer) {
      entry.Vld := False
    }
  }
  def PushAdr(adr: UInt) : Unit = {
    buffer(wrNdx).Adr := adr
    wrNdx := wrNdx + 1
  }
  def PushData(data: Bits) : Unit = {
    buffer(wrDataNdx).Vld := True
    buffer(wrDataNdx).Data := data
    wrDataNdx := wrDataNdx + 1
  }
  def Pull() : Inst = {
    val inst = Inst()
    inst.Vld          := buffer(rdNdx).Vld
    inst.Adr          := buffer(rdNdx).Adr
    inst.Data         := buffer(rdNdx).Data
    inst.AdrNext      := buffer(rdNdx+1).Adr //Buffer always being filled, this should have been written
    buffer(rdNdx).Vld := False
    rdNdx := rdNdx + 1
    return inst
  }

  def Empty() : Bool = ~buffer(rdNdx).Vld
  def Full()  : Bool =  buffer(wrNdx).Vld
}

//Hardware definition
class riscv_ifu(bufferSize : Int) extends Component {
  val misfetch    = in(Bool)
  val misfetchAdr = in(UInt(32 bits))
  val freeze      = in(Bool)
  val inst    = out(Reg(Inst()))
  val busInst = master(WishBone())

  val busInstReq = Reg(WishBoneReq()) 
  busInst.req <> busInstReq

  busInstReq.cyc  init(False)
  busInstReq.stb  init(False)
  busInstReq.we   init(False)
  busInstReq.adr  init(0)
  busInstReq.sel  init(0)
  busInstReq.data init(0)
  busInstReq.tga  init(0)
  busInstReq.tgd  init(0)
  busInstReq.tgc  init(0)

  val token = Reg(UInt(4 bits))
  token init(0)

  val PC = Reg(UInt(32 bits))
  PC init(0)

  val buf = InstBuff(bufferSize)

  when( ~busInst.stall 
      & ~buf.Full()) {
    busInstReq.cyc  := True
    busInstReq.stb  := True
    busInstReq.we   := False
    busInstReq.sel  := B"4'hF"
    busInstReq.data := 0
    busInstReq.tga  := 0
    busInstReq.tgd  := 0
    when(misfetch) {
      busInstReq.adr  := misfetchAdr
      busInstReq.tgc  := B(token + 1)
      token := token + 1
      buf.PushAdr(misfetchAdr)
      PC := misfetchAdr + 4
    } otherwise {
      busInstReq.adr  := PC
      busInstReq.tgc  := B(token)
      buf.PushAdr(PC)
      PC := PC + 4
    }
  } otherwise {
    when(misfetch) {
      token := token + 1
      PC := misfetchAdr
    }
  } 

  when(busInst.stall) {
    busInst.req.cyc  := False
    busInst.req.stb  := False
  }

  when( busInst.rsp.ack && 
        (U(busInst.rsp.tgc) === token) &&
        ~misfetch ) {
    buf.PushData(busInst.rsp.data)
  }

  when(misfetch) {
    inst.Vld := False
    buf.Clear() 
  } elsewhen(freeze) {
    inst := inst 
  } elsewhen(~buf.Empty()) {
    inst := buf.Pull() 
  } otherwise {
    inst.Vld := False
  }

}
