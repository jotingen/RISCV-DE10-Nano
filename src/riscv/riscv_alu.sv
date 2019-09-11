//import riscv_pkg::*;

module riscv_alu (
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


  input  logic        idu_vld,
  input  logic [31:0] inst,
  input  logic  [3:0] fm,
  input  logic  [3:0] pred,
  input  logic  [3:0] succ,
  input  logic  [4:0] shamt,
  input  logic [31:0] imm,
  input  logic  [4:0] uimm,
  input  logic [11:0] csr,
  input  logic  [6:0] funct7,
  input  logic  [2:0] funct3,
  input  logic  [4:0] rs2,
  input  logic  [4:0] rs1,
  input  logic  [4:0] rd,
  input  logic  [6:0] opcode,

  output logic        alu_vld,
  output logic [31:0] alu_inst,
  output logic        alu_br_miss,
  output logic [31:0] alu_addr,
  
  input  logic LUI,
  input  logic AUIPC,
  input  logic JAL,
  input  logic JALR,
  input  logic BEQ,
  input  logic BNE,
  input  logic BLT,
  input  logic BGE,
  input  logic BLTU,
  input  logic BGEU,
  input  logic LB,
  input  logic LH,
  input  logic LW,
  input  logic LBU,
  input  logic LHU,
  input  logic SB,
  input  logic SH,
  input  logic SW,
  input  logic ADDI,
  input  logic SLTI,
  input  logic SLTIU,
  input  logic XORI,
  input  logic ORI,
  input  logic ANDI,
  input  logic SLLI,
  input  logic SRLI,
  input  logic SRAI,
  input  logic ADD,
  input  logic SUB,
  input  logic SLL,
  input  logic SLT,
  input  logic SLTU,
  input  logic XOR,
  input  logic SRL,
  input  logic SRA,
  input  logic OR,
  input  logic AND,
  input  logic FENCE,
  input  logic FENCE_I,
  input  logic ECALL,
  input  logic CSRRW,
  input  logic CSRRS,
  input  logic CSRRC,
  input  logic CSRRWI,
  input  logic CSRRSI,
  input  logic CSRRCI,
  input  logic EBREAK,
  input  logic TRAP,

  output logic              PC_wr,
  output logic [31:0]       PC_in,

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

logic [31:0] PC_orig;
logic [31:0] PC_next_PC_imm20;
logic [31:0] PC_next_PC_imm12;
logic [31:0] PC_next_rs1_imm11;

logic [31:0] rs1_data;
logic [31:0] rs2_data;
logic [31:0] rd_data;

logic        alu_retired;
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
logic        alu_trap;

logic [31:0] addr;

//Map out registers
always_comb
  begin
  unique
  case(rs1)
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
    'd31: rs1_data = x31;
  endcase
  unique
  case(rs2)
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
    'd31: rs2_data = x31;
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
  case(rd)
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
    'd31: x31_in = rd_data;
  endcase
  end

always_comb
  begin
  PC_next_PC_imm20 = PC_in+{{11{imm[20]}},imm[20:0]};
  PC_next_PC_imm12 = PC_in+{{19{imm[12]}},imm[12:0]};
  PC_next_rs1_imm11 = (rs1_data+{{20{imm[11]}},imm[11:0]}) & 32'hFFFFFFFE;
  end

logic [3:0] cnt;
always_ff @(posedge clk)
  begin

  alu_vld <= '0;
  alu_retired <= '0;

  PC_wr <= '0;
  PC_orig <= PC_in;
  PC_in <= PC_in;
  x_wr  <= '0;
  rd_data <= rd_data;

  csr_req   <= '0  ;
  csr_write <= csr_write;
  csr_addr  <= csr_addr ;
  csr_mask  <= csr_mask ;
  csr_data_wr  <= '0;

  bus_req   <= '0;
  bus_write <= '0;
  bus_addr  <= '0;
  bus_data_wr  <= '0 ;
  bus_data_rd_mask <= '0;
  bus_data_wr_mask <= '0;

  alu_inst       <= inst;  
  alu_br_miss    <= '0;
  alu_fm         <= fm;    
  alu_pred       <= pred;  
  alu_succ       <= succ;  
  alu_shamt      <= shamt; 
  alu_imm        <= imm;   
  alu_uimm       <= uimm;  
  alu_csr        <= csr;   
  alu_funct7     <= funct7;
  alu_funct3     <= funct3;
  alu_rs2        <= rs2;   
  alu_rs1        <= rs1;   
  alu_rd         <= rd;    
  alu_opcode     <= opcode;
  alu_rs2_data   <= rs2_data;  
  alu_rs1_data   <= rs1_data;  
  //alu_rd_data    <= rd_data;   
  alu_trap       <= '0;   

  if((idu_vld && ~alu_br_miss) || cnt != 'd0)
    begin
    unique
    case (1'b1)
      ADD : begin
            //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "ADD", PC, rs1, rs1_data, rs2, rs2_data, rd);
            alu_vld <= '1;
            alu_retired <= '1;
            x_wr[rd] <= '1;
            rd_data <= rs1_data + rs2_data;
            PC_wr <= '1;
            PC_in <= PC_in+'d4;
            end
      SLT : begin
            //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SLT", PC, rs1, rs1_data, rs2, rs2_data, rd);
            alu_vld <= '1;
            alu_retired <= '1;
            x_wr[rd] <= '1;
            if($signed(rs1_data) < $signed(rs2_data))
              rd_data <= 'd1;
            else
              rd_data <= 'd0;
            PC_wr <= '1;
            PC_in <= PC_in+'d4;
            end
      SLTU : begin
             //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SLTU", PC, rs1, rs1_data, rs2, rs2_data, rd);
             alu_vld <= '1;
             alu_retired <= '1;
             x_wr[rd] <= '1;
             if(rs1_data < rs2_data)
               rd_data <= 'd1;
             else
               rd_data <= 'd0;
             PC_wr <= '1;
             PC_in <= PC_in+'d4;
             end
      AND : begin
            //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "AND", PC, rs1, rs1_data, rs2, rs2_data, rd);
            alu_vld <= '1;
            alu_retired <= '1;
            x_wr[rd] <= '1;
            rd_data <= rs1_data & rs2_data;
            PC_wr <= '1;
            PC_in <= PC_in+'d4;
            end
      OR : begin
           //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "OR", PC, rs1, rs1_data, rs2, rs2_data, rd);
           alu_vld <= '1;
           alu_retired <= '1;
           x_wr[rd] <= '1;
           rd_data <= rs1_data | rs2_data;
           PC_wr <= '1;
           PC_in <= PC_in+'d4;
           end
      XOR : begin
            //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "XOR", PC, rs1, rs1_data, rs2, rs2_data, rd);
            alu_vld <= '1;
            alu_retired <= '1;
            x_wr[rd] <= '1;
            rd_data <= rs1_data ^ rs2_data;
            PC_wr <= '1;
            PC_in <= PC_in+'d4;
            end
      SLL : begin
            //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SLL", PC, rs1, rs1_data, rs2, rs2_data, rd);
            alu_vld <= '1;
            alu_retired <= '1;
            x_wr[rd] <= '1;
            rd_data <= rs1_data << rs2_data[4:0];
            PC_wr <= '1;
            PC_in <= PC_in+'d4;
            end
      SRL : begin
            //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SRL", PC, rs1, rs1_data, rs2, rs2_data, rd);
            alu_vld <= '1;
            alu_retired <= '1;
            x_wr[rd] <= '1;
            rd_data <= rs1_data >> rs2_data[4:0];
            PC_wr <= '1;
            PC_in <= PC_in+'d4;
            end
      SUB : begin
            //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SUB", PC, rs1, rs1_data, rs2, rs2_data, rd);
            alu_vld <= '1;
            alu_retired <= '1;
            x_wr[rd] <= '1;
            rd_data <= rs1_data - rs2_data;
            PC_wr <= '1;
            PC_in <= PC_in+'d4;
            end
      SRA : begin
            //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SRA", PC, rs1, rs1_data, rs2, rs2_data, rd);
            alu_vld <= '1;
            alu_retired <= '1;
            x_wr[rd] <= '1;
            rd_data <= rs1_data >>> rs2_data;
            PC_wr <= '1;
            PC_in <= PC_in+'d4;
            end


      ADDI : begin
             //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "ADDI", PC, rs1, rs1_data, {{20{imm[11]}},imm[11:0]}, rd);
             alu_vld <= '1;
             alu_retired <= '1;
             x_wr[rd] <= '1;
             rd_data <= rs1_data + {{20{imm[11]}},imm[11:0]};
             PC_wr <= '1;
             PC_in <= PC_in+'d4;
             end
      SLTI : begin
             //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "SLTI", PC, rs1, rs1_data, {{20{imm[11]}},imm[11:0]}, rd);
             alu_vld <= '1;
             alu_retired <= '1;
             x_wr[rd] <= '1;
             if($signed(rs1_data) < $signed({{20{imm[11]}},imm[11:0]}))
               rd_data <= 'd1;
             else
               rd_data <= 'd0;
             PC_wr <= '1;
             PC_in <= PC_in+'d4;
             end
      SLTIU : begin
              //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "SLTIU", PC, rs1, rs1_data, {{20{imm[11]}},imm[11:0]}, rd);
              alu_vld <= '1;
             alu_retired <= '1;
              x_wr[rd] <= '1;
              if(rs1_data < {{20{imm[11]}},imm[11:0]})
                rd_data <= 'd1;
              else
                rd_data <= 'd0;
              PC_wr <= '1;
              PC_in <= PC_in+'d4;
              end
      ANDI : begin
             //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "ANDI", PC, rs1, rs1_data, {{20{imm[11]}},imm[11:0]}, rd);
             alu_vld <= '1;
             alu_retired <= '1;
             x_wr[rd] <= '1;
             rd_data <= rs1_data & {{20{imm[11]}},imm[11:0]};
             PC_wr <= '1;
             PC_in <= PC_in+'d4;
             end
      ORI : begin
            //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "ORI", PC, rs1, rs1_data, {{20{imm[11]}},imm[11:0]}, rd);
            alu_vld <= '1;
            alu_retired <= '1;
            x_wr[rd] <= '1;
            rd_data <= rs1_data | {{20{imm[11]}},imm[11:0]};
            PC_wr <= '1;
            PC_in <= PC_in+'d4;
            end
      XORI : begin
             //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "XORI", PC, rs1, rs1_data, {{20{imm[11]}},imm[11:0]}, rd);
             alu_vld <= '1;
             alu_retired <= '1;
             x_wr[rd] <= '1;
             rd_data <= rs1_data ^ {{20{imm[11]}},imm[11:0]};
             PC_wr <= '1;
             PC_in <= PC_in+'d4;
             end
      SLLI : begin
             //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "SLLI", PC, rs1, rs1_data, {{27{'0}},imm[4:0]}, rd);
             alu_vld <= '1;
             alu_retired <= '1;
             x_wr[rd] <= '1;
             rd_data <= rs1_data << imm[4:0];
             PC_wr <= '1;
             PC_in <= PC_in+'d4;
             end
      SRLI : begin
             //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "SRLI", PC, rs1, rs1_data, {{27{'0}},imm[4:0]}, rd);
             alu_vld <= '1;
             alu_retired <= '1;
             x_wr[rd] <= '1;
             rd_data <= rs1_data >> imm[4:0];
             PC_wr <= '1;
             PC_in <= PC_in+'d4;
             end
      SRAI : begin
             //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "SRAI", PC, rs1, rs1_data, imm[4:0], rd);
             alu_vld <= '1;
             alu_retired <= '1;
             x_wr[rd] <= '1;
             rd_data <= rs1_data >>> imm;
             PC_wr <= '1;
             PC_in <= PC_in+'d4;
             end


      JAL : begin
            if(imm!='0 || rd!='0)
              //$display("%-5s PC=%08X imm=%08X rd=(%d)", "JAL", PC, {{11{imm[20]}},imm[20:0]}, rd);
            alu_vld <= '1;
            alu_retired <= '1;
            PC_wr <= '1;
            PC_in <= PC_next_PC_imm20;
            if(PC_next_PC_imm20[1:0] != '0)
              begin
              alu_trap <= '1;
              PC_wr <= '0;
              end
            else
              begin
              x_wr[rd] <= '1;
              rd_data <= PC_in+'d4;
              alu_br_miss <= '1;
              end
            end
      JALR : begin
             //$display("%-5s PC=%08X imm=%08X rd=(%d)", "JALR", PC, {{20{imm[11]}},imm[11:0]}, rd);
             alu_vld <= '1;
             alu_retired <= '1;
             PC_wr <= '1;
             PC_in <= PC_next_rs1_imm11;
             if(PC_next_rs1_imm11[1:0] != '0)
               begin
               alu_trap <= '1;
               PC_wr <= '0;
               end
             else
               begin
               x_wr[rd] <= '1;
               rd_data <= PC_in+'d4;
               alu_br_miss <= '1;
               end
             end


      BEQ : begin
            //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BEQ", PC, rs1, rs1_data, rs2, rs2_data, {{19{imm[12]}},imm[12:0]});
            alu_vld <= '1;
            alu_retired <= '1;
            PC_wr <= '1;
            if(rs1_data == rs2_data)
              begin
              PC_in <= PC_next_PC_imm12;
              if(PC_next_PC_imm12[1:0] != '0)
                begin
                alu_trap <= '1;
                PC_wr <= '0;
                end
              alu_br_miss <= '1;
              end
            else                  
              PC_in <= PC_in+'d4;
            end
      BNE : begin
            //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BNE", PC, rs1, rs1_data, rs2, rs2_data, {{19{imm[12]}},imm[12:0]});
            alu_vld <= '1;
            alu_retired <= '1;
            PC_wr <= '1;
            if(rs1_data != rs2_data)
              begin
              PC_in <= PC_next_PC_imm12;
              if(PC_next_PC_imm12[1:0] != '0)
                begin
                alu_trap <= '1;
                PC_wr <= '0;
                end
              alu_br_miss <= '1;
              end
            else                  
              PC_in <= PC_in+'d4;
            end
      BLT : begin
            //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BLT", PC, rs1, rs1_data, rs2, rs2_data, {{19{imm[12]}},imm[12:0]});
            alu_vld <= '1;
            alu_retired <= '1;
            PC_wr <= '1;
            if($signed(rs1_data) < $signed(rs2_data))
              begin
              PC_in <= PC_next_PC_imm12;
              if(PC_next_PC_imm12[1:0] != '0)
                begin
                alu_trap <= '1;
                PC_wr <= '0;
                end
              alu_br_miss <= '1;
              end
            else                  
              PC_in <= PC_in+'d4;
            end
      BLTU : begin
             //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BLTU", PC, rs1, rs1_data, rs2, rs2_data, {{19{imm[12]}},imm[12:0]});
             alu_vld <= '1;
             alu_retired <= '1;
             PC_wr <= '1;
             if(rs1_data < rs2_data)
              begin
              PC_in <= PC_next_PC_imm12;
              if(PC_next_PC_imm12[1:0] != '0)
                begin
                alu_trap <= '1;
                PC_wr <= '0;
                end
              alu_br_miss <= '1;
              end
             else                  
               PC_in <= PC_in+'d4;
             end
      BGE : begin
            //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BGE", PC, rs1, rs1_data, rs2, rs2_data, {{19{imm[12]}},imm[12:0]});
            alu_vld <= '1;
            alu_retired <= '1;
            PC_wr <= '1;
            if($signed(rs1_data) >= $signed(rs2_data))
              begin
              PC_in <= PC_next_PC_imm12;
              if(PC_next_PC_imm12[1:0] != '0)
                begin
                alu_trap <= '1;
                PC_wr <= '0;
                end
              alu_br_miss <= '1;
              end
            else                  
              PC_in <= PC_in+'d4;
            end
      BGEU : begin
             //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BGEU", PC, rs1, rs1_data, rs2, rs2_data, {{19{imm[12]}},imm[12:0]});
             alu_vld <= '1;
             alu_retired <= '1;
             PC_wr <= '1;
             if(rs1_data >= rs2_data)
              begin
               PC_in <= PC_next_PC_imm12;
               if(PC_next_PC_imm12[1:0] != '0)
                 begin
                 alu_trap <= '1;
                 PC_wr <= '0;
                 end
              alu_br_miss <= '1;
              end
             else                  
               PC_in <= PC_in+'d4;
             end


      LUI : begin
            //$display("%-5s PC=%08X imm=%08X rd=(%d)", "LUI", PC, imm, rd);
            alu_vld <= '1;
            alu_retired <= '1;
            x_wr[rd] <= '1;
            rd_data <= imm;
            PC_wr <= '1;
            PC_in <= PC_in+'d4;
            end
      AUIPC : begin
              //$display("%-5s PC=%08X imm=%08X rd=(%d)", "AUIPC", PC, imm, rd);
              alu_vld <= '1;
              alu_retired <= '1;
              x_wr[rd] <= '1;
              rd_data <= PC_in + imm;
              PC_wr <= '1;
              PC_in <= PC_in+'d4;
              end


      LB : begin
           if(cnt=='d0)
             begin
             bus_req   <= '1;
             bus_write <= '0;
             addr  = rs1_data + { {20{imm[11]}}, imm[11:0]};
             bus_addr  <= addr;
             unique
             case(addr[1:0])
               'b00: bus_data_rd_mask <= 'b0001;
               'b01: bus_data_rd_mask <= 'b0010;
               'b10: bus_data_rd_mask <= 'b0100;
               'b11: bus_data_rd_mask <= 'b1000;
             endcase
             cnt <= cnt + 1;
             end
           else if(bus_ack)
             begin
             //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "LW", PC, rs1, rs1_data, {{20{imm[11]}},imm[11:0]}, rd);
             alu_vld <= '1;
             alu_retired <= '1;
             x_wr[rd] <= '1;
             addr  = rs1_data + { {20{imm[11]}}, imm[11:0]};
             unique
             case(addr[1:0])
               'b00: rd_data <= {{24{bus_data_rd[7]}},bus_data_rd[7:0]};
               'b01: rd_data <= {{24{bus_data_rd[15]}},bus_data_rd[15:8]};
               'b10: rd_data <= {{24{bus_data_rd[23]}},bus_data_rd[23:16]};
               'b11: rd_data <= {{24{bus_data_rd[31]}},bus_data_rd[31:24]};
             endcase
             PC_wr <= '1;
             PC_in <= PC_in+'d4;
             cnt <= '0;
             end
           else
             begin
             cnt <= cnt + 1;
             end
           end
      LBU : begin
           if(cnt=='d0)
             begin
             bus_req   <= '1;
             bus_write <= '0;
             addr  = rs1_data + { {20{imm[11]}}, imm[11:0]};
             bus_addr  <= addr;
             unique
             case(addr[1:0])
               'b00: bus_data_rd_mask <= 'b0001;
               'b01: bus_data_rd_mask <= 'b0010;
               'b10: bus_data_rd_mask <= 'b0100;
               'b11: bus_data_rd_mask <= 'b1000;
             endcase
             cnt <= cnt + 1;
             end
           else if(bus_ack)
             begin
             //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "LW", PC, rs1, rs1_data, {{20{imm[11]}},imm[11:0]}, rd);
             alu_vld <= '1;
             alu_retired <= '1;
             x_wr[rd] <= '1;
             addr  = rs1_data + { {20{imm[11]}}, imm[11:0]};
             unique
             case(addr[1:0])
               'b00: rd_data <= {{24{'0}},bus_data_rd[7:0]};
               'b01: rd_data <= {{24{'0}},bus_data_rd[15:8]};
               'b10: rd_data <= {{24{'0}},bus_data_rd[23:16]};
               'b11: rd_data <= {{24{'0}},bus_data_rd[31:24]};
             endcase
             PC_wr <= '1;
             PC_in <= PC_in+'d4;
             cnt <= '0;
             end
           else
             begin
             cnt <= cnt + 1;
             end
           end
      LH : begin
           if(cnt=='d0)
             begin
             bus_req   <= '1;
             bus_write <= '0;
             addr  = rs1_data + { {20{imm[11]}}, imm[11:0]};
             bus_addr  <= addr;
             unique
             case(addr[1])
               'b0: bus_data_rd_mask <= 'b0011;
               'b1: bus_data_rd_mask <= 'b1100;
             endcase
             cnt <= cnt + 1;
             end
           else if(bus_ack)
             begin
             //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "LW", PC, rs1, rs1_data, {{20{imm[11]}},imm[11:0]}, rd);
             alu_vld <= '1;
             alu_retired <= '1;
             x_wr[rd] <= '1;
             addr  = rs1_data + { {20{imm[11]}}, imm[11:0]};
             unique
             case(addr[1:0])
               'b0: rd_data <= {{16{bus_data_rd[15]}},bus_data_rd[15:0]};
               'b1: rd_data <= {{16{bus_data_rd[31]}},bus_data_rd[31:16]};
             endcase
             PC_wr <= '1;
             PC_in <= PC_in+'d4;
             cnt <= '0;
             end
           else
             begin
             cnt <= cnt + 1;
             end
           end
      LHU : begin
           if(cnt=='d0)
             begin
             bus_req   <= '1;
             bus_write <= '0;
             addr  = rs1_data + { {20{imm[11]}}, imm[11:0]};
             bus_addr  <= addr;
             unique
             case(addr[1])
               'b0: bus_data_rd_mask <= 'b0011;
               'b1: bus_data_rd_mask <= 'b1100;
             endcase
             cnt <= cnt + 1;
             end
           else if(bus_ack)
             begin
             //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "LW", PC, rs1, rs1_data, {{20{imm[11]}},imm[11:0]}, rd);
             alu_vld <= '1;
             alu_retired <= '1;
             x_wr[rd] <= '1;
             addr  = rs1_data + { {20{imm[11]}}, imm[11:0]};
             unique
             case(addr[1:0])
               'b0: rd_data <= {{16{'0}},bus_data_rd[15:0]};
               'b1: rd_data <= {{16{'0}},bus_data_rd[31:16]};
             endcase
             PC_wr <= '1;
             PC_in <= PC_in+'d4;
             cnt <= '0;
             end
           else
             begin
             cnt <= cnt + 1;
             end
           end
      LW : begin
           if(cnt=='d0)
             begin
             bus_req   <= '1;
             bus_write <= '0;
             addr  = rs1_data + { {20{imm[11]}}, imm[11:0]};
             bus_addr  <= addr;
             bus_data_rd_mask <= 'b1111;
             cnt <= cnt + 1;
             end
           else if(bus_ack)
             begin
             //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "LW", PC, rs1, rs1_data, {{20{imm[11]}},imm[11:0]}, rd);
             alu_vld <= '1;
             alu_retired <= '1;
             x_wr[rd] <= '1;
             rd_data <= bus_data_rd;
             PC_wr <= '1;
             PC_in <= PC_in+'d4;
             cnt <= '0;
             end
           else
             begin
             cnt <= cnt + 1;
             end
           end
      SB : begin
           if(cnt=='d0)
             begin
             bus_req   <= '1;
             bus_write <= '1;
             addr  = rs1_data + { {20{imm[11]}}, imm[11:0]};
             bus_addr  <= addr;
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
             cnt <= cnt + 1;
             end
           else if(bus_ack)
             begin
             //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "SW", PC, rs1, rs1_data, rs2, rs2_data, {{20{imm[11]}},imm[11:0]});
             alu_vld <= '1;
             alu_retired <= '1;
             PC_wr <= '1;
             PC_in <= PC_in+'d4;
             cnt <= '0;
             end
           end
      SH : begin
           if(cnt=='d0)
             begin
             bus_req   <= '1;
             bus_write <= '1;
             addr  = rs1_data + { {20{imm[11]}}, imm[11:0]};
             bus_addr  <= addr;
             unique
             case(addr[1:0])
               'b0: bus_data_wr  <= {{16{'0}},rs2_data[15:0]};
               'b1: bus_data_wr  <= {         rs2_data[15:0],{16{'0}}};
             endcase
             unique
             case(addr[1:0])
               'b0: bus_data_wr_mask <= 'b0011;
               'b1: bus_data_wr_mask <= 'b1100;
             endcase
             cnt <= cnt + 1;
             end
           else if(bus_ack)
             begin
             //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "SW", PC, rs1, rs1_data, rs2, rs2_data, {{20{imm[11]}},imm[11:0]});
             alu_vld <= '1;
             alu_retired <= '1;
             PC_wr <= '1;
             PC_in <= PC_in+'d4;
             cnt <= '0;
             end
           end
      SW : begin
           if(cnt=='d0)
             begin
             bus_req   <= '1;
             bus_write <= '1;
             addr  = rs1_data + { {20{imm[11]}}, imm[11:0]};
             bus_addr  <= addr;
             bus_data_wr  <= rs2_data;
             bus_data_wr_mask <= 'b1111;
             cnt <= cnt + 1;
             end
           else if(bus_ack)
             begin
             //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "SW", PC, rs1, rs1_data, rs2, rs2_data, {{20{imm[11]}},imm[11:0]});
             alu_vld <= '1;
             alu_retired <= '1;
             PC_wr <= '1;
             PC_in <= PC_in+'d4;
             cnt <= '0;
             end
           end


      FENCE : begin
              //$display("%-5s PC=%08X" , "FENCE", PC);
              //TODO
              alu_vld <= '1;
              PC_wr <= '1;
              PC_in <= PC_in+'d4;
              end



      ECALL : begin
              //$display("%-5s PC=%08X" , "ECALL - !!TODO!!", PC);
              alu_vld <= '1;
              alu_retired <= '1;
              PC_wr <= '1;
              PC_in <= PC_in+'d4;
              end
      CSRRW : begin
              if(cnt=='d0)
                begin
                csr_req   <= '1;
                csr_write <= '1;
                csr_addr  <= csr;
                csr_mask  <= '1;
                csr_data_wr  <= rs1_data;
                cnt <= cnt + 1;
                end
              else if(cnt=='d2)
                begin
                //$display("%-5s CSR=%03X rs1=(%d)%08X rd=(%d)", "CSRRW", csr, rs1, rs1_data, rd);
                alu_vld <= '1;
                alu_retired <= '1;
                x_wr[rd] <= '1;
                rd_data <= '0;
                rd_data <= csr_data_rd;
                PC_wr <= '1;
                PC_in <= PC_in+'d4;
                cnt <= '0;
                end
              else
                begin
                cnt <= cnt + 1;
                end
              end
      CSRRS : begin
              if(cnt=='d0)
                begin
                csr_req   <= '1;
                if(rs1 != '0)
                  begin
                  csr_write <= '1;
                  end
                else
                  begin
                  csr_write <= '0;
                  end
                csr_addr  <= csr;
                csr_mask  <= rs1_data;
                csr_data_wr  <= '1;
                cnt <= cnt + 1;
                end
              else if(cnt=='d2)
                begin
                //$display("%-5s CSR=%03X rs1=(%d)%08X rd=(%d)", "CSRRS", csr, rs1, rs1_data, rd);
                alu_vld <= '1;
                alu_retired <= '1;
                x_wr[rd] <= '1;
                rd_data <= '0;
                rd_data <= csr_data_rd;
                PC_wr <= '1;
                PC_in <= PC_in+'d4;
                cnt <= '0;
                end
              else
                begin
                cnt <= cnt + 1;
                end
              end
      CSRRC : begin
              if(cnt=='d0)
                begin
                csr_req   <= '1;
                if(rs1 != '0)
                  begin
                  csr_write <= '1;
                  end
                else
                  begin
                  csr_write <= '0;
                  end
                csr_addr  <= csr;
                csr_mask  <= rs1_data;
                csr_data_wr  <= '0;
                cnt <= cnt + 1;
                end
              else if(cnt=='d2)
                begin
                //$display("%-5s CSR=%03X rs1=(%d)%08X rd=(%d)", "CSRRS", csr, rs1, rs1_data, rd);
                alu_vld <= '1;
                alu_retired <= '1;
                x_wr[rd] <= '1;
                rd_data <= '0;
                rd_data <= csr_data_rd;
                PC_wr <= '1;
                PC_in <= PC_in+'d4;
                cnt <= '0;
                end
              else
                begin
                cnt <= cnt + 1;
                end
              end
      CSRRWI : begin
              if(cnt=='d0)
                begin
                csr_req   <= '1;
                csr_write <= '1;
                csr_addr  <= csr;
                csr_mask  <= '1;
                csr_data_wr  <= '0;
                csr_data_wr[4:0]  <= uimm;
                cnt <= cnt + 1;
                end
              else if(cnt=='d2)
                begin
                //$display("%-5s CSR=%03X rs1=(%d)%08X rd=(%d)", "CSRRWI", csr, rs1, rs1_data, rd);
                alu_vld <= '1;
                alu_retired <= '1;
                x_wr[rd] <= '1;
                rd_data <= '0;
                rd_data <= csr_data_rd;
                PC_wr <= '1;
                PC_in <= PC_in+'d4;
                cnt <= '0;
                end
              else
                begin
                cnt <= cnt + 1;
                end
              end
      CSRRSI : begin
              if(cnt=='d0)
                begin
                csr_req   <= '1;
                if(uimm != '0)
                  begin
                  csr_write <= '1;
                  end
                else
                  begin
                  csr_write <= '0;
                  end
                csr_addr  <= csr;
                csr_mask  <= '1;
                csr_data_wr  <= '0;
                csr_data_wr[4:0]  <= uimm;
                cnt <= cnt + 1;
                end
              else if(cnt=='d2)
                begin
                //$display("%-5s CSR=%03X rs1=(%d)%08X rd=(%d)", "CSRRSI", csr, rs1, rs1_data, rd);
                alu_vld <= '1;
                alu_retired <= '1;
                x_wr[rd] <= '1;
                rd_data <= '0;
                rd_data <= csr_data_rd;
                PC_wr <= '1;
                PC_in <= PC_in+'d4;
                cnt <= '0;
                end
              else
                begin
                cnt <= cnt + 1;
                end
              end
      CSRRCI : begin
              if(cnt=='d0)
                begin
                csr_req   <= '1;
                if(uimm != '0)
                  begin
                  csr_write <= '1;
                  end
                else
                  begin
                  csr_write <= '0;
                  end
                csr_addr  <= csr;
                csr_mask  <= '1;
                csr_data_wr  <= '0;
                csr_data_wr[4:0]  <= uimm;
                cnt <= cnt + 1;
                end
              else if(cnt=='d2)
                begin
                //$display("%-5s CSR=%03X rs1=(%d)%08X rd=(%d)", "CSRRCI", csr, rs1, rs1_data, rd);
                alu_vld <= '1;
                alu_retired <= '1;
                x_wr[rd] <= '1;
                rd_data <= '0;
                rd_data <= csr_data_rd;
                PC_wr <= '1;
                PC_in <= PC_in+'d4;
                cnt <= '0;
                end
              else
                begin
                cnt <= cnt + 1;
                end
              end
      EBREAK : begin
               //TODO
               //$display("%-5s PC=%08X" , "EBREAK - !!TODO!!", PC);
               alu_vld <= '1;
               alu_retired <= '1;
               PC_wr <= '1;
               PC_in <= PC_in+'d4;
               end
      TRAP :   begin
               //TODO
               //$display("%-5s PC=%08X" , "TRAP - !!TODO!!", PC);
               alu_vld <= '1;
               alu_retired <= '1;
               alu_trap <= '1;
               PC_wr <= '0;
               end
      default : begin
                //$display("%-5s PC=%08X" , "INVALID!!", PC);
                alu_vld <= '1;
                alu_retired <= '1;
                alu_trap <= '1;
                PC_wr <= '0;
                end
              
      endcase

    if(PC_in[1:0] != '0)
      begin
      alu_trap <= '1;
      PC_wr <= '0;
      end
    end
  else
    begin
    //Keep valid high to keep pipe flowing
    alu_vld <= '1;
    end

  if(rd == '0)
    rd_data <= '0;

  if(rst)
    begin
    alu_vld <= '1;
    alu_retired <= '0;
    cnt <= '0;

    PC_wr <= '0;
    PC_in <= '0;
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
    end
  end

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
  rvfi_valid = alu_vld & alu_retired;
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
  rvfi_pc_rdata = PC_orig;
  rvfi_pc_wdata = PC_in;
  rvfi_mem_addr = bus_addr;
  rvfi_mem_rmask = bus_data_rd_mask;
  rvfi_mem_wmask = bus_data_wr_mask;
  rvfi_mem_rdata = bus_data_rd;
  rvfi_mem_wdata = bus_data_wr;

  rvfi_csr_mcycle_rmask = '0;
  rvfi_csr_mcycle_wmask = '0;
  rvfi_csr_mcycle_rdata = '0;
  rvfi_csr_mcycle_wdata = '0;

  rvfi_csr_minstret_rmask = '0;
  rvfi_csr_minstret_wmask = '0;
  rvfi_csr_minstret_rdata = '0;
  rvfi_csr_minstret_wdata = '0;
  end
`endif
endmodule
