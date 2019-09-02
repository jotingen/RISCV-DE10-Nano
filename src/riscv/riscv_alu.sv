import riscv_pkg::*;

module riscv_alu (
  input  logic        clk,
  input  logic        rst,

  input  logic        idu_vld,
  output logic        alu_vld,
  output logic        alu_access_mem,

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

  output logic              PC_wr,
  output logic [31:0]       PC_in,
  input  logic [31:0]       PC,

  output logic [31:0]       x_wr,
  output logic [31:0][31:0] x_in,
  input  logic [31:0][31:0] x,

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
  output logic [31:0]      bus_data_wr,
  input  logic [31:0]      bus_data_rd
);


assign alu_access_mem = bus_req;

logic [3:0] cnt;
always_ff @(posedge clk)
  begin

  alu_vld <= '0;

  PC_wr <= '0;
  PC_in <= PC;
  x_wr  <= '0;
  x_in  <= x_in; 

  csr_req   <= '0  ;
  csr_write <= csr_write;
  csr_addr  <= csr_addr ;
  csr_mask  <= csr_mask ;
  csr_data_wr  <= '0;

  bus_req   <= '0;
  bus_write <= '0;
  bus_addr  <= '0;
  bus_data_wr  <= '0 ;

  if(idu_vld || cnt != 'd0)
    begin
    unique
    case (1'b1)
      ADD : begin
            //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "ADD", PC, rs1, x[rs1], rs2, x[rs2], rd);
            alu_vld <= '1;
            x_wr[rd] <= '1;
            x_in[rd] <= x[rs1] + x[rs2];
            PC_wr <= '1;
            PC_in <= PC+'d4;
            end
      SLT : begin
            //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SLT", PC, rs1, x[rs1], rs2, x[rs2], rd);
            alu_vld <= '1;
            x_wr[rd] <= '1;
            if($signed(x[rs1]) < $signed(x[rs2]))
              x_in[rd] <= 'd1;
            else
              x_in[rd] <= 'd0;
            PC_wr <= '1;
            PC_in <= PC+'d4;
            end
      SLTU : begin
             //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SLTU", PC, rs1, x[rs1], rs2, x[rs2], rd);
             alu_vld <= '1;
             x_wr[rd] <= '1;
             if(x[rs1] < x[rs2])
               x_in[rd] <= 'd1;
             else
               x_in[rd] <= 'd0;
             PC_wr <= '1;
             PC_in <= PC+'d4;
             end
      AND : begin
            //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "AND", PC, rs1, x[rs1], rs2, x[rs2], rd);
            alu_vld <= '1;
            x_wr[rd] <= '1;
            x_in[rd] <= x[rs1] & x[rs2];
            PC_wr <= '1;
            PC_in <= PC+'d4;
            end
      OR : begin
           //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "OR", PC, rs1, x[rs1], rs2, x[rs2], rd);
           alu_vld <= '1;
           x_wr[rd] <= '1;
           x_in[rd] <= x[rs1] | x[rs2];
           PC_wr <= '1;
           PC_in <= PC+'d4;
           end
      XOR : begin
            //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "XOR", PC, rs1, x[rs1], rs2, x[rs2], rd);
            alu_vld <= '1;
            x_wr[rd] <= '1;
            x_in[rd] <= x[rs1] ^ x[rs2];
            PC_wr <= '1;
            PC_in <= PC+'d4;
            end
      SLL : begin
            //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SLL", PC, rs1, x[rs1], rs2, x[rs2], rd);
            alu_vld <= '1;
            x_wr[rd] <= '1;
            x_in[rd] <= x[rs1] << x[rs2][4:0];
            PC_wr <= '1;
            PC_in <= PC+'d4;
            end
      SRL : begin
            //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SRL", PC, rs1, x[rs1], rs2, x[rs2], rd);
            alu_vld <= '1;
            x_wr[rd] <= '1;
            x_in[rd] <= x[rs1] >> x[rs2][4:0];
            PC_wr <= '1;
            PC_in <= PC+'d4;
            end
      SUB : begin
            //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SUB", PC, rs1, x[rs1], rs2, x[rs2], rd);
            alu_vld <= '1;
            x_wr[rd] <= '1;
            x_in[rd] <= x[rs1] - x[rs2];
            PC_wr <= '1;
            PC_in <= PC+'d4;
            end
      SRA : begin
            //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X rd=(%d)", "SRA", PC, rs1, x[rs1], rs2, x[rs2], rd);
            alu_vld <= '1;
            x_wr[rd] <= '1;
            x_in[rd] <= x[rs1] >>> x[rs2];
            PC_wr <= '1;
            PC_in <= PC+'d4;
            end


      ADDI : begin
             //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "ADDI", PC, rs1, x[rs1], {{20{imm[11]}},imm[11:0]}, rd);
             alu_vld <= '1;
             x_wr[rd] <= '1;
             x_in[rd] <= x[rs1] + {{20{imm[11]}},imm[11:0]};
             PC_wr <= '1;
             PC_in <= PC+'d4;
             end
      SLTI : begin
             //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "SLTI", PC, rs1, x[rs1], {{20{imm[11]}},imm[11:0]}, rd);
             alu_vld <= '1;
             x_wr[rd] <= '1;
             if($signed(x[rs1]) < $signed({{20{imm[11]}},imm[11:0]}))
               x_in[rd] <= 'd1;
             else
               x_in[rd] <= 'd0;
             PC_wr <= '1;
             PC_in <= PC+'d4;
             end
      SLTIU : begin
              //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "SLTIU", PC, rs1, x[rs1], {{20{imm[11]}},imm[11:0]}, rd);
              alu_vld <= '1;
              x_wr[rd] <= '1;
              if(x[rs1] < {{20{imm[11]}},imm[11:0]})
                x_in[rd] <= 'd1;
              else
                x_in[rd] <= 'd0;
              PC_wr <= '1;
              PC_in <= PC+'d4;
              end
      ANDI : begin
             //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "ANDI", PC, rs1, x[rs1], {{20{imm[11]}},imm[11:0]}, rd);
             alu_vld <= '1;
             x_wr[rd] <= '1;
             x_in[rd] <= x[rs1] & {{20{imm[11]}},imm[11:0]};
             PC_wr <= '1;
             PC_in <= PC+'d4;
             end
      ORI : begin
            //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "ORI", PC, rs1, x[rs1], {{20{imm[11]}},imm[11:0]}, rd);
            alu_vld <= '1;
            x_wr[rd] <= '1;
            x_in[rd] <= x[rs1] | {{20{imm[11]}},imm[11:0]};
            PC_wr <= '1;
            PC_in <= PC+'d4;
            end
      XORI : begin
             //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "XORI", PC, rs1, x[rs1], {{20{imm[11]}},imm[11:0]}, rd);
             alu_vld <= '1;
             x_wr[rd] <= '1;
             x_in[rd] <= x[rs1] ^ {{20{imm[11]}},imm[11:0]};
             PC_wr <= '1;
             PC_in <= PC+'d4;
             end
      SLLI : begin
             //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "SLLI", PC, rs1, x[rs1], {{27{'0}},imm[4:0]}, rd);
             alu_vld <= '1;
             x_wr[rd] <= '1;
             x_in[rd] <= x[rs1] << imm[4:0];
             PC_wr <= '1;
             PC_in <= PC+'d4;
             end
      SRLI : begin
             //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "SRLI", PC, rs1, x[rs1], {{27{'0}},imm[4:0]}, rd);
             alu_vld <= '1;
             x_wr[rd] <= '1;
             x_in[rd] <= x[rs1] >> imm[4:0];
             PC_wr <= '1;
             PC_in <= PC+'d4;
             end
      SRAI : begin
             //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "SRAI", PC, rs1, x[rs1], imm[4:0], rd);
             alu_vld <= '1;
             x_wr[rd] <= '1;
             x_in[rd] <= x[rs1] >>> imm;
             PC_wr <= '1;
             PC_in <= PC+'d4;
             end


      JAL : begin
            if(imm!='0 || rd!='0)
              //$display("%-5s PC=%08X imm=%08X rd=(%d)", "JAL", PC, {{11{imm[20]}},imm[20:0]}, rd);
            alu_vld <= '1;
            x_wr[rd] <= '1;
            x_in[rd] <= PC+'d4;
            PC_wr <= '1;
            PC_in <= PC+{{11{imm[20]}},imm[20:0]};
            end
      JALR : begin
             //$display("%-5s PC=%08X imm=%08X rd=(%d)", "JALR", PC, {{20{imm[11]}},imm[11:0]}, rd);
             alu_vld <= '1;
             x_wr[rd] <= '1;
             x_in[rd] <= PC+'d4;
             PC_wr <= '1;
             PC_in <= (x[rs1]+{{20{imm[11]}},imm[11:0]}) & 31'hFFFFFFFE;
             end


      BEQ : begin
            //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BEQ", PC, rs1, x[rs1], rs2, x[rs2], {{19{imm[12]}},imm[12:0]});
            alu_vld <= '1;
            PC_wr <= '1;
            if(x[rs1] == x[rs2])
              PC_in <= PC+{{19{imm[12]}},imm[12:0]};
            else                  
              PC_in <= PC+'d4;
            end
      BNE : begin
            //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BNE", PC, rs1, x[rs1], rs2, x[rs2], {{19{imm[12]}},imm[12:0]});
            alu_vld <= '1;
            PC_wr <= '1;
            if(x[rs1] != x[rs2])
              PC_in <= PC+{{19{imm[12]}},imm[12:0]};
            else                  
              PC_in <= PC+'d4;
            end
      BLT : begin
            //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BLT", PC, rs1, x[rs1], rs2, x[rs2], {{19{imm[12]}},imm[12:0]});
            alu_vld <= '1;
            PC_wr <= '1;
            if($signed(x[rs1]) < $signed(x[rs2]))
              PC_in <= PC+{{19{imm[12]}},imm[12:0]};
            else                  
              PC_in <= PC+'d4;
            end
      BLTU : begin
             //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BLTU", PC, rs1, x[rs1], rs2, x[rs2], {{19{imm[12]}},imm[12:0]});
             alu_vld <= '1;
             PC_wr <= '1;
             if(x[rs1] < x[rs2])
               PC_in <= PC+{{19{imm[12]}},imm[12:0]};
             else                  
               PC_in <= PC+'d4;
             end
      BGE : begin
            //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BGE", PC, rs1, x[rs1], rs2, x[rs2], {{19{imm[12]}},imm[12:0]});
            alu_vld <= '1;
            PC_wr <= '1;
            if($signed(x[rs1]) >= $signed(x[rs2]))
              PC_in <= PC+{{19{imm[12]}},imm[12:0]};
            else                  
              PC_in <= PC+'d4;
            end
      BGEU : begin
             //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "BGEU", PC, rs1, x[rs1], rs2, x[rs2], {{19{imm[12]}},imm[12:0]});
             alu_vld <= '1;
             PC_wr <= '1;
             if(x[rs1] >= x[rs2])
               PC_in <= PC+{{19{imm[12]}},imm[12:0]};
             else                  
               PC_in <= PC+'d4;
             end


      LUI : begin
            //$display("%-5s PC=%08X imm=%08X rd=(%d)", "LUI", PC, imm, rd);
            alu_vld <= '1;
            x_wr[rd] <= '1;
            x_in[rd] <= imm;
            PC_wr <= '1;
            PC_in <= PC+'d4;
            end
      AUIPC : begin
              //$display("%-5s PC=%08X imm=%08X rd=(%d)", "AUIPC", PC, imm, rd);
              alu_vld <= '1;
              x_wr[rd] <= '1;
              x_in[rd] <= PC + imm;
              PC_wr <= '1;
              PC_in <= PC+'d4;
              end


      LW : begin
           if(cnt=='d0)
             begin
             bus_req   <= '1;
             bus_write <= '0;
             bus_addr  <= x[rs1] + { {20{imm[11]}}, imm[11:0]};
             cnt <= cnt + 1;
             end
           else if(bus_ack)
             begin
             //$display("%-5s PC=%08X rs1=(%d)%08X imm=%08X rd=(%d)", "LW", PC, rs1, x[rs1], {{20{imm[11]}},imm[11:0]}, rd);
             alu_vld <= '1;
             x_wr[rd] <= '1;
             x_in[rd] <= bus_data_rd;
             PC_wr <= '1;
             PC_in <= PC+'d4;
             cnt <= '0;
             end
           else
             begin
             cnt <= cnt + 1;
             end
           end
      SW : begin
           if(cnt=='d0)
             begin
             bus_req   <= '1;
             bus_write <= '1;
             bus_addr  <= x[rs1] + { {20{imm[11]}}, imm[11:0]};
             bus_data_wr  <= x[rs2];
             cnt <= cnt + 1;
             end
           else if(bus_ack)
             begin
             //$display("%-5s PC=%08X rs1=(%d)%08X rs2=(%d)%08X imm=%08X ", "SW", PC, rs1, x[rs1], rs2, x[rs2], {{20{imm[11]}},imm[11:0]});
             alu_vld <= '1;
             PC_wr <= '1;
             PC_in <= PC+'d4;
             cnt <= '0;
             end
           end


      FENCE : begin
              //$display("%-5s PC=%08X" , "FENCE", PC);
              alu_vld <= '1;
              PC_wr <= '1;
              PC_in <= PC+'d4;
              end



      ECALL : begin
              //$display("%-5s PC=%08X" , "ECALL - !!TODO!!", PC);
              alu_vld <= '1;
              PC_wr <= '1;
              PC_in <= PC+'d4;
              end
      CSRRW : begin
              if(cnt=='d0)
                begin
                csr_req   <= '1;
                csr_write <= '1;
                csr_addr  <= csr;
                csr_mask  <= '1;
                csr_data_wr  <= x[rs1];
                cnt <= cnt + 1;
                end
              else if(cnt=='d2)
                begin
                //$display("%-5s CSR=%03X rs1=(%d)%08X rd=(%d)", "CSRRW", csr, rs1, x[rs1], rd);
                alu_vld <= '1;
                x_wr[rd] <= '1;
                x_in[rd] <= '0;
                x_in[rd] <= csr_data_rd;
                PC_wr <= '1;
                PC_in <= PC+'d4;
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
                csr_mask  <= x[rs1];
                csr_data_wr  <= '1;
                cnt <= cnt + 1;
                end
              else if(cnt=='d2)
                begin
                //$display("%-5s CSR=%03X rs1=(%d)%08X rd=(%d)", "CSRRS", csr, rs1, x[rs1], rd);
                alu_vld <= '1;
                x_wr[rd] <= '1;
                x_in[rd] <= '0;
                x_in[rd] <= csr_data_rd;
                PC_wr <= '1;
                PC_in <= PC+'d4;
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
                csr_mask  <= x[rs1];
                csr_data_wr  <= '0;
                cnt <= cnt + 1;
                end
              else if(cnt=='d2)
                begin
                //$display("%-5s CSR=%03X rs1=(%d)%08X rd=(%d)", "CSRRS", csr, rs1, x[rs1], rd);
                alu_vld <= '1;
                x_wr[rd] <= '1;
                x_in[rd] <= '0;
                x_in[rd] <= csr_data_rd;
                PC_wr <= '1;
                PC_in <= PC+'d4;
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
                //$display("%-5s CSR=%03X rs1=(%d)%08X rd=(%d)", "CSRRWI", csr, rs1, x[rs1], rd);
                alu_vld <= '1;
                x_wr[rd] <= '1;
                x_in[rd] <= '0;
                x_in[rd] <= csr_data_rd;
                PC_wr <= '1;
                PC_in <= PC+'d4;
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
                //$display("%-5s CSR=%03X rs1=(%d)%08X rd=(%d)", "CSRRSI", csr, rs1, x[rs1], rd);
                alu_vld <= '1;
                x_wr[rd] <= '1;
                x_in[rd] <= '0;
                x_in[rd] <= csr_data_rd;
                PC_wr <= '1;
                PC_in <= PC+'d4;
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
                //$display("%-5s CSR=%03X rs1=(%d)%08X rd=(%d)", "CSRRCI", csr, rs1, x[rs1], rd);
                alu_vld <= '1;
                x_wr[rd] <= '1;
                x_in[rd] <= '0;
                x_in[rd] <= csr_data_rd;
                PC_wr <= '1;
                PC_in <= PC+'d4;
                cnt <= '0;
                end
              else
                begin
                cnt <= cnt + 1;
                end
              end
              //input  logic CSRRS,
              //input  logic CSRRC,
              //input  logic CSRRWI,
              //input  logic CSRRSI,
              //input  logic CSRRCI,
      EBREAK : begin
               //TODO
               //$display("%-5s PC=%08X" , "EBREAK - !!TODO!!", PC);
               alu_vld <= '1;
               PC_wr <= '1;
               PC_in <= PC+'d4;
               end
      default : begin
                //$display("%-5s PC=%08X" , "INVALID!!", PC);
                end
              
      endcase
    end
   
  if(rst)
    begin
    alu_vld <= '0;
    cnt <= '0;
    end
  end

endmodule
