import riscv_pkg::*;

module riscv_idu (
  input  logic        clk,
  input  logic        rst,

  output logic        idu_rdy,
  input  logic        idu_req,
  input  logic [31:0] idu_inst,
  output logic        idu_done,

  output logic  [3:0] fm,
  output logic  [3:0] pred,
  output logic  [3:0] succ,
  output logic  [4:0] shamt,
  output logic [31:0] imm,
  output logic  [6:0] funct7,
  output logic  [2:0] funct3,
  output logic  [4:0] rs2,
  output logic  [4:0] rs1,
  output logic  [4:0] rd,
  output logic  [6:0] opcode,

  output logic  [1:0] dbg_led

);
typedef struct packed {
  logic  [6:0] funct7;
  logic  [4:0] rs2;
  logic  [4:0] rs1;
  logic  [2:0] funct3;
  logic  [4:0] rd;
  logic  [6:0] opcode;
} inst_RType_s;
typedef struct packed {
  logic [11:0] imm_11_0;
  logic  [4:0] rs1;
  logic  [2:0] funct3;
  logic  [4:0] rd;
  logic  [6:0] opcode;
} inst_IType_s;
typedef struct packed {
  logic  [6:0] imm_11_5;
  logic  [4:0] rs2;
  logic  [4:0] rs1;
  logic  [2:0] funct3;
  logic  [4:0] imm_4_0;
  logic  [6:0] opcode;
} inst_SType_s;
typedef struct packed {
  logic        imm_12;
  logic  [5:0] imm_10_5;
  logic  [4:0] rs2;
  logic  [4:0] rs1;
  logic  [2:0] funct3;
  logic  [3:0] imm_4_1;
  logic        imm_11;
  logic  [6:0] opcode;
} inst_BType_s;
typedef struct packed {
  logic [19:0] imm_31_12;
  logic  [4:0] rd;
  logic  [6:0] opcode;
} inst_UType_s;
typedef struct packed {
  logic        imm_20;
  logic  [9:0] imm_10_1;
  logic        imm_11;
  logic  [7:0] imm_19_12;
  logic  [4:0] rd;
  logic  [6:0] opcode;
} inst_JType_s;

typedef enum {
  IDLE,
  DECODE
} idu_state_e;
idu_state_e idu_state;

logic [31:0] inst;
always_ff @(posedge clk)
  begin
  idu_state <= idu_state;
  idu_rdy  <= idu_rdy;
  idu_done <= '0;
  inst <= inst;
  case (idu_state)
    IDLE : begin
           if(idu_req)
             begin
						 idu_state <= DECODE;
					   inst <= idu_inst;
             idu_rdy <= '0;
             end
           end
    DECODE : begin
           idu_state <= IDLE;
           idu_rdy <= '1;
           idu_done <= '1;
           end
  endcase
  if(rst)
    begin
    idu_state <= IDLE;
		inst <= '0;
    idu_rdy <= '1;
    end
  end

  
logic [6:0]  inst_opcode;
inst_RType_s inst_R;
inst_IType_s inst_I;
inst_SType_s inst_S;
inst_BType_s inst_B;
inst_UType_s inst_U;
inst_JType_s inst_J;
always_comb
  begin
  inst_opcode = inst[6:0];
  inst_R = inst;
  inst_I = inst;
  inst_S = inst;
  inst_B = inst;
  inst_U = inst;
  inst_J = inst;

  fm     = '0;
  pred   = '0;
  succ   = '0;
  shamt  = '0;
  imm    = '0;
  funct7 = '0;
  funct3 = '0;
  rs2    = '0;
  rs1    = '0;
  rd     = '0;
  opcode = inst_opcode;
  case (inst_opcode)
    'b0110111 : begin //LUI
                imm[31:12] = inst_U.imm_31_12;
                rd         = inst_U.rd;
                end
    'b0010111 : begin //AUIPC
                imm[31:12] = inst_U.imm_31_12;
                rd         = inst_U.rd;
                end
    'b1101111 : begin //JAL
                imm[20]    = inst_J.imm_20;
                imm[10:1]  = inst_J.imm_10_1;
                imm[11]    = inst_J.imm_11;
                imm[19:12] = inst_J.imm_19_12;
                rd         = inst_J.rd;
                end
    'b1100111 : begin //JALR
                imm[11:0]  = inst_I.imm_11_0;
                rs1        = inst_I.rs1;
                funct3     = inst_I.funct3;
                rd         = inst_I.rd;
                end
    'b1100111 : begin 
                case (inst_B.funct3)
                  'b000 : begin //BEQ
                          imm[12]    = inst_B.imm_12;
                          imm[10:5]  = inst_B.imm_10_5;
                          rs2        = inst_B.rs2;
                          rs1        = inst_B.rs1;
                          funct3     = inst_B.funct3;
                          imm[4:1]   = inst_B.imm_4_1;
                          imm[11]    = inst_B.imm_11;
                          end
                  'b001 : begin //BNE
                          imm[12]    = inst_B.imm_12;
                          imm[10:5]  = inst_B.imm_10_5;
                          rs2        = inst_B.rs2;
                          rs1        = inst_B.rs1;
                          funct3     = inst_B.funct3;
                          imm[4:1]   = inst_B.imm_4_1;
                          imm[11]    = inst_B.imm_11;
                          end
                  'b100 : begin //BLT
                          imm[12]    = inst_B.imm_12;
                          imm[10:5]  = inst_B.imm_10_5;
                          rs2        = inst_B.rs2;
                          rs1        = inst_B.rs1;
                          funct3     = inst_B.funct3;
                          imm[4:1]   = inst_B.imm_4_1;
                          imm[11]    = inst_B.imm_11;
                          end
                  'b101 : begin //BGE
                          imm[12]    = inst_B.imm_12;
                          imm[10:5]  = inst_B.imm_10_5;
                          rs2        = inst_B.rs2;
                          rs1        = inst_B.rs1;
                          funct3     = inst_B.funct3;
                          imm[4:1]   = inst_B.imm_4_1;
                          imm[11]    = inst_B.imm_11;
                          end
                  'b110 : begin //BLTU
                          imm[12]    = inst_B.imm_12;
                          imm[10:5]  = inst_B.imm_10_5;
                          rs2        = inst_B.rs2;
                          rs1        = inst_B.rs1;
                          funct3     = inst_B.funct3;
                          imm[4:1]   = inst_B.imm_4_1;
                          imm[11]    = inst_B.imm_11;
                          end
                  'b111 : begin //BGEU
                          imm[12]    = inst_B.imm_12;
                          imm[10:5]  = inst_B.imm_10_5;
                          rs2        = inst_B.rs2;
                          rs1        = inst_B.rs1;
                          funct3     = inst_B.funct3;
                          imm[4:1]   = inst_B.imm_4_1;
                          imm[11]    = inst_B.imm_11;
                          end
                endcase
                end
    'b0000011 : begin     
                case (inst_I.funct3)
                  'b000 : begin //LB
                          imm[11:0]  = inst_I.imm_11_0;
                          rs1        = inst_I.rs1;
                          funct3     = inst_I.funct3;
                          rd         = inst_I.rd;
                          end
                  'b000 : begin //LH
                          imm[11:0]  = inst_I.imm_11_0;
                          rs1        = inst_I.rs1;
                          funct3     = inst_I.funct3;
                          rd         = inst_I.rd;
                          end
                  'b000 : begin //LW
                          imm[11:0]  = inst_I.imm_11_0;
                          rs1        = inst_I.rs1;
                          funct3     = inst_I.funct3;
                          rd         = inst_I.rd;
                          end
                  'b000 : begin //LBU
                          imm[11:0]  = inst_I.imm_11_0;
                          rs1        = inst_I.rs1;
                          funct3     = inst_I.funct3;
                          rd         = inst_I.rd;
                          end
                  'b000 : begin //LHU
                          imm[11:0]  = inst_I.imm_11_0;
                          rs1        = inst_I.rs1;
                          funct3     = inst_I.funct3;
                          rd         = inst_I.rd;
                          end
                endcase
                end
    'b0100011 : begin 
                case (inst_S.funct3)
                  'b000 : begin //SB
                          imm[11:5]  = inst_S.imm_11_5;
                          rs2        = inst_S.rs2;
                          rs1        = inst_S.rs1;
                          funct3     = inst_S.funct3;
                          imm[4:0]   = inst_S.imm_4_0;
                          end
                  'b001 : begin //SH
                          imm[11:5]  = inst_S.imm_11_5;
                          rs2        = inst_S.rs2;
                          rs1        = inst_S.rs1;
                          funct3     = inst_S.funct3;
                          imm[4:0]   = inst_S.imm_4_0;
                          end
                  'b010 : begin //SW
                          imm[11:5]  = inst_S.imm_11_5;
                          rs2        = inst_S.rs2;
                          rs1        = inst_S.rs1;
                          funct3     = inst_S.funct3;
                          imm[4:0]   = inst_S.imm_4_0;
                          end
                endcase
                end
    'b0010011 : begin 
                case (inst_I.funct3)
                  'b000 : begin //ADDI
                          imm[11:0]  = inst_I.imm_11_0;
                          rs1        = inst_I.rs1;
                          funct3     = inst_I.funct3;
                          rd         = inst_I.rd;
                          end
                  'b010 : begin //SLTI
                          imm[11:0]  = inst_I.imm_11_0;
                          rs1        = inst_I.rs1;
                          funct3     = inst_I.funct3;
                          rd         = inst_I.rd;
                          end
                  'b011 : begin //SLTIU
                          imm[11:0]  = inst_I.imm_11_0;
                          rs1        = inst_I.rs1;
                          funct3     = inst_I.funct3;
                          rd         = inst_I.rd;
                          end
                  'b100 : begin //XORI
                          imm[11:0]  = inst_I.imm_11_0;
                          rs1        = inst_I.rs1;
                          funct3     = inst_I.funct3;
                          rd         = inst_I.rd;
                          end
                  'b110 : begin //ORI
                          imm[11:0]  = inst_I.imm_11_0;
                          rs1        = inst_I.rs1;
                          funct3     = inst_I.funct3;
                          rd         = inst_I.rd;
                          end
                  'b111 : begin //ANDI
                          imm[11:0]  = inst_I.imm_11_0;
                          rs1        = inst_I.rs1;
                          funct3     = inst_I.funct3;
                          rd         = inst_I.rd;
                          end
                  'b001 : begin //SLLI
                          funct7     = inst_R.funct7;  
                          shamt      = inst_R.rs2;
                          rs1        = inst_R.rs1;
                          funct3     = inst_R.funct3;
                          rd         = inst_R.rd;
                          end
                  'b101 : begin 
                          case (inst_R.funct7)
                            'b0000000 : begin //SRLI
                                        funct7     = inst_R.funct7;  
                                        shamt      = inst_R.rs2;
                                        rs1        = inst_R.rs1;
                                        funct3     = inst_R.funct3;
                                        rd         = inst_R.rd;
                                        end
                            'b0100000 : begin //SRAI
                                        funct7     = inst_R.funct7;  
                                        shamt      = inst_R.rs2;
                                        rs1        = inst_R.rs1;
                                        funct3     = inst_R.funct3;
                                        rd         = inst_R.rd;
                                        end
                          endcase
                          end
                endcase
                end
    'b0110011 : begin 
                case (inst_R.funct3)
                  'b000 : begin 
                          case (inst_R.funct7)
                            'b0000000 : begin //ADD
                                        funct7     = inst_R.funct7;  
                                        rs2        = inst_R.rs2;
                                        rs1        = inst_R.rs1;
                                        funct3     = inst_R.funct3;
                                        rd         = inst_R.rd;
                                        end
                            'b0100000 : begin //SUB
                                        funct7     = inst_R.funct7;  
                                        rs2        = inst_R.rs2;
                                        rs1        = inst_R.rs1;
                                        funct3     = inst_R.funct3;
                                        rd         = inst_R.rd;
                                        end
                          endcase
                          end
                  'b001 : begin //SLL
                          funct7     = inst_R.funct7;  
                          rs2        = inst_R.rs2;
                          rs1        = inst_R.rs1;
                          funct3     = inst_R.funct3;
                          rd         = inst_R.rd;
                          end
                  'b010 : begin //SLT
                          funct7     = inst_R.funct7;  
                          rs2        = inst_R.rs2;
                          rs1        = inst_R.rs1;
                          funct3     = inst_R.funct3;
                          rd         = inst_R.rd;
                          end
                  'b011 : begin //SLTU
                          funct7     = inst_R.funct7;  
                          rs2        = inst_R.rs2;
                          rs1        = inst_R.rs1;
                          funct3     = inst_R.funct3;
                          rd         = inst_R.rd;
                          end
                  'b100 : begin //XOR
                          funct7     = inst_R.funct7;  
                          rs2        = inst_R.rs2;
                          rs1        = inst_R.rs1;
                          funct3     = inst_R.funct3;
                          rd         = inst_R.rd;
                          end
                  'b101 : begin 
                          case (inst_R.funct7)
                            'b0000000 : begin //SRL
                                        funct7     = inst_R.funct7;  
                                        rs2        = inst_R.rs2;
                                        rs1        = inst_R.rs1;
                                        funct3     = inst_R.funct3;
                                        rd         = inst_R.rd;
                                        end
                            'b0100000 : begin //SRA
                                        funct7     = inst_R.funct7;  
                                        rs2        = inst_R.rs2;
                                        rs1        = inst_R.rs1;
                                        funct3     = inst_R.funct3;
                                        rd         = inst_R.rd;
                                        end
                          endcase
                          end
                  'b110 : begin //OR
                          funct7     = inst_R.funct7;  
                          rs2        = inst_R.rs2;
                          rs1        = inst_R.rs1;
                          funct3     = inst_R.funct3;
                          rd         = inst_R.rd;
                          end
                  'b101 : begin //AND
                          funct7     = inst_R.funct7;  
                          rs2        = inst_R.rs2;
                          rs1        = inst_R.rs1;
                          funct3     = inst_R.funct3;
                          rd         = inst_R.rd;
                          end
                endcase
                end
    'b0001111 : begin //FENCE
                {fm,pred,succ} = inst_I.imm_11_0;
                rs1            = inst_I.rs1;
                funct3         = inst_I.funct3;
                rd             = inst_I.rd;
                end
    'b1110011 : begin //ECALL
                end
    'b1110011 : begin //EBREAK
                end
  endcase
  end



always_comb
  begin
  dbg_led[0] = inst[0];
  dbg_led[1] = inst[1];
  end

endmodule
