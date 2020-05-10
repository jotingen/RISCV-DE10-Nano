import wishbone_pkg::*;

module top (

//////////// CLOCK //////////
input  logic           FPGA_CLK1_50,
input  logic           FPGA_CLK2_50,
input  logic           FPGA_CLK3_50,

//////////// LED //////////
output logic  [7:0]    LED,

//////////// HPS //////////
output logic [14:0]    HPS_DDR3_ADDR,
output logic  [2:0]    HPS_DDR3_BA,
output logic           HPS_DDR3_CAS_N,
output logic           HPS_DDR3_CKE,
output logic           HPS_DDR3_CK_N,
output logic           HPS_DDR3_CK_P,
output logic           HPS_DDR3_CS_N,
output logic  [3:0]    HPS_DDR3_DM,
inout  logic [31:0]    HPS_DDR3_DQ,
inout  logic  [3:0]    HPS_DDR3_DQS_N,
inout  logic  [3:0]    HPS_DDR3_DQS_P,
output logic           HPS_DDR3_ODT,
output logic           HPS_DDR3_RAS_N,
output logic           HPS_DDR3_RESET_N,
input  logic           HPS_DDR3_RZQ,
output logic           HPS_DDR3_WE_N,

//////////// KEY //////////
input  logic  [1:0]    KEY,

//////////// SW //////////
input  logic  [3:0]    SW,

//////////// ADC //////////
output logic           ADC_CONVST,
output logic           ADC_SCK,
output logic           ADC_SDI,
input  logic           ADC_SDO,

//////////// GPIO_0, GPIO connect to GPIO Default //////////
`ifdef SIM
output logic           GPIO_0_00,
output logic           GPIO_0_01, //UART GND
output logic           GPIO_0_02,
input  logic           GPIO_0_03, //UART RXD
output logic           GPIO_0_04,
output logic           GPIO_0_05, //UART TXD
output logic           GPIO_0_06,
output logic           GPIO_0_07, //UART CTS
output logic           GPIO_0_08,
input  logic           GPIO_0_09, //UART RTS
output logic           GPIO_0_10,
output logic           GPIO_0_11,
output logic           GPIO_0_12,
output logic           GPIO_0_13,
output logic           GPIO_0_14,
output logic           GPIO_0_15,
output logic           GPIO_0_16,
output logic           GPIO_0_17,
output logic           GPIO_0_18,
output logic           GPIO_0_19,
output logic           GPIO_0_20,
output logic           GPIO_0_21,
output logic           GPIO_0_22,
output logic           GPIO_0_23,
output logic           GPIO_0_24,
output logic           GPIO_0_25,
output logic           GPIO_0_26,
output logic           GPIO_0_27,
output logic           GPIO_0_28,
output logic           GPIO_0_29,
output logic           GPIO_0_30,
output logic           GPIO_0_31,
output logic           GPIO_0_32,
output logic           GPIO_0_33,
output logic           GPIO_0_34,
output logic           GPIO_0_35,
`else
inout  logic           GPIO_0_00,
inout  logic           GPIO_0_01,
inout  logic           GPIO_0_02,
inout  logic           GPIO_0_03,
inout  logic           GPIO_0_04,
inout  logic           GPIO_0_05,
inout  logic           GPIO_0_06,
inout  logic           GPIO_0_07,
inout  logic           GPIO_0_08,
inout  logic           GPIO_0_09,
inout  logic           GPIO_0_10,
inout  logic           GPIO_0_11,
inout  logic           GPIO_0_12,
inout  logic           GPIO_0_13,
inout  logic           GPIO_0_14,
inout  logic           GPIO_0_15,
inout  logic           GPIO_0_16,
inout  logic           GPIO_0_17,
inout  logic           GPIO_0_18,
inout  logic           GPIO_0_19,
inout  logic           GPIO_0_20,
inout  logic           GPIO_0_21,
inout  logic           GPIO_0_22,
inout  logic           GPIO_0_23,
inout  logic           GPIO_0_24,
inout  logic           GPIO_0_25,
inout  logic           GPIO_0_26,
inout  logic           GPIO_0_27,
inout  logic           GPIO_0_28,
inout  logic           GPIO_0_29,
inout  logic           GPIO_0_30,
inout  logic           GPIO_0_31,
inout  logic           GPIO_0_32,
inout  logic           GPIO_0_33,
inout  logic           GPIO_0_34,
inout  logic           GPIO_0_35,
`endif

//////////// GPIO_1, GPIO connect to GPIO Default //////////
`ifdef SIM
output logic           GPIO_1_00,
output logic           GPIO_1_01,
output logic           GPIO_1_02,
output logic           GPIO_1_03,
output logic           GPIO_1_04,
output logic           GPIO_1_05,
output logic           GPIO_1_06,
output logic           GPIO_1_07,
output logic           GPIO_1_08,
output logic           GPIO_1_09,
output logic           GPIO_1_10,
output logic           GPIO_1_11,
output logic           GPIO_1_12,
output logic           GPIO_1_13,
output logic           GPIO_1_14,
output logic           GPIO_1_15,
output logic           GPIO_1_16,
output logic           GPIO_1_17,
output logic           GPIO_1_18,
output logic           GPIO_1_19,
output logic           GPIO_1_20,
output logic           GPIO_1_21,
output logic           GPIO_1_22,
output logic           GPIO_1_23,
output logic           GPIO_1_24,
output logic           GPIO_1_25,
output logic           GPIO_1_26,
output logic           GPIO_1_27,
output logic           GPIO_1_28,
output logic           GPIO_1_29,
output logic           GPIO_1_30,
output logic           GPIO_1_31,
output logic           GPIO_1_32,
output logic           GPIO_1_33,
output logic           GPIO_1_34,
output logic           GPIO_1_35,
`else
inout  logic           GPIO_1_00,
inout  logic           GPIO_1_01,
inout  logic           GPIO_1_02,
inout  logic           GPIO_1_03,
inout  logic           GPIO_1_04,
inout  logic           GPIO_1_05,
inout  logic           GPIO_1_06,
inout  logic           GPIO_1_07,
inout  logic           GPIO_1_08,
inout  logic           GPIO_1_09,
inout  logic           GPIO_1_10,
inout  logic           GPIO_1_11,
inout  logic           GPIO_1_12,
inout  logic           GPIO_1_13,
inout  logic           GPIO_1_14,
inout  logic           GPIO_1_15,
inout  logic           GPIO_1_16,
inout  logic           GPIO_1_17,
inout  logic           GPIO_1_18,
inout  logic           GPIO_1_19,
inout  logic           GPIO_1_20,
inout  logic           GPIO_1_21,
inout  logic           GPIO_1_22,
inout  logic           GPIO_1_23,
inout  logic           GPIO_1_24,
inout  logic           GPIO_1_25,
inout  logic           GPIO_1_26,
inout  logic           GPIO_1_27,
inout  logic           GPIO_1_28,
inout  logic           GPIO_1_29,
inout  logic           GPIO_1_30,
inout  logic           GPIO_1_31,
inout  logic           GPIO_1_32,
inout  logic           GPIO_1_33,
inout  logic           GPIO_1_34,
inout  logic           GPIO_1_35,
`endif

//////////// ARDUINO //////////
`ifdef SIM
output logic           ARDUINO_IO_00,
output logic           ARDUINO_IO_01,
output logic           ARDUINO_IO_02,
output logic           ARDUINO_IO_03,
output logic           ARDUINO_IO_04,
output logic           ARDUINO_IO_05,
output logic           ARDUINO_IO_06,
output logic           ARDUINO_IO_07,
output logic           ARDUINO_IO_08,
output logic           ARDUINO_IO_09,
output logic           ARDUINO_IO_10,
output logic           ARDUINO_IO_11,
input  logic           ARDUINO_IO_12,
output logic           ARDUINO_IO_13,
output logic           ARDUINO_IO_14,
output logic           ARDUINO_IO_15,
`else
inout  logic           ARDUINO_IO_00,
inout  logic           ARDUINO_IO_01,
inout  logic           ARDUINO_IO_02,
inout  logic           ARDUINO_IO_03,
inout  logic           ARDUINO_IO_04,
inout  logic           ARDUINO_IO_05,
inout  logic           ARDUINO_IO_06,
inout  logic           ARDUINO_IO_07,
inout  logic           ARDUINO_IO_08,
inout  logic           ARDUINO_IO_09,
inout  logic           ARDUINO_IO_10,
inout  logic           ARDUINO_IO_11,
inout  logic           ARDUINO_IO_12,
inout  logic           ARDUINO_IO_13,
inout  logic           ARDUINO_IO_14,
inout  logic           ARDUINO_IO_15,
`endif

inout  logic           ARDUINO_RESET_N,

//////////// HDMI //////////
inout  logic           HDMI_I2C_SCL,
inout  logic           HDMI_I2C_SDA,
inout  logic           HDMI_I2S,
inout  logic           HDMI_LRCLK,
inout  logic           HDMI_MCLK,
inout  logic           HDMI_SCLK,
output logic           HDMI_TX_CLK,
output logic           HDMI_TX_DE,
output logic  [23:0]   HDMI_TX_D,
output logic           HDMI_TX_HS,
input  logic           HDMI_TX_INT,
output logic           HDMI_TX_VS

`ifdef RISCV_FORMAL
  ,
  output reg   [5:0]       rvfi_valid,
  output reg   [5:0][63:0] rvfi_order,
  output reg   [5:0][31:0] rvfi_insn,
  output reg   [5:0]       rvfi_trap,
  output reg   [5:0]       rvfi_halt,
  output reg   [5:0]       rvfi_intr,
  output reg   [5:0][ 1:0] rvfi_mode,
  output reg   [5:0][ 1:0] rvfi_ixl,
  output reg   [5:0][ 4:0] rvfi_rs1_addr,
  output reg   [5:0][ 4:0] rvfi_rs2_addr,
  output reg   [5:0][31:0] rvfi_rs1_rdata,
  output reg   [5:0][31:0] rvfi_rs2_rdata,
  output reg   [5:0][ 4:0] rvfi_rd_addr,
  output reg   [5:0][31:0] rvfi_rd_wdata,
  output reg   [5:0][31:0] rvfi_pc_rdata,
  output reg   [5:0][31:0] rvfi_pc_wdata,
  output reg   [5:0][31:0] rvfi_mem_addr,
  output reg   [5:0][ 3:0] rvfi_mem_rmask,
  output reg   [5:0][ 3:0] rvfi_mem_wmask,
  output reg   [5:0][31:0] rvfi_mem_rdata,
  output reg   [5:0][31:0] rvfi_mem_wdata,

  output reg   [5:0][63:0] rvfi_csr_mcycle_rmask,
  output reg   [5:0][63:0] rvfi_csr_mcycle_wmask,
  output reg   [5:0][63:0] rvfi_csr_mcycle_rdata,
  output reg   [5:0][63:0] rvfi_csr_mcycle_wdata,

  output reg   [5:0][63:0] rvfi_csr_minstret_rmask,
  output reg   [5:0][63:0] rvfi_csr_minstret_wmask,
  output reg   [5:0][63:0] rvfi_csr_minstret_rdata,
  output reg   [5:0][63:0] rvfi_csr_minstret_wdata,
  output logic clk,
  output logic rst
`endif

`ifdef SIM
  ,
  input  logic         DDR3_CLK,  //100MHz
  input  logic         ddr3_avl_ready,       
  output logic [25:0]  ddr3_avl_addr,        
  input  logic         ddr3_avl_rdata_valid, 
  input  logic [127:0] ddr3_avl_rdata,       
  output logic [127:0] ddr3_avl_wdata,       
  output logic         ddr3_avl_read_req,    
  output logic         ddr3_avl_write_req,   
  output logic [8:0]   ddr3_avl_size         
`endif
);

`ifndef RISCV_FORMAL
  logic clk;
  logic rst;
`endif

wishbone_pkg::bus_req_t riscv_mmc_inst;
wishbone_pkg::bus_rsp_t mmc_riscv_inst;

wishbone_pkg::bus_req_t mmc_mem_inst;
wishbone_pkg::bus_rsp_t mem_mmc_inst;

wishbone_pkg::bus_req_t mmc_ddr3_inst;
wishbone_pkg::bus_rsp_t ddr3_mmc_inst;

wishbone_pkg::bus_req_t mmc_led_inst;
wishbone_pkg::bus_rsp_t led_mmc_inst;

wishbone_pkg::bus_req_t mmc_keys_inst;
wishbone_pkg::bus_rsp_t keys_mmc_inst;

wishbone_pkg::bus_req_t mmc_uart_inst;
wishbone_pkg::bus_rsp_t uart_mmc_inst;

wishbone_pkg::bus_req_t mmc_touchpad_inst;
wishbone_pkg::bus_rsp_t touchpad_mmc_inst;

wishbone_pkg::bus_req_t mmc_display_inst;
wishbone_pkg::bus_rsp_t display_mmc_inst;

wishbone_pkg::bus_req_t mmc_displaybuff_inst;
wishbone_pkg::bus_rsp_t displaybuff_mmc_inst;

wishbone_pkg::bus_req_t mmc_consolebuff_inst;
wishbone_pkg::bus_rsp_t consolebuff_mmc_inst;

wishbone_pkg::bus_req_t mmc_sdcard_inst;
wishbone_pkg::bus_rsp_t sdcard_mmc_inst;

wishbone_pkg::bus_req_t riscv_mmc_data;
wishbone_pkg::bus_rsp_t mmc_riscv_data;

wishbone_pkg::bus_req_t mmc_mem_data;
wishbone_pkg::bus_rsp_t mem_mmc_data;

wishbone_pkg::bus_req_t mmc_ddr3_data;
wishbone_pkg::bus_rsp_t ddr3_mmc_data;

wishbone_pkg::bus_req_t mmc_led_data;
wishbone_pkg::bus_rsp_t led_mmc_data;

wishbone_pkg::bus_req_t mmc_keys_data;
wishbone_pkg::bus_rsp_t keys_mmc_data;

wishbone_pkg::bus_req_t mmc_uart_data;
wishbone_pkg::bus_rsp_t uart_mmc_data;

wishbone_pkg::bus_req_t mmc_touchpad_data;
wishbone_pkg::bus_rsp_t touchpad_mmc_data;

wishbone_pkg::bus_req_t mmc_display_data;
wishbone_pkg::bus_rsp_t display_mmc_data;

wishbone_pkg::bus_req_t mmc_displaybuff_data;
wishbone_pkg::bus_rsp_t displaybuff_mmc_data;

wishbone_pkg::bus_req_t mmc_consolebuff_data;
wishbone_pkg::bus_rsp_t consolebuff_mmc_data;

wishbone_pkg::bus_req_t mmc_sdcard_data;
wishbone_pkg::bus_rsp_t sdcard_mmc_data;


`ifndef SIM
logic         DDR3_CLK;  //100MHz
logic         ddr3_avl_ready;                  //          	 .avl.waitrequest
logic [25:0]  ddr3_avl_addr;                   //             .address
logic         ddr3_avl_rdata_valid;            //             .readdatavalid
logic [127:0] ddr3_avl_rdata;                  //             .readdata
logic [127:0] ddr3_avl_wdata;                  //             .writedata
logic         ddr3_avl_read_req;               //             .read
logic         ddr3_avl_write_req;              //             .write
logic [8:0]   ddr3_avl_size;                   //             .burstcount
`endif

logic arst;
logic arst_1;
logic arst_2;
logic arst_3;

always @(posedge clk)
  begin
  //arst_1 <= arst;  //Reset pin got shocked and is burned out, using key0
  arst_1 <= ~KEY[0];
  arst_2 <= arst_1;
  arst_3 <= arst_2;
  rst    <= arst_3;
  end  

  
//PLL pll (
//  .inclk0 (FPGA_CLK1_50),
//  .c0     (clk),
//  .locked ()
//);
assign clk = FPGA_CLK1_50;


//HDMI TMP
assign HDMI_TX_CLK = '0;
assign HDMI_TX_DE  = '0;
assign HDMI_TX_D   = '0;
assign HDMI_TX_HS  = '0;
assign HDMI_TX_VS  = '0;

riscv #(.M_EXT(1)) riscv (
  .clk         (clk),
  .rst         (rst),

  .bus_inst_flat_o  (riscv_mmc_inst), 
  .bus_inst_flat_i  (mmc_riscv_inst), 

  .bus_data_flat_o  (riscv_mmc_data), 
  .bus_data_flat_i  (mmc_riscv_data) 

`ifdef RISCV_FORMAL
  ,
  .rvfi_valid              (rvfi_valid             ),
  .rvfi_order              (rvfi_order             ),
  .rvfi_insn               (rvfi_insn              ),
  .rvfi_trap               (rvfi_trap              ),
  .rvfi_halt               (rvfi_halt              ),
  .rvfi_intr               (rvfi_intr              ),
  .rvfi_mode               (rvfi_mode              ),
  .rvfi_ixl                (rvfi_ixl               ),
  .rvfi_rs1_addr           (rvfi_rs1_addr          ),
  .rvfi_rs2_addr           (rvfi_rs2_addr          ),
  .rvfi_rs1_rdata          (rvfi_rs1_rdata         ),
  .rvfi_rs2_rdata          (rvfi_rs2_rdata         ),
  .rvfi_rd_addr            (rvfi_rd_addr           ),
  .rvfi_rd_wdata           (rvfi_rd_wdata          ),
  .rvfi_pc_rdata           (rvfi_pc_rdata          ),
  .rvfi_pc_wdata           (rvfi_pc_wdata          ),
  .rvfi_mem_addr           (rvfi_mem_addr          ),
  .rvfi_mem_rmask          (rvfi_mem_rmask         ),
  .rvfi_mem_wmask          (rvfi_mem_wmask         ),
  .rvfi_mem_rdata          (rvfi_mem_rdata         ),
  .rvfi_mem_wdata          (rvfi_mem_wdata         ),
                                                              
  .rvfi_csr_mcycle_rmask   (rvfi_csr_mcycle_rmask  ),
  .rvfi_csr_mcycle_wmask   (rvfi_csr_mcycle_wmask  ),
  .rvfi_csr_mcycle_rdata   (rvfi_csr_mcycle_rdata  ),
  .rvfi_csr_mcycle_wdata   (rvfi_csr_mcycle_wdata  ),
                                                              
  .rvfi_csr_minstret_rmask (rvfi_csr_minstret_rmask),
  .rvfi_csr_minstret_wmask (rvfi_csr_minstret_wmask),
  .rvfi_csr_minstret_rdata (rvfi_csr_minstret_rdata),
  .rvfi_csr_minstret_wdata (rvfi_csr_minstret_wdata)
`endif
);

  mmc_wb mmc_inst (
    .clk         (clk),
    .rst         (rst),
    
    .riscv_mmc_flat_i  (riscv_mmc_inst),
    .mmc_riscv_flat_o  (mmc_riscv_inst),
  
    .mmc_mem_flat_o    (mmc_mem_inst),
    .mem_mmc_flat_i    (mem_mmc_inst),
  
    .mmc_ddr3_flat_o   (mmc_ddr3_inst),
    .ddr3_mmc_flat_i   (ddr3_mmc_inst),
  
    .mmc_led_flat_o    (mmc_led_inst),
    .led_mmc_flat_i    (led_mmc_inst),
  
    .mmc_keys_flat_o   (mmc_keys_inst),
    .keys_mmc_flat_i   (keys_mmc_inst),
  
    .mmc_uart_flat_o   (mmc_uart_inst),
    .uart_mmc_flat_i   (uart_mmc_inst),
  
    .mmc_sdcard_flat_o (mmc_sdcard_inst),
    .sdcard_mmc_flat_i (sdcard_mmc_inst)
  );
  
  mmc_wb mmc_data (
    .clk         (clk),
    .rst         (rst),
    
    .riscv_mmc_flat_i  (riscv_mmc_data),
    .mmc_riscv_flat_o  (mmc_riscv_data),
  
    .mmc_mem_flat_o    (mmc_mem_data),
    .mem_mmc_flat_i    (mem_mmc_data),
  
    .mmc_ddr3_flat_o   (mmc_ddr3_data),
    .ddr3_mmc_flat_i   (ddr3_mmc_data),
  
    .mmc_led_flat_o    (mmc_led_data),
    .led_mmc_flat_i    (led_mmc_data),
  
    .mmc_keys_flat_o   (mmc_keys_data),
    .keys_mmc_flat_i   (keys_mmc_data),
  
    .mmc_uart_flat_o   (mmc_uart_data),
    .uart_mmc_flat_i   (uart_mmc_data),
  
    .mmc_sdcard_flat_o (mmc_sdcard_data),
    .sdcard_mmc_flat_i (sdcard_mmc_data)
  );
  
  mem mem (
    .clk         (clk),
    .rst         (rst),
  
    .bus_inst_flat_i                (mmc_mem_inst),
    .bus_inst_flat_o                (mem_mmc_inst),   
  
    .bus_data_flat_i                (mmc_mem_data),
    .bus_data_flat_o                (mem_mmc_data)
  );
  
  ddr3 ddr3 (
    .clk         (clk),
    .ddr3_clk    (DDR3_CLK),
    .rst         (rst),
  
    .ddr3_avl_ready         (ddr3_avl_ready),       
    .ddr3_avl_addr          (ddr3_avl_addr),        
    .ddr3_avl_rdata_valid   (ddr3_avl_rdata_valid), 
    .ddr3_avl_rdata         (ddr3_avl_rdata),       
    .ddr3_avl_wdata         (ddr3_avl_wdata),       
    .ddr3_avl_read_req      (ddr3_avl_read_req),    
    .ddr3_avl_write_req     (ddr3_avl_write_req),   
    .ddr3_avl_size          (ddr3_avl_size),         
  
    .bus_inst_flat_i                (mmc_ddr3_inst),
    .bus_inst_flat_o                (ddr3_mmc_inst),   
  
    .bus_data_flat_i                (mmc_ddr3_data),
    .bus_data_flat_o                (ddr3_mmc_data)
  );
  
  led #(.SIZE(5),.ADDR_BASE(32'h00000000)) led (
    .clk         (clk),
    .rst         (rst),
  
    .LED         (LED),
  
    .bus_data_flat_i                (mmc_led_data),
    .bus_data_flat_o                (led_mmc_data)    
  );
  
  keys #(.SIZE(5),.ADDR_BASE(32'hC0000000)) keys (
    .clk         (clk),
    .rst         (rst),
  
    .KEY         (KEY),
  
    .bus_data_flat_i                (mmc_keys_data),
    .bus_data_flat_o                (keys_mmc_data)    
  );
  
  uart uart (
    .clk (clk),
    .rst (rst),
    
    .GND (GPIO_0_01),
    .TXD (GPIO_0_05),
    .RXD (GPIO_0_03),
    .CTS (GPIO_0_09),
    .RTS (GPIO_0_07),
  
    .bus_data_flat_i                (mmc_uart_data),
    .bus_data_flat_o                (uart_mmc_data)    
  );
  
  waveshare_tft_touch_shield shield (
    .clk (FPGA_CLK1_50),
    .rst (rst),
  
    .arst (arst),
  
    .ADC_CONVST      (ADC_CONVST),     
    .ADC_SCK         (ADC_SCK),        
    .ADC_SDI         (ADC_SDI),        
    .ADC_SDO         (ADC_SDO),        
                                      
    .ARDUINO_IO_00   (ARDUINO_IO_00),
    .ARDUINO_IO_01   (ARDUINO_IO_01),
    .ARDUINO_IO_02   (ARDUINO_IO_02),
    .ARDUINO_IO_03   (ARDUINO_IO_03),
    .ARDUINO_IO_04   (ARDUINO_IO_04),
    .ARDUINO_IO_05   (ARDUINO_IO_05),
    .ARDUINO_IO_06   (ARDUINO_IO_06),
    .ARDUINO_IO_07   (ARDUINO_IO_07),
    .ARDUINO_IO_08   (ARDUINO_IO_08),
    .ARDUINO_IO_09   (ARDUINO_IO_09),
    .ARDUINO_IO_10   (ARDUINO_IO_10),
    .ARDUINO_IO_11   (ARDUINO_IO_11),
    .ARDUINO_IO_12   (ARDUINO_IO_12),
    .ARDUINO_IO_13   (ARDUINO_IO_13),
    .ARDUINO_IO_14   (ARDUINO_IO_14),
    .ARDUINO_IO_15   (ARDUINO_IO_15),
    .ARDUINO_RESET_N (ARDUINO_RESET_N),
  
    .touchpad_data_flat_i                 (mmc_touchpad_data),  
    .touchpad_data_flat_o                 (touchpad_mmc_data),   
                                                                   
    .display_data_flat_i                (mmc_display_data),  
    .display_data_flat_o                (display_mmc_data),   
                                                                   
    .displaybuff_data_flat_i               (mmc_displaybuff_data),  
    .displaybuff_data_flat_o               (displaybuff_mmc_data),   
                                                                   
    .consolebuff_data_flat_i            (mmc_consolebuff_data),  
    .consolebuff_data_flat_o            (consolebuff_mmc_data),   
                                                                   
    .sdcard_data_flat_i                 (mmc_sdcard_data),  
    .sdcard_data_flat_o                 (sdcard_mmc_data)    
  );
  
  `ifndef SIM
  soc_system u0 (
    //Clock&Reset
    .clk_clk                               ( FPGA_CLK1_50 ),                               //                            clk.clk
    .ddr3_clk_clk                          ( DDR3_CLK ),                             //                    clk_ddr3.clk
    
    //HPS ddr3
    .memory_mem_a                          ( HPS_DDR3_ADDR),                       //                memory.mem_a
    .memory_mem_ba                         ( HPS_DDR3_BA),                         //                .mem_ba
    .memory_mem_ck                         ( HPS_DDR3_CK_P),                       //                .mem_ck
    .memory_mem_ck_n                       ( HPS_DDR3_CK_N),                       //                .mem_ck_n
    .memory_mem_cke                        ( HPS_DDR3_CKE),                        //                .mem_cke
    .memory_mem_cs_n                       ( HPS_DDR3_CS_N),                       //                .mem_cs_n
    .memory_mem_ras_n                      ( HPS_DDR3_RAS_N),                      //                .mem_ras_n
    .memory_mem_cas_n                      ( HPS_DDR3_CAS_N),                      //                .mem_cas_n
    .memory_mem_we_n                       ( HPS_DDR3_WE_N),                       //                .mem_we_n
    .memory_mem_reset_n                    ( HPS_DDR3_RESET_N),                    //                .mem_reset_n
    .memory_mem_dq                         ( HPS_DDR3_DQ),                         //                .mem_dq
    .memory_mem_dqs                        ( HPS_DDR3_DQS_P),                      //                .mem_dqs
    .memory_mem_dqs_n                      ( HPS_DDR3_DQS_N),                      //                .mem_dqs_n
    .memory_mem_odt                        ( HPS_DDR3_ODT),                        //                .mem_odt
    .memory_mem_dm                         ( HPS_DDR3_DM),                         //                .mem_dm
    .memory_oct_rzqin                      ( HPS_DDR3_RZQ),                        //                .oct_rzqin
    
    .ddr3_hps_f2h_sdram0_clock_clk          (DDR3_CLK),          // ddr3_0_hps_f2h_sdram0_clock.clk
    .ddr3_hps_f2h_sdram0_data_address       (ddr3_avl_addr),       //  ddr3_0_hps_f2h_sdram0_data.address
    .ddr3_hps_f2h_sdram0_data_read          (ddr3_avl_read_req),          //                            .read
    .ddr3_hps_f2h_sdram0_data_readdata      (ddr3_avl_rdata),      //                            .readdata
    .ddr3_hps_f2h_sdram0_data_write         (ddr3_avl_write_req),         //                            .write
    .ddr3_hps_f2h_sdram0_data_writedata     (ddr3_avl_wdata),     //                            .writedata
    .ddr3_hps_f2h_sdram0_data_readdatavalid (ddr3_avl_rdata_valid), //                            .readdatavalid
    .ddr3_hps_f2h_sdram0_data_waitrequest   (ddr3_avl_ready),   //                            .waitrequest
    .ddr3_hps_f2h_sdram0_data_byteenable    (16'hffff),    //                            .byteenable
    .ddr3_hps_f2h_sdram0_data_burstcount    (ddr3_avl_size)     //                            .burstcount
  );
  `endif
       
endmodule
