//import riscv_pkg::*;

module riscv_alu  (
  input  logic        clk,
  input  logic        rst,

  output logic        alu_vld,
  output logic [31:0] alu_inst,
  output logic [63:0] alu_order,
  output logic        alu_trap,
  output logic [31:0] alu_PC,
  output logic [31:0] alu_PC_next,
  output logic  [4:0] alu_rs1,
  output logic  [4:0] alu_rs2,
  output logic [31:0] alu_rs1_data,
  output logic [31:0] alu_rs2_data,
  output logic        alu_rd_wr,
  output logic  [4:0] alu_rd,
  output logic [31:0] alu_rd_data,

  input  logic        dpu_vld,
  input  logic [31:0] dpu_inst,
  input  logic [63:0] dpu_order,
  input  logic [31:0] dpu_PC,

  input  logic  [3:0] dpu_fm,
  input  logic  [3:0] dpu_pred,
  input  logic  [3:0] dpu_succ,
  input  logic  [4:0] dpu_shamt,
  input  logic [31:0] dpu_imm,
  input  logic  [4:0] dpu_uimm,
  input  logic [11:0] dpu_csr,
  input  logic  [6:0] dpu_funct7,
  input  logic  [2:0] dpu_funct3,
  input  logic  [4:0] dpu_rs2,
  input  logic  [4:0] dpu_rs1,
  input  logic  [4:0] dpu_rd,
  input  logic  [6:0] dpu_opcode,

  input  logic [31:0] dpu_rs1_data,
  input  logic [31:0] dpu_rs2_data,

  input  logic dpu_LUI,
  input  logic dpu_AUIPC,
  input  logic dpu_ADDI,
  input  logic dpu_SLTI,
  input  logic dpu_SLTIU,
  input  logic dpu_XORI,
  input  logic dpu_ORI,
  input  logic dpu_ANDI,
  input  logic dpu_SLLI,
  input  logic dpu_SRLI,
  input  logic dpu_SRAI,
  input  logic dpu_ADD,
  input  logic dpu_SUB,
  input  logic dpu_SLL,
  input  logic dpu_SLT,
  input  logic dpu_SLTU,
  input  logic dpu_XOR,
  input  logic dpu_SRL,
  input  logic dpu_SRA,
  input  logic dpu_OR,
  input  logic dpu_AND,
  input  logic dpu_FENCE,
  input  logic dpu_FENCE_I,
  input  logic dpu_ECALL,
  input  logic dpu_EBREAK,
  input  logic dpu_TRAP

);


logic  [3:0] alu_fm;
logic  [3:0] alu_pred;
logic  [3:0] alu_succ;
logic  [4:0] alu_shamt;
logic [31:0] alu_imm;
logic  [4:0] alu_uimm;
logic [11:0] alu_csr;
logic  [6:0] alu_funct7;
logic  [2:0] alu_funct3;
logic  [6:0] alu_opcode;

logic alu_LUI;
logic alu_AUIPC;
logic alu_JAL;
logic alu_JALR;
logic alu_BEQ;
logic alu_BNE;
logic alu_BLT;
logic alu_BGE;
logic alu_BLTU;
logic alu_BGEU;
logic alu_LB;
logic alu_LH;
logic alu_LW;
logic alu_LBU;
logic alu_LHU;
logic alu_SB;
logic alu_SH;
logic alu_SW;
logic alu_ADDI;
logic alu_SLTI;
logic alu_SLTIU;
logic alu_XORI;
logic alu_ORI;
logic alu_ANDI;
logic alu_SLLI;
logic alu_SRLI;
logic alu_SRAI;
logic alu_ADD;
logic alu_SUB;
logic alu_SLL;
logic alu_SLT;
logic alu_SLTU;
logic alu_XOR;
logic alu_SRL;
logic alu_SRA;
logic alu_OR;
logic alu_AND;
logic alu_FENCE;
logic alu_FENCE_I;
logic alu_ECALL;
logic alu_CSRRW;
logic alu_CSRRS;
logic alu_CSRRC;
logic alu_CSRRWI;
logic alu_CSRRSI;
logic alu_CSRRCI;
logic alu_EBREAK;
logic alu_MUL;
logic alu_MULH;
logic alu_MULHSU;
logic alu_MULHU;
logic alu_DIV;
logic alu_DIVU;
logic alu_REM;
logic alu_REMU;
logic alu_TRAP;

logic [31:0] addr;

logic [31:0] mem_rdata;

logic [63:0] product;
logic [63:0] product_unsigned;
logic [64:0] product_signed_unsigned;

logic [31:0] quotient;
logic [31:0] quotient_unsigned;

logic [31:0] remainder;
logic [31:0] remainder_unsigned;

always_ff @(posedge clk)
  begin
  //if(alu_vld & alu_trap)
  //  $fatal();

  alu_vld <= dpu_vld;

  alu_PC      <= dpu_PC;
  alu_PC_next <= dpu_PC+'d4;
  alu_rd_wr  <= '0;

  alu_rs2_data   <= dpu_rs2_data;  
  alu_rs1_data   <= dpu_rs1_data;  
  alu_rd_data    <= '0;   
  alu_trap       <= '0;   

  alu_inst    <= dpu_inst;      
  alu_order   <= dpu_order;      
  alu_fm      <= dpu_fm;        
  alu_pred    <= dpu_pred;      
  alu_succ    <= dpu_succ;      
  alu_shamt   <= dpu_shamt;     
  alu_imm     <= dpu_imm;       
  alu_uimm    <= dpu_uimm;      
  alu_csr     <= dpu_csr;       
  alu_funct7  <= dpu_funct7;    
  alu_funct3  <= dpu_funct3;    
  alu_rs2     <= dpu_rs2;       
  alu_rs1     <= dpu_rs1;       
  alu_rd      <= dpu_rd;        
  alu_opcode  <= dpu_opcode;    
                                 
  alu_LUI     <= dpu_LUI;       
  alu_AUIPC   <= dpu_AUIPC;     
  alu_ADDI    <= dpu_ADDI;      
  alu_SLTI    <= dpu_SLTI;      
  alu_SLTIU   <= dpu_SLTIU;     
  alu_XORI    <= dpu_XORI;      
  alu_ORI     <= dpu_ORI;       
  alu_ANDI    <= dpu_ANDI;      
  alu_SLLI    <= dpu_SLLI;      
  alu_SRLI    <= dpu_SRLI;      
  alu_SRAI    <= dpu_SRAI;      
  alu_ADD     <= dpu_ADD;       
  alu_SUB     <= dpu_SUB;       
  alu_SLL     <= dpu_SLL;       
  alu_SLT     <= dpu_SLT;       
  alu_SLTU    <= dpu_SLTU;      
  alu_XOR     <= dpu_XOR;       
  alu_SRL     <= dpu_SRL;       
  alu_SRA     <= dpu_SRA;       
  alu_OR      <= dpu_OR;        
  alu_AND     <= dpu_AND;       
  alu_FENCE   <= dpu_FENCE;     
  alu_FENCE_I <= dpu_FENCE_I;   
  alu_ECALL   <= dpu_ECALL;     
  alu_EBREAK  <= dpu_EBREAK;    
  alu_TRAP    <= dpu_TRAP;      


  if(dpu_vld)
    begin
    unique
    case (1'b1)
      dpu_LUI : begin
                //$display("%-5s PC=%08X imm=%08X rd=(%d)", "LUI", PC, dpu_imm, dpu_rd);
                alu_rd_wr <= '1;
                alu_rd_data <= dpu_imm;
                alu_PC_next <= dpu_PC+'d4;
                end
      dpu_AUIPC : begin
                  //$display("%0t %-5s PC=%08X imm=%08X rd=(%d)", $time, "AUIPC", dpu_PC, dpu_imm, dpu_rd);
                  alu_rd_wr <= '1;
                  alu_rd_data <= dpu_PC + dpu_imm;
                  alu_PC_next <= dpu_PC+'d4;
                  end
      dpu_ADD : begin
                //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "ADD", PC, dpu_rs1, dpu_rs1_data, dpu_rs2, dpu_rs2_data, dpu_rd);
                alu_rd_wr <= '1;
                alu_rd_data <= dpu_rs1_data + dpu_rs2_data;
                alu_PC_next <= dpu_PC+'d4;
                end
      dpu_SLT : begin
                //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SLT", PC, dpu_rs1, dpu_rs1_data, dpu_rs2, dpu_rs2_data, dpu_rd);
                alu_rd_wr <= '1;
                if($signed(dpu_rs1_data) < $signed(dpu_rs2_data))
                  alu_rd_data <= 'd1;
                else
                  alu_rd_data <= 'd0;
                alu_PC_next <= dpu_PC+'d4;
                end
      dpu_SLTU : begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SLTU", PC, dpu_rs1, dpu_rs1_data, dpu_rs2, dpu_rs2_data, dpu_rd);
                 alu_rd_wr <= '1;
                 if(dpu_rs1_data < dpu_rs2_data)
                   alu_rd_data <= 'd1;
                 else
                   alu_rd_data <= 'd0;
                 alu_PC_next <= dpu_PC+'d4;
                 end
      dpu_AND : begin
                //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "AND", PC, dpu_rs1, dpu_rs1_data, dpu_rs2, dpu_rs2_data, dpu_rd);
                alu_rd_wr <= '1;
                alu_rd_data <= dpu_rs1_data & dpu_rs2_data;
                alu_PC_next <= dpu_PC+'d4;
                end
      dpu_OR : begin
               //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "OR", PC, dpu_rs1, dpu_rs1_data, dpu_rs2, dpu_rs2_data, dpu_rd);
               alu_rd_wr <= '1;
               alu_rd_data <= dpu_rs1_data | dpu_rs2_data;
               alu_PC_next <= dpu_PC+'d4;
               end
      dpu_XOR : begin
                //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "XOR", PC, dpu_rs1, dpu_rs1_data, dpu_rs2, dpu_rs2_data, dpu_rd);
                alu_rd_wr <= '1;
                alu_rd_data <= dpu_rs1_data ^ dpu_rs2_data;
                alu_PC_next <= dpu_PC+'d4;
                end
      dpu_SLL : begin
                //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SLL", PC, dpu_rs1, dpu_rs1_data, dpu_rs2, dpu_rs2_data, dpu_rd);
                alu_rd_wr <= '1;
                alu_rd_data <= dpu_rs1_data << dpu_rs2_data[4:0];
                alu_PC_next <= dpu_PC+'d4;
                end
      dpu_SRL : begin
                //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SRL", PC, dpu_rs1, dpu_rs1_data, dpu_rs2, dpu_rs2_data, dpu_rd);
                alu_rd_wr <= '1;
                alu_rd_data <= dpu_rs1_data >> dpu_rs2_data[4:0];
                alu_PC_next <= dpu_PC+'d4;
                end
      dpu_SUB : begin
                //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SUB", PC, dpu_rs1, dpu_rs1_data, dpu_rs2, dpu_rs2_data, dpu_rd);
                alu_rd_wr <= '1;
                alu_rd_data <= dpu_rs1_data - dpu_rs2_data;
                alu_PC_next <= dpu_PC+'d4;
                end
      dpu_SRA : begin
                //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SRA", PC, dpu_rs1, dpu_rs1_data, dpu_rs2, dpu_rs2_data, dpu_rd);
                alu_rd_wr <= '1;
                alu_rd_data <= dpu_rs1_data >>> dpu_rs2_data;
                alu_PC_next <= dpu_PC+'d4;
                end


      dpu_ADDI : begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "ADDI", PC, dpu_rs1, dpu_rs1_data, {{20{dpu_imm[11]}},dpu_imm[11:0]}, dpu_rd);
                 alu_rd_wr <= '1;
                 alu_rd_data <= dpu_rs1_data + {{20{dpu_imm[11]}},dpu_imm[11:0]};
                 alu_PC_next <= dpu_PC+'d4;
                 end
      dpu_SLTI : begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "SLTI", PC, dpu_rs1, dpu_rs1_data, {{20{dpu_imm[11]}},dpu_imm[11:0]}, dpu_rd);
                 alu_rd_wr <= '1;
                 if($signed(dpu_rs1_data) < $signed({{20{dpu_imm[11]}},dpu_imm[11:0]}))
                   alu_rd_data <= 'd1;
                 else
                   alu_rd_data <= 'd0;
                 alu_PC_next <= dpu_PC+'d4;
                 end
      dpu_SLTIU : begin
                  //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "SLTIU", PC, dpu_rs1, dpu_rs1_data, {{20{dpu_imm[11]}},dpu_imm[11:0]}, dpu_rd);
                  alu_rd_wr <= '1;
                  if(dpu_rs1_data < {{20{dpu_imm[11]}},dpu_imm[11:0]})
                    alu_rd_data <= 'd1;
                  else
                    alu_rd_data <= 'd0;
                  alu_PC_next <= dpu_PC+'d4;
                  end
      dpu_ANDI : begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "ANDI", PC, dpu_rs1, dpu_rs1_data, {{20{dpu_imm[11]}},dpu_imm[11:0]}, dpu_rd);
                 alu_rd_wr <= '1;
                 alu_rd_data <= dpu_rs1_data & {{20{dpu_imm[11]}},dpu_imm[11:0]};
                 alu_PC_next <= dpu_PC+'d4;
                 end
      dpu_ORI : begin
                //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "ORI", PC, dpu_rs1, dpu_rs1_data, {{20{dpu_imm[11]}},dpu_imm[11:0]}, dpu_rd);
                alu_rd_wr <= '1;
                alu_rd_data <= dpu_rs1_data | {{20{dpu_imm[11]}},dpu_imm[11:0]};
                alu_PC_next <= dpu_PC+'d4;
                end
      dpu_XORI : begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "XORI", PC, dpu_rs1, dpu_rs1_data, {{20{dpu_imm[11]}},dpu_imm[11:0]}, dpu_rd);
                 alu_rd_wr <= '1;
                 alu_rd_data <= dpu_rs1_data ^ {{20{dpu_imm[11]}},dpu_imm[11:0]};
                 alu_PC_next <= dpu_PC+'d4;
                 end
      dpu_SLLI : begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "SLLI", PC, dpu_rs1, dpu_rs1_data, {{27{'0}},dpu_imm[4:0]}, dpu_rd);
                 alu_rd_wr <= '1;
                 alu_rd_data <= dpu_rs1_data << dpu_shamt;
                 alu_PC_next <= dpu_PC+'d4;
                 end
      dpu_SRLI : begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "SRLI", PC, dpu_rs1, dpu_rs1_data, {{27{'0}},dpu_imm[4:0]}, dpu_rd);
                 alu_rd_wr <= '1;
                 alu_rd_data <= dpu_rs1_data >> dpu_shamt;
                 alu_PC_next <= dpu_PC+'d4;
                 end
      dpu_SRAI : begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "SRAI", PC, dpu_rs1, dpu_rs1_data, dpu_imm[4:0], dpu_rd);
                 alu_rd_wr <= '1;
                 alu_rd_data <= $signed(dpu_rs1_data) >>> dpu_shamt;
                 alu_PC_next <= dpu_PC+'d4;
                 end


      dpu_FENCE : begin
                  //$display("%-5s PC=%08X" , "FENCE", PC);
                  //TODO
                  alu_PC_next <= dpu_PC+'d4;
                  end



      dpu_ECALL : begin
                  //$display("%-5s PC=%08X" , "ECALL - !!TODO!!", PC);
                  alu_PC_next <= dpu_PC+'d4;
                  end
      dpu_EBREAK : begin
                   //TODO
                   //$display("%-5s PC=%08X" , "EBREAK - !!TODO!!", PC);
                   alu_PC_next <= dpu_PC+'d4;
                   end
      dpu_TRAP :   begin
                   //TODO
                   //$display("%0t %-5s PC=%08X : 0x%08f" , $time, "TRAP from IDU - !!TODO!!", dpu_PC, dpu_inst);
                   alu_trap <= '1;
                   end
          default : begin
                //$display("%0t %-5s PC=%08X : 0x%08X" , $time, "TRAP from INVALID INST!!", alu_PC, alu_inst);
                alu_trap <= '1;
                end
              
      endcase

    if(dpu_PC[1:0] != '0)
      begin
      //$display("%0t %-5s PC=%08X : 0x%08X" , $time, "TRAP from INVALID PC!!", alu_PC, alu_inst);
      alu_trap <= '1;
      end

    end

  if(dpu_rd == '0)
    alu_rd_data <= '0;

  if(rst)
    begin
    alu_vld <= '0;

    alu_PC <= '0;
    alu_PC_next <= '0;
    alu_rd_wr  <= '0;
    alu_rd_data <= '0;

    alu_inst    <= '0;
    alu_order   <= '0;
    alu_fm      <= '0;
    alu_pred    <= '0;
    alu_succ    <= '0;
    alu_shamt   <= '0;
    alu_imm     <= '0;
    alu_uimm    <= '0;
    alu_csr     <= '0;
    alu_funct7  <= '0;
    alu_funct3  <= '0;
    alu_rs2     <= '0;
    alu_rs1     <= '0;
    alu_rd      <= '0;
    alu_opcode  <= '0;
              
    alu_LUI     <= '0;
    alu_AUIPC   <= '0;
    alu_ADDI    <= '0;
    alu_SLTI    <= '0;
    alu_SLTIU   <= '0;
    alu_XORI    <= '0;
    alu_ORI     <= '0;
    alu_ANDI    <= '0;
    alu_SLLI    <= '0;
    alu_SRLI    <= '0;
    alu_SRAI    <= '0;
    alu_ADD     <= '0;
    alu_SUB     <= '0;
    alu_SLL     <= '0;
    alu_SLT     <= '0;
    alu_SLTU    <= '0;
    alu_XOR     <= '0;
    alu_SRL     <= '0;
    alu_SRA     <= '0;
    alu_OR      <= '0;
    alu_AND     <= '0;
    alu_FENCE   <= '0;
    alu_FENCE_I <= '0;
    alu_ECALL   <= '0;
    alu_CSRRW   <= '0;
    alu_CSRRS   <= '0;
    alu_CSRRC   <= '0;
    alu_CSRRWI  <= '0;
    alu_CSRRSI  <= '0;
    alu_CSRRCI  <= '0;
    alu_EBREAK  <= '0;
    alu_MUL     <= '0;
    alu_MULH    <= '0;
    alu_MULHSU  <= '0;
    alu_MULHU   <= '0;
    alu_DIV     <= '0;
    alu_DIVU    <= '0;
    alu_REM     <= '0;
    alu_REMU    <= '0;
    alu_TRAP    <= '0;
    end
  end

endmodule
