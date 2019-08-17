import riscv_pkg::*;

module riscv (
  input  logic           clk,
  input  logic           rst,

  input  logic           start,

  output logic           bus_req,
  input  logic           bus_ack,
  output logic           bus_write,
  output logic [15:0]    bus_addr,
  inout  logic [15:0]    bus_data,

  output logic [7:0]     led
);

logic [32:0] timer;

riscv_pkg::state state;
logic [15:0]    PC;

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


assign led[7:0] = timer[32:25];
always_ff @(posedge clk)
  begin
  if(rst)
    timer <= 'd1;
  else if(start)
    timer <= 'd1;
  else
    timer <= timer + 'd1;
  end

endmodule
