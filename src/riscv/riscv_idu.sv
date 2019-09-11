module riscv_idu (
  input  logic        clk,
  input  logic        rst,

  input  logic        ifu_vld,
  input  logic [31:0] ifu_inst,
  output logic [31:0] ifu_inst_PC,
  output logic        idu_vld,
  output logic [31:0] idu_inst_PC,

  output logic        idu_rdy,
  input  logic        idu_req,

  input  logic             alu_vld,
  input  logic             alu_br_miss,

  output logic [31:0] inst,
  output logic  [3:0] fm,
  output logic  [3:0] pred,
  output logic  [3:0] succ,
  output logic  [4:0] shamt,
  output logic [31:0] imm,
  output logic  [4:0] uimm,
  output logic [11:0] csr,
  output logic  [6:0] funct7,
  output logic  [2:0] funct3,
  output logic  [4:0] rs2,
  output logic  [4:0] rs1,
  output logic  [4:0] rd,
  output logic  [6:0] opcode,

  output logic LUI,
  output logic AUIPC,
  output logic JAL,
  output logic JALR,
  output logic BEQ,
  output logic BNE,
  output logic BLT,
  output logic BGE,
  output logic BLTU,
  output logic BGEU,
  output logic LB,
  output logic LH,
  output logic LW,
  output logic LBU,
  output logic LHU,
  output logic SB,
  output logic SH,
  output logic SW,
  output logic ADDI,
  output logic SLTI,
  output logic SLTIU,
  output logic XORI,
  output logic ORI,
  output logic ANDI,
  output logic SLLI,
  output logic SRLI,
  output logic SRAI,
  output logic ADD,
  output logic SUB,
  output logic SLL,
  output logic SLT,
  output logic SLTU,
  output logic XOR,
  output logic SRL,
  output logic SRA,
  output logic OR,
  output logic AND,
  output logic FENCE,
  output logic FENCE_I,
  output logic ECALL,
  output logic CSRRW,
  output logic CSRRS,
  output logic CSRRC,
  output logic CSRRWI,
  output logic CSRRSI,
  output logic CSRRCI,
  output logic EBREAK,
  output logic TRAP
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
  
always_ff @(posedge clk)
  begin
  idu_vld <= ifu_vld;
  if(alu_vld & alu_br_miss)
    idu_vld <= '0;
  inst    <= ifu_inst;
  idu_inst_PC <= ifu_inst_PC;
  opcode  <= ifu_inst[6:0];

  fm      <= '0;
  pred    <= '0;
  succ    <= '0;
  shamt   <= '0;
  imm     <= '0;
  uimm    <= '0;
  funct7  <= '0;
  funct3  <= '0;
  rs2     <= '0;
  rs1     <= '0;
  rd      <= '0;

  LUI     <= '0;
  AUIPC   <= '0;
  JAL     <= '0;
  JALR    <= '0;
  BEQ     <= '0;
  BNE     <= '0;
  BLT     <= '0;
  BGE     <= '0;
  BLTU    <= '0;
  BGEU    <= '0;
  LB      <= '0;
  LH      <= '0;
  LW      <= '0;
  LBU     <= '0;
  LHU     <= '0;
  SB      <= '0;
  SH      <= '0;
  SW      <= '0;
  ADDI    <= '0;
  SLTI    <= '0;
  SLTIU   <= '0;
  XORI    <= '0;
  ORI     <= '0;
  ANDI    <= '0;
  SLLI    <= '0;
  SRLI    <= '0;
  SRAI    <= '0;
  ADD     <= '0;
  SUB     <= '0;
  SLL     <= '0;
  SLT     <= '0;
  SLTU    <= '0;
  XOR     <= '0;
  SRL     <= '0;
  SRA     <= '0;
  OR      <= '0;
  AND     <= '0;
  FENCE   <= '0;
  FENCE_I <= '0;
  ECALL   <= '0;
  CSRRW   <= '0;
  CSRRS   <= '0;
  CSRRC   <= '0;
  CSRRWI  <= '0;
  CSRRSI  <= '0;
  CSRRCI  <= '0;
  EBREAK  <= '0;
  TRAP    <= '0;

  unique
  case (inst_opcode)
    'b0110111 : begin //LUI
                imm[31:12] <= instU_imm_31_12;
                rd         <= instU_rd;
                LUI        <= '1;
                end
    'b0010111 : begin //AUIPC
                imm[31:12] <= instU_imm_31_12;
                rd         <= instU_rd;
                AUIPC      <= '1;
                end
    'b1101111 : begin //JAL
                imm[20]    <= instJ_imm_20;
                imm[10:1]  <= instJ_imm_10_1;
                imm[11]    <= instJ_imm_11;
                imm[19:12] <= instJ_imm_19_12;
                rd         <= instJ_rd;
                JAL        <= '1;
                end
    'b1100111 : begin 
                case (instB_funct3)
                  'b000 : begin //JALR
                          imm[11:0]  <= instI_imm_11_0;
                          rs1        <= instI_rs1;
                          funct3     <= instI_funct3;
                          rd         <= instI_rd;
                          JALR       <= '1;
                          end
                  default : begin 
                            TRAP <= '1;
                            end
                endcase
                end
    'b1100011 : begin 
                unique
                case (instB_funct3)
                  'b000 : begin //BEQ
                          imm[12]    <= instB_imm_12;
                          imm[10:5]  <= instB_imm_10_5;
                          rs2        <= instB_rs2;
                          rs1        <= instB_rs1;
                          funct3     <= instB_funct3;
                          imm[4:1]   <= instB_imm_4_1;
                          imm[11]    <= instB_imm_11;
			  BEQ        <= '1;
                          end
                  'b001 : begin //BNE
                          imm[12]    <= instB_imm_12;
                          imm[10:5]  <= instB_imm_10_5;
                          rs2        <= instB_rs2;
                          rs1        <= instB_rs1;
                          funct3     <= instB_funct3;
                          imm[4:1]   <= instB_imm_4_1;
                          imm[11]    <= instB_imm_11;
                          BNE        <= '1;
                          end
                  'b100 : begin //BLT
                          imm[12]    <= instB_imm_12;
                          imm[10:5]  <= instB_imm_10_5;
                          rs2        <= instB_rs2;
                          rs1        <= instB_rs1;
                          funct3     <= instB_funct3;
                          imm[4:1]   <= instB_imm_4_1;
                          imm[11]    <= instB_imm_11;
                          BLT        <= '1;
                          end
                  'b101 : begin //BGE
                          imm[12]    <= instB_imm_12;
                          imm[10:5]  <= instB_imm_10_5;
                          rs2        <= instB_rs2;
                          rs1        <= instB_rs1;
                          funct3     <= instB_funct3;
                          imm[4:1]   <= instB_imm_4_1;
                          imm[11]    <= instB_imm_11;
                          BGE        <= '1;
                          end
                  'b110 : begin //BLTU
                          imm[12]    <= instB_imm_12;
                          imm[10:5]  <= instB_imm_10_5;
                          rs2        <= instB_rs2;
                          rs1        <= instB_rs1;
                          funct3     <= instB_funct3;
                          imm[4:1]   <= instB_imm_4_1;
                          imm[11]    <= instB_imm_11;
                          BLTU       <= '1;
                          end
                  'b111 : begin //BGEU
                          imm[12]    <= instB_imm_12;
                          imm[10:5]  <= instB_imm_10_5;
                          rs2        <= instB_rs2;
                          rs1        <= instB_rs1;
                          funct3     <= instB_funct3;
                          imm[4:1]   <= instB_imm_4_1;
                          imm[11]    <= instB_imm_11;
                          BGEU       <= '1;
                          end
                  default : begin 
                            TRAP <= '1;
                            end
                endcase
                end
    'b0000011 : begin     
                unique
                case (instI_funct3)
                  'b000 : begin //LB
                          imm[11:0]  <= instI_imm_11_0;
                          rs1        <= instI_rs1;
                          funct3     <= instI_funct3;
                          rd         <= instI_rd;
                          LB         <= '1;
                          end
                  'b001 : begin //LH
                          imm[11:0]  <= instI_imm_11_0;
                          rs1        <= instI_rs1;
                          funct3     <= instI_funct3;
                          rd         <= instI_rd;
                          LH         <= '1;
                          end
                  'b010 : begin //LW
                          imm[11:0]  <= instI_imm_11_0;
                          rs1        <= instI_rs1;
                          funct3     <= instI_funct3;
                          rd         <= instI_rd;
                          LW         <= '1;
                          end
                  'b100 : begin //LBU
                          imm[11:0]  <= instI_imm_11_0;
                          rs1        <= instI_rs1;
                          funct3     <= instI_funct3;
                          rd         <= instI_rd;
                          LBU        <= '1;
                          end
                  'b101 : begin //LHU
                          imm[11:0]  <= instI_imm_11_0;
                          rs1        <= instI_rs1;
                          funct3     <= instI_funct3;
                          rd         <= instI_rd;
                          LHU        <= '1;
                          end
                  default : begin 
                            TRAP <= '1;
                            end
                endcase
                end
    'b0100011 : begin 
                unique
                case (instS_funct3)
                  'b000 : begin //SB
                          imm[11:5]  <= instS_imm_11_5;
                          rs2        <= instS_rs2;
                          rs1        <= instS_rs1;
                          funct3     <= instS_funct3;
                          imm[4:0]   <= instS_imm_4_0;
                          SB         <= '1;
                          end
                  'b001 : begin //SH
                          imm[11:5]  <= instS_imm_11_5;
                          rs2        <= instS_rs2;
                          rs1        <= instS_rs1;
                          funct3     <= instS_funct3;
                          imm[4:0]   <= instS_imm_4_0;
                          SH         <= '1;
                          end
                  'b010 : begin //SW
                          imm[11:5]  <= instS_imm_11_5;
                          rs2        <= instS_rs2;
                          rs1        <= instS_rs1;
                          funct3     <= instS_funct3;
                          imm[4:0]   <= instS_imm_4_0;
                          SW         <= '1;
                          end
                  default : begin 
                            TRAP <= '1;
                            end
                endcase
                end
    'b0010011 : begin 
                unique
                case (instI_funct3)
                  'b000 : begin //ADDI
                          imm[11:0]  <= instI_imm_11_0;
                          rs1        <= instI_rs1;
                          funct3     <= instI_funct3;
                          rd         <= instI_rd;
                          ADDI       <= '1;
                          end
                  'b010 : begin //SLTI
                          imm[11:0]  <= instI_imm_11_0;
                          rs1        <= instI_rs1;
                          funct3     <= instI_funct3;
                          rd         <= instI_rd;
                          SLTI       <= '1;
                          end
                  'b011 : begin //SLTIU
                          imm[11:0]  <= instI_imm_11_0;
                          rs1        <= instI_rs1;
                          funct3     <= instI_funct3;
                          rd         <= instI_rd;
                          SLTIU      <= '1;
                          end
                  'b100 : begin //XORI
                          imm[11:0]  <= instI_imm_11_0;
                          rs1        <= instI_rs1;
                          funct3     <= instI_funct3;
                          rd         <= instI_rd;
                          XORI       <= '1;
                          end
                  'b110 : begin //ORI
                          imm[11:0]  <= instI_imm_11_0;
                          rs1        <= instI_rs1;
                          funct3     <= instI_funct3;
                          rd         <= instI_rd;
                          ORI        <= '1;
                          end
                  'b111 : begin //ANDI
                          imm[11:0]  <= instI_imm_11_0;
                          rs1        <= instI_rs1;
                          funct3     <= instI_funct3;
                          rd         <= instI_rd;
                          ANDI       <= '1;
                          end
                  'b001 : begin 
                          case (instR_funct7)
                            'b0000000 : begin //SLLI
                                        funct7     <= instR_funct7;  
                                        shamt      <= instR_rs2;
                                        rs1        <= instR_rs1;
                                        funct3     <= instR_funct3;
                                        rd         <= instR_rd;
                                        SLLI       <= '1;
                                        end
                            default : begin 
                                      TRAP <= '1;
                                      end
                          endcase
                          end
                  'b101 : begin 
                          unique
                          case (instR_funct7)
                            'b0000000 : begin //SRLI
                                        funct7     <= instR_funct7;  
                                        shamt      <= instR_rs2;
                                        rs1        <= instR_rs1;
                                        funct3     <= instR_funct3;
                                        rd         <= instR_rd;
                                        SRLI       <= '1;
                                        end
                            'b0100000 : begin //SRAI
                                        funct7     <= instR_funct7;  
                                        shamt      <= instR_rs2;
                                        rs1        <= instR_rs1;
                                        funct3     <= instR_funct3;
                                        rd         <= instR_rd;
                                        SRAI       <= '1;
                                        end
                            default : begin 
                                      TRAP <= '1;
                                      end
                          endcase
                          end
                  default : begin 
                            TRAP <= '1;
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
                                        funct7     <= instR_funct7;  
                                        rs2        <= instR_rs2;
                                        rs1        <= instR_rs1;
                                        funct3     <= instR_funct3;
                                        rd         <= instR_rd;
                                        ADD        <= '1;
                                        end
                            'b0100000 : begin //SUB
                                        funct7     <= instR_funct7;  
                                        rs2        <= instR_rs2;
                                        rs1        <= instR_rs1;
                                        funct3     <= instR_funct3;
                                        rd         <= instR_rd;
                                        SUB        <= '1;
                                        end
                            default : begin 
                                      TRAP <= '1;
                                      end
                          endcase
                          end
                  'b001 : begin 
                          unique
                          case (instR_funct7)
                            'b0000000 : begin //SLL
                                        funct7     <= instR_funct7;  
                                        rs2        <= instR_rs2;
                                        rs1        <= instR_rs1;
                                        funct3     <= instR_funct3;
                                        rd         <= instR_rd;
                                        SLL        <= '1;
                                        end
                            default : begin 
                                      TRAP <= '1;
                                      end
                          endcase
                          end
                  'b010 : begin 
                          unique
                          case (instR_funct7)
                            'b0000000 : begin //SLT
                                        funct7     <= instR_funct7;  
                                        rs2        <= instR_rs2;
                                        rs1        <= instR_rs1;
                                        funct3     <= instR_funct3;
                                        rd         <= instR_rd;
                                        SLT        <= '1;
                                        end
                            default : begin 
                                      TRAP <= '1;
                                      end
                          endcase
                          end
                  'b011 : begin 
                          unique
                          case (instR_funct7)
                            'b0000000 : begin //SLTU
                                        funct7     <= instR_funct7;  
                                        rs2        <= instR_rs2;
                                        rs1        <= instR_rs1;
                                        funct3     <= instR_funct3;
                                        rd         <= instR_rd;
                                        SLTU       <= '1;
                                        end
                            default : begin 
                                      TRAP <= '1;
                                      end
                          endcase
                          end
                  'b100 : begin 
                          unique
                          case (instR_funct7)
                            'b0000000 : begin //XOR
                                        funct7     <= instR_funct7;  
                                        rs2        <= instR_rs2;
                                        rs1        <= instR_rs1;
                                        funct3     <= instR_funct3;
                                        rd         <= instR_rd;
                                        XOR        <= '1;
                                        end
                            default : begin 
                                      TRAP <= '1;
                                      end
                          endcase
                          end
                  'b101 : begin 
                          unique
                          case (instR_funct7)
                            'b0000000 : begin //SRL
                                        funct7     <= instR_funct7;  
                                        rs2        <= instR_rs2;
                                        rs1        <= instR_rs1;
                                        funct3     <= instR_funct3;
                                        rd         <= instR_rd;
                                        SRL        <= '1;
                                        end
                            'b0100000 : begin //SRA
                                        funct7     <= instR_funct7;  
                                        rs2        <= instR_rs2;
                                        rs1        <= instR_rs1;
                                        funct3     <= instR_funct3;
                                        rd         <= instR_rd;
                                        SRA        <= '1;
                                        end
                            default : begin 
                                      TRAP <= '1;
                                      end
                          endcase
                          end
                  'b110 : begin 
                          unique
                          case (instR_funct7)
                            'b0000000 : begin //OR
                                        funct7     <= instR_funct7;  
                                        rs2        <= instR_rs2;
                                        rs1        <= instR_rs1;
                                        funct3     <= instR_funct3;
                                        rd         <= instR_rd;
                                        OR         <= '1;
                                        end
                            default : begin 
                                      TRAP <= '1;
                                      end
                          endcase
                          end
                  'b111 : begin 
                          unique
                          case (instR_funct7)
                            'b0000000 : begin //AND
                                        funct7     <= instR_funct7;  
                                        rs2        <= instR_rs2;
                                        rs1        <= instR_rs1;
                                        funct3     <= instR_funct3;
                                        rd         <= instR_rd;
                                        AND        <= '1;
                                        end
                            default : begin 
                                      TRAP <= '1;
                                      end
                          endcase
                          end
                  default : begin 
                            TRAP <= '1;
                            end
                endcase
                end
    'b0001111 : begin //FENCE
                {fm,pred,succ} <= instI_imm_11_0;
                rs1            <= instI_rs1;
                funct3         <= instI_funct3;
                rd             <= instI_rd;
                FENCE      <= '1;
                end
    'b1110011 : begin 
                unique
                case (instI_funct3)
                  'b000 : begin 
                          unique
                          case (instI_imm_11_0)
                            'b000000000000 : begin //ECALL
                                             ECALL      <= '1;
                                             end
                            'b000000000001 : begin //EBREAK
                                             EBREAK     <= '1;
                                             end
                            default : begin 
                                      TRAP <= '1;
                                      end
                          endcase
                          end
                  'b001 : begin 
                          csr        <= instI_imm_11_0;
                          rs1        <= instI_rs1;
                          funct3     <= instI_funct3;
                          rd         <= instI_rd;
                          CSRRW      <= '1;
                          end
                  'b010 : begin 
                          csr        <= instI_imm_11_0;
                          rs1        <= instI_rs1;
                          funct3     <= instI_funct3;
                          rd         <= instI_rd;
                          CSRRS      <= '1;
                          end
                  'b011 : begin 
                          csr        <= instI_imm_11_0;
                          rs1        <= instI_rs1;
                          funct3     <= instI_funct3;
                          rd         <= instI_rd;
                          CSRRC      <= '1;
                          end
                  'b101 : begin 
                          csr        <= instI_imm_11_0;
                          uimm       <= instI_rs1;
                          funct3     <= instI_funct3;
                          rd         <= instI_rd;
                          CSRRWI     <= '1;
                          end
                  'b110 : begin 
                          csr        <= instI_imm_11_0;
                          uimm       <= instI_rs1;
                          funct3     <= instI_funct3;
                          rd         <= instI_rd;
                          CSRRSI     <= '1;
                          end
                  'b111 : begin 
                          csr        <= instI_imm_11_0;
                          uimm       <= instI_rs1;
                          funct3     <= instI_funct3;
                          rd         <= instI_rd;
                          CSRRCI     <= '1;
                          end
                  default : begin 
                            TRAP <= '1;
                            end
              endcase
              end
    default : begin 
              TRAP <= '1;
              end
  endcase
  if(rst)
    begin
    idu_vld <= '0;
    end
  end

endmodule
