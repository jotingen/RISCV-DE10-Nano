`include "svunit_defines.svh"

`include "clk_and_reset.svh"
`include "ddr3_clk_and_reset.svh"

`include "../../src/common/lru_16.sv"
`include "../../src/common/lru_32.sv"
`include "../../src/de10nano/ADC/simulation/ADC.v"
`include "../../src/de10nano/ADC/simulation/submodules/ADC_adc_mega_0.v"
`include "../../src/de10nano/ADC/simulation/submodules/altera_up_avalon_adv_adc.v"
`include "../../src/de10nano/ddr3/ddr3.sv"
`include "../../src/de10nano/ddr3/ddr3_cache.sv"
`include "../../src/de10nano/ddr3/ddr3_fifo.v"
`include "../../src/de10nano/debounce.v"
`include "../../src/de10nano/keys.sv"
`include "../../src/de10nano/led.sv"
`include "../../src/mem/mem.sv"
`include "../../src/mmc/mmc.sv"
`include "../../src/mmc/mmc_wb.sv"
`include "../../src/quartus/PLL/PLL.v"
`include "../../src/quartus/display_buffer/display_buffer.v"
`include "../../src/quartus/display_buffer_32k/display_buffer_32k.v"
`include "../../src/quartus/divider/divider.v"
`include "../../src/quartus/divider_unsigned/divider_unsigned.v"
`include "../../src/quartus/ifu_buff/ifu_buff.v"
`include "../../src/quartus/multiplier/multiplier.v"
`include "../../src/quartus/multiplier_signed_unsigned/multiplier_signed_unsigned.v"
`include "../../src/quartus/multiplier_unsigned/multiplier_unsigned.v"
`include "../../src/quartus/ram_1r1w_64kbx32b/ram_1r1w_64kbx32b.v"
`include "../../src/quartus/ram_1rw_8192x16/ram_1rw_8192x16.v"
`include "../../src/quartus/wishbone_buff/wishbone_buff.v"
`include "../../src/riscv/riscv.sv"
`include "../../src/riscv/riscv_alu.sv"
`include "../../src/riscv/riscv_br_pred.sv"
`include "../../src/riscv/riscv_bru.sv"
`include "../../src/riscv/riscv_csr.sv"
`include "../../src/riscv/riscv_csu.sv"
`include "../../src/riscv/riscv_dpu.sv"
`include "../../src/riscv/riscv_dvu.sv"
`include "../../src/riscv/riscv_exu.sv"
`include "../../src/riscv/riscv_idu.sv"
`include "../../src/riscv/riscv_ifu.sv"
`include "../../src/riscv/riscv_lsu.sv"
`include "../../src/riscv/riscv_mpu.sv"
`include "../../src/riscv/riscv_pkg.sv"
`include "../../src/riscv/riscv_regfile.sv"
`include "../../src/riscv/riscv_wbu.sv"
`include "../../src/sdcard/sdcard.sv"
`include "../../src/sdcard/sdcard_data_in_fifo.v"
`include "../../src/spi/spi.sv"
`include "../../src/spi/spi_arb.sv"
`include "../../src/top.sv"
`include "../../src/uart/uart.sv"
`include "../../src/waveshare/ILI9486/ILI9486.sv"
`include "../../src/waveshare/ILI9486/ILI9486_buffer.sv"
`include "../../src/waveshare/ILI9486/ILI9486_clk.sv"
`include "../../src/waveshare/ILI9486/ILI9486_transmit.sv"
`include "../../src/waveshare/ILI9486/console_buffer.sv"
`include "../../src/waveshare/ILI9486/fifo.v"
`include "../../src/waveshare/waveshare_tft_touch_shield.sv"

`include "/mnt/c/intelFPGA_lite/19.1/quartus/eda/sim_lib/altera_mf.v"
`include "/mnt/c/intelFPGA_lite/19.1/quartus/eda/sim_lib/220model.v"

//`include "ddr3_mem.sv"
//`include "ddr3_wishbone_driver.sv"
//`include "ddr3_wishbone_monitor.sv"

module sim_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "ddr3_ut";
  svunit_testcase svunit_ut;


  wire rst_n;
  `CLK_RESET_FIXTURE(20,10)
  `DDR3_CLK_RESET_FIXTURE(3,10)
  assign rst_n = ~rst;

  localparam      MEM_CYC_DELAY = 25*20/3;
  localparam      VERBOSE = 0;

  //////////// CLOCK //////////
  logic           FPGA_CLK1_50;
  logic           FPGA_CLK2_50;
  logic           FPGA_CLK3_50;

  //////////// LED //////////
  logic  [7:0]    LED;

  //////////// HPS //////////
  logic [14:0]    HPS_DDR3_ADDR;
  logic  [2:0]    HPS_DDR3_BA;
  logic           HPS_DDR3_CAS_N;
  logic           HPS_DDR3_CKE;
  logic           HPS_DDR3_CK_N;
  logic           HPS_DDR3_CK_P;
  logic           HPS_DDR3_CS_N;
  logic  [3:0]    HPS_DDR3_DM;
  wire  [31:0]    HPS_DDR3_DQ;
  wire   [3:0]    HPS_DDR3_DQS_N;
  wire   [3:0]    HPS_DDR3_DQS_P;
  logic           HPS_DDR3_ODT;
  logic           HPS_DDR3_RAS_N;
  logic           HPS_DDR3_RESET_N;
  logic           HPS_DDR3_RZQ;
  logic           HPS_DDR3_WE_N;

  //////////// KEY //////////
  logic  [1:0]    KEY;

  //////////// SW //////////
  logic  [3:0]    SW;

  //////////// ADC //////////
  logic           ADC_CONVST;
  logic           ADC_SCK;
  logic           ADC_SDI;
  logic           ADC_SDO;

  //////////// GPIO_0; GPIO connect to GPIO Default //////////
  logic           GPIO_0_00;
  logic           GPIO_0_01; //UART GND
  logic           GPIO_0_02;
  logic           GPIO_0_03; //UART RXD
  logic           GPIO_0_04;
  logic           GPIO_0_05; //UART TXD
  logic           GPIO_0_06;
  logic           GPIO_0_07; //UART CTS
  logic           GPIO_0_08;
  logic           GPIO_0_09; //UART RTS
  logic           GPIO_0_10;
  logic           GPIO_0_11;
  logic           GPIO_0_12;
  logic           GPIO_0_13;
  logic           GPIO_0_14;
  logic           GPIO_0_15;
  logic           GPIO_0_16;
  logic           GPIO_0_17;
  logic           GPIO_0_18;
  logic           GPIO_0_19;
  logic           GPIO_0_20;
  logic           GPIO_0_21;
  logic           GPIO_0_22;
  logic           GPIO_0_23;
  logic           GPIO_0_24;
  logic           GPIO_0_25;
  logic           GPIO_0_26;
  logic           GPIO_0_27;
  logic           GPIO_0_28;
  logic           GPIO_0_29;
  logic           GPIO_0_30;
  logic           GPIO_0_31;
  logic           GPIO_0_32;
  logic           GPIO_0_33;
  logic           GPIO_0_34;
  logic           GPIO_0_35;

  //////////// GPIO_1; GPIO connect to GPIO Default //////////
  logic           GPIO_1_00;
  logic           GPIO_1_01;
  logic           GPIO_1_02;
  logic           GPIO_1_03;
  logic           GPIO_1_04;
  logic           GPIO_1_05;
  logic           GPIO_1_06;
  logic           GPIO_1_07;
  logic           GPIO_1_08;
  logic           GPIO_1_09;
  logic           GPIO_1_10;
  logic           GPIO_1_11;
  logic           GPIO_1_12;
  logic           GPIO_1_13;
  logic           GPIO_1_14;
  logic           GPIO_1_15;
  logic           GPIO_1_16;
  logic           GPIO_1_17;
  logic           GPIO_1_18;
  logic           GPIO_1_19;
  logic           GPIO_1_20;
  logic           GPIO_1_21;
  logic           GPIO_1_22;
  logic           GPIO_1_23;
  logic           GPIO_1_24;
  logic           GPIO_1_25;
  logic           GPIO_1_26;
  logic           GPIO_1_27;
  logic           GPIO_1_28;
  logic           GPIO_1_29;
  logic           GPIO_1_30;
  logic           GPIO_1_31;
  logic           GPIO_1_32;
  logic           GPIO_1_33;
  logic           GPIO_1_34;
  logic           GPIO_1_35;

  //////////// ARDUINO //////////
  logic           ARDUINO_IO_00;
  logic           ARDUINO_IO_01;
  logic           ARDUINO_IO_02;
  logic           ARDUINO_IO_03;
  logic           ARDUINO_IO_04;
  logic           ARDUINO_IO_05;
  logic           ARDUINO_IO_06;
  logic           ARDUINO_IO_07;
  logic           ARDUINO_IO_08;
  logic           ARDUINO_IO_09;
  logic           ARDUINO_IO_10;
  logic           ARDUINO_IO_11;
  logic           ARDUINO_IO_12;
  logic           ARDUINO_IO_13;
  logic           ARDUINO_IO_14;
  logic           ARDUINO_IO_15;

  //////////// HDMI //////////
  wire            HDMI_I2C_SCL;
  wire            HDMI_I2C_SDA;
  wire            HDMI_I2S;
  wire            HDMI_LRCLK;
  wire            HDMI_MCLK;
  wire            HDMI_SCLK;
  logic           HDMI_TX_CLK;
  logic           HDMI_TX_DE;
  logic  [23:0]   HDMI_TX_D;
  logic           HDMI_TX_HS;
  logic           HDMI_TX_INT;
  logic           HDMI_TX_VS;

  logic           DDR3_CLK;  //100MHz
  logic           ddr3_avl_ready;       
  logic [25:0]    ddr3_avl_addr;        
  logic           ddr3_avl_rdata_valid; 
  logic [127:0]   ddr3_avl_rdata;       
  logic [127:0]   ddr3_avl_wdata;       
  logic           ddr3_avl_read_req;    
  logic           ddr3_avl_write_req;   
  logic [8:0]     ddr3_avl_size;        

  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  assign KEY[0] = rst_n; //Physical board's reset pin shorted
  top de10nano(
    .FPGA_CLK1_50 (clk),
    .FPGA_CLK2_50 (clk),
    .FPGA_CLK3_50 (clk),
    
    .LED,
    
    .HPS_DDR3_ADDR,
    .HPS_DDR3_BA,
    .HPS_DDR3_CAS_N,
    .HPS_DDR3_CKE,
    .HPS_DDR3_CK_N,
    .HPS_DDR3_CK_P,
    .HPS_DDR3_CS_N,
    .HPS_DDR3_DM,
    .HPS_DDR3_DQ,
    .HPS_DDR3_DQS_N,
    .HPS_DDR3_DQS_P,
    .HPS_DDR3_ODT,
    .HPS_DDR3_RAS_N,
    .HPS_DDR3_RESET_N,
    .HPS_DDR3_RZQ,
    .HPS_DDR3_WE_N,
    
    .KEY,
    
    .SW,
    
    .ADC_CONVST,
    .ADC_SCK,
    .ADC_SDI,
    .ADC_SDO,
    
    .GPIO_0_00,
    .GPIO_0_01, //UART GND
    .GPIO_0_02,
    .GPIO_0_03, //UART RXD
    .GPIO_0_04,
    .GPIO_0_05, //UART TXD
    .GPIO_0_06,
    .GPIO_0_07, //UART CTS
    .GPIO_0_08,
    .GPIO_0_09, //UART RTS
    .GPIO_0_10,
    .GPIO_0_11,
    .GPIO_0_12,
    .GPIO_0_13,
    .GPIO_0_14,
    .GPIO_0_15,
    .GPIO_0_16,
    .GPIO_0_17,
    .GPIO_0_18,
    .GPIO_0_19,
    .GPIO_0_20,
    .GPIO_0_21,
    .GPIO_0_22,
    .GPIO_0_23,
    .GPIO_0_24,
    .GPIO_0_25,
    .GPIO_0_26,
    .GPIO_0_27,
    .GPIO_0_28,
    .GPIO_0_29,
    .GPIO_0_30,
    .GPIO_0_31,
    .GPIO_0_32,
    .GPIO_0_33,
    .GPIO_0_34,
    .GPIO_0_35,
    
    .GPIO_1_00,
    .GPIO_1_01,
    .GPIO_1_02,
    .GPIO_1_03,
    .GPIO_1_04,
    .GPIO_1_05,
    .GPIO_1_06,
    .GPIO_1_07,
    .GPIO_1_08,
    .GPIO_1_09,
    .GPIO_1_10,
    .GPIO_1_11,
    .GPIO_1_12,
    .GPIO_1_13,
    .GPIO_1_14,
    .GPIO_1_15,
    .GPIO_1_16,
    .GPIO_1_17,
    .GPIO_1_18,
    .GPIO_1_19,
    .GPIO_1_20,
    .GPIO_1_21,
    .GPIO_1_22,
    .GPIO_1_23,
    .GPIO_1_24,
    .GPIO_1_25,
    .GPIO_1_26,
    .GPIO_1_27,
    .GPIO_1_28,
    .GPIO_1_29,
    .GPIO_1_30,
    .GPIO_1_31,
    .GPIO_1_32,
    .GPIO_1_33,
    .GPIO_1_34,
    .GPIO_1_35,
    
    .ARDUINO_IO_00,
    .ARDUINO_IO_01,
    .ARDUINO_IO_02,
    .ARDUINO_IO_03,
    .ARDUINO_IO_04,
    .ARDUINO_IO_05,
    .ARDUINO_IO_06,
    .ARDUINO_IO_07,
    .ARDUINO_IO_08,
    .ARDUINO_IO_09,
    .ARDUINO_IO_10,
    .ARDUINO_IO_11,
    .ARDUINO_IO_12,
    .ARDUINO_IO_13,
    .ARDUINO_IO_14,
    .ARDUINO_IO_15,
    
    .ARDUINO_RESET_N (rst_n),
    
    .HDMI_I2C_SCL,
    .HDMI_I2C_SDA,
    .HDMI_I2S,
    .HDMI_LRCLK,
    .HDMI_MCLK,
    .HDMI_SCLK,
    .HDMI_TX_CLK,
    .HDMI_TX_DE,
    .HDMI_TX_D,
    .HDMI_TX_HS,
    .HDMI_TX_INT,
    .HDMI_TX_VS,
    
    .DDR3_CLK (ddr3_clk),
    .ddr3_avl_ready,       
    .ddr3_avl_addr,        
    .ddr3_avl_rdata_valid, 
    .ddr3_avl_rdata,       
    .ddr3_avl_wdata,       
    .ddr3_avl_read_req,    
    .ddr3_avl_write_req,   
    .ddr3_avl_size
  );    


  //===================================
  // Build
  //===================================
  function void build();
    svunit_ut = new(name);

    //my_ddr3 = new(/* New arguments if needed */);
  endfunction


  //===================================
  // Setup for running the Unit Tests
  //===================================
  task setup();
    svunit_ut.setup();
    /* Place Setup Code Here */
    fork
      reset();
      ddr3_reset();
    join

  endtask


  //===================================
  // Here we deconstruct anything we 
  // need after running the Unit Tests
  //===================================
  task teardown();
    svunit_ut.teardown();
    /* Place Teardown Code Here */
    step();

  endtask


  initial
    begin
    $dumpfile("sim.vcd");
    //$dumpvars();
    $dumpvars(100, de10nano);
    end

  //===================================
  // All tests are defined between the
  // SVUNIT_TESTS_BEGIN/END macros
  //
  // Each individual test must be
  // defined between `SVTEST(_NAME_)
  // `SVTEST_END
  //
  // i.e.
  //   `SVTEST(mytest)
  //     <test code>
  //   `SVTEST_END
  //===================================

  `SVUNIT_TESTS_BEGIN

  `SVTEST(TEST)
  $readmemh("../../output/programs/bootloader/bootloader_3.v", de10nano.mem.mem_array_3);
  $readmemh("../../output/programs/bootloader/bootloader_2.v", de10nano.mem.mem_array_2);
  $readmemh("../../output/programs/bootloader/bootloader_1.v", de10nano.mem.mem_array_1);
  $readmemh("../../output/programs/bootloader/bootloader_0.v", de10nano.mem.mem_array_0);
  step(100);
  `SVTEST_END


  `SVUNIT_TESTS_END

endmodule
