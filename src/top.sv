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
inout  logic  [35:0]   GPIO_0,

//////////// GPIO_1, GPIO connect to GPIO Default //////////
inout  logic  [35:0]   GPIO_1,

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
  output reg          rvfi_valid,
  output reg   [63:0] rvfi_order,
  output reg   [31:0] rvfi_insn,
  output reg          rvfi_trap,
  output reg          rvfi_halt,
  output reg          rvfi_intr,
  output reg   [ 1:0] rvfi_mode,
  output reg   [ 1:0] rvfi_ixl,
  output reg   [ 4:0] rvfi_rs1_addr,
  output reg   [ 4:0] rvfi_rs2_addr,
  output reg   [31:0] rvfi_rs1_rdata,
  output reg   [31:0] rvfi_rs2_rdata,
  output reg   [ 4:0] rvfi_rd_addr,
  output reg   [31:0] rvfi_rd_wdata,
  output reg   [31:0] rvfi_pc_rdata,
  output reg   [31:0] rvfi_pc_wdata,
  output reg   [31:0] rvfi_mem_addr,
  output reg   [ 3:0] rvfi_mem_rmask,
  output reg   [ 3:0] rvfi_mem_wmask,
  output reg   [31:0] rvfi_mem_rdata,
  output reg   [31:0] rvfi_mem_wdata,

  output reg   [63:0] rvfi_csr_mcycle_rmask,
  output reg   [63:0] rvfi_csr_mcycle_wmask,
  output reg   [63:0] rvfi_csr_mcycle_rdata,
  output reg   [63:0] rvfi_csr_mcycle_wdata,

  output reg   [63:0] rvfi_csr_minstret_rmask,
  output reg   [63:0] rvfi_csr_minstret_wmask,
  output reg   [63:0] rvfi_csr_minstret_rdata,
  output reg   [63:0] rvfi_csr_minstret_wdata,
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

logic           mmc_mem_instbus_req;
logic           mmc_mem_instbus_write;
logic [31:0]    mmc_mem_instbus_addr;
logic [31:0]    mmc_mem_instbus_data;
logic  [3:0]    mmc_mem_instbus_data_rd_mask;
logic  [3:0]    mmc_mem_instbus_data_wr_mask;

logic           mem_mmc_instbus_ack;
logic [31:0]    mem_mmc_instbus_data;

logic           mmc_ddr3_instbus_req;
logic           mmc_ddr3_instbus_write;
logic [31:0]    mmc_ddr3_instbus_addr;
logic [31:0]    mmc_ddr3_instbus_data;
logic  [3:0]    mmc_ddr3_instbus_data_rd_mask;
logic  [3:0]    mmc_ddr3_instbus_data_wr_mask;

logic           ddr3_mmc_instbus_ack;
logic [31:0]    ddr3_mmc_instbus_data;

logic           riscv_mmc_bus_req;
logic           riscv_mmc_bus_write;
logic [31:0]    riscv_mmc_bus_addr;
logic [31:0]    riscv_mmc_bus_data;
logic  [3:0]    riscv_mmc_bus_data_rd_mask;
logic  [3:0]    riscv_mmc_bus_data_wr_mask;

logic           mmc_riscv_bus_ack;
logic [31:0]    mmc_riscv_bus_data;

logic           mmc_mem_bus_req;
logic           mmc_mem_bus_write;
logic [31:0]    mmc_mem_bus_addr;
logic [31:0]    mmc_mem_bus_data;
logic  [3:0]    mmc_mem_bus_data_rd_mask;
logic  [3:0]    mmc_mem_bus_data_wr_mask;

logic           mem_mmc_bus_ack;
logic [31:0]    mem_mmc_bus_data;

logic           mmc_ddr3_bus_req;
logic           mmc_ddr3_bus_write;
logic [31:0]    mmc_ddr3_bus_addr;
logic [31:0]    mmc_ddr3_bus_data;
logic  [3:0]    mmc_ddr3_bus_data_rd_mask;
logic  [3:0]    mmc_ddr3_bus_data_wr_mask;

logic           ddr3_mmc_bus_ack;
logic [31:0]    ddr3_mmc_bus_data;

logic           mmc_led_bus_req;
logic           mmc_led_bus_write;
logic [31:0]    mmc_led_bus_addr;
logic [31:0]    mmc_led_bus_data;
logic  [3:0]    mmc_led_bus_data_rd_mask;
logic  [3:0]    mmc_led_bus_data_wr_mask;

logic           led_mmc_bus_ack;
logic [31:0]    led_mmc_bus_data;

logic           mmc_keys_bus_req;
logic           mmc_keys_bus_write;
logic [31:0]    mmc_keys_bus_addr;
logic [31:0]    mmc_keys_bus_data;
logic  [3:0]    mmc_keys_bus_data_rd_mask;
logic  [3:0]    mmc_keys_bus_data_wr_mask;

logic           keys_mmc_bus_ack;
logic [31:0]    keys_mmc_bus_data;

logic           mmc_touchpad_bus_req;
logic           mmc_touchpad_bus_write;
logic [31:0]    mmc_touchpad_bus_addr;
logic [31:0]    mmc_touchpad_bus_data;
logic  [3:0]    mmc_touchpad_bus_data_rd_mask;
logic  [3:0]    mmc_touchpad_bus_data_wr_mask;

logic           touchpad_mmc_bus_ack;
logic [31:0]    touchpad_mmc_bus_data;

logic           mmc_display_bus_req;
logic           mmc_display_bus_write;
logic [31:0]    mmc_display_bus_addr;
logic [31:0]    mmc_display_bus_data;
logic  [3:0]    mmc_display_bus_data_rd_mask;
logic  [3:0]    mmc_display_bus_data_wr_mask;

logic           display_mmc_bus_ack;
logic [31:0]    display_mmc_bus_data;

logic           mmc_dispbuff_bus_req;
logic           mmc_dispbuff_bus_write;
logic [31:0]    mmc_dispbuff_bus_addr;
logic [31:0]    mmc_dispbuff_bus_data;
logic  [3:0]    mmc_dispbuff_bus_data_rd_mask;
logic  [3:0]    mmc_dispbuff_bus_data_wr_mask;

logic           dispbuff_mmc_bus_ack;
logic [31:0]    dispbuff_mmc_bus_data;

logic           mmc_consolebuff_bus_req;
logic           mmc_consolebuff_bus_write;
logic [31:0]    mmc_consolebuff_bus_addr;
logic [31:0]    mmc_consolebuff_bus_data;
logic  [3:0]    mmc_consolebuff_bus_data_rd_mask;
logic  [3:0]    mmc_consolebuff_bus_data_wr_mask;

logic           consolebuff_mmc_bus_ack;
logic [31:0]    consolebuff_mmc_bus_data;

logic           mmc_uart_bus_req;
logic           mmc_uart_bus_write;
logic [31:0]    mmc_uart_bus_addr;
logic [31:0]    mmc_uart_bus_data;
logic  [3:0]    mmc_uart_bus_data_rd_mask;
logic  [3:0]    mmc_uart_bus_data_wr_mask;

logic           uart_mmc_bus_ack;
logic [31:0]    uart_mmc_bus_data;

logic           mmc_sdcard_bus_req;
logic           mmc_sdcard_bus_write;
logic [31:0]    mmc_sdcard_bus_addr;
logic [31:0]    mmc_sdcard_bus_data;
logic  [3:0]    mmc_sdcard_bus_data_rd_mask;
logic  [3:0]    mmc_sdcard_bus_data_wr_mask;

logic           sdcard_mmc_bus_ack;
logic [31:0]    sdcard_mmc_bus_data;

`ifndef SIM
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

  .i_membus_ack   (mmc_riscv_bus_ack),   
  .i_membus_data  (mmc_riscv_bus_data),

  .o_membus_req   (riscv_mmc_bus_req),   
  .o_membus_write (riscv_mmc_bus_write), 
  .o_membus_addr  (riscv_mmc_bus_addr),  
  .o_membus_data  (riscv_mmc_bus_data),
  .o_membus_data_rd_mask  (riscv_mmc_bus_data_rd_mask),
  .o_membus_data_wr_mask  (riscv_mmc_bus_data_wr_mask)

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
  .ddr3_mmc_tgc_i                (ddr3_mmc_inst_tgc)  

  //.riscv_mmc_bus_req             (riscv_mmc_instbus_req            ),    
  //.riscv_mmc_bus_write           ('0                               ),  
  //.riscv_mmc_bus_addr            (riscv_mmc_instbus_addr           ),   
  //.riscv_mmc_bus_data            (riscv_mmc_instbus_data           ),   
  //.riscv_mmc_bus_data_rd_mask    ('0                               ), 
  //.riscv_mmc_bus_data_wr_mask    ('0                               ), 
  //      
  //.mmc_riscv_bus_ack             (mmc_riscv_instbus_ack            ),
  //.mmc_riscv_bus_data            (mmc_riscv_instbus_data           ),
  //                                                               
  //.mmc_mem_bus_req               (mmc_mem_instbus_req              ),
  //.mmc_mem_bus_write             (mmc_mem_instbus_write            ),
  //.mmc_mem_bus_addr              (mmc_mem_instbus_addr             ),
  //.mmc_mem_bus_data              (mmc_mem_instbus_data             ),
  //.mmc_mem_bus_data_rd_mask      (mmc_mem_instbus_data_rd_mask     ),
  //.mmc_mem_bus_data_wr_mask      (mmc_mem_instbus_data_wr_mask     ),
  //                                                               
  //.mem_mmc_bus_ack               (mem_mmc_instbus_ack              ),
  //.mem_mmc_bus_data              (mem_mmc_instbus_data             ),
  //                                                               
  //.mmc_ddr3_bus_req              (mmc_ddr3_instbus_req             ),
  //.mmc_ddr3_bus_write            (mmc_ddr3_instbus_write           ),
  //.mmc_ddr3_bus_addr             (mmc_ddr3_instbus_addr            ),
  //.mmc_ddr3_bus_data             (mmc_ddr3_instbus_data            ),
  //.mmc_ddr3_bus_data_rd_mask     (mmc_ddr3_instbus_data_rd_mask    ),
  //.mmc_ddr3_bus_data_wr_mask     (mmc_ddr3_instbus_data_wr_mask    ),
  //                                                             
  //.ddr3_mmc_bus_ack              (ddr3_mmc_instbus_ack             ),
  //.ddr3_mmc_bus_data             (ddr3_mmc_instbus_data            ),
  //                                                               
  //.mmc_led_bus_req               (                             ),
  //.mmc_led_bus_write             (                             ),
  //.mmc_led_bus_addr              (                             ),
  //.mmc_led_bus_data              (                             ),
  //.mmc_led_bus_data_rd_mask      (                             ),
  //.mmc_led_bus_data_wr_mask      (                             ),
  //                                                               
  //.led_mmc_bus_ack               ('0                           ),
  //.led_mmc_bus_data              ('0                           ),
  //                                                               
  //.mmc_keys_bus_req              (                             ),
  //.mmc_keys_bus_write            (                             ),
  //.mmc_keys_bus_addr             (                             ),
  //.mmc_keys_bus_data             (                             ),
  //.mmc_keys_bus_data_rd_mask     (                             ),
  //.mmc_keys_bus_data_wr_mask     (                             ),
  //                                                               
  //.keys_mmc_bus_ack              ('0                           ),
  //.keys_mmc_bus_data             ('0                           ),
  //                                                               
  //.mmc_joystick_bus_req          (                             ),
  //.mmc_joystick_bus_write        (                             ),
  //.mmc_joystick_bus_addr         (                             ),
  //.mmc_joystick_bus_data         (                             ),
  //.mmc_joystick_bus_data_rd_mask (                             ),
  //.mmc_joystick_bus_data_wr_mask (                             ),
  //                                                               
  //.joystick_mmc_bus_ack          ('0                           ),
  //.joystick_mmc_bus_data         ('0                           ),
  //                                                               
  //.mmc_display_bus_req           (                             ),
  //.mmc_display_bus_write         (                             ),
  //.mmc_display_bus_addr          (                             ),
  //.mmc_display_bus_data          (                             ),
  //.mmc_display_bus_data_rd_mask  (                             ),
  //.mmc_display_bus_data_wr_mask  (                             ),
  //                                                               
  //.display_mmc_bus_ack           ('0                           ),
  //.display_mmc_bus_data          ('0                           ),
  //                                                               
  //.mmc_dispbuff_bus_req          (                             ),
  //.mmc_dispbuff_bus_write        (                             ),
  //.mmc_dispbuff_bus_addr         (                             ),
  //.mmc_dispbuff_bus_data         (                             ),
  //.mmc_dispbuff_bus_data_rd_mask (                             ),
  //.mmc_dispbuff_bus_data_wr_mask (                             ),
  //                                                               
  //.dispbuff_mmc_bus_ack          ('0                           ),
  //.dispbuff_mmc_bus_data         ('0                           ),

  //.mmc_consolebuff_bus_req          (                             ),
  //.mmc_consolebuff_bus_write        (                             ),
  //.mmc_consolebuff_bus_addr         (                             ),
  //.mmc_consolebuff_bus_data         (                             ),
  //.mmc_consolebuff_bus_data_rd_mask (                             ),
  //.mmc_consolebuff_bus_data_wr_mask (                             ),
  //                                                               
  //.consolebuff_mmc_bus_ack          ('0                           ),
  //.consolebuff_mmc_bus_data         ('0                           ),

  //.mmc_uart_bus_req          (                             ),
  //.mmc_uart_bus_write        (                             ),
  //.mmc_uart_bus_addr         (                             ),
  //.mmc_uart_bus_data         (                             ),
  //.mmc_uart_bus_data_rd_mask (                             ),
  //.mmc_uart_bus_data_wr_mask (                             ),
  //                                                               
  //.uart_mmc_bus_ack          ('0                           ),
  //.uart_mmc_bus_data         ('0                           ),

  //.mmc_sdcard_bus_req            (                             ),
  //.mmc_sdcard_bus_write          (                             ),
  //.mmc_sdcard_bus_addr           (                             ),
  //.mmc_sdcard_bus_data           (                             ),
  //.mmc_sdcard_bus_data_rd_mask   (                             ),
  //.mmc_sdcard_bus_data_wr_mask   (                             ),
  //                                                                 
  //.sdcard_mmc_bus_ack            ('0                           ),
  //.sdcard_mmc_bus_data           ('0                           )
);

mmc mmc_data (
  .clk         (clk),
  .rst         (rst),
  
  .riscv_mmc_bus_req             (riscv_mmc_bus_req            ),    
  .riscv_mmc_bus_write           (riscv_mmc_bus_write          ),  
  .riscv_mmc_bus_addr            (riscv_mmc_bus_addr           ),   
  .riscv_mmc_bus_data            (riscv_mmc_bus_data           ),   
  .riscv_mmc_bus_data_rd_mask    (riscv_mmc_bus_data_rd_mask   ), 
  .riscv_mmc_bus_data_wr_mask    (riscv_mmc_bus_data_wr_mask   ), 
        
  .mmc_riscv_bus_ack             (mmc_riscv_bus_ack            ),
  .mmc_riscv_bus_data            (mmc_riscv_bus_data           ),
                                                                 
  .mmc_mem_bus_req               (mmc_mem_bus_req              ),
  .mmc_mem_bus_write             (mmc_mem_bus_write            ),
  .mmc_mem_bus_addr              (mmc_mem_bus_addr             ),
  .mmc_mem_bus_data              (mmc_mem_bus_data             ),
  .mmc_mem_bus_data_rd_mask      (mmc_mem_bus_data_rd_mask     ),
  .mmc_mem_bus_data_wr_mask      (mmc_mem_bus_data_wr_mask     ),
                                                                 
  .mem_mmc_bus_ack               (mem_mmc_bus_ack              ),
  .mem_mmc_bus_data              (mem_mmc_bus_data             ),
                                                                 
  .mmc_ddr3_bus_req              (mmc_ddr3_bus_req             ),
  .mmc_ddr3_bus_write            (mmc_ddr3_bus_write           ),
  .mmc_ddr3_bus_addr             (mmc_ddr3_bus_addr            ),
  .mmc_ddr3_bus_data             (mmc_ddr3_bus_data            ),
  .mmc_ddr3_bus_data_rd_mask     (mmc_ddr3_bus_data_rd_mask    ),
  .mmc_ddr3_bus_data_wr_mask     (mmc_ddr3_bus_data_wr_mask    ),
                                                               
  .ddr3_mmc_bus_ack              (ddr3_mmc_bus_ack             ),
  .ddr3_mmc_bus_data             (ddr3_mmc_bus_data            ),
                                                                 
  .mmc_led_bus_req               (mmc_led_bus_req              ),
  .mmc_led_bus_write             (mmc_led_bus_write            ),
  .mmc_led_bus_addr              (mmc_led_bus_addr             ),
  .mmc_led_bus_data              (mmc_led_bus_data             ),
  .mmc_led_bus_data_rd_mask      (mmc_led_bus_data_rd_mask     ),
  .mmc_led_bus_data_wr_mask      (mmc_led_bus_data_wr_mask     ),
                                                                 
  .led_mmc_bus_ack               (led_mmc_bus_ack              ),
  .led_mmc_bus_data              (led_mmc_bus_data             ),
                                                                 
  .mmc_keys_bus_req              (mmc_keys_bus_req             ),
  .mmc_keys_bus_write            (mmc_keys_bus_write           ),
  .mmc_keys_bus_addr             (mmc_keys_bus_addr            ),
  .mmc_keys_bus_data             (mmc_keys_bus_data            ),
  .mmc_keys_bus_data_rd_mask     (mmc_keys_bus_data_rd_mask    ),
  .mmc_keys_bus_data_wr_mask     (mmc_keys_bus_data_wr_mask    ),
                                                                 
  .keys_mmc_bus_ack              (keys_mmc_bus_ack             ),
  .keys_mmc_bus_data             (keys_mmc_bus_data            ),
                                                                 
  .mmc_joystick_bus_req          (mmc_touchpad_bus_req         ),
  .mmc_joystick_bus_write        (mmc_touchpad_bus_write       ),
  .mmc_joystick_bus_addr         (mmc_touchpad_bus_addr        ),
  .mmc_joystick_bus_data         (mmc_touchpad_bus_data        ),
  .mmc_joystick_bus_data_rd_mask (mmc_touchpad_bus_data_rd_mask),
  .mmc_joystick_bus_data_wr_mask (mmc_touchpad_bus_data_wr_mask),
                                                                 
  .joystick_mmc_bus_ack          (touchpad_mmc_bus_ack         ),
  .joystick_mmc_bus_data         (touchpad_mmc_bus_data        ),
                                                                 
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
                                                                 
  .mmc_uart_bus_req          (mmc_uart_bus_req         ),
  .mmc_uart_bus_write        (mmc_uart_bus_write       ),
  .mmc_uart_bus_addr         (mmc_uart_bus_addr        ),
  .mmc_uart_bus_data         (mmc_uart_bus_data        ),
  .mmc_uart_bus_data_rd_mask (mmc_uart_bus_data_rd_mask),
  .mmc_uart_bus_data_wr_mask (mmc_uart_bus_data_wr_mask),
                                                                 
  .uart_mmc_bus_ack          (uart_mmc_bus_ack         ),
  .uart_mmc_bus_data         (uart_mmc_bus_data        ),
                                                                 
  .mmc_sdcard_bus_req            (mmc_sdcard_bus_req         ),
  .mmc_sdcard_bus_write          (mmc_sdcard_bus_write       ),
  .mmc_sdcard_bus_addr           (mmc_sdcard_bus_addr        ),
  .mmc_sdcard_bus_data           (mmc_sdcard_bus_data        ),
  .mmc_sdcard_bus_data_rd_mask   (mmc_sdcard_bus_data_rd_mask),
  .mmc_sdcard_bus_data_wr_mask   (mmc_sdcard_bus_data_wr_mask),
                                                                   
  .sdcard_mmc_bus_ack            (sdcard_mmc_bus_ack         ),
  .sdcard_mmc_bus_data           (sdcard_mmc_bus_data        )
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

  .i_membus_req           (mmc_mem_bus_req),   
  .i_membus_write         (mmc_mem_bus_write), 
  .i_membus_addr          (mmc_mem_bus_addr),  
  .i_membus_data          (mmc_mem_bus_data),
  .i_membus_data_rd_mask  (mmc_mem_bus_data_rd_mask),
  .i_membus_data_wr_mask  (mmc_mem_bus_data_wr_mask),

  .o_membus_ack           (mem_mmc_bus_ack),   
  .o_membus_data          (mem_mmc_bus_data)
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

  .i_instbus_req          (mmc_ddr3_instbus_req),   
  .i_instbus_addr         (mmc_ddr3_instbus_addr),  

  .o_instbus_ack          (ddr3_mmc_instbus_ack),   
  .o_instbus_data         (ddr3_mmc_instbus_data),

  .i_membus_req           (mmc_ddr3_bus_req),   
  .i_membus_write         (mmc_ddr3_bus_write), 
  .i_membus_addr          (mmc_ddr3_bus_addr),  
  .i_membus_data          (mmc_ddr3_bus_data),
  .i_membus_data_rd_mask  (mmc_ddr3_bus_data_rd_mask),
  .i_membus_data_wr_mask  (mmc_ddr3_bus_data_wr_mask),

  .o_membus_ack           (ddr3_mmc_bus_ack),   
  .o_membus_data          (ddr3_mmc_bus_data)
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
  
  .GND (GPIO_0[1]),
  .TXD (GPIO_0[5]),
  .RXD (GPIO_0[3]),
  .CTS (GPIO_0[9]),
  .RTS (GPIO_0[7]),

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
