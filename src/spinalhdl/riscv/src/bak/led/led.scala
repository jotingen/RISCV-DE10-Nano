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

package mem

import wishbone._

import spinal.core._
import spinal.lib._


//Hardware definition
class led_top extends Component {
  val bus = slave(WishBone())
  val LED = out  Bits(8 bits)

  LED := RegNext(LED)
  LED init(0)

  when(bus.req.cyc 
       & bus.req.stb
       & bus.req.we) {
    LED := bus.req.data(7 downto 0)
       }

  bus.stall       := False
  bus.rsp.ack     := False
  bus.rsp.err     := False
  bus.rsp.rty     := False
  bus.rsp.data    := 0
  bus.rsp.tga     := 0
  bus.rsp.tgd     := 0
  bus.rsp.tgc     := 0
  when(  bus.req.cyc 
       & bus.req.stb) {
    bus.rsp.ack := True
  }

}
