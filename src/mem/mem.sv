module mem #(
  parameter integer      SIZE = 4,
  parameter logic [31:0] ADDR_BASE = 32'h00000000
) (
  input  logic           clk,
  input  logic           rst,

  input  logic           bus_req,
  output logic           bus_ack,
  input  logic           bus_write,
  input  logic [31:0]    bus_addr,
  inout  logic [31:0]    bus_data

);

logic [7:0] mem_array_3 [2**(SIZE-2)-1:0];
logic [7:0] mem_array_2 [2**(SIZE-2)-1:0];
logic [7:0] mem_array_1 [2**(SIZE-2)-1:0];
logic [7:0] mem_array_0 [2**(SIZE-2)-1:0];

logic put_data;
logic [31:0] address;
logic [31:0] data;

assign bus_data = put_data ? data : 'z;
             
assign address = bus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2];
always_ff @(posedge clk)
  begin
  put_data <= '0;
  bus_ack  <= 'z;
  data <= data;
  if(bus_req &
     bus_addr >= ADDR_BASE &
     bus_addr <= ADDR_BASE + 2**SIZE - 1)
    begin
    bus_ack <= '1;
    if (bus_write)
      begin
      mem_array_0[bus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]] <= bus_data[7:0];
      mem_array_1[bus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]] <= bus_data[15:8];
      mem_array_2[bus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]] <= bus_data[23:16];
      mem_array_3[bus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]] <= bus_data[31:24];
      end
    else
      begin
      put_data <= '1;
      data[7:0]   <= mem_array_0[bus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]];
      data[15:8]  <= mem_array_1[bus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]];
      data[23:16] <= mem_array_2[bus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]];
      data[31:24] <= mem_array_3[bus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]];
      end
    end
  end

endmodule
