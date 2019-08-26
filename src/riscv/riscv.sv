import riscv_pkg::*;

module riscv (
  input  logic           clk,
  input  logic           rst,

  input  logic           start,

  output logic           bus_req,
  input  logic           bus_ack,
  output logic           bus_write,
  output logic [31:0]    bus_addr,
  inout  logic [31:0]    bus_data,

  output logic [1:0]     dbg_led
);

logic              PC_wr;
logic [31:0]       PC_in;
logic [31:0]       PC;

logic [31:0]       x_wr;
logic [31:0][31:0] x_in;
logic [31:0][31:0] x;

riscv_pkg::ifu_s  ifu_out;
logic             ifu_rdy;
logic             ifu_req;
logic             ifu_done;
logic [31:0]      ifu_inst;

logic             idu_rdy;
logic             idu_req;
logic [31:0]      idu_inst;
logic             idu_done;

logic        ifu_vld;
logic        alu_vld;

logic  [3:0] fm;
logic  [3:0] pred;
logic  [3:0] succ;
logic  [4:0] shamt;
logic [31:0] imm;
logic  [6:0] funct7;
logic  [2:0] funct3;
logic  [4:0] rs2;
logic  [4:0] rs1;
logic  [4:0] rd;
logic  [6:0] opcode;

logic LUI;
logic AUIPC;
logic JAL;
logic JALR;
logic BEQ;
logic BNE;
logic BLT;
logic BGE;
logic BLTU;
logic BGEU;
logic LB;
logic LH;
logic LW;
logic LBU;
logic LHU;
logic SB;
logic SH;
logic SW;
logic ADDI;
logic SLTI;
logic SLTIU;
logic XORI;
logic ORI;
logic ANDI;
logic SLLI;
logic SRLI;
logic SRAI;
logic ADD;
logic SUB;
logic SLL;
logic SLT;
logic SLTU;
logic XOR;
logic SRL;
logic SRA;
logic OR;
logic AND;
logic FENCE;
logic FENCE_I;
logic ECALL;
logic EBREAK;

riscv_regfile regfile (
  .clk (clk),
  .rst (rst),

  .PC_wr (PC_wr),
  .PC_in (PC_in),
  .PC    (PC   ),

  .x_wr  (x_wr ),
  .x_in  (x_in ),
  .x     (x    )
);

riscv_ifu ifu (
  .clk (clk),
  .rst (rst),

  .PC    (PC_in),

  .alu_vld (alu_vld),
  .ifu_vld (ifu_vld),
  .ifu_inst (ifu_inst),

  .rdy  (ifu_rdy),
  .req  (ifu_req),
  .done (ifu_done),


  .bus_req   (bus_req),   
  .bus_ack   (bus_ack),   
  .bus_write (bus_write), 
  .bus_addr  (bus_addr),  
  .bus_data  (bus_data)  
);

riscv_idu idu (
  .clk (clk),
  .rst (rst),

  .ifu_vld (ifu_vld),
  .ifu_inst (ifu_inst),
  .idu_vld (idu_vld),

  .idu_rdy  (idu_rdy),
  .idu_req  (idu_req),
                             
  .fm        (fm      ),
  .pred      (pred    ),
  .succ      (succ    ),
  .shamt     (shamt   ),
  .imm       (imm     ),
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
  .EBREAK    (EBREAK  ),
 
  .dbg_led (dbg_led)

);

riscv_alu alu (
  .clk       (clk     ),
  .rst       (rst     ),
                             
  .idu_vld (idu_vld),
  .alu_vld   (alu_vld),
                             
  .fm        (fm      ),
  .pred      (pred    ),
  .succ      (succ    ),
  .shamt     (shamt   ),
  .imm       (imm     ),
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
  .EBREAK    (EBREAK  ),
                             
  .PC_wr     (PC_wr   ),
  .PC_in     (PC_in   ),
  .PC        (PC      ),
                             
  .x_wr      (x_wr    ),
  .x_in      (x_in    ),
  .x         (x       ),

  .bus_req   (bus_req),   
  .bus_ack   (bus_ack),   
  .bus_write (bus_write), 
  .bus_addr  (bus_addr),  
  .bus_data  (bus_data)
);

endmodule
