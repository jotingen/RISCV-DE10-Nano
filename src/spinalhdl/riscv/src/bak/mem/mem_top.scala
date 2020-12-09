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
class mem_top extends Component {
  val busInst = slave(WishBone())
  val busData = slave(WishBone())

  val busInstStall = Reg(Bool) 
  busInstStall init(False)

  val busInstRsp = Reg(WishBoneRsp()) 
  busInstRsp.ack   init(False)
  busInstRsp.err   init(False)
  busInstRsp.rty   init(False)
  busInstRsp.data  init(0)
  busInstRsp.tga   init(0)
  busInstRsp.tgd   init(0)
  busInstRsp.tgc   init(0)

  val busDataStall = Reg(Bool) 
  busDataStall init(False)

  val busDataRsp = Reg(WishBoneRsp()) 
  busDataRsp.ack   init(False)
  busDataRsp.err   init(False)
  busDataRsp.rty   init(False)
  busDataRsp.data  init(0)
  busDataRsp.tga   init(0)
  busDataRsp.tgd   init(0)
  busDataRsp.tgc   init(0)

  val mem = Array.fill(4)(new mem_sector)
  for(memSectorNdx <- 0 until 4) {
    mem(memSectorNdx).io.w0en   <> (  busData.req.cyc 
                                & busData.req.stb 
                                & busData.req.we
                                & busData.req.sel(memSectorNdx))
    mem(memSectorNdx).io.w0adr  <>   busData.req.adr(15 downto 0)
    mem(memSectorNdx).io.w0data <>   busData.req.data(memSectorNdx*8+7 downto memSectorNdx*8+0) 

    mem(memSectorNdx).io.r0en   <> (  busInst.req.cyc 
                                & busInst.req.stb 
                                & ~busInst.req.we
                                & busInst.req.sel(memSectorNdx))
    mem(memSectorNdx).io.r0adr  <>   busInst.req.adr(15 downto 0)
    busInstRsp.data(memSectorNdx*8+7 downto memSectorNdx*8+0) := mem(memSectorNdx).io.r0data 

    mem(memSectorNdx).io.r1en   <> (  busData.req.cyc 
                                & busData.req.stb 
                                & ~busData.req.we
                                & busData.req.sel(memSectorNdx))
    mem(memSectorNdx).io.r1adr  <>   busData.req.adr(15 downto 0)
    busDataRsp.data(memSectorNdx*8+7 downto memSectorNdx*8+0) := mem(memSectorNdx).io.r0data 
  }
  busInst.stall <> busInstStall
  busInst.rsp   <> busInstRsp
  busData.stall <> busDataStall
  busData.rsp   <> busDataRsp
}

class mem_sector extends Component {
  val io = new Bundle {
    val w0en   = in  Bool
    val w0adr  = in  UInt(16 bits)
    val w0data = in  Bits(8 bits)
    val r0en   = in  Bool
    val r0adr  = in  UInt(16 bits)
    val r0data = out Bits(8 bits)
    val r1en   = in  Bool
    val r1adr  = in  UInt(16 bits)
    val r1data = out Bits(8 bits)
  }

  val mem = Mem(Bits(8 bits),wordCount = 65526)

    mem.write(
      enable  = io.w0en,
      address = io.w0adr,
      data    = io.w0data
    )

    io.r0data := mem.readSync(
      enable  = io.r0en,
      address = io.r0adr
    )
    io.r1data := mem.readSync(
      enable  = io.r1en,
      address = io.r1adr
    )
}
