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
  val riscvBus = slave(wbBundle())

  val memBus   = master(wbBundle())
  val ddr3Bus  = master(wbBundle())

  memBus.req := Reg(riscvBus.req)
  ddr3Bus.req := Reg(riscvBus.req)

  memBus.req.cyc  init(0)
  ddr3Bus.req.cyc init(0)
  memBus.req.stb  init(0)
  ddr3Bus.req.stb init(0)
}


