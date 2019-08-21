module riscv_reg (
  input  logic              clk,
  input  logic              rst,

  input  logic              PC_wr,
  input  logic [31:0]       PC_in,
  output logic [31:0]       PC,

  input  logic [31:0]       x_wr,
  input  logic [31:0][31:0] x_in,
  output logic [31:0][31:0] x
);

always_ff @(posedge clk)
  begin

  PC <= PC;
  x  <= x;

  if(PC_wr[i])
    begin
    PC[i] <= PC_in[i];
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
    PC <= 'h200;
    x  <= '0;
    end
  end

endmodule
