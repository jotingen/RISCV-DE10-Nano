module waveshare_tft_touch_shield (

input  logic           clk,
input  logic           rst,
output logic           arst,

  input  logic           mmc_touchpad_bus_req,
  input  logic           mmc_touchpad_bus_write,
  input  logic [31:0]    mmc_touchpad_bus_addr,
  input  logic [31:0]    mmc_touchpad_bus_data,
  input  logic  [3:0]    mmc_touchpad_bus_data_rd_mask,
  input  logic  [3:0]    mmc_touchpad_bus_data_wr_mask,

  output logic           touchpad_mmc_bus_ack,
  output logic [31:0]    touchpad_mmc_bus_data,

  input  logic           mmc_display_bus_req,
  input  logic           mmc_display_bus_write,
  input  logic [31:0]    mmc_display_bus_addr,
  input  logic [31:0]    mmc_display_bus_data,
  input  logic  [3:0]    mmc_display_bus_data_rd_mask,
  input  logic  [3:0]    mmc_display_bus_data_wr_mask,

  output logic           display_mmc_bus_ack,
  output logic [31:0]    display_mmc_bus_data,

  input  logic           mmc_consolebuff_bus_req,
  input  logic           mmc_consolebuff_bus_write,
  input  logic [31:0]    mmc_consolebuff_bus_addr,
  input  logic [31:0]    mmc_consolebuff_bus_data,
  input  logic  [3:0]    mmc_consolebuff_bus_data_rd_mask,
  input  logic  [3:0]    mmc_consolebuff_bus_data_wr_mask,

  output logic           consolebuff_mmc_bus_ack,
  output logic [31:0]    consolebuff_mmc_bus_data,

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

inout  logic           ARDUINO_RESET_N

);

//IO
logic SCLK;
logic MISO;
logic MOSI;
logic LCD_CS;
logic LCD_BL;
logic LCD_RST;
logic LCD_DC;
logic TP_BUSY;
logic SD_CS;
logic TP_CS;
logic TP_IRQ;

assign GND = '0;
assign LCD_RST = ~rst;
assign LCD_BL = '1;
assign TP_CS = '1;

assign ARDUINO_IO_00 = 'z;
assign ARDUINO_IO_01 = 'z;
assign ARDUINO_IO_02 = 'z;
assign ARDUINO_IO_03 = 'z;
assign ARDUINO_IO_04 = TP_CS;
assign ARDUINO_IO_05 = SD_CS;
assign ARDUINO_IO_06 = 'z;
assign ARDUINO_IO_07 = LCD_DC;
assign ARDUINO_IO_08 = LCD_RST;
assign ARDUINO_IO_09 = LCD_BL;
assign ARDUINO_IO_10 = LCD_CS;
assign ARDUINO_IO_11 = MOSI;
assign ARDUINO_IO_12 = 'z;
assign ARDUINO_IO_13 = SCLK;
assign ARDUINO_IO_14 = GND;
assign ARDUINO_IO_15 = 'z;
assign TP_IRQ  = ARDUINO_IO_03;
assign TP_BUSY = ARDUINO_IO_06;
assign MISO    = ARDUINO_IO_12;

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

////Joystick
//joystick #(.SIZE(5),.ADDR_BASE(32'h00000000)) joystick (
//  .clk         (clk),
//  .rst         (rst),
//
//  .ADC_CONVST  (ADC_CONVST),     
//  .ADC_SCK     (ADC_SCK),        
//  .ADC_SDI     (ADC_SDI),        
//  .ADC_SDO     (ADC_SDO),        
//
//  .i_bus_req           (mmc_joystick_bus_req),   
//  .i_bus_write         (mmc_joystick_bus_write), 
//  .i_bus_addr          (mmc_joystick_bus_addr),  
//  .i_bus_data          (mmc_joystick_bus_data),
//  .i_bus_data_rd_mask  (mmc_joystick_bus_data_rd_mask),
//  .i_bus_data_wr_mask  (mmc_joystick_bus_data_wr_mask),
//
//  .o_bus_ack           (joystick_mmc_bus_ack),   
//  .o_bus_data          (joystick_mmc_bus_data)
//);


//Display
ILI9486 display (
  .clk (clk),
  .rst (rst),

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
ILI9486_buffer display_buffer (
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

//Console Buffer
console_buffer console_buffer (
  .clk (clk),
  .rst (rst),

  .i_membus_req           (mmc_consolebuff_bus_req),   
  .i_membus_write         (mmc_consolebuff_bus_write), 
  .i_membus_addr          (mmc_consolebuff_bus_addr),  
  .i_membus_data          (mmc_consolebuff_bus_data),
  .i_membus_data_rd_mask  (mmc_consolebuff_bus_data_rd_mask) ,
  .i_membus_data_wr_mask  (mmc_consolebuff_bus_data_wr_mask),

  .o_membus_ack           (consolebuff_mmc_bus_ack),   
  .o_membus_data          (consolebuff_mmc_bus_data)
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
  .MOSI  (sdcard_MOSI),
  .MISO  (MISO),

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

  .SCK             (SCLK          ),
  .DISPLAY_CS      (LCD_CS        ),
  .SDCARD_CS       (SD_CS         ),
  .RS_DC           (LCD_DC        ),
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
