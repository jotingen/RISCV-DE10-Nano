module LC3(

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

);

logic clk;

logic        bus_req;
logic        bus_ack;
logic        bus_write;
logic [15:0] bus_addr;
logic [15:0] bus_data;

PLL pll (
  .inclk0 (FPGA_CLK1_50),
  .c0     (clk),
  .locked ()
);

LC3_core core (
  .clk (clk),
  .rst (KEY[0]),
  .start (KEY[1]),

  .bus_req   (bus_req),   
  .bus_ack   (bus_ack),   
  .bus_write (bus_write), 
  .bus_addr  (bus_addr),  
  .bus_data  (bus_data),  

  .led (LED)
);

LC3_mem_base #(.ADDR_LO(16'h0000), .ADDR_HI(16'h0FFF)) mem_base (
  .clk (clk),
  .rst (KEY[0]),

  .bus_req   (bus_req),   
  .bus_ack   (bus_ack),   
  .bus_write (bus_write), 
  .bus_addr  (bus_addr),  
  .bus_data  (bus_data)  
);

//LC3_mem #(.ADDR_LO(16'h1000), .ADDR_HI(16'h2FFF)) mem (
//  .clk (clk),
//  .rst (KEY[0]),
//
//  .bus_req   (bus_req),   
//  .bus_ack   (bus_ack),   
//  .bus_write (bus_write), 
//  .bus_addr  (bus_addr),  
//  .bus_data  (bus_data),  
//
//  .DRAM_ADDR  (DRAM_ADDR),  
//  .DRAM_BA    (DRAM_BA),    
//  .DRAM_CAS_N (DRAM_CAS_N), 
//  .DRAM_CKE   (DRAM_CKE),   
//  .DRAM_CLK   (DRAM_CLK),   
//  .DRAM_CS_N  (DRAM_CS_N),  
//  .DRAM_DQ    (DRAM_DQ),    
//  .DRAM_DQM   (DRAM_DQM),   
//  .DRAM_RAS_N (DRAM_RAS_N), 
//  .DRAM_WE_N  (DRAM_WE_N)   
//);

endmodule
