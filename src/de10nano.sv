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

logic        riscv_mem_instbus_req;
logic        riscv_mem_instbus_ack;
logic        riscv_mem_instbus_write;
logic [31:0] riscv_mem_instbus_addr;
logic [31:0] riscv_mem_instbus_data;

logic        mem_riscv_instbus_req;
logic        mem_riscv_instbus_ack;
logic        mem_riscv_instbus_write;
logic [31:0] mem_riscv_instbus_addr;
logic [31:0] mem_riscv_instbus_data;


logic        riscv_mem_bus_req;
logic        riscv_mem_bus_ack;
logic        riscv_mem_bus_write;
logic [31:0] riscv_mem_bus_addr;
logic [31:0] riscv_mem_bus_data;
logic  [3:0] riscv_mem_bus_data_rd_mask;
logic  [3:0] riscv_mem_bus_data_wr_mask;

logic        mem_led_bus_req;
logic        mem_led_bus_ack;
logic        mem_led_bus_write;
logic [31:0] mem_led_bus_addr;
logic [31:0] mem_led_bus_data;
logic  [3:0] mem_led_bus_data_rd_mask;
logic  [3:0] mem_led_bus_data_wr_mask;

logic        led_keys_bus_req;
logic        led_keys_bus_ack;
logic        led_keys_bus_write;
logic [31:0] led_keys_bus_addr;
logic [31:0] led_keys_bus_data;
logic  [3:0] led_keys_bus_data_rd_mask;
logic  [3:0] led_keys_bus_data_wr_mask;

logic        keys_shield_bus_req;
logic        keys_shield_bus_ack;
logic        keys_shield_bus_write;
logic [31:0] keys_shield_bus_addr;
logic [31:0] keys_shield_bus_data;
logic  [3:0] keys_shield_bus_data_rd_mask;
logic  [3:0] keys_shield_bus_data_wr_mask;

logic        shield_riscv_bus_req;
logic        shield_riscv_bus_ack;
logic        shield_riscv_bus_write;
logic [31:0] shield_riscv_bus_addr;
logic [31:0] shield_riscv_bus_data;
logic  [3:0] shield_riscv_bus_data_rd_mask;
logic  [3:0] shield_riscv_bus_data_wr_mask;

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

riscv riscv (
  .clk         (clk),
  .rst         (rst),

  .i_instbus_req   (mem_riscv_instbus_req),  
  .i_instbus_ack   (mem_riscv_instbus_ack),  
  .i_instbus_write (mem_riscv_instbus_write),
  .i_instbus_addr  (mem_riscv_instbus_addr), 
  .i_instbus_data  (mem_riscv_instbus_data), 
                                            
  .o_instbus_req   (riscv_mem_instbus_req),     
  .o_instbus_ack   (riscv_mem_instbus_ack),     
  .o_instbus_write (riscv_mem_instbus_write),   
  .o_instbus_addr  (riscv_mem_instbus_addr),    
  .o_instbus_data  (riscv_mem_instbus_data),    

  .i_membus_req   (shield_riscv_bus_req),   
  .i_membus_ack   (shield_riscv_bus_ack),   
  .i_membus_write (shield_riscv_bus_write), 
  .i_membus_addr  (shield_riscv_bus_addr),  
  .i_membus_data  (shield_riscv_bus_data),
  .i_membus_data_rd_mask  (shield_riscv_bus_data_rd_mask),
  .i_membus_data_wr_mask  (shield_riscv_bus_data_wr_mask),

  .o_membus_req   (riscv_mem_bus_req),   
  .o_membus_ack   (riscv_mem_bus_ack),   
  .o_membus_write (riscv_mem_bus_write), 
  .o_membus_addr  (riscv_mem_bus_addr),  
  .o_membus_data  (riscv_mem_bus_data),
  .o_membus_data_rd_mask  (riscv_mem_bus_data_rd_mask),
  .o_membus_data_wr_mask  (riscv_mem_bus_data_wr_mask)

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

mem #(.SIZE(17),.ADDR_BASE(32'h00000000)) mem (
  .clk         (clk),
  .rst         (rst),

  .i_instbus_req   (riscv_mem_instbus_req),   
  .i_instbus_ack   (riscv_mem_instbus_ack),   
  .i_instbus_write (riscv_mem_instbus_write), 
  .i_instbus_addr  (riscv_mem_instbus_addr),  
  .i_instbus_data  (riscv_mem_instbus_data),

  .o_instbus_req   (mem_riscv_instbus_req),   
  .o_instbus_ack   (mem_riscv_instbus_ack),   
  .o_instbus_write (mem_riscv_instbus_write), 
  .o_instbus_addr  (mem_riscv_instbus_addr),  
  .o_instbus_data  (mem_riscv_instbus_data),

  .i_membus_req   (riscv_mem_bus_req),   
  .i_membus_ack   (riscv_mem_bus_ack),   
  .i_membus_write (riscv_mem_bus_write), 
  .i_membus_addr  (riscv_mem_bus_addr),  
  .i_membus_data  (riscv_mem_bus_data),
  .i_membus_data_rd_mask  (riscv_mem_bus_data_rd_mask),
  .i_membus_data_wr_mask  (riscv_mem_bus_data_wr_mask),

  .o_membus_req   (mem_led_bus_req),   
  .o_membus_ack   (mem_led_bus_ack),   
  .o_membus_write (mem_led_bus_write), 
  .o_membus_addr  (mem_led_bus_addr),  
  .o_membus_data  (mem_led_bus_data),
  .o_membus_data_rd_mask  (mem_led_bus_data_rd_mask),
  .o_membus_data_wr_mask  (mem_led_bus_data_wr_mask)
);

led #(.SIZE(5),.ADDR_BASE(32'hC0000000)) led (
  .clk         (clk),
  .rst         (rst),

  .LED         (LED),

  .i_bus_req   (mem_led_bus_req),   
  .i_bus_ack   (mem_led_bus_ack),   
  .i_bus_write (mem_led_bus_write), 
  .i_bus_addr  (mem_led_bus_addr),  
  .i_bus_data  (mem_led_bus_data),
  .i_bus_data_rd_mask  (mem_led_bus_data_rd_mask),
  .i_bus_data_wr_mask  (mem_led_bus_data_wr_mask),

  .o_bus_req   (led_keys_bus_req),   
  .o_bus_ack   (led_keys_bus_ack),   
  .o_bus_write (led_keys_bus_write), 
  .o_bus_addr  (led_keys_bus_addr),  
  .o_bus_data  (led_keys_bus_data),
  .o_bus_data_rd_mask  (led_keys_bus_data_rd_mask),
  .o_bus_data_wr_mask  (led_keys_bus_data_wr_mask)
);

keys #(.SIZE(5),.ADDR_BASE(32'hC1000000)) keys (
  .clk         (clk),
  .rst         (rst),

  .KEY         (KEY),

  .i_bus_req   (led_keys_bus_req),   
  .i_bus_ack   (led_keys_bus_ack),   
  .i_bus_write (led_keys_bus_write), 
  .i_bus_addr  (led_keys_bus_addr),  
  .i_bus_data  (led_keys_bus_data),
  .i_bus_data_rd_mask  (led_keys_bus_data_rd_mask),
  .i_bus_data_wr_mask  (led_keys_bus_data_wr_mask),

  .o_bus_req   (keys_shield_bus_req),   
  .o_bus_ack   (keys_shield_bus_ack),   
  .o_bus_write (keys_shield_bus_write), 
  .o_bus_addr  (keys_shield_bus_addr),  
  .o_bus_data  (keys_shield_bus_data),
  .o_bus_data_rd_mask  (keys_shield_bus_data_rd_mask),
  .o_bus_data_wr_mask  (keys_shield_bus_data_wr_mask)
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

  .i_bus_req   (keys_shield_bus_req),   
  .i_bus_ack   (keys_shield_bus_ack),   
  .i_bus_write (keys_shield_bus_write), 
  .i_bus_addr  (keys_shield_bus_addr),  
  .i_bus_data  (keys_shield_bus_data),
  .i_bus_data_rd_mask  (keys_shield_bus_data_rd_mask),
  .i_bus_data_wr_mask  (keys_shield_bus_data_wr_mask),

  .o_bus_req   (shield_riscv_bus_req),   
  .o_bus_ack   (shield_riscv_bus_ack),   
  .o_bus_write (shield_riscv_bus_write), 
  .o_bus_addr  (shield_riscv_bus_addr),  
  .o_bus_data  (shield_riscv_bus_data),
  .o_bus_data_rd_mask  (shield_riscv_bus_data_rd_mask),
  .o_bus_data_wr_mask  (shield_riscv_bus_data_wr_mask)
);

endmodule
