import riscv_pkg::*;

module riscv_ifu (
  input  logic             clk,
  input  logic             rst,

  input  logic [15:0]      PC,

  output logic             rdy,
  input  logic             req,
  output logic             done,
 
  output logic [31:0]      inst,

  output logic             bus_req,
  input  logic             bus_ack,
  output logic             bus_write,
  output logic [15:0]      bus_addr,
  inout  logic [31:0]      bus_data

);

typedef enum {
  IDLE,
  REQ,
  DATA
} ifu_state_s;
ifu_state_s ifu_state;
always_ff @(posedge clk)
  begin
  rdy  <= rdy;
  done <= '0;
  bus_req <= 'z;
  bus_write <= 'z;
  bus_addr <= 'z;
  inst <= inst;
  case (ifu_state)
    IDLE : begin
           if(req)
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
            ifu_state <= DATA;
					  inst <= bus_data;
            end
          end
    DATA : begin
           ifu_state <= IDLE;
           rdy <= '1;
           done <= '1;
           end
  endcase
  if(rst)
    begin
    rdy <= '1;
    inst <= '0;
    end
  end


endmodule
