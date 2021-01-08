package wishbone

import spinal.core._
import spinal.lib._

case class WishBoneConfig(
    val adrWidth: Int,
    val selWidth: Int,
    val dataWidth: Int,
    val tgaWidth: Int,
    val tgdWidth: Int,
    val tgcWidth: Int
) {}

case class WishBoneReq( config: WishBoneConfig ) extends Bundle {
  val cyc = Bool
  val stb = Bool
  val we = Bool
  val adr = UInt( config.adrWidth bits )
  val sel = Bits( config.selWidth bits )
  val data = Bits( config.dataWidth bits )
  val tga = Bits( config.tgaWidth bits )
  val tgd = Bits( config.tgdWidth bits )
  val tgc = Bits( config.tgcWidth bits )
  def ReverseEndian(): WishBoneReq = {
    val req = WishBoneReq( config )
    req.cyc := this.cyc
    req.stb := this.stb
    req.we := this.we
    req.adr := this.adr
    req.sel := Reverse( this.sel )
    req.data := EndiannessSwap( this.data )
    req.tga := this.tga
    req.tgd := this.tgd
    req.tgc := this.tgc
    return req
  }
}

case class WishBoneRsp( config: WishBoneConfig ) extends Bundle {
  val ack = Bool
  val err = Bool
  val rty = Bool
  val data = Bits( config.dataWidth bits )
  val tga = Bits( config.tgaWidth bits )
  val tgd = Bits( config.tgdWidth bits )
  val tgc = Bits( config.tgcWidth bits )
  def ReverseEndian(): WishBoneRsp = {
    val rsp = WishBoneRsp( config )
    rsp.ack := this.ack
    rsp.err := this.err
    rsp.rty := this.rty
    rsp.data := EndiannessSwap( this.data )
    rsp.tga := this.tga
    rsp.tgd := this.tgd
    rsp.tgc := this.tgc
    return rsp
  }
}

case class WishBone( config: WishBoneConfig ) extends Bundle with IMasterSlave {
  val req = WishBoneReq( config )
  val stall = Bool
  val rsp = WishBoneRsp( config )
  override def asMaster(): Unit = {
    out( req )
    in( stall )
    in( rsp )
  }

  //Todo experiment with this
  //def SendReq(we: Bool, adr: Bits, data: Bits): Bool = {
  //  when(stall.stall) {
  //    req.cyc  := False
  //    req.stb  := False
  //    return False
  //  }
  //    req.cyc  := True
  //    req.stb  := True
  //    req.we   := we
  //    req.adr  := 0
  //    req.sel  := 0
  //    req.data := 0
  //    req.tga  := 0
  //    req.tgd  := 0
  //    req.tgc  := 0
  //    return True
  //}
}
