//import riscv_pkg::*;

module riscv_dvu#(
  parameter M_EXT = 1
)  (
  input  logic        clk,
  input  logic        rst,

  output logic        dvu_vld,
  output logic [31:0] dvu_inst,
  output logic        dvu_retired,
  output logic        dvu_freeze,
  output logic        dvu_trap,
  output logic [31:0] dvu_PC,
  output logic [31:0] dvu_PC_next,
  output logic  [4:0] dvu_rs1,
  output logic  [4:0] dvu_rs2,
  output logic [31:0] dvu_rs1_data,
  output logic [31:0] dvu_rs2_data,
  output logic        dvu_rd_wr,
  output logic  [4:0] dvu_rd,
  output logic [31:0] dvu_rd_data,

  input  logic        dpu_vld,
  input  logic [31:0] dpu_inst,
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

  input  logic dpu_DIV,
  input  logic dpu_DIVU,
  input  logic dpu_REM,
  input  logic dpu_REMU

);

logic  [3:0] dvu_fm;
logic  [3:0] dvu_pred;
logic  [3:0] dvu_succ;
logic  [4:0] dvu_shamt;
logic [31:0] dvu_imm;
logic  [4:0] dvu_uimm;
logic [11:0] dvu_csr;
logic  [6:0] dvu_funct7;
logic  [2:0] dvu_funct3;
logic  [6:0] dvu_opcode;

logic dvu_DIV;
logic dvu_DIVU;
logic dvu_REM;
logic dvu_REMU;

logic [31:0] addr;


logic [31:0] quotient;
logic [31:0] quotient_unsigned;

logic [31:0] remainder;
logic [31:0] remainder_unsigned;

logic [3:0] dvu_cnt;
always_ff @(posedge clk)
  begin
  dvu_vld <= dvu_vld;
  dvu_retired <= '0;
  dvu_freeze <= dvu_freeze;

  dvu_PC      <= dvu_PC;
  dvu_PC_next <= dvu_PC_next;
  dvu_rd_wr  <= '0;
  dvu_rd_data <= dvu_rd_data;

  dvu_rs2_data   <= dvu_rs2_data;  
  dvu_rs1_data   <= dvu_rs1_data;  
  dvu_trap       <= '0;   

  dvu_inst    <= dvu_inst;      
  dvu_fm      <= dvu_fm;        
  dvu_pred    <= dvu_pred;      
  dvu_succ    <= dvu_succ;      
  dvu_shamt   <= dvu_shamt;     
  dvu_imm     <= dvu_imm;       
  dvu_uimm    <= dvu_uimm;      
  dvu_csr     <= dvu_csr;       
  dvu_funct7  <= dvu_funct7;    
  dvu_funct3  <= dvu_funct3;    
  dvu_rs2     <= dvu_rs2;       
  dvu_rs1     <= dvu_rs1;       
  dvu_rd      <= dvu_rd;        
  dvu_opcode  <= dvu_opcode;    
                                 
  dvu_DIV     <= dvu_DIV;
  dvu_DIVU    <= dvu_DIVU;
  dvu_REM     <= dvu_REM;
  dvu_REMU    <= dvu_REMU;

  //Capture IDU when IDU is valid and ALU is not valid or is retiring without
  //branch miss or trap
  if((~dvu_vld | (dvu_vld & dvu_retired)) & dpu_vld)
    begin
    dvu_vld     <= '1;
    dvu_inst    <= dpu_inst;      
    dvu_PC      <= dpu_PC;      

    dvu_retired <= '0;
    dvu_freeze  <= '1;

    dvu_fm      <= dpu_fm;        
    dvu_pred    <= dpu_pred;      
    dvu_succ    <= dpu_succ;      
    dvu_shamt   <= dpu_shamt;     
    dvu_imm     <= dpu_imm;       
    dvu_uimm    <= dpu_uimm;      
    dvu_csr     <= dpu_csr;       
    dvu_funct7  <= dpu_funct7;    
    dvu_funct3  <= dpu_funct3;    
    dvu_rs2     <= dpu_rs2;       
    dvu_rs1     <= dpu_rs1;       
    dvu_rd      <= dpu_rd;        
    dvu_opcode  <= dpu_opcode;    
                   
    dvu_DIV     <= dpu_DIV;  
    dvu_DIVU    <= dpu_DIVU; 
    dvu_REM     <= dpu_REM;  
    dvu_REMU    <= dpu_REMU; 

    dvu_rs1_data<= dpu_rs1_data;      
    dvu_rs2_data<= dpu_rs2_data;      
    end
  //Else turn off if retiring
  else if(dvu_vld & dvu_retired)
    begin
    dvu_retired <= '0;
    dvu_freeze <= '0;
    dvu_vld     <= '0;
    end

  if(dvu_vld & ~dvu_retired)
    begin
    unique
    case (1'b1)
      dvu_DIV    : begin
                   if(dvu_cnt=='d0)
                     begin
                     dvu_freeze <= '1;
                     dvu_cnt <= dvu_cnt + 1;
                     end
                   else if(dvu_cnt=='d10)
                     begin
                     dvu_retired <= '1;
                     dvu_rd_wr <= '1;
                     dvu_rd_data <= quotient[31:0];
                     dvu_PC_next <= dvu_PC+'d4;
                     dvu_freeze <= '0;
                     dvu_cnt <= '0;
                     end
                   else
                     begin
                     dvu_freeze <= '1;
                     dvu_cnt <= dvu_cnt + 1;
                     end
                   end
      dvu_DIVU   : begin
                   if(dvu_cnt=='d0)
                     begin
                     dvu_freeze <= '1;
                     dvu_cnt <= dvu_cnt + 1;
                     end
                   else if(dvu_cnt=='d10)
                     begin
                     dvu_retired <= '1;
                     dvu_rd_wr <= '1;
                     dvu_rd_data <= quotient_unsigned[31:0];
                     dvu_PC_next <= dvu_PC+'d4;
                     dvu_freeze <= '0;
                     dvu_cnt <= '0;
                     end
                   else
                     begin
                     dvu_freeze <= '1;
                     dvu_cnt <= dvu_cnt + 1;
                     end
                   end
      dvu_REM    : begin
                   if(dvu_cnt=='d0)
                     begin
                     dvu_freeze <= '1;
                     dvu_cnt <= dvu_cnt + 1;
                     end
                   else if(dvu_cnt=='d10)
                     begin
                     dvu_retired <= '1;
                     dvu_rd_wr <= '1;
                     dvu_rd_data <= remainder[31:0];
                     dvu_PC_next <= dvu_PC+'d4;
                     dvu_freeze <= '0;
                     dvu_cnt <= '0;
                     end
                   else
                     begin
                     dvu_freeze <= '1;
                     dvu_cnt <= dvu_cnt + 1;
                     end
                   end
      dvu_REMU   : begin
                   if(dvu_cnt=='d0)
                     begin
                     dvu_freeze <= '1;
                     dvu_cnt <= dvu_cnt + 1;
                     end
                   else if(dvu_cnt=='d10)
                     begin
                     dvu_retired <= '1;
                     dvu_rd_wr <= '1;
                     dvu_rd_data <= remainder_unsigned[31:0];
                     dvu_PC_next <= dvu_PC+'d4;
                     dvu_freeze <= '0;
                     dvu_cnt <= '0;
                     end
                   else
                     begin
                     dvu_freeze <= '1;
                     dvu_cnt <= dvu_cnt + 1;
                     end
                   end
          default : begin
                //$display("%0t %-5s PC=%08X : 0x%08X" , $time, "TRAP from INVALID INST!!", dvu_PC, dvu_inst);
                dvu_retired <= '1;
                dvu_freeze <= '0;
                dvu_trap <= '1;
                end
              
      endcase

    if(dvu_PC[1:0] != '0)
      begin
      //$display("%0t %-5s PC=%08X : 0x%08X" , $time, "TRAP from INVALID PC!!", dvu_PC, dvu_inst);
      dvu_trap <= '1;
      end

    end

  if(dvu_rd == '0)
    dvu_rd_data <= '0;

  if(rst)
    begin
    dvu_vld <= '0;
    dvu_retired <= '0;
    dvu_freeze <= '0;
    dvu_cnt <= '0;

    dvu_PC <= '0;
    dvu_PC_next <= '0;
    dvu_rd_wr  <= '0;
    dvu_rd_data <= '0;

    dvu_inst    <= '0;
    dvu_fm      <= '0;
    dvu_pred    <= '0;
    dvu_succ    <= '0;
    dvu_shamt   <= '0;
    dvu_imm     <= '0;
    dvu_uimm    <= '0;
    dvu_csr     <= '0;
    dvu_funct7  <= '0;
    dvu_funct3  <= '0;
    dvu_rs2     <= '0;
    dvu_rs1     <= '0;
    dvu_rd      <= '0;
    dvu_opcode  <= '0;
              
    dvu_DIV     <= '0;
    dvu_DIVU    <= '0;
    dvu_REM     <= '0;
    dvu_REMU    <= '0;

    end
  end

divider divider (
  .clock    (clk),
  .denom    (dvu_rs2_data),
  .numer    (dvu_rs1_data),
  .quotient (quotient),
  .remain   (remainder)
);

divider_unsigned divider_unsigned (
  .clock    (clk),
  .denom    (dvu_rs2_data),
  .numer    (dvu_rs1_data),
  .quotient (quotient_unsigned),
  .remain   (remainder_unsigned)
);

endmodule
