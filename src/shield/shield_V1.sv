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

  input  logic           mmc_sdcard_bus_req,
  input  logic           mmc_sdcard_bus_write,
  input  logic [31:0]    mmc_sdcard_bus_addr,
  input  logic [31:0]    mmc_sdcard_bus_data,
  input  logic  [3:0]    mmc_sdcard_bus_data_rd_mask,
  input  logic  [3:0]    mmc_sdcard_bus_data_wr_mask,

  output logic           sdcard_mmc_bus_ack,
  output logic [31:0]    sdcard_mmc_bus_data,

//////////// ADC //////////
output logic           ADC_CONVST,
output logic           ADC_SCK,
output logic           ADC_SDI,
input  logic           ADC_SDO,

//////////// ARDUINO //////////
//inout  logic [15:0]    ARDUINO_IO,
output logic  SD_CS, 
output logic  TFT_DC,
output logic  TFT_CS,
output logic  MOSI,  
input  logic  MISO,  
output logic  SCK,   
output logic  GND,   
inout  logic           ARDUINO_RESET_N

);

//IO
//logic SD_CS;
//logic TFT_DC;
//logic TFT_CS;
//logic MOSI;
//logic MISO;
//logic SCK;
//logic GND;

//assign SD_CS = '0;
assign GND = '0;

//assign ARDUINO_IO[0] = 'z;
//assign ARDUINO_IO[1] = 'z;
//assign ARDUINO_IO[2] = 'z;
//assign ARDUINO_IO[3] = 'z;
//assign ARDUINO_IO[4] = SD_CS;
//assign ARDUINO_IO[5] = 'z;
//assign ARDUINO_IO[6] = 'z;
//assign ARDUINO_IO[7] = 'z;
//assign ARDUINO_IO[8] = TFT_DC;
//assign ARDUINO_IO[9] = 'z;
//assign ARDUINO_IO[10] = TFT_CS;
//assign ARDUINO_IO[11] = MOSI;
//assign MISO = ARDUINO_IO[12];
//assign ARDUINO_IO[13] = SCK;
//assign ARDUINO_IO[14] = GND;
//assign ARDUINO_IO[15] = 'z;
assign arst = ~ARDUINO_RESET_N;

logic display_SPIReq;
logic display_SPIDone;
logic display_SCK;
logic display_CS;
logic display_RS_DC;
logic display_DATA;

logic sdcard_SPIReq;
logic sdcard_SCK;
logic sdcard_CS;
logic sdcard_RS_DC;
logic sdcard_DATA;

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

  .SPIReq  (display_SPIReq),
  .SPIAck  (display_SPIAck),
  .SPIDone (display_SPIDone),
  .SCK     (display_SCK),
  .CS      (display_CS),
  .RS_DC   (display_RS_DC),
  .DATA    (display_MOSI),

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

//SD Card
sdcard sdcard (
  .clk (clk),
  .rst (rst),
  .arst (arst),

  .SPIReq  (sdcard_SPIReq),
  .SPIAck  (sdcard_SPIAck),
  .SPIDone (sdcard_SPIDone),
  .SCK   (sdcard_SCK),
  .CS    (sdcard_CS),
  .RS_DC (sdcard_RS_DC),
  .DATA  (sdcard_MOSI),

  .i_bus_req           (mmc_sdcard_bus_req),   
  .i_bus_write         (mmc_sdcard_bus_write), 
  .i_bus_addr          (mmc_sdcard_bus_addr),  
  .i_bus_data          (mmc_sdcard_bus_data),
  .i_bus_data_rd_mask  (mmc_sdcard_bus_data_rd_mask) ,
  .i_bus_data_wr_mask  (mmc_sdcard_bus_data_wr_mask),

  .o_bus_ack           (sdcard_mmc_bus_ack),   
  .o_bus_data          (sdcard_mmc_bus_data)
);

spi_arb spi_arb (
  .clk             (clk           ),
  .rst             (rst           ),

  .SCK             (SCK           ),
  .DISPLAY_CS      (TFT_CS        ),
  .SDCARD_CS       (SD_CS         ),
  .RS_DC           (TFT_DC        ),
  .DATA            (MOSI          ),

  .display_SPIReq  (display_SPIReq),
  .display_SPIDone (display_SPIDone),
  .display_SCK     (display_SCK   ),
  .display_CS      (display_CS    ),
  .display_RS_DC   (display_RS_DC ),
  .display_DATA    (display_MOSI  ),

  .display_SPIAck  (display_SPIAck),

  .sdcard_SPIReq   (sdcard_SPIReq ),
  .sdcard_SPIDone  (sdcard_SPIDone),
  .sdcard_SCK      (sdcard_SCK    ),
  .sdcard_CS       (sdcard_CS     ),
  .sdcard_RS_DC    (sdcard_RS_DC  ),
  .sdcard_DATA     (sdcard_MOSI   ),

  .sdcard_SPIAck   (sdcard_SPIAck )
);

endmodule
