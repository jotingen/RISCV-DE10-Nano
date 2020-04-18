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

logic [31:0]      riscv_mmc_inst_adr;
logic [31:0]      riscv_mmc_inst_data;
logic             riscv_mmc_inst_we;
logic  [3:0]      riscv_mmc_inst_sel;
logic             riscv_mmc_inst_stb;
logic             riscv_mmc_inst_cyc;
logic             riscv_mmc_inst_tga;
logic             riscv_mmc_inst_tgd;
logic  [3:0]      riscv_mmc_inst_tgc;

logic             mmc_riscv_inst_ack;
logic             mmc_riscv_inst_stall;
logic             mmc_riscv_inst_err;
logic             mmc_riscv_inst_rty;
logic [31:0]      mmc_riscv_inst_data;
logic             mmc_riscv_inst_tga;
logic             mmc_riscv_inst_tgd;
logic  [3:0]      mmc_riscv_inst_tgc;

logic [31:0]      mmc_mem_inst_adr;
logic [31:0]      mmc_mem_inst_data;
logic             mmc_mem_inst_we;
logic  [3:0]      mmc_mem_inst_sel;
logic             mmc_mem_inst_stb;
logic             mmc_mem_inst_cyc;
logic             mmc_mem_inst_tga;
logic             mmc_mem_inst_tgd;
logic  [3:0]      mmc_mem_inst_tgc;

logic             mem_mmc_inst_ack;
logic             mem_mmc_inst_stall;
logic             mem_mmc_inst_err;
logic             mem_mmc_inst_rty;
logic [31:0]      mem_mmc_inst_data;
logic             mem_mmc_inst_tga;
logic             mem_mmc_inst_tgd;
logic  [3:0]      mem_mmc_inst_tgc;

logic [31:0]      mmc_ddr3_inst_adr;
logic [31:0]      mmc_ddr3_inst_data;
logic             mmc_ddr3_inst_we;
logic  [3:0]      mmc_ddr3_inst_sel;
logic             mmc_ddr3_inst_stb;
logic             mmc_ddr3_inst_cyc;
logic             mmc_ddr3_inst_tga;
logic             mmc_ddr3_inst_tgd;
logic  [3:0]      mmc_ddr3_inst_tgc;

logic             ddr3_mmc_inst_ack;
logic             ddr3_mmc_inst_stall;
logic             ddr3_mmc_inst_err;
logic             ddr3_mmc_inst_rty;
logic [31:0]      ddr3_mmc_inst_data;
logic             ddr3_mmc_inst_tga;
logic             ddr3_mmc_inst_tgd;
logic  [3:0]      ddr3_mmc_inst_tgc;

logic [31:0]      mmc_led_inst_adr;
logic [31:0]      mmc_led_inst_data;
logic             mmc_led_inst_we;
logic  [3:0]      mmc_led_inst_sel;
logic             mmc_led_inst_stb;
logic             mmc_led_inst_cyc;
logic             mmc_led_inst_tga;
logic             mmc_led_inst_tgd;
logic  [3:0]      mmc_led_inst_tgc;

logic             led_mmc_inst_ack;
logic             led_mmc_inst_stall;
logic             led_mmc_inst_err;
logic             led_mmc_inst_rty;
logic [31:0]      led_mmc_inst_data;
logic             led_mmc_inst_tga;
logic             led_mmc_inst_tgd;
logic  [3:0]      led_mmc_inst_tgc;

logic [31:0]      mmc_keys_inst_adr;
logic [31:0]      mmc_keys_inst_data;
logic             mmc_keys_inst_we;
logic  [3:0]      mmc_keys_inst_sel;
logic             mmc_keys_inst_stb;
logic             mmc_keys_inst_cyc;
logic             mmc_keys_inst_tga;
logic             mmc_keys_inst_tgd;
logic  [3:0]      mmc_keys_inst_tgc;

logic             keys_mmc_inst_ack;
logic             keys_mmc_inst_stall;
logic             keys_mmc_inst_err;
logic             keys_mmc_inst_rty;
logic [31:0]      keys_mmc_inst_data;
logic             keys_mmc_inst_tga;
logic             keys_mmc_inst_tgd;
logic  [3:0]      keys_mmc_inst_tgc;

logic [31:0]      mmc_uart_inst_adr;
logic [31:0]      mmc_uart_inst_data;
logic             mmc_uart_inst_we;
logic  [3:0]      mmc_uart_inst_sel;
logic             mmc_uart_inst_stb;
logic             mmc_uart_inst_cyc;
logic             mmc_uart_inst_tga;
logic             mmc_uart_inst_tgd;
logic  [3:0]      mmc_uart_inst_tgc;

logic             uart_mmc_inst_ack;
logic             uart_mmc_inst_stall;
logic             uart_mmc_inst_err;
logic             uart_mmc_inst_rty;
logic [31:0]      uart_mmc_inst_data;
logic             uart_mmc_inst_tga;
logic             uart_mmc_inst_tgd;
logic  [3:0]      uart_mmc_inst_tgc;

logic [31:0]      mmc_sdcard_inst_adr;
logic [31:0]      mmc_sdcard_inst_data;
logic             mmc_sdcard_inst_we;
logic  [3:0]      mmc_sdcard_inst_sel;
logic             mmc_sdcard_inst_stb;
logic             mmc_sdcard_inst_cyc;
logic             mmc_sdcard_inst_tga;
logic             mmc_sdcard_inst_tgd;
logic  [3:0]      mmc_sdcard_inst_tgc;

logic             sdcard_mmc_inst_ack;
logic             sdcard_mmc_inst_stall;
logic             sdcard_mmc_inst_err;
logic             sdcard_mmc_inst_rty;
logic [31:0]      sdcard_mmc_inst_data;
logic             sdcard_mmc_inst_tga;
logic             sdcard_mmc_inst_tgd;
logic  [3:0]      sdcard_mmc_inst_tgc;

logic [31:0]      riscv_mmc_data_adr;
logic [31:0]      riscv_mmc_data_data;
logic             riscv_mmc_data_we;
logic  [3:0]      riscv_mmc_data_sel;
logic             riscv_mmc_data_stb;
logic             riscv_mmc_data_cyc;
logic             riscv_mmc_data_tga;
logic             riscv_mmc_data_tgd;
logic  [3:0]      riscv_mmc_data_tgc;

logic             mmc_riscv_data_ack;
logic             mmc_riscv_data_stall;
logic             mmc_riscv_data_err;
logic             mmc_riscv_data_rty;
logic [31:0]      mmc_riscv_data_data;
logic             mmc_riscv_data_tga;
logic             mmc_riscv_data_tgd;
logic  [3:0]      mmc_riscv_data_tgc;

logic [31:0]      mmc_mem_data_adr;
logic [31:0]      mmc_mem_data_data;
logic             mmc_mem_data_we;
logic  [3:0]      mmc_mem_data_sel;
logic             mmc_mem_data_stb;
logic             mmc_mem_data_cyc;
logic             mmc_mem_data_tga;
logic             mmc_mem_data_tgd;
logic  [3:0]      mmc_mem_data_tgc;

logic             mem_mmc_data_ack;
logic             mem_mmc_data_stall;
logic             mem_mmc_data_err;
logic             mem_mmc_data_rty;
logic [31:0]      mem_mmc_data_data;
logic             mem_mmc_data_tga;
logic             mem_mmc_data_tgd;
logic  [3:0]      mem_mmc_data_tgc;

logic [31:0]      mmc_ddr3_data_adr;
logic [31:0]      mmc_ddr3_data_data;
logic             mmc_ddr3_data_we;
logic  [3:0]      mmc_ddr3_data_sel;
logic             mmc_ddr3_data_stb;
logic             mmc_ddr3_data_cyc;
logic             mmc_ddr3_data_tga;
logic             mmc_ddr3_data_tgd;
logic  [3:0]      mmc_ddr3_data_tgc;

logic             ddr3_mmc_data_ack;
logic             ddr3_mmc_data_stall;
logic             ddr3_mmc_data_err;
logic             ddr3_mmc_data_rty;
logic [31:0]      ddr3_mmc_data_data;
logic             ddr3_mmc_data_tga;
logic             ddr3_mmc_data_tgd;
logic  [3:0]      ddr3_mmc_data_tgc;

logic [31:0]      mmc_led_data_adr;
logic [31:0]      mmc_led_data_data;
logic             mmc_led_data_we;
logic  [3:0]      mmc_led_data_sel;
logic             mmc_led_data_stb;
logic             mmc_led_data_cyc;
logic             mmc_led_data_tga;
logic             mmc_led_data_tgd;
logic  [3:0]      mmc_led_data_tgc;

logic             led_mmc_data_ack;
logic             led_mmc_data_stall;
logic             led_mmc_data_err;
logic             led_mmc_data_rty;
logic [31:0]      led_mmc_data_data;
logic             led_mmc_data_tga;
logic             led_mmc_data_tgd;
logic  [3:0]      led_mmc_data_tgc;

logic [31:0]      mmc_keys_data_adr;
logic [31:0]      mmc_keys_data_data;
logic             mmc_keys_data_we;
logic  [3:0]      mmc_keys_data_sel;
logic             mmc_keys_data_stb;
logic             mmc_keys_data_cyc;
logic             mmc_keys_data_tga;
logic             mmc_keys_data_tgd;
logic  [3:0]      mmc_keys_data_tgc;

logic             keys_mmc_data_ack;
logic             keys_mmc_data_stall;
logic             keys_mmc_data_err;
logic             keys_mmc_data_rty;
logic [31:0]      keys_mmc_data_data;
logic             keys_mmc_data_tga;
logic             keys_mmc_data_tgd;
logic  [3:0]      keys_mmc_data_tgc;

logic [31:0]      mmc_uart_data_adr;
logic [31:0]      mmc_uart_data_data;
logic             mmc_uart_data_we;
logic  [3:0]      mmc_uart_data_sel;
logic             mmc_uart_data_stb;
logic             mmc_uart_data_cyc;
logic             mmc_uart_data_tga;
logic             mmc_uart_data_tgd;
logic  [3:0]      mmc_uart_data_tgc;

logic             uart_mmc_data_ack;
logic             uart_mmc_data_stall;
logic             uart_mmc_data_err;
logic             uart_mmc_data_rty;
logic [31:0]      uart_mmc_data_data;
logic             uart_mmc_data_tga;
logic             uart_mmc_data_tgd;
logic  [3:0]      uart_mmc_data_tgc;

logic [31:0]      mmc_sdcard_data_adr;
logic [31:0]      mmc_sdcard_data_data;
logic             mmc_sdcard_data_we;
logic  [3:0]      mmc_sdcard_data_sel;
logic             mmc_sdcard_data_stb;
logic             mmc_sdcard_data_cyc;
logic             mmc_sdcard_data_tga;
logic             mmc_sdcard_data_tgd;
logic  [3:0]      mmc_sdcard_data_tgc;

logic             sdcard_mmc_data_ack;
logic             sdcard_mmc_data_stall;
logic             sdcard_mmc_data_err;
logic             sdcard_mmc_data_rty;
logic [31:0]      sdcard_mmc_data_data;
logic             sdcard_mmc_data_tga;
logic             sdcard_mmc_data_tgd;
logic  [3:0]      sdcard_mmc_data_tgc;


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

  .bus_inst_adr_o   (riscv_mmc_inst_adr), 
  .bus_inst_data_o  (riscv_mmc_inst_data),
  .bus_inst_we_o    (riscv_mmc_inst_we),  
  .bus_inst_sel_o   (riscv_mmc_inst_sel), 
  .bus_inst_stb_o   (riscv_mmc_inst_stb), 
  .bus_inst_cyc_o   (riscv_mmc_inst_cyc), 
  .bus_inst_tga_o   (riscv_mmc_inst_tga), 
  .bus_inst_tgd_o   (riscv_mmc_inst_tgd), 
  .bus_inst_tgc_o   (riscv_mmc_inst_tgc), 
                                     
  .bus_inst_ack_i   (mmc_riscv_inst_ack), 
  .bus_inst_stall_i (mmc_riscv_inst_stall),
  .bus_inst_err_i   (mmc_riscv_inst_err), 
  .bus_inst_rty_i   (mmc_riscv_inst_rty), 
  .bus_inst_data_i  (mmc_riscv_inst_data), 
  .bus_inst_tga_i   (mmc_riscv_inst_tga), 
  .bus_inst_tgd_i   (mmc_riscv_inst_tgd), 
  .bus_inst_tgc_i   (mmc_riscv_inst_tgc), 

  .bus_data_adr_o   (riscv_mmc_data_adr), 
  .bus_data_data_o  (riscv_mmc_data_data),
  .bus_data_we_o    (riscv_mmc_data_we),  
  .bus_data_sel_o   (riscv_mmc_data_sel), 
  .bus_data_stb_o   (riscv_mmc_data_stb), 
  .bus_data_cyc_o   (riscv_mmc_data_cyc), 
  .bus_data_tga_o   (riscv_mmc_data_tga), 
  .bus_data_tgd_o   (riscv_mmc_data_tgd), 
  .bus_data_tgc_o   (riscv_mmc_data_tgc), 
                                     
  .bus_data_ack_i   (mmc_riscv_data_ack), 
  .bus_data_stall_i (mmc_riscv_data_stall),
  .bus_data_err_i   (mmc_riscv_data_err), 
  .bus_data_rty_i   (mmc_riscv_data_rty), 
  .bus_data_data_i  (mmc_riscv_data_data), 
  .bus_data_tga_i   (mmc_riscv_data_tga), 
  .bus_data_tgd_i   (mmc_riscv_data_tgd), 
  .bus_data_tgc_i   (mmc_riscv_data_tgc) 


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
  
  .riscv_mmc_adr_i               (riscv_mmc_inst_adr),  
  .riscv_mmc_data_i              (riscv_mmc_inst_data), 
  .riscv_mmc_we_i                (riscv_mmc_inst_we),   
  .riscv_mmc_sel_i               (riscv_mmc_inst_sel),  
  .riscv_mmc_stb_i               (riscv_mmc_inst_stb),  
  .riscv_mmc_cyc_i               (riscv_mmc_inst_cyc),  
  .riscv_mmc_tga_i               (riscv_mmc_inst_tga),  
  .riscv_mmc_tgd_i               (riscv_mmc_inst_tgd),  
  .riscv_mmc_tgc_i               (riscv_mmc_inst_tgc),  
                                                        
  .mmc_riscv_ack_o               (mmc_riscv_inst_ack),  
  .mmc_riscv_stall_o             (mmc_riscv_inst_stall),
  .mmc_riscv_err_o               (mmc_riscv_inst_err),  
  .mmc_riscv_rty_o               (mmc_riscv_inst_rty),  
  .mmc_riscv_data_o              (mmc_riscv_inst_data),  
  .mmc_riscv_tga_o               (mmc_riscv_inst_tga),  
  .mmc_riscv_tgd_o               (mmc_riscv_inst_tgd),  
  .mmc_riscv_tgc_o               (mmc_riscv_inst_tgc),  

  .mmc_mem_adr_o                 (mmc_mem_inst_adr),  
  .mmc_mem_data_o                (mmc_mem_inst_data), 
  .mmc_mem_we_o                  (mmc_mem_inst_we),   
  .mmc_mem_sel_o                 (mmc_mem_inst_sel),  
  .mmc_mem_stb_o                 (mmc_mem_inst_stb),  
  .mmc_mem_cyc_o                 (mmc_mem_inst_cyc),  
  .mmc_mem_tga_o                 (mmc_mem_inst_tga),  
  .mmc_mem_tgd_o                 (mmc_mem_inst_tgd),  
  .mmc_mem_tgc_o                 (mmc_mem_inst_tgc),  
                                                          
  .mem_mmc_ack_i                 (mem_mmc_inst_ack),  
  .mem_mmc_stall_i               (mem_mmc_inst_stall),
  .mem_mmc_err_i                 (mem_mmc_inst_err),  
  .mem_mmc_rty_i                 (mem_mmc_inst_rty),  
  .mem_mmc_data_i                (mem_mmc_inst_data),  
  .mem_mmc_tga_i                 (mem_mmc_inst_tga),  
  .mem_mmc_tgd_i                 (mem_mmc_inst_tgd),  
  .mem_mmc_tgc_i                 (mem_mmc_inst_tgc), 

  .mmc_ddr3_adr_o                (mmc_ddr3_inst_adr),  
  .mmc_ddr3_data_o               (mmc_ddr3_inst_data), 
  .mmc_ddr3_we_o                 (mmc_ddr3_inst_we),   
  .mmc_ddr3_sel_o                (mmc_ddr3_inst_sel),  
  .mmc_ddr3_stb_o                (mmc_ddr3_inst_stb),  
  .mmc_ddr3_cyc_o                (mmc_ddr3_inst_cyc),  
  .mmc_ddr3_tga_o                (mmc_ddr3_inst_tga),  
  .mmc_ddr3_tgd_o                (mmc_ddr3_inst_tgd),  
  .mmc_ddr3_tgc_o                (mmc_ddr3_inst_tgc),  
                                                         
  .ddr3_mmc_ack_i                (ddr3_mmc_inst_ack),  
  .ddr3_mmc_stall_i              (ddr3_mmc_inst_stall),
  .ddr3_mmc_err_i                (ddr3_mmc_inst_err),  
  .ddr3_mmc_rty_i                (ddr3_mmc_inst_rty),  
  .ddr3_mmc_data_i               (ddr3_mmc_inst_data),  
  .ddr3_mmc_tga_i                (ddr3_mmc_inst_tga),  
  .ddr3_mmc_tgd_i                (ddr3_mmc_inst_tgd),  
  .ddr3_mmc_tgc_i                (ddr3_mmc_inst_tgc), 

  .mmc_led_adr_o                 (mmc_led_inst_adr),  
  .mmc_led_data_o                (mmc_led_inst_data), 
  .mmc_led_we_o                  (mmc_led_inst_we),   
  .mmc_led_sel_o                 (mmc_led_inst_sel),  
  .mmc_led_stb_o                 (mmc_led_inst_stb),  
  .mmc_led_cyc_o                 (mmc_led_inst_cyc),  
  .mmc_led_tga_o                 (mmc_led_inst_tga),  
  .mmc_led_tgd_o                 (mmc_led_inst_tgd),  
  .mmc_led_tgc_o                 (mmc_led_inst_tgc),  
                                                          
  .led_mmc_ack_i                 ('0),  
  .led_mmc_stall_i               ('0),
  .led_mmc_err_i                 (mmc_led_inst_cyc & mmc_led_inst_stb),  
  .led_mmc_rty_i                 ('0),  
  .led_mmc_data_i                ('0),  
  .led_mmc_tga_i                 (mmc_led_inst_tga),  
  .led_mmc_tgd_i                 (mmc_led_inst_tgd),  
  .led_mmc_tgc_i                 (mmc_led_inst_tgc), 

  .mmc_keys_adr_o                (mmc_keys_inst_adr),  
  .mmc_keys_data_o               (mmc_keys_inst_data), 
  .mmc_keys_we_o                 (mmc_keys_inst_we),   
  .mmc_keys_sel_o                (mmc_keys_inst_sel),  
  .mmc_keys_stb_o                (mmc_keys_inst_stb),  
  .mmc_keys_cyc_o                (mmc_keys_inst_cyc),  
  .mmc_keys_tga_o                (mmc_keys_inst_tga),  
  .mmc_keys_tgd_o                (mmc_keys_inst_tgd),  
  .mmc_keys_tgc_o                (mmc_keys_inst_tgc),  
                                                         
  .keys_mmc_ack_i                ('0),  
  .keys_mmc_stall_i              ('0),
  .keys_mmc_err_i                (mmc_keys_inst_cyc & mmc_keys_inst_stb),  
  .keys_mmc_rty_i                ('0),  
  .keys_mmc_data_i               ('0),  
  .keys_mmc_tga_i                (mmc_keys_inst_tga),  
  .keys_mmc_tgd_i                (mmc_keys_inst_tgd),  
  .keys_mmc_tgc_i                (mmc_keys_inst_tgc), 

  .mmc_uart_adr_o                (mmc_uart_inst_adr),  
  .mmc_uart_data_o               (mmc_uart_inst_data), 
  .mmc_uart_we_o                 (mmc_uart_inst_we),   
  .mmc_uart_sel_o                (mmc_uart_inst_sel),  
  .mmc_uart_stb_o                (mmc_uart_inst_stb),  
  .mmc_uart_cyc_o                (mmc_uart_inst_cyc),  
  .mmc_uart_tga_o                (mmc_uart_inst_tga),  
  .mmc_uart_tgd_o                (mmc_uart_inst_tgd),  
  .mmc_uart_tgc_o                (mmc_uart_inst_tgc),  
                                                         
  .uart_mmc_ack_i                ('0),  
  .uart_mmc_stall_i              ('0),
  .uart_mmc_err_i                (mmc_uart_inst_cyc & mmc_uart_inst_stb),  
  .uart_mmc_rty_i                ('0),  
  .uart_mmc_data_i               ('0),  
  .uart_mmc_tga_i                (mmc_uart_inst_tga),  
  .uart_mmc_tgd_i                (mmc_uart_inst_tgd),  
  .uart_mmc_tgc_i                (mmc_uart_inst_tgc), 

  .mmc_sdcard_adr_o              (mmc_sdcard_inst_adr),  
  .mmc_sdcard_data_o             (mmc_sdcard_inst_data), 
  .mmc_sdcard_we_o               (mmc_sdcard_inst_we),   
  .mmc_sdcard_sel_o              (mmc_sdcard_inst_sel),  
  .mmc_sdcard_stb_o              (mmc_sdcard_inst_stb),  
  .mmc_sdcard_cyc_o              (mmc_sdcard_inst_cyc),  
  .mmc_sdcard_tga_o              (mmc_sdcard_inst_tga),  
  .mmc_sdcard_tgd_o              (mmc_sdcard_inst_tgd),  
  .mmc_sdcard_tgc_o              (mmc_sdcard_inst_tgc),  
                                                       
  .sdcard_mmc_ack_i              ('0),  
  .sdcard_mmc_stall_i            ('0),
  .sdcard_mmc_err_i              (mmc_sdcard_inst_cyc & mmc_sdcard_inst_stb),  
  .sdcard_mmc_rty_i              ('0),  
  .sdcard_mmc_data_i             ('0),  
  .sdcard_mmc_tga_i              (mmc_sdcard_inst_tga),  
  .sdcard_mmc_tgd_i              (mmc_sdcard_inst_tgd),  
  .sdcard_mmc_tgc_i              (mmc_sdcard_inst_tgc) 

);

mmc_wb mmc_data (
  .clk         (clk),
  .rst         (rst),
  
  .riscv_mmc_adr_i               (riscv_mmc_data_adr),  
  .riscv_mmc_data_i              (riscv_mmc_data_data), 
  .riscv_mmc_we_i                (riscv_mmc_data_we),   
  .riscv_mmc_sel_i               (riscv_mmc_data_sel),  
  .riscv_mmc_stb_i               (riscv_mmc_data_stb),  
  .riscv_mmc_cyc_i               (riscv_mmc_data_cyc),  
  .riscv_mmc_tga_i               (riscv_mmc_data_tga),  
  .riscv_mmc_tgd_i               (riscv_mmc_data_tgd),  
  .riscv_mmc_tgc_i               (riscv_mmc_data_tgc),  
                                                        
  .mmc_riscv_ack_o               (mmc_riscv_data_ack),  
  .mmc_riscv_stall_o             (mmc_riscv_data_stall),
  .mmc_riscv_err_o               (mmc_riscv_data_err),  
  .mmc_riscv_rty_o               (mmc_riscv_data_rty),  
  .mmc_riscv_data_o              (mmc_riscv_data_data),  
  .mmc_riscv_tga_o               (mmc_riscv_data_tga),  
  .mmc_riscv_tgd_o               (mmc_riscv_data_tgd),  
  .mmc_riscv_tgc_o               (mmc_riscv_data_tgc),  

  .mmc_mem_adr_o                 (mmc_mem_data_adr),  
  .mmc_mem_data_o                (mmc_mem_data_data), 
  .mmc_mem_we_o                  (mmc_mem_data_we),   
  .mmc_mem_sel_o                 (mmc_mem_data_sel),  
  .mmc_mem_stb_o                 (mmc_mem_data_stb),  
  .mmc_mem_cyc_o                 (mmc_mem_data_cyc),  
  .mmc_mem_tga_o                 (mmc_mem_data_tga),  
  .mmc_mem_tgd_o                 (mmc_mem_data_tgd),  
  .mmc_mem_tgc_o                 (mmc_mem_data_tgc),  
                                                          
  .mem_mmc_ack_i                 (mem_mmc_data_ack),  
  .mem_mmc_stall_i               (mem_mmc_data_stall),
  .mem_mmc_err_i                 (mem_mmc_data_err),  
  .mem_mmc_rty_i                 (mem_mmc_data_rty),  
  .mem_mmc_data_i                (mem_mmc_data_data),  
  .mem_mmc_tga_i                 (mem_mmc_data_tga),  
  .mem_mmc_tgd_i                 (mem_mmc_data_tgd),  
  .mem_mmc_tgc_i                 (mem_mmc_data_tgc), 

  .mmc_ddr3_adr_o                (mmc_ddr3_data_adr),  
  .mmc_ddr3_data_o               (mmc_ddr3_data_data), 
  .mmc_ddr3_we_o                 (mmc_ddr3_data_we),   
  .mmc_ddr3_sel_o                (mmc_ddr3_data_sel),  
  .mmc_ddr3_stb_o                (mmc_ddr3_data_stb),  
  .mmc_ddr3_cyc_o                (mmc_ddr3_data_cyc),  
  .mmc_ddr3_tga_o                (mmc_ddr3_data_tga),  
  .mmc_ddr3_tgd_o                (mmc_ddr3_data_tgd),  
  .mmc_ddr3_tgc_o                (mmc_ddr3_data_tgc),  
                                                         
  .ddr3_mmc_ack_i                (ddr3_mmc_data_ack),  
  .ddr3_mmc_stall_i              (ddr3_mmc_data_stall),
  .ddr3_mmc_err_i                (ddr3_mmc_data_err),  
  .ddr3_mmc_rty_i                (ddr3_mmc_data_rty),  
  .ddr3_mmc_data_i               (ddr3_mmc_data_data),  
  .ddr3_mmc_tga_i                (ddr3_mmc_data_tga),  
  .ddr3_mmc_tgd_i                (ddr3_mmc_data_tgd),  
  .ddr3_mmc_tgc_i                (ddr3_mmc_data_tgc), 

  .mmc_led_adr_o                 (mmc_led_data_adr),  
  .mmc_led_data_o                (mmc_led_data_data), 
  .mmc_led_we_o                  (mmc_led_data_we),   
  .mmc_led_sel_o                 (mmc_led_data_sel),  
  .mmc_led_stb_o                 (mmc_led_data_stb),  
  .mmc_led_cyc_o                 (mmc_led_data_cyc),  
  .mmc_led_tga_o                 (mmc_led_data_tga),  
  .mmc_led_tgd_o                 (mmc_led_data_tgd),  
  .mmc_led_tgc_o                 (mmc_led_data_tgc),  
                                                          
  .led_mmc_ack_i                 (led_mmc_data_ack),    
  .led_mmc_stall_i               (led_mmc_data_stall),  
  .led_mmc_err_i                 (led_mmc_data_err),    
  .led_mmc_rty_i                 (led_mmc_data_rty),    
  .led_mmc_data_i                (led_mmc_data_data),   
  .led_mmc_tga_i                 (led_mmc_data_tga),    
  .led_mmc_tgd_i                 (led_mmc_data_tgd),    
  .led_mmc_tgc_i                 (led_mmc_data_tgc),    

  .mmc_keys_adr_o                (mmc_keys_data_adr),  
  .mmc_keys_data_o               (mmc_keys_data_data), 
  .mmc_keys_we_o                 (mmc_keys_data_we),   
  .mmc_keys_sel_o                (mmc_keys_data_sel),  
  .mmc_keys_stb_o                (mmc_keys_data_stb),  
  .mmc_keys_cyc_o                (mmc_keys_data_cyc),  
  .mmc_keys_tga_o                (mmc_keys_data_tga),  
  .mmc_keys_tgd_o                (mmc_keys_data_tgd),  
  .mmc_keys_tgc_o                (mmc_keys_data_tgc),  
                                                        
  .keys_mmc_ack_i                (keys_mmc_data_ack),    
  .keys_mmc_stall_i              (keys_mmc_data_stall),  
  .keys_mmc_err_i                (keys_mmc_data_err),    
  .keys_mmc_rty_i                (keys_mmc_data_rty),    
  .keys_mmc_data_i               (keys_mmc_data_data),   
  .keys_mmc_tga_i                (keys_mmc_data_tga),    
  .keys_mmc_tgd_i                (keys_mmc_data_tgd),    
  .keys_mmc_tgc_i                (keys_mmc_data_tgc),    

  .mmc_uart_adr_o                (mmc_uart_data_adr),  
  .mmc_uart_data_o               (mmc_uart_data_data), 
  .mmc_uart_we_o                 (mmc_uart_data_we),   
  .mmc_uart_sel_o                (mmc_uart_data_sel),  
  .mmc_uart_stb_o                (mmc_uart_data_stb),  
  .mmc_uart_cyc_o                (mmc_uart_data_cyc),  
  .mmc_uart_tga_o                (mmc_uart_data_tga),  
  .mmc_uart_tgd_o                (mmc_uart_data_tgd),  
  .mmc_uart_tgc_o                (mmc_uart_data_tgc),  
                                                        
  .uart_mmc_ack_i                (uart_mmc_data_ack),    
  .uart_mmc_stall_i              (uart_mmc_data_stall),  
  .uart_mmc_err_i                (uart_mmc_data_err),    
  .uart_mmc_rty_i                (uart_mmc_data_rty),    
  .uart_mmc_data_i               (uart_mmc_data_data),   
  .uart_mmc_tga_i                (uart_mmc_data_tga),    
  .uart_mmc_tgd_i                (uart_mmc_data_tgd),    
  .uart_mmc_tgc_i                (uart_mmc_data_tgc),    

  .mmc_sdcard_adr_o              (mmc_sdcard_data_adr),  
  .mmc_sdcard_data_o             (mmc_sdcard_data_data), 
  .mmc_sdcard_we_o               (mmc_sdcard_data_we),   
  .mmc_sdcard_sel_o              (mmc_sdcard_data_sel),  
  .mmc_sdcard_stb_o              (mmc_sdcard_data_stb),  
  .mmc_sdcard_cyc_o              (mmc_sdcard_data_cyc),  
  .mmc_sdcard_tga_o              (mmc_sdcard_data_tga),  
  .mmc_sdcard_tgd_o              (mmc_sdcard_data_tgd),  
  .mmc_sdcard_tgc_o              (mmc_sdcard_data_tgc),  
                                                       
  .sdcard_mmc_ack_i              (sdcard_mmc_data_ack),  
  .sdcard_mmc_stall_i            (sdcard_mmc_data_stall),
  .sdcard_mmc_err_i              (sdcard_mmc_data_err),   
  .sdcard_mmc_rty_i              (sdcard_mmc_data_rty),  
  .sdcard_mmc_data_i             (sdcard_mmc_data_data), 
  .sdcard_mmc_tga_i              (sdcard_mmc_data_tga),  
  .sdcard_mmc_tgd_i              (sdcard_mmc_data_tgd),  
  .sdcard_mmc_tgc_i              (sdcard_mmc_data_tgc)   

);

mem mem (
  .clk         (clk),
  .rst         (rst),

  .bus_inst_adr_i         (mmc_mem_inst_adr),  
  .bus_inst_data_i        (mmc_mem_inst_data), 
  .bus_inst_we_i          (mmc_mem_inst_we),   
  .bus_inst_sel_i         (mmc_mem_inst_sel),  
  .bus_inst_stb_i         (mmc_mem_inst_stb),  
  .bus_inst_cyc_i         (mmc_mem_inst_cyc),  
  .bus_inst_tga_i         (mmc_mem_inst_tga),  
  .bus_inst_tgd_i         (mmc_mem_inst_tgd),  
  .bus_inst_tgc_i         (mmc_mem_inst_tgc),  
                                                  
  .bus_inst_ack_o         (mem_mmc_inst_ack),  
  .bus_inst_stall_o       (mem_mmc_inst_stall),
  .bus_inst_err_o         (mem_mmc_inst_err),  
  .bus_inst_rty_o         (mem_mmc_inst_rty),  
  .bus_inst_data_o        (mem_mmc_inst_data),  
  .bus_inst_tga_o         (mem_mmc_inst_tga),  
  .bus_inst_tgd_o         (mem_mmc_inst_tgd),  
  .bus_inst_tgc_o         (mem_mmc_inst_tgc),  

  .bus_data_adr_i         (mmc_mem_data_adr),  
  .bus_data_data_i        (mmc_mem_data_data), 
  .bus_data_we_i          (mmc_mem_data_we),   
  .bus_data_sel_i         (mmc_mem_data_sel),  
  .bus_data_stb_i         (mmc_mem_data_stb),  
  .bus_data_cyc_i         (mmc_mem_data_cyc),  
  .bus_data_tga_i         (mmc_mem_data_tga),  
  .bus_data_tgd_i         (mmc_mem_data_tgd),  
  .bus_data_tgc_i         (mmc_mem_data_tgc),  
                                                  
  .bus_data_ack_o         (mem_mmc_data_ack),  
  .bus_data_stall_o       (mem_mmc_data_stall),
  .bus_data_err_o         (mem_mmc_data_err),  
  .bus_data_rty_o         (mem_mmc_data_rty),  
  .bus_data_data_o        (mem_mmc_data_data),  
  .bus_data_tga_o         (mem_mmc_data_tga),  
  .bus_data_tgd_o         (mem_mmc_data_tgd),  
  .bus_data_tgc_o         (mem_mmc_data_tgc)
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

  .bus_inst_adr_i         (mmc_ddr3_inst_adr),  
  .bus_inst_data_i        (mmc_ddr3_inst_data), 
  .bus_inst_we_i          (mmc_ddr3_inst_we),   
  .bus_inst_sel_i         (mmc_ddr3_inst_sel),  
  .bus_inst_stb_i         (mmc_ddr3_inst_stb),  
  .bus_inst_cyc_i         (mmc_ddr3_inst_cyc),  
  .bus_inst_tga_i         (mmc_ddr3_inst_tga),  
  .bus_inst_tgd_i         (mmc_ddr3_inst_tgd),  
  .bus_inst_tgc_i         (mmc_ddr3_inst_tgc),  
                                                  
  .bus_inst_ack_o         (ddr3_mmc_inst_ack),  
  .bus_inst_stall_o       (ddr3_mmc_inst_stall),
  .bus_inst_err_o         (ddr3_mmc_inst_err),  
  .bus_inst_rty_o         (ddr3_mmc_inst_rty),  
  .bus_inst_data_o        (ddr3_mmc_inst_data),  
  .bus_inst_tga_o         (ddr3_mmc_inst_tga),  
  .bus_inst_tgd_o         (ddr3_mmc_inst_tgd),  
  .bus_inst_tgc_o         (ddr3_mmc_inst_tgc),  

  .bus_mem_adr_i         (mmc_ddr3_data_adr),  
  .bus_mem_data_i        (mmc_ddr3_data_data), 
  .bus_mem_we_i          (mmc_ddr3_data_we),   
  .bus_mem_sel_i         (mmc_ddr3_data_sel),  
  .bus_mem_stb_i         (mmc_ddr3_data_stb),  
  .bus_mem_cyc_i         (mmc_ddr3_data_cyc),  
  .bus_mem_tga_i         (mmc_ddr3_data_tga),  
  .bus_mem_tgd_i         (mmc_ddr3_data_tgd),  
  .bus_mem_tgc_i         (mmc_ddr3_data_tgc),  
                                                  
  .bus_mem_ack_o         (ddr3_mmc_data_ack),  
  .bus_mem_stall_o       (ddr3_mmc_data_stall),
  .bus_mem_err_o         (ddr3_mmc_data_err),  
  .bus_mem_rty_o         (ddr3_mmc_data_rty),  
  .bus_mem_data_o        (ddr3_mmc_data_data),  
  .bus_mem_tga_o         (ddr3_mmc_data_tga),  
  .bus_mem_tgd_o         (ddr3_mmc_data_tgd),  
  .bus_mem_tgc_o         (ddr3_mmc_data_tgc)  

);

led #(.SIZE(5),.ADDR_BASE(32'h00000000)) led (
  .clk         (clk),
  .rst         (rst),

  .LED         (LED),

  .i_bus_req           (mmc_led_bus_req),   
  .i_bus_write         (mmc_led_bus_write), 
  .i_bus_addr          (mmc_led_bus_addr),  
  .i_bus_data          (mmc_led_bus_data),
  .i_bus_data_rd_mask  (mmc_led_bus_data_rd_mask),
  .i_bus_data_wr_mask  (mmc_led_bus_data_wr_mask),

  .o_bus_ack           (led_mmc_bus_ack),   
  .o_bus_data          (led_mmc_bus_data)
);

keys #(.SIZE(5),.ADDR_BASE(32'hC0000000)) keys (
  .clk         (clk),
  .rst         (rst),

  .KEY         (KEY),

  .i_bus_req           (mmc_keys_bus_req),   
  .i_bus_write         (mmc_keys_bus_write), 
  .i_bus_addr          (mmc_keys_bus_addr),  
  .i_bus_data          (mmc_keys_bus_data),
  .i_bus_data_rd_mask  (mmc_keys_bus_data_rd_mask),
  .i_bus_data_wr_mask  (mmc_keys_bus_data_wr_mask),

  .o_bus_ack           (keys_mmc_bus_ack),   
  .o_bus_data          (keys_mmc_bus_data)
);

uart uart (
  .clk (clk),
  .rst (rst),
  
  .GND (GPIO_0_01),
  .TXD (GPIO_0_05),
  .RXD (GPIO_0_03),
  .CTS (GPIO_0_09),
  .RTS (GPIO_0_07),

  .i_bus_req           (mmc_uart_bus_req),   
  .i_bus_write         (mmc_uart_bus_write), 
  .i_bus_addr          (mmc_uart_bus_addr),  
  .i_bus_data          (mmc_uart_bus_data),
  .i_bus_data_rd_mask  (mmc_uart_bus_data_rd_mask),
  .i_bus_data_wr_mask  (mmc_uart_bus_data_wr_mask),

  .o_bus_ack           (uart_mmc_bus_ack),   
  .o_bus_data          (uart_mmc_bus_data)
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

  .mmc_touchpad_bus_req          (mmc_touchpad_bus_req         ),
  .mmc_touchpad_bus_write        (mmc_touchpad_bus_write       ),
  .mmc_touchpad_bus_addr         (mmc_touchpad_bus_addr        ),
  .mmc_touchpad_bus_data         (mmc_touchpad_bus_data        ),
  .mmc_touchpad_bus_data_rd_mask (mmc_touchpad_bus_data_rd_mask),
  .mmc_touchpad_bus_data_wr_mask (mmc_touchpad_bus_data_wr_mask),
                                                                 
  .touchpad_mmc_bus_ack          (touchpad_mmc_bus_ack         ),
  .touchpad_mmc_bus_data         (touchpad_mmc_bus_data        ),
                                                                 
  .mmc_display_bus_req           (mmc_display_bus_req          ),
  .mmc_display_bus_write         (mmc_display_bus_write        ),
  .mmc_display_bus_addr          (mmc_display_bus_addr         ),
  .mmc_display_bus_data          (mmc_display_bus_data         ),
  .mmc_display_bus_data_rd_mask  (mmc_display_bus_data_rd_mask ),
  .mmc_display_bus_data_wr_mask  (mmc_display_bus_data_wr_mask ),
                                                                 
  .display_mmc_bus_ack           (display_mmc_bus_ack          ),
  .display_mmc_bus_data          (display_mmc_bus_data         ),
                                                                 
  .mmc_dispbuff_bus_req          (mmc_dispbuff_bus_req         ),
  .mmc_dispbuff_bus_write        (mmc_dispbuff_bus_write       ),
  .mmc_dispbuff_bus_addr         (mmc_dispbuff_bus_addr        ),
  .mmc_dispbuff_bus_data         (mmc_dispbuff_bus_data        ),
  .mmc_dispbuff_bus_data_rd_mask (mmc_dispbuff_bus_data_rd_mask),
  .mmc_dispbuff_bus_data_wr_mask (mmc_dispbuff_bus_data_wr_mask),
                                                                 
  .dispbuff_mmc_bus_ack          (dispbuff_mmc_bus_ack         ),
  .dispbuff_mmc_bus_data         (dispbuff_mmc_bus_data        ),
                                                                 
  .mmc_consolebuff_bus_req          (mmc_consolebuff_bus_req         ),
  .mmc_consolebuff_bus_write        (mmc_consolebuff_bus_write       ),
  .mmc_consolebuff_bus_addr         (mmc_consolebuff_bus_addr        ),
  .mmc_consolebuff_bus_data         (mmc_consolebuff_bus_data        ),
  .mmc_consolebuff_bus_data_rd_mask (mmc_consolebuff_bus_data_rd_mask),
  .mmc_consolebuff_bus_data_wr_mask (mmc_consolebuff_bus_data_wr_mask),
                                                                 
  .consolebuff_mmc_bus_ack          (consolebuff_mmc_bus_ack         ),
  .consolebuff_mmc_bus_data         (consolebuff_mmc_bus_data        ),
                                                                 
  .mmc_sdcard_bus_req          (mmc_sdcard_bus_req         ),
  .mmc_sdcard_bus_write        (mmc_sdcard_bus_write       ),
  .mmc_sdcard_bus_addr         (mmc_sdcard_bus_addr        ),
  .mmc_sdcard_bus_data         (mmc_sdcard_bus_data        ),
  .mmc_sdcard_bus_data_rd_mask (mmc_sdcard_bus_data_rd_mask),
  .mmc_sdcard_bus_data_wr_mask (mmc_sdcard_bus_data_wr_mask),
                                                                 
  .sdcard_mmc_bus_ack          (sdcard_mmc_bus_ack         ),
  .sdcard_mmc_bus_data         (sdcard_mmc_bus_data        )
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
