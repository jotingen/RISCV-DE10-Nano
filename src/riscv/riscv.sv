import riscv_pkg::*;

module riscv (
  input  logic           clk,
  input  logic           rst,

  input  logic           start,

  output logic           bus_req,
  input  logic           bus_ack,
  output logic           bus_write,
  output logic [31:0]    bus_addr,
  inout  logic [31:0]    bus_data
);

riscv_pkg::state state;
logic [31:0]    PC;

riscv_fsm fsm (
  .clk (clk),
  .rst (rst),

  .state (state),
  .PC    (PC)
);

riscv_ifu ifu (
  .clk (clk),
  .rst (rst),

  .state (state),
  .PC    (PC),

  .bus_req   (bus_req),   
  .bus_ack   (bus_ack),   
  .bus_write (bus_write), 
  .bus_addr  (bus_addr),  
  .bus_data  (bus_data)  
);


endmodule
