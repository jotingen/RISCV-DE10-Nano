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

package riscv

import wishbone._

import spinal.core._
import spinal.lib._


//Hardware definition
class riscv_top extends Component {
  val busInst = master(wbBundle())
  val busData = master(wbBundle())

  val busInstReq = wbReqBundle() 
  busInstReq.cyc := ~busInst.req.cyc
  busInst.req := RegNext(busInst.req)
  busInst.req.cyc init(0)
}
