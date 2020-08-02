/*
 * SpinalHDL
 * Copyright (c) Dolu, All rights reserved.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3.0 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library.
 */

package wishbone

import spinal.core._
import spinal.lib._

case class WishBoneReq() extends Bundle {
  val cyc  = Bool
  val stb  = Bool
  val we   = Bool
  val adr  = UInt(32 bits)
  val sel  = Bits(4 bits)
  val data = Bits(32 bits)
  val tga  = Bits(1 bits)
  val tgd  = Bits(1 bits)
  val tgc  = Bits(4 bits)

}

case class WishBoneRsp() extends Bundle {
  val ack   = Bool
  val err   = Bool
  val rty   = Bool
  val data  = Bits(32 bits)
  val tga   = Bits(1 bits)
  val tgd   = Bits(1 bits)
  val tgc   = Bits(4 bits)
}

case class WishBone() extends Bundle with IMasterSlave {
  val req   = WishBoneReq()
  val stall = Bool
  val rsp   = WishBoneRsp()
  override def asMaster(): Unit = {
    out(req)
    in(stall)
    in(rsp)
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

