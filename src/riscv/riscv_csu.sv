//import riscv_pkg::*;

module riscv_csu (
  input  logic        clk,
  input  logic        rst,

  output logic        csu_vld,
  output logic [31:0] csu_inst,
  output logic        csu_retired,
  output logic        csu_freeze,
  output logic        csu_trap,
  output logic [31:0] csu_PC,
  output logic [31:0] csu_PC_next,
  output logic  [4:0] csu_rs1,
  output logic  [4:0] csu_rs2,
  output logic [31:0] csu_rs1_data,
  output logic [31:0] csu_rs2_data,
  output logic        csu_rd_wr,
  output logic  [4:0] csu_rd,
  output logic [31:0] csu_rd_data,

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

  input  logic dpu_CSRRW,
  input  logic dpu_CSRRS,
  input  logic dpu_CSRRC,
  input  logic dpu_CSRRWI,
  input  logic dpu_CSRRSI,
  input  logic dpu_CSRRCI,

  output logic             csr_req,
  input  logic             csr_ack,
  output logic             csr_write,
  output logic [31:0]      csr_addr,
  output logic [31:0]      csr_mask,
  output logic [31:0]      csr_data_wr,
  input  logic [31:0]      csr_data_rd

);

logic  [3:0] csu_fm;
logic  [3:0] csu_pred;
logic  [3:0] csu_succ;
logic  [4:0] csu_shamt;
logic [31:0] csu_imm;
logic  [4:0] csu_uimm;
logic [11:0] csu_csr;
logic  [6:0] csu_funct7;
logic  [2:0] csu_funct3;
logic  [6:0] csu_opcode;

logic csu_CSRRW;
logic csu_CSRRS;
logic csu_CSRRC;
logic csu_CSRRWI;
logic csu_CSRRSI;
logic csu_CSRRCI;



logic [3:0] csu_cnt;
always_ff @(posedge clk)
  begin
  csu_vld <= csu_vld;
  csu_retired <= '0;
  csu_freeze <= csu_freeze;

  csu_PC      <= csu_PC;
  csu_PC_next <= csu_PC_next;
  csu_rd_wr  <= '0;
  csu_rd_data <= csu_rd_data;

  csr_req   <= '0  ;
  csr_write <= csr_write;
  csr_addr  <= csr_addr ;
  csr_mask  <= csr_mask ;
  csr_data_wr  <= '0;

  csu_rs2_data   <= csu_rs2_data;  
  csu_rs1_data   <= csu_rs1_data;  
  csu_trap       <= '0;   

  csu_inst    <= csu_inst;      
  csu_fm      <= csu_fm;        
  csu_pred    <= csu_pred;      
  csu_succ    <= csu_succ;      
  csu_shamt   <= csu_shamt;     
  csu_imm     <= csu_imm;       
  csu_uimm    <= csu_uimm;      
  csu_csr     <= csu_csr;       
  csu_funct7  <= csu_funct7;    
  csu_funct3  <= csu_funct3;    
  csu_rs2     <= csu_rs2;       
  csu_rs1     <= csu_rs1;       
  csu_rd      <= csu_rd;        
  csu_opcode  <= csu_opcode;    
                                 
  csu_CSRRW   <= csu_CSRRW;     
  csu_CSRRS   <= csu_CSRRS;     
  csu_CSRRC   <= csu_CSRRC;     
  csu_CSRRWI  <= csu_CSRRWI;    
  csu_CSRRSI  <= csu_CSRRSI;    
  csu_CSRRCI  <= csu_CSRRCI;    


  //Capture IDU when IDU is valid and ALU is not valid or is retiring without
  //branch miss or trap
  if((~csu_vld | (csu_vld & csu_retired)) & dpu_vld)
    begin
    csu_vld     <= dpu_vld;
    csu_inst    <= dpu_inst;      
    csu_PC      <= dpu_PC;      

    csu_retired <= '0;
    csu_freeze  <= dpu_vld;

    csu_fm      <= dpu_fm;        
    csu_pred    <= dpu_pred;      
    csu_succ    <= dpu_succ;      
    csu_shamt   <= dpu_shamt;     
    csu_imm     <= dpu_imm;       
    csu_uimm    <= dpu_uimm;      
    csu_csr     <= dpu_csr;       
    csu_funct7  <= dpu_funct7;    
    csu_funct3  <= dpu_funct3;    
    csu_rs2     <= dpu_rs2;       
    csu_rs1     <= dpu_rs1;       
    csu_rd      <= dpu_rd;        
    csu_opcode  <= dpu_opcode;    
                   
    csu_CSRRW   <= dpu_CSRRW;     
    csu_CSRRS   <= dpu_CSRRS;     
    csu_CSRRC   <= dpu_CSRRC;     
    csu_CSRRWI  <= dpu_CSRRWI;    
    csu_CSRRSI  <= dpu_CSRRSI;    
    csu_CSRRCI  <= dpu_CSRRCI;    

    csu_rs1_data<= dpu_rs1_data;      
    csu_rs2_data<= dpu_rs2_data;      

    csr_req   <= '0;
    csr_write <= '0;
    csr_addr  <= '0;
    csr_mask <= '0;
    csr_data_wr  <= '0;
    end
  //Else turn off if retiring
  else if(csu_vld & csu_retired)
    begin
    csu_retired <= '0;
    csu_freeze <= '0;
    csu_vld     <= '0;
    end

  if(csu_vld & ~csu_retired)
    begin


    unique
    case (1'b1)
      csu_CSRRW : begin
                  if(csu_cnt=='d0)
                    begin
                    csr_req   <= '1;
                    csr_write <= '1;
                    csr_addr  <= csu_csr;
                    csr_mask  <= '1;
                    csr_data_wr  <= csu_rs1_data;
                    csu_freeze <= '1;
                    csu_cnt <= csu_cnt + 1;
                    end
                  else if(csu_cnt=='d2)
                    begin
                    //$display("%-5s CSR=%03X rs1=(%d)%08X rd=(%d)", "CSRRW", csu_csr, csu_rs1, csu_rs1_data, csu_rd);
                    csu_retired <= '1;
                    csu_rd_wr <= '1;
                    csu_rd_data <= '0;
                    csu_rd_data <= csr_data_rd;
                    csu_PC_next <= csu_PC+'d4;
                    csu_freeze <= '0;
                    csu_cnt <= '0;
                    end
                  else
                    begin
                    csu_freeze <= '1;
                    csu_cnt <= csu_cnt + 1;
                    end
                  end
      csu_CSRRS : begin
                  if(csu_cnt=='d0)
                    begin
                    csr_req   <= '1;
                    if(csu_rs1 != '0)
                      begin
                      csr_write <= '1;
                      end
                    else
                      begin
                      csr_write <= '0;
                      end
                    csr_addr  <= csu_csr;
                    csr_mask  <= csu_rs1_data;
                    csr_data_wr  <= '1;
                    csu_freeze <= '1;
                    csu_cnt <= csu_cnt + 1;
                    end
                  else if(csu_cnt=='d2)
                    begin
                    //$display("%-5s CSR=%03X rs1=(%d)%08X rd=(%d)", "CSRRS", csu_csr, csu_rs1, csu_rs1_data, csu_rd);
                    csu_retired <= '1;
                    csu_rd_wr <= '1;
                    csu_rd_data <= '0;
                    csu_rd_data <= csr_data_rd;
                    csu_PC_next <= csu_PC+'d4;
                    csu_freeze <= '0;
                    csu_cnt <= '0;
                    end
                  else
                    begin
                    csu_freeze <= '1;
                    csu_cnt <= csu_cnt + 1;
                    end
                  end
      csu_CSRRC : begin
                  if(csu_cnt=='d0)
                    begin
                    csr_req   <= '1;
                    if(csu_rs1 != '0)
                      begin
                      csr_write <= '1;
                      end
                    else
                      begin
                      csr_write <= '0;
                      end
                    csr_addr  <= csu_csr;
                    csr_mask  <= csu_rs1_data;
                    csr_data_wr  <= '0;
                    csu_freeze <= '1;
                    csu_cnt <= csu_cnt + 1;
                    end
                  else if(csu_cnt=='d2)
                    begin
                    //$display("%-5s CSR=%03X rs1=(%d)%08X rd=(%d)", "CSRRS", csu_csr, csu_rs1, csu_rs1_data, csu_rd);
                    csu_retired <= '1;
                    csu_rd_wr <= '1;
                    csu_rd_data <= '0;
                    csu_rd_data <= csr_data_rd;
                    csu_PC_next <= csu_PC+'d4;
                    csu_freeze <= '0;
                    csu_cnt <= '0;
                    end
                  else
                    begin
                    csu_freeze <= '1;
                    csu_cnt <= csu_cnt + 1;
                    end
                  end
      csu_CSRRWI : begin
                  if(csu_cnt=='d0)
                    begin
                    csr_req   <= '1;
                    csr_write <= '1;
                    csr_addr  <= csu_csr;
                    csr_mask  <= '1;
                    csr_data_wr  <= '0;
                    csr_data_wr[4:0]  <= csu_uimm;
                    csu_freeze <= '1;
                    csu_cnt <= csu_cnt + 1;
                    end
                  else if(csu_cnt=='d2)
                    begin
                    //$display("%-5s CSR=%03X rs1=(%d)%08X rd=(%d)", "CSRRWI", csu_csr, csu_rs1, csu_rs1_data, csu_rd);
                    csu_retired <= '1;
                    csu_rd_wr <= '1;
                    csu_rd_data <= '0;
                    csu_rd_data <= csr_data_rd;
                    csu_PC_next <= csu_PC+'d4;
                    csu_freeze <= '0;
                    csu_cnt <= '0;
                    end
                  else
                    begin
                    csu_freeze <= '1;
                    csu_cnt <= csu_cnt + 1;
                    end
                  end
      csu_CSRRSI : begin
                  if(csu_cnt=='d0)
                    begin
                    csr_req   <= '1;
                    if(csu_uimm != '0)
                      begin
                      csr_write <= '1;
                      end
                    else
                      begin
                      csr_write <= '0;
                      end
                    csr_addr  <= csu_csr;
                    csr_mask  <= '1;
                    csr_data_wr  <= '0;
                    csr_data_wr[4:0]  <= csu_uimm;
                    csu_freeze <= '1;
                    csu_cnt <= csu_cnt + 1;
                    end
                  else if(csu_cnt=='d2)
                    begin
                    //$display("%-5s CSR=%03X rs1=(%d)%08X rd=(%d)", "CSRRSI", csu_csr, csu_rs1, csu_rs1_data, csu_rd);
                    csu_retired <= '1;
                    csu_rd_wr <= '1;
                    csu_rd_data <= '0;
                    csu_rd_data <= csr_data_rd;
                    csu_PC_next <= csu_PC+'d4;
                    csu_freeze <= '0;
                    csu_cnt <= '0;
                    end
                  else
                    begin
                    csu_freeze <= '1;
                    csu_cnt <= csu_cnt + 1;
                    end
                  end
      csu_CSRRCI : begin
                  if(csu_cnt=='d0)
                    begin
                    csr_req   <= '1;
                    if(csu_uimm != '0)
                      begin
                      csr_write <= '1;
                      end
                    else
                      begin
                      csr_write <= '0;
                      end
                    csr_addr  <= csu_csr;
                    csr_mask  <= '1;
                    csr_data_wr  <= '0;
                    csr_data_wr[4:0]  <= csu_uimm;
                    csu_freeze <= '1;
                    csu_cnt <= csu_cnt + 1;
                    end
                  else if(csu_cnt=='d2)
                    begin
                    //$display("%-5s CSR=%03X rs1=(%d)%08X rd=(%d)", "CSRRCI", csu_csr, csu_rs1, csu_rs1_data, csu_rd);
                    csu_retired <= '1;
                    csu_rd_wr <= '1;
                    csu_rd_data <= '0;
                    csu_rd_data <= csr_data_rd;
                    csu_PC_next <= csu_PC+'d4;
                    csu_freeze <= '0;
                    csu_cnt <= '0;
                    end
                  else
                    begin
                    csu_freeze <= '1;
                    csu_cnt <= csu_cnt + 1;
                    end
                  end
          default : begin
                //$display("%0t %-5s PC=%08X : 0x%08X" , $time, "TRAP from INVALID INST!!", csu_PC, csu_inst);
                csu_retired <= '1;
                csu_freeze <= '0;
                csu_trap <= '1;
                end
              
      endcase

    if(csu_PC[1:0] != '0)
      begin
      //$display("%0t %-5s PC=%08X : 0x%08X" , $time, "TRAP from INVALID PC!!", csu_PC, csu_inst);
      csu_trap <= '1;
      end

    end

  if(csu_rd == '0)
    csu_rd_data <= '0;

  if(rst)
    begin
    csu_vld <= '0;
    csu_retired <= '0;
    csu_freeze <= '0;
    csu_cnt <= '0;

    csu_PC <= '0;
    csu_PC_next <= '0;
    csu_rd_wr  <= '0;
    csu_rd_data <= '0;

    csr_req   <= '0;
    csr_write <= '0;
    csr_addr  <= '0;
    csr_mask  <= '0;
    csr_data_wr  <= '0;

    csu_inst    <= '0;
    csu_fm      <= '0;
    csu_pred    <= '0;
    csu_succ    <= '0;
    csu_shamt   <= '0;
    csu_imm     <= '0;
    csu_uimm    <= '0;
    csu_csr     <= '0;
    csu_funct7  <= '0;
    csu_funct3  <= '0;
    csu_rs2     <= '0;
    csu_rs1     <= '0;
    csu_rd      <= '0;
    csu_opcode  <= '0;
              
    csu_CSRRW   <= '0;
    csu_CSRRS   <= '0;
    csu_CSRRC   <= '0;
    csu_CSRRWI  <= '0;
    csu_CSRRSI  <= '0;
    csu_CSRRCI  <= '0;

    end
  end
endmodule
