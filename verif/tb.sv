`timescale 1ns / 1ns

module tb ();

//////////// CLOCK //////////
logic           FPGA_CLK1_50;
logic           FPGA_CLK2_50;
logic           FPGA_CLK3_50;
logic           DDR3_CLK;

//////////// LED //////////
logic  [7:0]    LED;

//////////// KEY //////////
logic  [1:0]    KEY;

//////////// SW //////////
logic  [3:0]    SW;

//////////// ADC //////////
logic           ADC_CONVST;
logic           ADC_SCK;
logic           ADC_SDI;
logic           ADC_SDO;

//////////// ARDUINO //////////
logic           SD_CS; 
logic           LCD_DC;
logic           LCD_CS;
logic           MOSI;  
logic           MISO;  
logic           SCK;   
logic           GND;   
logic           ARDUINO_RESET_N;

//////////// HDMI //////////
logic           HDMI_I2C_SCL;
logic           HDMI_I2C_SDA;
logic           HDMI_I2S;
logic           HDMI_LRCLK;
logic           HDMI_MCLK;
logic           HDMI_SCLK;
logic           HDMI_TX_CLK;
logic           HDMI_TX_DE;
logic  [23:0]   HDMI_TX_D;
logic           HDMI_TX_HS;
logic           HDMI_TX_INT;
logic           HDMI_TX_VS;

//////////// GPIO_0, GPIO connect to GPIO Default //////////
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

//////////// GPIO_1, GPIO connect to GPIO Default //////////
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

/////////// SOC ///////////
logic         ddr3_avl_ready;       
logic [25:0]  ddr3_avl_addr;        
logic         ddr3_avl_rdata_valid; 
logic [127:0] ddr3_avl_rdata;       
logic [127:0] ddr3_avl_wdata;       
logic         ddr3_avl_read_req;    
logic         ddr3_avl_write_req;   
logic [8:0]   ddr3_avl_size;        

logic clk;
logic rst;

`ifdef RISCV_FORMAL
logic [5:0]   rvfi_valid;
logic [383:0] rvfi_order;
logic [191:0] rvfi_insn;
logic [5:0]   rvfi_trap;
logic [5:0]   rvfi_halt;
logic [5:0]   rvfi_intr;
logic [11:0]  rvfi_mode;
logic [11:0]  rvfi_ixl;
logic [29:0]  rvfi_rs1_addr;
logic [29:0]  rvfi_rs2_addr;
logic [191:0] rvfi_rs1_rdata;
logic [191:0] rvfi_rs2_rdata;
logic [29:0]  rvfi_rd_addr;
logic [191:0] rvfi_rd_wdata;
logic [191:0] rvfi_pc_rdata;
logic [191:0] rvfi_pc_wdata;
logic [191:0] rvfi_mem_addr;
logic [23:0]  rvfi_mem_rmask;
logic [23:0]  rvfi_mem_wmask;
logic [191:0] rvfi_mem_rdata;
logic [191:0] rvfi_mem_wdata;
logic [5:0]   rvfi_mem_extamo;
logic [383:0] rvfi_csr_mcycle_rmask;
logic [383:0] rvfi_csr_mcycle_wmask;
logic [383:0] rvfi_csr_mcycle_rdata;
logic [383:0] rvfi_csr_mcycle_wdata;
logic [383:0] rvfi_csr_minstret_rmask;
logic [383:0] rvfi_csr_minstret_wmask;
logic [383:0] rvfi_csr_minstret_rdata;
logic [383:0] rvfi_csr_minstret_wdata;
`endif

logic [15:0] errcode;

logic reset_en;
logic reset_n;

assign ARDUINO_RESET_N = (reset_en)? reset_n : 'hz;

top dut (

//////////// CLOCK //////////
.FPGA_CLK1_50,
.FPGA_CLK2_50,
.FPGA_CLK3_50,
.DDR3_CLK,

//////////// LED //////////
.LED,

//////////// KEY //////////
.KEY,

//////////// SW //////////
.SW,

//////////// ADC //////////
.ADC_CONVST,
.ADC_SCK,
.ADC_SDI,
.ADC_SDO,

//////////// ARDUINO //////////
.ARDUINO_IO_00 (),
.ARDUINO_IO_01 (),
.ARDUINO_IO_02 (),
.ARDUINO_IO_03 (),
.ARDUINO_IO_04 (TP_CS),
.ARDUINO_IO_05 (SD_CS),
.ARDUINO_IO_06 (),
.ARDUINO_IO_07 (LCD_DC),
.ARDUINO_IO_08 (LCD_RST),
.ARDUINO_IO_09 (LCD_BL),
.ARDUINO_IO_10 (LCD_CS),
.ARDUINO_IO_11 (MOSI),
.ARDUINO_IO_12 (MISO),
.ARDUINO_IO_13 (SCLK),
.ARDUINO_IO_14 (GND),
.ARDUINO_IO_15 (),
.ARDUINO_RESET_N,

//////////// HDMI //////////
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

//////////// GPIO_0, GPIO connect to GPIO Default //////////
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

//////////// GPIO_1, GPIO connect to GPIO Default //////////
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

/////////// SOC ///////////
.ddr3_avl_ready,       
.ddr3_avl_addr,        
.ddr3_avl_rdata_valid, 
.ddr3_avl_rdata,       
.ddr3_avl_wdata,       
.ddr3_avl_read_req,    
.ddr3_avl_write_req,   
.ddr3_avl_size        

`ifdef RISCV_FORMAL
                        ,
.rvfi_valid             ,
.rvfi_order             ,
.rvfi_insn              ,
.rvfi_trap              ,
.rvfi_halt              ,
.rvfi_intr              ,
.rvfi_mode              ,
.rvfi_ixl               ,
.rvfi_rs1_addr          ,
.rvfi_rs2_addr          ,
.rvfi_rs1_rdata         ,
.rvfi_rs2_rdata         ,
.rvfi_rd_addr           ,
.rvfi_rd_wdata          ,
.rvfi_pc_rdata          ,
.rvfi_pc_wdata          ,
.rvfi_mem_addr          ,
.rvfi_mem_rmask         ,
.rvfi_mem_wmask         ,
.rvfi_mem_rdata         ,
.rvfi_mem_wdata         ,
                        
.rvfi_csr_mcycle_rmask  ,
.rvfi_csr_mcycle_wmask  ,
.rvfi_csr_mcycle_rdata  ,
.rvfi_csr_mcycle_wdata  ,
                        
.rvfi_csr_minstret_rmask,
.rvfi_csr_minstret_wmask,
.rvfi_csr_minstret_rdata,
.rvfi_csr_minstret_wdata,

.clk,
.rst
`endif
);

ddr3_model ddr3 (
  .clk                  (DDR3_CLK),
  .ddr3_avl_ready       (ddr3_avl_ready),       
  .ddr3_avl_addr        (ddr3_avl_addr),        
  .ddr3_avl_rdata_valid (ddr3_avl_rdata_valid), 
  .ddr3_avl_rdata       (ddr3_avl_rdata),       
  .ddr3_avl_wdata       (ddr3_avl_wdata),       
  .ddr3_avl_read_req    (ddr3_avl_read_req),    
  .ddr3_avl_write_req   (ddr3_avl_write_req),   
  .ddr3_avl_size        (ddr3_avl_size)        
);

spi_sd_model sd (
  .rstn  (ARDUINO_RESET_N),
  .ncs   (SD_CS),
  .sclk  (SCLK),
  .mosi  (MOSI),
  .miso  (MISO)
);

`ifdef RISCV_FORMAL
riscv_rvfimon monitor (
  .clock(clk),
  .reset(rst),
  .rvfi_valid,
  .rvfi_order,
  .rvfi_insn,
  .rvfi_trap,
  .rvfi_halt,
  .rvfi_intr,
  .rvfi_mode,
  .rvfi_rs1_addr,
  .rvfi_rs2_addr,
  .rvfi_rs1_rdata,
  .rvfi_rs2_rdata,
  .rvfi_rd_addr,
  .rvfi_rd_wdata,
  .rvfi_pc_rdata,
  .rvfi_pc_wdata,
  .rvfi_mem_addr,
  .rvfi_mem_rmask,
  .rvfi_mem_wmask,
  .rvfi_mem_rdata,
  .rvfi_mem_wdata,
  .rvfi_mem_extamo,
  .errcode
);
`endif

//initial
//  begin
//    $readmemh("../../tests/timer_3.v", dut.mem.mem_array_3);
//    $readmemh("../../tests/timer_2.v", dut.mem.mem_array_2);
//    $readmemh("../../tests/timer_1.v", dut.mem.mem_array_1);
//    $readmemh("../../tests/timer_0.v", dut.mem.mem_array_0);
//  end

initial
  begin
  $readmemh("../../output/programs//benchmarks/primes.v", ddr3.ddr3);
  end

initial 
  begin 
  FPGA_CLK1_50 = 0; 
  FPGA_CLK2_50 = 0; 
  FPGA_CLK3_50 = 0; 
  DDR3_CLK     = 0;
  KEY = '1;
  ADC_SDO = '0;
  reset_en = '1;
  reset_n = '1;
  #20
  reset_n = '0;
  KEY[0] = '0;
  #200
  reset_n = '1;
  KEY[0] = '1;
//  ARDUINO_RESET_N = 0; 
  end 

final
  begin
  $display("End of test");
  $display("  %0d Instructions", {dut.riscv.csrfile.csr_C82,dut.riscv.csrfile.csr_C02});
  $display("  %0.2f Instructions per Cycle",   1.0*({dut.riscv.csrfile.csr_C82,dut.riscv.csrfile.csr_C02})/({dut.riscv.csrfile.csr_C80,dut.riscv.csrfile.csr_C00}));
  $display("  %0.2fM Instructions per Second", 1.0*({dut.riscv.csrfile.csr_C82,dut.riscv.csrfile.csr_C02})/({dut.riscv.csrfile.csr_C80,dut.riscv.csrfile.csr_C00})*50);
  end
    
always 
  begin
  #10  
  FPGA_CLK1_50 =  ! FPGA_CLK1_50;
  FPGA_CLK2_50 =  ! FPGA_CLK2_50;
  FPGA_CLK3_50 =  ! FPGA_CLK3_50;
  end

always 
  begin
  #5  
  DDR3_CLK =  ! DDR3_CLK;
  end

logic uart_state_idle;
logic uart_state_something;
logic [3:0] uart_state_timer;
logic [11:0] uart_buffer;
initial
  begin
  uart_state_idle = '1;
  uart_state_something  = '0;
  uart_state_timer  = '0;
  end
always
  begin
  #120
  uart_state_idle <=        '0;
  uart_state_something  <=  '0;
  uart_state_timer  <=            uart_state_timer;             
  uart_buffer <= {uart_buffer[10:0],GPIO_0_05};
  case('1)
    uart_state_idle: begin
                     if(GPIO_0_05 == '0)
                       begin
                       //$write(GPIO_0_05);
                       uart_state_something <= '1;
                       end 
                     else
                       begin
                       uart_state_idle <= '1;
                       end 
                     end
    uart_state_something: begin
                     //$write(GPIO_0_05);
                     if(uart_state_timer == 'd10)
                       begin
                       //$display("");
                       //$display("%b",{uart_buffer[10:0],GPIO_0_05});
                       //$display("%h",{uart_buffer[2],
                       //               uart_buffer[3],
                       //               uart_buffer[4],
                       //               uart_buffer[5],
                       //               uart_buffer[6],
                       //               uart_buffer[7],
                       //               uart_buffer[8],
                       //               uart_buffer[9]});
                       //$display("%c",{uart_buffer[2],
                       //               uart_buffer[3],
                       //               uart_buffer[4],
                       //               uart_buffer[5],
                       //               uart_buffer[6],
                       //               uart_buffer[7],
                       //               uart_buffer[8],
                       //               uart_buffer[9]});
                       $write("%c",{uart_buffer[2],
                                    uart_buffer[3],
                                    uart_buffer[4],
                                    uart_buffer[5],
                                    uart_buffer[6],
                                    uart_buffer[7],
                                    uart_buffer[8],
                                    uart_buffer[9]});
                       uart_state_timer <= '0;
                       uart_state_idle <= '1;
                       end 
                     else
                       begin
                       uart_state_timer <= uart_state_timer + 1;
                       uart_state_something <= '1;
                       end 
                     end
  endcase
  end
//.GPIO_0_05, //UART TXD

endmodule
