module shield_V1 (

input  logic           clk,
input  logic           rst,
output logic           arst,

input  logic           i_bus_req,
input  logic           i_bus_ack,
input  logic           i_bus_write,
input  logic [31:0]    i_bus_addr,
input  logic [31:0]    i_bus_data,
input  logic  [3:0]    i_bus_data_rd_mask,
input  logic  [3:0]    i_bus_data_wr_mask,

output logic           o_bus_req,
output logic           o_bus_ack,
output logic           o_bus_write,
output logic [31:0]    o_bus_addr,
output logic [31:0]    o_bus_data,
output logic  [3:0]    o_bus_data_rd_mask,
output logic  [3:0]    o_bus_data_wr_mask,

//////////// ADC //////////
output logic           ADC_CONVST,
output logic           ADC_SCK,
output logic           ADC_SDI,
input  logic           ADC_SDO,

//////////// ARDUINO //////////
inout  logic [15:0]    ARDUINO_IO,
inout  logic           ARDUINO_RESET_N

);

logic        joystick_display_bus_req;
logic        joystick_display_bus_ack;
logic        joystick_display_bus_write;
logic [31:0] joystick_display_bus_addr;
logic [31:0] joystick_display_bus_data;
logic  [3:0] joystick_display_bus_data_rd_mask;
logic  [3:0] joystick_display_bus_data_wr_mask;

//IO
logic SD_CS;
logic TFT_DC;
logic TFT_CS;
logic MOSI;
logic MISO;
logic SCK;
logic GND;

assign SD_CS = '0;
assign MISO = '0;
assign GND = '0;

assign ARDUINO_IO[0] = 'z;
assign ARDUINO_IO[1] = 'z;
assign ARDUINO_IO[2] = 'z;
assign ARDUINO_IO[3] = 'z;
assign ARDUINO_IO[4] = SD_CS;
assign ARDUINO_IO[5] = 'z;
assign ARDUINO_IO[6] = 'z;
assign ARDUINO_IO[7] = 'z;
assign ARDUINO_IO[8] = TFT_DC;
assign ARDUINO_IO[9] = 'z;
assign ARDUINO_IO[10] = TFT_CS;
assign ARDUINO_IO[11] = MOSI;
assign ARDUINO_IO[12] = MISO;
assign ARDUINO_IO[13] = SCK;
assign ARDUINO_IO[14] = GND;
assign ARDUINO_IO[15] = 'z;
assign arst = ~ARDUINO_RESET_N;


//Joystick
joystick #(.SIZE(5),.ADDR_BASE(32'hC1000100)) joystick (
  .clk         (clk),
  .rst         (rst),

  .ADC_CONVST  (ADC_CONVST),     
  .ADC_SCK     (ADC_SCK),        
  .ADC_SDI     (ADC_SDI),        
  .ADC_SDO     (ADC_SDO),        

  .i_bus_req   (i_bus_req),   
  .i_bus_ack   (i_bus_ack),   
  .i_bus_write (i_bus_write), 
  .i_bus_addr  (i_bus_addr),  
  .i_bus_data  (i_bus_data),
  .i_bus_data_rd_mask  (i_bus_data_rd_mask),
  .i_bus_data_wr_mask  (i_bus_data_wr_mask),

  .o_bus_req   (joystick_display_bus_req),   
  .o_bus_ack   (joystick_display_bus_ack),   
  .o_bus_write (joystick_display_bus_write), 
  .o_bus_addr  (joystick_display_bus_addr),  
  .o_bus_data  (joystick_display_bus_data),
  .o_bus_data_rd_mask  (joystick_display_bus_data_rd_mask) ,
  .o_bus_data_wr_mask  (joystick_display_bus_data_wr_mask)
);


//Display
st7735r #(.SIZE(8),.ADDR_BASE(32'hC2000000))  display (
  .clk (clk),
  .rst (rst),
  .arst (arst),

  .RS_DC (TFT_DC),
  .SCK   (SCK),
  .DATA  (MOSI),
  .CS    (TFT_CS),

  .i_bus_req   (joystick_display_bus_req),   
  .i_bus_ack   (joystick_display_bus_ack),   
  .i_bus_write (joystick_display_bus_write), 
  .i_bus_addr  (joystick_display_bus_addr),  
  .i_bus_data  (joystick_display_bus_data),
  .i_bus_data_rd_mask  (joystick_display_bus_data_rd_mask) ,
  .i_bus_data_wr_mask  (joystick_display_bus_data_wr_mask),

  .o_bus_req   (o_bus_req),   
  .o_bus_ack   (o_bus_ack),   
  .o_bus_write (o_bus_write), 
  .o_bus_addr  (o_bus_addr),  
  .o_bus_data  (o_bus_data),
  .o_bus_data_rd_mask  (o_bus_data_rd_mask) ,
  .o_bus_data_wr_mask  (o_bus_data_wr_mask)
);
endmodule
