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

  val busInstReq = Reg(wbReqBundle()) 
  busInstReq.cyc  init(False)
  busInstReq.stb  init(False)
  busInstReq.we   init(False)
  busInstReq.adr  init(0)
  busInstReq.sel  init(0)
  busInstReq.data init(0)
  busInstReq.tga  init(0)
  busInstReq.tgd  init(0)
  busInstReq.tgc  init(0)
  busInstReq.cyc := ~busInstReq.cyc
  busInstReq.stb := ~busInstReq.cyc
  busInstReq.adr := U(busInst.rsp.data)


  busInst.req <> busInstReq

  val busDataReq = Reg(wbReqBundle()) 
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
