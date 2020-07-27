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

package de10nano

import wishbone._
import riscv._
import mem._
import mmc._

import spinal.core._
import spinal.lib._

case class TriState[T <: Data](dataType : HardType[T]) extends Bundle with IMasterSlave{
    val read,write : T = dataType()
      val writeEnable = Bool

        override def asMaster(): Unit = {
              out(write,writeEnable)
                  in(read)
                    }
}

//Hardware definition
class de10nano extends Component {

  //////////// CLOCK //////////
  var FPGA_CLK1_50 = in  Bool
  var FPGA_CLK2_50 = in  Bool
  var FPGA_CLK3_50 = in  Bool

  //////////// LED //////////
  val LED = out  Bits(8 bits)

  //////////// HPS //////////
  val HPS_DDR3_ADDR    = out Bits(15 bits)
  val HPS_DDR3_BA      = out Bits(3 bits)
  val HPS_DDR3_CAS_N   = out Bits(1 bits)
  val HPS_DDR3_CKE     = out Bits(1 bits)
  val HPS_DDR3_CK_N    = out Bits(1 bits)
  val HPS_DDR3_CK_P    = out Bits(1 bits)
  val HPS_DDR3_CS_N    = out Bits(1 bits)
  val HPS_DDR3_DM      = out Bits(4 bits)
  val HPS_DDR3_DQ      = inout(Analog(Bits(32 bits)))
  val HPS_DDR3_DQS_N   = inout(Analog(Bits(4 bits)))
  val HPS_DDR3_DQS_P   = inout(Analog(Bits(4 bits)))
  val HPS_DDR3_ODT     = out Bits(1 bits)
  val HPS_DDR3_RAS_N   = out Bits(1 bits)
  val HPS_DDR3_RESET_N = out Bits(1 bits)
  val HPS_DDR3_RZQ     = in  Bits(1 bits)
  val HPS_DDR3_WE_N    = out Bits(1 bits)

  //////////// KEY //////////
  val KEY = in  Bits(2 bits)

  //////////// SW //////////
  val SW  = in  Bits(4 bits)

  //////////// ADC //////////
  val ADC_CONVST = out Bits(1 bits)
  val ADC_SCK    = out Bits(1 bits)
  val ADC_SDI    = out Bits(1 bits)
  val ADC_SDO    = in  Bits(1 bits)

  //////////// GPIO_0 GPIO connect to GPIO Default //////////
  val GPIO_0_00 = inout(Analog(Bits(1 bits)))
  val GPIO_0_01 = inout(Analog(Bits(1 bits)))
  val GPIO_0_02 = inout(Analog(Bits(1 bits)))
  val GPIO_0_03 = inout(Analog(Bits(1 bits)))
  val GPIO_0_04 = inout(Analog(Bits(1 bits)))
  val GPIO_0_05 = inout(Analog(Bits(1 bits)))
  val GPIO_0_06 = inout(Analog(Bits(1 bits)))
  val GPIO_0_07 = inout(Analog(Bits(1 bits)))
  val GPIO_0_08 = inout(Analog(Bits(1 bits)))
  val GPIO_0_09 = inout(Analog(Bits(1 bits)))
  val GPIO_0_10 = inout(Analog(Bits(1 bits)))
  val GPIO_0_11 = inout(Analog(Bits(1 bits)))
  val GPIO_0_12 = inout(Analog(Bits(1 bits)))
  val GPIO_0_13 = inout(Analog(Bits(1 bits)))
  val GPIO_0_14 = inout(Analog(Bits(1 bits)))
  val GPIO_0_15 = inout(Analog(Bits(1 bits)))
  val GPIO_0_16 = inout(Analog(Bits(1 bits)))
  val GPIO_0_17 = inout(Analog(Bits(1 bits)))
  val GPIO_0_18 = inout(Analog(Bits(1 bits)))
  val GPIO_0_19 = inout(Analog(Bits(1 bits)))
  val GPIO_0_20 = inout(Analog(Bits(1 bits)))
  val GPIO_0_21 = inout(Analog(Bits(1 bits)))
  val GPIO_0_22 = inout(Analog(Bits(1 bits)))
  val GPIO_0_23 = inout(Analog(Bits(1 bits)))
  val GPIO_0_24 = inout(Analog(Bits(1 bits)))
  val GPIO_0_25 = inout(Analog(Bits(1 bits)))
  val GPIO_0_26 = inout(Analog(Bits(1 bits)))
  val GPIO_0_27 = inout(Analog(Bits(1 bits)))
  val GPIO_0_28 = inout(Analog(Bits(1 bits)))
  val GPIO_0_29 = inout(Analog(Bits(1 bits)))
  val GPIO_0_30 = inout(Analog(Bits(1 bits)))
  val GPIO_0_31 = inout(Analog(Bits(1 bits)))
  val GPIO_0_32 = inout(Analog(Bits(1 bits)))
  val GPIO_0_33 = inout(Analog(Bits(1 bits)))
  val GPIO_0_34 = inout(Analog(Bits(1 bits)))
  val GPIO_0_35 = inout(Analog(Bits(1 bits)))

  //////////// GPIO_1 GPIO connect to GPIO Default //////////
  val GPIO_1_00 = inout(Analog(Bits(1 bits)))
  val GPIO_1_01 = inout(Analog(Bits(1 bits)))
  val GPIO_1_02 = inout(Analog(Bits(1 bits)))
  val GPIO_1_03 = inout(Analog(Bits(1 bits)))
  val GPIO_1_04 = inout(Analog(Bits(1 bits)))
  val GPIO_1_05 = inout(Analog(Bits(1 bits)))
  val GPIO_1_06 = inout(Analog(Bits(1 bits)))
  val GPIO_1_07 = inout(Analog(Bits(1 bits)))
  val GPIO_1_08 = inout(Analog(Bits(1 bits)))
  val GPIO_1_09 = inout(Analog(Bits(1 bits)))
  val GPIO_1_10 = inout(Analog(Bits(1 bits)))
  val GPIO_1_11 = inout(Analog(Bits(1 bits)))
  val GPIO_1_12 = inout(Analog(Bits(1 bits)))
  val GPIO_1_13 = inout(Analog(Bits(1 bits)))
  val GPIO_1_14 = inout(Analog(Bits(1 bits)))
  val GPIO_1_15 = inout(Analog(Bits(1 bits)))
  val GPIO_1_16 = inout(Analog(Bits(1 bits)))
  val GPIO_1_17 = inout(Analog(Bits(1 bits)))
  val GPIO_1_18 = inout(Analog(Bits(1 bits)))
  val GPIO_1_19 = inout(Analog(Bits(1 bits)))
  val GPIO_1_20 = inout(Analog(Bits(1 bits)))
  val GPIO_1_21 = inout(Analog(Bits(1 bits)))
  val GPIO_1_22 = inout(Analog(Bits(1 bits)))
  val GPIO_1_23 = inout(Analog(Bits(1 bits)))
  val GPIO_1_24 = inout(Analog(Bits(1 bits)))
  val GPIO_1_25 = inout(Analog(Bits(1 bits)))
  val GPIO_1_26 = inout(Analog(Bits(1 bits)))
  val GPIO_1_27 = inout(Analog(Bits(1 bits)))
  val GPIO_1_28 = inout(Analog(Bits(1 bits)))
  val GPIO_1_29 = inout(Analog(Bits(1 bits)))
  val GPIO_1_30 = inout(Analog(Bits(1 bits)))
  val GPIO_1_31 = inout(Analog(Bits(1 bits)))
  val GPIO_1_32 = inout(Analog(Bits(1 bits)))
  val GPIO_1_33 = inout(Analog(Bits(1 bits)))
  val GPIO_1_34 = inout(Analog(Bits(1 bits)))
  val GPIO_1_35 = inout(Analog(Bits(1 bits)))

  //////////// ARDUINO //////////
  val ARDUINO_IO_00 = inout(Analog(Bits(1 bits)))
  val ARDUINO_IO_01 = inout(Analog(Bits(1 bits)))
  val ARDUINO_IO_02 = inout(Analog(Bits(1 bits)))
  val ARDUINO_IO_03 = inout(Analog(Bits(1 bits)))
  val ARDUINO_IO_04 = inout(Analog(Bits(1 bits)))
  val ARDUINO_IO_05 = inout(Analog(Bits(1 bits)))
  val ARDUINO_IO_06 = inout(Analog(Bits(1 bits)))
  val ARDUINO_IO_07 = inout(Analog(Bits(1 bits)))
  val ARDUINO_IO_08 = inout(Analog(Bits(1 bits)))
  val ARDUINO_IO_09 = inout(Analog(Bits(1 bits)))
  val ARDUINO_IO_10 = inout(Analog(Bits(1 bits)))
  val ARDUINO_IO_11 = inout(Analog(Bits(1 bits)))
  val ARDUINO_IO_12 = inout(Analog(Bits(1 bits)))
  val ARDUINO_IO_13 = inout(Analog(Bits(1 bits)))
  val ARDUINO_IO_14 = inout(Analog(Bits(1 bits)))
  val ARDUINO_IO_15 = inout(Analog(Bits(1 bits)))

  val ARDUINO_RESET_N = in  Bool

  //////////// HDMI //////////
  val HDMI_I2C_SCL = inout(Analog(Bits(1 bits)))
  val HDMI_I2C_SDA = inout(Analog(Bits(1 bits)))
  val HDMI_I2S     = inout(Analog(Bits(1 bits)))
  val HDMI_LRCLK   = inout(Analog(Bits(1 bits)))
  val HDMI_MCLK    = inout(Analog(Bits(1 bits)))
  val HDMI_SCLK    = inout(Analog(Bits(1 bits)))
  val HDMI_TX_CLK  = out Bits(1 bits)
  val HDMI_TX_DE   = out Bits(1 bits)
  val HDMI_TX_D    = out Bits(24 bits)
  val HDMI_TX_HS   = out Bits(1 bits)
  val HDMI_TX_INT  = in  Bits(1 bits)
  val HDMI_TX_VS   = out Bits(1 bits)

  val FPGA_Clk1_Domain = ClockDomain(
    clock  = FPGA_CLK1_50,
    reset  = ARDUINO_RESET_N,
    config = ClockDomainConfig(
      clockEdge        = RISING,
      resetKind        = ASYNC,
      resetActiveLevel = LOW
    )
  )
  val FPGA_Clk2_Domain = ClockDomain(
    clock  = FPGA_CLK2_50,
    reset  = ARDUINO_RESET_N,
    config = ClockDomainConfig(
      clockEdge        = RISING,
      resetKind        = ASYNC,
      resetActiveLevel = LOW
    )
  )
  val FPGA_Clk3_Domain = ClockDomain(
    clock  = FPGA_CLK3_50,
    reset  = ARDUINO_RESET_N,
    config = ClockDomainConfig(
      clockEdge        = RISING,
      resetKind        = ASYNC,
      resetActiveLevel = LOW
    )
  )

  val FPGA_Clk1_Area = new ClockingArea(FPGA_Clk1_Domain) {
    val riscv   = new riscv_top
    val mmcInst = new mmc_top
    val mmcData = new mmc_top
    val mem     = new mem_top
    val ddr3    = new mem_top

    riscv.busInst <> mmcInst.riscvBus
    riscv.busData <> mmcData.riscvBus

    mem.busInst <> mmcInst.memBus
    mem.busData <> mmcData.memBus

    ddr3.busInst <> mmcInst.ddr3Bus
    ddr3.busData <> mmcData.ddr3Bus

    //Temporarily drive
    LED := 0

    HPS_DDR3_ADDR    := 0
    HPS_DDR3_BA      := 0
    HPS_DDR3_CAS_N   := 0
    HPS_DDR3_CKE     := 0
    HPS_DDR3_CK_N    := 0
    HPS_DDR3_CK_P    := 0
    HPS_DDR3_CS_N    := 0
    HPS_DDR3_DM      := 0
    HPS_DDR3_ODT     := 0
    HPS_DDR3_RAS_N   := 0
    HPS_DDR3_RESET_N := 0
    HPS_DDR3_WE_N    := 0

    ADC_CONVST := 0
    ADC_SCK    := 0
    ADC_SDI    := 0

    HDMI_TX_CLK  := 0
    HDMI_TX_DE   := 0
    HDMI_TX_D    := 0
    HDMI_TX_HS   := 0
    HDMI_TX_VS   := 0
  }

}


//Define a custom SpinalHDL configuration with synchronous reset instead of the default asynchronous one. This configuration can be resued everywhere
object de10nano_config extends SpinalConfig(defaultConfigForClockDomains = ClockDomainConfig(resetKind = SYNC))

//Generate the riscv's Verilog using the above custom configuration.
object de10nano {
  def main(args: Array[String]) {
    de10nano_config.generateVerilog(new de10nano)
  }
}

