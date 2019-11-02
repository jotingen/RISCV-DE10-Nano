module riscv_regfile (
  input  logic              clk,
  input  logic              rst,

  input  logic [31:0]       x_wr,
  input  logic [31:0]       x00_in,
  input  logic [31:0]       x01_in,
  input  logic [31:0]       x02_in,
  input  logic [31:0]       x03_in,
  input  logic [31:0]       x04_in,
  input  logic [31:0]       x05_in,
  input  logic [31:0]       x06_in,
  input  logic [31:0]       x07_in,
  input  logic [31:0]       x08_in,
  input  logic [31:0]       x09_in,
  input  logic [31:0]       x10_in,
  input  logic [31:0]       x11_in,
  input  logic [31:0]       x12_in,
  input  logic [31:0]       x13_in,
  input  logic [31:0]       x14_in,
  input  logic [31:0]       x15_in,
  input  logic [31:0]       x16_in,
  input  logic [31:0]       x17_in,
  input  logic [31:0]       x18_in,
  input  logic [31:0]       x19_in,
  input  logic [31:0]       x20_in,
  input  logic [31:0]       x21_in,
  input  logic [31:0]       x22_in,
  input  logic [31:0]       x23_in,
  input  logic [31:0]       x24_in,
  input  logic [31:0]       x25_in,
  input  logic [31:0]       x26_in,
  input  logic [31:0]       x27_in,
  input  logic [31:0]       x28_in,
  input  logic [31:0]       x29_in,
  input  logic [31:0]       x30_in,
  input  logic [31:0]       x31_in,
  output logic [31:0]       x00,
  output logic [31:0]       x01,
  output logic [31:0]       x02,
  output logic [31:0]       x03,
  output logic [31:0]       x04,
  output logic [31:0]       x05,
  output logic [31:0]       x06,
  output logic [31:0]       x07,
  output logic [31:0]       x08,
  output logic [31:0]       x09,
  output logic [31:0]       x10,
  output logic [31:0]       x11,
  output logic [31:0]       x12,
  output logic [31:0]       x13,
  output logic [31:0]       x14,
  output logic [31:0]       x15,
  output logic [31:0]       x16,
  output logic [31:0]       x17,
  output logic [31:0]       x18,
  output logic [31:0]       x19,
  output logic [31:0]       x20,
  output logic [31:0]       x21,
  output logic [31:0]       x22,
  output logic [31:0]       x23,
  output logic [31:0]       x24,
  output logic [31:0]       x25,
  output logic [31:0]       x26,
  output logic [31:0]       x27,
  output logic [31:0]       x28,
  output logic [31:0]       x29,
  output logic [31:0]       x30,
  output logic [31:0]       x31
);

always_ff @(posedge clk)
  begin

  x00 <= x00;
  x01 <= x01;
  x02 <= x02;
  x03 <= x03;
  x04 <= x04;
  x05 <= x05;
  x06 <= x06;
  x07 <= x07;
  x08 <= x08;
  x09 <= x09;
  x10 <= x10;
  x11 <= x11;
  x12 <= x12;
  x13 <= x13;
  x14 <= x14;
  x15 <= x15;
  x16 <= x16;
  x17 <= x17;
  x18 <= x18;
  x19 <= x19;
  x20 <= x20;
  x21 <= x21;
  x22 <= x22;
  x23 <= x23;
  x24 <= x24;
  x25 <= x25;
  x26 <= x26;
  x27 <= x27;
  x28 <= x28;
  x29 <= x29;
  x30 <= x30;
  x31 <= x31;

  if(x_wr[00]) x00 <= '0;
  if(x_wr[01]) x01 <= x01_in;
  if(x_wr[02]) x02 <= x02_in;
  if(x_wr[03]) x03 <= x03_in;
  if(x_wr[04]) x04 <= x04_in;
  if(x_wr[05]) x05 <= x05_in;
  if(x_wr[06]) x06 <= x06_in;
  if(x_wr[07]) x07 <= x07_in;
  if(x_wr[08]) x08 <= x08_in;
  if(x_wr[09]) x09 <= x09_in;
  if(x_wr[10]) x10 <= x10_in;
  if(x_wr[11]) x11 <= x11_in;
  if(x_wr[12]) x12 <= x12_in;
  if(x_wr[13]) x13 <= x13_in;
  if(x_wr[14]) x14 <= x14_in;
  if(x_wr[15]) x15 <= x15_in;
  if(x_wr[16]) x16 <= x16_in;
  if(x_wr[17]) x17 <= x17_in;
  if(x_wr[18]) x18 <= x18_in;
  if(x_wr[19]) x19 <= x19_in;
  if(x_wr[20]) x20 <= x20_in;
  if(x_wr[21]) x21 <= x21_in;
  if(x_wr[22]) x22 <= x22_in;
  if(x_wr[23]) x23 <= x23_in;
  if(x_wr[24]) x24 <= x24_in;
  if(x_wr[25]) x25 <= x25_in;
  if(x_wr[26]) x26 <= x26_in;
  if(x_wr[27]) x27 <= x27_in;
  if(x_wr[28]) x28 <= x28_in;
  if(x_wr[29]) x29 <= x29_in;
  if(x_wr[30]) x30 <= x30_in;
  if(x_wr[31]) x31 <= x31_in;

  if(rst)
    begin
    x00 <= '0;
    x01 <= '0;
    x02 <= '0;
    x03 <= '0;
    x04 <= '0;
    x05 <= '0;
    x06 <= '0;
    x07 <= '0;
    x08 <= '0;
    x09 <= '0;
    x10 <= '0;
    x11 <= '0;
    x12 <= '0;
    x13 <= '0;
    x14 <= '0;
    x15 <= '0;
    x16 <= '0;
    x17 <= '0;
    x18 <= '0;
    x19 <= '0;
    x20 <= '0;
    x21 <= '0;
    x22 <= '0;
    x23 <= '0;
    x24 <= '0;
    x25 <= '0;
    x26 <= '0;
    x27 <= '0;
    x28 <= '0;
    x29 <= '0;
    x30 <= '0;
    x31 <= '0;
    end
  end

endmodule
