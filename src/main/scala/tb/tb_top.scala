package tb

import core._

import spinal.core._
import spinal.lib._
import javax.net.ssl.TrustManager

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

class tb_top extends Component {
  val FPGA_CLK1_50 = in( Bool )
  val FPGA_CLK2_50 = in( Bool )
  val FPGA_CLK3_50 = in( Bool )
  val DDR3_CLK = Bool

  val LED = out( Bits( 8 bits ) )

  val HPS_DDR3_ADDR = out( Bits( 15 bits ) )
  val HPS_DDR3_BA = out( Bits( 3 bits ) )
  val HPS_DDR3_CAS_N = out( Bool )
  val HPS_DDR3_CKE = out( Bool )
  val HPS_DDR3_CK_N = out( Bool )
  val HPS_DDR3_CK_P = out( Bool )
  val HPS_DDR3_CS_N = out( Bool )
  val HPS_DDR3_DM = out( Bits( 4 bits ) )
  val HPS_DDR3_DQ = inout( Analog( Bits( 32 bits ) ) )
  val HPS_DDR3_DQS_N = inout( Analog( Bits( 4 bits ) ) )
  val HPS_DDR3_DQS_P = inout( Analog( Bits( 4 bits ) ) )
  val HPS_DDR3_ODT = out( Bool )
  val HPS_DDR3_RAS_N = out( Bool )
  val HPS_DDR3_RESET_N = out( Bool )
  val HPS_DDR3_RZQ = in( Bool )
  val HPS_DDR3_WE_N = out( Bool )

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

  val core = new core_top()

  core.FPGA_CLK1_50 <> FPGA_CLK1_50
  core.FPGA_CLK2_50 <> FPGA_CLK2_50
  core.FPGA_CLK3_50 <> FPGA_CLK3_50

  core.LED <> LED

  core.KEY <> KEY

  core.SW <> SW

  core.ADC_CONVST <> ADC_CONVST
  core.ADC_SCK <> ADC_SCK
  core.ADC_SDI <> ADC_SDI
  core.ADC_SDO <> ADC_SDO

  core.GPIO_0_00 <> GPIO_0_00
  core.GPIO_0_01 <> GPIO_0_01 
  core.GPIO_0_02 <> GPIO_0_02
  core.GPIO_0_03 <> GPIO_0_03 
  core.GPIO_0_04 <> GPIO_0_04
  core.GPIO_0_05 <> GPIO_0_05 
  core.GPIO_0_06 <> GPIO_0_06
  core.GPIO_0_07 <> GPIO_0_07 
  core.GPIO_0_08 <> GPIO_0_08
  core.GPIO_0_09 <> GPIO_0_09 
  core.GPIO_0_10 <> GPIO_0_10
  core.GPIO_0_11 <> GPIO_0_11
  core.GPIO_0_12 <> GPIO_0_12
  core.GPIO_0_13 <> GPIO_0_13
  core.GPIO_0_14 <> GPIO_0_14
  core.GPIO_0_15 <> GPIO_0_15
  core.GPIO_0_16 <> GPIO_0_16
  core.GPIO_0_17 <> GPIO_0_17
  core.GPIO_0_18 <> GPIO_0_18
  core.GPIO_0_19 <> GPIO_0_19
  core.GPIO_0_20 <> GPIO_0_20
  core.GPIO_0_21 <> GPIO_0_21
  core.GPIO_0_22 <> GPIO_0_22
  core.GPIO_0_23 <> GPIO_0_23
  core.GPIO_0_24 <> GPIO_0_24
  core.GPIO_0_25 <> GPIO_0_25
  core.GPIO_0_26 <> GPIO_0_26
  core.GPIO_0_27 <> GPIO_0_27
  core.GPIO_0_28 <> GPIO_0_28
  core.GPIO_0_29 <> GPIO_0_29
  core.GPIO_0_30 <> GPIO_0_30
  core.GPIO_0_31 <> GPIO_0_31
  core.GPIO_0_32 <> GPIO_0_32
  core.GPIO_0_33 <> GPIO_0_33
  core.GPIO_0_34 <> GPIO_0_34
  core.GPIO_0_35 <> GPIO_0_35
               
  core.GPIO_1_00 <> GPIO_1_00
  core.GPIO_1_01 <> GPIO_1_01
  core.GPIO_1_02 <> GPIO_1_02
  core.GPIO_1_03 <> GPIO_1_03
  core.GPIO_1_04 <> GPIO_1_04
  core.GPIO_1_05 <> GPIO_1_05
  core.GPIO_1_06 <> GPIO_1_06
  core.GPIO_1_07 <> GPIO_1_07
  core.GPIO_1_08 <> GPIO_1_08
  core.GPIO_1_09 <> GPIO_1_09
  core.GPIO_1_10 <> GPIO_1_10
  core.GPIO_1_11 <> GPIO_1_11
  core.GPIO_1_12 <> GPIO_1_12
  core.GPIO_1_13 <> GPIO_1_13
  core.GPIO_1_14 <> GPIO_1_14
  core.GPIO_1_15 <> GPIO_1_15
  core.GPIO_1_16 <> GPIO_1_16
  core.GPIO_1_17 <> GPIO_1_17
  core.GPIO_1_18 <> GPIO_1_18
  core.GPIO_1_19 <> GPIO_1_19
  core.GPIO_1_20 <> GPIO_1_20
  core.GPIO_1_21 <> GPIO_1_21
  core.GPIO_1_22 <> GPIO_1_22
  core.GPIO_1_23 <> GPIO_1_23
  core.GPIO_1_24 <> GPIO_1_24
  core.GPIO_1_25 <> GPIO_1_25
  core.GPIO_1_26 <> GPIO_1_26
  core.GPIO_1_27 <> GPIO_1_27
  core.GPIO_1_28 <> GPIO_1_28
  core.GPIO_1_29 <> GPIO_1_29
  core.GPIO_1_30 <> GPIO_1_30
  core.GPIO_1_31 <> GPIO_1_31
  core.GPIO_1_32 <> GPIO_1_32
  core.GPIO_1_33 <> GPIO_1_33
  core.GPIO_1_34 <> GPIO_1_34
  core.GPIO_1_35 <> GPIO_1_35

  core.ARDUINO_IO_00 <> ARDUINO_IO_00
  core.ARDUINO_IO_01 <> ARDUINO_IO_01
  core.ARDUINO_IO_02 <> ARDUINO_IO_02
  core.ARDUINO_IO_03 <> ARDUINO_IO_03
  core.ARDUINO_IO_04 <> ARDUINO_IO_04
  core.ARDUINO_IO_05 <> ARDUINO_IO_05
  core.ARDUINO_IO_06 <> ARDUINO_IO_06
  core.ARDUINO_IO_07 <> ARDUINO_IO_07
  core.ARDUINO_IO_08 <> ARDUINO_IO_08
  core.ARDUINO_IO_09 <> ARDUINO_IO_09
  core.ARDUINO_IO_10 <> ARDUINO_IO_10
  core.ARDUINO_IO_11 <> ARDUINO_IO_11
  core.ARDUINO_IO_12 <> ARDUINO_IO_12
  core.ARDUINO_IO_13 <> ARDUINO_IO_13
  core.ARDUINO_IO_14 <> ARDUINO_IO_14
  core.ARDUINO_IO_15 <> ARDUINO_IO_15
  core.ARDUINO_RESET_N <> ARDUINO_RESET_N

  core.HDMI_I2C_SCL <> HDMI_I2C_SCL
  core.HDMI_I2C_SDA <> HDMI_I2C_SDA
  core.HDMI_I2S     <> HDMI_I2S    
  core.HDMI_LRCLK   <> HDMI_LRCLK  
  core.HDMI_MCLK    <> HDMI_MCLK   
  core.HDMI_SCLK    <> HDMI_SCLK   
  core.HDMI_TX_CLK  <> HDMI_TX_CLK 
  core.HDMI_TX_DE   <> HDMI_TX_DE  
  core.HDMI_TX_D    <> HDMI_TX_D   
  core.HDMI_TX_HS   <> HDMI_TX_HS  
  core.HDMI_TX_INT  <> HDMI_TX_INT 
  core.HDMI_TX_VS   <> HDMI_TX_VS  

  val FPGA_CLK1_50_area =
    new ClockingArea( FPGA_CLK1_50_domain ) {
    }

  val DDR3_CLK_area =
    new ClockingArea( DDR3_CLK_domain ) {
      val u0 = new soc_system()

      u0.clk_clk <> FPGA_CLK1_50
      u0.ddr3_clk_clk <> DDR3_CLK

      u0.memory_mem_a <> HPS_DDR3_ADDR
      u0.memory_mem_ba <> HPS_DDR3_BA
      u0.memory_mem_ck <> HPS_DDR3_CK_P
      u0.memory_mem_ck_n <> HPS_DDR3_CK_N
      u0.memory_mem_cke <> HPS_DDR3_CKE
      u0.memory_mem_cs_n <> HPS_DDR3_CS_N
      u0.memory_mem_ras_n <> HPS_DDR3_RAS_N
      u0.memory_mem_cas_n <> HPS_DDR3_CAS_N
      u0.memory_mem_we_n <> HPS_DDR3_WE_N
      u0.memory_mem_reset_n <> HPS_DDR3_RESET_N
      u0.memory_mem_dq <> HPS_DDR3_DQ
      u0.memory_mem_dqs <> HPS_DDR3_DQS_P
      u0.memory_mem_dqs_n <> HPS_DDR3_DQS_N
      u0.memory_mem_odt <> HPS_DDR3_ODT
      u0.memory_mem_dm <> HPS_DDR3_DM
      u0.memory_oct_rzqin <> HPS_DDR3_RZQ

      DDR3_CLK <> core.DDR3_CLK
      u0.ddr3_hps_f2h_sdram0_clock_clk          <> core.ddr3_hps_f2h_sdram0_clock_clk         
      u0.ddr3_hps_f2h_sdram0_data_address       <> core.ddr3_hps_f2h_sdram0_data_address      
      u0.ddr3_hps_f2h_sdram0_data_read          <> core.ddr3_hps_f2h_sdram0_data_read         
      u0.ddr3_hps_f2h_sdram0_data_readdata      <> core.ddr3_hps_f2h_sdram0_data_readdata     
      u0.ddr3_hps_f2h_sdram0_data_write         <> core.ddr3_hps_f2h_sdram0_data_write        
      u0.ddr3_hps_f2h_sdram0_data_writedata     <> core.ddr3_hps_f2h_sdram0_data_writedata    
      u0.ddr3_hps_f2h_sdram0_data_readdatavalid <> core.ddr3_hps_f2h_sdram0_data_readdatavalid
      u0.ddr3_hps_f2h_sdram0_data_waitrequest   <> core.ddr3_hps_f2h_sdram0_data_waitrequest  
      u0.ddr3_hps_f2h_sdram0_data_byteenable    <> core.ddr3_hps_f2h_sdram0_data_byteenable   
      u0.ddr3_hps_f2h_sdram0_data_burstcount    <> core.ddr3_hps_f2h_sdram0_data_burstcount   
    }
}

class soc_system extends Component {
  val clk_clk = in( Bool )
  val ddr3_clk_clk = out( Bool )

  val memory_mem_a = out( Bits( 15 bits ) )
  val memory_mem_ba = out( Bits( 3 bits ) )
  val memory_mem_ck = out( Bool )
  val memory_mem_ck_n = out( Bool )
  val memory_mem_cke = out( Bool )
  val memory_mem_cs_n = out( Bool )
  val memory_mem_ras_n = out( Bool )
  val memory_mem_cas_n = out( Bool )
  val memory_mem_we_n = out( Bool )
  val memory_mem_reset_n = out( Bool )
  val memory_mem_dq = inout( Analog( Bits( 32 bits ) ) )
  val memory_mem_dqs = inout( Analog( Bits( 4 bits ) ) )
  val memory_mem_dqs_n = inout( Analog( Bits( 4 bits ) ) )
  val memory_mem_odt = out( Bool )
  val memory_mem_dm = out( Bits( 4 bits ) )
  val memory_oct_rzqin = in( Bool )

  val ddr3_hps_f2h_sdram0_clock_clk = in( Bool )
  val ddr3_hps_f2h_sdram0_data_address = in( Bits( 26 bits ) )
  val ddr3_hps_f2h_sdram0_data_read = in( Bool )
  val ddr3_hps_f2h_sdram0_data_readdata = out( Bits( 128 bits ) )
  val ddr3_hps_f2h_sdram0_data_write = in( Bool )
  val ddr3_hps_f2h_sdram0_data_writedata = in( Bits( 128 bits ) )
  val ddr3_hps_f2h_sdram0_data_readdatavalid = out( Bool )
  val ddr3_hps_f2h_sdram0_data_waitrequest = out( Bool )
  val ddr3_hps_f2h_sdram0_data_byteenable = in( Bits( 16 bits ) )
  val ddr3_hps_f2h_sdram0_data_burstcount = in( Bits( 9 bits ) )

  ddr3_clk_clk <> clk_clk

  memory_mem_a.clearAll()
  memory_mem_ba.clearAll()
  memory_mem_ck := False
  memory_mem_ck_n := False
  memory_mem_cke := False
  memory_mem_cs_n := False
  memory_mem_ras_n := False
  memory_mem_cas_n := False
  memory_mem_we_n := False
  memory_mem_reset_n := False
  memory_mem_odt := False
  memory_mem_dm.clearAll()

  ddr3_hps_f2h_sdram0_data_readdata.clearAll()
  ddr3_hps_f2h_sdram0_data_readdatavalid := False
  ddr3_hps_f2h_sdram0_data_waitrequest := False
}

class tbAsserts() extends Component {
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
object tb_config
    extends SpinalConfig(
      defaultConfigForClockDomains = ClockDomainConfig(
        resetKind        = SYNC,
        resetActiveLevel = HIGH
      ),
      targetDirectory              = "target"
    )

//Generate the riscv's Verilog using the above custom configuration.
object tb_top {
  def main( args: Array[String] ) {
    tb_config.includeFormal.generateVerilog( new tb_top )
  }
}
