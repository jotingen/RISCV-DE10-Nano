import riscv_pkg::*;

module riscv_alu (
  input  logic        clk,
  input  logic        rst,

  input  logic        idu_done,

  input  logic  [3:0] fm,
  input  logic  [3:0] pred,
  input  logic  [3:0] succ,
  input  logic  [4:0] shamt,
  input  logic [31:0] imm,
  input  logic  [6:0] funct7,
  input  logic  [2:0] funct3,
  input  logic  [4:0] rs2,
  input  logic  [4:0] rs1,
  input  logic  [4:0] rd,
  input  logic  [6:0] opcode,
  
  input  logic LUI,
  input  logic AUIPC,
  input  logic JAL,
  input  logic JALR,
  input  logic BEQ,
  input  logic BNE,
  input  logic BLT,
  input  logic BGE,
  input  logic BLTU,
  input  logic BGEU,
  input  logic LB,
  input  logic LH,
  input  logic LW,
  input  logic LBU,
  input  logic LHU,
  input  logic SB,
  input  logic SH,
  input  logic SW,
  input  logic ADDI,
  input  logic SLTI,
  input  logic SLTIU,
  input  logic XORI,
  input  logic ORI,
  input  logic ANDI,
  input  logic SLLI,
  input  logic SRLI,
  input  logic SRAI,
  input  logic ADD,
  input  logic SUB,
  input  logic SLL,
  input  logic SLT,
  input  logic SLTU,
  input  logic XOR,
  input  logic SRL,
  input  logic SRA,
  input  logic OR,
  input  logic AND,
  input  logic FENCE,
  input  logic FENCE_I,
  input  logic ECALL,
  input  logic EBREAK,

  output logic              PC_wr,
  output logic [31:0]       PC_in,
  input  logic [31:0]       PC,

  output logic [31:0]       x_wr,
  output logic [31:0][31:0] x_in,
  input  logic [31:0][31:0] x
);

always_ff @(posedge clk)
  begin

  PC_wr <= '0;
  PC_in <= PC_in;
  x_wr  <= '0;
  x_in  <= x_in; 

  if(idu_done)
    begin
    if(ADDI)
      begin
        x_wr[rd] <= '1;
        x_in[rd] <= x[rs1] + { {20{imm[11]}}, imm[11:0]};
        PC_wr <= '1;
        PC_in <= PC+1;
      end
    end
   
  end

endmodule
