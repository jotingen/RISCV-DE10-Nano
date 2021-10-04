package core

import wishbone._
import rvfimon._
import riscv._
import led._
import keys._
import mem._
import uart._

import spinal.core._
import spinal.lib._
import javax.net.ssl.TrustManager

case class riscv_config(
    busWishBoneConfig: WishBoneConfig
)

case class TriState[T <: Data]( dataType: HardType[T] )
    extends Bundle
    with IMasterSlave {
  val read, write: T = dataType()
  val writeEnable = Bool

  override def asMaster(): Unit = {
    out( write, writeEnable )
    in( read )
  }
}

class core_top extends Component {
  val config = riscv_config(
    busWishBoneConfig = WishBoneConfig(
      adrWidth  = 32,
      selWidth  = 4,
      dataWidth = 32,
      tgaWidth  = 1,
      tgdWidth  = 1,
      tgcWidth  = 4
    )
  )

  val FPGA_CLK1_50 = in( Bool )
  val FPGA_CLK2_50 = in( Bool )
  val FPGA_CLK3_50 = in( Bool )

  val LED = out( Bits( 8 bits ) )

  //SOC System
  val DDR3_CLK = in( Bool )
  val ddr3_hps_f2h_sdram0_clock_clk = out( Bool )
  val ddr3_hps_f2h_sdram0_data_address = out( Bits( 26 bits ) )
  val ddr3_hps_f2h_sdram0_data_read = out( Bool )
  val ddr3_hps_f2h_sdram0_data_readdata = in( Bits( 128 bits ) )
  val ddr3_hps_f2h_sdram0_data_write = out( Bool )
  val ddr3_hps_f2h_sdram0_data_writedata = out( Bits( 128 bits ) )
  val ddr3_hps_f2h_sdram0_data_readdatavalid = in( Bool )
  val ddr3_hps_f2h_sdram0_data_waitrequest = in( Bool )
  val ddr3_hps_f2h_sdram0_data_byteenable = out( Bits( 16 bits ) )
  val ddr3_hps_f2h_sdram0_data_burstcount = out( Bits( 9 bits ) )

  val KEY = in( Bits( 2 bits ) )

  val SW = in( Bits( 4 bits ) )

  val ADC_CONVST = out( Bool )
  val ADC_SCK = out( Bool )
  val ADC_SDI = out( Bool )
  val ADC_SDO = in( Bool )

  val GPIO_0_00 = inout( Analog( Bool ) )
  val GPIO_0_01 = inout( Analog( Bool ) ) //UART GND
  val GPIO_0_02 = inout( Analog( Bool ) )
  val GPIO_0_03 = inout( Analog( Bool ) ) //UART RXD
  val GPIO_0_04 = inout( Analog( Bool ) )
  val GPIO_0_05 = inout( Analog( Bool ) ) //UART TXD
  val GPIO_0_06 = inout( Analog( Bool ) )
  val GPIO_0_07 = inout( Analog( Bool ) ) //UART CTS
  val GPIO_0_08 = inout( Analog( Bool ) )
  val GPIO_0_09 = inout( Analog( Bool ) ) //UART RTS
  val GPIO_0_10 = inout( Analog( Bool ) )
  val GPIO_0_11 = inout( Analog( Bool ) )
  val GPIO_0_12 = inout( Analog( Bool ) )
  val GPIO_0_13 = inout( Analog( Bool ) )
  val GPIO_0_14 = inout( Analog( Bool ) )
  val GPIO_0_15 = inout( Analog( Bool ) )
  val GPIO_0_16 = inout( Analog( Bool ) )
  val GPIO_0_17 = inout( Analog( Bool ) )
  val GPIO_0_18 = inout( Analog( Bool ) )
  val GPIO_0_19 = inout( Analog( Bool ) )
  val GPIO_0_20 = inout( Analog( Bool ) )
  val GPIO_0_21 = inout( Analog( Bool ) )
  val GPIO_0_22 = inout( Analog( Bool ) )
  val GPIO_0_23 = inout( Analog( Bool ) )
  val GPIO_0_24 = inout( Analog( Bool ) )
  val GPIO_0_25 = inout( Analog( Bool ) )
  val GPIO_0_26 = inout( Analog( Bool ) )
  val GPIO_0_27 = inout( Analog( Bool ) )
  val GPIO_0_28 = inout( Analog( Bool ) )
  val GPIO_0_29 = inout( Analog( Bool ) )
  val GPIO_0_30 = inout( Analog( Bool ) )
  val GPIO_0_31 = inout( Analog( Bool ) )
  val GPIO_0_32 = inout( Analog( Bool ) )
  val GPIO_0_33 = inout( Analog( Bool ) )
  val GPIO_0_34 = inout( Analog( Bool ) )
  val GPIO_0_35 = inout( Analog( Bool ) )

  val GPIO_1_00 = inout( Analog( Bool ) )
  val GPIO_1_01 = inout( Analog( Bool ) )
  val GPIO_1_02 = inout( Analog( Bool ) )
  val GPIO_1_03 = inout( Analog( Bool ) )
  val GPIO_1_04 = inout( Analog( Bool ) )
  val GPIO_1_05 = inout( Analog( Bool ) )
  val GPIO_1_06 = inout( Analog( Bool ) )
  val GPIO_1_07 = inout( Analog( Bool ) )
  val GPIO_1_08 = inout( Analog( Bool ) )
  val GPIO_1_09 = inout( Analog( Bool ) )
  val GPIO_1_10 = inout( Analog( Bool ) )
  val GPIO_1_11 = inout( Analog( Bool ) )
  val GPIO_1_12 = inout( Analog( Bool ) )
  val GPIO_1_13 = inout( Analog( Bool ) )
  val GPIO_1_14 = inout( Analog( Bool ) )
  val GPIO_1_15 = inout( Analog( Bool ) )
  val GPIO_1_16 = inout( Analog( Bool ) )
  val GPIO_1_17 = inout( Analog( Bool ) )
  val GPIO_1_18 = inout( Analog( Bool ) )
  val GPIO_1_19 = inout( Analog( Bool ) )
  val GPIO_1_20 = inout( Analog( Bool ) )
  val GPIO_1_21 = inout( Analog( Bool ) )
  val GPIO_1_22 = inout( Analog( Bool ) )
  val GPIO_1_23 = inout( Analog( Bool ) )
  val GPIO_1_24 = inout( Analog( Bool ) )
  val GPIO_1_25 = inout( Analog( Bool ) )
  val GPIO_1_26 = inout( Analog( Bool ) )
  val GPIO_1_27 = inout( Analog( Bool ) )
  val GPIO_1_28 = inout( Analog( Bool ) )
  val GPIO_1_29 = inout( Analog( Bool ) )
  val GPIO_1_30 = inout( Analog( Bool ) )
  val GPIO_1_31 = inout( Analog( Bool ) )
  val GPIO_1_32 = inout( Analog( Bool ) )
  val GPIO_1_33 = inout( Analog( Bool ) )
  val GPIO_1_34 = inout( Analog( Bool ) )
  val GPIO_1_35 = inout( Analog( Bool ) )

  val ARDUINO_IO_00 = inout( Analog( Bool ) )
  val ARDUINO_IO_01 = inout( Analog( Bool ) )
  val ARDUINO_IO_02 = inout( Analog( Bool ) )
  val ARDUINO_IO_03 = inout( Analog( Bool ) )
  val ARDUINO_IO_04 = inout( Analog( Bool ) )
  val ARDUINO_IO_05 = inout( Analog( Bool ) )
  val ARDUINO_IO_06 = inout( Analog( Bool ) )
  val ARDUINO_IO_07 = inout( Analog( Bool ) )
  val ARDUINO_IO_08 = inout( Analog( Bool ) )
  val ARDUINO_IO_09 = inout( Analog( Bool ) )
  val ARDUINO_IO_10 = inout( Analog( Bool ) )
  val ARDUINO_IO_11 = inout( Analog( Bool ) )
  val ARDUINO_IO_12 = inout( Analog( Bool ) )
  val ARDUINO_IO_13 = inout( Analog( Bool ) )
  val ARDUINO_IO_14 = inout( Analog( Bool ) )
  val ARDUINO_IO_15 = inout( Analog( Bool ) )
  val ARDUINO_RESET_N = inout( Analog( Bool ) )

  val HDMI_I2C_SCL = inout( Analog( Bool ) )
  val HDMI_I2C_SDA = inout( Analog( Bool ) )
  val HDMI_I2S = inout( Analog( Bool ) )
  val HDMI_LRCLK = inout( Analog( Bool ) )
  val HDMI_MCLK = inout( Analog( Bool ) )
  val HDMI_SCLK = inout( Analog( Bool ) )
  val HDMI_TX_CLK = out( Bool )
  val HDMI_TX_DE = out( Bool )
  val HDMI_TX_D = out( Bits( 24 bits ) )
  val HDMI_TX_HS = out( Bool )
  val HDMI_TX_INT = in( Bool )
  val HDMI_TX_VS = out( Bool )

  //Using KEY[0] as reset due to burnout of TFT shield
  val FPGA_CLK1_50_domain = ClockDomain(
    clock  = FPGA_CLK1_50,
    reset  = KEY( 0 ),
    config = ClockDomainConfig(
      clockEdge        = RISING,
      resetKind        = ASYNC,
      resetActiveLevel = LOW
    )
  )
  val FPGA_CLK2_50_domain = ClockDomain(
    clock  = FPGA_CLK2_50,
    reset  = KEY( 0 ),
    config = ClockDomainConfig(
      clockEdge        = RISING,
      resetKind        = ASYNC,
      resetActiveLevel = LOW
    )
  )
  val FPGA_CLK3_50_domain = ClockDomain(
    clock  = FPGA_CLK3_50,
    reset  = KEY( 0 ),
    config = ClockDomainConfig(
      clockEdge        = RISING,
      resetKind        = ASYNC,
      resetActiveLevel = LOW
    )
  )

  val DDR3_CLK_domain = ClockDomain(
    clock  = DDR3_CLK,
    config = ClockDomainConfig(
      clockEdge = RISING
    )
  )

  val ddr3 = new ddr3()
  ddr3.clk <> FPGA_CLK1_50
  ddr3.ddr3_clk <> DDR3_CLK

  val FPGA_CLK1_50_area =
    new ClockingArea( FPGA_CLK1_50_domain ) {
      val IRQ = Bits( 32 bits )
      IRQ.clearAll()

      val rvfi = Vec( RvfiMon(), 6 )

      val mmc_inst = new mmc_wb()
      val mmc_data = new mmc_wb()
      val cpu = new riscv_top()
      val led = new led_top()
      val keys = new keys_top()
      val uart = new uart_top()
      val mem = new mem_top()
      val shield = new waveshare_tft_touch_shield()
      val debug = new debug_top()

      val arst = Bool()
      val rst = Bool()
      //rst := BufferCC( arst ) //Reset pin got shocked and is burned out, using key0
      rst := BufferCC( KEY( 0 ) )

      mmc_inst.ddr3cntl_mmc_flat_i.clearAll()
      mmc_inst.led_mmc_flat_i.clearAll()
      mmc_inst.keys_mmc_flat_i.clearAll()
      mmc_inst.uart_mmc_flat_i.clearAll()
      mmc_inst.sdcard_mmc_flat_i.clearAll()

      cpu.IRQ <> IRQ
      Cat(
        cpu.busInst.req.cyc,
        cpu.busInst.req.stb,
        cpu.busInst.req.we,
        cpu.busInst.req.adr,
        cpu.busInst.req.sel,
        cpu.busInst.req.data,
        cpu.busInst.req.tga,
        cpu.busInst.req.tgd,
        cpu.busInst.req.tgc
      ) <> mmc_inst.riscv_mmc_flat_i
      cpu.busInst.stall := mmc_inst.mmc_riscv_flat_o( 41 )
      cpu.busInst.rsp.ack := mmc_inst.mmc_riscv_flat_o( 40 )
      cpu.busInst.rsp.err := mmc_inst.mmc_riscv_flat_o( 39 )
      cpu.busInst.rsp.rty := mmc_inst.mmc_riscv_flat_o( 38 )
      cpu.busInst.rsp.data := mmc_inst.mmc_riscv_flat_o( 37 downto 6 )
      cpu.busInst.rsp.tga := mmc_inst.mmc_riscv_flat_o( 5 downto 5 )
      cpu.busInst.rsp.tgd := mmc_inst.mmc_riscv_flat_o( 4 downto 4 )
      cpu.busInst.rsp.tgc := mmc_inst.mmc_riscv_flat_o( 3 downto 0 )
      Cat(
        cpu.busData.req.cyc,
        cpu.busData.req.stb,
        cpu.busData.req.we,
        cpu.busData.req.adr,
        cpu.busData.req.sel,
        cpu.busData.req.data,
        cpu.busData.req.tga,
        cpu.busData.req.tgd,
        cpu.busData.req.tgc
      ) <> mmc_data.riscv_mmc_flat_i
      cpu.busData.stall := mmc_data.mmc_riscv_flat_o( 41 )
      cpu.busData.rsp.ack := mmc_data.mmc_riscv_flat_o( 40 )
      cpu.busData.rsp.err := mmc_data.mmc_riscv_flat_o( 39 )
      cpu.busData.rsp.rty := mmc_data.mmc_riscv_flat_o( 38 )
      cpu.busData.rsp.data := mmc_data.mmc_riscv_flat_o( 37 downto 6 )
      cpu.busData.rsp.tga := mmc_data.mmc_riscv_flat_o( 5 downto 5 )
      cpu.busData.rsp.tgd := mmc_data.mmc_riscv_flat_o( 4 downto 4 )
      cpu.busData.rsp.tgc := mmc_data.mmc_riscv_flat_o( 3 downto 0 )
      cpu.rvfi <> rvfi

      led.LED <> LED
      Cat(
        led.bus.stall,
        led.bus.rsp.ack,
        led.bus.rsp.err,
        led.bus.rsp.rty,
        led.bus.rsp.data,
        led.bus.rsp.tga,
        led.bus.rsp.tgd,
        led.bus.rsp.tgc
      ) <> mmc_data.led_mmc_flat_i
      led.bus.req.cyc := mmc_data.mmc_led_flat_o( 76 )
      led.bus.req.stb := mmc_data.mmc_led_flat_o( 75 )
      led.bus.req.we := mmc_data.mmc_led_flat_o( 74 )
      led.bus.req.adr := mmc_data.mmc_led_flat_o( 73 downto 42 ).asUInt
      led.bus.req.sel := mmc_data.mmc_led_flat_o( 41 downto 38 )
      led.bus.req.data := mmc_data.mmc_led_flat_o( 37 downto 6 )
      led.bus.req.tga := mmc_data.mmc_led_flat_o( 5 downto 5 )
      led.bus.req.tgd := mmc_data.mmc_led_flat_o( 4 downto 4 )
      led.bus.req.tgc := mmc_data.mmc_led_flat_o( 3 downto 0 )

      keys.KEY <> KEY
      Cat(
        keys.bus.stall,
        keys.bus.rsp.ack,
        keys.bus.rsp.err,
        keys.bus.rsp.rty,
        keys.bus.rsp.data,
        keys.bus.rsp.tga,
        keys.bus.rsp.tgd,
        keys.bus.rsp.tgc
      ) <> mmc_data.keys_mmc_flat_i
      keys.bus.req.cyc := mmc_data.mmc_keys_flat_o( 76 )
      keys.bus.req.stb := mmc_data.mmc_keys_flat_o( 75 )
      keys.bus.req.we := mmc_data.mmc_keys_flat_o( 74 )
      keys.bus.req.adr := mmc_data.mmc_keys_flat_o( 73 downto 42 ).asUInt
      keys.bus.req.sel := mmc_data.mmc_keys_flat_o( 41 downto 38 )
      keys.bus.req.data := mmc_data.mmc_keys_flat_o( 37 downto 6 )
      keys.bus.req.tga := mmc_data.mmc_keys_flat_o( 5 downto 5 )
      keys.bus.req.tgd := mmc_data.mmc_keys_flat_o( 4 downto 4 )
      keys.bus.req.tgc := mmc_data.mmc_keys_flat_o( 3 downto 0 )

      GPIO_0_01 := uart.GND
      GPIO_0_05 := uart.TXD
      uart.RXD := GPIO_0_03
      uart.CTS := GPIO_0_07
      GPIO_0_09 := uart.RTS
      uart.IRQ <> IRQ( 0 )
      Cat(
        uart.bus.stall,
        uart.bus.rsp.ack,
        uart.bus.rsp.err,
        uart.bus.rsp.rty,
        uart.bus.rsp.data,
        uart.bus.rsp.tga,
        uart.bus.rsp.tgd,
        uart.bus.rsp.tgc
      ) <> mmc_data.uart_mmc_flat_i
      uart.bus.req.cyc := mmc_data.mmc_uart_flat_o( 76 )
      uart.bus.req.stb := mmc_data.mmc_uart_flat_o( 75 )
      uart.bus.req.we := mmc_data.mmc_uart_flat_o( 74 )
      uart.bus.req.adr := mmc_data.mmc_uart_flat_o( 73 downto 42 ).asUInt
      uart.bus.req.sel := mmc_data.mmc_uart_flat_o( 41 downto 38 )
      uart.bus.req.data := mmc_data.mmc_uart_flat_o( 37 downto 6 )
      uart.bus.req.tga := mmc_data.mmc_uart_flat_o( 5 downto 5 )
      uart.bus.req.tgd := mmc_data.mmc_uart_flat_o( 4 downto 4 )
      uart.bus.req.tgc := mmc_data.mmc_uart_flat_o( 3 downto 0 )

      ddr3.rst <> rst
      ddr3.bus_cntl_flat_i <> mmc_data.mmc_ddr3cntl_flat_o
      ddr3.bus_cntl_flat_o <> mmc_data.ddr3cntl_mmc_flat_i
      ddr3.bus_inst_flat_i <> mmc_inst.mmc_ddr3_flat_o
      ddr3.bus_inst_flat_o <> mmc_inst.ddr3_mmc_flat_i
      ddr3.bus_data_flat_i <> mmc_data.mmc_ddr3_flat_o
      ddr3.bus_data_flat_o <> mmc_data.ddr3_mmc_flat_i

      Cat(
        mem.busInst.stall,
        mem.busInst.rsp.ack,
        mem.busInst.rsp.err,
        mem.busInst.rsp.rty,
        mem.busInst.rsp.data,
        mem.busInst.rsp.tga,
        mem.busInst.rsp.tgd,
        mem.busInst.rsp.tgc
      ) <> mmc_inst.mem_mmc_flat_i
      mem.busInst.req.cyc := mmc_inst.mmc_mem_flat_o( 76 )
      mem.busInst.req.stb := mmc_inst.mmc_mem_flat_o( 75 )
      mem.busInst.req.we := mmc_inst.mmc_mem_flat_o( 74 )
      mem.busInst.req.adr := mmc_inst.mmc_mem_flat_o( 73 downto 42 ).asUInt
      mem.busInst.req.sel := mmc_inst.mmc_mem_flat_o( 41 downto 38 )
      mem.busInst.req.data := mmc_inst.mmc_mem_flat_o( 37 downto 6 )
      mem.busInst.req.tga := mmc_inst.mmc_mem_flat_o( 5 downto 5 )
      mem.busInst.req.tgd := mmc_inst.mmc_mem_flat_o( 4 downto 4 )
      mem.busInst.req.tgc := mmc_inst.mmc_mem_flat_o( 3 downto 0 )
      Cat(
        mem.busData.stall,
        mem.busData.rsp.ack,
        mem.busData.rsp.err,
        mem.busData.rsp.rty,
        mem.busData.rsp.data,
        mem.busData.rsp.tga,
        mem.busData.rsp.tgd,
        mem.busData.rsp.tgc
      ) <> mmc_data.mem_mmc_flat_i
      mem.busData.req.cyc := mmc_data.mmc_mem_flat_o( 76 )
      mem.busData.req.stb := mmc_data.mmc_mem_flat_o( 75 )
      mem.busData.req.we := mmc_data.mmc_mem_flat_o( 74 )
      mem.busData.req.adr := mmc_data.mmc_mem_flat_o( 73 downto 42 ).asUInt
      mem.busData.req.sel := mmc_data.mmc_mem_flat_o( 41 downto 38 )
      mem.busData.req.data := mmc_data.mmc_mem_flat_o( 37 downto 6 )
      mem.busData.req.tga := mmc_data.mmc_mem_flat_o( 5 downto 5 )
      mem.busData.req.tgd := mmc_data.mmc_mem_flat_o( 4 downto 4 )
      mem.busData.req.tgc := mmc_data.mmc_mem_flat_o( 3 downto 0 )

      shield.arst            <> arst
      shield.ADC_CONVST      <> ADC_CONVST     
      shield.ADC_SCK         <> ADC_SCK        
      shield.ADC_SDI         <> ADC_SDI        
      shield.ADC_SDO         <> ADC_SDO        
      shield.ARDUINO_IO_00   <> ARDUINO_IO_00  
      shield.ARDUINO_IO_01   <> ARDUINO_IO_01  
      shield.ARDUINO_IO_02   <> ARDUINO_IO_02  
      shield.ARDUINO_IO_03   <> ARDUINO_IO_03  
      shield.ARDUINO_IO_04   <> ARDUINO_IO_04  
      shield.ARDUINO_IO_05   <> ARDUINO_IO_05  
      shield.ARDUINO_IO_06   <> ARDUINO_IO_06  
      shield.ARDUINO_IO_07   <> ARDUINO_IO_07  
      shield.ARDUINO_IO_08   <> ARDUINO_IO_08  
      shield.ARDUINO_IO_09   <> ARDUINO_IO_09  
      shield.ARDUINO_IO_10   <> ARDUINO_IO_10  
      shield.ARDUINO_IO_11   <> ARDUINO_IO_11  
      shield.ARDUINO_IO_12   <> ARDUINO_IO_12  
      shield.ARDUINO_IO_13   <> ARDUINO_IO_13  
      shield.ARDUINO_IO_14   <> ARDUINO_IO_14  
      shield.ARDUINO_IO_15   <> ARDUINO_IO_15  
      shield.ARDUINO_RESET_N <> ARDUINO_RESET_N
      shield.touchpad_data_flat_i.clearAll()
      shield.display_data_flat_i.clearAll()
      shield.displaybuff_data_flat_i.clearAll()
      shield.consolebuff_data_flat_i.clearAll()
      shield.sdcard_data_flat_i <> mmc_data.mmc_sdcard_flat_o
      shield.sdcard_data_flat_o <> mmc_data.sdcard_mmc_flat_i

      Cat(
        debug.busInst.stall,
        debug.busInst.rsp.ack,
        debug.busInst.rsp.err,
        debug.busInst.rsp.rty,
        debug.busInst.rsp.data,
        debug.busInst.rsp.tga,
        debug.busInst.rsp.tgd,
        debug.busInst.rsp.tgc
      ) <> mmc_inst.debug_mmc_flat_i
      debug.busInst.req.cyc := mmc_inst.mmc_debug_flat_o( 76 )
      debug.busInst.req.stb := mmc_inst.mmc_debug_flat_o( 75 )
      debug.busInst.req.we := mmc_inst.mmc_debug_flat_o( 74 )
      debug.busInst.req.adr := mmc_inst.mmc_debug_flat_o( 73 downto 42 ).asUInt
      debug.busInst.req.sel := mmc_inst.mmc_debug_flat_o( 41 downto 38 )
      debug.busInst.req.data := mmc_inst.mmc_debug_flat_o( 37 downto 6 )
      debug.busInst.req.tga := mmc_inst.mmc_debug_flat_o( 5 downto 5 )
      debug.busInst.req.tgd := mmc_inst.mmc_debug_flat_o( 4 downto 4 )
      debug.busInst.req.tgc := mmc_inst.mmc_debug_flat_o( 3 downto 0 )
      Cat(
        debug.busData.stall,
        debug.busData.rsp.ack,
        debug.busData.rsp.err,
        debug.busData.rsp.rty,
        debug.busData.rsp.data,
        debug.busData.rsp.tga,
        debug.busData.rsp.tgd,
        debug.busData.rsp.tgc
      ) <> mmc_data.debug_mmc_flat_i
      debug.busData.req.cyc := mmc_data.mmc_debug_flat_o( 76 )
      debug.busData.req.stb := mmc_data.mmc_debug_flat_o( 75 )
      debug.busData.req.we := mmc_data.mmc_debug_flat_o( 74 )
      debug.busData.req.adr := mmc_data.mmc_debug_flat_o( 73 downto 42 ).asUInt
      debug.busData.req.sel := mmc_data.mmc_debug_flat_o( 41 downto 38 )
      debug.busData.req.data := mmc_data.mmc_debug_flat_o( 37 downto 6 )
      debug.busData.req.tga := mmc_data.mmc_debug_flat_o( 5 downto 5 )
      debug.busData.req.tgd := mmc_data.mmc_debug_flat_o( 4 downto 4 )
      debug.busData.req.tgc := mmc_data.mmc_debug_flat_o( 3 downto 0 )

      HDMI_TX_CLK := False
      HDMI_TX_DE := False
      HDMI_TX_D.clearAll()
      HDMI_TX_HS := False
      HDMI_TX_VS := False

      val asserts = new coreAsserts();
    }

  val DDR3_CLK_area =
    new ClockingArea( DDR3_CLK_domain ) {
      ddr3_hps_f2h_sdram0_clock_clk <> DDR3_CLK
      ddr3_hps_f2h_sdram0_data_address <> ddr3.ddr3_avl_addr
      ddr3_hps_f2h_sdram0_data_read <> ddr3.ddr3_avl_read_req
      ddr3_hps_f2h_sdram0_data_readdata <> ddr3.ddr3_avl_rdata
      ddr3_hps_f2h_sdram0_data_write <> ddr3.ddr3_avl_write_req
      ddr3_hps_f2h_sdram0_data_writedata <> ddr3.ddr3_avl_wdata
      ddr3_hps_f2h_sdram0_data_readdatavalid <> ddr3.ddr3_avl_rdata_valid
      ddr3_hps_f2h_sdram0_data_waitrequest <> ddr3.ddr3_avl_ready
      ddr3_hps_f2h_sdram0_data_byteenable.setAll()
      ddr3_hps_f2h_sdram0_data_burstcount <> ddr3.ddr3_avl_size
    }
}

class mmc_wb extends BlackBox {
  val config = riscv_config(
    busWishBoneConfig = WishBoneConfig(
      adrWidth  = 32,
      selWidth  = 4,
      dataWidth = 32,
      tgaWidth  = 1,
      tgdWidth  = 1,
      tgcWidth  = 4
    )
  )

  val clk = in( Bool )
  val rst = in( Bool )

  val riscv_mmc_flat_i = in(
    Bits( widthOf( WishBoneReq( config.busWishBoneConfig ) ) bits )
  )
  val mmc_riscv_flat_o = out(
    Bits( ( widthOf( WishBoneRsp( config.busWishBoneConfig ) ) + 1 ) bits )
  )

  val mmc_mem_flat_o = out(
    Bits( widthOf( WishBoneReq( config.busWishBoneConfig ) ) bits )
  )
  val mem_mmc_flat_i = in(
    Bits( ( widthOf( WishBoneRsp( config.busWishBoneConfig ) ) + 1 ) bits )
  )

  val mmc_ddr3_flat_o = out(
    Bits( widthOf( WishBoneReq( config.busWishBoneConfig ) ) bits )
  )
  val ddr3_mmc_flat_i = in(
    Bits( ( widthOf( WishBoneRsp( config.busWishBoneConfig ) ) + 1 ) bits )
  )

  val mmc_ddr3cntl_flat_o = out(
    Bits( widthOf( WishBoneReq( config.busWishBoneConfig ) ) bits )
  )
  val ddr3cntl_mmc_flat_i = in(
    Bits( ( widthOf( WishBoneRsp( config.busWishBoneConfig ) ) + 1 ) bits )
  )

  val mmc_led_flat_o = out(
    Bits( widthOf( WishBoneReq( config.busWishBoneConfig ) ) bits )
  )
  val led_mmc_flat_i = in(
    Bits( ( widthOf( WishBoneRsp( config.busWishBoneConfig ) ) + 1 ) bits )
  )

  val mmc_keys_flat_o = out(
    Bits( widthOf( WishBoneReq( config.busWishBoneConfig ) ) bits )
  )
  val keys_mmc_flat_i = in(
    Bits( ( widthOf( WishBoneRsp( config.busWishBoneConfig ) ) + 1 ) bits )
  )

  val mmc_uart_flat_o = out(
    Bits( widthOf( WishBoneReq( config.busWishBoneConfig ) ) bits )
  )
  val uart_mmc_flat_i = in(
    Bits( ( widthOf( WishBoneRsp( config.busWishBoneConfig ) ) + 1 ) bits )
  )

  val mmc_sdcard_flat_o = out(
    Bits( widthOf( WishBoneReq( config.busWishBoneConfig ) ) bits )
  )
  val sdcard_mmc_flat_i = in(
    Bits( ( widthOf( WishBoneRsp( config.busWishBoneConfig ) ) + 1 ) bits )
  )

  val mmc_debug_flat_o = out(
    Bits( widthOf( WishBoneReq( config.busWishBoneConfig ) ) bits )
  )
  val debug_mmc_flat_i = in(
    Bits( ( widthOf( WishBoneRsp( config.busWishBoneConfig ) ) + 1 ) bits )
  )

  mapCurrentClockDomain( clock = clk, reset = rst )
}

class waveshare_tft_touch_shield extends BlackBox {
  val config = riscv_config(
    busWishBoneConfig = WishBoneConfig(
      adrWidth  = 32,
      selWidth  = 4,
      dataWidth = 32,
      tgaWidth  = 1,
      tgdWidth  = 1,
      tgcWidth  = 4
    )
  )

  val clk = in( Bool )
  val rst = in( Bool )
  val arst = out( Bool )

  val ADC_CONVST = out( Bool )
  val ADC_SCK = out( Bool )
  val ADC_SDI = out( Bool )
  val ADC_SDO = in( Bool )

  val ARDUINO_IO_00 = inout( Analog( Bool ) )
  val ARDUINO_IO_01 = inout( Analog( Bool ) )
  val ARDUINO_IO_02 = inout( Analog( Bool ) )
  val ARDUINO_IO_03 = inout( Analog( Bool ) )
  val ARDUINO_IO_04 = inout( Analog( Bool ) )
  val ARDUINO_IO_05 = inout( Analog( Bool ) )
  val ARDUINO_IO_06 = inout( Analog( Bool ) )
  val ARDUINO_IO_07 = inout( Analog( Bool ) )
  val ARDUINO_IO_08 = inout( Analog( Bool ) )
  val ARDUINO_IO_09 = inout( Analog( Bool ) )
  val ARDUINO_IO_10 = inout( Analog( Bool ) )
  val ARDUINO_IO_11 = inout( Analog( Bool ) )
  val ARDUINO_IO_12 = inout( Analog( Bool ) )
  val ARDUINO_IO_13 = inout( Analog( Bool ) )
  val ARDUINO_IO_14 = inout( Analog( Bool ) )
  val ARDUINO_IO_15 = inout( Analog( Bool ) )
  val ARDUINO_RESET_N = inout( Analog( Bool ) )

  val touchpad_data_flat_i = in(
    Bits( widthOf( WishBoneReq( config.busWishBoneConfig ) ) bits )
  )
  val touchpad_data_flat_o = out(
    Bits( ( widthOf( WishBoneRsp( config.busWishBoneConfig ) ) + 1 ) bits )
  )

  val display_data_flat_i = in(
    Bits( widthOf( WishBoneReq( config.busWishBoneConfig ) ) bits )
  )
  val display_data_flat_o = out(
    Bits( ( widthOf( WishBoneRsp( config.busWishBoneConfig ) ) + 1 ) bits )
  )

  val displaybuff_data_flat_i = in(
    Bits( widthOf( WishBoneReq( config.busWishBoneConfig ) ) bits )
  )
  val displaybuff_data_flat_o = out(
    Bits( ( widthOf( WishBoneRsp( config.busWishBoneConfig ) ) + 1 ) bits )
  )

  val consolebuff_data_flat_i = in(
    Bits( widthOf( WishBoneReq( config.busWishBoneConfig ) ) bits )
  )
  val consolebuff_data_flat_o = out(
    Bits( ( widthOf( WishBoneRsp( config.busWishBoneConfig ) ) + 1 ) bits )
  )

  val sdcard_data_flat_i = in(
    Bits( widthOf( WishBoneReq( config.busWishBoneConfig ) ) bits )
  )
  val sdcard_data_flat_o = out(
    Bits( ( widthOf( WishBoneRsp( config.busWishBoneConfig ) ) + 1 ) bits )
  )
  
  mapCurrentClockDomain( clock = clk, reset = rst )
}

class ddr3 extends BlackBox {
  val config = riscv_config(
    busWishBoneConfig = WishBoneConfig(
      adrWidth  = 32,
      selWidth  = 4,
      dataWidth = 32,
      tgaWidth  = 1,
      tgdWidth  = 1,
      tgcWidth  = 4
    )
  )

  val clk = in( Bool )
  val ddr3_clk = in( Bool )
  val rst = in( Bool )

  val bus_cntl_flat_i = in(
    Bits( widthOf( WishBoneReq( config.busWishBoneConfig ) ) bits )
  )
  val bus_cntl_flat_o = out(
    Bits( ( widthOf( WishBoneRsp( config.busWishBoneConfig ) ) + 1 ) bits )
  )

  val bus_inst_flat_i = in(
    Bits( widthOf( WishBoneReq( config.busWishBoneConfig ) ) bits )
  )
  val bus_inst_flat_o = out(
    Bits( ( widthOf( WishBoneRsp( config.busWishBoneConfig ) ) + 1 ) bits )
  )

  val bus_data_flat_i = in(
    Bits( widthOf( WishBoneReq( config.busWishBoneConfig ) ) bits )
  )
  val bus_data_flat_o = out(
    Bits( ( widthOf( WishBoneRsp( config.busWishBoneConfig ) ) + 1 ) bits )
  )

  val ddr3_avl_ready = in( Bool )
  val ddr3_avl_addr = out( Bits( 26 bits ) )
  val ddr3_avl_rdata_valid = in( Bool )
  val ddr3_avl_rdata = in( Bits( 128 bits ) )
  val ddr3_avl_wdata = out( Bits( 128 bits ) )
  val ddr3_avl_read_req = out( Bool )
  val ddr3_avl_write_req = out( Bool )
  val ddr3_avl_size = out( Bits( 9 bits ) )
}


class coreAsserts() extends Component {
  import spinal.core.GenerationFlags._
  import spinal.core.Formal._

  //Signal toggles after initial reset, nothing matters before the first reset
  var reset_seen = Reg( Bool )
  reset_seen := reset_seen
  when( clockDomain.isResetActive ) {
    reset_seen := True
  }

  GenerationFlags.formal {
    when( reset_seen ) {}
  }

}

//Define a custom SpinalHDL configuration with synchronous reset instead of the default asynchronous one. This configuration can be resued everywhere
object core_config
    extends SpinalConfig(
      defaultConfigForClockDomains = ClockDomainConfig(
        resetKind        = SYNC,
        resetActiveLevel = HIGH
      ),
      targetDirectory              = "target"
    )

//Generate the riscv's Verilog using the above custom configuration.
object core_top {
  def main( args: Array[String] ) {
    core_config.includeFormal.generateVerilog( new core_top )
  }
}
