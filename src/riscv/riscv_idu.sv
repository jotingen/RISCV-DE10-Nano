module riscv_idu #(
  parameter M_EXT = 1
) (
  input  logic        clk,
  input  logic        rst,

  input  logic        ifu_vld,
  input  logic [31:0] ifu_inst,
  input  logic [31:0] ifu_inst_PC,

  input  logic        alu_vld,
  input  logic        alu_retired,
  input  logic        alu_freeze,
  input  logic        alu_br_miss,
  input  logic        alu_trap,

  output logic        idu_vld,
  output logic        idu_freeze,
  output logic [31:0] idu_inst,
  output logic [31:0] idu_inst_PC,

  output logic  [3:0] idu_decode_fm,
  output logic  [3:0] idu_decode_pred,
  output logic  [3:0] idu_decode_succ,
  output logic  [4:0] idu_decode_shamt,
  output logic [31:0] idu_decode_imm,
  output logic  [4:0] idu_decode_uimm,
  output logic [11:0] idu_decode_csr,
  output logic  [6:0] idu_decode_funct7,
  output logic  [2:0] idu_decode_funct3,
  output logic  [4:0] idu_decode_rs2,
  output logic  [4:0] idu_decode_rs1,
  output logic  [4:0] idu_decode_rd,
  output logic  [6:0] idu_decode_opcode,

  output logic        idu_decode_LUI,
  output logic        idu_decode_AUIPC,
  output logic        idu_decode_JAL,
  output logic        idu_decode_JALR,
  output logic        idu_decode_BEQ,
  output logic        idu_decode_BNE,
  output logic        idu_decode_BLT,
  output logic        idu_decode_BGE,
  output logic        idu_decode_BLTU,
  output logic        idu_decode_BGEU,
  output logic        idu_decode_LB,
  output logic        idu_decode_LH,
  output logic        idu_decode_LW,
  output logic        idu_decode_LBU,
  output logic        idu_decode_LHU,
  output logic        idu_decode_SB,
  output logic        idu_decode_SH,
  output logic        idu_decode_SW,
  output logic        idu_decode_ADDI,
  output logic        idu_decode_SLTI,
  output logic        idu_decode_SLTIU,
  output logic        idu_decode_XORI,
  output logic        idu_decode_ORI,
  output logic        idu_decode_ANDI,
  output logic        idu_decode_SLLI,
  output logic        idu_decode_SRLI,
  output logic        idu_decode_SRAI,
  output logic        idu_decode_ADD,
  output logic        idu_decode_SUB,
  output logic        idu_decode_SLL,
  output logic        idu_decode_SLT,
  output logic        idu_decode_SLTU,
  output logic        idu_decode_XOR,
  output logic        idu_decode_SRL,
  output logic        idu_decode_SRA,
  output logic        idu_decode_OR,
  output logic        idu_decode_AND,
  output logic        idu_decode_FENCE,
  output logic        idu_decode_FENCE_I,
  output logic        idu_decode_ECALL,
  output logic        idu_decode_CSRRW,
  output logic        idu_decode_CSRRS,
  output logic        idu_decode_CSRRC,
  output logic        idu_decode_CSRRWI,
  output logic        idu_decode_CSRRSI,
  output logic        idu_decode_CSRRCI,
  output logic        idu_decode_EBREAK,
  output logic        idu_decode_MUL,
  output logic        idu_decode_MULH,
  output logic        idu_decode_MULHSU,
  output logic        idu_decode_MULHU,
  output logic        idu_decode_DIV,
  output logic        idu_decode_DIVU,
  output logic        idu_decode_REM,
  output logic        idu_decode_REMU,
  output logic        idu_decode_TRAP
);

  logic  [6:0] instR_funct7;
  logic  [4:0] instR_rs2;
  logic  [4:0] instR_rs1;
  logic  [2:0] instR_funct3;
  logic  [4:0] instR_rd;

  logic [11:0] instI_imm_11_0;
  logic  [4:0] instI_rs1;
  logic  [2:0] instI_funct3;
  logic  [4:0] instI_rd;

  logic  [6:0] instS_imm_11_5;
  logic  [4:0] instS_rs2;
  logic  [4:0] instS_rs1;
  logic  [2:0] instS_funct3;
  logic  [4:0] instS_imm_4_0;

  logic        instB_imm_12;
  logic  [5:0] instB_imm_10_5;
  logic  [4:0] instB_rs2;
  logic  [4:0] instB_rs1;
  logic  [2:0] instB_funct3;
  logic  [3:0] instB_imm_4_1;
  logic        instB_imm_11;

  logic [19:0] instU_imm_31_12;
  logic  [4:0] instU_rd;

  logic        instJ_imm_20;
  logic  [9:0] instJ_imm_10_1;
  logic        instJ_imm_11;
  logic  [7:0] instJ_imm_19_12;
  logic  [4:0] instJ_rd;

  logic  [6:0] inst_opcode;

  assign instR_funct7    = ifu_inst[31:25];
  assign instR_rs2       = ifu_inst[24:20];
  assign instR_rs1       = ifu_inst[19:15];
  assign instR_funct3    = ifu_inst[14:12];
  assign instR_rd        = ifu_inst[11:7];
                        
  assign instI_imm_11_0  = ifu_inst[31:20];
  assign instI_rs1       = ifu_inst[19:15];
  assign instI_funct3    = ifu_inst[14:12];
  assign instI_rd        = ifu_inst[11:7];
                        
  assign instS_imm_11_5  = ifu_inst[31:25];
  assign instS_rs2       = ifu_inst[24:20];
  assign instS_rs1       = ifu_inst[19:15];
  assign instS_funct3    = ifu_inst[14:12];
  assign instS_imm_4_0   = ifu_inst[11:7];
                        
  assign instB_imm_12    = ifu_inst[31];
  assign instB_imm_10_5  = ifu_inst[30:25];
  assign instB_rs2       = ifu_inst[24:20];
  assign instB_rs1       = ifu_inst[19:15];
  assign instB_funct3    = ifu_inst[14:12];
  assign instB_imm_4_1   = ifu_inst[11:8];
  assign instB_imm_11    = ifu_inst[7];
                        
  assign instU_imm_31_12 = ifu_inst[31:12];
  assign instU_rd        = ifu_inst[11:7];
                        
  assign instJ_imm_20    = ifu_inst[31];
  assign instJ_imm_10_1  = ifu_inst[30:21];
  assign instJ_imm_11    = ifu_inst[20];
  assign instJ_imm_19_12 = ifu_inst[19:12];
  assign instJ_rd        = ifu_inst[11:7];

  assign inst_opcode     = ifu_inst[6:0];
  
logic frozen;
always_comb
  begin
  //Pipe frozen
  frozen = alu_vld & alu_freeze;
  end


always_ff @(posedge clk)
  begin
  idu_freeze <= idu_freeze;

  if(alu_vld & alu_retired)
    idu_freeze <= '0;

  //if((frozen & ~idu_vld) | ~frozen | (alu_vld & alu_retired))
  if(~frozen)
    begin
    idu_vld <= ifu_vld;
    //Throw away if branch missed or trapped
    if(alu_vld & (alu_br_miss | alu_trap))
      idu_vld <= '0;
    idu_inst    <= ifu_inst;
    idu_inst_PC <= ifu_inst_PC;

    idu_decode_opcode  <= ifu_inst[6:0];
    idu_decode_fm      <= '0;
    idu_decode_pred    <= '0;
    idu_decode_succ    <= '0;
    idu_decode_shamt   <= '0;
    idu_decode_imm     <= '0;
    idu_decode_uimm    <= '0;
    idu_decode_csr     <= '0;
    idu_decode_funct7  <= '0;
    idu_decode_funct3  <= '0;
    idu_decode_rs2     <= '0;
    idu_decode_rs1     <= '0;
    idu_decode_rd      <= '0;
  
    idu_decode_LUI     <= '0;
    idu_decode_AUIPC   <= '0;
    idu_decode_JAL     <= '0;
    idu_decode_JALR    <= '0;
    idu_decode_BEQ     <= '0;
    idu_decode_BNE     <= '0;
    idu_decode_BLT     <= '0;
    idu_decode_BGE     <= '0;
    idu_decode_BLTU    <= '0;
    idu_decode_BGEU    <= '0;
    idu_decode_LB      <= '0;
    idu_decode_LH      <= '0;
    idu_decode_LW      <= '0;
    idu_decode_LBU     <= '0;
    idu_decode_LHU     <= '0;
    idu_decode_SB      <= '0;
    idu_decode_SH      <= '0;
    idu_decode_SW      <= '0;
    idu_decode_ADDI    <= '0;
    idu_decode_SLTI    <= '0;
    idu_decode_SLTIU   <= '0;
    idu_decode_XORI    <= '0;
    idu_decode_ORI     <= '0;
    idu_decode_ANDI    <= '0;
    idu_decode_SLLI    <= '0;
    idu_decode_SRLI    <= '0;
    idu_decode_SRAI    <= '0;
    idu_decode_ADD     <= '0;
    idu_decode_SUB     <= '0;
    idu_decode_SLL     <= '0;
    idu_decode_SLT     <= '0;
    idu_decode_SLTU    <= '0;
    idu_decode_XOR     <= '0;
    idu_decode_SRL     <= '0;
    idu_decode_SRA     <= '0;
    idu_decode_OR      <= '0;
    idu_decode_AND     <= '0;
    idu_decode_FENCE   <= '0;
    idu_decode_FENCE_I <= '0;
    idu_decode_ECALL   <= '0;
    idu_decode_CSRRW   <= '0;
    idu_decode_CSRRS   <= '0;
    idu_decode_CSRRC   <= '0;
    idu_decode_CSRRWI  <= '0;
    idu_decode_CSRRSI  <= '0;
    idu_decode_CSRRCI  <= '0;
    idu_decode_EBREAK  <= '0;
    idu_decode_MUL     <= '0;
    idu_decode_MULH    <= '0;
    idu_decode_MULHSU  <= '0;
    idu_decode_MULHU   <= '0;
    idu_decode_DIV     <= '0;
    idu_decode_DIVU    <= '0;
    idu_decode_REM     <= '0;
    idu_decode_REMU    <= '0;
    idu_decode_TRAP    <= '0;
  
    unique
    case (inst_opcode)
      'b0110111 : begin //LUI
                  idu_decode_imm[31:12] <= instU_imm_31_12;
                  idu_decode_rd         <= instU_rd;
                  idu_decode_LUI        <= '1;
                  end
      'b0010111 : begin //AUIPC
                  idu_decode_imm[31:12] <= instU_imm_31_12;
                  idu_decode_rd         <= instU_rd;
                  idu_decode_AUIPC      <= '1;
                  end
      'b1101111 : begin //JAL
                  idu_decode_imm[20]    <= instJ_imm_20;
                  idu_decode_imm[10:1]  <= instJ_imm_10_1;
                  idu_decode_imm[11]    <= instJ_imm_11;
                  idu_decode_imm[19:12] <= instJ_imm_19_12;
                  idu_decode_rd         <= instJ_rd;
                  idu_decode_JAL        <= '1;
                  end
      'b1100111 : begin 
                  case (instB_funct3)
                    'b000 : begin //JALR
                            idu_decode_imm[11:0]  <= instI_imm_11_0;
                            idu_decode_rs1        <= instI_rs1;
                            idu_decode_funct3     <= instI_funct3;
                            idu_decode_rd         <= instI_rd;
                            idu_decode_JALR       <= '1;
                            end
                    default : begin 
                              idu_decode_TRAP <= '1;
                              end
                  endcase
                  end
      'b1100011 : begin 
                  unique
                  case (instB_funct3)
                    'b000 : begin //BEQ
                            idu_decode_imm[12]    <= instB_imm_12;
                            idu_decode_imm[10:5]  <= instB_imm_10_5;
                            idu_decode_rs2        <= instB_rs2;
                            idu_decode_rs1        <= instB_rs1;
                            idu_decode_funct3     <= instB_funct3;
                            idu_decode_imm[4:1]   <= instB_imm_4_1;
                            idu_decode_imm[11]    <= instB_imm_11;
  			    idu_decode_BEQ        <= '1;
                            end
                    'b001 : begin //BNE
                            idu_decode_imm[12]    <= instB_imm_12;
                            idu_decode_imm[10:5]  <= instB_imm_10_5;
                            idu_decode_rs2        <= instB_rs2;
                            idu_decode_rs1        <= instB_rs1;
                            idu_decode_funct3     <= instB_funct3;
                            idu_decode_imm[4:1]   <= instB_imm_4_1;
                            idu_decode_imm[11]    <= instB_imm_11;
                            idu_decode_BNE        <= '1;
                            end
                    'b100 : begin //BLT
                            idu_decode_imm[12]    <= instB_imm_12;
                            idu_decode_imm[10:5]  <= instB_imm_10_5;
                            idu_decode_rs2        <= instB_rs2;
                            idu_decode_rs1        <= instB_rs1;
                            idu_decode_funct3     <= instB_funct3;
                            idu_decode_imm[4:1]   <= instB_imm_4_1;
                            idu_decode_imm[11]    <= instB_imm_11;
                            idu_decode_BLT        <= '1;
                            end
                    'b101 : begin //BGE
                            idu_decode_imm[12]    <= instB_imm_12;
                            idu_decode_imm[10:5]  <= instB_imm_10_5;
                            idu_decode_rs2        <= instB_rs2;
                            idu_decode_rs1        <= instB_rs1;
                            idu_decode_funct3     <= instB_funct3;
                            idu_decode_imm[4:1]   <= instB_imm_4_1;
                            idu_decode_imm[11]    <= instB_imm_11;
                            idu_decode_BGE        <= '1;
                            end
                    'b110 : begin //BLTU
                            idu_decode_imm[12]    <= instB_imm_12;
                            idu_decode_imm[10:5]  <= instB_imm_10_5;
                            idu_decode_rs2        <= instB_rs2;
                            idu_decode_rs1        <= instB_rs1;
                            idu_decode_funct3     <= instB_funct3;
                            idu_decode_imm[4:1]   <= instB_imm_4_1;
                            idu_decode_imm[11]    <= instB_imm_11;
                            idu_decode_BLTU       <= '1;
                            end
                    'b111 : begin //BGEU
                            idu_decode_imm[12]    <= instB_imm_12;
                            idu_decode_imm[10:5]  <= instB_imm_10_5;
                            idu_decode_rs2        <= instB_rs2;
                            idu_decode_rs1        <= instB_rs1;
                            idu_decode_funct3     <= instB_funct3;
                            idu_decode_imm[4:1]   <= instB_imm_4_1;
                            idu_decode_imm[11]    <= instB_imm_11;
                            idu_decode_BGEU       <= '1;
                            end
                    default : begin 
                              idu_decode_TRAP <= '1;
                              end
                  endcase
                  end
      'b0000011 : begin     
                  unique
                  case (instI_funct3)
                    'b000 : begin //LB
                            idu_decode_imm[11:0]  <= instI_imm_11_0;
                            idu_decode_rs1        <= instI_rs1;
                            idu_decode_funct3     <= instI_funct3;
                            idu_decode_rd         <= instI_rd;
                            idu_freeze            <= '1;
                            idu_decode_LB         <= '1;
                            end
                    'b001 : begin //LH
                            idu_decode_imm[11:0]  <= instI_imm_11_0;
                            idu_decode_rs1        <= instI_rs1;
                            idu_decode_funct3     <= instI_funct3;
                            idu_decode_rd         <= instI_rd;
                            idu_freeze            <= '1;
                            idu_decode_LH         <= '1;
                            end
                    'b010 : begin //LW
                            idu_decode_imm[11:0]  <= instI_imm_11_0;
                            idu_decode_rs1        <= instI_rs1;
                            idu_decode_funct3     <= instI_funct3;
                            idu_decode_rd         <= instI_rd;
                            idu_freeze            <= '1;
                            idu_decode_LW         <= '1;
                            end
                    'b100 : begin //LBU
                            idu_decode_imm[11:0]  <= instI_imm_11_0;
                            idu_decode_rs1        <= instI_rs1;
                            idu_decode_funct3     <= instI_funct3;
                            idu_decode_rd         <= instI_rd;
                            idu_freeze            <= '1;
                            idu_decode_LBU        <= '1;
                            end
                    'b101 : begin //LHU
                            idu_decode_imm[11:0]  <= instI_imm_11_0;
                            idu_decode_rs1        <= instI_rs1;
                            idu_decode_funct3     <= instI_funct3;
                            idu_decode_rd         <= instI_rd;
                            idu_freeze            <= '1;
                            idu_decode_LHU        <= '1;
                            end
                    default : begin 
                              idu_decode_TRAP <= '1;
                              end
                  endcase
                  end
      'b0100011 : begin 
                  unique
                  case (instS_funct3)
                    'b000 : begin //SB
                            idu_decode_imm[11:5]  <= instS_imm_11_5;
                            idu_decode_rs2        <= instS_rs2;
                            idu_decode_rs1        <= instS_rs1;
                            idu_decode_funct3     <= instS_funct3;
                            idu_decode_imm[4:0]   <= instS_imm_4_0;
                            idu_freeze            <= '1;
                            idu_decode_SB         <= '1;
                            end
                    'b001 : begin //SH
                            idu_decode_imm[11:5]  <= instS_imm_11_5;
                            idu_decode_rs2        <= instS_rs2;
                            idu_decode_rs1        <= instS_rs1;
                            idu_decode_funct3     <= instS_funct3;
                            idu_decode_imm[4:0]   <= instS_imm_4_0;
                            idu_freeze            <= '1;
                            idu_decode_SH         <= '1;
                            end
                    'b010 : begin //SW
                            idu_decode_imm[11:5]  <= instS_imm_11_5;
                            idu_decode_rs2        <= instS_rs2;
                            idu_decode_rs1        <= instS_rs1;
                            idu_decode_funct3     <= instS_funct3;
                            idu_decode_imm[4:0]   <= instS_imm_4_0;
                            idu_freeze            <= '1;
                            idu_decode_SW         <= '1;
                            end
                    default : begin 
                              idu_decode_TRAP <= '1;
                              end
                  endcase
                  end
      'b0010011 : begin 
                  unique
                  case (instI_funct3)
                    'b000 : begin //ADDI
                            idu_decode_imm[11:0]  <= instI_imm_11_0;
                            idu_decode_rs1        <= instI_rs1;
                            idu_decode_funct3     <= instI_funct3;
                            idu_decode_rd         <= instI_rd;
                            idu_decode_ADDI       <= '1;
                            end
                    'b010 : begin //SLTI
                            idu_decode_imm[11:0]  <= instI_imm_11_0;
                            idu_decode_rs1        <= instI_rs1;
                            idu_decode_funct3     <= instI_funct3;
                            idu_decode_rd         <= instI_rd;
                            idu_decode_SLTI       <= '1;
                            end
                    'b011 : begin //SLTIU
                            idu_decode_imm[11:0]  <= instI_imm_11_0;
                            idu_decode_rs1        <= instI_rs1;
                            idu_decode_funct3     <= instI_funct3;
                            idu_decode_rd         <= instI_rd;
                            idu_decode_SLTIU      <= '1;
                            end
                    'b100 : begin //XORI
                            idu_decode_imm[11:0]  <= instI_imm_11_0;
                            idu_decode_rs1        <= instI_rs1;
                            idu_decode_funct3     <= instI_funct3;
                            idu_decode_rd         <= instI_rd;
                            idu_decode_XORI       <= '1;
                            end
                    'b110 : begin //ORI
                            idu_decode_imm[11:0]  <= instI_imm_11_0;
                            idu_decode_rs1        <= instI_rs1;
                            idu_decode_funct3     <= instI_funct3;
                            idu_decode_rd         <= instI_rd;
                            idu_decode_ORI        <= '1;
                            end
                    'b111 : begin //ANDI
                            idu_decode_imm[11:0]  <= instI_imm_11_0;
                            idu_decode_rs1        <= instI_rs1;
                            idu_decode_funct3     <= instI_funct3;
                            idu_decode_rd         <= instI_rd;
                            idu_decode_ANDI       <= '1;
                            end
                    'b001 : begin 
                            case (instR_funct7)
                              'b0000000 : begin //SLLI
                                          idu_decode_funct7     <= instR_funct7;  
                                          idu_decode_shamt      <= instR_rs2;
                                          idu_decode_rs1        <= instR_rs1;
                                          idu_decode_funct3     <= instR_funct3;
                                          idu_decode_rd         <= instR_rd;
                                          idu_decode_SLLI       <= '1;
                                          end
                              default : begin 
                                        idu_decode_TRAP <= '1;
                                        end
                            endcase
                            end
                    'b101 : begin 
                            unique
                            case (instR_funct7)
                              'b0000000 : begin //SRLI
                                          idu_decode_funct7     <= instR_funct7;  
                                          idu_decode_shamt      <= instR_rs2;
                                          idu_decode_rs1        <= instR_rs1;
                                          idu_decode_funct3     <= instR_funct3;
                                          idu_decode_rd         <= instR_rd;
                                          idu_decode_SRLI       <= '1;
                                          end
                              'b0100000 : begin //SRAI
                                          idu_decode_funct7     <= instR_funct7;  
                                          idu_decode_shamt      <= instR_rs2;
                                          idu_decode_rs1        <= instR_rs1;
                                          idu_decode_funct3     <= instR_funct3;
                                          idu_decode_rd         <= instR_rd;
                                          idu_decode_SRAI       <= '1;
                                          end
                              default : begin 
                                        idu_decode_TRAP <= '1;
                                        end
                            endcase
                            end
                    default : begin 
                              idu_decode_TRAP <= '1;
                              end
                  endcase
                  end
      'b0110011 : begin 
                  unique
                  case (instR_funct3)
                    'b000 : begin 
                            unique
                            case (instR_funct7)
                              'b0000000 : begin //ADD
                                          idu_decode_funct7     <= instR_funct7;  
                                          idu_decode_rs2        <= instR_rs2;
                                          idu_decode_rs1        <= instR_rs1;
                                          idu_decode_funct3     <= instR_funct3;
                                          idu_decode_rd         <= instR_rd;
                                          idu_decode_ADD        <= '1;
                                          end
                              'b0000001 : begin //MUL
                                          if(M_EXT)
                                            begin
                                            idu_decode_funct7     <= instR_funct7;  
                                            idu_decode_rs2        <= instR_rs2;
                                            idu_decode_rs1        <= instR_rs1;
                                            idu_decode_funct3     <= instR_funct3;
                                            idu_decode_rd         <= instR_rd;
                                            idu_decode_MUL        <= '1;
                                            end
                                          else
                                            begin 
                                            idu_decode_TRAP <= '1;
                                            end
                                          end
                              'b0100000 : begin //SUB
                                          idu_decode_funct7     <= instR_funct7;  
                                          idu_decode_rs2        <= instR_rs2;
                                          idu_decode_rs1        <= instR_rs1;
                                          idu_decode_funct3     <= instR_funct3;
                                          idu_decode_rd         <= instR_rd;
                                          idu_decode_SUB        <= '1;
                                          end
                              default : begin 
                                        idu_decode_TRAP <= '1;
                                        end
                            endcase
                            end
                    'b001 : begin 
                            unique
                            case (instR_funct7)
                              'b0000000 : begin //SLL
                                          idu_decode_funct7     <= instR_funct7;  
                                          idu_decode_rs2        <= instR_rs2;
                                          idu_decode_rs1        <= instR_rs1;
                                          idu_decode_funct3     <= instR_funct3;
                                          idu_decode_rd         <= instR_rd;
                                          idu_decode_SLL        <= '1;
                                          end
                              'b0000001 : begin //MULH
                                          if(M_EXT)
                                            begin
                                            idu_decode_funct7     <= instR_funct7;  
                                            idu_decode_rs2        <= instR_rs2;
                                            idu_decode_rs1        <= instR_rs1;
                                            idu_decode_funct3     <= instR_funct3;
                                            idu_decode_rd         <= instR_rd;
                                            idu_decode_MULH       <= '1;
                                            end
                                          else
                                            begin 
                                            idu_decode_TRAP <= '1;
                                            end
                                          end
                              default : begin 
                                        idu_decode_TRAP <= '1;
                                        end
                            endcase
                            end
                    'b010 : begin 
                            unique
                            case (instR_funct7)
                              'b0000000 : begin //SLT
                                          idu_decode_funct7     <= instR_funct7;  
                                          idu_decode_rs2        <= instR_rs2;
                                          idu_decode_rs1        <= instR_rs1;
                                          idu_decode_funct3     <= instR_funct3;
                                          idu_decode_rd         <= instR_rd;
                                          idu_decode_SLT        <= '1;
                                          end
                              'b0000001 : begin //MULHSU
                                          if(M_EXT)
                                            begin
                                            idu_decode_funct7     <= instR_funct7;  
                                            idu_decode_rs2        <= instR_rs2;
                                            idu_decode_rs1        <= instR_rs1;
                                            idu_decode_funct3     <= instR_funct3;
                                            idu_decode_rd         <= instR_rd;
                                            idu_decode_MULHSU     <= '1;
                                            end
                                          else
                                            begin 
                                            idu_decode_TRAP <= '1;
                                            end
                                          end
                              default : begin 
                                        idu_decode_TRAP <= '1;
                                        end
                            endcase
                            end
                    'b011 : begin 
                            unique
                            case (instR_funct7)
                              'b0000000 : begin //SLTU
                                          idu_decode_funct7     <= instR_funct7;  
                                          idu_decode_rs2        <= instR_rs2;
                                          idu_decode_rs1        <= instR_rs1;
                                          idu_decode_funct3     <= instR_funct3;
                                          idu_decode_rd         <= instR_rd;
                                          idu_decode_SLTU       <= '1;
                                          end
                              'b0000001 : begin //MULHU
                                          if(M_EXT)
                                            begin
                                            idu_decode_funct7     <= instR_funct7;  
                                            idu_decode_rs2        <= instR_rs2;
                                            idu_decode_rs1        <= instR_rs1;
                                            idu_decode_funct3     <= instR_funct3;
                                            idu_decode_rd         <= instR_rd;
                                            idu_decode_MULHU      <= '1;
                                            end
                                          else
                                            begin 
                                            idu_decode_TRAP <= '1;
                                            end
                                          end
                              default : begin 
                                        idu_decode_TRAP <= '1;
                                        end
                            endcase
                            end
                    'b100 : begin 
                            unique
                            case (instR_funct7)
                              'b0000000 : begin //XOR
                                          idu_decode_funct7     <= instR_funct7;  
                                          idu_decode_rs2        <= instR_rs2;
                                          idu_decode_rs1        <= instR_rs1;
                                          idu_decode_funct3     <= instR_funct3;
                                          idu_decode_rd         <= instR_rd;
                                          idu_decode_XOR        <= '1;
                                          end
                              'b0000001 : begin //DIV 
                                          if(M_EXT)
                                            begin
                                            idu_decode_funct7     <= instR_funct7;  
                                            idu_decode_rs2        <= instR_rs2;
                                            idu_decode_rs1        <= instR_rs1;
                                            idu_decode_funct3     <= instR_funct3;
                                            idu_decode_rd         <= instR_rd;
                                            idu_decode_DIV        <= '1;
                                            end
                                          else
                                            begin 
                                            idu_decode_TRAP <= '1;
                                            end
                                          end
                              default : begin 
                                        idu_decode_TRAP <= '1;
                                        end
                            endcase
                            end
                    'b101 : begin 
                            unique
                            case (instR_funct7)
                              'b0000000 : begin //SRL
                                          idu_decode_funct7     <= instR_funct7;  
                                          idu_decode_rs2        <= instR_rs2;
                                          idu_decode_rs1        <= instR_rs1;
                                          idu_decode_funct3     <= instR_funct3;
                                          idu_decode_rd         <= instR_rd;
                                          idu_decode_SRL        <= '1;
                                          end
                              'b0000001 : begin //DIVU
                                          if(M_EXT)
                                            begin
                                            idu_decode_funct7     <= instR_funct7;  
                                            idu_decode_rs2        <= instR_rs2;
                                            idu_decode_rs1        <= instR_rs1;
                                            idu_decode_funct3     <= instR_funct3;
                                            idu_decode_rd         <= instR_rd;
                                            idu_decode_DIVU       <= '1;
                                            end
                                          else
                                            begin 
                                            idu_decode_TRAP <= '1;
                                            end
                                          end
                              'b0100000 : begin //SRA
                                          idu_decode_funct7     <= instR_funct7;  
                                          idu_decode_rs2        <= instR_rs2;
                                          idu_decode_rs1        <= instR_rs1;
                                          idu_decode_funct3     <= instR_funct3;
                                          idu_decode_rd         <= instR_rd;
                                          idu_decode_SRA        <= '1;
                                          end
                              default : begin 
                                        idu_decode_TRAP <= '1;
                                        end
                            endcase
                            end
                    'b110 : begin 
                            unique
                            case (instR_funct7)
                              'b0000000 : begin //OR
                                          idu_decode_funct7     <= instR_funct7;  
                                          idu_decode_rs2        <= instR_rs2;
                                          idu_decode_rs1        <= instR_rs1;
                                          idu_decode_funct3     <= instR_funct3;
                                          idu_decode_rd         <= instR_rd;
                                          idu_decode_OR         <= '1;
                                          end
                              'b0000001 : begin //REM 
                                          if(M_EXT)
                                            begin
                                            idu_decode_funct7     <= instR_funct7;  
                                            idu_decode_rs2        <= instR_rs2;
                                            idu_decode_rs1        <= instR_rs1;
                                            idu_decode_funct3     <= instR_funct3;
                                            idu_decode_rd         <= instR_rd;
                                            idu_decode_REM        <= '1;
                                            end
                                          else
                                            begin 
                                            idu_decode_TRAP <= '1;
                                            end
                                          end
                              default : begin 
                                        idu_decode_TRAP <= '1;
                                        end
                            endcase
                            end
                    'b111 : begin 
                            unique
                            case (instR_funct7)
                              'b0000000 : begin //AND
                                          idu_decode_funct7     <= instR_funct7;  
                                          idu_decode_rs2        <= instR_rs2;
                                          idu_decode_rs1        <= instR_rs1;
                                          idu_decode_funct3     <= instR_funct3;
                                          idu_decode_rd         <= instR_rd;
                                          idu_decode_AND        <= '1;
                                          end
                              'b0000001 : begin //REMU
                                          if(M_EXT)
                                            begin
                                            idu_decode_funct7     <= instR_funct7;  
                                            idu_decode_rs2        <= instR_rs2;
                                            idu_decode_rs1        <= instR_rs1;
                                            idu_decode_funct3     <= instR_funct3;
                                            idu_decode_rd         <= instR_rd;
                                            idu_decode_REMU       <= '1;
                                            end
                                          else
                                            begin 
                                            idu_decode_TRAP <= '1;
                                            end
                                          end
                              default : begin 
                                        idu_decode_TRAP <= '1;
                                        end
                            endcase
                            end
                    default : begin 
                              idu_decode_TRAP <= '1;
                              end
                  endcase
                  end
      'b0001111 : begin //FENCE
                  {idu_decode_fm,
                   idu_decode_pred,
                   idu_decode_succ} <= instI_imm_11_0;
                  idu_decode_rs1            <= instI_rs1;
                  idu_decode_funct3         <= instI_funct3;
                  idu_decode_rd             <= instI_rd;
                  idu_decode_FENCE      <= '1;
                  end
      'b1110011 : begin 
                  unique
                  case (instI_funct3)
                    'b000 : begin 
                            unique
                            case (instI_imm_11_0)
                              'b000000000000 : begin //ECALL
                                               idu_decode_ECALL      <= '1;
                                               end
                              'b000000000001 : begin //EBREAK
                                               idu_decode_EBREAK     <= '1;
                                               end
                              default : begin 
                                        idu_decode_TRAP <= '1;
                                        end
                            endcase
                            end
                    'b001 : begin 
                            idu_decode_csr        <= instI_imm_11_0;
                            idu_decode_rs1        <= instI_rs1;
                            idu_decode_funct3     <= instI_funct3;
                            idu_decode_rd         <= instI_rd;
                            idu_decode_CSRRW      <= '1;
                            end
                    'b010 : begin 
                            idu_decode_csr        <= instI_imm_11_0;
                            idu_decode_rs1        <= instI_rs1;
                            idu_decode_funct3     <= instI_funct3;
                            idu_decode_rd         <= instI_rd;
                            idu_decode_CSRRS      <= '1;
                            end
                    'b011 : begin 
                            idu_decode_csr        <= instI_imm_11_0;
                            idu_decode_rs1        <= instI_rs1;
                            idu_decode_funct3     <= instI_funct3;
                            idu_decode_rd         <= instI_rd;
                            idu_decode_CSRRC      <= '1;
                            end
                    'b101 : begin 
                            idu_decode_csr        <= instI_imm_11_0;
                            idu_decode_uimm       <= instI_rs1;
                            idu_decode_funct3     <= instI_funct3;
                            idu_decode_rd         <= instI_rd;
                            idu_decode_CSRRWI     <= '1;
                            end
                    'b110 : begin 
                            idu_decode_csr        <= instI_imm_11_0;
                            idu_decode_uimm       <= instI_rs1;
                            idu_decode_funct3     <= instI_funct3;
                            idu_decode_rd         <= instI_rd;
                            idu_decode_CSRRSI     <= '1;
                            end
                    'b111 : begin 
                            idu_decode_csr        <= instI_imm_11_0;
                            idu_decode_uimm       <= instI_rs1;
                            idu_decode_funct3     <= instI_funct3;
                            idu_decode_rd         <= instI_rd;
                            idu_decode_CSRRCI     <= '1;
                            end
                    default : begin 
                              idu_decode_TRAP <= '1;
                              end
                endcase
                end

      default : begin 
                idu_decode_TRAP <= '1;
                end
    endcase
    end
  else //ALU is waiting
    begin
    idu_vld <= idu_vld;
    idu_freeze <= idu_freeze;
    idu_inst    <= idu_inst;
    idu_inst_PC <= idu_inst_PC;

    idu_decode_opcode  <= idu_decode_opcode;
    idu_decode_fm      <= idu_decode_fm     ;
    idu_decode_pred    <= idu_decode_pred   ;
    idu_decode_succ    <= idu_decode_succ   ;
    idu_decode_shamt   <= idu_decode_shamt  ;
    idu_decode_imm     <= idu_decode_imm    ;
    idu_decode_uimm    <= idu_decode_uimm   ;
    idu_decode_funct7  <= idu_decode_funct7 ;
    idu_decode_funct3  <= idu_decode_funct3 ;
    idu_decode_rs2     <= idu_decode_rs2    ;
    idu_decode_rs1     <= idu_decode_rs1    ;
    idu_decode_rd      <= idu_decode_rd     ;
                      
    idu_decode_LUI     <= idu_decode_LUI    ;
    idu_decode_AUIPC   <= idu_decode_AUIPC  ;
    idu_decode_JAL     <= idu_decode_JAL    ;
    idu_decode_JALR    <= idu_decode_JALR   ;
    idu_decode_BEQ     <= idu_decode_BEQ    ;
    idu_decode_BNE     <= idu_decode_BNE    ;
    idu_decode_BLT     <= idu_decode_BLT    ;
    idu_decode_BGE     <= idu_decode_BGE    ;
    idu_decode_BLTU    <= idu_decode_BLTU   ;
    idu_decode_BGEU    <= idu_decode_BGEU   ;
    idu_decode_LB      <= idu_decode_LB     ;
    idu_decode_LH      <= idu_decode_LH     ;
    idu_decode_LW      <= idu_decode_LW     ;
    idu_decode_LBU     <= idu_decode_LBU    ;
    idu_decode_LHU     <= idu_decode_LHU    ;
    idu_decode_SB      <= idu_decode_SB     ;
    idu_decode_SH      <= idu_decode_SH     ;
    idu_decode_SW      <= idu_decode_SW     ;
    idu_decode_ADDI    <= idu_decode_ADDI   ;
    idu_decode_SLTI    <= idu_decode_SLTI   ;
    idu_decode_SLTIU   <= idu_decode_SLTIU  ;
    idu_decode_XORI    <= idu_decode_XORI   ;
    idu_decode_ORI     <= idu_decode_ORI    ;
    idu_decode_ANDI    <= idu_decode_ANDI   ;
    idu_decode_SLLI    <= idu_decode_SLLI   ;
    idu_decode_SRLI    <= idu_decode_SRLI   ;
    idu_decode_SRAI    <= idu_decode_SRAI   ;
    idu_decode_ADD     <= idu_decode_ADD    ;
    idu_decode_SUB     <= idu_decode_SUB    ;
    idu_decode_SLL     <= idu_decode_SLL    ;
    idu_decode_SLT     <= idu_decode_SLT    ;
    idu_decode_SLTU    <= idu_decode_SLTU   ;
    idu_decode_XOR     <= idu_decode_XOR    ;
    idu_decode_SRL     <= idu_decode_SRL    ;
    idu_decode_SRA     <= idu_decode_SRA    ;
    idu_decode_OR      <= idu_decode_OR     ;
    idu_decode_AND     <= idu_decode_AND    ;
    idu_decode_FENCE   <= idu_decode_FENCE  ;
    idu_decode_FENCE_I <= idu_decode_FENCE_I;
    idu_decode_ECALL   <= idu_decode_ECALL  ;
    idu_decode_CSRRW   <= idu_decode_CSRRW  ;
    idu_decode_CSRRS   <= idu_decode_CSRRS  ;
    idu_decode_CSRRC   <= idu_decode_CSRRC  ;
    idu_decode_CSRRWI  <= idu_decode_CSRRWI ;
    idu_decode_CSRRSI  <= idu_decode_CSRRSI ;
    idu_decode_CSRRCI  <= idu_decode_CSRRCI ;
    idu_decode_EBREAK  <= idu_decode_EBREAK ;
    idu_decode_MUL     <= idu_decode_MUL    ;
    idu_decode_MULH    <= idu_decode_MULH   ;
    idu_decode_MULHSU  <= idu_decode_MULHSU ;
    idu_decode_MULHU   <= idu_decode_MULHU  ;
    idu_decode_DIV     <= idu_decode_DIV    ;
    idu_decode_DIVU    <= idu_decode_DIVU   ;
    idu_decode_REM     <= idu_decode_REM    ;
    idu_decode_REMU    <= idu_decode_REMU   ;
    idu_decode_TRAP    <= idu_decode_TRAP   ;
    end

  if(rst)
    begin
    idu_vld <= '0;
    idu_freeze <= '0;
    end
  end

endmodule
