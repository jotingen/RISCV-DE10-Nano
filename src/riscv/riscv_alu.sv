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
  input  logic [31:0][31:0] x,

  output logic             bus_req,
  input  logic             bus_ack,
  output logic             bus_write,
  output logic [31:0]      bus_addr,
  inout  logic [31:0]      bus_data
);

logic             bus_put;
logic             bus_req_out;
logic             bus_write_out;
logic [31:0]      bus_addr_out;
logic [31:0]      bus_data_out;

assign bus_req = bus_put ? bus_req_out : 'z;
assign bus_write = bus_put ? bus_write_out : 'z;
assign bus_addr = bus_put ? bus_addr_out : 'z;
assign bus_data = bus_put ? bus_data_out : 'z;

logic [2:0] cnt;
always_ff @(posedge clk)
  begin

  PC_wr <= '0;
  PC_in <= PC_in;
  x_wr  <= '0;
  x_in  <= x_in; 

  bus_put       <= '0;
  bus_req_out   <= bus_req_out  ;
  bus_write_out <= bus_write_out;
  bus_addr_out  <= bus_addr_out ;
  bus_data_out  <= bus_data_out ;

  if(idu_done || cnt != 'd0)
    begin
    if(ADD)
      begin
        x_wr[rd] <= '1;
        x_in[rd] <= x[rs1] + x[rs2];
        PC_wr <= '1;
        PC_in <= PC+1;
      end
    if(ADDI)
      begin
        x_wr[rd] <= '1;
        x_in[rd] <= x[rs1] + { {20{imm[11]}}, imm[11:0]};
        PC_wr <= '1;
        PC_in <= PC+1;
      end
    if(LW)
      begin
        if(cnt=='d0)
          begin
          bus_put <= '1;
          bus_req_out   <= '1;
          bus_write_out <= '0;
          bus_addr_out  <= x[rs1] + { {20{imm[11]}}, imm[11:0]};
          cnt <= cnt + 1;
          end
        else if(cnt=='d4)
          begin
          x_wr[rd] <= '1;
          x_in[rd] <= bus_data;
          PC_wr <= '1;
          PC_in <= PC+1;
          cnt <= '0;
          end
        else
          begin
          cnt <= cnt + 1;
          end
      end
    if(SW)
      begin
        bus_put <= '1;
        bus_req_out   <= '1;
        bus_write_out <= '1;
        bus_addr_out  <= x[rs1] + { {20{imm[11]}}, imm[11:0]};
        bus_data_out  <= x[rs2];
        PC_wr <= '1;
        PC_in <= PC+1;
      end
    end
   
  if(rst)
    begin
    cnt <= '0;
    end
  end

endmodule
