import wishbone_pkg::*;

module waveshare_tft_touch_shield (

  input  logic           clk,
  input  logic           rst,
  output logic           arst,

  input  logic [$bits(wishbone_pkg::bus_req_t)-1:0] touchpad_data_flat_i,
  output logic [$bits(wishbone_pkg::bus_rsp_t)-1:0] touchpad_data_flat_o,

  input  logic [$bits(wishbone_pkg::bus_req_t)-1:0] display_data_flat_i,
  output logic [$bits(wishbone_pkg::bus_rsp_t)-1:0] display_data_flat_o,

  input  logic [$bits(wishbone_pkg::bus_req_t)-1:0] consolebuff_data_flat_i,
  output logic [$bits(wishbone_pkg::bus_rsp_t)-1:0] consolebuff_data_flat_o,

  input  logic [$bits(wishbone_pkg::bus_req_t)-1:0] displaybuff_data_flat_i,
  output logic [$bits(wishbone_pkg::bus_rsp_t)-1:0] displaybuff_data_flat_o,

  input  logic [$bits(wishbone_pkg::bus_req_t)-1:0] sdcard_data_flat_i,
  output logic [$bits(wishbone_pkg::bus_rsp_t)-1:0] sdcard_data_flat_o,

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

wishbone_pkg::bus_req_t touchpad_data_i;
wishbone_pkg::bus_rsp_t touchpad_data_o;

wishbone_pkg::bus_req_t display_data_i;
wishbone_pkg::bus_rsp_t display_data_o;

wishbone_pkg::bus_req_t consolebuff_data_i;
wishbone_pkg::bus_rsp_t consolebuff_data_o;

wishbone_pkg::bus_req_t displaybuff_data_i;
wishbone_pkg::bus_rsp_t displaybuff_data_o;

wishbone_pkg::bus_req_t sdcard_data_i;
wishbone_pkg::bus_rsp_t sdcard_data_o;

always_comb
begin
  touchpad_data_i         = touchpad_data_flat_i;
  touchpad_data_flat_o    = touchpad_data_o;
  display_data_i          = display_data_flat_i;
  display_data_flat_o     = display_data_o;
  consolebuff_data_i      = consolebuff_data_flat_i;
  consolebuff_data_flat_o = consolebuff_data_o;
  displaybuff_data_i      = displaybuff_data_flat_i;
  displaybuff_data_flat_o = displaybuff_data_o;
  sdcard_data_i           = sdcard_data_flat_i;
  sdcard_data_flat_o      = sdcard_data_o;
end


//IO
logic SCLK;
logic MISO;
logic MOSI;
logic GND;
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

logic display_SPIAck;
logic display_SPIDone;
logic display_SPIReq;
logic display_SCK;
logic display_CS;
logic display_RS_DC;
logic display_DATA;
logic display_MOSI;

logic sdcard_SPIAck;
logic sdcard_SPIDone;
logic sdcard_SPIReq;
logic sdcard_SCK;
logic sdcard_CS;
logic sdcard_RS_DC;
logic sdcard_DATA;
logic sdcard_MOSI;


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

  .bus_data_flat_i          (display_data_i),   
  .bus_data_flat_o          (display_data_o)
);

//Display Buffer
ILI9486_buffer display_buffer (
  .clk (clk),
  .rst (rst),

  .bus_data_flat_i             (displaybuff_data_i),   
  .bus_data_flat_o             (displaybuff_data_o)
);

//Console Buffer
console_buffer console_buffer (
  .clk (clk),
  .rst (rst),

  .bus_data_flat_i             (consolebuff_data_i),   
  .bus_data_flat_o             (consolebuff_data_o)
);

//SD Card
sdcard sdcard (
  .clk (clk),
  .rst (rst),
  .arst (arst),

  .SPIReq  (sdcard_SPIReq),
  .SPIAck  (sdcard_SPIAck),
  .SPIDone (sdcard_SPIDone),
  .SCK     (sdcard_SCK),
  .CS      (sdcard_CS),
  .RS_DC   (sdcard_RS_DC),
  .MOSI    (sdcard_MOSI),
  .MISO    (MISO),

  .bus_data_flat_i (sdcard_data_i),  
  .bus_data_flat_o (sdcard_data_o)    
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
