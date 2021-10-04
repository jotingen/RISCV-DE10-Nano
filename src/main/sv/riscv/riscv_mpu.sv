//import riscv_pkg::*;

module riscv_mpu#(
  parameter M_EXT = 1
)  (
  input  logic        clk,
  input  logic        rst,

  output logic        mpu_vld,
  output logic [31:0] mpu_inst,
  output logic [63:0] mpu_order,
  output logic        mpu_retired,
  output logic        mpu_freeze,
  output logic        mpu_trap,
  output logic [31:0] mpu_PC,
  output logic [31:0] mpu_PC_next,
  output logic  [4:0] mpu_rs1,
  output logic  [4:0] mpu_rs2,
  output logic [31:0] mpu_rs1_data,
  output logic [31:0] mpu_rs2_data,
  output logic        mpu_rd_wr,
  output logic  [4:0] mpu_rd,
  output logic [31:0] mpu_rd_data,

  input  logic        dpu_vld,
  input  logic [31:0] dpu_inst,
  input  logic [63:0] dpu_order,
  input  logic [31:0] dpu_PC,
  
  input  logic  [3:0] dpu_fm,
  input  logic  [3:0] dpu_pred,
  input  logic  [3:0] dpu_succ,
  input  logic  [4:0] dpu_shamt,
  input  logic [31:0] dpu_imm,
  input  logic  [4:0] dpu_uimm,
  input  logic [11:0] dpu_csr,
  input  logic  [6:0] dpu_funct7,
  input  logic  [2:0] dpu_funct3,
  input  logic  [4:0] dpu_rs2,
  input  logic  [4:0] dpu_rs1,
  input  logic  [4:0] dpu_rd,
  input  logic  [6:0] dpu_opcode,

  input  logic [31:0] dpu_rs1_data,
  input  logic [31:0] dpu_rs2_data,

  input  logic dpu_MUL,
  input  logic dpu_MULH,
  input  logic dpu_MULHSU,
  input  logic dpu_MULHU

);

logic  [3:0] mpu_fm;
logic  [3:0] mpu_pred;
logic  [3:0] mpu_succ;
logic  [4:0] mpu_shamt;
logic [31:0] mpu_imm;
logic  [4:0] mpu_uimm;
logic [11:0] mpu_csr;
logic  [6:0] mpu_funct7;
logic  [2:0] mpu_funct3;
logic  [6:0] mpu_opcode;

logic mpu_MUL;
logic mpu_MULH;
logic mpu_MULHSU;
logic mpu_MULHU;

logic [63:0] product;
logic [63:0] product_unsigned;
logic [64:0] product_signed_unsigned;


logic [3:0] mpu_cnt;
always_ff @(posedge clk)
  begin
  mpu_vld <= mpu_vld;
  mpu_retired <= '0;
  mpu_freeze <= mpu_freeze;

  mpu_PC      <= mpu_PC;
  mpu_PC_next <= mpu_PC_next;
  mpu_rd_wr  <= '0;
  mpu_rd_data <= mpu_rd_data;

  mpu_rs2_data   <= mpu_rs2_data;  
  mpu_rs1_data   <= mpu_rs1_data;  
  mpu_trap       <= '0;   

  mpu_inst    <= mpu_inst;      
  mpu_order   <= mpu_order;      
  mpu_fm      <= mpu_fm;        
  mpu_pred    <= mpu_pred;      
  mpu_succ    <= mpu_succ;      
  mpu_shamt   <= mpu_shamt;     
  mpu_imm     <= mpu_imm;       
  mpu_uimm    <= mpu_uimm;      
  mpu_csr     <= mpu_csr;       
  mpu_funct7  <= mpu_funct7;    
  mpu_funct3  <= mpu_funct3;    
  mpu_rs2     <= mpu_rs2;       
  mpu_rs1     <= mpu_rs1;       
  mpu_rd      <= mpu_rd;        
  mpu_opcode  <= mpu_opcode;    
                                 
  mpu_MUL     <= mpu_MUL;
  mpu_MULH    <= mpu_MULH;
  mpu_MULHSU  <= mpu_MULHSU;
  mpu_MULHU   <= mpu_MULHU;

  //Capture IDU when IDU is valid and ALU is not valid or is retiring without
  //branch miss or trap
  if((~mpu_vld | (mpu_vld & mpu_retired)) & dpu_vld)
    begin
    mpu_vld     <= dpu_vld;
    mpu_inst    <= dpu_inst;      
    mpu_order   <= dpu_order;      
    mpu_PC      <= dpu_PC;      

    mpu_retired <= '0;
    mpu_freeze  <= dpu_vld;

    mpu_fm      <= dpu_fm;        
    mpu_pred    <= dpu_pred;      
    mpu_succ    <= dpu_succ;      
    mpu_shamt   <= dpu_shamt;     
    mpu_imm     <= dpu_imm;       
    mpu_uimm    <= dpu_uimm;      
    mpu_csr     <= dpu_csr;       
    mpu_funct7  <= dpu_funct7;    
    mpu_funct3  <= dpu_funct3;    
    mpu_rs2     <= dpu_rs2;       
    mpu_rs1     <= dpu_rs1;       
    mpu_rd      <= dpu_rd;        
    mpu_opcode  <= dpu_opcode;    
                   
    mpu_MUL     <= dpu_MUL;  
    mpu_MULH    <= dpu_MULH; 
    mpu_MULHSU  <= dpu_MULHSU;
    mpu_MULHU   <= dpu_MULHU;

    mpu_rs1_data<= dpu_rs1_data;      
    mpu_rs2_data<= dpu_rs2_data;      
    end
  //Else turn off if retiring
  else if(mpu_vld & mpu_retired)
    begin
    mpu_retired <= '0;
    mpu_freeze <= '0;
    mpu_vld     <= '0;
    end

  if(mpu_vld & ~mpu_retired)
    begin


    unique
    case (1'b1)
      mpu_MUL    : begin
                   if(mpu_cnt=='d0)
                     begin
                     mpu_freeze <= '1;
                     mpu_cnt <= mpu_cnt + 1;
                     end
                   else if(mpu_cnt=='d2)
                     begin
                     mpu_retired <= '1;
                     mpu_rd_wr <= '1;
                     mpu_rd_data <= product[31:0];
                     mpu_PC_next <= mpu_PC+'d4;
                     mpu_freeze <= '0;
                     mpu_cnt <= '0;
                     end
                   else
                     begin
                     mpu_freeze <= '1;
                     mpu_cnt <= mpu_cnt + 1;
                     end
                   end
      mpu_MULH   : begin
                   if(mpu_cnt=='d0)
                     begin
                     mpu_freeze <= '1;
                     mpu_cnt <= mpu_cnt + 1;
                     end
                   else if(mpu_cnt=='d2)
                     begin
                     mpu_retired <= '1;
                     mpu_rd_wr <= '1;
                     mpu_rd_data <= product[63:32];
                     mpu_PC_next <= mpu_PC+'d4;
                     mpu_freeze <= '0;
                     mpu_cnt <= '0;
                     end
                   else
                     begin
                     mpu_freeze <= '1;
                     mpu_cnt <= mpu_cnt + 1;
                     end
                   end
      mpu_MULHSU : begin
                   if(mpu_cnt=='d0)
                     begin
                     mpu_freeze <= '1;
                     mpu_cnt <= mpu_cnt + 1;
                     end
                   else if(mpu_cnt=='d2)
                     begin
                     mpu_retired <= '1;
                     mpu_rd_wr <= '1;
                     mpu_rd_data <= product_unsigned[63:32];
                     mpu_PC_next <= mpu_PC+'d4;
                     mpu_freeze <= '0;
                     mpu_cnt <= '0;
                     end
                   else
                     begin
                     mpu_freeze <= '1;
                     mpu_cnt <= mpu_cnt + 1;
                     end
                   end
      mpu_MULHU  : begin
                   if(mpu_cnt=='d0)
                     begin
                     mpu_freeze <= '1;
                     mpu_cnt <= mpu_cnt + 1;
                     end
                   else if(mpu_cnt=='d2)
                     begin
                     mpu_retired <= '1;
                     mpu_rd_wr <= '1;
                     mpu_rd_data <= product_signed_unsigned[63:32];
                     mpu_PC_next <= mpu_PC+'d4;
                     mpu_freeze <= '0;
                     mpu_cnt <= '0;
                     end
                   else
                     begin
                     mpu_freeze <= '1;
                     mpu_cnt <= mpu_cnt + 1;
                     end
                   end
          default : begin
                //$display("%0t %-5s PC=%08X : 0x%08X" , $time, "TRAP from INVALID INST!!", mpu_PC, mpu_inst);
                mpu_retired <= '1;
                mpu_freeze <= '0;
                mpu_trap <= '1;
                end
              
      endcase

    if(mpu_PC[1:0] != '0)
      begin
      //$display("%0t %-5s PC=%08X : 0x%08X" , $time, "TRAP from INVALID PC!!", mpu_PC, mpu_inst);
      mpu_trap <= '1;
      end

    end

  if(mpu_rd == '0)
    mpu_rd_data <= '0;

  if(rst)
    begin
    mpu_vld <= '0;
    mpu_retired <= '0;
    mpu_freeze <= '0;
    mpu_cnt <= '0;

    mpu_PC <= '0;
    mpu_PC_next <= '0;
    mpu_rd_wr  <= '0;
    mpu_rd_data <= '0;

    mpu_inst    <= '0;
    mpu_order   <= '0;
    mpu_fm      <= '0;
    mpu_pred    <= '0;
    mpu_succ    <= '0;
    mpu_shamt   <= '0;
    mpu_imm     <= '0;
    mpu_uimm    <= '0;
    mpu_csr     <= '0;
    mpu_funct7  <= '0;
    mpu_funct3  <= '0;
    mpu_rs2     <= '0;
    mpu_rs1     <= '0;
    mpu_rd      <= '0;
    mpu_opcode  <= '0;
              
    mpu_MUL     <= '0;
    mpu_MULH    <= '0;
    mpu_MULHSU  <= '0;
    mpu_MULHU   <= '0;

    end
  end

multiplier multiplier (
  .clock    (clk),
  .dataa  (mpu_rs1_data),
  .datab  (mpu_rs2_data),
  .result (product)
);

multiplier_unsigned multiplier_unsigned (
  .clock    (clk),
  .dataa  (mpu_rs1_data),
  .datab  (mpu_rs2_data),
  .result (product_unsigned)
);

multiplier_signed_unsigned multiplier_signed_unsigned (
  .clock    (clk),
  .dataa  (mpu_rs1_data),
  .datab  ({1'b0,mpu_rs2_data}),
  .result (product_signed_unsigned)
);

endmodule
