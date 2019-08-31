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
  input  logic [31:0]    bus_data_wr,
  output logic [31:0]    bus_data_rd

);

logic [7:0] mem_array_3 [2**(SIZE-2)-1:0];
logic [7:0] mem_array_2 [2**(SIZE-2)-1:0];
logic [7:0] mem_array_1 [2**(SIZE-2)-1:0];
logic [7:0] mem_array_0 [2**(SIZE-2)-1:0];

always_ff @(posedge clk)
  begin
  bus_data_rd <= '0;
  bus_ack  <= '0;
  if(bus_req &
     bus_addr >= ADDR_BASE &
     bus_addr <= ADDR_BASE + 2**SIZE - 1)
    begin
    bus_ack <= '1;
    if (bus_write)
      begin
      mem_array_0[bus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]] <= bus_data_wr[7:0];
      mem_array_1[bus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]] <= bus_data_wr[15:8];
      mem_array_2[bus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]] <= bus_data_wr[23:16];
      mem_array_3[bus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]] <= bus_data_wr[31:24];
      end
    else
      begin
      bus_data_rd[7:0]   <= mem_array_0[bus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]];
      bus_data_rd[15:8]  <= mem_array_1[bus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]];
      bus_data_rd[23:16] <= mem_array_2[bus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]];
      bus_data_rd[31:24] <= mem_array_3[bus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]];
      end
    end
  end

initial
  begin
    $readmemh("../../tests/timer_3.v", mem_array_3);
    $readmemh("../../tests/timer_2.v", mem_array_2);
    $readmemh("../../tests/timer_1.v", mem_array_1);
    $readmemh("../../tests/timer_0.v", mem_array_0);
  end

endmodule
