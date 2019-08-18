import riscv_pkg::*;

module riscv (
  input  logic           clk,
  input  logic           rst,

  input  logic           start,

  output logic           bus_req,
  input  logic           bus_ack,
  output logic           bus_write,
  output logic [31:0]    bus_addr,
  inout  logic [31:0]    bus_data,

  output logic [1:0]     dbg_led
);

logic [31:0]    PC;


logic             ifu_rdy;
logic             ifu_req;
logic             ifu_done;
logic [31:0]      ifu_inst;

logic             idu_rdy;
logic             idu_req;
logic [31:0]      idu_inst;
logic             idu_done;

riscv_fsm fsm (
  .clk (clk),
  .rst (rst),

  .PC    (PC),

  .ifu_rdy  (ifu_rdy),
  .ifu_req  (ifu_req),
  .ifu_done (ifu_done),
  .ifu_inst (ifu_inst),

  .idu_req  (idu_req),
  .idu_inst (idu_inst),
  .idu_done (idu_done)
);

riscv_ifu ifu (
  .clk (clk),
  .rst (rst),

  .PC    (PC),

  .rdy  (ifu_rdy),
  .req  (ifu_req),
  .done (ifu_done),

  .inst (ifu_inst),

  .bus_req   (bus_req),   
  .bus_ack   (bus_ack),   
  .bus_write (bus_write), 
  .bus_addr  (bus_addr),  
  .bus_data  (bus_data)  
);

riscv_idu idu (
  .clk (clk),
  .rst (rst),

  .idu_rdy  (idu_rdy),
  .idu_req  (idu_req),
  .idu_inst (idu_inst), 
  .idu_done (idu_done),
 
  .dbg_led (dbg_led)

);


endmodule
