import riscv_pkg::*;

module riscv_fsm (
  input  logic             clk,
  input  logic             rst,

  output riscv_pkg::state  state,
  output logic [31:0]      PC

);

always_ff @(posedge clk)
  begin
  PC    <= PC;
  state <= state;

  case (state)
    riscv_pkg::IFU_FETCH: begin
      state <= riscv_pkg::IDU_DECODE;
      end
    riscv_pkg::IDU_DECODE: begin
      state <= riscv_pkg::ALU_EXECUTE;
      end
    riscv_pkg::ALU_EXECUTE: begin
      state <= riscv_pkg::IFU_FETCH;
      PC <= PC + 1;
      end
  endcase
    
  if(rst)
    begin
    PC    <= '0;
    state <= riscv_pkg::IFU_FETCH;
    end
  end

endmodule
