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

package soc_system

import spinal.core._
import spinal.lib._


//Hardware definition
class soc_system extends BlackBox {
  val clk_clk                                = in  (Bool)
  val ddr3_clk_clk                           = out (Bool)
  val memory_mem_a                           = out (Bits(15 bits))
  val memory_mem_ba                          = out (Bits(3 bits))
  val memory_mem_ck                          = out (Bits(1 bits))
  val memory_mem_ck_n                        = out (Bits(1 bits))
  val memory_mem_cke                         = out (Bits(1 bits))
  val memory_mem_cs_n                        = out (Bits(1 bits))
  val memory_mem_ras_n                       = out (Bits(1 bits))
  val memory_mem_cas_n                       = out (Bits(1 bits))
  val memory_mem_we_n                        = out (Bits(1 bits))
  val memory_mem_reset_n                     = out (Bits(1 bits))
  val memory_mem_dq                          = inout(Analog(Bits(32 bits))) 
  val memory_mem_dqs                         = inout(Analog(Bits(4 bits)))  
  val memory_mem_dqs_n                       = inout(Analog(Bits(4 bits)))  
  val memory_mem_odt                         = out (Bits(1 bits))
  val memory_mem_dm                          = out (Bits(4 bits))
  val memory_oct_rzqin                       = in  (Bits(1 bits))
  val ddr3_hps_f2h_sdram0_clock_clk          = in  (Bool)
  val ddr3_hps_f2h_sdram0_data_address       = in  (Bits(26 bits))
  val ddr3_hps_f2h_sdram0_data_read          = in  (Bits(1 bits))
  val ddr3_hps_f2h_sdram0_data_readdata      = out (Bits(128 bits))
  val ddr3_hps_f2h_sdram0_data_write         = in  (Bits(1 bits))
  val ddr3_hps_f2h_sdram0_data_writedata     = in  (Bits(128 bits))
  val ddr3_hps_f2h_sdram0_data_readdatavalid = out (Bits(1 bits))
  val ddr3_hps_f2h_sdram0_data_waitrequest   = out (Bits(1 bits))
  val ddr3_hps_f2h_sdram0_data_byteenable    = in  (Bits(16 bits))
  val ddr3_hps_f2h_sdram0_data_burstcount    = in  (Bits(9 bits))

  val DDR3_Domain = ClockDomain(
    clock  = ddr3_hps_f2h_sdram0_clock_clk//,
    //reset  = ARDUINO_RESET_N,
    //config = ClockDomainConfig(
    //  clockEdge        = RISING,
    //  resetKind        = ASYNC,
    //  resetActiveLevel = LOW
    //)
  )
  mapCurrentClockDomain(clock=clk_clk)

}


