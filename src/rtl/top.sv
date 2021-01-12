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
  output logic   [5:0]       rvfi_valid,
  output logic   [5:0][63:0] rvfi_order,
  output logic   [5:0][31:0] rvfi_insn,
  output logic   [5:0]       rvfi_trap,
  output logic   [5:0]       rvfi_halt,
  output logic   [5:0]       rvfi_intr,
  output logic   [5:0][ 1:0] rvfi_mode,
  output logic   [5:0][ 4:0] rvfi_rs1_addr,
  output logic   [5:0][ 4:0] rvfi_rs2_addr,
  output logic   [5:0][31:0] rvfi_rs1_rdata,
  output logic   [5:0][31:0] rvfi_rs2_rdata,
  output logic   [5:0][ 4:0] rvfi_rd_addr,
  output logic   [5:0][31:0] rvfi_rd_wdata,
  output logic   [5:0][31:0] rvfi_pc_rdata,
  output logic   [5:0][31:0] rvfi_pc_wdata,
  output logic   [5:0][31:0] rvfi_mem_addr,
  output logic   [5:0][ 3:0] rvfi_mem_rmask,
  output logic   [5:0][ 3:0] rvfi_mem_wmask,
  output logic   [5:0][31:0] rvfi_mem_rdata,
  output logic   [5:0][31:0] rvfi_mem_wdata,

  output logic   [5:0][63:0] rvfi_csr_mcycle_rmask,
  output logic   [5:0][63:0] rvfi_csr_mcycle_wmask,
  output logic   [5:0][63:0] rvfi_csr_mcycle_rdata,
  output logic   [5:0][63:0] rvfi_csr_mcycle_wdata,

  output logic   [5:0][63:0] rvfi_csr_minstret_rmask,
  output logic   [5:0][63:0] rvfi_csr_minstret_wmask,
  output logic   [5:0][63:0] rvfi_csr_minstret_rdata,
  output logic   [5:0][63:0] rvfi_csr_minstret_wdata,
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

wishbone_pkg::bus_req_t mmc_ddr3cntl_inst;
wishbone_pkg::bus_rsp_t ddr3cntl_mmc_inst;

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

wishbone_pkg::bus_req_t mmc_debug_inst;
wishbone_pkg::bus_rsp_t debug_mmc_inst;

wishbone_pkg::bus_req_t riscv_mmc_data;
wishbone_pkg::bus_rsp_t mmc_riscv_data;

wishbone_pkg::bus_req_t mmc_mem_data;
wishbone_pkg::bus_rsp_t mem_mmc_data;

wishbone_pkg::bus_req_t mmc_ddr3_data;
wishbone_pkg::bus_rsp_t ddr3_mmc_data;

wishbone_pkg::bus_req_t mmc_ddr3cntl_data;
wishbone_pkg::bus_rsp_t ddr3cntl_mmc_data;

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

wishbone_pkg::bus_req_t mmc_debug_data;
wishbone_pkg::bus_rsp_t debug_mmc_data;

`ifndef RISCV_FORMAL
  logic   [5:0]       rvfi_valid;
  logic   [5:0][63:0] rvfi_order;
  logic   [5:0][31:0] rvfi_insn;
  logic   [5:0]       rvfi_trap;
  logic   [5:0]       rvfi_halt;
  logic   [5:0]       rvfi_intr;
  logic   [5:0][ 1:0] rvfi_mode;
  logic   [5:0][ 4:0] rvfi_rs1_addr;
  logic   [5:0][ 4:0] rvfi_rs2_addr;
  logic   [5:0][31:0] rvfi_rs1_rdata;
  logic   [5:0][31:0] rvfi_rs2_rdata;
  logic   [5:0][ 4:0] rvfi_rd_addr;
  logic   [5:0][31:0] rvfi_rd_wdata;
  logic   [5:0][31:0] rvfi_pc_rdata;
  logic   [5:0][31:0] rvfi_pc_wdata;
  logic   [5:0][31:0] rvfi_mem_addr;
  logic   [5:0][ 3:0] rvfi_mem_rmask;
  logic   [5:0][ 3:0] rvfi_mem_wmask;
  logic   [5:0][31:0] rvfi_mem_rdata;
  logic   [5:0][31:0] rvfi_mem_wdata;

  logic   [5:0][63:0] rvfi_csr_mcycle_rmask;
  logic   [5:0][63:0] rvfi_csr_mcycle_wmask;
  logic   [5:0][63:0] rvfi_csr_mcycle_rdata;
  logic   [5:0][63:0] rvfi_csr_mcycle_wdata;

  logic   [5:0][63:0] rvfi_csr_minstret_rmask;
  logic   [5:0][63:0] rvfi_csr_minstret_wmask;
  logic   [5:0][63:0] rvfi_csr_minstret_rdata;
  logic   [5:0][63:0] rvfi_csr_minstret_wdata;
`endif

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

logic [31:0] IRQ;

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

//SpinalHDL version
riscv_top riscv (
  .IRQ                 (IRQ),
  .busInst_req_cyc     (riscv_mmc_inst.Cyc  ),
  .busInst_req_stb     (riscv_mmc_inst.Stb  ),
  .busInst_req_we      (riscv_mmc_inst.We   ),
  .busInst_req_adr     (riscv_mmc_inst.Adr  ),
  .busInst_req_sel     (riscv_mmc_inst.Sel  ),
  .busInst_req_data    (riscv_mmc_inst.Data ),
  .busInst_req_tga     (riscv_mmc_inst.Tga  ),
  .busInst_req_tgd     (riscv_mmc_inst.Tgd  ),
  .busInst_req_tgc     (riscv_mmc_inst.Tgc  ),
  .busInst_stall       (mmc_riscv_inst.Stall),
  .busInst_rsp_ack     (mmc_riscv_inst.Ack  ),
  .busInst_rsp_err     (mmc_riscv_inst.Err  ),
  .busInst_rsp_rty     (mmc_riscv_inst.Rty  ),
  .busInst_rsp_data    (mmc_riscv_inst.Data ),
  .busInst_rsp_tga     (mmc_riscv_inst.Tga  ),
  .busInst_rsp_tgd     (mmc_riscv_inst.Tgd  ),
  .busInst_rsp_tgc     (mmc_riscv_inst.Tgc  ),
  .busData_req_cyc     (riscv_mmc_data.Cyc  ),
  .busData_req_stb     (riscv_mmc_data.Stb  ),
  .busData_req_we      (riscv_mmc_data.We   ),
  .busData_req_adr     (riscv_mmc_data.Adr  ),
  .busData_req_sel     ({riscv_mmc_data.Sel[0],
                         riscv_mmc_data.Sel[1],
                         riscv_mmc_data.Sel[2],
                         riscv_mmc_data.Sel[3]}),
  .busData_req_data    ({riscv_mmc_data.Data[7:0],  
                         riscv_mmc_data.Data[15:8], 
                         riscv_mmc_data.Data[23:16],
                         riscv_mmc_data.Data[31:24]}),
  .busData_req_tga     (riscv_mmc_data.Tga  ),
  .busData_req_tgd     (riscv_mmc_data.Tgd  ),
  .busData_req_tgc     (riscv_mmc_data.Tgc  ),
  .busData_stall       (mmc_riscv_data.Stall),
  .busData_rsp_ack     (mmc_riscv_data.Ack  ),
  .busData_rsp_err     (mmc_riscv_data.Err  ),
  .busData_rsp_rty     (mmc_riscv_data.Rty  ),
  .busData_rsp_data    ({mmc_riscv_data.Data[7:0],     
                         mmc_riscv_data.Data[15:8],    
                         mmc_riscv_data.Data[23:16],   
                         mmc_riscv_data.Data[31:24]}), 
  .busData_rsp_tga     (mmc_riscv_data.Tga  ),
  .busData_rsp_tgd     (mmc_riscv_data.Tgd  ),
  .busData_rsp_tgc     (mmc_riscv_data.Tgc  ),

  .rvfi_0_valid              (rvfi_valid[0]             ),
  .rvfi_0_order              (rvfi_order[0]             ),
  .rvfi_0_insn               (rvfi_insn[0]              ),
  .rvfi_0_trap               (rvfi_trap[0]              ),
  .rvfi_0_halt               (rvfi_halt[0]              ),
  .rvfi_0_intr               (rvfi_intr[0]              ),
  .rvfi_0_mode               (rvfi_mode[0]              ),
  .rvfi_0_rs1_addr           (rvfi_rs1_addr[0]          ),
  .rvfi_0_rs2_addr           (rvfi_rs2_addr[0]          ),
  .rvfi_0_rs1_rdata          (rvfi_rs1_rdata[0]         ),
  .rvfi_0_rs2_rdata          (rvfi_rs2_rdata [0]        ),
  .rvfi_0_rd_addr            (rvfi_rd_addr[0]           ),
  .rvfi_0_rd_wdata           (rvfi_rd_wdata[0]          ),
  .rvfi_0_pc_rdata           (rvfi_pc_rdata[0]          ),
  .rvfi_0_pc_wdata           (rvfi_pc_wdata[0]          ),
  .rvfi_0_mem_addr           (rvfi_mem_addr[0]          ),
  .rvfi_0_mem_rmask          (rvfi_mem_rmask[0]         ),
  .rvfi_0_mem_wmask          (rvfi_mem_wmask[0]         ),
  .rvfi_0_mem_rdata          (rvfi_mem_rdata[0]         ),
  .rvfi_0_mem_wdata          (rvfi_mem_wdata[0]         ),
  .rvfi_0_csr_mcycle_rmask   (rvfi_csr_mcycle_rmask[0]  ),
  .rvfi_0_csr_mcycle_wmask   (rvfi_csr_mcycle_wmask[0]  ),
  .rvfi_0_csr_mcycle_rdata   (rvfi_csr_mcycle_rdata[0]  ),
  .rvfi_0_csr_mcycle_wdata   (rvfi_csr_mcycle_wdata[0]  ),
  .rvfi_0_csr_minstret_rmask (rvfi_csr_minstret_rmask[0]),
  .rvfi_0_csr_minstret_wmask (rvfi_csr_minstret_wmask[0]),
  .rvfi_0_csr_minstret_rdata (rvfi_csr_minstret_rdata[0]),
  .rvfi_0_csr_minstret_wdata (rvfi_csr_minstret_wdata[0]),

  .rvfi_1_valid              (rvfi_valid[1]             ),
  .rvfi_1_order              (rvfi_order[1]             ),
  .rvfi_1_insn               (rvfi_insn[1]              ),
  .rvfi_1_trap               (rvfi_trap[1]              ),
  .rvfi_1_halt               (rvfi_halt[1]              ),
  .rvfi_1_intr               (rvfi_intr[1]              ),
  .rvfi_1_mode               (rvfi_mode[1]              ),
  .rvfi_1_rs1_addr           (rvfi_rs1_addr[1]          ),
  .rvfi_1_rs2_addr           (rvfi_rs2_addr[1]          ),
  .rvfi_1_rs1_rdata          (rvfi_rs1_rdata[1]         ),
  .rvfi_1_rs2_rdata          (rvfi_rs2_rdata [1]        ),
  .rvfi_1_rd_addr            (rvfi_rd_addr[1]           ),
  .rvfi_1_rd_wdata           (rvfi_rd_wdata[1]          ),
  .rvfi_1_pc_rdata           (rvfi_pc_rdata[1]          ),
  .rvfi_1_pc_wdata           (rvfi_pc_wdata[1]          ),
  .rvfi_1_mem_addr           (rvfi_mem_addr[1]          ),
  .rvfi_1_mem_rmask          (rvfi_mem_rmask[1]         ),
  .rvfi_1_mem_wmask          (rvfi_mem_wmask[1]         ),
  .rvfi_1_mem_rdata          (rvfi_mem_rdata[1]         ),
  .rvfi_1_mem_wdata          (rvfi_mem_wdata[1]         ),
  .rvfi_1_csr_mcycle_rmask   (rvfi_csr_mcycle_rmask[1]  ),
  .rvfi_1_csr_mcycle_wmask   (rvfi_csr_mcycle_wmask[1]  ),
  .rvfi_1_csr_mcycle_rdata   (rvfi_csr_mcycle_rdata[1]  ),
  .rvfi_1_csr_mcycle_wdata   (rvfi_csr_mcycle_wdata[1]  ),
  .rvfi_1_csr_minstret_rmask (rvfi_csr_minstret_rmask[1]),
  .rvfi_1_csr_minstret_wmask (rvfi_csr_minstret_wmask[1]),
  .rvfi_1_csr_minstret_rdata (rvfi_csr_minstret_rdata[1]),
  .rvfi_1_csr_minstret_wdata (rvfi_csr_minstret_wdata[1]),

  .rvfi_2_valid              (rvfi_valid[2]             ),
  .rvfi_2_order              (rvfi_order[2]             ),
  .rvfi_2_insn               (rvfi_insn[2]              ),
  .rvfi_2_trap               (rvfi_trap[2]              ),
  .rvfi_2_halt               (rvfi_halt[2]              ),
  .rvfi_2_intr               (rvfi_intr[2]              ),
  .rvfi_2_mode               (rvfi_mode[2]              ),
  .rvfi_2_rs1_addr           (rvfi_rs1_addr[2]          ),
  .rvfi_2_rs2_addr           (rvfi_rs2_addr[2]          ),
  .rvfi_2_rs1_rdata          (rvfi_rs1_rdata[2]         ),
  .rvfi_2_rs2_rdata          (rvfi_rs2_rdata [2]        ),
  .rvfi_2_rd_addr            (rvfi_rd_addr[2]           ),
  .rvfi_2_rd_wdata           (rvfi_rd_wdata[2]          ),
  .rvfi_2_pc_rdata           (rvfi_pc_rdata[2]          ),
  .rvfi_2_pc_wdata           (rvfi_pc_wdata[2]          ),
  .rvfi_2_mem_addr           (rvfi_mem_addr[2]          ),
  .rvfi_2_mem_rmask          (rvfi_mem_rmask[2]         ),
  .rvfi_2_mem_wmask          (rvfi_mem_wmask[2]         ),
  .rvfi_2_mem_rdata          (rvfi_mem_rdata[2]         ),
  .rvfi_2_mem_wdata          (rvfi_mem_wdata[2]         ),
  .rvfi_2_csr_mcycle_rmask   (rvfi_csr_mcycle_rmask[2]  ),
  .rvfi_2_csr_mcycle_wmask   (rvfi_csr_mcycle_wmask[2]  ),
  .rvfi_2_csr_mcycle_rdata   (rvfi_csr_mcycle_rdata[2]  ),
  .rvfi_2_csr_mcycle_wdata   (rvfi_csr_mcycle_wdata[2]  ),
  .rvfi_2_csr_minstret_rmask (rvfi_csr_minstret_rmask[2]),
  .rvfi_2_csr_minstret_wmask (rvfi_csr_minstret_wmask[2]),
  .rvfi_2_csr_minstret_rdata (rvfi_csr_minstret_rdata[2]),
  .rvfi_2_csr_minstret_wdata (rvfi_csr_minstret_wdata[2]),

  .rvfi_3_valid              (rvfi_valid[3]             ),
  .rvfi_3_order              (rvfi_order[3]             ),
  .rvfi_3_insn               (rvfi_insn[3]              ),
  .rvfi_3_trap               (rvfi_trap[3]              ),
  .rvfi_3_halt               (rvfi_halt[3]              ),
  .rvfi_3_intr               (rvfi_intr[3]              ),
  .rvfi_3_mode               (rvfi_mode[3]              ),
  .rvfi_3_rs1_addr           (rvfi_rs1_addr[3]          ),
  .rvfi_3_rs2_addr           (rvfi_rs2_addr[3]          ),
  .rvfi_3_rs1_rdata          (rvfi_rs1_rdata[3]         ),
  .rvfi_3_rs2_rdata          (rvfi_rs2_rdata [3]        ),
  .rvfi_3_rd_addr            (rvfi_rd_addr[3]           ),
  .rvfi_3_rd_wdata           (rvfi_rd_wdata[3]          ),
  .rvfi_3_pc_rdata           (rvfi_pc_rdata[3]          ),
  .rvfi_3_pc_wdata           (rvfi_pc_wdata[3]          ),
  .rvfi_3_mem_addr           (rvfi_mem_addr[3]          ),
  .rvfi_3_mem_rmask          (rvfi_mem_rmask[3]         ),
  .rvfi_3_mem_wmask          (rvfi_mem_wmask[3]         ),
  .rvfi_3_mem_rdata          (rvfi_mem_rdata[3]         ),
  .rvfi_3_mem_wdata          (rvfi_mem_wdata[3]         ),
  .rvfi_3_csr_mcycle_rmask   (rvfi_csr_mcycle_rmask[3]  ),
  .rvfi_3_csr_mcycle_wmask   (rvfi_csr_mcycle_wmask[3]  ),
  .rvfi_3_csr_mcycle_rdata   (rvfi_csr_mcycle_rdata[3]  ),
  .rvfi_3_csr_mcycle_wdata   (rvfi_csr_mcycle_wdata[3]  ),
  .rvfi_3_csr_minstret_rmask (rvfi_csr_minstret_rmask[3]),
  .rvfi_3_csr_minstret_wmask (rvfi_csr_minstret_wmask[3]),
  .rvfi_3_csr_minstret_rdata (rvfi_csr_minstret_rdata[3]),
  .rvfi_3_csr_minstret_wdata (rvfi_csr_minstret_wdata[3]),

  .rvfi_4_valid              (rvfi_valid[4]             ),
  .rvfi_4_order              (rvfi_order[4]             ),
  .rvfi_4_insn               (rvfi_insn[4]              ),
  .rvfi_4_trap               (rvfi_trap[4]              ),
  .rvfi_4_halt               (rvfi_halt[4]              ),
  .rvfi_4_intr               (rvfi_intr[4]              ),
  .rvfi_4_mode               (rvfi_mode[4]              ),
  .rvfi_4_rs1_addr           (rvfi_rs1_addr[4]          ),
  .rvfi_4_rs2_addr           (rvfi_rs2_addr[4]          ),
  .rvfi_4_rs1_rdata          (rvfi_rs1_rdata[4]         ),
  .rvfi_4_rs2_rdata          (rvfi_rs2_rdata [4]        ),
  .rvfi_4_rd_addr            (rvfi_rd_addr[4]           ),
  .rvfi_4_rd_wdata           (rvfi_rd_wdata[4]          ),
  .rvfi_4_pc_rdata           (rvfi_pc_rdata[4]          ),
  .rvfi_4_pc_wdata           (rvfi_pc_wdata[4]          ),
  .rvfi_4_mem_addr           (rvfi_mem_addr[4]          ),
  .rvfi_4_mem_rmask          (rvfi_mem_rmask[4]         ),
  .rvfi_4_mem_wmask          (rvfi_mem_wmask[4]         ),
  .rvfi_4_mem_rdata          (rvfi_mem_rdata[4]         ),
  .rvfi_4_mem_wdata          (rvfi_mem_wdata[4]         ),
  .rvfi_4_csr_mcycle_rmask   (rvfi_csr_mcycle_rmask[4]  ),
  .rvfi_4_csr_mcycle_wmask   (rvfi_csr_mcycle_wmask[4]  ),
  .rvfi_4_csr_mcycle_rdata   (rvfi_csr_mcycle_rdata[4]  ),
  .rvfi_4_csr_mcycle_wdata   (rvfi_csr_mcycle_wdata[4]  ),
  .rvfi_4_csr_minstret_rmask (rvfi_csr_minstret_rmask[4]),
  .rvfi_4_csr_minstret_wmask (rvfi_csr_minstret_wmask[4]),
  .rvfi_4_csr_minstret_rdata (rvfi_csr_minstret_rdata[4]),
  .rvfi_4_csr_minstret_wdata (rvfi_csr_minstret_wdata[4]),

  .rvfi_5_valid              (rvfi_valid[5]             ),
  .rvfi_5_order              (rvfi_order[5]             ),
  .rvfi_5_insn               (rvfi_insn[5]              ),
  .rvfi_5_trap               (rvfi_trap[5]              ),
  .rvfi_5_halt               (rvfi_halt[5]              ),
  .rvfi_5_intr               (rvfi_intr[5]              ),
  .rvfi_5_mode               (rvfi_mode[5]              ),
  .rvfi_5_rs1_addr           (rvfi_rs1_addr[5]          ),
  .rvfi_5_rs2_addr           (rvfi_rs2_addr[5]          ),
  .rvfi_5_rs1_rdata          (rvfi_rs1_rdata[5]         ),
  .rvfi_5_rs2_rdata          (rvfi_rs2_rdata [5]        ),
  .rvfi_5_rd_addr            (rvfi_rd_addr[5]           ),
  .rvfi_5_rd_wdata           (rvfi_rd_wdata[5]          ),
  .rvfi_5_pc_rdata           (rvfi_pc_rdata[5]          ),
  .rvfi_5_pc_wdata           (rvfi_pc_wdata[5]          ),
  .rvfi_5_mem_addr           (rvfi_mem_addr[5]          ),
  .rvfi_5_mem_rmask          (rvfi_mem_rmask[5]         ),
  .rvfi_5_mem_wmask          (rvfi_mem_wmask[5]         ),
  .rvfi_5_mem_rdata          (rvfi_mem_rdata[5]         ),
  .rvfi_5_mem_wdata          (rvfi_mem_wdata[5]         ),
  .rvfi_5_csr_mcycle_rmask   (rvfi_csr_mcycle_rmask[5]  ),
  .rvfi_5_csr_mcycle_wmask   (rvfi_csr_mcycle_wmask[5]  ),
  .rvfi_5_csr_mcycle_rdata   (rvfi_csr_mcycle_rdata[5]  ),
  .rvfi_5_csr_mcycle_wdata   (rvfi_csr_mcycle_wdata[5]  ),
  .rvfi_5_csr_minstret_rmask (rvfi_csr_minstret_rmask[5]),
  .rvfi_5_csr_minstret_wmask (rvfi_csr_minstret_wmask[5]),
  .rvfi_5_csr_minstret_rdata (rvfi_csr_minstret_rdata[5]),
  .rvfi_5_csr_minstret_wdata (rvfi_csr_minstret_wdata[5]),

  .clk                 (clk),
  .reset               (rst)
);

//riscv #(.M_EXT(1)) riscv (
//  .clk         (clk),
//  .rst         (rst),
//
//  .bus_inst_flat_o  (riscv_mmc_inst), 
//  .bus_inst_flat_i  (mmc_riscv_inst), 
//
//  .bus_data_flat_o  (riscv_mmc_data), 
//  .bus_data_flat_i  (mmc_riscv_data) 
//
//`ifdef RISCV_FORMAL
//  ,
//  .rvfi_valid              (rvfi_valid             ),
//  .rvfi_order              (rvfi_order             ),
//  .rvfi_insn               (rvfi_insn              ),
//  .rvfi_trap               (rvfi_trap              ),
//  .rvfi_halt               (rvfi_halt              ),
//  .rvfi_intr               (rvfi_intr              ),
//  .rvfi_mode               (rvfi_mode              ),
//  .rvfi_rs1_addr           (rvfi_rs1_addr          ),
//  .rvfi_rs2_addr           (rvfi_rs2_addr          ),
//  .rvfi_rs1_rdata          (rvfi_rs1_rdata         ),
//  .rvfi_rs2_rdata          (rvfi_rs2_rdata         ),
//  .rvfi_rd_addr            (rvfi_rd_addr           ),
//  .rvfi_rd_wdata           (rvfi_rd_wdata          ),
//  .rvfi_pc_rdata           (rvfi_pc_rdata          ),
//  .rvfi_pc_wdata           (rvfi_pc_wdata          ),
//  .rvfi_mem_addr           (rvfi_mem_addr          ),
//  .rvfi_mem_rmask          (rvfi_mem_rmask         ),
//  .rvfi_mem_wmask          (rvfi_mem_wmask         ),
//  .rvfi_mem_rdata          (rvfi_mem_rdata         ),
//  .rvfi_mem_wdata          (rvfi_mem_wdata         ),
//                                                              
//  .rvfi_csr_mcycle_rmask   (rvfi_csr_mcycle_rmask  ),
//  .rvfi_csr_mcycle_wmask   (rvfi_csr_mcycle_wmask  ),
//  .rvfi_csr_mcycle_rdata   (rvfi_csr_mcycle_rdata  ),
//  .rvfi_csr_mcycle_wdata   (rvfi_csr_mcycle_wdata  ),
//                                                              
//  .rvfi_csr_minstret_rmask (rvfi_csr_minstret_rmask),
//  .rvfi_csr_minstret_wmask (rvfi_csr_minstret_wmask),
//  .rvfi_csr_minstret_rdata (rvfi_csr_minstret_rdata),
//  .rvfi_csr_minstret_wdata (rvfi_csr_minstret_wdata)
//`endif
//);

  mmc_wb mmc_inst (
    .clk         (clk),
    .rst         (rst),
    
    .riscv_mmc_flat_i  (riscv_mmc_inst),
    .mmc_riscv_flat_o  (mmc_riscv_inst),
  
    .mmc_mem_flat_o    (mmc_mem_inst),
    .mem_mmc_flat_i    (mem_mmc_inst),
  
    .mmc_ddr3_flat_o   (mmc_ddr3_inst),
    .ddr3_mmc_flat_i   (ddr3_mmc_inst),
  
    .mmc_ddr3cntl_flat_o   (mmc_ddr3cntl_inst),
    .ddr3cntl_mmc_flat_i   (ddr3cntl_mmc_inst),
  
    .mmc_led_flat_o    (mmc_led_inst),
    .led_mmc_flat_i    (led_mmc_inst),
  
    .mmc_keys_flat_o   (mmc_keys_inst),
    .keys_mmc_flat_i   (keys_mmc_inst),
  
    .mmc_uart_flat_o   (mmc_uart_inst),
    .uart_mmc_flat_i   (uart_mmc_inst),
  
    .mmc_sdcard_flat_o (mmc_sdcard_inst),
    .sdcard_mmc_flat_i (sdcard_mmc_inst),
  
    .mmc_debug_flat_o  (mmc_debug_inst),
    .debug_mmc_flat_i  (debug_mmc_inst)
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
  
    .mmc_ddr3cntl_flat_o   (mmc_ddr3cntl_data),
    .ddr3cntl_mmc_flat_i   (ddr3cntl_mmc_data),
  
    .mmc_led_flat_o    (mmc_led_data),
    .led_mmc_flat_i    (led_mmc_data),
  
    .mmc_keys_flat_o   (mmc_keys_data),
    .keys_mmc_flat_i   (keys_mmc_data),
  
    .mmc_uart_flat_o   (mmc_uart_data),
    .uart_mmc_flat_i   (uart_mmc_data),
  
    .mmc_sdcard_flat_o (mmc_sdcard_data),
    .sdcard_mmc_flat_i (sdcard_mmc_data),
  
    .mmc_debug_flat_o  (mmc_debug_data),
    .debug_mmc_flat_i  (debug_mmc_data)
  );
  
  mem #(.SIZE(15)) mem (
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
  
    .bus_cntl_flat_i                (mmc_ddr3cntl_data),
    .bus_cntl_flat_o                (ddr3cntl_mmc_data),   
  
    .bus_inst_flat_i                (mmc_ddr3_inst),
    .bus_inst_flat_o                (ddr3_mmc_inst),   
  
    .bus_data_flat_i                (mmc_ddr3_data),
    .bus_data_flat_o                (ddr3_mmc_data)
  );
  
  //SpinalHDL version
  led_top led (
    .clk         (clk),
    .reset       (rst),
  
    .LED         (LED),
  
    .bus_req_cyc     (mmc_led_data.Cyc  ),
    .bus_req_stb     (mmc_led_data.Stb  ),
    .bus_req_we      (mmc_led_data.We   ),
    .bus_req_adr     (mmc_led_data.Adr  ),
    .bus_req_sel     (mmc_led_data.Sel  ),
    .bus_req_data    (mmc_led_data.Data ),
    .bus_req_tga     (mmc_led_data.Tga  ),
    .bus_req_tgd     (mmc_led_data.Tgd  ),
    .bus_req_tgc     (mmc_led_data.Tgc  ),
    .bus_stall       (led_mmc_data.Stall),
    .bus_rsp_ack     (led_mmc_data.Ack  ),
    .bus_rsp_err     (led_mmc_data.Err  ),
    .bus_rsp_rty     (led_mmc_data.Rty  ),
    .bus_rsp_data    (led_mmc_data.Data ),
    .bus_rsp_tga     (led_mmc_data.Tga  ),
    .bus_rsp_tgd     (led_mmc_data.Tgd  ),
    .bus_rsp_tgc     (led_mmc_data.Tgc  )
  );
  
  //SpinalHDL version
  keys_top keys (
    .clk         (clk),
    .reset       (rst),
  
    .KEY         (KEY),
  
    .bus_req_cyc     (mmc_keys_data.Cyc  ),
    .bus_req_stb     (mmc_keys_data.Stb  ),
    .bus_req_we      (mmc_keys_data.We   ),
    .bus_req_adr     (mmc_keys_data.Adr  ),
    .bus_req_sel     (mmc_keys_data.Sel  ),
    .bus_req_data    (mmc_keys_data.Data ),
    .bus_req_tga     (mmc_keys_data.Tga  ),
    .bus_req_tgd     (mmc_keys_data.Tgd  ),
    .bus_req_tgc     (mmc_keys_data.Tgc  ),
    .bus_stall       (keys_mmc_data.Stall),
    .bus_rsp_ack     (keys_mmc_data.Ack  ),
    .bus_rsp_err     (keys_mmc_data.Err  ),
    .bus_rsp_rty     (keys_mmc_data.Rty  ),
    .bus_rsp_data    (keys_mmc_data.Data ),
    .bus_rsp_tga     (keys_mmc_data.Tga  ),
    .bus_rsp_tgd     (keys_mmc_data.Tgd  ),
    .bus_rsp_tgc     (keys_mmc_data.Tgc  )
  );
  
  //SpinalHDL version
  uart_top uart (
    .clk         (clk),
    .reset       (rst),
  
    .IRQ         (IRQ[0]),

    .GND (GPIO_0_01),
    .TXD (GPIO_0_05),
    .RXD (GPIO_0_03),
    .CTS (GPIO_0_09),
    .RTS (GPIO_0_07),
  
    .bus_req_cyc     (mmc_uart_data.Cyc  ),
    .bus_req_stb     (mmc_uart_data.Stb  ),
    .bus_req_we      (mmc_uart_data.We   ),
    .bus_req_adr     (mmc_uart_data.Adr  ),
    .bus_req_sel     (mmc_uart_data.Sel  ),
    .bus_req_data    (mmc_uart_data.Data ),
    .bus_req_tga     (mmc_uart_data.Tga  ),
    .bus_req_tgd     (mmc_uart_data.Tgd  ),
    .bus_req_tgc     (mmc_uart_data.Tgc  ),
    .bus_stall       (uart_mmc_data.Stall),
    .bus_rsp_ack     (uart_mmc_data.Ack  ),
    .bus_rsp_err     (uart_mmc_data.Err  ),
    .bus_rsp_rty     (uart_mmc_data.Rty  ),
    .bus_rsp_data    (uart_mmc_data.Data ),
    .bus_rsp_tga     (uart_mmc_data.Tga  ),
    .bus_rsp_tgd     (uart_mmc_data.Tgd  ),
    .bus_rsp_tgc     (uart_mmc_data.Tgc  )
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
  
  debug #(.SIZE(7)) debug (
    .clk         (clk),
    .rst         (rst),
  
    .bus_inst_flat_i                (mmc_debug_inst),
    .bus_inst_flat_o                (debug_mmc_inst),   
  
    .bus_data_flat_i                (mmc_debug_data),
    .bus_data_flat_o                (debug_mmc_data)
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
