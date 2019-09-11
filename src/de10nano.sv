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

logic        mem_led_bus_req;
logic        mem_led_bus_ack;
logic        mem_led_bus_write;
logic [31:0] mem_led_bus_addr;
logic [31:0] mem_led_bus_data;

logic        led_keys_bus_req;
logic        led_keys_bus_ack;
logic        led_keys_bus_write;
logic [31:0] led_keys_bus_addr;
logic [31:0] led_keys_bus_data;

logic        keys_shield_bus_req;
logic        keys_shield_bus_ack;
logic        keys_shield_bus_write;
logic [31:0] keys_shield_bus_addr;
logic [31:0] keys_shield_bus_data;

logic        shield_riscv_bus_req;
logic        shield_riscv_bus_ack;
logic        shield_riscv_bus_write;
logic [31:0] shield_riscv_bus_addr;
logic [31:0] shield_riscv_bus_data;

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

  .o_membus_req   (riscv_mem_bus_req),   
  .o_membus_ack   (riscv_mem_bus_ack),   
  .o_membus_write (riscv_mem_bus_write), 
  .o_membus_addr  (riscv_mem_bus_addr),  
  .o_membus_data  (riscv_mem_bus_data)
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

  .o_membus_req   (mem_led_bus_req),   
  .o_membus_ack   (mem_led_bus_ack),   
  .o_membus_write (mem_led_bus_write), 
  .o_membus_addr  (mem_led_bus_addr),  
  .o_membus_data  (mem_led_bus_data)
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

  .o_bus_req   (led_keys_bus_req),   
  .o_bus_ack   (led_keys_bus_ack),   
  .o_bus_write (led_keys_bus_write), 
  .o_bus_addr  (led_keys_bus_addr),  
  .o_bus_data  (led_keys_bus_data)
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

  .o_bus_req   (keys_shield_bus_req),   
  .o_bus_ack   (keys_shield_bus_ack),   
  .o_bus_write (keys_shield_bus_write), 
  .o_bus_addr  (keys_shield_bus_addr),  
  .o_bus_data  (keys_shield_bus_data)
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

  .o_bus_req   (shield_riscv_bus_req),   
  .o_bus_ack   (shield_riscv_bus_ack),   
  .o_bus_write (shield_riscv_bus_write), 
  .o_bus_addr  (shield_riscv_bus_addr),  
  .o_bus_data  (shield_riscv_bus_data)
);

endmodule
