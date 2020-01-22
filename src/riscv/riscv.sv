module riscv #(
  parameter M_EXT = 1
) (
  input  logic        clk,
  input  logic        rst,

`ifdef RISCV_FORMAL
  output reg   [5:0]       rvfi_valid,
  output reg   [5:0][63:0] rvfi_order,
  output reg   [5:0][31:0] rvfi_insn,
  output reg   [5:0]       rvfi_trap,
  output reg   [5:0]       rvfi_halt,
  output reg   [5:0]       rvfi_intr,
  output reg   [5:0][ 1:0] rvfi_mode,
  output reg   [5:0][ 1:0] rvfi_ixl,
  output reg   [5:0][ 4:0] rvfi_rs1_addr,
  output reg   [5:0][ 4:0] rvfi_rs2_addr,
  output reg   [5:0][31:0] rvfi_rs1_rdata,
  output reg   [5:0][31:0] rvfi_rs2_rdata,
  output reg   [5:0][ 4:0] rvfi_rd_addr,
  output reg   [5:0][31:0] rvfi_rd_wdata,
  output reg   [5:0][31:0] rvfi_pc_rdata,
  output reg   [5:0][31:0] rvfi_pc_wdata,
  output reg   [5:0][31:0] rvfi_mem_addr,
  output reg   [5:0][ 3:0] rvfi_mem_rmask,
  output reg   [5:0][ 3:0] rvfi_mem_wmask,
  output reg   [5:0][31:0] rvfi_mem_rdata,
  output reg   [5:0][31:0] rvfi_mem_wdata,

  output reg   [5:0][63:0] rvfi_csr_mcycle_rmask,
  output reg   [5:0][63:0] rvfi_csr_mcycle_wmask,
  output reg   [5:0][63:0] rvfi_csr_mcycle_rdata,
  output reg   [5:0][63:0] rvfi_csr_mcycle_wdata,

  output reg   [5:0][63:0] rvfi_csr_minstret_rmask,
  output reg   [5:0][63:0] rvfi_csr_minstret_wmask,
  output reg   [5:0][63:0] rvfi_csr_minstret_rdata,
  output reg   [5:0][63:0] rvfi_csr_minstret_wdata,
`endif

  output logic [31:0]      bus_inst_adr_o,
  output logic [31:0]      bus_inst_data_o,
  output logic             bus_inst_we_o,
  output logic  [3:0]      bus_inst_sel_o,
  output logic             bus_inst_stb_o,
  output logic             bus_inst_cyc_o,
  output logic             bus_inst_tga_o,
  output logic             bus_inst_tgd_o,
  output logic  [3:0]      bus_inst_tgc_o,

  input  logic             bus_inst_ack_i,
  input  logic             bus_inst_stall_i,
  input  logic             bus_inst_err_i,
  input  logic             bus_inst_rty_i,
  input  logic [31:0]      bus_inst_data_i,
  input  logic             bus_inst_tga_i,
  input  logic             bus_inst_tgd_i,
  input  logic  [3:0]      bus_inst_tgc_i,

  input  logic        i_membus_ack,
  input  logic [31:0] i_membus_data,

  output logic        o_membus_req,
  output logic        o_membus_write,
  output logic [31:0] o_membus_addr,
  output logic [31:0] o_membus_data,
  output logic  [3:0] o_membus_data_rd_mask,
  output logic  [3:0] o_membus_data_wr_mask
);

logic              csr_req;
logic              csr_ack;
logic              csr_write;
logic [31:0]       csr_addr;
logic [31:0]       csr_mask;
logic [31:0]       csr_data_wr;
logic [31:0]       csr_data_rd;

logic [31:0]       x_wr;
logic [31:0]       x00_in;
logic [31:0]       x01_in;
logic [31:0]       x02_in;
logic [31:0]       x03_in;
logic [31:0]       x04_in;
logic [31:0]       x05_in;
logic [31:0]       x06_in;
logic [31:0]       x07_in;
logic [31:0]       x08_in;
logic [31:0]       x09_in;
logic [31:0]       x10_in;
logic [31:0]       x11_in;
logic [31:0]       x12_in;
logic [31:0]       x13_in;
logic [31:0]       x14_in;
logic [31:0]       x15_in;
logic [31:0]       x16_in;
logic [31:0]       x17_in;
logic [31:0]       x18_in;
logic [31:0]       x19_in;
logic [31:0]       x20_in;
logic [31:0]       x21_in;
logic [31:0]       x22_in;
logic [31:0]       x23_in;
logic [31:0]       x24_in;
logic [31:0]       x25_in;
logic [31:0]       x26_in;
logic [31:0]       x27_in;
logic [31:0]       x28_in;
logic [31:0]       x29_in;
logic [31:0]       x30_in;
logic [31:0]       x31_in;
logic [31:0]       x00;
logic [31:0]       x01;
logic [31:0]       x02;
logic [31:0]       x03;
logic [31:0]       x04;
logic [31:0]       x05;
logic [31:0]       x06;
logic [31:0]       x07;
logic [31:0]       x08;
logic [31:0]       x09;
logic [31:0]       x10;
logic [31:0]       x11;
logic [31:0]       x12;
logic [31:0]       x13;
logic [31:0]       x14;
logic [31:0]       x15;
logic [31:0]       x16;
logic [31:0]       x17;
logic [31:0]       x18;
logic [31:0]       x19;
logic [31:0]       x20;
logic [31:0]       x21;
logic [31:0]       x22;
logic [31:0]       x23;
logic [31:0]       x24;
logic [31:0]       x25;
logic [31:0]       x26;
logic [31:0]       x27;
logic [31:0]       x28;
logic [31:0]       x29;
logic [31:0]       x30;
logic [31:0]       x31;

logic [31:0]       pre_ifu_PC;
logic              pre_ifu_br_pred_taken;
logic [31:0]       pre_ifu_br_pred_PC_next;

logic             ifu_req;
logic [31:0]      ifu_inst;
logic [63:0]      ifu_inst_order;
logic [31:0]      ifu_inst_PC;
logic             ifu_inst_br_taken;
logic [31:0]      ifu_inst_br_pred_PC_next;

logic [31:0]      idu_inst;
logic             idu_done;

logic             ifu_vld;
logic             idu_vld;
logic             idu_freeze;
logic [63:0]      idu_inst_order;
logic [31:0]      idu_inst_PC;
logic             idu_inst_br_taken;
logic [31:0]      idu_inst_br_pred_PC_next;

logic             dpu_vld;
logic             dpu_freeze;

logic             exu_vld;
logic [63:0]      exu_order_next;
logic             exu_retired;
logic             exu_freeze;
logic             exu_br;
logic             exu_br_taken;
logic [31:0]      exu_br_pred_PC_next;
logic             exu_br_miss;
logic [31:0]      exu_PC;
logic [31:0]      exu_PC_next;
logic             exu_trap;

logic [31:0]      inst;
logic  [3:0]      idu_decode_fm;
logic  [3:0]      idu_decode_pred;
logic  [3:0]      idu_decode_succ;
logic  [4:0]      idu_decode_shamt;
logic [31:0]      idu_decode_imm;
logic  [4:0]      idu_decode_uimm;
logic [11:0]      idu_decode_csr;
logic  [6:0]      idu_decode_funct7;
logic  [2:0]      idu_decode_funct3;
logic  [4:0]      idu_decode_rs2;
logic  [4:0]      idu_decode_rs1;
logic  [4:0]      idu_decode_rd;
logic  [6:0]      idu_decode_opcode;

logic             idu_decode_LUI;
logic             idu_decode_AUIPC;
logic             idu_decode_JAL;
logic             idu_decode_JALR;
logic             idu_decode_BEQ;
logic             idu_decode_BNE;
logic             idu_decode_BLT;
logic             idu_decode_BGE;
logic             idu_decode_BLTU;
logic             idu_decode_BGEU;
logic             idu_decode_LB;
logic             idu_decode_LH;
logic             idu_decode_LW;
logic             idu_decode_LBU;
logic             idu_decode_LHU;
logic             idu_decode_SB;
logic             idu_decode_SH;
logic             idu_decode_SW;
logic             idu_decode_ADDI;
logic             idu_decode_SLTI;
logic             idu_decode_SLTIU;
logic             idu_decode_XORI;
logic             idu_decode_ORI;
logic             idu_decode_ANDI;
logic             idu_decode_SLLI;
logic             idu_decode_SRLI;
logic             idu_decode_SRAI;
logic             idu_decode_ADD;
logic             idu_decode_SUB;
logic             idu_decode_SLL;
logic             idu_decode_SLT;
logic             idu_decode_SLTU;
logic             idu_decode_XOR;
logic             idu_decode_SRL;
logic             idu_decode_SRA;
logic             idu_decode_OR;
logic             idu_decode_AND;
logic             idu_decode_FENCE;
logic             idu_decode_FENCE_I;
logic             idu_decode_ECALL;
logic             idu_decode_CSRRW;
logic             idu_decode_CSRRS;
logic             idu_decode_CSRRC;
logic             idu_decode_CSRRWI;
logic             idu_decode_CSRRSI;
logic             idu_decode_CSRRCI;
logic             idu_decode_EBREAK;
logic             idu_decode_MUL;
logic             idu_decode_MULH;
logic             idu_decode_MULHSU;
logic             idu_decode_MULHU;
logic             idu_decode_DIV;
logic             idu_decode_DIVU;
logic             idu_decode_REM;
logic             idu_decode_REMU;
logic             idu_decode_TRAP;

riscv_regfile regfile (
  .clk   (clk),
  .rst   (rst),

  .x_wr  (x_wr ),
  .x00_in         (x00_in  ),
  .x01_in         (x01_in  ),
  .x02_in         (x02_in  ),
  .x03_in         (x03_in  ),
  .x04_in         (x04_in  ),
  .x05_in         (x05_in  ),
  .x06_in         (x06_in  ),
  .x07_in         (x07_in  ),
  .x08_in         (x08_in  ),
  .x09_in         (x09_in  ),
  .x10_in         (x10_in  ),
  .x11_in         (x11_in  ),
  .x12_in         (x12_in  ),
  .x13_in         (x13_in  ),
  .x14_in         (x14_in  ),
  .x15_in         (x15_in  ),
  .x16_in         (x16_in  ),
  .x17_in         (x17_in  ),
  .x18_in         (x18_in  ),
  .x19_in         (x19_in  ),
  .x20_in         (x20_in  ),
  .x21_in         (x21_in  ),
  .x22_in         (x22_in  ),
  .x23_in         (x23_in  ),
  .x24_in         (x24_in  ),
  .x25_in         (x25_in  ),
  .x26_in         (x26_in  ),
  .x27_in         (x27_in  ),
  .x28_in         (x28_in  ),
  .x29_in         (x29_in  ),
  .x30_in         (x30_in  ),
  .x31_in         (x31_in  ),
  .x00            (x00     ),
  .x01            (x01     ),
  .x02            (x02     ),
  .x03            (x03     ),
  .x04            (x04     ),
  .x05            (x05     ),
  .x06            (x06     ),
  .x07            (x07     ),
  .x08            (x08     ),
  .x09            (x09     ),
  .x10            (x10     ),
  .x11            (x11     ),
  .x12            (x12     ),
  .x13            (x13     ),
  .x14            (x14     ),
  .x15            (x15     ),
  .x16            (x16     ),
  .x17            (x17     ),
  .x18            (x18     ),
  .x19            (x19     ),
  .x20            (x20     ),
  .x21            (x21     ),
  .x22            (x22     ),
  .x23            (x23     ),
  .x24            (x24     ),
  .x25            (x25     ),
  .x26            (x26     ),
  .x27            (x27     ),
  .x28            (x28     ),
  .x29            (x29     ),
  .x30            (x30     ),
  .x31            (x31     )
);

riscv_csr csrfile (
  .clk         (clk),
  .rst         (rst),

  .alu_vld          (exu_vld),
  .alu_retired    (exu_retired),
  .alu_br         (exu_br),
  .alu_br_miss    (exu_br_miss),

  .csr_req     (csr_req),   
  .csr_ack     (csr_ack),   
  .csr_write   (csr_write), 
  .csr_addr    (csr_addr),  
  .csr_mask    (csr_mask),  
  .csr_data_wr (csr_data_wr), 
  .csr_data_rd (csr_data_rd)  
);

riscv_br_pred br_pred (
  .clk         (clk),
  .rst         (rst),

  .pre_ifu_PC          (pre_ifu_PC),         
  .pre_ifu_br_pred_taken (pre_ifu_br_pred_taken),
  .pre_ifu_br_pred_PC_next  (pre_ifu_br_pred_PC_next), 

  .alu_vld        (exu_vld),
  .alu_retired    (exu_retired),
  .alu_br         (exu_br),
  .alu_br_taken   (exu_br_taken),
  .alu_br_miss    (exu_br_miss),
  .alu_PC         (exu_PC),
  .alu_PC_next    (exu_PC_next)
);

riscv_ifu ifu (
  .clk            (clk),
  .rst            (rst),

  .exu_vld        (exu_vld),
  .exu_order_next (exu_order_next),
  .exu_retired    (exu_retired),
  .exu_freeze     (exu_freeze | (dpu_vld & dpu_freeze)),
  .exu_br_miss    (exu_br_miss),
  .exu_trap       (exu_trap),
  .exu_PC_next    (exu_PC_next),

  .idu_vld   (idu_vld),
  .idu_freeze   (idu_freeze),

  .pre_ifu_PC          (pre_ifu_PC),         
  .pre_ifu_br_pred_taken (pre_ifu_br_pred_taken),
  .pre_ifu_br_pred_PC_next  (pre_ifu_br_pred_PC_next), 

  .ifu_vld        (ifu_vld),
  .ifu_inst       (ifu_inst),
  .ifu_inst_order       (ifu_inst_order),
  .ifu_inst_PC    (ifu_inst_PC),
  .ifu_inst_br_taken    (ifu_inst_br_taken),
  .ifu_inst_br_pred_PC_next    (ifu_inst_br_pred_PC_next),

  .bus_inst_adr_o   (bus_inst_adr_o), 
  .bus_inst_data_o  (bus_inst_data_o),
  .bus_inst_we_o    (bus_inst_we_o),  
  .bus_inst_sel_o   (bus_inst_sel_o), 
  .bus_inst_stb_o   (bus_inst_stb_o), 
  .bus_inst_cyc_o   (bus_inst_cyc_o), 
  .bus_inst_tga_o   (bus_inst_tga_o), 
  .bus_inst_tgd_o   (bus_inst_tgd_o), 
  .bus_inst_tgc_o   (bus_inst_tgc_o), 
                                     
  .bus_inst_ack_i   (bus_inst_ack_i), 
  .bus_inst_stall_i (bus_inst_stall_i),
  .bus_inst_err_i   (bus_inst_err_i), 
  .bus_inst_rty_i   (bus_inst_rty_i), 
  .bus_inst_data_i  (bus_inst_data_i), 
  .bus_inst_tga_i   (bus_inst_tga_i), 
  .bus_inst_tgd_i   (bus_inst_tgd_i), 
  .bus_inst_tgc_i   (bus_inst_tgc_i) 
);

riscv_idu #(.M_EXT(M_EXT)) idu (
  .clk       (clk),
  .rst       (rst),

  .ifu_vld   (ifu_vld),
  .ifu_inst  (ifu_inst),
  .ifu_inst_order       (ifu_inst_order),
  .ifu_inst_PC    (ifu_inst_PC),
  .ifu_inst_br_taken    (ifu_inst_br_taken),
  .ifu_inst_br_pred_PC_next    (ifu_inst_br_pred_PC_next),
                             
  .alu_vld        (exu_vld),
  .alu_retired    (exu_retired),
  .alu_freeze     (exu_freeze | (dpu_vld & dpu_freeze)),
  .alu_br_miss    (exu_br_miss),
  .alu_trap       (exu_trap),

  .idu_vld   (idu_vld),
  .idu_freeze   (idu_freeze),
  .idu_inst    (idu_inst),
  .idu_inst_order       (idu_inst_order),
  .idu_inst_PC    (idu_inst_PC),
  .idu_inst_br_taken    (idu_inst_br_taken),
  .idu_inst_br_pred_PC_next    (idu_inst_br_pred_PC_next),

  .idu_decode_fm        (idu_decode_fm      ),
  .idu_decode_pred      (idu_decode_pred    ),
  .idu_decode_succ      (idu_decode_succ    ),
  .idu_decode_shamt     (idu_decode_shamt   ),
  .idu_decode_imm       (idu_decode_imm     ),
  .idu_decode_uimm      (idu_decode_uimm    ),
  .idu_decode_csr       (idu_decode_csr     ),
  .idu_decode_funct7    (idu_decode_funct7  ),
  .idu_decode_funct3    (idu_decode_funct3  ),
  .idu_decode_rs2       (idu_decode_rs2     ),
  .idu_decode_rs1       (idu_decode_rs1     ),
  .idu_decode_rd        (idu_decode_rd      ),
  .idu_decode_opcode    (idu_decode_opcode  ),
                             
  .idu_decode_LUI       (idu_decode_LUI     ),
  .idu_decode_AUIPC     (idu_decode_AUIPC   ),
  .idu_decode_JAL       (idu_decode_JAL     ),
  .idu_decode_JALR      (idu_decode_JALR    ),
  .idu_decode_BEQ       (idu_decode_BEQ     ),
  .idu_decode_BNE       (idu_decode_BNE     ),
  .idu_decode_BLT       (idu_decode_BLT     ),
  .idu_decode_BGE       (idu_decode_BGE     ),
  .idu_decode_BLTU      (idu_decode_BLTU    ),
  .idu_decode_BGEU      (idu_decode_BGEU    ),
  .idu_decode_LB        (idu_decode_LB      ),
  .idu_decode_LH        (idu_decode_LH      ),
  .idu_decode_LW        (idu_decode_LW      ),
  .idu_decode_LBU       (idu_decode_LBU     ),
  .idu_decode_LHU       (idu_decode_LHU     ),
  .idu_decode_SB        (idu_decode_SB      ),
  .idu_decode_SH        (idu_decode_SH      ),
  .idu_decode_SW        (idu_decode_SW      ),
  .idu_decode_ADDI      (idu_decode_ADDI    ),
  .idu_decode_SLTI      (idu_decode_SLTI    ),
  .idu_decode_SLTIU     (idu_decode_SLTIU   ),
  .idu_decode_XORI      (idu_decode_XORI    ),
  .idu_decode_ORI       (idu_decode_ORI     ),
  .idu_decode_ANDI      (idu_decode_ANDI    ),
  .idu_decode_SLLI      (idu_decode_SLLI    ),
  .idu_decode_SRLI      (idu_decode_SRLI    ),
  .idu_decode_SRAI      (idu_decode_SRAI    ),
  .idu_decode_ADD       (idu_decode_ADD     ),
  .idu_decode_SUB       (idu_decode_SUB     ),
  .idu_decode_SLL       (idu_decode_SLL     ),
  .idu_decode_SLT       (idu_decode_SLT     ),
  .idu_decode_SLTU      (idu_decode_SLTU    ),
  .idu_decode_XOR       (idu_decode_XOR     ),
  .idu_decode_SRL       (idu_decode_SRL     ),
  .idu_decode_SRA       (idu_decode_SRA     ),
  .idu_decode_OR        (idu_decode_OR      ),
  .idu_decode_AND       (idu_decode_AND     ),
  .idu_decode_FENCE     (idu_decode_FENCE   ),
  .idu_decode_FENCE_I   (idu_decode_FENCE_I ),
  .idu_decode_ECALL     (idu_decode_ECALL   ),
  .idu_decode_CSRRW     (idu_decode_CSRRW   ),
  .idu_decode_CSRRS     (idu_decode_CSRRS   ),
  .idu_decode_CSRRC     (idu_decode_CSRRC   ),
  .idu_decode_CSRRWI    (idu_decode_CSRRWI  ),
  .idu_decode_CSRRSI    (idu_decode_CSRRSI  ),
  .idu_decode_CSRRCI    (idu_decode_CSRRCI  ),
  .idu_decode_EBREAK    (idu_decode_EBREAK  ),
  .idu_decode_MUL       (idu_decode_MUL     ),
  .idu_decode_MULH      (idu_decode_MULH    ),
  .idu_decode_MULHSU    (idu_decode_MULHSU  ),
  .idu_decode_MULHU     (idu_decode_MULHU   ),
  .idu_decode_DIV       (idu_decode_DIV     ),
  .idu_decode_DIVU      (idu_decode_DIVU    ),
  .idu_decode_REM       (idu_decode_REM     ),
  .idu_decode_REMU      (idu_decode_REMU    ),
  .idu_decode_TRAP      (idu_decode_TRAP    )
);

riscv_exu #(.M_EXT(M_EXT)) exu (
  .clk            (clk     ),
  .rst            (rst     ),

`ifdef RISCV_FORMAL
  .rvfi_valid              (rvfi_valid             ),
  .rvfi_order              (rvfi_order             ),
  .rvfi_insn               (rvfi_insn              ),
  .rvfi_trap               (rvfi_trap              ),
  .rvfi_halt               (rvfi_halt              ),
  .rvfi_intr               (rvfi_intr              ),
  .rvfi_mode               (rvfi_mode              ),
  .rvfi_ixl                (rvfi_ixl               ),
  .rvfi_rs1_addr           (rvfi_rs1_addr          ),
  .rvfi_rs2_addr           (rvfi_rs2_addr          ),
  .rvfi_rs1_rdata          (rvfi_rs1_rdata         ),
  .rvfi_rs2_rdata          (rvfi_rs2_rdata         ),
  .rvfi_rd_addr            (rvfi_rd_addr           ),
  .rvfi_rd_wdata           (rvfi_rd_wdata          ),
  .rvfi_pc_rdata           (rvfi_pc_rdata          ),
  .rvfi_pc_wdata           (rvfi_pc_wdata          ),
  .rvfi_mem_addr           (rvfi_mem_addr          ),
  .rvfi_mem_rmask          (rvfi_mem_rmask         ),
  .rvfi_mem_wmask          (rvfi_mem_wmask         ),
  .rvfi_mem_rdata          (rvfi_mem_rdata         ),
  .rvfi_mem_wdata          (rvfi_mem_wdata         ),

  .rvfi_csr_mcycle_rmask   (rvfi_csr_mcycle_rmask  ),
  .rvfi_csr_mcycle_wmask   (rvfi_csr_mcycle_wmask  ),
  .rvfi_csr_mcycle_rdata   (rvfi_csr_mcycle_rdata  ),
  .rvfi_csr_mcycle_wdata   (rvfi_csr_mcycle_wdata  ),

  .rvfi_csr_minstret_rmask (rvfi_csr_minstret_rmask),
  .rvfi_csr_minstret_wmask (rvfi_csr_minstret_wmask),
  .rvfi_csr_minstret_rdata (rvfi_csr_minstret_rdata),
  .rvfi_csr_minstret_wdata (rvfi_csr_minstret_wdata),
`endif
                             
  .dpu_vld        (dpu_vld),
  .dpu_freeze     (dpu_freeze),

  .exu_vld          (exu_vld),
  .exu_order_next    (exu_order_next),
  .exu_retired    (exu_retired),
  .exu_freeze     (exu_freeze),
  .exu_br         (exu_br),
  .exu_br_taken   (exu_br_taken),
  .exu_br_miss      (exu_br_miss),
  .exu_trap       (exu_trap),
  .exu_PC         (exu_PC),
  .exu_PC_next    (exu_PC_next),
                               
  .idu_vld          (idu_vld),
  .idu_inst             (idu_inst    ),
  .idu_inst_order       (idu_inst_order),
  .idu_inst_PC    (idu_inst_PC),
  .idu_inst_br_taken    (idu_inst_br_taken),
  .idu_inst_br_pred_PC_next    (idu_inst_br_pred_PC_next),
  .idu_decode_fm               (idu_decode_fm      ),
  .idu_decode_pred             (idu_decode_pred    ),
  .idu_decode_succ             (idu_decode_succ    ),
  .idu_decode_shamt            (idu_decode_shamt   ),
  .idu_decode_imm              (idu_decode_imm     ),
  .idu_decode_uimm             (idu_decode_uimm    ),
  .idu_decode_csr              (idu_decode_csr     ),
  .idu_decode_funct7           (idu_decode_funct7  ),
  .idu_decode_funct3           (idu_decode_funct3  ),
  .idu_decode_rs2              (idu_decode_rs2     ),
  .idu_decode_rs1              (idu_decode_rs1     ),
  .idu_decode_rd               (idu_decode_rd      ),
  .idu_decode_opcode           (idu_decode_opcode  ),
                                    
  .idu_decode_LUI              (idu_decode_LUI     ),
  .idu_decode_AUIPC            (idu_decode_AUIPC   ),
  .idu_decode_JAL              (idu_decode_JAL     ),
  .idu_decode_JALR             (idu_decode_JALR    ),
  .idu_decode_BEQ              (idu_decode_BEQ     ),
  .idu_decode_BNE              (idu_decode_BNE     ),
  .idu_decode_BLT              (idu_decode_BLT     ),
  .idu_decode_BGE              (idu_decode_BGE     ),
  .idu_decode_BLTU             (idu_decode_BLTU    ),
  .idu_decode_BGEU             (idu_decode_BGEU    ),
  .idu_decode_LB               (idu_decode_LB      ),
  .idu_decode_LH               (idu_decode_LH      ),
  .idu_decode_LW               (idu_decode_LW      ),
  .idu_decode_LBU              (idu_decode_LBU     ),
  .idu_decode_LHU              (idu_decode_LHU     ),
  .idu_decode_SB               (idu_decode_SB      ),
  .idu_decode_SH               (idu_decode_SH      ),
  .idu_decode_SW               (idu_decode_SW      ),
  .idu_decode_ADDI             (idu_decode_ADDI    ),
  .idu_decode_SLTI             (idu_decode_SLTI    ),
  .idu_decode_SLTIU            (idu_decode_SLTIU   ),
  .idu_decode_XORI             (idu_decode_XORI    ),
  .idu_decode_ORI              (idu_decode_ORI     ),
  .idu_decode_ANDI             (idu_decode_ANDI    ),
  .idu_decode_SLLI             (idu_decode_SLLI    ),
  .idu_decode_SRLI             (idu_decode_SRLI    ),
  .idu_decode_SRAI             (idu_decode_SRAI    ),
  .idu_decode_ADD              (idu_decode_ADD     ),
  .idu_decode_SUB              (idu_decode_SUB     ),
  .idu_decode_SLL              (idu_decode_SLL     ),
  .idu_decode_SLT              (idu_decode_SLT     ),
  .idu_decode_SLTU             (idu_decode_SLTU    ),
  .idu_decode_XOR              (idu_decode_XOR     ),
  .idu_decode_SRL              (idu_decode_SRL     ),
  .idu_decode_SRA              (idu_decode_SRA     ),
  .idu_decode_OR               (idu_decode_OR      ),
  .idu_decode_AND              (idu_decode_AND     ),
  .idu_decode_FENCE            (idu_decode_FENCE   ),
  .idu_decode_FENCE_I          (idu_decode_FENCE_I ),
  .idu_decode_ECALL            (idu_decode_ECALL   ),
  .idu_decode_CSRRW            (idu_decode_CSRRW   ),
  .idu_decode_CSRRS            (idu_decode_CSRRS   ),
  .idu_decode_CSRRC            (idu_decode_CSRRC   ),
  .idu_decode_CSRRWI           (idu_decode_CSRRWI  ),
  .idu_decode_CSRRSI           (idu_decode_CSRRSI  ),
  .idu_decode_CSRRCI           (idu_decode_CSRRCI  ),
  .idu_decode_EBREAK           (idu_decode_EBREAK  ),
  .idu_decode_MUL              (idu_decode_MUL     ),
  .idu_decode_MULH             (idu_decode_MULH    ),
  .idu_decode_MULHSU           (idu_decode_MULHSU  ),
  .idu_decode_MULHU            (idu_decode_MULHU   ),
  .idu_decode_DIV              (idu_decode_DIV     ),
  .idu_decode_DIVU             (idu_decode_DIVU    ),
  .idu_decode_REM              (idu_decode_REM     ),
  .idu_decode_REMU             (idu_decode_REMU    ),
  .idu_decode_TRAP             (idu_decode_TRAP    ),
                                    
  .x_wr             (x_wr    ),
  .x00_in           (x00_in  ),
  .x01_in           (x01_in  ),
  .x02_in           (x02_in  ),
  .x03_in           (x03_in  ),
  .x04_in           (x04_in  ),
  .x05_in           (x05_in  ),
  .x06_in           (x06_in  ),
  .x07_in           (x07_in  ),
  .x08_in           (x08_in  ),
  .x09_in           (x09_in  ),
  .x10_in           (x10_in  ),
  .x11_in           (x11_in  ),
  .x12_in           (x12_in  ),
  .x13_in           (x13_in  ),
  .x14_in           (x14_in  ),
  .x15_in           (x15_in  ),
  .x16_in           (x16_in  ),
  .x17_in           (x17_in  ),
  .x18_in           (x18_in  ),
  .x19_in           (x19_in  ),
  .x20_in           (x20_in  ),
  .x21_in           (x21_in  ),
  .x22_in           (x22_in  ),
  .x23_in           (x23_in  ),
  .x24_in           (x24_in  ),
  .x25_in           (x25_in  ),
  .x26_in           (x26_in  ),
  .x27_in           (x27_in  ),
  .x28_in           (x28_in  ),
  .x29_in           (x29_in  ),
  .x30_in           (x30_in  ),
  .x31_in           (x31_in  ),
  .x00              (x00     ),
  .x01              (x01     ),
  .x02              (x02     ),
  .x03              (x03     ),
  .x04              (x04     ),
  .x05              (x05     ),
  .x06              (x06     ),
  .x07              (x07     ),
  .x08              (x08     ),
  .x09              (x09     ),
  .x10              (x10     ),
  .x11              (x11     ),
  .x12              (x12     ),
  .x13              (x13     ),
  .x14              (x14     ),
  .x15              (x15     ),
  .x16              (x16     ),
  .x17              (x17     ),
  .x18              (x18     ),
  .x19              (x19     ),
  .x20              (x20     ),
  .x21              (x21     ),
  .x22              (x22     ),
  .x23              (x23     ),
  .x24              (x24     ),
  .x25              (x25     ),
  .x26              (x26     ),
  .x27              (x27     ),
  .x28              (x28     ),
  .x29              (x29     ),
  .x30              (x30     ),
  .x31              (x31     ),

  .csr_req          (csr_req),   
  .csr_ack          (csr_ack),   
  .csr_write        (csr_write), 
  .csr_addr         (csr_addr),  
  .csr_mask         (csr_mask),  
  .csr_data_wr      (csr_data_wr),
  .csr_data_rd      (csr_data_rd),

  .bus_req          (o_membus_req),   
  .bus_ack          (i_membus_ack),   
  .bus_write        (o_membus_write), 
  .bus_addr         (o_membus_addr),  
  .bus_data_wr      (o_membus_data),
  .bus_data_rd      (i_membus_data),
  .bus_data_rd_mask (o_membus_data_rd_mask),
  .bus_data_wr_mask (o_membus_data_wr_mask)
);

endmodule
