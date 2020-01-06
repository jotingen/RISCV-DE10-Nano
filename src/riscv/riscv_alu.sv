//import riscv_pkg::*;

module riscv_alu#(
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

  output logic        alu_vld,
  output logic        alu_retired,
  output logic        alu_freeze,
  output logic        alu_br,
  output logic        alu_br_taken,
  output logic        alu_br_miss,
  output logic        alu_trap,
  output logic [31:0] alu_PC,
  output logic [31:0] alu_PC_next,

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

logic [31:0] PC_next_PC_imm20;
logic [31:0] PC_next_PC_imm12;
logic [31:0] PC_next_rs1_imm11;

logic [31:0] rs1_data;
logic [31:0] rs2_data;
logic [31:0] rd_data;

logic [31:0] alu_br_pred_PC_next;

logic [31:0] alu_inst;
logic  [3:0] alu_fm;
logic  [3:0] alu_pred;
logic  [3:0] alu_succ;
logic  [4:0] alu_shamt;
logic [31:0] alu_imm;
logic  [4:0] alu_uimm;
logic [11:0] alu_csr;
logic  [6:0] alu_funct7;
logic  [2:0] alu_funct3;
logic  [4:0] alu_rs2;
logic  [4:0] alu_rs1;
logic  [4:0] alu_rd;
logic  [6:0] alu_opcode;
logic [31:0] alu_rs1_data;
logic [31:0] alu_rs2_data;
logic [31:0] alu_rd_data;

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

logic        alu_mem_access;

//Map out registers
always_comb
  begin
  unique
  case(alu_rs1)
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
  case(alu_rs2)
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
  x00_in = '0;
  x01_in = '0;
  x02_in = '0;
  x03_in = '0;
  x04_in = '0;
  x05_in = '0;
  x06_in = '0;
  x07_in = '0;
  x08_in = '0;
  x09_in = '0;
  x10_in = '0;
  x11_in = '0;
  x12_in = '0;
  x13_in = '0;
  x14_in = '0;
  x15_in = '0;
  x16_in = '0;
  x17_in = '0;
  x18_in = '0;
  x19_in = '0;
  x20_in = '0;
  x21_in = '0;
  x22_in = '0;
  x23_in = '0;
  x24_in = '0;
  x25_in = '0;
  x26_in = '0;
  x27_in = '0;
  x28_in = '0;
  x29_in = '0;
  x30_in = '0;
  x31_in = '0;
  unique
  case(alu_rd)
    'd00: x00_in = rd_data;
    'd01: x01_in = rd_data;
    'd02: x02_in = rd_data;
    'd03: x03_in = rd_data;
    'd04: x04_in = rd_data;
    'd05: x05_in = rd_data;
    'd06: x06_in = rd_data;
    'd07: x07_in = rd_data;
    'd08: x08_in = rd_data;
    'd09: x09_in = rd_data;
    'd10: x10_in = rd_data;
    'd11: x11_in = rd_data;
    'd12: x12_in = rd_data;
    'd13: x13_in = rd_data;
    'd14: x14_in = rd_data;
    'd15: x15_in = rd_data;
    'd16: x16_in = rd_data;
    'd17: x17_in = rd_data;
    'd18: x18_in = rd_data;
    'd19: x19_in = rd_data;
    'd20: x20_in = rd_data;
    'd21: x21_in = rd_data;
    'd22: x22_in = rd_data;
    'd23: x23_in = rd_data;
    'd24: x24_in = rd_data;
    'd25: x25_in = rd_data;
    'd26: x26_in = rd_data;
    'd27: x27_in = rd_data;
    'd28: x28_in = rd_data;
    'd29: x29_in = rd_data;
    'd30: x30_in = rd_data;
    default: x31_in = rd_data;
  endcase
  end

always_comb
  begin
  PC_next_PC_imm20 = alu_PC+{{11{alu_imm[20]}},alu_imm[20:0]};
  PC_next_PC_imm12 = alu_PC+{{19{alu_imm[12]}},alu_imm[12:0]};
  PC_next_rs1_imm11 = (rs1_data+{{20{alu_imm[11]}},alu_imm[11:0]}) & 32'hFFFFFFFE;
  end

logic [3:0] cnt;
always_ff @(posedge clk)
  begin
  //if(alu_vld & alu_trap)
  //  $fatal();

  alu_vld <= alu_vld;
  alu_retired <= '0;
  alu_freeze <= alu_freeze;
  alu_br <= '0;
  alu_br_taken <= alu_br_taken;
  alu_br_pred_PC_next <= alu_br_pred_PC_next;
  alu_br_miss <= '0;
  alu_mem_access <= alu_mem_access;

  alu_PC      <= alu_PC;
  alu_PC_next <= alu_PC_next;
  x_wr  <= '0;
  rd_data <= rd_data;

  csr_req   <= '0  ;
  csr_write <= csr_write;
  csr_addr  <= csr_addr ;
  csr_mask  <= csr_mask ;
  csr_data_wr  <= '0;

  bus_req   <= '0;
  bus_write <= bus_write;
  bus_addr  <= bus_addr;
  bus_data_wr  <= bus_data_wr;
  bus_data_rd_mask <= bus_data_rd_mask;
  bus_data_wr_mask <= bus_data_wr_mask;

  alu_rs2_data   <= rs2_data;  
  alu_rs1_data   <= rs1_data;  
  alu_rd_data    <= rd_data;   
  alu_trap       <= '0;   

  alu_inst    <= alu_inst;      
  alu_fm      <= alu_fm;        
  alu_pred    <= alu_pred;      
  alu_succ    <= alu_succ;      
  alu_shamt   <= alu_shamt;     
  alu_imm     <= alu_imm;       
  alu_uimm    <= alu_uimm;      
  alu_csr     <= alu_csr;       
  alu_funct7  <= alu_funct7;    
  alu_funct3  <= alu_funct3;    
  alu_rs2     <= alu_rs2;       
  alu_rs1     <= alu_rs1;       
  alu_rd      <= alu_rd;        
  alu_opcode  <= alu_opcode;    
                                 
  alu_LUI     <= alu_LUI;       
  alu_AUIPC   <= alu_AUIPC;     
  alu_JAL     <= alu_JAL;       
  alu_JALR    <= alu_JALR;      
  alu_BEQ     <= alu_BEQ;       
  alu_BNE     <= alu_BNE;       
  alu_BLT     <= alu_BLT;       
  alu_BGE     <= alu_BGE;       
  alu_BLTU    <= alu_BLTU;      
  alu_BGEU    <= alu_BGEU;      
  alu_LB      <= alu_LB;        
  alu_LH      <= alu_LH;        
  alu_LW      <= alu_LW;        
  alu_LBU     <= alu_LBU;       
  alu_LHU     <= alu_LHU;       
  alu_SB      <= alu_SB;        
  alu_SH      <= alu_SH;        
  alu_SW      <= alu_SW;        
  alu_ADDI    <= alu_ADDI;      
  alu_SLTI    <= alu_SLTI;      
  alu_SLTIU   <= alu_SLTIU;     
  alu_XORI    <= alu_XORI;      
  alu_ORI     <= alu_ORI;       
  alu_ANDI    <= alu_ANDI;      
  alu_SLLI    <= alu_SLLI;      
  alu_SRLI    <= alu_SRLI;      
  alu_SRAI    <= alu_SRAI;      
  alu_ADD     <= alu_ADD;       
  alu_SUB     <= alu_SUB;       
  alu_SLL     <= alu_SLL;       
  alu_SLT     <= alu_SLT;       
  alu_SLTU    <= alu_SLTU;      
  alu_XOR     <= alu_XOR;       
  alu_SRL     <= alu_SRL;       
  alu_SRA     <= alu_SRA;       
  alu_OR      <= alu_OR;        
  alu_AND     <= alu_AND;       
  alu_FENCE   <= alu_FENCE;     
  alu_FENCE_I <= alu_FENCE_I;   
  alu_ECALL   <= alu_ECALL;     
  alu_CSRRW   <= alu_CSRRW;     
  alu_CSRRS   <= alu_CSRRS;     
  alu_CSRRC   <= alu_CSRRC;     
  alu_CSRRWI  <= alu_CSRRWI;    
  alu_CSRRSI  <= alu_CSRRSI;    
  alu_CSRRCI  <= alu_CSRRCI;    
  alu_EBREAK  <= alu_EBREAK;    
  alu_MUL     <= alu_MUL;
  alu_MULH    <= alu_MULH;
  alu_MULHSU  <= alu_MULHSU;
  alu_MULHU   <= alu_MULHU;
  alu_DIV     <= alu_DIV;
  alu_DIVU    <= alu_DIVU;
  alu_REM     <= alu_REM;
  alu_REMU    <= alu_REMU;
  alu_TRAP    <= alu_TRAP;      

  mem_rdata <= mem_rdata;

  //Capture IDU when IDU is valid and ALU is not valid or is retiring without
  //branch miss or trap
  if((~alu_vld | (alu_vld & alu_retired & ~(alu_br_miss | alu_trap))) & idu_vld)
    begin
    alu_retired <= '0;
    alu_freeze  <= idu_vld;
    alu_br      <= '0;
    alu_br_taken <= idu_inst_br_taken;
    alu_br_pred_PC_next <= idu_inst_br_pred_PC_next;
    alu_br_miss <= '0;
    alu_vld     <= idu_vld;
    alu_inst    <= idu_inst;      
    alu_PC      <= idu_inst_PC;      
    alu_fm      <= idu_decode_fm;        
    alu_pred    <= idu_decode_pred;      
    alu_succ    <= idu_decode_succ;      
    alu_shamt   <= idu_decode_shamt;     
    alu_imm     <= idu_decode_imm;       
    alu_uimm    <= idu_decode_uimm;      
    alu_csr     <= idu_decode_csr;       
    alu_funct7  <= idu_decode_funct7;    
    alu_funct3  <= idu_decode_funct3;    
    alu_rs2     <= idu_decode_rs2;       
    alu_rs1     <= idu_decode_rs1;       
    alu_rd      <= idu_decode_rd;        
    alu_opcode  <= idu_decode_opcode;    
                   
    alu_LUI     <= idu_decode_LUI;       
    alu_AUIPC   <= idu_decode_AUIPC;     
    alu_JAL     <= idu_decode_JAL;       
    alu_JALR    <= idu_decode_JALR;      
    alu_BEQ     <= idu_decode_BEQ;       
    alu_BNE     <= idu_decode_BNE;       
    alu_BLT     <= idu_decode_BLT;       
    alu_BGE     <= idu_decode_BGE;       
    alu_BLTU    <= idu_decode_BLTU;      
    alu_BGEU    <= idu_decode_BGEU;      
    alu_LB      <= idu_decode_LB;        
    alu_LH      <= idu_decode_LH;        
    alu_LW      <= idu_decode_LW;        
    alu_LBU     <= idu_decode_LBU;       
    alu_LHU     <= idu_decode_LHU;       
    alu_SB      <= idu_decode_SB;        
    alu_SH      <= idu_decode_SH;        
    alu_SW      <= idu_decode_SW;        
    alu_ADDI    <= idu_decode_ADDI;      
    alu_SLTI    <= idu_decode_SLTI;      
    alu_SLTIU   <= idu_decode_SLTIU;     
    alu_XORI    <= idu_decode_XORI;      
    alu_ORI     <= idu_decode_ORI;       
    alu_ANDI    <= idu_decode_ANDI;      
    alu_SLLI    <= idu_decode_SLLI;      
    alu_SRLI    <= idu_decode_SRLI;      
    alu_SRAI    <= idu_decode_SRAI;      
    alu_ADD     <= idu_decode_ADD;       
    alu_SUB     <= idu_decode_SUB;       
    alu_SLL     <= idu_decode_SLL;       
    alu_SLT     <= idu_decode_SLT;       
    alu_SLTU    <= idu_decode_SLTU;      
    alu_XOR     <= idu_decode_XOR;       
    alu_SRL     <= idu_decode_SRL;       
    alu_SRA     <= idu_decode_SRA;       
    alu_OR      <= idu_decode_OR;        
    alu_AND     <= idu_decode_AND;       
    alu_FENCE   <= idu_decode_FENCE;     
    alu_FENCE_I <= idu_decode_FENCE_I;   
    alu_ECALL   <= idu_decode_ECALL;     
    alu_CSRRW   <= idu_decode_CSRRW;     
    alu_CSRRS   <= idu_decode_CSRRS;     
    alu_CSRRC   <= idu_decode_CSRRC;     
    alu_CSRRWI  <= idu_decode_CSRRWI;    
    alu_CSRRSI  <= idu_decode_CSRRSI;    
    alu_CSRRCI  <= idu_decode_CSRRCI;    
    alu_EBREAK  <= idu_decode_EBREAK;    
    alu_MUL     <= idu_decode_MUL;  
    alu_MULH    <= idu_decode_MULH; 
    alu_MULHSU  <= idu_decode_MULHSU;
    alu_MULHU   <= idu_decode_MULHU;
    alu_DIV     <= idu_decode_DIV;  
    alu_DIVU    <= idu_decode_DIVU; 
    alu_REM     <= idu_decode_REM;  
    alu_REMU    <= idu_decode_REMU; 
    alu_TRAP    <= idu_decode_TRAP;      
    bus_req   <= '0;
    bus_write <= '0;
    bus_addr  <= '0;
    bus_data_wr  <= '0;
    bus_data_rd_mask <= '0;
    bus_data_wr_mask <= '0;
    end
  //Else turn off if retiring
  else if(alu_vld & alu_retired)
    begin
    alu_retired <= '0;
    alu_mem_access <= '0;
    alu_freeze <= '0;
    alu_br_taken <= '0;
    alu_br_pred_PC_next <= '0;
    alu_br_miss <= '0;
    alu_vld     <= '0;
    end

  if(alu_vld & ~alu_retired)
    begin


    unique
    case (1'b1)
      alu_ADD : begin
                //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "ADD", PC, alu_rs1, rs1_data, alu_rs2, rs2_data, alu_rd);
                alu_retired <= '1;
                alu_freeze <= '0;
                x_wr[alu_rd] <= '1;
                rd_data <= rs1_data + rs2_data;
                alu_PC_next <= alu_PC+'d4;
                end
      alu_SLT : begin
                //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SLT", PC, alu_rs1, rs1_data, alu_rs2, rs2_data, alu_rd);
                alu_retired <= '1;
                alu_freeze <= '0;
                x_wr[alu_rd] <= '1;
                if($signed(rs1_data) < $signed(rs2_data))
                  rd_data <= 'd1;
                else
                  rd_data <= 'd0;
                alu_PC_next <= alu_PC+'d4;
                end
      alu_SLTU : begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SLTU", PC, alu_rs1, rs1_data, alu_rs2, rs2_data, alu_rd);
                 alu_retired <= '1;
                alu_freeze <= '0;
                 x_wr[alu_rd] <= '1;
                 if(rs1_data < rs2_data)
                   rd_data <= 'd1;
                 else
                   rd_data <= 'd0;
                 alu_PC_next <= alu_PC+'d4;
                 end
      alu_AND : begin
                //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "AND", PC, alu_rs1, rs1_data, alu_rs2, rs2_data, alu_rd);
                alu_retired <= '1;
                alu_freeze <= '0;
                x_wr[alu_rd] <= '1;
                rd_data <= rs1_data & rs2_data;
                alu_PC_next <= alu_PC+'d4;
                end
      alu_OR : begin
               //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "OR", PC, alu_rs1, rs1_data, alu_rs2, rs2_data, alu_rd);
               alu_retired <= '1;
                alu_freeze <= '0;
               x_wr[alu_rd] <= '1;
               rd_data <= rs1_data | rs2_data;
               alu_PC_next <= alu_PC+'d4;
               end
      alu_XOR : begin
                //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "XOR", PC, alu_rs1, rs1_data, alu_rs2, rs2_data, alu_rd);
                alu_retired <= '1;
                alu_freeze <= '0;
                x_wr[alu_rd] <= '1;
                rd_data <= rs1_data ^ rs2_data;
                alu_PC_next <= alu_PC+'d4;
                end
      alu_SLL : begin
                //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SLL", PC, alu_rs1, rs1_data, alu_rs2, rs2_data, alu_rd);
                alu_retired <= '1;
                alu_freeze <= '0;
                x_wr[alu_rd] <= '1;
                rd_data <= rs1_data << rs2_data[4:0];
                alu_PC_next <= alu_PC+'d4;
                end
      alu_SRL : begin
                //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SRL", PC, alu_rs1, rs1_data, alu_rs2, rs2_data, alu_rd);
                alu_retired <= '1;
                alu_freeze <= '0;
                x_wr[alu_rd] <= '1;
                rd_data <= rs1_data >> rs2_data[4:0];
                alu_PC_next <= alu_PC+'d4;
                end
      alu_SUB : begin
                //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SUB", PC, alu_rs1, rs1_data, alu_rs2, rs2_data, alu_rd);
                alu_retired <= '1;
                alu_freeze <= '0;
                x_wr[alu_rd] <= '1;
                rd_data <= rs1_data - rs2_data;
                alu_PC_next <= alu_PC+'d4;
                end
      alu_SRA : begin
                //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SRA", PC, alu_rs1, rs1_data, alu_rs2, rs2_data, alu_rd);
                alu_retired <= '1;
                alu_freeze <= '0;
                x_wr[alu_rd] <= '1;
                rd_data <= rs1_data >>> rs2_data;
                alu_PC_next <= alu_PC+'d4;
                end


      alu_ADDI : begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "ADDI", PC, alu_rs1, rs1_data, {{20{alu_imm[11]}},alu_imm[11:0]}, alu_rd);
                 alu_retired <= '1;
                alu_freeze <= '0;
                 x_wr[alu_rd] <= '1;
                 rd_data <= rs1_data + {{20{alu_imm[11]}},alu_imm[11:0]};
                 alu_PC_next <= alu_PC+'d4;
                 end
      alu_SLTI : begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "SLTI", PC, alu_rs1, rs1_data, {{20{alu_imm[11]}},alu_imm[11:0]}, alu_rd);
                 alu_retired <= '1;
                alu_freeze <= '0;
                 x_wr[alu_rd] <= '1;
                 if($signed(rs1_data) < $signed({{20{alu_imm[11]}},alu_imm[11:0]}))
                   rd_data <= 'd1;
                 else
                   rd_data <= 'd0;
                 alu_PC_next <= alu_PC+'d4;
                 end
      alu_SLTIU : begin
                  //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "SLTIU", PC, alu_rs1, rs1_data, {{20{alu_imm[11]}},alu_imm[11:0]}, alu_rd);
                 alu_retired <= '1;
                alu_freeze <= '0;
                  x_wr[alu_rd] <= '1;
                  if(rs1_data < {{20{alu_imm[11]}},alu_imm[11:0]})
                    rd_data <= 'd1;
                  else
                    rd_data <= 'd0;
                  alu_PC_next <= alu_PC+'d4;
                  end
      alu_ANDI : begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "ANDI", PC, alu_rs1, rs1_data, {{20{alu_imm[11]}},alu_imm[11:0]}, alu_rd);
                 alu_retired <= '1;
                alu_freeze <= '0;
                 x_wr[alu_rd] <= '1;
                 rd_data <= rs1_data & {{20{alu_imm[11]}},alu_imm[11:0]};
                 alu_PC_next <= alu_PC+'d4;
                 end
      alu_ORI : begin
                //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "ORI", PC, alu_rs1, rs1_data, {{20{alu_imm[11]}},alu_imm[11:0]}, alu_rd);
                alu_retired <= '1;
                alu_freeze <= '0;
                x_wr[alu_rd] <= '1;
                rd_data <= rs1_data | {{20{alu_imm[11]}},alu_imm[11:0]};
                alu_PC_next <= alu_PC+'d4;
                end
      alu_XORI : begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "XORI", PC, alu_rs1, rs1_data, {{20{alu_imm[11]}},alu_imm[11:0]}, alu_rd);
                 alu_retired <= '1;
                alu_freeze <= '0;
                 x_wr[alu_rd] <= '1;
                 rd_data <= rs1_data ^ {{20{alu_imm[11]}},alu_imm[11:0]};
                 alu_PC_next <= alu_PC+'d4;
                 end
      alu_SLLI : begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "SLLI", PC, alu_rs1, rs1_data, {{27{'0}},alu_imm[4:0]}, alu_rd);
                 alu_retired <= '1;
                alu_freeze <= '0;
                 x_wr[alu_rd] <= '1;
                 rd_data <= rs1_data << alu_shamt;
                 alu_PC_next <= alu_PC+'d4;
                 end
      alu_SRLI : begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "SRLI", PC, alu_rs1, rs1_data, {{27{'0}},alu_imm[4:0]}, alu_rd);
                 alu_retired <= '1;
                alu_freeze <= '0;
                 x_wr[alu_rd] <= '1;
                 rd_data <= rs1_data >> alu_shamt;
                 alu_PC_next <= alu_PC+'d4;
                 end
      alu_SRAI : begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "SRAI", PC, alu_rs1, rs1_data, alu_imm[4:0], alu_rd);
                 alu_retired <= '1;
                alu_freeze <= '0;
                 x_wr[alu_rd] <= '1;
                 rd_data <= $signed(rs1_data) >>> alu_shamt;
                 alu_PC_next <= alu_PC+'d4;
                 end


      alu_JAL : begin
                //if(alu_imm!='0 || alu_rd!='0)
                //  $display("%-5s PC=%08X imm=%08X rd=(%d)", "JAL", PC, {{11{alu_imm[20]}},alu_imm[20:0]}, alu_rd);
                alu_retired <= '1;
                alu_br <= '1;
                alu_freeze <= '0;
                alu_PC_next <= PC_next_PC_imm20;
                x_wr[alu_rd] <= '1;
                if(PC_next_PC_imm20[1:0] != '0)
                  begin
                  alu_trap <= '1;
                  end
                else
                  begin
                  rd_data <= alu_PC+'d4;
                  if(alu_br_pred_PC_next != PC_next_PC_imm20)
                    begin
                    alu_br_miss <= '1;
                    end
                  end
                end
      alu_JALR : begin
                 //$display("%-5s PC=%08X imm=%08X rd=(%d)", "JALR", PC, {{20{alu_imm[11]}},alu_imm[11:0]}, alu_rd);
                 alu_retired <= '1;
                 alu_br <= '1;
                 alu_freeze <= '0;
                 alu_PC_next <= PC_next_rs1_imm11;
                 x_wr[alu_rd] <= '1;
                 if(PC_next_rs1_imm11[1:0] != '0)
                   begin
                   alu_trap <= '1;
                   end
                 else
                   begin
                   rd_data <= alu_PC+'d4;
                  if(alu_br_pred_PC_next != PC_next_rs1_imm11)
                     begin
                     alu_br_miss <= '1;
                     end
                   end
                 end


      alu_BEQ : begin
                //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BEQ", PC, alu_rs1, rs1_data, alu_rs2, rs2_data, {{19{alu_imm[12]}},alu_imm[12:0]});
                alu_retired <= '1;
                alu_br <= '1;
                alu_freeze <= '0;
                if(rs1_data == rs2_data)
                  begin
                  alu_PC_next <= PC_next_PC_imm12;
                  if(PC_next_PC_imm12[1:0] != '0)
                    begin
                    alu_trap <= '1;
                    end
                  if(alu_br_pred_PC_next != PC_next_PC_imm12)
                    begin
                    alu_br_miss <= '1;
                    end
                  end
                else                  
                  begin
                  alu_PC_next <= alu_PC+'d4;
                  if(alu_br_pred_PC_next != alu_PC+'d4)
                    begin
                    alu_br_miss <= '1;
                    end
                  end
                end
      alu_BNE : begin
                //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BNE", PC, alu_rs1, rs1_data, alu_rs2, rs2_data, {{19{alu_imm[12]}},alu_imm[12:0]});
                alu_retired <= '1;
                alu_br <= '1;
                alu_freeze <= '0;
                if(rs1_data != rs2_data)
                  begin
                  alu_PC_next <= PC_next_PC_imm12;
                  if(PC_next_PC_imm12[1:0] != '0)
                    begin
                    alu_trap <= '1;
                    end
                  if(alu_br_pred_PC_next != PC_next_PC_imm12)
                    begin
                    alu_br_miss <= '1;
                    end
                  end
                else                  
                  begin
                  alu_PC_next <= alu_PC+'d4;
                  if(alu_br_pred_PC_next != alu_PC+'d4)
                    begin
                    alu_br_miss <= '1;
                    end
                  end
                end
      alu_BLT : begin
                //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BLT", PC, alu_rs1, rs1_data, alu_rs2, rs2_data, {{19{alu_imm[12]}},alu_imm[12:0]});
                alu_retired <= '1;
                alu_br <= '1;
                alu_freeze <= '0;
                if($signed(rs1_data) < $signed(rs2_data))
                  begin
                  alu_PC_next <= PC_next_PC_imm12;
                  if(PC_next_PC_imm12[1:0] != '0)
                    begin
                    alu_trap <= '1;
                    end
                  if(alu_br_pred_PC_next != PC_next_PC_imm12)
                    begin
                    alu_br_miss <= '1;
                    end
                  end
                else                  
                  begin
                  alu_PC_next <= alu_PC+'d4;
                  if(alu_br_pred_PC_next != alu_PC+'d4)
                    begin
                    alu_br_miss <= '1;
                    end
                  end
                end
      alu_BLTU : begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BLTU", PC, alu_rs1, rs1_data, alu_rs2, rs2_data, {{19{alu_imm[12]}},alu_imm[12:0]});
                 alu_retired <= '1;
                alu_br <= '1;
                alu_freeze <= '0;
                 if(rs1_data < rs2_data)
                  begin
                  alu_PC_next <= PC_next_PC_imm12;
                  if(PC_next_PC_imm12[1:0] != '0)
                    begin
                    alu_trap <= '1;
                    end
                  if(alu_br_pred_PC_next != PC_next_PC_imm12)
                    begin
                    alu_br_miss <= '1;
                    end
                  end
                 else                  
                   begin
                   alu_PC_next <= alu_PC+'d4;
                  if(alu_br_pred_PC_next != alu_PC+'d4)
                    begin
                    alu_br_miss <= '1;
                    end
                   end
                 end
      alu_BGE : begin
                //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BGE", PC, alu_rs1, rs1_data, alu_rs2, rs2_data, {{19{alu_imm[12]}},alu_imm[12:0]});
                alu_retired <= '1;
                alu_br <= '1;
                alu_freeze <= '0;
                if($signed(rs1_data) >= $signed(rs2_data))
                  begin
                  alu_PC_next <= PC_next_PC_imm12;
                  if(PC_next_PC_imm12[1:0] != '0)
                    begin
                    alu_trap <= '1;
                    end
                  if(alu_br_pred_PC_next != PC_next_PC_imm12)
                    begin
                    alu_br_miss <= '1;
                    end
                  end
                else                  
                  begin
                  alu_PC_next <= alu_PC+'d4;
                  if(alu_br_pred_PC_next != alu_PC+'d4)
                    begin
                    alu_br_miss <= '1;
                    end
                  end
                end
      alu_BGEU : begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BGEU", PC, alu_rs1, rs1_data, alu_rs2, rs2_data, {{19{alu_imm[12]}},alu_imm[12:0]});
                 alu_retired <= '1;
                alu_br <= '1;
                alu_freeze <= '0;
                 if(rs1_data >= rs2_data)
                  begin
                   alu_PC_next <= PC_next_PC_imm12;
                   if(PC_next_PC_imm12[1:0] != '0)
                     begin
                     alu_trap <= '1;
                     end
                  if(alu_br_pred_PC_next != PC_next_PC_imm12)
                    begin
                    alu_br_miss <= '1;
                    end
                  end
                 else                  
                   begin
                   alu_PC_next <= alu_PC+'d4;
                   if(alu_br_pred_PC_next != alu_PC+'d4)
                     begin
                     alu_br_miss <= '1;
                     end
                   end
                 end


      alu_LUI : begin
                //$display("%-5s PC=%08X imm=%08X rd=(%d)", "LUI", PC, alu_imm, alu_rd);
                alu_retired <= '1;
                alu_freeze <= '0;
                x_wr[alu_rd] <= '1;
                rd_data <= alu_imm;
                alu_PC_next <= alu_PC+'d4;
                end
      alu_AUIPC : begin
                  //$display("%0t %-5s PC=%08X imm=%08X rd=(%d)", $time, "AUIPC", alu_PC, alu_imm, alu_rd);
                  alu_retired <= '1;
                alu_freeze <= '0;
                  x_wr[alu_rd] <= '1;
                  rd_data <= alu_PC + alu_imm;
                  alu_PC_next <= alu_PC+'d4;
                  end


      alu_LB : begin
               if(~alu_mem_access)
                 begin
                 bus_req   <= '1;
                 bus_write <= '0;
                 addr  = rs1_data + { {20{alu_imm[11]}}, alu_imm[11:0]};
                 bus_addr  <= addr;
                 bus_addr[1:0] <= '0;
                 unique
                 case(addr[1:0])
                   'b00: bus_data_rd_mask <= 'b0001;
                   'b01: bus_data_rd_mask <= 'b0010;
                   'b10: bus_data_rd_mask <= 'b0100;
                   'b11: bus_data_rd_mask <= 'b1000;
                 endcase
                 alu_freeze <= '1;
                 alu_mem_access <= '1;
                 end
               else if(bus_ack)
                 begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "LW", PC, alu_rs1, rs1_data, {{20{alu_imm[11]}},alu_imm[11:0]}, alu_rd);
                 alu_retired <= '1;
                alu_freeze <= '0;
                 alu_mem_access <= '0;
                 x_wr[alu_rd] <= '1;
                 addr  = rs1_data + { {20{alu_imm[11]}}, alu_imm[11:0]};
                 unique
                 case(addr[1:0])
                   'b00: rd_data <= {{24{bus_data_rd[7]}},bus_data_rd[7:0]};
                   'b01: rd_data <= {{24{bus_data_rd[15]}},bus_data_rd[15:8]};
                   'b10: rd_data <= {{24{bus_data_rd[23]}},bus_data_rd[23:16]};
                   'b11: rd_data <= {{24{bus_data_rd[31]}},bus_data_rd[31:24]};
                 endcase
                 mem_rdata <= bus_data_rd;
                 alu_PC_next <= alu_PC+'d4;
                 end
               end
      alu_LBU : begin
               if(~alu_mem_access)
                 begin
                 bus_req   <= '1;
                 bus_write <= '0;
                 addr  = rs1_data + { {20{alu_imm[11]}}, alu_imm[11:0]};
                 bus_addr  <= addr;
                 bus_addr[1:0] <= '0;
                 unique
                 case(addr[1:0])
                   'b00: bus_data_rd_mask <= 'b0001;
                   'b01: bus_data_rd_mask <= 'b0010;
                   'b10: bus_data_rd_mask <= 'b0100;
                   'b11: bus_data_rd_mask <= 'b1000;
                 endcase
                 alu_freeze <= '1;
                 alu_mem_access <= '1;
                 end
               else if(bus_ack)
                 begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "LW", PC, alu_rs1, rs1_data, {{20{alu_imm[11]}},alu_imm[11:0]}, alu_rd);
                 alu_retired <= '1;
                alu_freeze <= '0;
                 alu_mem_access <= '0;
                 x_wr[alu_rd] <= '1;
                 addr  = rs1_data + { {20{alu_imm[11]}}, alu_imm[11:0]};
                 unique
                 case(addr[1:0])
                   'b00: rd_data <= {{24{'0}},bus_data_rd[7:0]};
                   'b01: rd_data <= {{24{'0}},bus_data_rd[15:8]};
                   'b10: rd_data <= {{24{'0}},bus_data_rd[23:16]};
                   'b11: rd_data <= {{24{'0}},bus_data_rd[31:24]};
                 endcase
                 mem_rdata <= bus_data_rd;
                 alu_PC_next <= alu_PC+'d4;
                 end
               end
      alu_LH : begin
               if(~alu_mem_access)
                 begin
                 bus_req   <= '1;
                 bus_write <= '0;
                 addr  = rs1_data + { {20{alu_imm[11]}}, alu_imm[11:0]};
                 bus_addr  <= addr;
                 bus_addr[1:0] <= '0;
                 unique
                 case(addr[1])
                   'b0: bus_data_rd_mask <= 'b0011;
                   'b1: bus_data_rd_mask <= 'b1100;
                 endcase
                 alu_freeze <= '1;
                 alu_mem_access <= '1;
                 end
               else if(bus_ack)
                 begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "LW", PC, alu_rs1, rs1_data, {{20{alu_imm[11]}},alu_imm[11:0]}, alu_rd);
                 alu_retired <= '1;
                alu_freeze <= '0;
                 alu_mem_access <= '0;
                 x_wr[alu_rd] <= '1;
                 addr  = rs1_data + { {20{alu_imm[11]}}, alu_imm[11:0]};
                 unique
                 case(addr[1])
                   'b0: rd_data <= {{16{bus_data_rd[15]}},bus_data_rd[15:0]};
                   'b1: rd_data <= {{16{bus_data_rd[31]}},bus_data_rd[31:16]};
                 endcase
                 mem_rdata <= bus_data_rd;
                 alu_PC_next <= alu_PC+'d4;
                 end
               end
      alu_LHU : begin
               if(~alu_mem_access)
                 begin
                 bus_req   <= '1;
                 bus_write <= '0;
                 addr  = rs1_data + { {20{alu_imm[11]}}, alu_imm[11:0]};
                 bus_addr  <= addr;
                 bus_addr[1:0] <= '0;
                 unique
                 case(addr[1])
                   'b0: bus_data_rd_mask <= 'b0011;
                   'b1: bus_data_rd_mask <= 'b1100;
                 endcase
                 alu_freeze <= '1;
                 alu_mem_access <= '1;
                 end
               else if(bus_ack)
                 begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "LW", PC, alu_rs1, rs1_data, {{20{alu_imm[11]}},alu_imm[11:0]}, alu_rd);
                 alu_retired <= '1;
                alu_freeze <= '0;
                 alu_mem_access <= '0;
                 x_wr[alu_rd] <= '1;
                 addr  = rs1_data + { {20{alu_imm[11]}}, alu_imm[11:0]};
                 unique
                 case(addr[1])
                   'b0: rd_data <= {{16{'0}},bus_data_rd[15:0]};
                   'b1: rd_data <= {{16{'0}},bus_data_rd[31:16]};
                 endcase
                 mem_rdata <= bus_data_rd;
                 alu_PC_next <= alu_PC+'d4;
                 end
               end
      alu_LW : begin
               if(~alu_mem_access)
                 begin
                 bus_req   <= '1;
                 bus_write <= '0;
                 addr  = rs1_data + { {20{alu_imm[11]}}, alu_imm[11:0]};
                 bus_addr  <= addr;
                 bus_addr[1:0] <= '0;
                 bus_data_rd_mask <= 'b1111;
                 alu_freeze <= '1;
                 alu_mem_access <= '1;
                 end
               else if(bus_ack)
                 begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "LW", PC, alu_rs1, rs1_data, {{20{alu_imm[11]}},alu_imm[11:0]}, alu_rd);
                 alu_retired <= '1;
                alu_freeze <= '0;
                 alu_mem_access <= '0;
                 x_wr[alu_rd] <= '1;
                 rd_data <= bus_data_rd;
                 mem_rdata <= bus_data_rd;
                 alu_PC_next <= alu_PC+'d4;
                 end
               end
      alu_SB : begin
               if(~alu_mem_access)
                 begin
                 bus_req   <= '1;
                 bus_write <= '1;
                 addr  = rs1_data + { {20{alu_imm[11]}}, alu_imm[11:0]};
                 bus_addr  <= addr;
                 bus_addr[1:0] <= '0;
                 unique
                 case(addr[1:0])
                   'b00: bus_data_wr  <= {{24{'0}},rs2_data[7:0]};
                   'b01: bus_data_wr  <= {{16{'0}},rs2_data[7:0],{8 {'0}}};
                   'b10: bus_data_wr  <= {{ 8{'0}},rs2_data[7:0],{16{'0}}};
                   'b11: bus_data_wr  <= {         rs2_data[7:0],{24{'0}}};
                 endcase
                 unique
                 case(addr[1:0])
                   'b00: bus_data_wr_mask <= 'b0001;
                   'b01: bus_data_wr_mask <= 'b0010;
                   'b10: bus_data_wr_mask <= 'b0100;
                   'b11: bus_data_wr_mask <= 'b1000;
                 endcase
                 alu_freeze <= '1;
                 alu_mem_access <= '1;
                 end
               else if(bus_ack)
                 begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "SW", PC, alu_rs1, rs1_data, alu_rs2, rs2_data, {{20{alu_imm[11]}},alu_imm[11:0]});
                 alu_retired <= '1;
                alu_freeze <= '0;
                 alu_mem_access <= '0;
                 alu_PC_next <= alu_PC+'d4;
                 end
               end
      alu_SH : begin
               if(~alu_mem_access)
                 begin
                 bus_req   <= '1;
                 bus_write <= '1;
                 addr  = rs1_data + { {20{alu_imm[11]}}, alu_imm[11:0]};
                 bus_addr  <= addr;
                 bus_addr[1:0] <= '0;
                 unique
                 case(addr[1])
                   'b0: bus_data_wr  <= {{16{'0}},rs2_data[15:0]};
                   'b1: bus_data_wr  <= {         rs2_data[15:0],{16{'0}}};
                 endcase
                 unique
                 case(addr[1])
                   'b0: bus_data_wr_mask <= 'b0011;
                   'b1: bus_data_wr_mask <= 'b1100;
                 endcase
                 alu_freeze <= '1;
                 alu_mem_access <= '1;
                 end
               else if(bus_ack)
                 begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "SW", PC, alu_rs1, rs1_data, alu_rs2, rs2_data, {{20{alu_imm[11]}},alu_imm[11:0]});
                 alu_retired <= '1;
                alu_freeze <= '0;
                 alu_mem_access <= '0;
                 alu_PC_next <= alu_PC+'d4;
                 end
               end
      alu_SW : begin
               if(~alu_mem_access)
                 begin
                 bus_req   <= '1;
                 bus_write <= '1;
                 addr  = rs1_data + { {20{alu_imm[11]}}, alu_imm[11:0]};
                 bus_addr  <= addr;
                 bus_addr[1:0] <= '0;
                 bus_data_wr  <= rs2_data;
                 bus_data_wr_mask <= 'b1111;
                 alu_freeze <= '1;
                 alu_mem_access <= '1;
                 end
               else if(bus_ack)
                 begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "SW", PC, alu_rs1, rs1_data, alu_rs2, rs2_data, {{20{alu_imm[11]}},alu_imm[11:0]});
                 alu_retired <= '1;
                 alu_freeze <= '0;
                 alu_mem_access <= '0;
                 alu_PC_next <= alu_PC+'d4;
                 end
               end


      alu_FENCE : begin
                  //$display("%-5s PC=%08X" , "FENCE", PC);
                  //TODO
                  alu_retired <= '1;
                alu_freeze <= '0;
                  alu_PC_next <= alu_PC+'d4;
                  end



      alu_ECALL : begin
                  //$display("%-5s PC=%08X" , "ECALL - !!TODO!!", PC);
                  alu_retired <= '1;
                alu_freeze <= '0;
                  alu_PC_next <= alu_PC+'d4;
                  end
      alu_CSRRW : begin
                  if(cnt=='d0)
                    begin
                    csr_req   <= '1;
                    csr_write <= '1;
                    csr_addr  <= alu_csr;
                    csr_mask  <= '1;
                    csr_data_wr  <= rs1_data;
                    alu_freeze <= '1;
                    cnt <= cnt + 1;
                    end
                  else if(cnt=='d2)
                    begin
                    //$display("%-5s CSR=%03X rs1=(%d)%08X rd=(%d)", "CSRRW", alu_csr, alu_rs1, rs1_data, alu_rd);
                    alu_retired <= '1;
                alu_freeze <= '0;
                    x_wr[alu_rd] <= '1;
                    rd_data <= '0;
                    rd_data <= csr_data_rd;
                    alu_PC_next <= alu_PC+'d4;
                    alu_freeze <= '0;
                    cnt <= '0;
                    end
                  else
                    begin
                    alu_freeze <= '1;
                    cnt <= cnt + 1;
                    end
                  end
      alu_CSRRS : begin
                  if(cnt=='d0)
                    begin
                    csr_req   <= '1;
                    if(alu_rs1 != '0)
                      begin
                      csr_write <= '1;
                      end
                    else
                      begin
                      csr_write <= '0;
                      end
                    csr_addr  <= alu_csr;
                    csr_mask  <= rs1_data;
                    csr_data_wr  <= '1;
                    alu_freeze <= '1;
                    cnt <= cnt + 1;
                    end
                  else if(cnt=='d2)
                    begin
                    //$display("%-5s CSR=%03X rs1=(%d)%08X rd=(%d)", "CSRRS", alu_csr, alu_rs1, rs1_data, alu_rd);
                    alu_retired <= '1;
                alu_freeze <= '0;
                    x_wr[alu_rd] <= '1;
                    rd_data <= '0;
                    rd_data <= csr_data_rd;
                    alu_PC_next <= alu_PC+'d4;
                    alu_freeze <= '0;
                    cnt <= '0;
                    end
                  else
                    begin
                    alu_freeze <= '1;
                    cnt <= cnt + 1;
                    end
                  end
      alu_CSRRC : begin
                  if(cnt=='d0)
                    begin
                    csr_req   <= '1;
                    if(alu_rs1 != '0)
                      begin
                      csr_write <= '1;
                      end
                    else
                      begin
                      csr_write <= '0;
                      end
                    csr_addr  <= alu_csr;
                    csr_mask  <= rs1_data;
                    csr_data_wr  <= '0;
                    alu_freeze <= '1;
                    cnt <= cnt + 1;
                    end
                  else if(cnt=='d2)
                    begin
                    //$display("%-5s CSR=%03X rs1=(%d)%08X rd=(%d)", "CSRRS", alu_csr, alu_rs1, rs1_data, alu_rd);
                    alu_retired <= '1;
                alu_freeze <= '0;
                    x_wr[alu_rd] <= '1;
                    rd_data <= '0;
                    rd_data <= csr_data_rd;
                    alu_PC_next <= alu_PC+'d4;
                    alu_freeze <= '0;
                    cnt <= '0;
                    end
                  else
                    begin
                    alu_freeze <= '1;
                    cnt <= cnt + 1;
                    end
                  end
      alu_CSRRWI : begin
                  if(cnt=='d0)
                    begin
                    csr_req   <= '1;
                    csr_write <= '1;
                    csr_addr  <= alu_csr;
                    csr_mask  <= '1;
                    csr_data_wr  <= '0;
                    csr_data_wr[4:0]  <= alu_uimm;
                    alu_freeze <= '1;
                    cnt <= cnt + 1;
                    end
                  else if(cnt=='d2)
                    begin
                    //$display("%-5s CSR=%03X rs1=(%d)%08X rd=(%d)", "CSRRWI", alu_csr, alu_rs1, rs1_data, alu_rd);
                    alu_retired <= '1;
                alu_freeze <= '0;
                    x_wr[alu_rd] <= '1;
                    rd_data <= '0;
                    rd_data <= csr_data_rd;
                    alu_PC_next <= alu_PC+'d4;
                    alu_freeze <= '0;
                    cnt <= '0;
                    end
                  else
                    begin
                    alu_freeze <= '1;
                    cnt <= cnt + 1;
                    end
                  end
      alu_CSRRSI : begin
                  if(cnt=='d0)
                    begin
                    csr_req   <= '1;
                    if(alu_uimm != '0)
                      begin
                      csr_write <= '1;
                      end
                    else
                      begin
                      csr_write <= '0;
                      end
                    csr_addr  <= alu_csr;
                    csr_mask  <= '1;
                    csr_data_wr  <= '0;
                    csr_data_wr[4:0]  <= alu_uimm;
                    alu_freeze <= '1;
                    cnt <= cnt + 1;
                    end
                  else if(cnt=='d2)
                    begin
                    //$display("%-5s CSR=%03X rs1=(%d)%08X rd=(%d)", "CSRRSI", alu_csr, alu_rs1, rs1_data, alu_rd);
                    alu_retired <= '1;
                alu_freeze <= '0;
                    x_wr[alu_rd] <= '1;
                    rd_data <= '0;
                    rd_data <= csr_data_rd;
                    alu_PC_next <= alu_PC+'d4;
                    alu_freeze <= '0;
                    cnt <= '0;
                    end
                  else
                    begin
                    alu_freeze <= '1;
                    cnt <= cnt + 1;
                    end
                  end
      alu_CSRRCI : begin
                  if(cnt=='d0)
                    begin
                    csr_req   <= '1;
                    if(alu_uimm != '0)
                      begin
                      csr_write <= '1;
                      end
                    else
                      begin
                      csr_write <= '0;
                      end
                    csr_addr  <= alu_csr;
                    csr_mask  <= '1;
                    csr_data_wr  <= '0;
                    csr_data_wr[4:0]  <= alu_uimm;
                    alu_freeze <= '1;
                    cnt <= cnt + 1;
                    end
                  else if(cnt=='d2)
                    begin
                    //$display("%-5s CSR=%03X rs1=(%d)%08X rd=(%d)", "CSRRCI", alu_csr, alu_rs1, rs1_data, alu_rd);
                    alu_retired <= '1;
                alu_freeze <= '0;
                    x_wr[alu_rd] <= '1;
                    rd_data <= '0;
                    rd_data <= csr_data_rd;
                    alu_PC_next <= alu_PC+'d4;
                    alu_freeze <= '0;
                    cnt <= '0;
                    end
                  else
                    begin
                    alu_freeze <= '1;
                    cnt <= cnt + 1;
                    end
                  end
      alu_EBREAK : begin
                   //TODO
                   //$display("%-5s PC=%08X" , "EBREAK - !!TODO!!", PC);
                   alu_retired <= '1;
                alu_freeze <= '0;
                   alu_PC_next <= alu_PC+'d4;
                   end
      alu_MUL    : begin
                   if(cnt=='d0)
                     begin
                     alu_freeze <= '1;
                     cnt <= cnt + 1;
                     end
                   else if(cnt=='d2)
                     begin
                     alu_retired <= '1;
                     alu_freeze <= '0;
                     x_wr[alu_rd] <= '1;
                     rd_data <= product[31:0];
                     alu_PC_next <= alu_PC+'d4;
                     alu_freeze <= '0;
                     cnt <= '0;
                     end
                   else
                     begin
                     alu_freeze <= '1;
                     cnt <= cnt + 1;
                     end
                   end
      alu_MULH   : begin
                   if(cnt=='d0)
                     begin
                     alu_freeze <= '1;
                     cnt <= cnt + 1;
                     end
                   else if(cnt=='d2)
                     begin
                     alu_retired <= '1;
                alu_freeze <= '0;
                     x_wr[alu_rd] <= '1;
                     rd_data <= product[63:32];
                     alu_PC_next <= alu_PC+'d4;
                     alu_freeze <= '0;
                     cnt <= '0;
                     end
                   else
                     begin
                     alu_freeze <= '1;
                     cnt <= cnt + 1;
                     end
                   end
      alu_MULHSU : begin
                   if(cnt=='d0)
                     begin
                     alu_freeze <= '1;
                     cnt <= cnt + 1;
                     end
                   else if(cnt=='d2)
                     begin
                     alu_retired <= '1;
                alu_freeze <= '0;
                     x_wr[alu_rd] <= '1;
                     rd_data <= product_unsigned[63:32];
                     alu_PC_next <= alu_PC+'d4;
                     alu_freeze <= '0;
                     cnt <= '0;
                     end
                   else
                     begin
                     alu_freeze <= '1;
                     cnt <= cnt + 1;
                     end
                   end
      alu_MULHU  : begin
                   if(cnt=='d0)
                     begin
                     alu_freeze <= '1;
                     cnt <= cnt + 1;
                     end
                   else if(cnt=='d2)
                     begin
                     alu_retired <= '1;
                alu_freeze <= '0;
                     x_wr[alu_rd] <= '1;
                     rd_data <= product_signed_unsigned[63:32];
                     alu_PC_next <= alu_PC+'d4;
                     alu_freeze <= '0;
                     cnt <= '0;
                     end
                   else
                     begin
                     alu_freeze <= '1;
                     cnt <= cnt + 1;
                     end
                   end
      alu_DIV    : begin
                   if(cnt=='d0)
                     begin
                     alu_freeze <= '1;
                     cnt <= cnt + 1;
                     end
                   else if(cnt=='d10)
                     begin
                     alu_retired <= '1;
                alu_freeze <= '0;
                     x_wr[alu_rd] <= '1;
                     rd_data <= quotient[31:0];
                     alu_PC_next <= alu_PC+'d4;
                     alu_freeze <= '0;
                     cnt <= '0;
                     end
                   else
                     begin
                     alu_freeze <= '1;
                     cnt <= cnt + 1;
                     end
                   end
      alu_DIVU   : begin
                   if(cnt=='d0)
                     begin
                     alu_freeze <= '1;
                     cnt <= cnt + 1;
                     end
                   else if(cnt=='d10)
                     begin
                     alu_retired <= '1;
                alu_freeze <= '0;
                     x_wr[alu_rd] <= '1;
                     rd_data <= quotient_unsigned[31:0];
                     alu_PC_next <= alu_PC+'d4;
                     alu_freeze <= '0;
                     cnt <= '0;
                     end
                   else
                     begin
                     alu_freeze <= '1;
                     cnt <= cnt + 1;
                     end
                   end
      alu_REM    : begin
                   if(cnt=='d0)
                     begin
                     alu_freeze <= '1;
                     cnt <= cnt + 1;
                     end
                   else if(cnt=='d10)
                     begin
                     alu_retired <= '1;
                alu_freeze <= '0;
                     x_wr[alu_rd] <= '1;
                     rd_data <= remainder[31:0];
                     alu_PC_next <= alu_PC+'d4;
                     alu_freeze <= '0;
                     cnt <= '0;
                     end
                   else
                     begin
                     alu_freeze <= '1;
                     cnt <= cnt + 1;
                     end
                   end
      alu_REMU   : begin
                   if(cnt=='d0)
                     begin
                     alu_freeze <= '1;
                     cnt <= cnt + 1;
                     end
                   else if(cnt=='d10)
                     begin
                     alu_retired <= '1;
                alu_freeze <= '0;
                     x_wr[alu_rd] <= '1;
                     rd_data <= remainder_unsigned[31:0];
                     alu_PC_next <= alu_PC+'d4;
                     alu_freeze <= '0;
                     cnt <= '0;
                     end
                   else
                     begin
                     alu_freeze <= '1;
                     cnt <= cnt + 1;
                     end
                   end
      alu_TRAP :   begin
                   //TODO
                   //$display("%0t %-5s PC=%08X : 0x%08f" , $time, "TRAP from IDU - !!TODO!!", alu_PC, alu_inst);
                   alu_retired <= '1;
                alu_freeze <= '0;
                   alu_trap <= '1;
                   end
          default : begin
                //$display("%0t %-5s PC=%08X : 0x%08X" , $time, "TRAP from INVALID INST!!", alu_PC, alu_inst);
                alu_retired <= '1;
                alu_freeze <= '0;
                alu_trap <= '1;
                end
              
      endcase

    if(alu_PC[1:0] != '0)
      begin
      //$display("%0t %-5s PC=%08X : 0x%08X" , $time, "TRAP from INVALID PC!!", alu_PC, alu_inst);
      alu_trap <= '1;
      end

    end

  if(alu_rd == '0)
    rd_data <= '0;

  if(rst)
    begin
    alu_vld <= '0;
    alu_retired <= '0;
    alu_mem_access <= '0;
    alu_freeze <= '0;
    alu_br <= '0;
    alu_br_miss <= '0;
    cnt <= '0;

    alu_PC <= '0;
    alu_PC_next <= '0;
    x_wr  <= '0;
    rd_data <= '0;

    csr_req   <= '0;
    csr_write <= '0;
    csr_addr  <= '0;
    csr_mask  <= '0;
    csr_data_wr  <= '0;

    bus_req   <= '0;
    bus_write <= '0;
    bus_addr  <= '0;
    bus_data_wr  <= '0 ;

    alu_inst    <= '0;
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
    alu_JAL     <= '0;
    alu_JALR    <= '0;
    alu_BEQ     <= '0;
    alu_BNE     <= '0;
    alu_BLT     <= '0;
    alu_BGE     <= '0;
    alu_BLTU    <= '0;
    alu_BGEU    <= '0;
    alu_LB      <= '0;
    alu_LH      <= '0;
    alu_LW      <= '0;
    alu_LBU     <= '0;
    alu_LHU     <= '0;
    alu_SB      <= '0;
    alu_SH      <= '0;
    alu_SW      <= '0;
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

    mem_rdata <= '0;
    end
  end

multiplier multiplier (
  .clock    (clk),
  .dataa  (rs1_data),
  .datab  (rs2_data),
  .result (product)
);

multiplier_unsigned multiplier_unsigned (
  .clock    (clk),
  .dataa  (rs1_data),
  .datab  (rs2_data),
  .result (product_unsigned)
);

multiplier_signed_unsigned multiplier_signed_unsigned (
  .clock    (clk),
  .dataa  (rs1_data),
  .datab  ({1'b0,rs2_data}),
  .result (product_signed_unsigned)
);

divider divider (
  .clock    (clk),
  .denom    (rs2_data),
  .numer    (rs1_data),
  .quotient (quotient),
  .remain   (remainder)
);

divider_unsigned divider_unsigned (
  .clock    (clk),
  .denom    (rs2_data),
  .numer    (rs1_data),
  .quotient (quotient_unsigned),
  .remain   (remainder_unsigned)
);

//RVFI interface
`ifdef RISCV_FORMAL
logic [63:0] order;
always_ff @(posedge clk)
  begin
  order <= order;
  if(alu_vld & alu_retired)
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
  rvfi_valid = alu_vld & alu_retired & ~alu_FENCE;
  rvfi_order = order;
  rvfi_insn = alu_inst;
  rvfi_trap = alu_trap;
  rvfi_halt = '0;
  rvfi_intr = '0;
  rvfi_mode = '0;
  rvfi_ixl = '0;
  rvfi_rs1_addr = alu_rs1;
  rvfi_rs2_addr = alu_rs2;
  rvfi_rs1_rdata = alu_rs1_data;
  rvfi_rs2_rdata = alu_rs2_data;
  rvfi_rd_addr = alu_rd;
  rvfi_rd_wdata = rd_data;
  rvfi_pc_rdata = alu_PC;
  rvfi_pc_wdata = alu_PC_next;
  rvfi_mem_addr = bus_addr;
  rvfi_mem_rmask = bus_data_rd_mask;
  rvfi_mem_wmask = bus_data_wr_mask;
  rvfi_mem_rdata = mem_rdata;
  rvfi_mem_wdata = bus_data_wr;

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
