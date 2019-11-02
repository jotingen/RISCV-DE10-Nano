
module riscv_ifu (
  input  logic             clk,
  input  logic             rst,

  input  logic             alu_vld,
  input  logic             alu_retired,
  input  logic             alu_freeze,
  input  logic             alu_br_miss,
  input  logic             alu_trap,
  input  logic [31:0]      alu_PC_next,

  input  logic             idu_vld,
  input  logic             idu_freeze,

  output logic             ifu_vld,
  output logic [31:0]      ifu_inst,
  output logic [31:0]      ifu_inst_PC,

  output logic             o_instbus_req,
  output logic             o_instbus_write,
  output logic [31:0]      o_instbus_addr,
  output logic [31:0]      o_instbus_data,

  input  logic             i_instbus_ack,
  input  logic [31:0]      i_instbus_data

);

//Invalid state  TODO halt?
logic illegal;

//Instruction requested
logic accessing;

//Instruction has been loaded, waiting to send
logic loaded;

logic [31:0] PC;
logic             instbus_req;
logic             instbus_write;
logic [31:0]      instbus_addr;
logic [31:0]      instbus_data;
  
assign o_instbus_req   = instbus_req & ~(alu_vld & (alu_trap | alu_br_miss));
assign o_instbus_write = instbus_write;
assign o_instbus_addr  = instbus_addr;
assign o_instbus_data  = instbus_data;

always_ff @(posedge clk)
  begin
  illegal         <= '0;
  accessing       <= accessing;
  loaded          <= loaded;
  instbus_req   <= '0;
  instbus_write <= instbus_write;
  instbus_addr  <= instbus_addr;
  instbus_data  <= instbus_data;
  
  ifu_vld     <= '0;
  ifu_inst    <= ifu_inst;
  ifu_inst_PC <= ifu_inst_PC;
  if(i_instbus_ack & accessing)
    begin
    ifu_inst    <= i_instbus_data;
    ifu_inst_PC <= instbus_addr;
    end
  PC      <= PC;

  unique
  casex({accessing,loaded,alu_vld,alu_retired,alu_freeze,alu_trap,alu_br_miss,idu_vld,idu_freeze,i_instbus_ack})
    'b00_0xxxx_0x_0: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= PC;
                     ifu_vld         <= '0;
                     PC              <= PC+4;
                     illegal         <= '0;
                     end
    'b00_0xxxx_0x_1: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= PC;
                     ifu_vld         <= '1;
                     PC              <= PC+4;
                     illegal         <= '0;
                     end
    'b00_0xxxx_10_0: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= PC;
                     ifu_vld         <= '0;
                     PC              <= PC+4;
                     illegal         <= '0;
                     end
    'b00_0xxxx_10_1: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= PC;
                     ifu_vld         <= '1;
                     PC              <= PC+4;
                     illegal         <= '0;
                     end
    'b00_0xxxx_11_0: begin
                     accessing       <= '0;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= PC;
                     illegal         <= '0;
                     end
    'b00_0xxxx_11_1: begin
                     accessing       <= '0;
                     loaded          <= '1;
                     instbus_req   <= '1;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '1;
                     PC              <= PC;
                     illegal         <= '0;
                     end


    'b00_10xxx_0x_0: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= PC;
                     ifu_vld         <= '0;
                     PC              <= PC+4;
                     illegal         <= '0;
                     end
    'b00_10xxx_0x_1: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= PC;
                     ifu_vld         <= '1;
                     PC              <= PC+4;
                     illegal         <= '0;
                     end
    'b00_10xxx_10_0: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= PC;
                     ifu_vld         <= '0;
                     PC              <= PC+4;
                     illegal         <= '0;
                     end
    'b00_10xxx_10_1: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= PC;
                     ifu_vld         <= '1;
                     PC              <= PC+4;
                     illegal         <= '0;
                     end
    'b00_10xxx_11_0: begin
                     accessing       <= '0;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= PC;
                     illegal         <= '0;
                     end
    'b00_10xxx_11_1: begin
                     accessing       <= '0;
                     loaded          <= '1;
                     instbus_req   <= '1;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '1;
                     PC              <= PC;
                     illegal         <= '0;
                     end


    'b00_11000_0x_0: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= PC;
                     ifu_vld         <= '0;
                     PC              <= PC+4;
                     illegal         <= '0;
                     end
    'b00_11000_0x_1: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= PC;
                     ifu_vld         <= '1;
                     PC              <= PC+4;
                     illegal         <= '0;
                     end
    'b00_11000_10_0: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= PC;
                     ifu_vld         <= '0;
                     PC              <= PC+4;
                     illegal         <= '0;
                     end
    'b00_11000_10_1: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= PC;
                     ifu_vld         <= '1;
                     PC              <= PC+4;
                     illegal         <= '0;
                     end
    'b00_11000_11_0: begin
                     accessing       <= '0;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= PC;
                     illegal         <= '0;
                     end
    'b00_11000_11_1: begin
                     accessing       <= '0;
                     loaded          <= '1;
                     instbus_req   <= '1;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '1;
                     PC              <= PC;
                     illegal         <= '0;
                     end


    'b00_11001_xx_x: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= alu_PC_next;
                     ifu_vld         <= '0;
                     PC              <= alu_PC_next+4;
                     illegal         <= '0;
                     end


    'b00_1101x_xx_x: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= alu_PC_next;
                     ifu_vld         <= '0;
                     PC              <= alu_PC_next+4;
                     illegal         <= '0;
                     end


    'b00_11100_xx_x: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= PC+4;
                     illegal         <= '0;
                     end


    'b00_11101_xx_x: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= alu_PC_next;
                     illegal         <= '0;
                     end


    'b00_1111x_xx_x: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= alu_PC_next;
                     illegal         <= '0;
                     end


    'b01_0xxxx_0x_0: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= PC;
                     ifu_vld         <= '0;
                     PC              <= PC+4;
                     illegal         <= '0;
                     end
    'b01_0xxxx_0x_1: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= PC;
                     ifu_vld         <= '1;
                     PC              <= PC+4;
                     illegal         <= '1;
                     end
    'b01_0xxxx_10_0: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= PC;
                     ifu_vld         <= '0;
                     PC              <= PC+4;
                     illegal         <= '0;
                     end
    'b01_0xxxx_10_1: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= PC;
                     ifu_vld         <= '1;
                     PC              <= PC+4;
                     illegal         <= '1;
                     end
    'b01_0xxxx_11_0: begin
                     accessing       <= '0;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= PC;
                     illegal         <= '0;
                     end
    'b01_0xxxx_11_1: begin
                     accessing       <= '0;
                     loaded          <= '1;
                     instbus_req   <= '1;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '1;
                     PC              <= PC;
                     illegal         <= '1;
                     end


    'b01_100xx_0x_0: begin
                     accessing       <= '0;
                     loaded          <= '1;
                     instbus_req   <= '0;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= PC;
                     illegal         <= '0;
                     end
    'b01_100xx_0x_1: begin
                     accessing       <= '0;
                     loaded          <= '1;
                     instbus_req   <= '0;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= PC;
                     illegal         <= '1;
                     end
    'b01_100xx_10_0: begin
                     accessing       <= '0;
                     loaded          <= '1;
                     instbus_req   <= '0;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= PC;
                     illegal         <= '0;
                     end
    'b01_100xx_10_1: begin
                     accessing       <= '0;
                     loaded          <= '1;
                     instbus_req   <= '0;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= PC;
                     illegal         <= '1;
                     end
    'b01_100xx_11_0: begin
                     accessing       <= '0;
                     loaded          <= '1;
                     instbus_req   <= '0;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= PC;
                     illegal         <= '0;
                     end
    'b01_100xx_11_1: begin
                     accessing       <= '0;
                     loaded          <= '1;
                     instbus_req   <= '0;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= PC;
                     illegal         <= '1;
                     end


    'b01_101xx_xx_0: begin
                     accessing       <= '0;
                     loaded          <= '1;
                     instbus_req   <= '0;
                     //instbus_addr  <= 0;
                     ifu_vld         <= '0;
                     PC              <= PC;
                     illegal         <= '0;
                     end
    'b01_101xx_xx_1: begin
                     accessing       <= '0;
                     loaded          <= '1;
                     instbus_req   <= '0;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= PC;
                     illegal         <= '1;
                     end


    'b01_11000_0x_0: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req     <= '1;
                     instbus_addr    <= PC;
                     ifu_vld         <= '1;
                     PC              <= PC+4;
                     illegal         <= '0;
                     end
    'b01_11000_0x_1: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= PC;
                     ifu_vld         <= '1;
                     PC              <= PC+4;
                     illegal         <= '1;
                     end
    'b01_11000_10_0: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= PC;
                     ifu_vld         <= '1;
                     PC              <= PC+4;
                     illegal         <= '0;
                     end
    'b01_11000_10_1: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= PC;
                     ifu_vld         <= '1;
                     PC              <= PC+4;
                     illegal         <= '1;
                     end
    'b01_11000_11_0: begin
                     accessing       <= '0;
                     loaded          <= '1;
                     instbus_req     <= '0;
                     //instbus_addr    <= '0;
                     ifu_vld         <= '0;
                     PC              <= PC;
                     illegal         <= '0;
                     end
    'b01_11000_11_1: begin
                     accessing       <= '0;
                     loaded          <= '1;
                     instbus_req     <= '1;
                     //instbus_addr    <= '0;
                     ifu_vld         <= '1;
                     PC              <= PC;
                     illegal         <= '1;
                     end


    'b01_11001_xx_0: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= alu_PC_next;
                     ifu_vld         <= '0;
                     PC              <= alu_PC_next+4;
                     illegal         <= '0;
                     end
    'b01_11001_xx_1: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= alu_PC_next;
                     ifu_vld         <= '0;
                     PC              <= alu_PC_next+4;
                     illegal         <= '1;
                     end


    'b01_1101x_xx_0: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= alu_PC_next;
                     ifu_vld         <= '0;
                     PC              <= alu_PC_next+4;
                     illegal         <= '0;
                     end
    'b01_1101x_xx_1: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= alu_PC_next;
                     ifu_vld         <= '0;
                     PC              <= alu_PC_next+4;
                     illegal         <= '1;
                     end


    'b01_11100_xx_0: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= PC+4;
                     illegal         <= '0;
                     end
    'b01_11100_xx_1: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= PC+4;
                     illegal         <= '1;
                     end


    'b01_11101_xx_0: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= alu_PC_next;
                     illegal         <= '0;
                     end
    'b01_11101_xx_1: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= alu_PC_next;
                     illegal         <= '1;
                     end


    'b01_1111x_xx_0: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= alu_PC_next;
                     illegal         <= '0;
                     end
    'b01_1111x_xx_1: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= alu_PC_next;
                     illegal         <= '1;
                     end


    'b10_0xxxx_0x_0: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '0;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= PC;
                     illegal         <= '0;
                     end
    'b10_0xxxx_0x_1: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= PC;
                     ifu_vld         <= '1;
                     PC              <= PC+4;
                     illegal         <= '0;
                     end
    'b10_0xxxx_10_0: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '0;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= PC;
                     illegal         <= '0;
                     end
    'b10_0xxxx_10_1: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= PC;
                     ifu_vld         <= '1;
                     PC              <= PC+4;
                     illegal         <= '0;
                     end
    'b10_0xxxx_11_0: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '0;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= PC;
                     illegal         <= '0;
                     end
    'b10_0xxxx_11_1: begin
                     accessing       <= '0;
                     loaded          <= '1;
                     instbus_req   <= '0;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= PC;
                     illegal         <= '0;
                     end


    'b10_100xx_0x_0: begin                     
                     accessing       <= '1;    
                     loaded          <= '0;    
                     instbus_req   <= '0;    
                     //instbus_addr  <= '0;    
                     ifu_vld         <= '0;    
                     PC              <= PC;    
                     illegal         <= '0;    
                     end                       
    'b10_100xx_0x_1: begin                     
                     accessing       <= '1;    
                     loaded          <= '0;    
                     instbus_req   <= '1;    
                     instbus_addr  <= PC;    
                     ifu_vld         <= '1;    
                     PC              <= PC+4;  
                     illegal         <= '0;    
                     end                       
    'b10_100xx_10_0: begin                     
                     accessing       <= '1;    
                     loaded          <= '0;    
                     instbus_req   <= '0;    
                     //instbus_addr  <= '0;    
                     ifu_vld         <= '0;    
                     PC              <= PC;    
                     illegal         <= '0;    
                     end                       
    'b10_100xx_10_1: begin                     
                     accessing       <= '1;    
                     loaded          <= '0;    
                     instbus_req   <= '1;    
                     instbus_addr  <= PC;    
                     ifu_vld         <= '1;    
                     PC              <= PC+4;  
                     illegal         <= '0;    
                     end                       
    'b10_100xx_11_0: begin                     
                     accessing       <= '1;    
                     loaded          <= '0;    
                     instbus_req   <= '0;    
                     //instbus_addr  <= '0;    
                     ifu_vld         <= '0;    
                     PC              <= PC;    
                     illegal         <= '0;    
                     end                       
    'b10_100xx_11_1: begin                     
                     accessing       <= '0;    
                     loaded          <= '1;    
                     instbus_req   <= '0;    
                     //instbus_addr  <= '0;    
                     ifu_vld         <= '1;    
                     PC              <= PC;    
                     illegal         <= '0;    
                     end                       


    'b10_101xx_xx_0: begin                     
                     accessing       <= '1;    
                     loaded          <= '0;    
                     instbus_req   <= '0;    
                     //instbus_addr  <= '0;    
                     ifu_vld         <= '0;    
                     PC              <= PC;    
                     illegal         <= '0;    
                     end                       
    'b10_101xx_xx_1: begin                     
                     accessing       <= '0;    
                     loaded          <= '1;    
                     instbus_req   <= '0;    
                     //instbus_addr  <= '0;    
                     ifu_vld         <= '0;    
                     PC              <= PC;  
                     illegal         <= '0;    
                     end                       


    'b10_11000_0x_0: begin                    
                     accessing       <= '1;   
                     loaded          <= '0;   
                     instbus_req   <= '0;   
                     //instbus_addr  <= '0;   
                     ifu_vld         <= '0;   
                     PC              <= PC;   
                     illegal         <= '0;   
                     end                      
    'b10_11000_0x_1: begin                    
                     accessing       <= '1;   
                     loaded          <= '0;   
                     instbus_req   <= '1;   
                     instbus_addr  <= PC;   
                     ifu_vld         <= '1;   
                     PC              <= PC+4; 
                     illegal         <= '0;   
                     end                      
    'b10_11000_10_0: begin                    
                     accessing       <= '1;   
                     loaded          <= '0;   
                     instbus_req   <= '0;   
                     //instbus_addr  <= '0;   
                     ifu_vld         <= '0;   
                     PC              <= PC;   
                     illegal         <= '0;   
                     end                      
    'b10_11000_10_1: begin                    
                     accessing       <= '1;   
                     loaded          <= '0;   
                     instbus_req   <= '1;   
                     instbus_addr  <= PC;   
                     ifu_vld         <= '1;   
                     PC              <= PC+4; 
                     illegal         <= '0;   
                     end                      
    'b10_11000_11_0: begin                    
                     accessing       <= '1;   
                     loaded          <= '0;   
                     instbus_req   <= '0;   
                     //instbus_addr  <= '0;   
                     ifu_vld         <= '0;   
                     PC              <= PC;   
                     illegal         <= '0;   
                     end                      
    'b10_11000_11_1: begin                    
                     accessing       <= '0;   
                     loaded          <= '1;   
                     instbus_req   <= '0;   
                     //instbus_addr  <= '0;   
                     ifu_vld         <= '0;   
                     PC              <= PC;   
                     illegal         <= '0;   
                     end                      


    'b10_11001_xx_0: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= alu_PC_next;
                     ifu_vld         <= '0;
                     PC              <= alu_PC_next+4;
                     illegal         <= '0;
                     end
    'b10_11001_xx_1: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= alu_PC_next;
                     ifu_vld         <= '0;
                     PC              <= alu_PC_next+4;
                     illegal         <= '0;
                     end


    'b10_1101x_xx_0: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= alu_PC_next;
                     ifu_vld         <= '0;
                     PC              <= alu_PC_next+4;
                     illegal         <= '0;
                     end
    'b10_1101x_xx_1: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '1;
                     instbus_addr  <= alu_PC_next;
                     ifu_vld         <= '0;
                     PC              <= alu_PC_next+4;
                     illegal         <= '0;
                     end


    'b10_11100_xx_0: begin
                     accessing       <= '1;
                     loaded          <= '0;
                     instbus_req   <= '0;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= PC;
                     illegal         <= '0;
                     end
    'b10_11100_xx_1: begin
                     accessing       <= '0;
                     loaded          <= '1;
                     instbus_req   <= '0;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= PC;
                     illegal         <= '0;
                     end


    'b10_11101_xx_0: begin
                     accessing       <= '0;
                     loaded          <= '0;
                     instbus_req   <= '0;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= alu_PC_next;
                     illegal         <= '0;
                     end
    'b10_11101_xx_1: begin
                     accessing       <= '0;
                     loaded          <= '0;
                     instbus_req   <= '0;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= alu_PC_next;
                     illegal         <= '0;
                     end


    'b10_1111x_xx_0: begin
                     accessing       <= '0;
                     loaded          <= '0;
                     instbus_req   <= '0;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= alu_PC_next;
                     illegal         <= '0;
                     end
    'b10_1111x_xx_1: begin
                     accessing       <= '0;
                     loaded          <= '0;
                     instbus_req   <= '0;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= alu_PC_next;
                     illegal         <= '0;
                     end

    default:         begin
                     accessing       <= '0;
                     loaded          <= '0;
                     instbus_req   <= '0;
                     //instbus_addr  <= '0;
                     ifu_vld         <= '0;
                     PC              <= PC;
                     illegal         <= '1;
                     end 
  endcase

  if(rst)
    begin
    illegal <= '1;

    PC <= '0;

    ifu_vld <= '0;
    ifu_inst <= '0;
    ifu_inst_PC <= '0;

    accessing <= '0;
    loaded <= '0;
    instbus_req <= '0;
    instbus_write <= '0;
    instbus_addr <= '0;
    instbus_data <= '0;
    end
  end


endmodule
