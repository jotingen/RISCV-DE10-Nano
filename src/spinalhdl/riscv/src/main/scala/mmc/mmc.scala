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

package mmc

import wishbone._

import spinal.core._
import spinal.lib._


//Hardware definition
class mmc_top extends Component {
  val riscvBus = slave(WishBone())

  val memBus  = master(WishBone())
  val ledBus  = master(WishBone())

  memBus.req <> riscvBus.req
  ledBus.req <> riscvBus.req

  riscvBus.stall := memBus.stall |
                    ledBus.stall

  riscvBus.rsp.ack   := False
  riscvBus.rsp.err   := False
  riscvBus.rsp.rty   := False
  riscvBus.rsp.data  := 0
  riscvBus.rsp.tga   := 0
  riscvBus.rsp.tgd   := 0
  riscvBus.rsp.tgc   := 0
  when (memBus.rsp.ack) {
    riscvBus.rsp := memBus.rsp
  }
  when (ledBus.rsp.ack ) {
    riscvBus.rsp := ledBus.rsp
  }

}


