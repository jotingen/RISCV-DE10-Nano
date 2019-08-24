import riscv_pkg::*;

module riscv_alu (
  input  logic        clk,
  input  logic        rst,

  input  logic        idu_vld,
  output logic        alu_vld,

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

  alu_vld <= '0;

  PC_wr <= '0;
  PC_in <= PC;
  x_wr  <= '0;
  x_in  <= x_in; 

  bus_put       <= '0;
  bus_req_out   <= bus_req_out  ;
  bus_write_out <= bus_write_out;
  bus_addr_out  <= bus_addr_out ;
  bus_data_out  <= bus_data_out ;

  if(idu_vld || cnt != 'd0)
    begin
    if(ADD)
      begin
        $display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "ADD", PC, rs1, x[rs1], rs2, x[rs2], rd);
        alu_vld <= '1;
        x_wr[rd] <= '1;
        x_in[rd] <= x[rs1] + x[rs2];
        PC_wr <= '1;
        PC_in <= PC+'d4;
      end
    else if(SLT)
      begin
        $display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SLT", PC, rs1, x[rs1], rs2, x[rs2], rd);
        alu_vld <= '1;
        x_wr[rd] <= '1;
        if($signed(x[rs1]) < $signed(x[rs2]))
          x_in[rd] <= 'd1;
        else
          x_in[rd] <= 'd0;
        PC_wr <= '1;
        PC_in <= PC+'d4;
      end
    else if(SLTU)
      begin
        $display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SLTU", PC, rs1, x[rs1], rs2, x[rs2], rd);
        alu_vld <= '1;
        x_wr[rd] <= '1;
        if(x[rs1] < x[rs2])
          x_in[rd] <= 'd1;
        else
          x_in[rd] <= 'd0;
        PC_wr <= '1;
        PC_in <= PC+'d4;
      end
    else if(AND)
      begin
        $display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "AND", PC, rs1, x[rs1], rs2, x[rs2], rd);
        alu_vld <= '1;
        x_wr[rd] <= '1;
        x_in[rd] <= x[rs1] & x[rs2];
        PC_wr <= '1;
        PC_in <= PC+'d4;
      end
    else if(OR)
      begin
        $display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "OR", PC, rs1, x[rs1], rs2, x[rs2], rd);
        alu_vld <= '1;
        x_wr[rd] <= '1;
        x_in[rd] <= x[rs1] | x[rs2];
        PC_wr <= '1;
        PC_in <= PC+'d4;
      end
    else if(XOR)
      begin
        $display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "XOR", PC, rs1, x[rs1], rs2, x[rs2], rd);
        alu_vld <= '1;
        x_wr[rd] <= '1;
        x_in[rd] <= x[rs1] ^ x[rs2];
        PC_wr <= '1;
        PC_in <= PC+'d4;
      end
    else if(SLL)
      begin
        $display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SLL", PC, rs1, x[rs1], rs2, x[rs2], rd);
        alu_vld <= '1;
        x_wr[rd] <= '1;
        x_in[rd] <= x[rs1] << x[rs2][4:0];
        PC_wr <= '1;
        PC_in <= PC+'d4;
      end
    else if(SRL)
      begin
        $display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SRL", PC, rs1, x[rs1], rs2, x[rs2], rd);
        alu_vld <= '1;
        x_wr[rd] <= '1;
        x_in[rd] <= x[rs1] >> x[rs2][4:0];
        PC_wr <= '1;
        PC_in <= PC+'d4;
      end
    else if(SUB)
      begin
        $display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SUB", PC, rs1, x[rs1], rs2, x[rs2], rd);
        alu_vld <= '1;
        x_wr[rd] <= '1;
        x_in[rd] <= x[rs1] - x[rs2];
        PC_wr <= '1;
        PC_in <= PC+'d4;
      end
    else if(SRA)
      begin
        $display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SRA", PC, rs1, x[rs1], rs2, x[rs2], rd);
        alu_vld <= '1;
        x_wr[rd] <= '1;
        x_in[rd] <= x[rs1] >>> x[rs2];
        PC_wr <= '1;
        PC_in <= PC+'d4;
      end


    else if(ADDI)
      begin
        $display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "ADDI", PC, rs1, x[rs1], {{20{imm[11]}},imm[11:0]}, rd);
        alu_vld <= '1;
        x_wr[rd] <= '1;
        x_in[rd] <= x[rs1] + {{20{imm[11]}},imm[11:0]};
        PC_wr <= '1;
        PC_in <= PC+'d4;
      end
    else if(SLTI)
      begin
        $display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "SLTI", PC, rs1, x[rs1], {{20{imm[11]}},imm[11:0]}, rd);
        alu_vld <= '1;
        x_wr[rd] <= '1;
        if($signed(x[rs1]) < $signed({{20{imm[11]}},imm[11:0]}))
          x_in[rd] <= 'd1;
        else
          x_in[rd] <= 'd0;
        PC_wr <= '1;
        PC_in <= PC+'d4;
      end
    else if(SLTIU)
      begin
        $display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "SLTIU", PC, rs1, x[rs1], {{20{imm[11]}},imm[11:0]}, rd);
        alu_vld <= '1;
        x_wr[rd] <= '1;
        if(x[rs1] < {{20{imm[11]}},imm[11:0]})
          x_in[rd] <= 'd1;
        else
          x_in[rd] <= 'd0;
        PC_wr <= '1;
        PC_in <= PC+'d4;
      end
    else if(ANDI)
      begin
        $display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "ANDI", PC, rs1, x[rs1], {{20{imm[11]}},imm[11:0]}, rd);
        alu_vld <= '1;
        x_wr[rd] <= '1;
        x_in[rd] <= x[rs1] & {{20{imm[11]}},imm[11:0]};
        PC_wr <= '1;
        PC_in <= PC+'d4;
      end
    else if(ORI)
      begin
        $display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "ORI", PC, rs1, x[rs1], {{20{imm[11]}},imm[11:0]}, rd);
        alu_vld <= '1;
        x_wr[rd] <= '1;
        x_in[rd] <= x[rs1] | {{20{imm[11]}},imm[11:0]};
        PC_wr <= '1;
        PC_in <= PC+'d4;
      end
    else if(XORI)
      begin
        $display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "XORI", PC, rs1, x[rs1], {{20{imm[11]}},imm[11:0]}, rd);
        alu_vld <= '1;
        x_wr[rd] <= '1;
        x_in[rd] <= x[rs1] ^ {{20{imm[11]}},imm[11:0]};
        PC_wr <= '1;
        PC_in <= PC+'d4;
      end
    else if(SLLI)
      begin
        $display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "SLLI", PC, rs1, x[rs1], {{27{'0}},imm[4:0]}, rd);
        alu_vld <= '1;
        x_wr[rd] <= '1;
        x_in[rd] <= x[rs1] << imm[4:0];
        PC_wr <= '1;
        PC_in <= PC+'d4;
      end
    else if(SRLI)
      begin
        $display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "SRLI", PC, rs1, x[rs1], {{27{'0}},imm[4:0]}, rd);
        alu_vld <= '1;
        x_wr[rd] <= '1;
        x_in[rd] <= x[rs1] >> imm[4:0];
        PC_wr <= '1;
        PC_in <= PC+'d4;
      end
    else if(SRAI)
      begin
        $display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "SRAI", PC, rs1, x[rs1], imm[4:0], rd);
        alu_vld <= '1;
        x_wr[rd] <= '1;
        x_in[rd] <= x[rs1] >>> imm;
        PC_wr <= '1;
        PC_in <= PC+'d4;
      end


    else if(JAL)
      begin
        $display("%-5s PC=%08X imm=%08X rd=(%d)", "JAL", PC, {{11{imm[20]}},imm[20:0]}, rd);
        alu_vld <= '1;
        x_wr[rd] <= '1;
        x_in[rd] <= PC+'d4;
        PC_wr <= '1;
        PC_in <= PC+{{11{imm[20]}},imm[20:0]};
      end
    else if(JALR)
      begin
        $display("%-5s PC=%08X imm=%08X rd=(%d)", "JALR", PC, {{20{imm[11]}},imm[11:0]}, rd);
        alu_vld <= '1;
        x_wr[rd] <= '1;
        x_in[rd] <= PC+'d4;
        PC_wr <= '1;
        PC_in <= (x[rs1]+{{20{imm[11]}},imm[11:0]}) & 31'hFFFFFFFE;
      end


    else if(BEQ)
      begin
        $display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BEQ", PC, rs1, x[rs1], rs2, x[rs2], {{19{imm[12]}},imm[12:0]});
        alu_vld <= '1;
        PC_wr <= '1;
        if(x[rs1] == x[rs2])
          PC_in <= PC+{{19{imm[12]}},imm[12:0]};
        else                  
          PC_in <= PC+'d4;
      end
    else if(BNE)
      begin
        $display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BNE", PC, rs1, x[rs1], rs2, x[rs2], {{19{imm[12]}},imm[12:0]});
        alu_vld <= '1;
        PC_wr <= '1;
        if(x[rs1] != x[rs2])
          PC_in <= PC+{{19{imm[12]}},imm[12:0]};
        else                  
          PC_in <= PC+'d4;
      end
    else if(BLT)
      begin
        $display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BLT", PC, rs1, x[rs1], rs2, x[rs2], {{19{imm[12]}},imm[12:0]});
        alu_vld <= '1;
        PC_wr <= '1;
        if($signed(x[rs1]) < $signed(x[rs2]))
          PC_in <= PC+{{19{imm[12]}},imm[12:0]};
        else                  
          PC_in <= PC+'d4;
      end
    else if(BLTU)
      begin
        $display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BLTU", PC, rs1, x[rs1], rs2, x[rs2], {{19{imm[12]}},imm[12:0]});
        alu_vld <= '1;
        PC_wr <= '1;
        if(x[rs1] < x[rs2])
          PC_in <= PC+{{19{imm[12]}},imm[12:0]};
        else                  
          PC_in <= PC+'d4;
      end
    else if(BGE)
      begin
        $display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BGE", PC, rs1, x[rs1], rs2, x[rs2], {{19{imm[12]}},imm[12:0]});
        alu_vld <= '1;
        PC_wr <= '1;
        if($signed(x[rs1]) >= $signed(x[rs2]))
          PC_in <= PC+{{19{imm[12]}},imm[12:0]};
        else                  
          PC_in <= PC+'d4;
      end
    else if(BGEU)
      begin
        $display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BGEU", PC, rs1, x[rs1], rs2, x[rs2], {{19{imm[12]}},imm[12:0]});
        alu_vld <= '1;
        PC_wr <= '1;
        if(x[rs1] >= x[rs2])
          PC_in <= PC+{{19{imm[12]}},imm[12:0]};
        else                  
          PC_in <= PC+'d4;
      end


    else if(LUI)
      begin
        $display("%-5s PC=%08X imm=%08X rd=(%d)", "LUI", PC, imm, rd);
        alu_vld <= '1;
        x_wr[rd] <= '1;
        x_in[rd] <= imm;
        PC_wr <= '1;
        PC_in <= PC+'d4;
      end
    else if(AUIPC)
      begin
        $display("%-5s PC=%08X imm=%08X rd=(%d)", "AUIPC", PC, imm, rd);
        alu_vld <= '1;
        x_wr[rd] <= '1;
        x_in[rd] <= PC + imm;
        PC_wr <= '1;
        PC_in <= PC+'d4;
      end


    else if(LW)
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
          $display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "LW", PC, rs1, x[rs1], {{20{imm[11]}},imm[11:0]}, rd);
          alu_vld <= '1;
          x_wr[rd] <= '1;
          x_in[rd] <= bus_data;
          PC_wr <= '1;
          PC_in <= PC+'d4;
          cnt <= '0;
          end
        else
          begin
          cnt <= cnt + 1;
          end
      end
    else if(SW)
      begin
        if(cnt=='d0)
          begin
          bus_put <= '1;
          bus_req_out   <= '1;
          bus_write_out <= '1;
          bus_addr_out  <= x[rs1] + { {20{imm[11]}}, imm[11:0]};
          bus_data_out  <= x[rs2];
          cnt <= cnt + 1;
          end
        else if(cnt=='d1)
          begin
          $display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "SW", PC, rs1, x[rs1], rs2, x[rs2], {{20{imm[11]}},imm[11:0]});
          alu_vld <= '1;
          PC_wr <= '1;
          PC_in <= PC+'d4;
          cnt <= '0;
          end
      end


    else if(FENCE)
      begin
        $display("%-5s PC=%08X" , "FENCE", PC);
        alu_vld <= '1;
        PC_wr <= '1;
        PC_in <= PC+'d4;
      end



    else if(ECALL)
      begin
        //TODO
        $display("%-5s PC=%08X" , "ECALL - !!TODO!!", PC);
        alu_vld <= '1;
        PC_wr <= '1;
        PC_in <= PC+'d4;
      end
    else if(EBREAK)
      begin
        //TODO
        $display("%-5s PC=%08X" , "EBREAK - !!TODO!!", PC);
        alu_vld <= '1;
        PC_wr <= '1;
        PC_in <= PC+'d4;
      end

    end
   
  if(rst)
    begin
    alu_vld <= '0;
    cnt <= '0;
    end
  end

endmodule
