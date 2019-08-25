import riscv_pkg::*;

module riscv_idu (
  input  logic        clk,
  input  logic        rst,

  input  logic        ifu_vld,
  input  logic [31:0] ifu_inst,
  output logic        idu_vld,

  output logic        idu_rdy,
  input  logic        idu_req,

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
  output logic EBREAK,

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

  
inst_RType_s inst_R;
inst_IType_s inst_I;
inst_SType_s inst_S;
inst_BType_s inst_B;
inst_UType_s inst_U;
inst_JType_s inst_J;
assign  inst_R  = ifu_inst;
assign  inst_I  = ifu_inst;
assign  inst_S  = ifu_inst;
assign  inst_B  = ifu_inst;
assign  inst_U  = ifu_inst;
assign  inst_J  = ifu_inst;

always_ff @(posedge clk)
  begin
  idu_vld     <= ifu_vld;
  opcode <= ifu_inst[6:0];

  fm      <= '0;
  pred    <= '0;
  succ    <= '0;
  shamt   <= '0;
  imm     <= '0;
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
	EBREAK  <= '0;
  case (ifu_inst[6:0])
    'b0110111 : begin //LUI
                imm[31:12] <= inst_U.imm_31_12;
                rd         <= inst_U.rd;
                LUI        <= '1;
                end
    'b0010111 : begin //AUIPC
                imm[31:12] <= inst_U.imm_31_12;
                rd         <= inst_U.rd;
                AUIPC      <= '1;
                end
    'b1101111 : begin //JAL
                imm[20]    <= inst_J.imm_20;
                imm[10:1]  <= inst_J.imm_10_1;
                imm[11]    <= inst_J.imm_11;
                imm[19:12] <= inst_J.imm_19_12;
                rd         <= inst_J.rd;
                JAL        <= '1;
                end
    'b1100111 : begin //JALR
                imm[11:0]  <= inst_I.imm_11_0;
                rs1        <= inst_I.rs1;
                funct3     <= inst_I.funct3;
                rd         <= inst_I.rd;
                JALR       <= '1;
                end
    'b1100011 : begin 
                case (inst_B.funct3)
                  'b000 : begin //BEQ
                          imm[12]    <= inst_B.imm_12;
                          imm[10:5]  <= inst_B.imm_10_5;
                          rs2        <= inst_B.rs2;
                          rs1        <= inst_B.rs1;
                          funct3     <= inst_B.funct3;
                          imm[4:1]   <= inst_B.imm_4_1;
                          imm[11]    <= inst_B.imm_11;
			  BEQ        <= '1;
                          end
                  'b001 : begin //BNE
                          imm[12]    <= inst_B.imm_12;
                          imm[10:5]  <= inst_B.imm_10_5;
                          rs2        <= inst_B.rs2;
                          rs1        <= inst_B.rs1;
                          funct3     <= inst_B.funct3;
                          imm[4:1]   <= inst_B.imm_4_1;
                          imm[11]    <= inst_B.imm_11;
                          BNE        <= '1;
                          end
                  'b100 : begin //BLT
                          imm[12]    <= inst_B.imm_12;
                          imm[10:5]  <= inst_B.imm_10_5;
                          rs2        <= inst_B.rs2;
                          rs1        <= inst_B.rs1;
                          funct3     <= inst_B.funct3;
                          imm[4:1]   <= inst_B.imm_4_1;
                          imm[11]    <= inst_B.imm_11;
                          BLT        <= '1;
                          end
                  'b101 : begin //BGE
                          imm[12]    <= inst_B.imm_12;
                          imm[10:5]  <= inst_B.imm_10_5;
                          rs2        <= inst_B.rs2;
                          rs1        <= inst_B.rs1;
                          funct3     <= inst_B.funct3;
                          imm[4:1]   <= inst_B.imm_4_1;
                          imm[11]    <= inst_B.imm_11;
                          BGE        <= '1;
                          end
                  'b110 : begin //BLTU
                          imm[12]    <= inst_B.imm_12;
                          imm[10:5]  <= inst_B.imm_10_5;
                          rs2        <= inst_B.rs2;
                          rs1        <= inst_B.rs1;
                          funct3     <= inst_B.funct3;
                          imm[4:1]   <= inst_B.imm_4_1;
                          imm[11]    <= inst_B.imm_11;
                          BLTU       <= '1;
                          end
                  'b111 : begin //BGEU
                          imm[12]    <= inst_B.imm_12;
                          imm[10:5]  <= inst_B.imm_10_5;
                          rs2        <= inst_B.rs2;
                          rs1        <= inst_B.rs1;
                          funct3     <= inst_B.funct3;
                          imm[4:1]   <= inst_B.imm_4_1;
                          imm[11]    <= inst_B.imm_11;
                          BGEU       <= '1;
                          end
                endcase
                end
    'b0000011 : begin     
                case (inst_I.funct3)
                  'b000 : begin //LB
                          imm[11:0]  <= inst_I.imm_11_0;
                          rs1        <= inst_I.rs1;
                          funct3     <= inst_I.funct3;
                          rd         <= inst_I.rd;
                          LB         <= '1;
                          end
                  'b001 : begin //LH
                          imm[11:0]  <= inst_I.imm_11_0;
                          rs1        <= inst_I.rs1;
                          funct3     <= inst_I.funct3;
                          rd         <= inst_I.rd;
                          LH         <= '1;
                          end
                  'b010 : begin //LW
                          imm[11:0]  <= inst_I.imm_11_0;
                          rs1        <= inst_I.rs1;
                          funct3     <= inst_I.funct3;
                          rd         <= inst_I.rd;
                          LW         <= '1;
                          end
                  'b100 : begin //LBU
                          imm[11:0]  <= inst_I.imm_11_0;
                          rs1        <= inst_I.rs1;
                          funct3     <= inst_I.funct3;
                          rd         <= inst_I.rd;
                          LBU        <= '1;
                          end
                  'b101 : begin //LHU
                          imm[11:0]  <= inst_I.imm_11_0;
                          rs1        <= inst_I.rs1;
                          funct3     <= inst_I.funct3;
                          rd         <= inst_I.rd;
                          LHU        <= '1;
                          end
                endcase
                end
    'b0100011 : begin 
                case (inst_S.funct3)
                  'b000 : begin //SB
                          imm[11:5]  <= inst_S.imm_11_5;
                          rs2        <= inst_S.rs2;
                          rs1        <= inst_S.rs1;
                          funct3     <= inst_S.funct3;
                          imm[4:0]   <= inst_S.imm_4_0;
                          SB         <= '1;
                          end
                  'b001 : begin //SH
                          imm[11:5]  <= inst_S.imm_11_5;
                          rs2        <= inst_S.rs2;
                          rs1        <= inst_S.rs1;
                          funct3     <= inst_S.funct3;
                          imm[4:0]   <= inst_S.imm_4_0;
                          SH         <= '1;
                          end
                  'b010 : begin //SW
                          imm[11:5]  <= inst_S.imm_11_5;
                          rs2        <= inst_S.rs2;
                          rs1        <= inst_S.rs1;
                          funct3     <= inst_S.funct3;
                          imm[4:0]   <= inst_S.imm_4_0;
                          SW         <= '1;
                          end
                endcase
                end
    'b0010011 : begin 
                case (inst_I.funct3)
                  'b000 : begin //ADDI
                          imm[11:0]  <= inst_I.imm_11_0;
                          rs1        <= inst_I.rs1;
                          funct3     <= inst_I.funct3;
                          rd         <= inst_I.rd;
                          ADDI       <= '1;
                          end
                  'b010 : begin //SLTI
                          imm[11:0]  <= inst_I.imm_11_0;
                          rs1        <= inst_I.rs1;
                          funct3     <= inst_I.funct3;
                          rd         <= inst_I.rd;
                          SLTI       <= '1;
                          end
                  'b011 : begin //SLTIU
                          imm[11:0]  <= inst_I.imm_11_0;
                          rs1        <= inst_I.rs1;
                          funct3     <= inst_I.funct3;
                          rd         <= inst_I.rd;
                          SLTIU      <= '1;
                          end
                  'b100 : begin //XORI
                          imm[11:0]  <= inst_I.imm_11_0;
                          rs1        <= inst_I.rs1;
                          funct3     <= inst_I.funct3;
                          rd         <= inst_I.rd;
                          XORI       <= '1;
                          end
                  'b110 : begin //ORI
                          imm[11:0]  <= inst_I.imm_11_0;
                          rs1        <= inst_I.rs1;
                          funct3     <= inst_I.funct3;
                          rd         <= inst_I.rd;
                          ORI        <= '1;
                          end
                  'b111 : begin //ANDI
                          imm[11:0]  <= inst_I.imm_11_0;
                          rs1        <= inst_I.rs1;
                          funct3     <= inst_I.funct3;
                          rd         <= inst_I.rd;
                          ANDI       <= '1;
                          end
                  'b001 : begin //SLLI
                          funct7     <= inst_R.funct7;  
                          shamt      <= inst_R.rs2;
                          rs1        <= inst_R.rs1;
                          funct3     <= inst_R.funct3;
                          rd         <= inst_R.rd;
                          SLLI       <= '1;
                          end
                  'b101 : begin 
                          case (inst_R.funct7)
                            'b0000000 : begin //SRLI
                                        funct7     <= inst_R.funct7;  
                                        shamt      <= inst_R.rs2;
                                        rs1        <= inst_R.rs1;
                                        funct3     <= inst_R.funct3;
                                        rd         <= inst_R.rd;
                                        SRLI       <= '1;
                                        end
                            'b0100000 : begin //SRAI
                                        funct7     <= inst_R.funct7;  
                                        shamt      <= inst_R.rs2;
                                        rs1        <= inst_R.rs1;
                                        funct3     <= inst_R.funct3;
                                        rd         <= inst_R.rd;
                                        SRAI       <= '1;
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
                                        funct7     <= inst_R.funct7;  
                                        rs2        <= inst_R.rs2;
                                        rs1        <= inst_R.rs1;
                                        funct3     <= inst_R.funct3;
                                        rd         <= inst_R.rd;
                                        ADD        <= '1;
                                        end
                            'b0100000 : begin //SUB
                                        funct7     <= inst_R.funct7;  
                                        rs2        <= inst_R.rs2;
                                        rs1        <= inst_R.rs1;
                                        funct3     <= inst_R.funct3;
                                        rd         <= inst_R.rd;
                                        SUB        <= '1;
                                        end
                          endcase
                          end
                  'b001 : begin //SLL
                          funct7     <= inst_R.funct7;  
                          rs2        <= inst_R.rs2;
                          rs1        <= inst_R.rs1;
                          funct3     <= inst_R.funct3;
                          rd         <= inst_R.rd;
                          SLL        <= '1;
                          end
                  'b010 : begin //SLT
                          funct7     <= inst_R.funct7;  
                          rs2        <= inst_R.rs2;
                          rs1        <= inst_R.rs1;
                          funct3     <= inst_R.funct3;
                          rd         <= inst_R.rd;
                          SLT        <= '1;
                          end
                  'b011 : begin //SLTU
                          funct7     <= inst_R.funct7;  
                          rs2        <= inst_R.rs2;
                          rs1        <= inst_R.rs1;
                          funct3     <= inst_R.funct3;
                          rd         <= inst_R.rd;
                          SLTU       <= '1;
                          end
                  'b100 : begin //XOR
                          funct7     <= inst_R.funct7;  
                          rs2        <= inst_R.rs2;
                          rs1        <= inst_R.rs1;
                          funct3     <= inst_R.funct3;
                          rd         <= inst_R.rd;
                          XOR        <= '1;
                          end
                  'b101 : begin 
                          case (inst_R.funct7)
                            'b0000000 : begin //SRL
                                        funct7     <= inst_R.funct7;  
                                        rs2        <= inst_R.rs2;
                                        rs1        <= inst_R.rs1;
                                        funct3     <= inst_R.funct3;
                                        rd         <= inst_R.rd;
                                        SRL        <= '1;
                                        end
                            'b0100000 : begin //SRA
                                        funct7     <= inst_R.funct7;  
                                        rs2        <= inst_R.rs2;
                                        rs1        <= inst_R.rs1;
                                        funct3     <= inst_R.funct3;
                                        rd         <= inst_R.rd;
                                        SRA        <= '1;
                                        end
                          endcase
                          end
                  'b110 : begin //OR
                          funct7     <= inst_R.funct7;  
                          rs2        <= inst_R.rs2;
                          rs1        <= inst_R.rs1;
                          funct3     <= inst_R.funct3;
                          rd         <= inst_R.rd;
                          OR         <= '1;
                          end
                  'b111 : begin //AND
                          funct7     <= inst_R.funct7;  
                          rs2        <= inst_R.rs2;
                          rs1        <= inst_R.rs1;
                          funct3     <= inst_R.funct3;
                          rd         <= inst_R.rd;
                          AND        <= '1;
                          end
                endcase
                end
    'b0001111 : begin //FENCE
                {fm,pred,succ} <= inst_I.imm_11_0;
                rs1            <= inst_I.rs1;
                funct3         <= inst_I.funct3;
                rd             <= inst_I.rd;
                FENCE      <= '1;
                end
    'b1110011 : begin //ECALL
                ECALL      <= '1;
                end
    'b1110011 : begin //EBREAK
                EBREAK     <= '1;
                end
  endcase
  end



always_ff @(posedge clk)
  begin
  dbg_led[0] <= ifu_inst[0];
  dbg_led[1] <= ifu_inst[1];
  end

endmodule
