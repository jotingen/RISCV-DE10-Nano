module mem #(
  parameter integer      SIZE = 4,
  parameter logic [31:0] ADDR_BASE = 32'h00000000
) (
  input  logic           clk,
  input  logic           rst,

  input  logic           i_bus_req,
  input  logic           i_bus_ack,
  input  logic           i_bus_write,
  input  logic [31:0]    i_bus_addr,
  input  logic [31:0]    i_bus_data,

  output logic           o_bus_req,
  output logic           o_bus_ack,
  output logic           o_bus_write,
  output logic [31:0]    o_bus_addr,
  output logic [31:0]    o_bus_data
);

logic [7:0] mem_array_3 [2**(SIZE-2)-1:0];
logic [7:0] mem_array_2 [2**(SIZE-2)-1:0];
logic [7:0] mem_array_1 [2**(SIZE-2)-1:0];
logic [7:0] mem_array_0 [2**(SIZE-2)-1:0];

always_ff @(posedge clk)
  begin
  o_bus_req   <= i_bus_req;    
  o_bus_ack   <= i_bus_ack;    
  o_bus_write <= i_bus_write;  
  o_bus_addr  <= i_bus_addr;   
  o_bus_data  <= i_bus_data;   

  if(i_bus_req &
     i_bus_addr >= ADDR_BASE &
     i_bus_addr <= ADDR_BASE + 2**SIZE - 1)
    begin
    o_bus_req <= '0;    
    o_bus_ack <= '1;
    if (i_bus_write)
      begin
      mem_array_0[i_bus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]] <= i_bus_data[7:0];
      mem_array_1[i_bus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]] <= i_bus_data[15:8];
      mem_array_2[i_bus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]] <= i_bus_data[23:16];
      mem_array_3[i_bus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]] <= i_bus_data[31:24];
      end
    o_bus_data[7:0]   <= mem_array_0[i_bus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]];
    o_bus_data[15:8]  <= mem_array_1[i_bus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]];
    o_bus_data[23:16] <= mem_array_2[i_bus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]];
    o_bus_data[31:24] <= mem_array_3[i_bus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]];
    end
  end

initial
  begin
    $readmemh("../../tests/demo/demo_3.v", mem_array_3);
    $readmemh("../../tests/demo/demo_2.v", mem_array_2);
    $readmemh("../../tests/demo/demo_1.v", mem_array_1);
    $readmemh("../../tests/demo/demo_0.v", mem_array_0);
  end

endmodule
