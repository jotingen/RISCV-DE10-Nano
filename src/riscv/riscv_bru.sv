//import riscv_pkg::*;

module riscv_bru (
  input  logic        clk,
  input  logic        rst,

  output logic        bru_vld,
  output logic [31:0] bru_inst,
  output logic        bru_br,
  output logic        bru_br_taken,
  output logic        bru_br_miss,
  output logic        bru_trap,
  output logic [31:0] bru_PC,
  output logic [31:0] bru_PC_next,
  output logic  [4:0] bru_rs1,
  output logic  [4:0] bru_rs2,
  output logic [31:0] bru_rs1_data,
  output logic [31:0] bru_rs2_data,
  output logic        bru_rd_wr,
  output logic  [4:0] bru_rd,
  output logic [31:0] bru_rd_data,

  input  logic        dpu_vld,
  input  logic [31:0] dpu_inst,
  input  logic [31:0] dpu_PC,

  input  logic        dpu_br_taken,
  input  logic [31:0] dpu_br_pred_PC_next,

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

  input  logic [31:0] dpu_PC_next_PC_imm20,
  input  logic [31:0] dpu_PC_next_PC_imm12,
  input  logic [31:0] dpu_PC_next_rs1_imm11,

  input  logic dpu_JAL,
  input  logic dpu_JALR,
  input  logic dpu_BEQ,
  input  logic dpu_BNE,
  input  logic dpu_BLT,
  input  logic dpu_BGE,
  input  logic dpu_BLTU,
  input  logic dpu_BGEU

);




logic [31:0] bru_br_pred_PC_next;

logic  [3:0] bru_fm;
logic  [3:0] bru_pred;
logic  [3:0] bru_succ;
logic  [4:0] bru_shamt;
logic [31:0] bru_imm;
logic  [4:0] bru_uimm;
logic [11:0] bru_csr;
logic  [6:0] bru_funct7;
logic  [2:0] bru_funct3;
logic  [6:0] bru_opcode;

logic bru_JAL;
logic bru_JALR;
logic bru_BEQ;
logic bru_BNE;
logic bru_BLT;
logic bru_BGE;
logic bru_BLTU;
logic bru_BGEU;

always_ff @(posedge clk)
  begin
  bru_vld <= dpu_vld;
  bru_br <= '0;
  bru_br_taken <= dpu_br_taken;
  bru_br_pred_PC_next <= dpu_br_pred_PC_next;
  bru_br_miss <= '0;

  bru_PC      <= dpu_PC;
  bru_PC_next <= '0;
  bru_rd_wr  <= '0;

  bru_rs2_data   <= dpu_rs2_data;  
  bru_rs1_data   <= dpu_rs1_data;  
  bru_rd_data    <= '0;   
  bru_trap       <= '0;   

  bru_inst    <= dpu_inst;      
  bru_fm      <= dpu_fm;        
  bru_pred    <= dpu_pred;      
  bru_succ    <= dpu_succ;      
  bru_shamt   <= dpu_shamt;     
  bru_imm     <= dpu_imm;       
  bru_uimm    <= dpu_uimm;      
  bru_csr     <= dpu_csr;       
  bru_funct7  <= dpu_funct7;    
  bru_funct3  <= dpu_funct3;    
  bru_rs2     <= dpu_rs2;       
  bru_rs1     <= dpu_rs1;       
  bru_rd      <= dpu_rd;        
  bru_opcode  <= dpu_opcode;    
                                 
  bru_JAL     <= dpu_JAL;       
  bru_JALR    <= dpu_JALR;      
  bru_BEQ     <= dpu_BEQ;       
  bru_BNE     <= dpu_BNE;       
  bru_BLT     <= dpu_BLT;       
  bru_BGE     <= dpu_BGE;       
  bru_BLTU    <= dpu_BLTU;      
  bru_BGEU    <= dpu_BGEU;      

  if(dpu_vld)
    begin
    unique
    case (1'b1)
      dpu_JAL : begin
                //if(dpu_imm!='0 || dpu_rd!='0)
                //  $display("%-5s PC=%08X imm=%08X rd=(%d)", "JAL", PC, {{11{dpu_imm[20]}},dpu_imm[20:0]}, dpu_rd);
                bru_br <= '1;
                bru_PC_next <= dpu_PC_next_PC_imm20;
                bru_rd_wr <= '1;
                if(dpu_PC_next_PC_imm20[1:0] != '0)
                  begin
                  bru_trap <= '1;
                  end
                else
                  begin
                  bru_rd_data <= dpu_PC+'d4;
                  if(dpu_br_pred_PC_next != dpu_PC_next_PC_imm20)
                    begin
                    bru_br_miss <= '1;
                    end
                  end
                end
      dpu_JALR : begin
                 //$display("%-5s PC=%08X imm=%08X rd=(%d)", "JALR", PC, {{20{dpu_imm[11]}},dpu_imm[11:0]}, dpu_rd);
                 bru_br <= '1;
                 bru_PC_next <= dpu_PC_next_rs1_imm11;
                 bru_rd_wr <= '1;
                 if(dpu_PC_next_rs1_imm11[1:0] != '0)
                   begin
                   bru_trap <= '1;
                   end
                 else
                   begin
                   bru_rd_data <= dpu_PC+'d4;
                  if(dpu_br_pred_PC_next != dpu_PC_next_rs1_imm11)
                     begin
                     bru_br_miss <= '1;
                     end
                   end
                 end


      dpu_BEQ : begin
                //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BEQ", PC, dpu_rs1, dpu_rs1_data, dpu_rs2, dpu_rs2_data, {{19{dpu_imm[12]}},dpu_imm[12:0]});
                bru_br <= '1;
                if(dpu_rs1_data == dpu_rs2_data)
                  begin
                  bru_PC_next <= dpu_PC_next_PC_imm12;
                  if(dpu_PC_next_PC_imm12[1:0] != '0)
                    begin
                    bru_trap <= '1;
                    end
                  if(dpu_br_pred_PC_next != dpu_PC_next_PC_imm12)
                    begin
                    bru_br_miss <= '1;
                    end
                  end
                else                  
                  begin
                  bru_PC_next <= dpu_PC+'d4;
                  if(dpu_br_pred_PC_next != dpu_PC+'d4)
                    begin
                    bru_br_miss <= '1;
                    end
                  end
                end
      dpu_BNE : begin
                //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BNE", PC, dpu_rs1, dpu_rs1_data, dpu_rs2, dpu_rs2_data, {{19{dpu_imm[12]}},dpu_imm[12:0]});
                bru_br <= '1;
                if(dpu_rs1_data != dpu_rs2_data)
                  begin
                  bru_PC_next <= dpu_PC_next_PC_imm12;
                  if(dpu_PC_next_PC_imm12[1:0] != '0)
                    begin
                    bru_trap <= '1;
                    end
                  if(dpu_br_pred_PC_next != dpu_PC_next_PC_imm12)
                    begin
                    bru_br_miss <= '1;
                    end
                  end
                else                  
                  begin
                  bru_PC_next <= dpu_PC+'d4;
                  if(dpu_br_pred_PC_next != dpu_PC+'d4)
                    begin
                    bru_br_miss <= '1;
                    end
                  end
                end
      dpu_BLT : begin
                //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BLT", PC, dpu_rs1, dpu_rs1_data, dpu_rs2, dpu_rs2_data, {{19{dpu_imm[12]}},dpu_imm[12:0]});
                bru_br <= '1;
                if($signed(dpu_rs1_data) < $signed(dpu_rs2_data))
                  begin
                  bru_PC_next <= dpu_PC_next_PC_imm12;
                  if(dpu_PC_next_PC_imm12[1:0] != '0)
                    begin
                    bru_trap <= '1;
                    end
                  if(dpu_br_pred_PC_next != dpu_PC_next_PC_imm12)
                    begin
                    bru_br_miss <= '1;
                    end
                  end
                else                  
                  begin
                  bru_PC_next <= dpu_PC+'d4;
                  if(dpu_br_pred_PC_next != dpu_PC+'d4)
                    begin
                    bru_br_miss <= '1;
                    end
                  end
                end
      dpu_BLTU : begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BLTU", PC, dpu_rs1, dpu_rs1_data, dpu_rs2, dpu_rs2_data, {{19{dpu_imm[12]}},dpu_imm[12:0]});
                bru_br <= '1;
                 if(dpu_rs1_data < dpu_rs2_data)
                  begin
                  bru_PC_next <= dpu_PC_next_PC_imm12;
                  if(dpu_PC_next_PC_imm12[1:0] != '0)
                    begin
                    bru_trap <= '1;
                    end
                  if(dpu_br_pred_PC_next != dpu_PC_next_PC_imm12)
                    begin
                    bru_br_miss <= '1;
                    end
                  end
                 else                  
                   begin
                   bru_PC_next <= dpu_PC+'d4;
                  if(dpu_br_pred_PC_next != dpu_PC+'d4)
                    begin
                    bru_br_miss <= '1;
                    end
                   end
                 end
      dpu_BGE : begin
                //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BGE", PC, dpu_rs1, dpu_rs1_data, dpu_rs2, dpu_rs2_data, {{19{dpu_imm[12]}},dpu_imm[12:0]});
                bru_br <= '1;
                if($signed(dpu_rs1_data) >= $signed(dpu_rs2_data))
                  begin
                  bru_PC_next <= dpu_PC_next_PC_imm12;
                  if(dpu_PC_next_PC_imm12[1:0] != '0)
                    begin
                    bru_trap <= '1;
                    end
                  if(dpu_br_pred_PC_next != dpu_PC_next_PC_imm12)
                    begin
                    bru_br_miss <= '1;
                    end
                  end
                else                  
                  begin
                  bru_PC_next <= dpu_PC+'d4;
                  if(dpu_br_pred_PC_next != dpu_PC+'d4)
                    begin
                    bru_br_miss <= '1;
                    end
                  end
                end
      dpu_BGEU : begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BGEU", PC, dpu_rs1, dpu_rs1_data, dpu_rs2, dpu_rs2_data, {{19{dpu_imm[12]}},dpu_imm[12:0]});
                bru_br <= '1;
                 if(dpu_rs1_data >= dpu_rs2_data)
                  begin
                   bru_PC_next <= dpu_PC_next_PC_imm12;
                   if(dpu_PC_next_PC_imm12[1:0] != '0)
                     begin
                     bru_trap <= '1;
                     end
                  if(dpu_br_pred_PC_next != dpu_PC_next_PC_imm12)
                    begin
                    bru_br_miss <= '1;
                    end
                  end
                 else                  
                   begin
                   bru_PC_next <= dpu_PC+'d4;
                   if(dpu_br_pred_PC_next != dpu_PC+'d4)
                     begin
                     bru_br_miss <= '1;
                     end
                   end
                 end


          default : begin
                //$display("%0t %-5s PC=%08X : 0x%08X" , $time, "TRAP from INVALID INST!!", dpu_PC, dpu_inst);
                bru_trap <= '1;
                end
              
      endcase

    if(dpu_PC[1:0] != '0)
      begin
      //$display("%0t %-5s PC=%08X : 0x%08X" , $time, "TRAP from INVALID PC!!", dpu_PC, dpu_inst);
      bru_trap <= '1;
      end

    end

  if(dpu_rd == '0)
    bru_rd_data <= '0;

  if(rst)
    begin
    bru_vld <= '0;
    bru_br <= '0;
    bru_br_miss <= '0;

    bru_PC <= '0;
    bru_PC_next <= '0;
    bru_rd_wr  <= '0;
    bru_rd_data <= '0;

    bru_inst    <= '0;
    bru_fm      <= '0;
    bru_pred    <= '0;
    bru_succ    <= '0;
    bru_shamt   <= '0;
    bru_imm     <= '0;
    bru_uimm    <= '0;
    bru_csr     <= '0;
    bru_funct7  <= '0;
    bru_funct3  <= '0;
    bru_rs2     <= '0;
    bru_rs1     <= '0;
    bru_rd      <= '0;
    bru_opcode  <= '0;
              
    bru_JAL     <= '0;
    bru_JALR    <= '0;
    bru_BEQ     <= '0;
    bru_BNE     <= '0;
    bru_BLT     <= '0;
    bru_BGE     <= '0;
    bru_BLTU    <= '0;
    bru_BGEU    <= '0;
    end
  end

endmodule
