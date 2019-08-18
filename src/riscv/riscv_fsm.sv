import riscv_pkg::*;

module riscv_fsm (
  input  logic             clk,
  input  logic             rst,

  output logic [31:0]      PC,

  input  logic             ifu_rdy,
  output logic             ifu_req,
  input  logic             ifu_done,
  input  logic [31:0]      ifu_inst,

  input  logic             idu_rdy,
  output logic             idu_req,
  input  logic             idu_done,
  output logic [31:0]      idu_inst
);

typedef enum {
  IFU_FETCH,
  IFU_WAIT,
  IDU_WAIT,
  ALU_EXECUTE
} state_s;
state_s  state;

always_ff @(posedge clk)
  begin
  PC    <= PC;
  state <= state;

  ifu_req  <= '0;
  idu_req  <= '0;
  idu_inst <= idu_inst;

  case (state)
    IFU_FETCH: begin
               if(ifu_rdy)
                 begin
                 state <= IFU_WAIT;
                 ifu_req <= '1;
                 end
               end
    IFU_WAIT : begin
               if(ifu_done)
                 begin
                 state <= IDU_WAIT;
                 idu_req  <= '1;
                 idu_inst <= ifu_inst;
                 end
               end
    IDU_WAIT : begin
               if(idu_done)
                 begin
                 state <= ALU_EXECUTE;
                 end
               end
    ALU_EXECUTE: begin
                 state <= IFU_FETCH;
                 PC <= PC + 1;
                 end
  endcase
    
  if(rst)
    begin
    PC    <= '0;
    state <= IFU_FETCH;
    ifu_req <= '0;
    idu_req <= '0;
    end
  end

endmodule
