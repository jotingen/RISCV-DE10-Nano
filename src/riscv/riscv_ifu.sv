import riscv_pkg::*;

module riscv_ifu (
  input  logic             clk,
  input  logic             rst,

  //output logic              PC_wr,
  //output logic [31:0]       PC_in,
  input  logic [31:0]       PC,

  input  logic             alu_vld,
  input  logic             alu_access_mem,

  output logic             ifu_vld,
 
  output logic [31:0]      ifu_inst,
  output logic [31:0]      ifu_inst_PC,

  output logic             rdy,
  input  logic             req,
  output logic             done,


  output riscv_pkg::ifu_s  ifu_out,

  output logic             bus_req,
  input  logic             bus_ack,
  output logic             bus_write,
  output logic [31:0]      bus_addr,
  output logic [31:0]      bus_data_wr,
  input  logic [31:0]      bus_data_rd

);

logic init;
typedef enum {
  IDLE,
  REQ,
  DATA
} ifu_state_s;
ifu_state_s ifu_state;

always_ff @(posedge clk)
  begin
  init <= '0;
  if(rst) 
    init <= '1;
  end

always_ff @(posedge clk)
  begin
  ifu_out.Vld <= '0;
  ifu_vld <= '0;
  //PC_wr <= '0;
  //PC_in <= PC;
  rdy  <= rdy;
  done <= '0;
  bus_req <= '0;
  bus_write <= '0;
  bus_addr <= '0;
  bus_data_wr <= '0;
  ifu_out.Inst <= ifu_out.Inst;
  ifu_inst <= ifu_inst;
  ifu_out.PC <= ifu_out.PC;
  ifu_inst_PC <= ifu_inst_PC;
  case (ifu_state)
    IDLE : begin
           if(~alu_access_mem & (alu_vld | (init & ~rst)))
             begin
						 ifu_state <= REQ;
             rdy <= '0;
             bus_req <= '1;
             bus_write <= '0;
             bus_addr <= PC;
             end
           end
    REQ : begin
          if(bus_ack)
            begin
            ifu_vld <= '1;
            ifu_state <= IDLE;
					  ifu_inst <= bus_data_rd;
            ifu_inst_PC <= PC;
            ifu_out.Vld <= '1;
					  ifu_out.Inst <= bus_data_rd;
            ifu_out.PC <= PC;
            //PC_wr <= '1;
            //PC_in <= PC + 'd4;
            end
          end
  endcase
  if(rst)
    begin
    ifu_vld <= '0;
    //PC_wr <= '0;
    //PC_in <= PC;
		ifu_state <= IDLE;
    rdy <= '1;
    ifu_inst <= '0;
    ifu_inst_PC <= '0;
    ifu_out.Vld <= '0;
    ifu_out.Inst <= '0;
    ifu_out.PC <= '0;

    end
  end


endmodule
