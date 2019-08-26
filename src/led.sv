module led #(
  parameter logic [31:0] ADDR_LO = 32'h00000000,
  parameter logic [31:0] ADDR_HI = 32'h0007FFFF
) (
  input  logic           clk,
  input  logic           rst,

  output logic  [7:0]    LED,

  input  logic           bus_req,
  output logic           bus_ack,
  input  logic           bus_write,
  input  logic [31:0]    bus_addr,
  inout  logic [31:0]    bus_data
);

logic put_data;
logic [31:0] data;
assign bus_data = put_data ? data : 'z;

always_ff @(posedge clk)
  begin
  put_data <= '0;
  bus_ack  <= 'z;
  data <= '0;
  LED <= LED;
  if(bus_req &
     bus_addr >= ADDR_LO &
     bus_addr <= ADDR_HI)
    begin
    bus_ack <= '1;
    if (bus_write)
      begin
      LED[7:0] <= bus_data[7:0] ^ //TMP
                  bus_data[15:8] ^
                  bus_data[23:16] ^
                  bus_data[31:24];
      end
    else
      begin
      put_data <= '1;
      data[7:0]   <= LED[7:0];
      end
    end

  if(rst)
    LED <= 'hAA;
  end

endmodule
