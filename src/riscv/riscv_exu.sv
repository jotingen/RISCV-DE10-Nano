module riscv_exu #(
  parameter M_EXT = 1
)  (
  input  logic        clk,
  input  logic        rst,

`ifdef RISCV_FORMAL
  output reg          rvfi_valid,
  output reg   [63:0] rvfi_order,
  output reg   [31:0] rvfi_insn,
  output reg          rvfi_trap,
  output reg          rvfi_halt,
  output reg          rvfi_intr,
  output reg   [ 1:0] rvfi_mode,
  output reg   [ 1:0] rvfi_ixl,
  output reg   [ 4:0] rvfi_rs1_addr,
  output reg   [ 4:0] rvfi_rs2_addr,
  output reg   [31:0] rvfi_rs1_rdata,
  output reg   [31:0] rvfi_rs2_rdata,
  output reg   [ 4:0] rvfi_rd_addr,
  output reg   [31:0] rvfi_rd_wdata,
  output reg   [31:0] rvfi_pc_rdata,
  output reg   [31:0] rvfi_pc_wdata,
  output reg   [31:0] rvfi_mem_addr,
  output reg   [ 3:0] rvfi_mem_rmask,
  output reg   [ 3:0] rvfi_mem_wmask,
  output reg   [31:0] rvfi_mem_rdata,
  output reg   [31:0] rvfi_mem_wdata,

  output reg   [63:0] rvfi_csr_mcycle_rmask,
  output reg   [63:0] rvfi_csr_mcycle_wmask,
  output reg   [63:0] rvfi_csr_mcycle_rdata,
  output reg   [63:0] rvfi_csr_mcycle_wdata,

  output reg   [63:0] rvfi_csr_minstret_rmask,
  output reg   [63:0] rvfi_csr_minstret_wmask,
  output reg   [63:0] rvfi_csr_minstret_rdata,
  output reg   [63:0] rvfi_csr_minstret_wdata,
`endif

  output logic        dpu_vld,
  output logic        dpu_freeze,

  output logic        exu_vld,
  output logic [31:0] exu_inst,
  output logic        exu_retired,
  output logic        exu_freeze,
  output logic        exu_br,
  output logic        exu_br_taken,
  output logic        exu_br_miss,
  output logic        exu_trap,
  output logic [31:0] exu_PC,
  output logic [31:0] exu_PC_next,
  output logic  [4:0] exu_rs1,
  output logic  [4:0] exu_rs2,
  output logic [31:0] exu_rs1_data,
  output logic [31:0] exu_rs2_data,
  output logic        exu_rd_wr,
  output logic  [4:0] exu_rd,
  output logic [31:0] exu_rd_data,
  output logic [31:0] exu_mem_rdata,

  input  logic        idu_vld,
  input  logic [31:0] idu_inst,
  input  logic [31:0] idu_inst_PC,
  input  logic        idu_inst_br_taken,
  input  logic [31:0] idu_inst_br_pred_PC_next,
  input  logic  [3:0] idu_decode_fm,
  input  logic  [3:0] idu_decode_pred,
  input  logic  [3:0] idu_decode_succ,
  input  logic  [4:0] idu_decode_shamt,
  input  logic [31:0] idu_decode_imm,
  input  logic  [4:0] idu_decode_uimm,
  input  logic [11:0] idu_decode_csr,
  input  logic  [6:0] idu_decode_funct7,
  input  logic  [2:0] idu_decode_funct3,
  input  logic  [4:0] idu_decode_rs2,
  input  logic  [4:0] idu_decode_rs1,
  input  logic  [4:0] idu_decode_rd,
  input  logic  [6:0] idu_decode_opcode,

  input  logic idu_decode_LUI,
  input  logic idu_decode_AUIPC,
  input  logic idu_decode_JAL,
  input  logic idu_decode_JALR,
  input  logic idu_decode_BEQ,
  input  logic idu_decode_BNE,
  input  logic idu_decode_BLT,
  input  logic idu_decode_BGE,
  input  logic idu_decode_BLTU,
  input  logic idu_decode_BGEU,
  input  logic idu_decode_LB,
  input  logic idu_decode_LH,
  input  logic idu_decode_LW,
  input  logic idu_decode_LBU,
  input  logic idu_decode_LHU,
  input  logic idu_decode_SB,
  input  logic idu_decode_SH,
  input  logic idu_decode_SW,
  input  logic idu_decode_ADDI,
  input  logic idu_decode_SLTI,
  input  logic idu_decode_SLTIU,
  input  logic idu_decode_XORI,
  input  logic idu_decode_ORI,
  input  logic idu_decode_ANDI,
  input  logic idu_decode_SLLI,
  input  logic idu_decode_SRLI,
  input  logic idu_decode_SRAI,
  input  logic idu_decode_ADD,
  input  logic idu_decode_SUB,
  input  logic idu_decode_SLL,
  input  logic idu_decode_SLT,
  input  logic idu_decode_SLTU,
  input  logic idu_decode_XOR,
  input  logic idu_decode_SRL,
  input  logic idu_decode_SRA,
  input  logic idu_decode_OR,
  input  logic idu_decode_AND,
  input  logic idu_decode_FENCE,
  input  logic idu_decode_FENCE_I,
  input  logic idu_decode_ECALL,
  input  logic idu_decode_CSRRW,
  input  logic idu_decode_CSRRS,
  input  logic idu_decode_CSRRC,
  input  logic idu_decode_CSRRWI,
  input  logic idu_decode_CSRRSI,
  input  logic idu_decode_CSRRCI,
  input  logic idu_decode_EBREAK,
  input  logic idu_decode_MUL,
  input  logic idu_decode_MULH,
  input  logic idu_decode_MULHSU,
  input  logic idu_decode_MULHU,
  input  logic idu_decode_DIV,
  input  logic idu_decode_DIVU,
  input  logic idu_decode_REM,
  input  logic idu_decode_REMU,
  input  logic idu_decode_TRAP,

  output logic [31:0]       x_wr,
  output logic [31:0]       x00_in,
  output logic [31:0]       x01_in,
  output logic [31:0]       x02_in,
  output logic [31:0]       x03_in,
  output logic [31:0]       x04_in,
  output logic [31:0]       x05_in,
  output logic [31:0]       x06_in,
  output logic [31:0]       x07_in,
  output logic [31:0]       x08_in,
  output logic [31:0]       x09_in,
  output logic [31:0]       x10_in,
  output logic [31:0]       x11_in,
  output logic [31:0]       x12_in,
  output logic [31:0]       x13_in,
  output logic [31:0]       x14_in,
  output logic [31:0]       x15_in,
  output logic [31:0]       x16_in,
  output logic [31:0]       x17_in,
  output logic [31:0]       x18_in,
  output logic [31:0]       x19_in,
  output logic [31:0]       x20_in,
  output logic [31:0]       x21_in,
  output logic [31:0]       x22_in,
  output logic [31:0]       x23_in,
  output logic [31:0]       x24_in,
  output logic [31:0]       x25_in,
  output logic [31:0]       x26_in,
  output logic [31:0]       x27_in,
  output logic [31:0]       x28_in,
  output logic [31:0]       x29_in,
  output logic [31:0]       x30_in,
  output logic [31:0]       x31_in,
  input  logic [31:0]       x00,
  input  logic [31:0]       x01,
  input  logic [31:0]       x02,
  input  logic [31:0]       x03,
  input  logic [31:0]       x04,
  input  logic [31:0]       x05,
  input  logic [31:0]       x06,
  input  logic [31:0]       x07,
  input  logic [31:0]       x08,
  input  logic [31:0]       x09,
  input  logic [31:0]       x10,
  input  logic [31:0]       x11,
  input  logic [31:0]       x12,
  input  logic [31:0]       x13,
  input  logic [31:0]       x14,
  input  logic [31:0]       x15,
  input  logic [31:0]       x16,
  input  logic [31:0]       x17,
  input  logic [31:0]       x18,
  input  logic [31:0]       x19,
  input  logic [31:0]       x20,
  input  logic [31:0]       x21,
  input  logic [31:0]       x22,
  input  logic [31:0]       x23,
  input  logic [31:0]       x24,
  input  logic [31:0]       x25,
  input  logic [31:0]       x26,
  input  logic [31:0]       x27,
  input  logic [31:0]       x28,
  input  logic [31:0]       x29,
  input  logic [31:0]       x30,
  input  logic [31:0]       x31,

  output logic             csr_req,
  input  logic             csr_ack,
  output logic             csr_write,
  output logic [31:0]      csr_addr,
  output logic [31:0]      csr_mask,
  output logic [31:0]      csr_data_wr,
  input  logic [31:0]      csr_data_rd,

  output logic             bus_req,
  input  logic             bus_ack,
  output logic             bus_write,
  output logic [31:0]      bus_addr,
  output logic  [3:0]      bus_data_rd_mask,
  output logic [31:0]      bus_data_wr,
  output logic  [3:0]      bus_data_wr_mask,
  input  logic [31:0]      bus_data_rd
);


logic        alu_vld;
logic [31:0] alu_inst;
logic        alu_trap;
logic [31:0] alu_PC;
logic [31:0] alu_PC_next;
logic  [4:0] alu_rs1;
logic  [4:0] alu_rs2;
logic [31:0] alu_rs1_data;
logic [31:0] alu_rs2_data;
logic        alu_rd_wr;
logic  [4:0] alu_rd;
logic [31:0] alu_rd_data;

logic        mpu_vld;
logic [31:0] mpu_inst;
logic        mpu_retired;
logic        mpu_freeze;
logic        mpu_trap;
logic [31:0] mpu_PC;
logic [31:0] mpu_PC_next;
logic  [4:0] mpu_rs1;
logic  [4:0] mpu_rs2;
logic [31:0] mpu_rs1_data;
logic [31:0] mpu_rs2_data;
logic        mpu_rd_wr;
logic  [4:0] mpu_rd;
logic [31:0] mpu_rd_data;

logic        dvu_vld;
logic [31:0] dvu_inst;
logic        dvu_retired;
logic        dvu_freeze;
logic        dvu_trap;
logic [31:0] dvu_PC;
logic [31:0] dvu_PC_next;
logic  [4:0] dvu_rs1;
logic  [4:0] dvu_rs2;
logic [31:0] dvu_rs1_data;
logic [31:0] dvu_rs2_data;
logic        dvu_rd_wr;
logic  [4:0] dvu_rd;
logic [31:0] dvu_rd_data;

logic        lsu_vld;
logic [31:0] lsu_inst;
logic        lsu_retired;
logic        lsu_freeze;
logic        lsu_trap;
logic [31:0] lsu_PC;
logic [31:0] lsu_PC_next;
logic  [4:0] lsu_rs1;
logic  [4:0] lsu_rs2;
logic [31:0] lsu_rs1_data;
logic [31:0] lsu_rs2_data;
logic        lsu_rd_wr;
logic  [4:0] lsu_rd;
logic [31:0] lsu_rd_data;
logic [31:0] lsu_mem_rdata;

logic        csu_vld;
logic [31:0] csu_inst;
logic        csu_retired;
logic        csu_freeze;
logic        csu_trap;
logic [31:0] csu_PC;
logic [31:0] csu_PC_next;
logic  [4:0] csu_rs1;
logic  [4:0] csu_rs2;
logic [31:0] csu_rs1_data;
logic [31:0] csu_rs2_data;
logic        csu_rd_wr;
logic  [4:0] csu_rd;
logic [31:0] csu_rd_data;

logic        bru_vld;
logic [31:0] bru_inst;
logic        bru_br;
logic        bru_br_taken;
logic        bru_br_miss;
logic        bru_trap;
logic [31:0] bru_PC;
logic [31:0] bru_PC_next;
logic  [4:0] bru_rs1;
logic  [4:0] bru_rs2;
logic [31:0] bru_rs1_data;
logic [31:0] bru_rs2_data;
logic        bru_rd_wr;
logic  [4:0] bru_rd;
logic [31:0] bru_rd_data;

logic [31:0] dpu_PC;
logic [31:0] dpu_inst_PC_next;

logic        dpu_alu_vld;
logic        dpu_mpu_vld;
logic        dpu_dvu_vld;
logic        dpu_lsu_vld;
logic        dpu_csu_vld;
logic        dpu_bru_vld;
logic        dpu_br_taken;

logic [31:0] dpu_br_pred_PC_next;
logic [31:0] exu_br_pred_PC_next;

logic        exu_mem_access;

logic [31:0] dpu_inst;
logic  [3:0] dpu_fm;
logic  [3:0] dpu_pred;
logic  [3:0] dpu_succ;
logic  [4:0] dpu_shamt;
logic [31:0] dpu_imm;
logic  [4:0] dpu_uimm;
logic [11:0] dpu_csr;
logic  [6:0] dpu_funct7;
logic  [2:0] dpu_funct3;
logic  [4:0] dpu_rs2;
logic  [4:0] dpu_rs1;
logic  [4:0] dpu_rd;
logic  [6:0] dpu_opcode;
logic [31:0] dpu_rs1_data;
logic [31:0] dpu_rs2_data;

logic [31:0] dpu_PC_next_PC_imm20;
logic [31:0] dpu_PC_next_PC_imm12;
logic [31:0] dpu_PC_next_rs1_imm11;

logic dpu_LUI;
logic dpu_AUIPC;
logic dpu_JAL;
logic dpu_JALR;
logic dpu_BEQ;
logic dpu_BNE;
logic dpu_BLT;
logic dpu_BGE;
logic dpu_BLTU;
logic dpu_BGEU;
logic dpu_LB;
logic dpu_LH;
logic dpu_LW;
logic dpu_LBU;
logic dpu_LHU;
logic dpu_SB;
logic dpu_SH;
logic dpu_SW;
logic dpu_ADDI;
logic dpu_SLTI;
logic dpu_SLTIU;
logic dpu_XORI;
logic dpu_ORI;
logic dpu_ANDI;
logic dpu_SLLI;
logic dpu_SRLI;
logic dpu_SRAI;
logic dpu_ADD;
logic dpu_SUB;
logic dpu_SLL;
logic dpu_SLT;
logic dpu_SLTU;
logic dpu_XOR;
logic dpu_SRL;
logic dpu_SRA;
logic dpu_OR;
logic dpu_AND;
logic dpu_FENCE;
logic dpu_FENCE_I;
logic dpu_ECALL;
logic dpu_CSRRW;
logic dpu_CSRRS;
logic dpu_CSRRC;
logic dpu_CSRRWI;
logic dpu_CSRRSI;
logic dpu_CSRRCI;
logic dpu_EBREAK;
logic dpu_MUL;
logic dpu_MULH;
logic dpu_MULHSU;
logic dpu_MULHU;
logic dpu_DIV;
logic dpu_DIVU;
logic dpu_REM;
logic dpu_REMU;
logic dpu_TRAP;

logic        wbu_vld;
logic [31:0] wbu_inst;
logic        wbu_retired;
logic        wbu_freeze;
logic        wbu_br;
logic        wbu_br_taken;
logic        wbu_br_miss;
logic        wbu_trap;
logic [31:0] wbu_PC;
logic [31:0] wbu_PC_next;
logic  [4:0] wbu_rs1;
logic  [4:0] wbu_rs2;
logic [31:0] wbu_rs1_data;
logic [31:0] wbu_rs2_data;
logic        wbu_rd_wr;
logic  [4:0] wbu_rd;
logic [31:0] wbu_rd_data;
logic [31:0] wbu_mem_rdata;


riscv_dpu dpu (
  .clk,
  .rst,
   
  .dpu_vld,
  .dpu_alu_vld,
  .dpu_mpu_vld,
  .dpu_dvu_vld,
  .dpu_lsu_vld,
  .dpu_csu_vld,
  .dpu_bru_vld,
  .dpu_br_taken,
  .dpu_freeze,
   
  .dpu_LUI,
  .dpu_AUIPC,
  .dpu_JAL,
  .dpu_JALR,
  .dpu_BEQ,
  .dpu_BNE,
  .dpu_BLT,
  .dpu_BGE,
  .dpu_BLTU,
  .dpu_BGEU,
  .dpu_LB,
  .dpu_LH,
  .dpu_LW,
  .dpu_LBU,
  .dpu_LHU,
  .dpu_SB,
  .dpu_SH,
  .dpu_SW,
  .dpu_ADDI,
  .dpu_SLTI,
  .dpu_SLTIU,
  .dpu_XORI,
  .dpu_ORI,
  .dpu_ANDI,
  .dpu_SLLI,
  .dpu_SRLI,
  .dpu_SRAI,
  .dpu_ADD,
  .dpu_SUB,
  .dpu_SLL,
  .dpu_SLT,
  .dpu_SLTU,
  .dpu_XOR,
  .dpu_SRL,
  .dpu_SRA,
  .dpu_OR,
  .dpu_AND,
  .dpu_FENCE,
  .dpu_FENCE_I,
  .dpu_ECALL,
  .dpu_CSRRW,
  .dpu_CSRRS,
  .dpu_CSRRC,
  .dpu_CSRRWI,
  .dpu_CSRRSI,
  .dpu_CSRRCI,
  .dpu_EBREAK,
  .dpu_MUL,
  .dpu_MULH,
  .dpu_MULHSU,
  .dpu_MULHU,
  .dpu_DIV,
  .dpu_DIVU,
  .dpu_REM,
  .dpu_REMU,
  .dpu_TRAP,
   
  .dpu_inst,
  .dpu_PC,
  .dpu_br_pred_PC_next,
  .dpu_fm,
  .dpu_pred,
  .dpu_succ,
  .dpu_shamt,
  .dpu_imm,
  .dpu_uimm,
  .dpu_csr,
  .dpu_funct7,
  .dpu_funct3,
  .dpu_rs2,
  .dpu_rs1,
  .dpu_rd,
  .dpu_opcode,
  .dpu_rs1_data,
  .dpu_rs2_data,
   
  .dpu_PC_next_PC_imm20,
  .dpu_PC_next_PC_imm12,
  .dpu_PC_next_rs1_imm11,

  .exu_vld,
  .exu_freeze,
  .exu_br_miss,
  .exu_trap,
  .exu_rs1,
  .exu_rs2,
  .exu_rd,
   
  .idu_vld,
  .idu_inst,
  .idu_inst_PC,
  .idu_inst_br_taken,
  .idu_inst_br_pred_PC_next,
  .idu_decode_fm,
  .idu_decode_pred,
  .idu_decode_succ,
  .idu_decode_shamt,
  .idu_decode_imm,
  .idu_decode_uimm,
  .idu_decode_csr,
  .idu_decode_funct7,
  .idu_decode_funct3,
  .idu_decode_rs2,
  .idu_decode_rs1,
  .idu_decode_rd,
  .idu_decode_opcode,

  .idu_decode_LUI,
  .idu_decode_AUIPC,
  .idu_decode_JAL,
  .idu_decode_JALR,
  .idu_decode_BEQ,
  .idu_decode_BNE,
  .idu_decode_BLT,
  .idu_decode_BGE,
  .idu_decode_BLTU,
  .idu_decode_BGEU,
  .idu_decode_LB,
  .idu_decode_LH,
  .idu_decode_LW,
  .idu_decode_LBU,
  .idu_decode_LHU,
  .idu_decode_SB,
  .idu_decode_SH,
  .idu_decode_SW,
  .idu_decode_ADDI,
  .idu_decode_SLTI,
  .idu_decode_SLTIU,
  .idu_decode_XORI,
  .idu_decode_ORI,
  .idu_decode_ANDI,
  .idu_decode_SLLI,
  .idu_decode_SRLI,
  .idu_decode_SRAI,
  .idu_decode_ADD,
  .idu_decode_SUB,
  .idu_decode_SLL,
  .idu_decode_SLT,
  .idu_decode_SLTU,
  .idu_decode_XOR,
  .idu_decode_SRL,
  .idu_decode_SRA,
  .idu_decode_OR,
  .idu_decode_AND,
  .idu_decode_FENCE,
  .idu_decode_FENCE_I,
  .idu_decode_ECALL,
  .idu_decode_CSRRW,
  .idu_decode_CSRRS,
  .idu_decode_CSRRC,
  .idu_decode_CSRRWI,
  .idu_decode_CSRRSI,
  .idu_decode_CSRRCI,
  .idu_decode_EBREAK,
  .idu_decode_MUL,
  .idu_decode_MULH,
  .idu_decode_MULHSU,
  .idu_decode_MULHU,
  .idu_decode_DIV,
  .idu_decode_DIVU,
  .idu_decode_REM,
  .idu_decode_REMU,
  .idu_decode_TRAP,

  .x00,
  .x01,
  .x02,
  .x03,
  .x04,
  .x05,
  .x06,
  .x07,
  .x08,
  .x09,
  .x10,
  .x11,
  .x12,
  .x13,
  .x14,
  .x15,
  .x16,
  .x17,
  .x18,
  .x19,
  .x20,
  .x21,
  .x22,
  .x23,
  .x24,
  .x25,
  .x26,
  .x27,
  .x28,
  .x29,
  .x30,
  .x31,

  .alu_vld,
  .alu_rs1,
  .alu_rs2,
  .alu_rd,
   
  .mpu_vld,
  .mpu_rs1,
  .mpu_rs2,
  .mpu_rd,
   
  .dvu_vld,
  .dvu_rs1,
  .dvu_rs2,
  .dvu_rd,
   
  .lsu_vld,
  .lsu_rs1,
  .lsu_rs2,
  .lsu_rd,
   
  .csu_vld,
  .csu_rs1,
  .csu_rs2,
  .csu_rd,
   
  .bru_vld,
  .bru_rs1,
  .bru_rs2,
  .bru_rd
);

riscv_alu alu (
  .clk            (clk     ),
  .rst            (rst     ),

  .alu_vld          (alu_vld),
  .alu_inst             (alu_inst    ),
  .alu_trap         (alu_trap),
  .alu_PC           (alu_PC),
  .alu_PC_next      (alu_PC_next),
  .alu_rs1          (alu_rs1),
  .alu_rs2          (alu_rs2),
  .alu_rs1_data          (alu_rs1_data),
  .alu_rs2_data          (alu_rs2_data),
  .alu_rd_wr        (alu_rd_wr),
  .alu_rd           (alu_rd),
  .alu_rd_data      (alu_rd_data),
                                 
  .dpu_vld          (dpu_alu_vld),
  .dpu_inst             (dpu_inst    ),
  .dpu_PC          (dpu_PC),

  .dpu_fm               (dpu_fm      ),
  .dpu_pred             (dpu_pred    ),
  .dpu_succ             (dpu_succ    ),
  .dpu_shamt            (dpu_shamt   ),
  .dpu_imm              (dpu_imm     ),
  .dpu_uimm             (dpu_uimm    ),
  .dpu_csr              (dpu_csr     ),
  .dpu_funct7           (dpu_funct7  ),
  .dpu_funct3           (dpu_funct3  ),
  .dpu_rs2              (dpu_rs2     ),
  .dpu_rs1              (dpu_rs1     ),
  .dpu_rd               (dpu_rd      ),
  .dpu_opcode           (dpu_opcode  ),
                                    
  .dpu_rs1_data             (dpu_rs1_data    ),
  .dpu_rs2_data             (dpu_rs2_data    ),

  .dpu_LUI              (dpu_LUI     ),
  .dpu_AUIPC            (dpu_AUIPC   ),
  .dpu_ADDI             (dpu_ADDI    ),
  .dpu_SLTI             (dpu_SLTI    ),
  .dpu_SLTIU            (dpu_SLTIU   ),
  .dpu_XORI             (dpu_XORI    ),
  .dpu_ORI              (dpu_ORI     ),
  .dpu_ANDI             (dpu_ANDI    ),
  .dpu_SLLI             (dpu_SLLI    ),
  .dpu_SRLI             (dpu_SRLI    ),
  .dpu_SRAI             (dpu_SRAI    ),
  .dpu_ADD              (dpu_ADD     ),
  .dpu_SUB              (dpu_SUB     ),
  .dpu_SLL              (dpu_SLL     ),
  .dpu_SLT              (dpu_SLT     ),
  .dpu_SLTU             (dpu_SLTU    ),
  .dpu_XOR              (dpu_XOR     ),
  .dpu_SRL              (dpu_SRL     ),
  .dpu_SRA              (dpu_SRA     ),
  .dpu_OR               (dpu_OR      ),
  .dpu_AND              (dpu_AND     ),
  .dpu_FENCE            (dpu_FENCE   ),
  .dpu_FENCE_I          (dpu_FENCE_I ),
  .dpu_ECALL            (dpu_ECALL   ),
  .dpu_EBREAK           (dpu_EBREAK  ),
  .dpu_TRAP             (dpu_TRAP    )
);

riscv_mpu mpu (
  .clk            (clk     ),
  .rst            (rst     ),

  .mpu_vld          (mpu_vld),
  .mpu_inst         (mpu_inst    ),
  .mpu_retired      (mpu_retired),
  .mpu_freeze       (mpu_freeze),
  .mpu_trap         (mpu_trap),
  .mpu_PC           (mpu_PC),
  .mpu_PC_next      (mpu_PC_next),
  .mpu_rs1          (mpu_rs1),
  .mpu_rs2          (mpu_rs2),
  .mpu_rs1_data          (mpu_rs1_data),
  .mpu_rs2_data          (mpu_rs2_data),
  .mpu_rd_wr        (mpu_rd_wr),
  .mpu_rd           (mpu_rd),
  .mpu_rd_data      (mpu_rd_data),
                                 
  .dpu_vld          (dpu_mpu_vld),
  .dpu_inst         (dpu_inst    ),
  .dpu_PC           (dpu_PC),

  .dpu_fm               (dpu_fm      ),
  .dpu_pred             (dpu_pred    ),
  .dpu_succ             (dpu_succ    ),
  .dpu_shamt            (dpu_shamt   ),
  .dpu_imm              (dpu_imm     ),
  .dpu_uimm             (dpu_uimm    ),
  .dpu_csr              (dpu_csr     ),
  .dpu_funct7           (dpu_funct7  ),
  .dpu_funct3           (dpu_funct3  ),
  .dpu_rs2              (dpu_rs2     ),
  .dpu_rs1              (dpu_rs1     ),
  .dpu_rd               (dpu_rd      ),
  .dpu_opcode           (dpu_opcode  ),
                                    
  .dpu_rs1_data             (dpu_rs1_data    ),
  .dpu_rs2_data             (dpu_rs2_data    ),

  .dpu_MUL               (dpu_MUL      ),
  .dpu_MULH              (dpu_MULH     ),
  .dpu_MULHSU            (dpu_MULHSU   ),
  .dpu_MULHU             (dpu_MULHU    )
);

riscv_dvu dvu (
  .clk            (clk     ),
  .rst            (rst     ),

  .dvu_vld          (dvu_vld),
  .dvu_inst         (dvu_inst    ),
  .dvu_retired      (dvu_retired),
  .dvu_freeze       (dvu_freeze),
  .dvu_trap         (dvu_trap),
  .dvu_PC           (dvu_PC),
  .dvu_PC_next      (dvu_PC_next),
  .dvu_rs1          (dvu_rs1),
  .dvu_rs2          (dvu_rs2),
  .dvu_rs1_data          (dvu_rs1_data),
  .dvu_rs2_data          (dvu_rs2_data),
  .dvu_rd_wr        (dvu_rd_wr),
  .dvu_rd           (dvu_rd),
  .dvu_rd_data      (dvu_rd_data),
                                 
  .dpu_vld          (dpu_dvu_vld),
  .dpu_inst         (dpu_inst    ),
  .dpu_PC           (dpu_PC),

  .dpu_fm               (dpu_fm      ),
  .dpu_pred             (dpu_pred    ),
  .dpu_succ             (dpu_succ    ),
  .dpu_shamt            (dpu_shamt   ),
  .dpu_imm              (dpu_imm     ),
  .dpu_uimm             (dpu_uimm    ),
  .dpu_csr              (dpu_csr     ),
  .dpu_funct7           (dpu_funct7  ),
  .dpu_funct3           (dpu_funct3  ),
  .dpu_rs2              (dpu_rs2     ),
  .dpu_rs1              (dpu_rs1     ),
  .dpu_rd               (dpu_rd      ),
  .dpu_opcode           (dpu_opcode  ),
                                    
  .dpu_rs1_data             (dpu_rs1_data    ),
  .dpu_rs2_data             (dpu_rs2_data    ),

  .dpu_DIV              (dpu_DIV     ),
  .dpu_DIVU             (dpu_DIVU    ),
  .dpu_REM              (dpu_REM     ),
  .dpu_REMU             (dpu_REMU    )
);

riscv_lsu lsu (
  .clk            (clk     ),
  .rst            (rst     ),

  .lsu_vld          (lsu_vld),
  .lsu_inst         (lsu_inst    ),
  .lsu_retired      (lsu_retired),
  .lsu_freeze       (lsu_freeze),
  .lsu_trap         (lsu_trap),
  .lsu_PC           (lsu_PC),
  .lsu_PC_next      (lsu_PC_next),
  .lsu_rs1          (lsu_rs1),
  .lsu_rs2          (lsu_rs2),
  .lsu_rs1_data          (lsu_rs1_data),
  .lsu_rs2_data          (lsu_rs2_data),
  .lsu_rd_wr        (lsu_rd_wr),
  .lsu_rd           (lsu_rd),
  .lsu_rd_data      (lsu_rd_data),
  .lsu_mem_rdata          (lsu_mem_rdata),
                                 
  .dpu_vld          (dpu_lsu_vld),
  .dpu_inst         (dpu_inst    ),
  .dpu_PC           (dpu_PC),

  .dpu_fm               (dpu_fm      ),
  .dpu_pred             (dpu_pred    ),
  .dpu_succ             (dpu_succ    ),
  .dpu_shamt            (dpu_shamt   ),
  .dpu_imm              (dpu_imm     ),
  .dpu_uimm             (dpu_uimm    ),
  .dpu_csr              (dpu_csr     ),
  .dpu_funct7           (dpu_funct7  ),
  .dpu_funct3           (dpu_funct3  ),
  .dpu_rs2              (dpu_rs2     ),
  .dpu_rs1              (dpu_rs1     ),
  .dpu_rd               (dpu_rd      ),
  .dpu_opcode           (dpu_opcode  ),
                                    
  .dpu_rs1_data             (dpu_rs1_data    ),
  .dpu_rs2_data             (dpu_rs2_data    ),

  .dpu_LB               (dpu_LB      ),
  .dpu_LH               (dpu_LH      ),
  .dpu_LW               (dpu_LW      ),
  .dpu_LBU              (dpu_LBU     ),
  .dpu_LHU              (dpu_LHU     ),
  .dpu_SB               (dpu_SB      ),
  .dpu_SH               (dpu_SH      ),
  .dpu_SW               (dpu_SW      ),

  .bus_req              (bus_req         ),
  .bus_ack              (bus_ack         ),
  .bus_write            (bus_write       ),
  .bus_addr             (bus_addr        ),
  .bus_data_rd_mask     (bus_data_rd_mask),
  .bus_data_wr          (bus_data_wr     ),
  .bus_data_wr_mask     (bus_data_wr_mask),
  .bus_data_rd          (bus_data_rd     )
);

riscv_csu csu (
  .clk            (clk     ),
  .rst            (rst     ),

  .csu_vld          (csu_vld),
  .csu_inst         (csu_inst    ),
  .csu_retired      (csu_retired),
  .csu_freeze       (csu_freeze),
  .csu_trap         (csu_trap),
  .csu_PC           (csu_PC),
  .csu_PC_next      (csu_PC_next),
  .csu_rs1          (csu_rs1),
  .csu_rs2          (csu_rs2),
  .csu_rs1_data          (csu_rs1_data),
  .csu_rs2_data          (csu_rs2_data),
  .csu_rd_wr        (csu_rd_wr),
  .csu_rd           (csu_rd),
  .csu_rd_data      (csu_rd_data),
                                 
  .dpu_vld          (dpu_csu_vld),
  .dpu_inst         (dpu_inst    ),
  .dpu_PC           (dpu_PC),

  .dpu_fm               (dpu_fm      ),
  .dpu_pred             (dpu_pred    ),
  .dpu_succ             (dpu_succ    ),
  .dpu_shamt            (dpu_shamt   ),
  .dpu_imm              (dpu_imm     ),
  .dpu_uimm             (dpu_uimm    ),
  .dpu_csr              (dpu_csr     ),
  .dpu_funct7           (dpu_funct7  ),
  .dpu_funct3           (dpu_funct3  ),
  .dpu_rs2              (dpu_rs2     ),
  .dpu_rs1              (dpu_rs1     ),
  .dpu_rd               (dpu_rd      ),
  .dpu_opcode           (dpu_opcode  ),
                                    
  .dpu_rs1_data             (dpu_rs1_data    ),
  .dpu_rs2_data             (dpu_rs2_data    ),

  .dpu_CSRRW            (dpu_CSRRW   ),
  .dpu_CSRRS            (dpu_CSRRS   ),
  .dpu_CSRRC            (dpu_CSRRC   ),
  .dpu_CSRRWI           (dpu_CSRRWI  ),
  .dpu_CSRRSI           (dpu_CSRRSI  ),
  .dpu_CSRRCI           (dpu_CSRRCI  ),

  .csr_req              (csr_req         ),
  .csr_ack              (csr_ack         ),
  .csr_write            (csr_write       ),
  .csr_addr             (csr_addr        ),
  .csr_mask             (csr_mask        ),
  .csr_data_wr          (csr_data_wr     ),
  .csr_data_rd          (csr_data_rd     )
);

riscv_bru bru (
  .clk            (clk     ),
  .rst            (rst     ),

  .bru_vld          (bru_vld),
  .bru_inst             (bru_inst    ),
  .bru_br           (bru_br),
  .bru_br_taken     (bru_br_taken),
  .bru_br_miss      (bru_br_miss),
  .bru_trap         (bru_trap),
  .bru_PC           (bru_PC),
  .bru_PC_next      (bru_PC_next),
  .bru_rs1          (bru_rs1),
  .bru_rs2          (bru_rs2),
  .bru_rs1_data          (bru_rs1_data),
  .bru_rs2_data          (bru_rs2_data),
  .bru_rd_wr        (bru_rd_wr),
  .bru_rd           (bru_rd),
  .bru_rd_data      (bru_rd_data),
                                 
  .dpu_vld              (dpu_bru_vld),
  .dpu_inst             (dpu_inst    ),
  .dpu_PC               (dpu_PC),
  .dpu_br_taken         (dpu_br_taken),
  .dpu_br_pred_PC_next  (dpu_br_pred_PC_next),
  .dpu_fm               (dpu_fm      ),
  .dpu_pred             (dpu_pred    ),
  .dpu_succ             (dpu_succ    ),
  .dpu_shamt            (dpu_shamt   ),
  .dpu_imm              (dpu_imm     ),
  .dpu_uimm             (dpu_uimm    ),
  .dpu_csr              (dpu_csr     ),
  .dpu_funct7           (dpu_funct7  ),
  .dpu_funct3           (dpu_funct3  ),
  .dpu_rs2              (dpu_rs2     ),
  .dpu_rs1              (dpu_rs1     ),
  .dpu_rd               (dpu_rd      ),
  .dpu_opcode           (dpu_opcode  ),

  .dpu_rs1_data             (dpu_rs1_data    ),
  .dpu_rs2_data             (dpu_rs2_data    ),

  .dpu_PC_next_PC_imm20 (dpu_PC_next_PC_imm20 ),
  .dpu_PC_next_PC_imm12 (dpu_PC_next_PC_imm12 ),
  .dpu_PC_next_rs1_imm11(dpu_PC_next_rs1_imm11),
                             
  .dpu_JAL              (dpu_JAL     ),
  .dpu_JALR             (dpu_JALR    ),
  .dpu_BEQ              (dpu_BEQ     ),
  .dpu_BNE              (dpu_BNE     ),
  .dpu_BLT              (dpu_BLT     ),
  .dpu_BGE              (dpu_BGE     ),
  .dpu_BLTU             (dpu_BLTU    ),
  .dpu_BGEU             (dpu_BGEU    )
);

riscv_wbu wbu (
  .wbu_vld,
  .wbu_inst,
  .wbu_retired,
  .wbu_freeze,
  .wbu_br,
  .wbu_br_taken,
  .wbu_br_miss,
  .wbu_trap,
  .wbu_PC,
  .wbu_PC_next,
  .wbu_rs1,
  .wbu_rs2,
  .wbu_rs1_data,
  .wbu_rs2_data,
  .wbu_rd_wr,
  .wbu_rd,
  .wbu_rd_data,
  .wbu_mem_rdata,
   
  .x_wr,
  .x00_in,
  .x01_in,
  .x02_in,
  .x03_in,
  .x04_in,
  .x05_in,
  .x06_in,
  .x07_in,
  .x08_in,
  .x09_in,
  .x10_in,
  .x11_in,
  .x12_in,
  .x13_in,
  .x14_in,
  .x15_in,
  .x16_in,
  .x17_in,
  .x18_in,
  .x19_in,
  .x20_in,
  .x21_in,
  .x22_in,
  .x23_in,
  .x24_in,
  .x25_in,
  .x26_in,
  .x27_in,
  .x28_in,
  .x29_in,
  .x30_in,
  .x31_in,
   
  .alu_vld,
  .alu_inst,
  .alu_trap,
  .alu_PC,
  .alu_PC_next,
  .alu_rs1,
  .alu_rs2,
  .alu_rs1_data,
  .alu_rs2_data,
  .alu_rd_wr,
  .alu_rd,
  .alu_rd_data,
   
  .mpu_vld,
  .mpu_inst,
  .mpu_retired,
  .mpu_freeze,
  .mpu_trap,
  .mpu_PC,
  .mpu_PC_next,
  .mpu_rs1,
  .mpu_rs2,
  .mpu_rs1_data,
  .mpu_rs2_data,
  .mpu_rd_wr,
  .mpu_rd,
  .mpu_rd_data,
   
  .dvu_vld,
  .dvu_inst,
  .dvu_retired,
  .dvu_freeze,
  .dvu_trap,
  .dvu_PC,
  .dvu_PC_next,
  .dvu_rs1,
  .dvu_rs2,
  .dvu_rs1_data,
  .dvu_rs2_data,
  .dvu_rd_wr,
  .dvu_rd,
  .dvu_rd_data,
   
  .lsu_vld,
  .lsu_inst,
  .lsu_retired,
  .lsu_freeze,
  .lsu_trap,
  .lsu_PC,
  .lsu_PC_next,
  .lsu_rs1,
  .lsu_rs2,
  .lsu_rs1_data,
  .lsu_rs2_data,
  .lsu_rd_wr,
  .lsu_rd,
  .lsu_rd_data,
  .lsu_mem_rdata,
   
  .csu_vld,
  .csu_inst,
  .csu_retired,
  .csu_freeze,
  .csu_trap,
  .csu_PC,
  .csu_PC_next,
  .csu_rs1,
  .csu_rs2,
  .csu_rs1_data,
  .csu_rs2_data,
  .csu_rd_wr,
  .csu_rd,
  .csu_rd_data,
   
  .bru_vld,
  .bru_inst,
  .bru_br,
  .bru_br_taken,
  .bru_br_miss,
  .bru_trap,
  .bru_PC,
  .bru_PC_next,
  .bru_rs1,
  .bru_rs2,
  .bru_rs1_data,
  .bru_rs2_data,
  .bru_rd_wr,
  .bru_rd,
  .bru_rd_data
);

always_comb
  begin
  exu_vld       = wbu_vld;      
  exu_inst      = wbu_inst;     
  exu_retired   = wbu_retired;  
  exu_freeze    = wbu_freeze;   
  exu_br        = wbu_br;       
  exu_br_taken  = wbu_br_taken; 
  exu_br_miss   = wbu_br_miss;  
  exu_trap      = wbu_trap;     
  exu_PC        = wbu_PC;       
  exu_PC_next   = wbu_PC_next;  
  exu_rs1       = wbu_rs1;      
  exu_rs2       = wbu_rs2;      
  exu_rs1_data  = wbu_rs1_data; 
  exu_rs2_data  = wbu_rs2_data; 
  exu_rd_wr     = wbu_rd_wr;    
  exu_rd        = wbu_rd;       
  exu_rd_data   = wbu_rd_data;  
  exu_mem_rdata = wbu_mem_rdata;
  end

//RVFI interface
`ifdef RISCV_FORMAL
logic [63:0] order;
always_ff @(posedge clk)
  begin
  order <= order;
  if(exu_vld & exu_retired)
    begin
    order <= order + 1;
    end
  if(rst)
    begin
    order <= '0;
    end
  end
  
always_comb
  begin
  rvfi_valid = exu_vld & exu_retired;// & ~exu_FENCE;
  rvfi_order = order;
  rvfi_insn = exu_inst;
  rvfi_trap = exu_trap;
  rvfi_halt = '0;
  rvfi_intr = '0;
  rvfi_mode = '0;
  rvfi_ixl = '0;
  rvfi_rs1_addr = exu_rs1;
  rvfi_rs2_addr = exu_rs2;
  rvfi_rs1_rdata = exu_rs1_data;
  rvfi_rs2_rdata = exu_rs2_data;
  rvfi_rd_addr = exu_rd;
  rvfi_rd_wdata = exu_rd_data;
  rvfi_pc_rdata = exu_PC;
  rvfi_pc_wdata = exu_PC_next;
  rvfi_mem_addr = bus_addr;
  rvfi_mem_rmask = {4{lsu_vld}} & bus_data_rd_mask;
  rvfi_mem_wmask = {4{lsu_vld}} & bus_data_wr_mask;
  rvfi_mem_rdata = {32{lsu_vld}} & exu_mem_rdata;
  rvfi_mem_wdata = {32{lsu_vld}} & bus_data_wr;

  rvfi_csr_mcycle_rmask = csr_write ? '0 : csr_mask;
  rvfi_csr_mcycle_wmask = csr_write ? csr_mask : '0;
  rvfi_csr_mcycle_rdata = csr_data_rd; 
  rvfi_csr_mcycle_wdata = csr_data_wr;

  rvfi_csr_minstret_rmask = '0;
  rvfi_csr_minstret_wmask = '0;
  rvfi_csr_minstret_rdata = '0;
  rvfi_csr_minstret_wdata = '0;
  end
`endif
endmodule
