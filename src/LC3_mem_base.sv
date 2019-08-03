module LC3_mem_base #(
  parameter logic [15:0] ADDR_LO = 16'h0000,
  parameter logic [15:0] ADDR_HI = 16'h0FFF
) (
  input  logic           clk,
  input  logic           rst,

  input  logic           bus_req,
  output logic           bus_ack,
  input  logic           bus_write,
  input  logic [15:0]    bus_addr,
  inout  logic [15:0]    bus_data
);

logic [12:0]  address;
logic [15:0]  data;
logic         wren;
logic [15:0]  q;

always_comb
  begin
  if(bus_req &
     bus_addr >= ADDR_LO &
     bus_addr <= ADDR_HI)
    begin
    logic [15:0] bus_addr_adjusted;

    bus_ack = '1;

    bus_addr_adjusted = bus_addr - ADDR_LO;
    address  = bus_addr_adjusted[12:0];
    data     = bus_data;

    if(bus_write)
      begin
      wren     = '1;
      bus_data = 'z;
      end
    else
      begin
      wren     = '0;
      bus_data = q;
      end
    end
  else
    begin
    bus_ack = 'z;

    address  = '0;

    wren     = '0;
    data     = '0;
    bus_data = 'z;
    end
  end

ram_1rw_8192x16 ram_1rw_8192x16 (
  .address (address),
  .clock   (clk),
  .data    (data),
  .wren    (wren),
  .q       (q)
);

endmodule

