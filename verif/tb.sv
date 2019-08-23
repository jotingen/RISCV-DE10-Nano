`timescale 100ps / 100ps
module tb ();

//////////// CLOCK //////////
logic           FPGA_CLK1_50;
logic           FPGA_CLK2_50;
logic           FPGA_CLK3_50;

//////////// LED //////////
logic  [7:0]    LED;

//////////// KEY //////////
logic  [1:0]    KEY;

//////////// SW //////////
logic  [3:0]    SW;

//////////// ADC //////////
logic           ADC_CONVST;
logic           ADC_SCK;
logic           ADC_SDI;
logic           ADC_SDO;

//////////// ARDUINO //////////
logic  [15:0]   ARDUINO_IO;
logic            ARDUINO_RESET_N;

//////////// HDMI //////////
logic           HDMI_I2C_SCL;
logic           HDMI_I2C_SDA;
logic           HDMI_I2S;
logic           HDMI_LRCLK;
logic           HDMI_MCLK;
logic           HDMI_SCLK;
logic           HDMI_TX_CLK;
logic           HDMI_TX_DE;
logic  [23:0]   HDMI_TX_D;
logic           HDMI_TX_HS;
logic           HDMI_TX_INT;
logic           HDMI_TX_VS;

logic reset_en;
logic reset_n;

assign ARDUINO_RESET_N = (reset_en)? reset_n : 'hz;

de10nano dut (

//////////// CLOCK //////////
.FPGA_CLK1_50,
.FPGA_CLK2_50,
.FPGA_CLK3_50,

//////////// LED //////////
.LED,

//////////// KEY //////////
.KEY,

//////////// SW //////////
.SW,

//////////// ADC //////////
.ADC_CONVST,
.ADC_SCK,
.ADC_SDI,
.ADC_SDO,

//////////// ARDUINO //////////
.ARDUINO_IO,
.ARDUINO_RESET_N,

//////////// HDMI //////////
.HDMI_I2C_SCL,
.HDMI_I2C_SDA,
.HDMI_I2S,
.HDMI_LRCLK,
.HDMI_MCLK,
.HDMI_SCLK,
.HDMI_TX_CLK,
.HDMI_TX_DE,
.HDMI_TX_D,
.HDMI_TX_HS,
.HDMI_TX_INT,
.HDMI_TX_VS

);

initial
  begin
    $readmemh("../../verif/tests/add_3.v", dut.mem.mem_array_3);
    $readmemh("../../verif/tests/add_2.v", dut.mem.mem_array_2);
    $readmemh("../../verif/tests/add_1.v", dut.mem.mem_array_1);
    $readmemh("../../verif/tests/add_0.v", dut.mem.mem_array_0);
  end

initial 
  begin 
  FPGA_CLK1_50 = 0; 
  FPGA_CLK2_50 = 0; 
  FPGA_CLK3_50 = 0; 
  reset_en = '1;
  reset_n = '1;
  #200
  reset_n = '0;
  #2000
  reset_n = '1;
//  ARDUINO_RESET_N = 0; 
  end 
    
always 
  begin
  #100  
  FPGA_CLK1_50 =  ! FPGA_CLK1_50;
  FPGA_CLK2_50 =  ! FPGA_CLK2_50;
  FPGA_CLK3_50 =  ! FPGA_CLK3_50;
  end


endmodule
