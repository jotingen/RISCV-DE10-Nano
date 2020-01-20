module riscv_dpu #(
  parameter M_EXT = 1
)  (
  input  logic        clk,
  input  logic        rst,

  output logic        dpu_vld,
  output logic        dpu_alu_vld,
  output logic        dpu_mpu_vld,
  output logic        dpu_dvu_vld,
  output logic        dpu_lsu_vld,
  output logic        dpu_csu_vld,
  output logic        dpu_bru_vld,
  output logic        dpu_br_taken,
  output logic        dpu_freeze,

  output logic        dpu_LUI,
  output logic        dpu_AUIPC,
  output logic        dpu_JAL,
  output logic        dpu_JALR,
  output logic        dpu_BEQ,
  output logic        dpu_BNE,
  output logic        dpu_BLT,
  output logic        dpu_BGE,
  output logic        dpu_BLTU,
  output logic        dpu_BGEU,
  output logic        dpu_LB,
  output logic        dpu_LH,
  output logic        dpu_LW,
  output logic        dpu_LBU,
  output logic        dpu_LHU,
  output logic        dpu_SB,
  output logic        dpu_SH,
  output logic        dpu_SW,
  output logic        dpu_ADDI,
  output logic        dpu_SLTI,
  output logic        dpu_SLTIU,
  output logic        dpu_XORI,
  output logic        dpu_ORI,
  output logic        dpu_ANDI,
  output logic        dpu_SLLI,
  output logic        dpu_SRLI,
  output logic        dpu_SRAI,
  output logic        dpu_ADD,
  output logic        dpu_SUB,
  output logic        dpu_SLL,
  output logic        dpu_SLT,
  output logic        dpu_SLTU,
  output logic        dpu_XOR,
  output logic        dpu_SRL,
  output logic        dpu_SRA,
  output logic        dpu_OR,
  output logic        dpu_AND,
  output logic        dpu_FENCE,
  output logic        dpu_FENCE_I,
  output logic        dpu_ECALL,
  output logic        dpu_CSRRW,
  output logic        dpu_CSRRS,
  output logic        dpu_CSRRC,
  output logic        dpu_CSRRWI,
  output logic        dpu_CSRRSI,
  output logic        dpu_CSRRCI,
  output logic        dpu_EBREAK,
  output logic        dpu_MUL,
  output logic        dpu_MULH,
  output logic        dpu_MULHSU,
  output logic        dpu_MULHU,
  output logic        dpu_DIV,
  output logic        dpu_DIVU,
  output logic        dpu_REM,
  output logic        dpu_REMU,
  output logic        dpu_TRAP,

  output logic [31:0] dpu_inst,
  output logic [31:0] dpu_PC,
  output logic [31:0] dpu_br_pred_PC_next,
  output logic  [3:0] dpu_fm,
  output logic  [3:0] dpu_pred,
  output logic  [3:0] dpu_succ,
  output logic  [4:0] dpu_shamt,
  output logic [31:0] dpu_imm,
  output logic  [4:0] dpu_uimm,
  output logic [11:0] dpu_csr,
  output logic  [6:0] dpu_funct7,
  output logic  [2:0] dpu_funct3,
  output logic  [4:0] dpu_rs2,
  output logic  [4:0] dpu_rs1,
  output logic  [4:0] dpu_rd,
  output logic  [6:0] dpu_opcode,
  output logic [31:0] dpu_rs1_data,
  output logic [31:0] dpu_rs2_data,
          
  output logic [31:0] dpu_PC_next_PC_imm20,
  output logic [31:0] dpu_PC_next_PC_imm12,
  output logic [31:0] dpu_PC_next_rs1_imm11,

  input  logic        exu_vld,
  input  logic        exu_freeze,
  input  logic        exu_br_miss,
  input  logic        exu_trap,
  input  logic  [4:0] exu_rs1,
  input  logic  [4:0] exu_rs2,
  input  logic  [4:0] exu_rd,

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

  input  logic        alu_vld,
  input  logic  [4:0] alu_rs1,
  input  logic  [4:0] alu_rs2,
  input  logic  [4:0] alu_rd,

  input  logic        mpu_vld,
  input  logic  [4:0] mpu_rs1,
  input  logic  [4:0] mpu_rs2,
  input  logic  [4:0] mpu_rd,

  input  logic        dvu_vld,
  input  logic  [4:0] dvu_rs1,
  input  logic  [4:0] dvu_rs2,
  input  logic  [4:0] dvu_rd,

  input  logic        lsu_vld,
  input  logic  [4:0] lsu_rs1,
  input  logic  [4:0] lsu_rs2,
  input  logic  [4:0] lsu_rd,

  input  logic        csu_vld,
  input  logic  [4:0] csu_rs1,
  input  logic  [4:0] csu_rs2,
  input  logic  [4:0] csu_rd,

  input  logic        bru_vld,
  input  logic  [4:0] bru_rs1,
  input  logic  [4:0] bru_rs2,
  input  logic  [4:0] bru_rd

);


logic [31:0] rs1_data;
logic [31:0] rs2_data;

logic dpu_hazard;

logic dpu_rs1_hazard;
logic dpu_rs2_hazard;
logic dpu_rd_hazard;

logic dpu_alu_rs1_hazard;
logic dpu_alu_rs2_hazard;
logic dpu_alu_rd_hazard;

logic dpu_mpu_rs1_hazard;
logic dpu_mpu_rs2_hazard;
logic dpu_mpu_rd_hazard;

logic dpu_dvu_rs1_hazard;
logic dpu_dvu_rs2_hazard;
logic dpu_dvu_rd_hazard;

logic dpu_lsu_rs1_hazard;
logic dpu_lsu_rs2_hazard;
logic dpu_lsu_rd_hazard;

logic dpu_csu_rs1_hazard;
logic dpu_csu_rs2_hazard;
logic dpu_csu_rd_hazard;

logic dpu_bru_rs1_hazard;
logic dpu_bru_rs2_hazard;
logic dpu_bru_rd_hazard;

logic dpu_exu_rs1_hazard;
logic dpu_exu_rs2_hazard;
logic dpu_exu_rd_hazard;


//Map out registers
always_comb
  begin
  unique
  case(dpu_rs1)
    'd00: rs1_data = x00;
    'd01: rs1_data = x01;
    'd02: rs1_data = x02;
    'd03: rs1_data = x03;
    'd04: rs1_data = x04;
    'd05: rs1_data = x05;
    'd06: rs1_data = x06;
    'd07: rs1_data = x07;
    'd08: rs1_data = x08;
    'd09: rs1_data = x09;
    'd10: rs1_data = x10;
    'd11: rs1_data = x11;
    'd12: rs1_data = x12;
    'd13: rs1_data = x13;
    'd14: rs1_data = x14;
    'd15: rs1_data = x15;
    'd16: rs1_data = x16;
    'd17: rs1_data = x17;
    'd18: rs1_data = x18;
    'd19: rs1_data = x19;
    'd20: rs1_data = x20;
    'd21: rs1_data = x21;
    'd22: rs1_data = x22;
    'd23: rs1_data = x23;
    'd24: rs1_data = x24;
    'd25: rs1_data = x25;
    'd26: rs1_data = x26;
    'd27: rs1_data = x27;
    'd28: rs1_data = x28;
    'd29: rs1_data = x29;
    'd30: rs1_data = x30;
    default: rs1_data = x31;
  endcase
  unique
  case(dpu_rs2)
    'd00: rs2_data = x00;
    'd01: rs2_data = x01;
    'd02: rs2_data = x02;
    'd03: rs2_data = x03;
    'd04: rs2_data = x04;
    'd05: rs2_data = x05;
    'd06: rs2_data = x06;
    'd07: rs2_data = x07;
    'd08: rs2_data = x08;
    'd09: rs2_data = x09;
    'd10: rs2_data = x10;
    'd11: rs2_data = x11;
    'd12: rs2_data = x12;
    'd13: rs2_data = x13;
    'd14: rs2_data = x14;
    'd15: rs2_data = x15;
    'd16: rs2_data = x16;
    'd17: rs2_data = x17;
    'd18: rs2_data = x18;
    'd19: rs2_data = x19;
    'd20: rs2_data = x20;
    'd21: rs2_data = x21;
    'd22: rs2_data = x22;
    'd23: rs2_data = x23;
    'd24: rs2_data = x24;
    'd25: rs2_data = x25;
    'd26: rs2_data = x26;
    'd27: rs2_data = x27;
    'd28: rs2_data = x28;
    'd29: rs2_data = x29;
    'd30: rs2_data = x30;
    default: rs2_data = x31;
  endcase
  end

always_comb
  begin
  dpu_PC_next_PC_imm20 = dpu_PC+{{11{dpu_imm[20]}},dpu_imm[20:0]};
  dpu_PC_next_PC_imm12 = dpu_PC+{{19{dpu_imm[12]}},dpu_imm[12:0]};
  dpu_PC_next_rs1_imm11 = (rs1_data+{{20{dpu_imm[11]}},dpu_imm[11:0]}) & 32'hFFFFFFFE;
  end

always_comb
  begin
  dpu_rs2_data   = rs2_data;  
  dpu_rs1_data   = rs1_data;  

  dpu_alu_rs1_hazard = alu_vld && dpu_rs1 != '0 &&
                       ( dpu_rs1 == alu_rs1 |
                         dpu_rs1 == alu_rs2 |
                         dpu_rs1 == alu_rd  );
  dpu_alu_rs2_hazard = alu_vld && dpu_rs2 != '0 &&
                       ( dpu_rs2 == alu_rs1 |
                         dpu_rs2 == alu_rs2 |
                         dpu_rs2 == alu_rd  );
  dpu_alu_rd_hazard  = alu_vld && dpu_rd  != '0 &&
                       ( dpu_rd  == alu_rs1 |
                         dpu_rd  == alu_rs2 |
                         dpu_rd  == alu_rd  );

  dpu_mpu_rs1_hazard = mpu_vld && dpu_rs1 != '0 &&
                       ( dpu_rs1 == mpu_rs1 |
                         dpu_rs1 == mpu_rs2 |
                         dpu_rs1 == mpu_rd  );
  dpu_mpu_rs2_hazard = mpu_vld && dpu_rs2 != '0 &&
                       ( dpu_rs2 == mpu_rs1 |
                         dpu_rs2 == mpu_rs2 |
                         dpu_rs2 == mpu_rd  );
  dpu_mpu_rd_hazard  = mpu_vld && dpu_rd  != '0 &&
                       ( dpu_rd  == mpu_rs1 |
                         dpu_rd  == mpu_rs2 |
                         dpu_rd  == mpu_rd  );

  dpu_dvu_rs1_hazard = dvu_vld && dpu_rs1 != '0 &&
                       ( dpu_rs1 == dvu_rs1 |
                         dpu_rs1 == dvu_rs2 |
                         dpu_rs1 == dvu_rd  );
  dpu_dvu_rs2_hazard = dvu_vld && dpu_rs2 != '0 &&
                       ( dpu_rs2 == dvu_rs1 |
                         dpu_rs2 == dvu_rs2 |
                         dpu_rs2 == dvu_rd  );
  dpu_dvu_rd_hazard  = dvu_vld && dpu_rd  != '0 &&
                       ( dpu_rd  == dvu_rs1 |
                         dpu_rd  == dvu_rs2 |
                         dpu_rd  == dvu_rd  );

  dpu_lsu_rs1_hazard = lsu_vld && dpu_rs1 != '0 &&
                       ( dpu_rs1 == lsu_rs1 |
                         dpu_rs1 == lsu_rs2 |
                         dpu_rs1 == lsu_rd  );
  dpu_lsu_rs2_hazard = lsu_vld && dpu_rs2 != '0 &&
                       ( dpu_rs2 == lsu_rs1 |
                         dpu_rs2 == lsu_rs2 |
                         dpu_rs2 == lsu_rd  );
  dpu_lsu_rd_hazard  = lsu_vld && dpu_rd  != '0 &&
                       ( dpu_rd  == lsu_rs1 |
                         dpu_rd  == lsu_rs2 |
                         dpu_rd  == lsu_rd  );

  dpu_csu_rs1_hazard = csu_vld && dpu_rs1 != '0 &&
                       ( dpu_rs1 == csu_rs1 |
                         dpu_rs1 == csu_rs2 |
                         dpu_rs1 == csu_rd  );
  dpu_csu_rs2_hazard = csu_vld && dpu_rs2 != '0 &&
                       ( dpu_rs2 == csu_rs1 |
                         dpu_rs2 == csu_rs2 |
                         dpu_rs2 == csu_rd  );
  dpu_csu_rd_hazard  = csu_vld && dpu_rd  != '0 &&
                       ( dpu_rd  == csu_rs1 |
                         dpu_rd  == csu_rs2 |
                         dpu_rd  == csu_rd  );

  dpu_bru_rs1_hazard = bru_vld && dpu_rs1 != '0 &&
                       ( dpu_rs1 == bru_rs1 |
                         dpu_rs1 == bru_rs2 |
                         dpu_rs1 == bru_rd  );
  dpu_bru_rs2_hazard = bru_vld && dpu_rs2 != '0 &&
                       ( dpu_rs2 == bru_rs1 |
                         dpu_rs2 == bru_rs2 |
                         dpu_rs2 == bru_rd  );
  dpu_bru_rd_hazard  = bru_vld && dpu_rd  != '0 &&
                       ( dpu_rd  == bru_rs1 |
                         dpu_rd  == bru_rs2 |
                         dpu_rd  == bru_rd  );

  //TMP, this should act more like a passthrough
  dpu_exu_rs1_hazard = exu_vld && dpu_rs1 != '0 &&
                       ( dpu_rs1 == exu_rs1 |
                         dpu_rs1 == exu_rs2 |
                         dpu_rs1 == exu_rd  );
  dpu_exu_rs2_hazard = exu_vld && dpu_rs2 != '0 &&
                       ( dpu_rs2 == exu_rs1 |
                         dpu_rs2 == exu_rs2 |
                         dpu_rs2 == exu_rd  );
  dpu_exu_rd_hazard  = exu_vld && dpu_rd  != '0 &&
                       ( dpu_rd  == exu_rs1 |
                         dpu_rd  == exu_rs2 |
                         dpu_rd  == exu_rd  );

  dpu_rs1_hazard = dpu_alu_rs1_hazard | dpu_mpu_rs1_hazard | dpu_dvu_rs1_hazard | dpu_lsu_rs1_hazard | dpu_csu_rs1_hazard | dpu_bru_rs1_hazard | dpu_exu_rs1_hazard;
  dpu_rs2_hazard = dpu_alu_rs2_hazard | dpu_mpu_rs2_hazard | dpu_dvu_rs2_hazard | dpu_lsu_rs2_hazard | dpu_csu_rs2_hazard | dpu_bru_rs2_hazard | dpu_exu_rs2_hazard;
  dpu_rd_hazard  = dpu_alu_rd_hazard  | dpu_mpu_rd_hazard  | dpu_dvu_rd_hazard  | dpu_lsu_rd_hazard  | dpu_csu_rd_hazard  | dpu_bru_rd_hazard  | dpu_exu_rd_hazard;

  dpu_hazard = dpu_rs1_hazard | dpu_rs2_hazard | dpu_rd_hazard;
  dpu_freeze = (dpu_vld & dpu_hazard) |
               (exu_vld & exu_freeze);

  dpu_alu_vld         = dpu_vld & ~dpu_freeze & ~(exu_vld & (exu_br_miss | exu_trap)) &
                        (dpu_LUI     |
                         dpu_AUIPC   |
                         dpu_ADDI    |
                         dpu_SLTI    |
                         dpu_SLTIU   |
                         dpu_XORI    |
                         dpu_ORI     |
                         dpu_ANDI    |
                         dpu_SLLI    |
                         dpu_SRLI    |
                         dpu_SRAI    |
                         dpu_ADD     |
                         dpu_SUB     |
                         dpu_SLL     |
                         dpu_SLT     |
                         dpu_SLTU    |
                         dpu_XOR     |
                         dpu_SRL     |
                         dpu_SRA     |
                         dpu_OR      |
                         dpu_AND     |
                         dpu_FENCE   |
                         dpu_FENCE_I |
                         dpu_ECALL   |
                         dpu_TRAP);      
  dpu_mpu_vld         = dpu_vld & ~dpu_freeze & ~(exu_vld & (exu_br_miss | exu_trap)) &
                        (dpu_MUL    |
                         dpu_MULH   |
                         dpu_MULHSU |
                         dpu_MULHU);
  dpu_dvu_vld         = dpu_vld & ~dpu_freeze & ~(exu_vld & (exu_br_miss | exu_trap)) &
                        (dpu_DIV  |
                         dpu_DIVU |
                         dpu_REM  |
                         dpu_REMU); 
  dpu_lsu_vld         = dpu_vld & ~dpu_freeze & ~(exu_vld & (exu_br_miss | exu_trap)) &
                        (dpu_LB  |
                         dpu_LH  |
                         dpu_LW  |
                         dpu_LBU |
                         dpu_LHU |
                         dpu_SB  |
                         dpu_SH  |
                         dpu_SW); 
  dpu_csu_vld         = dpu_vld & ~dpu_freeze & ~(exu_vld & (exu_br_miss | exu_trap)) & 
                        (dpu_CSRRW  |
                         dpu_CSRRS  |
                         dpu_CSRRC  |
                         dpu_CSRRWI |
                         dpu_CSRRSI |
                         dpu_CSRRCI); 
  dpu_bru_vld         = dpu_vld & ~dpu_freeze & ~(exu_vld & (exu_br_miss | exu_trap)) & 
                        (dpu_JAL  |      
                         dpu_JALR |      
                         dpu_BEQ  |      
                         dpu_BNE  |      
                         dpu_BLT  |      
                         dpu_BGE  |      
                         dpu_BLTU |      
                         dpu_BGEU);      
  end

always_ff @(posedge clk)
  begin
  if(dpu_vld & dpu_freeze)
    begin
    dpu_vld           <= dpu_vld;
    end
  else
    begin
    dpu_vld           <= '0;
    end

  dpu_br_taken        <= dpu_br_taken;
  dpu_br_pred_PC_next <= dpu_br_pred_PC_next;

  dpu_inst            <= dpu_inst;      
  dpu_fm              <= dpu_fm;        
  dpu_pred            <= dpu_pred;      
  dpu_succ            <= dpu_succ;      
  dpu_shamt           <= dpu_shamt;     
  dpu_imm             <= dpu_imm;       
  dpu_uimm            <= dpu_uimm;      
  dpu_csr             <= dpu_csr;       
  dpu_funct7          <= dpu_funct7;    
  dpu_funct3          <= dpu_funct3;    
  dpu_rs2             <= dpu_rs2;       
  dpu_rs1             <= dpu_rs1;       
  dpu_rd              <= dpu_rd;        
  dpu_opcode          <= dpu_opcode;    
                                         
  dpu_LUI             <= dpu_LUI;       
  dpu_AUIPC           <= dpu_AUIPC;     
  dpu_JAL             <= dpu_JAL;       
  dpu_JALR            <= dpu_JALR;      
  dpu_BEQ             <= dpu_BEQ;       
  dpu_BNE             <= dpu_BNE;       
  dpu_BLT             <= dpu_BLT;       
  dpu_BGE             <= dpu_BGE;       
  dpu_BLTU            <= dpu_BLTU;      
  dpu_BGEU            <= dpu_BGEU;      
  dpu_LB              <= dpu_LB;        
  dpu_LH              <= dpu_LH;        
  dpu_LW              <= dpu_LW;        
  dpu_LBU             <= dpu_LBU;       
  dpu_LHU             <= dpu_LHU;       
  dpu_SB              <= dpu_SB;        
  dpu_SH              <= dpu_SH;        
  dpu_SW              <= dpu_SW;        
  dpu_ADDI            <= dpu_ADDI;      
  dpu_SLTI            <= dpu_SLTI;      
  dpu_SLTIU           <= dpu_SLTIU;     
  dpu_XORI            <= dpu_XORI;      
  dpu_ORI             <= dpu_ORI;       
  dpu_ANDI            <= dpu_ANDI;      
  dpu_SLLI            <= dpu_SLLI;      
  dpu_SRLI            <= dpu_SRLI;      
  dpu_SRAI            <= dpu_SRAI;      
  dpu_ADD             <= dpu_ADD;       
  dpu_SUB             <= dpu_SUB;       
  dpu_SLL             <= dpu_SLL;       
  dpu_SLT             <= dpu_SLT;       
  dpu_SLTU            <= dpu_SLTU;      
  dpu_XOR             <= dpu_XOR;       
  dpu_SRL             <= dpu_SRL;       
  dpu_SRA             <= dpu_SRA;       
  dpu_OR              <= dpu_OR;        
  dpu_AND             <= dpu_AND;       
  dpu_FENCE           <= dpu_FENCE;     
  dpu_FENCE_I         <= dpu_FENCE_I;   
  dpu_ECALL           <= dpu_ECALL;     
  dpu_CSRRW           <= dpu_CSRRW;     
  dpu_CSRRS           <= dpu_CSRRS;     
  dpu_CSRRC           <= dpu_CSRRC;     
  dpu_CSRRWI          <= dpu_CSRRWI;    
  dpu_CSRRSI          <= dpu_CSRRSI;    
  dpu_CSRRCI          <= dpu_CSRRCI;    
  dpu_EBREAK          <= dpu_EBREAK;    
  dpu_MUL             <= dpu_MUL;
  dpu_MULH            <= dpu_MULH;
  dpu_MULHSU          <= dpu_MULHSU;
  dpu_MULHU           <= dpu_MULHU;
  dpu_DIV             <= dpu_DIV;
  dpu_DIVU            <= dpu_DIVU;
  dpu_REM             <= dpu_REM;
  dpu_REMU            <= dpu_REMU;
  dpu_TRAP            <= dpu_TRAP;      

  //Capture IDU when IDU is valid and DPU is not valid or frozen
  if(idu_vld & ~(dpu_vld & dpu_freeze))
    begin
    dpu_vld             <= '1;
    dpu_br_taken        <= idu_inst_br_taken;
    dpu_br_pred_PC_next <= idu_inst_br_pred_PC_next;
    dpu_inst            <= idu_inst;      
    dpu_PC              <= idu_inst_PC;      
    dpu_fm              <= idu_decode_fm;        
    dpu_pred            <= idu_decode_pred;      
    dpu_succ            <= idu_decode_succ;      
    dpu_shamt           <= idu_decode_shamt;     
    dpu_imm             <= idu_decode_imm;       
    dpu_uimm            <= idu_decode_uimm;      
    dpu_csr             <= idu_decode_csr;       
    dpu_funct7          <= idu_decode_funct7;    
    dpu_funct3          <= idu_decode_funct3;    
    dpu_rs2             <= idu_decode_rs2;       
    dpu_rs1             <= idu_decode_rs1;       
    dpu_rd              <= idu_decode_rd;        
    dpu_opcode          <= idu_decode_opcode;    
                           
    dpu_LUI             <= idu_decode_LUI;       
    dpu_AUIPC           <= idu_decode_AUIPC;     
    dpu_JAL             <= idu_decode_JAL;       
    dpu_JALR            <= idu_decode_JALR;      
    dpu_BEQ             <= idu_decode_BEQ;       
    dpu_BNE             <= idu_decode_BNE;       
    dpu_BLT             <= idu_decode_BLT;       
    dpu_BGE             <= idu_decode_BGE;       
    dpu_BLTU            <= idu_decode_BLTU;      
    dpu_BGEU            <= idu_decode_BGEU;      
    dpu_LB              <= idu_decode_LB;        
    dpu_LH              <= idu_decode_LH;        
    dpu_LW              <= idu_decode_LW;        
    dpu_LBU             <= idu_decode_LBU;       
    dpu_LHU             <= idu_decode_LHU;       
    dpu_SB              <= idu_decode_SB;        
    dpu_SH              <= idu_decode_SH;        
    dpu_SW              <= idu_decode_SW;        
    dpu_ADDI            <= idu_decode_ADDI;      
    dpu_SLTI            <= idu_decode_SLTI;      
    dpu_SLTIU           <= idu_decode_SLTIU;     
    dpu_XORI            <= idu_decode_XORI;      
    dpu_ORI             <= idu_decode_ORI;       
    dpu_ANDI            <= idu_decode_ANDI;      
    dpu_SLLI            <= idu_decode_SLLI;      
    dpu_SRLI            <= idu_decode_SRLI;      
    dpu_SRAI            <= idu_decode_SRAI;      
    dpu_ADD             <= idu_decode_ADD;       
    dpu_SUB             <= idu_decode_SUB;       
    dpu_SLL             <= idu_decode_SLL;       
    dpu_SLT             <= idu_decode_SLT;       
    dpu_SLTU            <= idu_decode_SLTU;      
    dpu_XOR             <= idu_decode_XOR;       
    dpu_SRL             <= idu_decode_SRL;       
    dpu_SRA             <= idu_decode_SRA;       
    dpu_OR              <= idu_decode_OR;        
    dpu_AND             <= idu_decode_AND;       
    dpu_FENCE           <= idu_decode_FENCE;     
    dpu_FENCE_I         <= idu_decode_FENCE_I;   
    dpu_ECALL           <= idu_decode_ECALL;     
    dpu_CSRRW           <= idu_decode_CSRRW;     
    dpu_CSRRS           <= idu_decode_CSRRS;     
    dpu_CSRRC           <= idu_decode_CSRRC;     
    dpu_CSRRWI          <= idu_decode_CSRRWI;    
    dpu_CSRRSI          <= idu_decode_CSRRSI;    
    dpu_CSRRCI          <= idu_decode_CSRRCI;    
    dpu_EBREAK          <= idu_decode_EBREAK;    
    dpu_MUL             <= idu_decode_MUL;  
    dpu_MULH            <= idu_decode_MULH; 
    dpu_MULHSU          <= idu_decode_MULHSU;
    dpu_MULHU           <= idu_decode_MULHU;
    dpu_DIV             <= idu_decode_DIV;  
    dpu_DIVU            <= idu_decode_DIVU; 
    dpu_REM             <= idu_decode_REM;  
    dpu_REMU            <= idu_decode_REMU; 
    dpu_TRAP            <= idu_decode_TRAP;      
    end

  if(exu_vld & (exu_br_miss | exu_trap))
    begin
    dpu_vld             <= '0;
    end

  if(rst)
    begin
    dpu_vld             <= '0;
    end
  end

endmodule

