module de10nano(

//////////// CLOCK //////////
input  logic           FPGA_CLK1_50,
input  logic           FPGA_CLK2_50,
input  logic           FPGA_CLK3_50,

//////////// LED //////////
output logic  [7:0]    LED,

//////////// KEY //////////
input  logic  [1:0]    KEY,

//////////// SW //////////
input  logic  [3:0]    SW,

//////////// ADC //////////
output logic           ADC_CONVST,
output logic           ADC_SCK,
output logic           ADC_SDI,
input  logic           ADC_SDO,

//////////// ARDUINO //////////
inout  logic  [15:0]   ARDUINO_IO,
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
);

`ifndef RISCV_FORMAL
  logic clk;
  logic rst;
`endif

logic           riscv_mmc_instbus_req;
logic [31:0]    riscv_mmc_instbus_addr;

logic           mmc_riscv_instbus_ack;
logic [31:0]    mmc_riscv_instbus_data;

logic           mmc_mem_instbus_req;
logic [31:0]    mmc_mem_instbus_addr;

logic           mem_mmc_instbus_ack;
logic [31:0]    mem_mmc_instbus_data;

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

logic           mmc_joystick_bus_req;
logic           mmc_joystick_bus_write;
logic [31:0]    mmc_joystick_bus_addr;
logic [31:0]    mmc_joystick_bus_data;
logic  [3:0]    mmc_joystick_bus_data_rd_mask;
logic  [3:0]    mmc_joystick_bus_data_wr_mask;

logic           joystick_mmc_bus_ack;
logic [31:0]    joystick_mmc_bus_data;

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

logic arst;
logic arst_1;
logic arst_2;
logic arst_3;

always @(posedge clk)
  begin
  arst_1 <= arst;
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

riscv #(.M_EXT(1)) riscv (
  .clk         (clk),
  .rst         (rst),

  .i_instbus_ack   (mmc_riscv_instbus_ack),  
  .i_instbus_data  (mmc_riscv_instbus_data), 
                                            
  .o_instbus_req   (riscv_mmc_instbus_req),     
  .o_instbus_write (riscv_mmc_instbus_write),   
  .o_instbus_addr  (riscv_mmc_instbus_addr),    
  .o_instbus_data  (riscv_mmc_instbus_data),    

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

mmc mmc_inst (
  .clk         (clk),
  .rst         (rst),
  
  .riscv_mmc_bus_req             (riscv_mmc_instbus_req            ),    
  .riscv_mmc_bus_write           ('0                               ),  
  .riscv_mmc_bus_addr            (riscv_mmc_instbus_addr           ),   
  .riscv_mmc_bus_data            (riscv_mmc_instbus_data           ),   
  .riscv_mmc_bus_data_rd_mask    ('0                               ), 
  .riscv_mmc_bus_data_wr_mask    ('0                               ), 
        
  .mmc_riscv_bus_ack             (mmc_riscv_instbus_ack            ),
  .mmc_riscv_bus_data            (mmc_riscv_instbus_data           ),
                                                                 
  .mmc_mem_bus_req               (mmc_mem_instbus_req              ),
  .mmc_mem_bus_write             (mmc_mem_instbus_write            ),
  .mmc_mem_bus_addr              (mmc_mem_instbus_addr             ),
  .mmc_mem_bus_data              (mmc_mem_instbus_data             ),
  .mmc_mem_bus_data_rd_mask      (mmc_mem_instbus_data_rd_mask     ),
  .mmc_mem_bus_data_wr_mask      (mmc_mem_instbus_data_wr_mask     ),
                                                                 
  .mem_mmc_bus_ack               (mem_mmc_instbus_ack              ),
  .mem_mmc_bus_data              (mem_mmc_instbus_data             ),
                                                                 
  .mmc_led_bus_req               (                             ),
  .mmc_led_bus_write             (                             ),
  .mmc_led_bus_addr              (                             ),
  .mmc_led_bus_data              (                             ),
  .mmc_led_bus_data_rd_mask      (                             ),
  .mmc_led_bus_data_wr_mask      (                             ),
                                                                 
  .led_mmc_bus_ack               ('0                           ),
  .led_mmc_bus_data              ('0                           ),
                                                                 
  .mmc_keys_bus_req              (                             ),
  .mmc_keys_bus_write            (                             ),
  .mmc_keys_bus_addr             (                             ),
  .mmc_keys_bus_data             (                             ),
  .mmc_keys_bus_data_rd_mask     (                             ),
  .mmc_keys_bus_data_wr_mask     (                             ),
                                                                 
  .keys_mmc_bus_ack              ('0                           ),
  .keys_mmc_bus_data             ('0                           ),
                                                                 
  .mmc_joystick_bus_req          (                             ),
  .mmc_joystick_bus_write        (                             ),
  .mmc_joystick_bus_addr         (                             ),
  .mmc_joystick_bus_data         (                             ),
  .mmc_joystick_bus_data_rd_mask (                             ),
  .mmc_joystick_bus_data_wr_mask (                             ),
                                                                 
  .joystick_mmc_bus_ack          ('0                           ),
  .joystick_mmc_bus_data         ('0                           ),
                                                                 
  .mmc_display_bus_req           (                             ),
  .mmc_display_bus_write         (                             ),
  .mmc_display_bus_addr          (                             ),
  .mmc_display_bus_data          (                             ),
  .mmc_display_bus_data_rd_mask  (                             ),
  .mmc_display_bus_data_wr_mask  (                             ),
                                                                 
  .display_mmc_bus_ack           ('0                           ),
  .display_mmc_bus_data          ('0                           ),
                                                                 
  .mmc_dispbuff_bus_req          (                             ),
  .mmc_dispbuff_bus_write        (                             ),
  .mmc_dispbuff_bus_addr         (                             ),
  .mmc_dispbuff_bus_data         (                             ),
  .mmc_dispbuff_bus_data_rd_mask (                             ),
  .mmc_dispbuff_bus_data_wr_mask (                             ),
                                                                 
  .dispbuff_mmc_bus_ack          ('0                           ),
  .dispbuff_mmc_bus_data         ('0                           )
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
                                                                 
  .mmc_joystick_bus_req          (mmc_joystick_bus_req         ),
  .mmc_joystick_bus_write        (mmc_joystick_bus_write       ),
  .mmc_joystick_bus_addr         (mmc_joystick_bus_addr        ),
  .mmc_joystick_bus_data         (mmc_joystick_bus_data        ),
  .mmc_joystick_bus_data_rd_mask (mmc_joystick_bus_data_rd_mask),
  .mmc_joystick_bus_data_wr_mask (mmc_joystick_bus_data_wr_mask),
                                                                 
  .joystick_mmc_bus_ack          (joystick_mmc_bus_ack         ),
  .joystick_mmc_bus_data         (joystick_mmc_bus_data        ),
                                                                 
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
  .dispbuff_mmc_bus_data         (dispbuff_mmc_bus_data        )
);

mem #(.SIZE(17),.ADDR_BASE(32'h00000000)) mem (
  .clk         (clk),
  .rst         (rst),

  .i_instbus_req          (mmc_mem_instbus_req),   
  .i_instbus_addr         (mmc_mem_instbus_addr),  

  .o_instbus_ack          (mem_mmc_instbus_ack),   
  .o_instbus_data         (mem_mmc_instbus_data),

  .i_membus_req           (mmc_mem_bus_req),   
  .i_membus_write         (mmc_mem_bus_write), 
  .i_membus_addr          (mmc_mem_bus_addr),  
  .i_membus_data          (mmc_mem_bus_data),
  .i_membus_data_rd_mask  (mmc_mem_bus_data_rd_mask),
  .i_membus_data_wr_mask  (mmc_mem_bus_data_wr_mask),

  .o_membus_ack           (mem_mmc_bus_ack),   
  .o_membus_data          (mem_mmc_bus_data)
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

shield_V1 shield (
  .clk (FPGA_CLK1_50),
  .rst (rst),

  .arst (arst),

  .ADC_CONVST      (ADC_CONVST),     
  .ADC_SCK         (ADC_SCK),        
  .ADC_SDI         (ADC_SDI),        
  .ADC_SDO         (ADC_SDO),        
                                    
  .ARDUINO_IO      (ARDUINO_IO),     
  .ARDUINO_RESET_N (ARDUINO_RESET_N),

  .mmc_joystick_bus_req          (mmc_joystick_bus_req         ),
  .mmc_joystick_bus_write        (mmc_joystick_bus_write       ),
  .mmc_joystick_bus_addr         (mmc_joystick_bus_addr        ),
  .mmc_joystick_bus_data         (mmc_joystick_bus_data        ),
  .mmc_joystick_bus_data_rd_mask (mmc_joystick_bus_data_rd_mask),
  .mmc_joystick_bus_data_wr_mask (mmc_joystick_bus_data_wr_mask),
                                                                 
  .joystick_mmc_bus_ack          (joystick_mmc_bus_ack         ),
  .joystick_mmc_bus_data         (joystick_mmc_bus_data        ),
                                                                 
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
  .dispbuff_mmc_bus_data         (dispbuff_mmc_bus_data        )
);

endmodule
