import riscv_pkg::*;

module riscv_ifu (
  input  logic             clk,
  input  logic             rst,

  output logic             rdy,
  input  logic             req,
  output logic             done,

  input  logic             alu_vld,
  output logic             ifu_vld,
 
  output logic [31:0]      ifu_inst,
  output logic [31:0]      ifu_inst_PC,

  //output logic              PC_wr,
  //output logic [31:0]       PC_in,
  input  logic [31:0]       PC,

  output logic             bus_req,
  input  logic             bus_ack,
  output logic             bus_write,
  output logic [31:0]      bus_addr,
  inout  logic [31:0]      bus_data

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
  ifu_vld <= '0;
  //PC_wr <= '0;
  //PC_in <= PC;
  rdy  <= rdy;
  done <= '0;
  bus_req <= 'z;
  bus_write <= 'z;
  bus_addr <= 'z;
  ifu_inst <= ifu_inst;
  ifu_inst_PC <= ifu_inst_PC;
  case (ifu_state)
    IDLE : begin
           if(alu_vld | (init & ~rst))
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
					  ifu_inst <= bus_data;
            ifu_inst_PC <= PC;
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

    end
  end


endmodule
