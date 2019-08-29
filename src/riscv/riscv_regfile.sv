module riscv_regfile (
  input  logic              clk,
  input  logic              rst,

  input  logic              PC_wr,
  input  logic [31:0]       PC_in,
  output logic [31:0]       PC,

  input  logic [31:0]       x_wr,
  input  logic [31:0][31:0] x_in,
  output logic [31:0][31:0] x
);

logic [31:0]       x00;
logic [31:0]       x01;
logic [31:0]       x02;
logic [31:0]       x03;
logic [31:0]       x04;
logic [31:0]       x05;
logic [31:0]       x06;
logic [31:0]       x07;
logic [31:0]       x08;
logic [31:0]       x09;
logic [31:0]       x10;
logic [31:0]       x11;
logic [31:0]       x12;
logic [31:0]       x13;
logic [31:0]       x14;
logic [31:0]       x15;
logic [31:0]       x16;
logic [31:0]       x17;
logic [31:0]       x18;
logic [31:0]       x19;
logic [31:0]       x20;
logic [31:0]       x21;
logic [31:0]       x22;
logic [31:0]       x23;
logic [31:0]       x24;
logic [31:0]       x25;
logic [31:0]       x26;
logic [31:0]       x27;
logic [31:0]       x28;
logic [31:0]       x29;
logic [31:0]       x30;
logic [31:0]       x31;

//Splitting out to make it easier in GTKWave
always_comb
  begin
  x00 = x[00];
  x01 = x[01];
  x02 = x[02];
  x03 = x[03];
  x04 = x[04];
  x05 = x[05];
  x06 = x[06];
  x07 = x[07];
  x08 = x[08];
  x09 = x[09];
  x10 = x[10];
  x11 = x[11];
  x12 = x[12];
  x13 = x[13];
  x14 = x[14];
  x15 = x[15];
  x16 = x[16];
  x17 = x[17];
  x18 = x[18];
  x19 = x[19];
  x20 = x[20];
  x21 = x[21];
  x22 = x[22];
  x23 = x[23];
  x24 = x[24];
  x25 = x[25];
  x26 = x[26];
  x27 = x[27];
  x28 = x[28];
  x29 = x[29];
  x30 = x[30];
  x31 = x[31];
  end

always_ff @(posedge clk)
  begin

  PC <= PC;
  x  <= x;

  if(PC_wr)
    begin
    PC <= PC_in;
    end

  for(int i = 1; i < 32; i++) //x0 stays 0
    begin
    if(x_wr[i])
      begin
      x[i] <= x_in[i];
      end
    end

  if(rst)
    begin
    PC <= 'h10000;// Temporary until I figure out how to make the boot rom
    x  <= '0;
    end
  end

endmodule
