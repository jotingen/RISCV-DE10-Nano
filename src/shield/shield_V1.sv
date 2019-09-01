module shield_V1 (

input  logic           clk,
input  logic           rst,
output logic           arst,

input  logic           bus_req,
output logic           bus_ack,
input  logic           bus_write,
input  logic [31:0]    bus_addr,
inout  logic [31:0]    bus_data,

//////////// ADC //////////
output logic           ADC_CONVST,
output logic           ADC_SCK,
output logic           ADC_SDI,
input  logic           ADC_SDO,

//////////// ARDUINO //////////
inout  logic [15:0]    ARDUINO_IO,
inout  logic           ARDUINO_RESET_N,

//////////// JOYSTICK //////////
output logic           JOY_UP,    
output logic           JOY_RIGHT, 
output logic           JOY_SELECT,
output logic           JOY_DOWN,  
output logic           JOY_LEFT   

);

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

assign bus_ack  = 'z;
assign bus_data = 'z;


//Joystick
logic [11:0] CH0;     
logic [11:0] CH1;     
logic [11:0] CH2;     
logic [11:0] CH3;     
logic [11:0] CH4;     
logic [11:0] CH5;     
logic [11:0] CH6;     
logic [11:0] CH7;     

ADC adc (
  .CLOCK    (clk),    
  .RESET    (rst),    
  .CH0      (CH0),    
  .CH1      (CH1),    
  .CH2      (CH2),    
  .CH3      (CH3),    
  .CH4      (CH4),    
  .CH5      (CH5),    
  .CH6      (CH6),    
  .CH7      (CH7),    
  .ADC_SCLK (ADC_SCK),
  .ADC_CS_N (ADC_CONVST),
  .ADC_DOUT (ADC_SDO),   
  .ADC_DIN  (ADC_SDI)    
);

always_ff @(posedge clk)
  begin
  JOY_UP     <= CH3[11:9] == 'b101; // UP    
  JOY_RIGHT  <= CH3[11:9] == 'b011; // RIGHT 
  JOY_SELECT <= CH3[11:9] == 'b010; // SELECT
  JOY_DOWN   <= CH3[11:9] == 'b001; // DOWN  
  JOY_LEFT   <= CH3[11:9] == 'b000; // LEFT  
  end


//Display
st7735r display (
  .clk (clk),
  .rst (rst),
  .RS_DC (TFT_DC),
  .SCK   (SCK),
  .DATA  (MOSI),
  .CS    (TFT_CS)
);
endmodule
