module riscv (
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

  input  logic        i_instbus_req,
  input  logic        i_instbus_ack,
  input  logic        i_instbus_write,
  input  logic [31:0] i_instbus_addr,
  input  logic [31:0] i_instbus_data,

  output logic        o_instbus_req,
  output logic        o_instbus_ack,
  output logic        o_instbus_write,
  output logic [31:0] o_instbus_addr,
  output logic [31:0] o_instbus_data,

  input  logic        i_membus_req,
  input  logic        i_membus_ack,
  input  logic        i_membus_write,
  input  logic [31:0] i_membus_addr,
  input  logic [31:0] i_membus_data,

  output logic        o_membus_req,
  output logic        o_membus_ack,
  output logic        o_membus_write,
  output logic [31:0] o_membus_addr,
  output logic [31:0] o_membus_data
);

logic              csr_req;
logic              csr_ack;
logic              csr_write;
logic [31:0]       csr_addr;
logic [31:0]       csr_mask;
logic [31:0]       csr_data_wr;
logic [31:0]       csr_data_rd;

logic              PC_wr;
logic [31:0]       PC_in;
logic [31:0]       PC;

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

logic             ifu_req;
logic [31:0]      ifu_inst;
logic [31:0]      ifu_inst_PC;

logic             idu_rdy;
logic             idu_req;
logic [31:0]      idu_inst;
logic             idu_done;

logic             ifu_vld;
logic             idu_vld;
logic [31:0]      idu_inst_PC;
logic             alu_vld;
logic             alu_br_miss;

logic [31:0]      inst;
logic  [3:0]      fm;
logic  [3:0]      pred;
logic  [3:0]      succ;
logic  [4:0]      shamt;
logic [31:0]      imm;
logic  [4:0]      uimm;
logic [11:0]      csr;
logic  [6:0]      funct7;
logic  [2:0]      funct3;
logic  [4:0]      rs2;
logic  [4:0]      rs1;
logic  [4:0]      rd;
logic  [6:0]      opcode;

logic             LUI;
logic             AUIPC;
logic             JAL;
logic             JALR;
logic             BEQ;
logic             BNE;
logic             BLT;
logic             BGE;
logic             BLTU;
logic             BGEU;
logic             LB;
logic             LH;
logic             LW;
logic             LBU;
logic             LHU;
logic             SB;
logic             SH;
logic             SW;
logic             ADDI;
logic             SLTI;
logic             SLTIU;
logic             XORI;
logic             ORI;
logic             ANDI;
logic             SLLI;
logic             SRLI;
logic             SRAI;
logic             ADD;
logic             SUB;
logic             SLL;
logic             SLT;
logic             SLTU;
logic             XOR;
logic             SRL;
logic             SRA;
logic             OR;
logic             AND;
logic             FENCE;
logic             FENCE_I;
logic             ECALL;
logic             CSRRW;
logic             CSRRS;
logic             CSRRC;
logic             CSRRWI;
logic             CSRRSI;
logic             CSRRCI;
logic             EBREAK;
logic             TRAP;

riscv_regfile regfile (
  .clk   (clk),
  .rst   (rst),

  //.PC_wr (PC_wr),
  //.PC_in (PC_in),
  //.PC    (PC   ),

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

  .csr_req     (csr_req),   
  .csr_ack     (csr_ack),   
  .csr_write   (csr_write), 
  .csr_addr    (csr_addr),  
  .csr_mask    (csr_mask),  
  .csr_data_wr (csr_data_wr), 
  .csr_data_rd (csr_data_rd)  
);

assign o_instbus_ack = '0;
riscv_ifu ifu (
  .clk            (clk),
  .rst            (rst),

  .alu_vld        (alu_vld),
  .alu_br_miss    (alu_br_miss),
  .PC_in          (PC_in),

  .ifu_vld        (ifu_vld),
  .ifu_inst       (ifu_inst),
  .ifu_inst_PC    (ifu_inst_PC),

  .o_instbus_req   (o_instbus_req),   
  .o_instbus_write (o_instbus_write), 
  .o_instbus_addr  (o_instbus_addr),  
  .o_instbus_data  (o_instbus_data),

  .i_instbus_ack   (i_instbus_ack),   
  .i_instbus_addr  (i_instbus_addr),  
  .i_instbus_data  (i_instbus_data)  
);

riscv_idu idu (
  .clk       (clk),
  .rst       (rst),

  .ifu_vld   (ifu_vld),
  .ifu_inst  (ifu_inst),
  .ifu_inst_PC    (ifu_inst_PC),
  .idu_vld   (idu_vld),
  .idu_inst_PC    (idu_inst_PC),

  .idu_rdy   (idu_rdy),
  .idu_req   (idu_req),
                             
  .alu_vld        (alu_vld),
  .alu_br_miss    (alu_br_miss),

  .inst           (inst    ),
  .fm        (fm      ),
  .pred      (pred    ),
  .succ      (succ    ),
  .shamt     (shamt   ),
  .imm       (imm     ),
  .uimm      (uimm    ),
  .csr       (csr     ),
  .funct7    (funct7  ),
  .funct3    (funct3  ),
  .rs2       (rs2     ),
  .rs1       (rs1     ),
  .rd        (rd      ),
  .opcode    (opcode  ),
                             
  .LUI       (LUI     ),
  .AUIPC     (AUIPC   ),
  .JAL       (JAL     ),
  .JALR      (JALR    ),
  .BEQ       (BEQ     ),
  .BNE       (BNE     ),
  .BLT       (BLT     ),
  .BGE       (BGE     ),
  .BLTU      (BLTU    ),
  .BGEU      (BGEU    ),
  .LB        (LB      ),
  .LH        (LH      ),
  .LW        (LW      ),
  .LBU       (LBU     ),
  .LHU       (LHU     ),
  .SB        (SB      ),
  .SH        (SH      ),
  .SW        (SW      ),
  .ADDI      (ADDI    ),
  .SLTI      (SLTI    ),
  .SLTIU     (SLTIU   ),
  .XORI      (XORI    ),
  .ORI       (ORI     ),
  .ANDI      (ANDI    ),
  .SLLI      (SLLI    ),
  .SRLI      (SRLI    ),
  .SRAI      (SRAI    ),
  .ADD       (ADD     ),
  .SUB       (SUB     ),
  .SLL       (SLL     ),
  .SLT       (SLT     ),
  .SLTU      (SLTU    ),
  .XOR       (XOR     ),
  .SRL       (SRL     ),
  .SRA       (SRA     ),
  .OR        (OR      ),
  .AND       (AND     ),
  .FENCE     (FENCE   ),
  .FENCE_I   (FENCE_I ),
  .ECALL     (ECALL   ),
  .CSRRW     (CSRRW   ),
  .CSRRS     (CSRRS   ),
  .CSRRC     (CSRRC   ),
  .CSRRWI    (CSRRWI  ),
  .CSRRSI    (CSRRSI  ),
  .CSRRCI    (CSRRCI  ),
  .EBREAK    (EBREAK  ),
  .TRAP      (TRAP    )
);

assign o_membus_ack = '0;
riscv_alu alu (
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
                             
  .idu_vld        (idu_vld),
  .alu_vld        (alu_vld),
  .alu_br_miss    (alu_br_miss),
                             
  .inst           (inst    ),
  .fm             (fm      ),
  .pred           (pred    ),
  .succ           (succ    ),
  .shamt          (shamt   ),
  .imm            (imm     ),
  .uimm           (uimm    ),
  .csr            (csr     ),
  .funct7         (funct7  ),
  .funct3         (funct3  ),
  .rs2            (rs2     ),
  .rs1            (rs1     ),
  .rd             (rd      ),
  .opcode         (opcode  ),
                                  
  .LUI            (LUI     ),
  .AUIPC          (AUIPC   ),
  .JAL            (JAL     ),
  .JALR           (JALR    ),
  .BEQ            (BEQ     ),
  .BNE            (BNE     ),
  .BLT            (BLT     ),
  .BGE            (BGE     ),
  .BLTU           (BLTU    ),
  .BGEU           (BGEU    ),
  .LB             (LB      ),
  .LH             (LH      ),
  .LW             (LW      ),
  .LBU            (LBU     ),
  .LHU            (LHU     ),
  .SB             (SB      ),
  .SH             (SH      ),
  .SW             (SW      ),
  .ADDI           (ADDI    ),
  .SLTI           (SLTI    ),
  .SLTIU          (SLTIU   ),
  .XORI           (XORI    ),
  .ORI            (ORI     ),
  .ANDI           (ANDI    ),
  .SLLI           (SLLI    ),
  .SRLI           (SRLI    ),
  .SRAI           (SRAI    ),
  .ADD            (ADD     ),
  .SUB            (SUB     ),
  .SLL            (SLL     ),
  .SLT            (SLT     ),
  .SLTU           (SLTU    ),
  .XOR            (XOR     ),
  .SRL            (SRL     ),
  .SRA            (SRA     ),
  .OR             (OR      ),
  .AND            (AND     ),
  .FENCE          (FENCE   ),
  .FENCE_I        (FENCE_I ),
  .ECALL          (ECALL   ),
  .CSRRW          (CSRRW   ),
  .CSRRS          (CSRRS   ),
  .CSRRC          (CSRRC   ),
  .CSRRWI         (CSRRWI  ),
  .CSRRSI         (CSRRSI  ),
  .CSRRCI         (CSRRCI  ),
  .EBREAK         (EBREAK  ),
  .TRAP           (TRAP    ),
                                  
  .PC_wr          (PC_wr   ),
  .PC_in          (PC_in   ),
  //.PC             (PC      ),
                                  
  .x_wr           (x_wr    ),
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
  .x31            (x31     ),

  .csr_req        (csr_req),   
  .csr_ack        (csr_ack),   
  .csr_write      (csr_write), 
  .csr_addr       (csr_addr),  
  .csr_mask       (csr_mask),  
  .csr_data_wr    (csr_data_wr),
  .csr_data_rd    (csr_data_rd),

  .bus_req        (o_membus_req),   
  .bus_ack        (i_membus_ack),   
  .bus_write      (o_membus_write), 
  .bus_addr       (o_membus_addr),  
  .bus_data_wr    (o_membus_data),
  .bus_data_rd    (i_membus_data) 
);

endmodule
