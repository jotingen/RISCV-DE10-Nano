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

);

logic clk;

logic rst;
logic start;

logic        bus_req;
logic        bus_ack;
logic        bus_write;
logic [31:0] bus_addr;
logic [31:0] bus_data_wr;
logic [31:0] bus_data_rd;

logic        mem_bus_ack;
logic [31:0] mem_bus_data_rd;
logic        led_bus_ack;
logic [31:0] led_bus_data_rd;

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

assign start = ~KEY[1];

always_ff @(posedge clk)
  begin
  bus_ack     <= mem_bus_ack     | led_bus_ack    ;
  bus_data_rd <= mem_bus_data_rd | led_bus_data_rd;
  if(rst)
    begin
    bus_ack     <= '0;
    bus_data_rd <= '0;
    end
  end

riscv riscv (
  .clk (clk),
  .rst (rst),
  .start (start),

  .bus_req   (bus_req),   
  .bus_ack   (bus_ack),   
  .bus_write (bus_write), 
  .bus_addr  (bus_addr),  
  .bus_data_rd  (bus_data_rd),
  .bus_data_wr  (bus_data_wr)
);

mem #(.SIZE(18),.ADDR_BASE(32'h00000000)) mem (
  .clk (clk),
  .rst (rst),

  .bus_req   (bus_req),   
  .bus_ack   (mem_bus_ack),   
  .bus_write (bus_write), 
  .bus_addr  (bus_addr),  
  .bus_data_rd  (mem_bus_data_rd),
  .bus_data_wr  (bus_data_wr)
);

led #(.SIZE(1),.ADDR_BASE(32'hC0000000)) led (
  .clk (clk),
  .rst (rst),

  .LED (LED),

  .bus_req   (bus_req),   
  .bus_ack   (led_bus_ack),   
  .bus_write (bus_write), 
  .bus_addr  (bus_addr),  
  .bus_data_rd  (led_bus_data_rd),
  .bus_data_wr  (bus_data_wr)
);

shield_V1 shield (
  .clk (FPGA_CLK1_50),
  .rst (rst),

  .arst (arst),

  //.bus_req   (bus_req),   
  //.bus_ack   (bus_ack),   
  //.bus_write (bus_write), 
  //.bus_addr  (bus_addr),  
  //.bus_data  (bus_data), 

  .ADC_CONVST      (ADC_CONVST),     
  .ADC_SCK         (ADC_SCK),        
  .ADC_SDI         (ADC_SDI),        
  .ADC_SDO         (ADC_SDO),        
                                    
  .ARDUINO_IO      (ARDUINO_IO),     
  .ARDUINO_RESET_N (ARDUINO_RESET_N) 
);

endmodule
