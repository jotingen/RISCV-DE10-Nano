module shield_V1 (

input  logic           clk,
input  logic           rst,
output logic           arst,

  input  logic           mmc_joystick_bus_req,
  input  logic           mmc_joystick_bus_write,
  input  logic [31:0]    mmc_joystick_bus_addr,
  input  logic [31:0]    mmc_joystick_bus_data,
  input  logic  [3:0]    mmc_joystick_bus_data_rd_mask,
  input  logic  [3:0]    mmc_joystick_bus_data_wr_mask,

  output logic           joystick_mmc_bus_ack,
  output logic [31:0]    joystick_mmc_bus_data,

  input  logic           mmc_display_bus_req,
  input  logic           mmc_display_bus_write,
  input  logic [31:0]    mmc_display_bus_addr,
  input  logic [31:0]    mmc_display_bus_data,
  input  logic  [3:0]    mmc_display_bus_data_rd_mask,
  input  logic  [3:0]    mmc_display_bus_data_wr_mask,

  output logic           display_mmc_bus_ack,
  output logic [31:0]    display_mmc_bus_data,

  input  logic           mmc_dispbuff_bus_req,
  input  logic           mmc_dispbuff_bus_write,
  input  logic [31:0]    mmc_dispbuff_bus_addr,
  input  logic [31:0]    mmc_dispbuff_bus_data,
  input  logic  [3:0]    mmc_dispbuff_bus_data_rd_mask,
  input  logic  [3:0]    mmc_dispbuff_bus_data_wr_mask,

  output logic           dispbuff_mmc_bus_ack,
  output logic [31:0]    dispbuff_mmc_bus_data,

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

logic        display_buffer_bus_req;
logic        display_buffer_bus_ack;
logic        display_buffer_bus_write;
logic [31:0] display_buffer_bus_addr;
logic [31:0] display_buffer_bus_data;
logic  [3:0] display_buffer_bus_data_rd_mask;
logic  [3:0] display_buffer_bus_data_wr_mask;

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
joystick #(.SIZE(5),.ADDR_BASE(32'h00000000)) joystick (
  .clk         (clk),
  .rst         (rst),

  .ADC_CONVST  (ADC_CONVST),     
  .ADC_SCK     (ADC_SCK),        
  .ADC_SDI     (ADC_SDI),        
  .ADC_SDO     (ADC_SDO),        

  .i_bus_req           (mmc_joystick_bus_req),   
  .i_bus_write         (mmc_joystick_bus_write), 
  .i_bus_addr          (mmc_joystick_bus_addr),  
  .i_bus_data          (mmc_joystick_bus_data),
  .i_bus_data_rd_mask  (mmc_joystick_bus_data_rd_mask),
  .i_bus_data_wr_mask  (mmc_joystick_bus_data_wr_mask),

  .o_bus_ack           (joystick_mmc_bus_ack),   
  .o_bus_data          (joystick_mmc_bus_data)
);


//Display
st7735r #(.SIZE(16),.ADDR_BASE(32'h00000000))  display (
  .clk (clk),
  .rst (rst),
  .arst (arst),

  .RS_DC (TFT_DC),
  .SCK   (SCK),
  .DATA  (MOSI),
  .CS    (TFT_CS),

  .i_bus_req           (mmc_display_bus_req),   
  .i_bus_write         (mmc_display_bus_write), 
  .i_bus_addr          (mmc_display_bus_addr),  
  .i_bus_data          (mmc_display_bus_data),
  .i_bus_data_rd_mask  (mmc_display_bus_data_rd_mask) ,
  .i_bus_data_wr_mask  (mmc_display_bus_data_wr_mask),

  .o_bus_ack           (display_mmc_bus_ack),   
  .o_bus_data          (display_mmc_bus_data)
);

//Display Buffer
st7735r_buffer #(.SIZE(17),.ADDR_BASE(32'h00000000))  display_buffer (
  .clk (clk),
  .rst (rst),

  .i_membus_req           (mmc_dispbuff_bus_req),   
  .i_membus_write         (mmc_dispbuff_bus_write), 
  .i_membus_addr          (mmc_dispbuff_bus_addr),  
  .i_membus_data          (mmc_dispbuff_bus_data),
  .i_membus_data_rd_mask  (mmc_dispbuff_bus_data_rd_mask) ,
  .i_membus_data_wr_mask  (mmc_dispbuff_bus_data_wr_mask),

  .o_membus_ack           (dispbuff_mmc_bus_ack),   
  .o_membus_data          (dispbuff_mmc_bus_data)
);
endmodule
