module led #(
  parameter integer      SIZE = 4,
  parameter logic [31:0] ADDR_BASE = 32'h00000000
) (
  input  logic           clk,
  input  logic           rst,

  output logic  [7:0]    LED,

  input  logic           bus_req,
  output logic           bus_ack,
  input  logic           bus_write,
  input  logic [31:0]    bus_addr,
  input  logic [31:0]    bus_data_wr,
  output logic [31:0]    bus_data_rd
);

always_ff @(posedge clk)
  begin
  bus_ack  <= '0;
  bus_data_rd <= '0;
  LED <= LED;
  if(bus_req &
     bus_addr >= ADDR_BASE &
     bus_addr <= ADDR_BASE + 2**SIZE - 1)
    begin
    bus_ack <= '1;
    if (bus_write)
      begin
      LED[7:0] <= bus_data_wr[7:0];// ^ //TMP
                  //bus_data[15:8] ^
                  //bus_data[23:16] ^
                  //bus_data[31:24];
      end
    else
      begin
      bus_data_rd[7:0]   <= LED[7:0];
      end
    end

  if(rst)
    LED <= 'hAA;
  end

endmodule
