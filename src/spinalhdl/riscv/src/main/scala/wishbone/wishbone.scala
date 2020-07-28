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

case class wbReqBundle() extends Bundle {
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

case class wbRspBundle() extends Bundle {
  val stall = Bool
  val ack   = Bool
  val err   = Bool
  val rty   = Bool
  val data  = Bits(32 bits)
  val tga   = Bits(1 bits)
  val tgd   = Bits(1 bits)
  val tgc   = Bits(4 bits)
}

case class wbBundle() extends Bundle with IMasterSlave {
  val req = wbReqBundle()
  val rsp = wbRspBundle()
  override def asMaster(): Unit = {
    out(req)
    in(rsp)
  }
}

