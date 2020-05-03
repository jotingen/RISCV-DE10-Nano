import wishbone_pkg::*;

module riscv_lsu(
  input  logic        clk,
  input  logic        rst,

  output logic        lsu_vld,
  output logic [31:0] lsu_inst,
  output logic [63:0] lsu_order,
  output logic        lsu_retired,
  output logic        lsu_freeze,
  output logic        lsu_trap,
  output logic [31:0] lsu_PC,
  output logic [31:0] lsu_PC_next,
  output logic  [4:0] lsu_rs1,
  output logic  [4:0] lsu_rs2,
  output logic [31:0] lsu_rs1_data,
  output logic [31:0] lsu_rs2_data,
  output logic        lsu_rd_wr,
  output logic  [4:0] lsu_rd,
  output logic [31:0] lsu_rd_data,
  output logic [31:0] lsu_mem_rdata,

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

  input  logic dpu_LB,
  input  logic dpu_LH,
  input  logic dpu_LW,
  input  logic dpu_LBU,
  input  logic dpu_LHU,
  input  logic dpu_SB,
  input  logic dpu_SH,
  input  logic dpu_SW,

  output wishbone_pkg::bus_req_t bus_data_o,
  input  wishbone_pkg::bus_rsp_t bus_data_i

);

logic  [3:0] lsu_fm;
logic  [3:0] lsu_pred;
logic  [3:0] lsu_succ;
logic  [4:0] lsu_shamt;
logic [31:0] lsu_imm;
logic  [4:0] lsu_uimm;
logic [11:0] lsu_csr;
logic  [6:0] lsu_funct7;
logic  [2:0] lsu_funct3;
logic  [6:0] lsu_opcode;

logic lsu_LB;
logic lsu_LH;
logic lsu_LW;
logic lsu_LBU;
logic lsu_LHU;
logic lsu_SB;
logic lsu_SH;
logic lsu_SW;

logic [31:0] addr;


logic        lsu_mem_access;

always_ff @(posedge clk)
  begin
  lsu_vld <= lsu_vld;
  lsu_retired <= '0;
  lsu_freeze <= lsu_freeze;
  lsu_mem_access <= lsu_mem_access;

  lsu_PC      <= lsu_PC;
  lsu_PC_next <= lsu_PC_next;
  lsu_rd_wr  <= '0;
  lsu_rd_data <= lsu_rd_data;

  bus_data_o.Stb  <= '0;
  bus_data_o.Cyc  <= '0;
  bus_data_o.Adr  <= bus_data_o.Adr;
  bus_data_o.Data <= bus_data_o.Data;
  bus_data_o.We   <= bus_data_o.We; 
  bus_data_o.Sel  <= bus_data_o.Sel;
  bus_data_o.Tga  <= bus_data_o.Tga;
  bus_data_o.Tgd  <= bus_data_o.Tgd;
  bus_data_o.Tgc  <= bus_data_o.Tgc;

  lsu_rs2_data   <= lsu_rs2_data;  
  lsu_rs1_data   <= lsu_rs1_data;  
  lsu_trap       <= '0;   

  lsu_inst    <= lsu_inst;      
  lsu_order   <= lsu_order;      
  lsu_fm      <= lsu_fm;        
  lsu_pred    <= lsu_pred;      
  lsu_succ    <= lsu_succ;      
  lsu_shamt   <= lsu_shamt;     
  lsu_imm     <= lsu_imm;       
  lsu_uimm    <= lsu_uimm;      
  lsu_csr     <= lsu_csr;       
  lsu_funct7  <= lsu_funct7;    
  lsu_funct3  <= lsu_funct3;    
  lsu_rs2     <= lsu_rs2;       
  lsu_rs1     <= lsu_rs1;       
  lsu_rd      <= lsu_rd;        
  lsu_opcode  <= lsu_opcode;    
                                 
  lsu_LB      <= lsu_LB;        
  lsu_LH      <= lsu_LH;        
  lsu_LW      <= lsu_LW;        
  lsu_LBU     <= lsu_LBU;       
  lsu_LHU     <= lsu_LHU;       
  lsu_SB      <= lsu_SB;        
  lsu_SH      <= lsu_SH;        
  lsu_SW      <= lsu_SW;        

  lsu_mem_rdata <= lsu_mem_rdata;

  //Capture IDU when IDU is valid and ALU is not valid or is retiring without
  //branch miss or trap
  if((~lsu_vld | (lsu_vld & lsu_retired)) & dpu_vld)
    begin
    lsu_vld     <= dpu_vld;
    lsu_inst    <= dpu_inst;      
    lsu_order   <= dpu_order;      
    lsu_PC      <= dpu_PC;      

    lsu_retired <= '0;
    lsu_freeze  <= dpu_vld;

    lsu_fm      <= dpu_fm;        
    lsu_pred    <= dpu_pred;      
    lsu_succ    <= dpu_succ;      
    lsu_shamt   <= dpu_shamt;     
    lsu_imm     <= dpu_imm;       
    lsu_uimm    <= dpu_uimm;      
    lsu_csr     <= dpu_csr;       
    lsu_funct7  <= dpu_funct7;    
    lsu_funct3  <= dpu_funct3;    
    lsu_rs2     <= dpu_rs2;       
    lsu_rs1     <= dpu_rs1;       
    lsu_rd      <= dpu_rd;        
    lsu_opcode  <= dpu_opcode;    
                   
    lsu_LB      <= dpu_LB;        
    lsu_LH      <= dpu_LH;        
    lsu_LW      <= dpu_LW;        
    lsu_LBU     <= dpu_LBU;       
    lsu_LHU     <= dpu_LHU;       
    lsu_SB      <= dpu_SB;        
    lsu_SH      <= dpu_SH;        
    lsu_SW      <= dpu_SW;        

    lsu_rs1_data<= dpu_rs1_data;      
    lsu_rs2_data<= dpu_rs2_data;      

    bus_data_o.Stb  <= '0;
    bus_data_o.Cyc  <= '0;
    bus_data_o.Adr  <= '0;
    bus_data_o.Data <= '0;
    bus_data_o.We   <= '0;
    bus_data_o.Sel  <= '0;
    bus_data_o.Tga  <= '0;
    bus_data_o.Tgd  <= '0;
    bus_data_o.Tgc  <= '0;
    end
  //Else turn off if retiring
  else if(lsu_vld & lsu_retired)
    begin
    lsu_retired <= '0;
    lsu_mem_access <= '0;
    lsu_freeze <= '0;
    lsu_vld     <= '0;
    end

  if(lsu_vld & ~lsu_retired)
    begin


    unique
    case (1'b1)
      lsu_LB : begin
               if(~lsu_mem_access)
                 begin
                 bus_data_o.Stb  <= '1;
                 bus_data_o.Cyc  <= '1;
                 bus_data_o.We   <= '1;
                 addr  = lsu_rs1_data + { {20{lsu_imm[11]}}, lsu_imm[11:0]};
                 bus_data_o.Adr  <= addr;
                 bus_data_o.Adr[1:0]  <= '0;
                 unique
                 case(addr[1:0])
                   'b00: bus_data_o.Sel <= 'b0001;
                   'b01: bus_data_o.Sel <= 'b0010;
                   'b10: bus_data_o.Sel <= 'b0100;
                   default: bus_data_o.Sel <= 'b1000;
                 endcase
                 lsu_freeze <= '1;
                 lsu_mem_access <= '1;
                 end
               else if(bus_data_i.Ack)
                 begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "LW", PC, lsu_rs1, lsu_rs1_data, {{20{lsu_imm[11]}},lsu_imm[11:0]}, lsu_rd);
                 lsu_retired <= '1;
                lsu_freeze <= '0;
                 lsu_mem_access <= '0;
                 lsu_rd_wr <= '1;
                 addr  = lsu_rs1_data + { {20{lsu_imm[11]}}, lsu_imm[11:0]};
                 unique
                 case(addr[1:0])
                   'b00: lsu_rd_data <= {{24{bus_data_i.Data[7]}},bus_data_i.Data[7:0]};
                   'b01: lsu_rd_data <= {{24{bus_data_i.Data[15]}},bus_data_i.Data[15:8]};
                   'b10: lsu_rd_data <= {{24{bus_data_i.Data[23]}},bus_data_i.Data[23:16]};
                   default: lsu_rd_data <= {{24{bus_data_i.Data[31]}},bus_data_i.Data[31:24]};
                 endcase
                 lsu_mem_rdata <= bus_data_i.Data;
                 lsu_PC_next <= lsu_PC+'d4;
                 end
               end
      lsu_LBU : begin
               if(~lsu_mem_access)
                 begin
                 bus_data_o.Stb  <= '1;
                 bus_data_o.Cyc  <= '1;
                 bus_data_o.We <= '0;
                 addr  = lsu_rs1_data + { {20{lsu_imm[11]}}, lsu_imm[11:0]};
                 bus_data_o.Adr  <= addr;
                 bus_data_o.Adr[1:0] <= '0;
                 unique
                 case(addr[1:0])
                   'b00: bus_data_o.Sel <= 'b0001;
                   'b01: bus_data_o.Sel <= 'b0010;
                   'b10: bus_data_o.Sel <= 'b0100;
                   default: bus_data_o.Sel <= 'b1000;
                 endcase
                 lsu_freeze <= '1;
                 lsu_mem_access <= '1;
                 end
               else if(bus_data_i.Ack)
                 begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "LW", PC, lsu_rs1, lsu_rs1_data, {{20{lsu_imm[11]}},lsu_imm[11:0]}, lsu_rd);
                 lsu_retired <= '1;
                lsu_freeze <= '0;
                 lsu_mem_access <= '0;
                 lsu_rd_wr <= '1;
                 addr  = lsu_rs1_data + { {20{lsu_imm[11]}}, lsu_imm[11:0]};
                 unique
                 case(addr[1:0])
                   'b00: lsu_rd_data <= {{24{'0}},bus_data_i.Data[7:0]};
                   'b01: lsu_rd_data <= {{24{'0}},bus_data_i.Data[15:8]};
                   'b10: lsu_rd_data <= {{24{'0}},bus_data_i.Data[23:16]};
                   default: lsu_rd_data <= {{24{'0}},bus_data_i.Data[31:24]};
                 endcase
                 lsu_mem_rdata <= bus_data_i.Data;
                 lsu_PC_next <= lsu_PC+'d4;
                 end
               end
      lsu_LH : begin
               if(~lsu_mem_access)
                 begin
                 bus_data_o.Stb  <= '1;
                 bus_data_o.Cyc  <= '1;
                 bus_data_o.We <= '0;
                 addr  = lsu_rs1_data + { {20{lsu_imm[11]}}, lsu_imm[11:0]};
                 bus_data_o.Adr  <= addr;
                 bus_data_o.Adr[1:0] <= '0;
                 unique
                 case(addr[1])
                   'b0: bus_data_o.Sel <= 'b0011;
                   default: bus_data_o.Sel <= 'b1100;
                 endcase
                 lsu_freeze <= '1;
                 lsu_mem_access <= '1;
                 end
               else if(bus_data_i.Ack)
                 begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "LW", PC, lsu_rs1, lsu_rs1_data, {{20{lsu_imm[11]}},lsu_imm[11:0]}, lsu_rd);
                 lsu_retired <= '1;
                lsu_freeze <= '0;
                 lsu_mem_access <= '0;
                 lsu_rd_wr <= '1;
                 addr  = lsu_rs1_data + { {20{lsu_imm[11]}}, lsu_imm[11:0]};
                 unique
                 case(addr[1])
                   'b0: lsu_rd_data <= {{16{bus_data_i.Data[15]}},bus_data_i.Data[15:0]};
                   default: lsu_rd_data <= {{16{bus_data_i.Data[31]}},bus_data_i.Data[31:16]};
                 endcase
                 lsu_mem_rdata <= bus_data_i.Data;
                 lsu_PC_next <= lsu_PC+'d4;
                 end
               end
      lsu_LHU : begin
               if(~lsu_mem_access)
                 begin
                 bus_data_o.Stb  <= '1;
                 bus_data_o.Cyc  <= '1;
                 bus_data_o.We <= '0;
                 addr  = lsu_rs1_data + { {20{lsu_imm[11]}}, lsu_imm[11:0]};
                 bus_data_o.Adr  <= addr;
                 bus_data_o.Adr[1:0] <= '0;
                 unique
                 case(addr[1])
                   'b0: bus_data_o.Sel <= 'b0011;
                   default: bus_data_o.Sel <= 'b1100;
                 endcase
                 lsu_freeze <= '1;
                 lsu_mem_access <= '1;
                 end
               else if(bus_data_i.Ack)
                 begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "LW", PC, lsu_rs1, lsu_rs1_data, {{20{lsu_imm[11]}},lsu_imm[11:0]}, lsu_rd);
                 lsu_retired <= '1;
                lsu_freeze <= '0;
                 lsu_mem_access <= '0;
                 lsu_rd_wr <= '1;
                 addr  = lsu_rs1_data + { {20{lsu_imm[11]}}, lsu_imm[11:0]};
                 unique
                 case(addr[1])
                   'b0: lsu_rd_data <= {{16{'0}},bus_data_i.Data[15:0]};
                   default: lsu_rd_data <= {{16{'0}},bus_data_i.Data[31:16]};
                 endcase
                 lsu_mem_rdata <= bus_data_i.Data;
                 lsu_PC_next <= lsu_PC+'d4;
                 end
               end
      lsu_LW : begin
               if(~lsu_mem_access)
                 begin
                 bus_data_o.Stb  <= '1;
                 bus_data_o.Cyc  <= '1;
                 bus_data_o.We <= '0;
                 addr  = lsu_rs1_data + { {20{lsu_imm[11]}}, lsu_imm[11:0]};
                 bus_data_o.Adr  <= addr;
                 bus_data_o.Adr[1:0] <= '0;
                 bus_data_o.Sel <= 'b1111;
                 lsu_freeze <= '1;
                 lsu_mem_access <= '1;
                 end
               else if(bus_data_i.Ack)
                 begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "LW", PC, lsu_rs1, lsu_rs1_data, {{20{lsu_imm[11]}},lsu_imm[11:0]}, lsu_rd);
                 lsu_retired <= '1;
                lsu_freeze <= '0;
                 lsu_mem_access <= '0;
                 lsu_rd_wr <= '1;
                 lsu_rd_data <= bus_data_i.Data;
                 lsu_mem_rdata <= bus_data_i.Data;
                 lsu_PC_next <= lsu_PC+'d4;
                 end
               end
      lsu_SB : begin
               if(~lsu_mem_access)
                 begin
                 bus_data_o.Stb  <= '1;
                 bus_data_o.Cyc  <= '1;
                 bus_data_o.We <= '1;
                 addr  = lsu_rs1_data + { {20{lsu_imm[11]}}, lsu_imm[11:0]};
                 bus_data_o.Adr  <= addr;
                 bus_data_o.Adr[1:0] <= '0;
                 unique
                 case(addr[1:0])
                   'b00: bus_data_o.Data  <= {{24{'0}},lsu_rs2_data[7:0]};
                   'b01: bus_data_o.Data  <= {{16{'0}},lsu_rs2_data[7:0],{8 {'0}}};
                   'b10: bus_data_o.Data  <= {{ 8{'0}},lsu_rs2_data[7:0],{16{'0}}};
                   default: bus_data_o.Data  <= {         lsu_rs2_data[7:0],{24{'0}}};
                 endcase
                 unique
                 case(addr[1:0])
                   'b00: bus_data_o.Sel <= 'b0001;
                   'b01: bus_data_o.Sel <= 'b0010;
                   'b10: bus_data_o.Sel <= 'b0100;
                   default: bus_data_o.Sel <= 'b1000;
                 endcase
                 lsu_freeze <= '1;
                 lsu_mem_access <= '1;
                 end
               else if(bus_data_i.Ack)
                 begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "SW", PC, lsu_rs1, lsu_rs1_data, lsu_rs2, lsu_rs2_data, {{20{lsu_imm[11]}},lsu_imm[11:0]});
                 lsu_retired <= '1;
                lsu_freeze <= '0;
                 lsu_mem_access <= '0;
                 lsu_PC_next <= lsu_PC+'d4;
                 end
               end
      lsu_SH : begin
               if(~lsu_mem_access)
                 begin
                 bus_data_o.Stb  <= '1;
                 bus_data_o.Cyc  <= '1;
                 bus_data_o.We <= '1;
                 addr  = lsu_rs1_data + { {20{lsu_imm[11]}}, lsu_imm[11:0]};
                 bus_data_o.Adr  <= addr;
                 bus_data_o.Adr[1:0] <= '0;
                 unique
                 case(addr[1])
                   'b0: bus_data_o.Data  <= {{16{'0}},lsu_rs2_data[15:0]};
                   default: bus_data_o.Data  <= {         lsu_rs2_data[15:0],{16{'0}}};
                 endcase
                 unique
                 case(addr[1])
                   'b0: bus_data_o.Sel <= 'b0011;
                   default: bus_data_o.Sel <= 'b1100;
                 endcase
                 lsu_freeze <= '1;
                 lsu_mem_access <= '1;
                 end
               else if(bus_data_i.Ack)
                 begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "SW", PC, lsu_rs1, lsu_rs1_data, lsu_rs2, lsu_rs2_data, {{20{lsu_imm[11]}},lsu_imm[11:0]});
                 lsu_retired <= '1;
                lsu_freeze <= '0;
                 lsu_mem_access <= '0;
                 lsu_PC_next <= lsu_PC+'d4;
                 end
               end
      lsu_SW : begin
               if(~lsu_mem_access)
                 begin
                 bus_data_o.Stb  <= '1;
                 bus_data_o.Cyc  <= '1;
                 bus_data_o.We <= '1;
                 addr  = lsu_rs1_data + { {20{lsu_imm[11]}}, lsu_imm[11:0]};
                 bus_data_o.Adr  <= addr;
                 bus_data_o.Adr[1:0] <= '0;
                 bus_data_o.Data  <= lsu_rs2_data;
                 bus_data_o.Sel <= 'b1111;
                 lsu_freeze <= '1;
                 lsu_mem_access <= '1;
                 end
               else if(bus_data_i.Ack)
                 begin
                 //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "SW", PC, lsu_rs1, lsu_rs1_data, lsu_rs2, lsu_rs2_data, {{20{lsu_imm[11]}},lsu_imm[11:0]});
                 lsu_retired <= '1;
                 lsu_freeze <= '0;
                 lsu_mem_access <= '0;
                 lsu_PC_next <= lsu_PC+'d4;
                 end
               end
          default : begin
                //$display("%0t %-5s PC=%08X : 0x%08X" , $time, "TRAP from INVALID INST!!", lsu_PC, lsu_inst);
                lsu_retired <= '1;
                lsu_freeze <= '0;
                lsu_trap <= '1;
                end
              
      endcase

    if(lsu_PC[1:0] != '0)
      begin
      //$display("%0t %-5s PC=%08X : 0x%08X" , $time, "TRAP from INVALID PC!!", lsu_PC, lsu_inst);
      lsu_trap <= '1;
      end

    end

  if(lsu_rd == '0)
    lsu_rd_data <= '0;

  if(rst)
    begin
    lsu_vld <= '0;
    lsu_retired <= '0;
    lsu_mem_access <= '0;
    lsu_freeze <= '0;

    lsu_PC <= '0;
    lsu_PC_next <= '0;
    lsu_rd_wr  <= '0;
    lsu_rd_data <= '0;

    bus_data_o.Stb  <= '0;
    bus_data_o.Cyc  <= '0;
    bus_data_o.We <= '0;
    bus_data_o.Adr  <= '0;
    bus_data_o.Data  <= '0 ;

    lsu_inst    <= '0;
    lsu_order   <= '0;
    lsu_fm      <= '0;
    lsu_pred    <= '0;
    lsu_succ    <= '0;
    lsu_shamt   <= '0;
    lsu_imm     <= '0;
    lsu_uimm    <= '0;
    lsu_csr     <= '0;
    lsu_funct7  <= '0;
    lsu_funct3  <= '0;
    lsu_rs2     <= '0;
    lsu_rs1     <= '0;
    lsu_rd      <= '0;
    lsu_opcode  <= '0;
              
    lsu_LB      <= '0;
    lsu_LH      <= '0;
    lsu_LW      <= '0;
    lsu_LBU     <= '0;
    lsu_LHU     <= '0;
    lsu_SB      <= '0;
    lsu_SH      <= '0;
    lsu_SW      <= '0;

    lsu_mem_rdata <= '0;
    end
  end
endmodule
