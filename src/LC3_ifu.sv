import LC3_pkg::*;

module LC3_ifu (
  input  logic           clk,
  input  logic           rst,

  input  LC3_pkg::state  state,
  input  logic [15:0]    PC,

  output logic           bus_req,
  input  logic           bus_ack,
  output logic           bus_write,
  output logic [15:0]    bus_addr,
  inout  logic [15:0]    bus_data

);


always_comb
  if(rst)
    begin
    bus_req   = '1;
    bus_write = '0;
    bus_addr  = 'h0000;
    //bus_data  = 'z;
    end
  else if(state == LC3_pkg::IFU_FETCH)
    begin
    bus_req   = '1;
    bus_write = '0;
    bus_addr  = PC;
    //bus_data  = 'z;
    end
  else
    begin
    bus_req   = 'z;
    bus_write = 'z;
    bus_addr  = 'z;
    //bus_data  = 'z;
    end


endmodule
