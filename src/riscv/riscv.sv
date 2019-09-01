import riscv_pkg::*;

module riscv (
  input  logic        clk,
  input  logic        rst,

  input  logic        i_bus_req,
  input  logic        i_bus_ack,
  input  logic        i_bus_write,
  input  logic [31:0] i_bus_addr,
  input  logic [31:0] i_bus_data,

  output logic        o_bus_req,
  output logic        o_bus_ack,
  output logic        o_bus_write,
  output logic [31:0] o_bus_addr,
  output logic [31:0] o_bus_data
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
logic [31:0][31:0] x_in;
logic [31:0][31:0] x;

riscv_pkg::ifu_s  ifu_out;
logic             ifu_rdy;
logic             ifu_req;
logic             ifu_done;
logic [31:0]      ifu_inst;
logic [31:0]      ifu_inst_PC;

logic             idu_rdy;
logic             idu_req;
logic [31:0]      idu_inst;
logic             idu_done;

logic             ifu_vld;
logic             idu_vld;
logic             alu_vld;
logic             alu_access_mem;

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

logic             ifu_bus_req;
logic             ifu_bus_write;
logic [31:0]      ifu_bus_addr;
logic [31:0]      ifu_bus_data;
logic             alu_bus_req;
logic             alu_bus_write;
logic [31:0]      alu_bus_addr;
logic [31:0]      alu_bus_data;

always_ff @(posedge clk)
  begin
  o_bus_req   <= ifu_bus_req     | alu_bus_req;
  o_bus_ack   <= '0;
  o_bus_write <= ifu_bus_write   | alu_bus_write;
  o_bus_addr  <= ifu_bus_addr    | alu_bus_addr;
  o_bus_data  <= ifu_bus_data    | alu_bus_data;
  if(rst)
    begin
    o_bus_req   <= '0;
    o_bus_ack   <= '0;
    o_bus_write <= '0;
    o_bus_addr  <= '0;
    o_bus_data  <= '0;
    end
  end

riscv_regfile regfile (
  .clk   (clk),
  .rst   (rst),

  .PC_wr (PC_wr),
  .PC_in (PC_in),
  .PC    (PC   ),

  .x_wr  (x_wr ),
  .x_in  (x_in ),
  .x     (x    )
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

riscv_ifu ifu (
  .clk            (clk),
  .rst            (rst),

  .PC             (PC_in),

  .alu_vld        (alu_vld),
  .alu_access_mem (alu_access_mem),
  .ifu_vld        (ifu_vld),
  .ifu_inst       (ifu_inst),
  .ifu_inst_PC    (ifu_inst_PC),

  .rdy            (ifu_rdy),
  .req            (ifu_req),
  .done           (ifu_done),


  .bus_req        (ifu_bus_req),   
  .bus_ack        (i_bus_ack),   
  .bus_write      (ifu_bus_write), 
  .bus_addr       (ifu_bus_addr),  
  .bus_data_wr    (ifu_bus_data),
  .bus_data_rd    (i_bus_data)  
);

riscv_idu idu (
  .clk       (clk),
  .rst       (rst),

  .ifu_vld   (ifu_vld),
  .ifu_inst  (ifu_inst),
  .idu_vld   (idu_vld),

  .idu_rdy   (idu_rdy),
  .idu_req   (idu_req),
                             
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
  .EBREAK    (EBREAK  )
);

riscv_alu alu (
  .clk            (clk     ),
  .rst            (rst     ),
                             
  .idu_vld        (idu_vld),
  .alu_vld        (alu_vld),
  .alu_access_mem (alu_access_mem),
                             
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
                                  
  .PC_wr          (PC_wr   ),
  .PC_in          (PC_in   ),
  .PC             (PC      ),
                                  
  .x_wr           (x_wr    ),
  .x_in           (x_in    ),
  .x              (x       ),

  .csr_req        (csr_req),   
  .csr_ack        (csr_ack),   
  .csr_write      (csr_write), 
  .csr_addr       (csr_addr),  
  .csr_mask       (csr_mask),  
  .csr_data_wr    (csr_data_wr),
  .csr_data_rd    (csr_data_rd),

  .bus_req        (alu_bus_req),   
  .bus_ack        (i_bus_ack),   
  .bus_write      (alu_bus_write), 
  .bus_addr       (alu_bus_addr),  
  .bus_data_wr    (alu_bus_data),
  .bus_data_rd    (i_bus_data)
);

endmodule
