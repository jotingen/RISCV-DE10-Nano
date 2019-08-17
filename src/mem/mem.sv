module mem #(
  parameter logic [31:0] ADDR_LO = 32'h00000000,
  parameter logic [31:0] ADDR_HI = 32'h0000FFFF
) (
  input  logic           clk,
  input  logic           rst,

  input  logic           bus_req,
  output logic           bus_ack,
  input  logic           bus_write,
  input  logic [15:0]    bus_addr,
  inout  logic [15:0]    bus_data

);

logic wren;
logic [31:0] q;
logic [15:0] bus_addr_adjusted;

assign bus_data = bus_req ? q : 'z;

always_comb
  begin
  wren  = '0;
  bus_ack = 'z;
  bus_addr_adjusted = '0;
  if(bus_req &
     bus_addr >= ADDR_LO &
     bus_addr <= ADDR_HI)
    begin

    bus_ack = '1;
    bus_addr_adjusted = bus_addr - ADDR_LO;

    if(bus_write)
      begin
      wren  = '1;
      end
    end
  end

ram_1r1w_64kbx32b	ram_1r1w_64kbx32b_inst (
	.address ( bus_addr_adjusted ),
	.clock   ( clk ),
	.data    ( bus_data ),
	.wren    ( wren ),
	.q       ( q )
	);

endmodule

