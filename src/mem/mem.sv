module mem #(
  parameter integer      SIZE = 4,
  parameter logic [31:0] ADDR_BASE = 32'h00000000
) (
  input  logic           clk,
  input  logic           rst,

  input  logic           i_instbus_req,
  input  logic           i_instbus_ack,
  input  logic           i_instbus_write,
  input  logic [31:0]    i_instbus_addr,
  input  logic [31:0]    i_instbus_data,

  output logic           o_instbus_req,
  output logic           o_instbus_ack,
  output logic           o_instbus_write,
  output logic [31:0]    o_instbus_addr,
  output logic [31:0]    o_instbus_data,

  input  logic           i_membus_req,
  input  logic           i_membus_ack,
  input  logic           i_membus_write,
  input  logic [31:0]    i_membus_addr,
  input  logic [31:0]    i_membus_data,

  output logic           o_membus_req,
  output logic           o_membus_ack,
  output logic           o_membus_write,
  output logic [31:0]    o_membus_addr,
  output logic [31:0]    o_membus_data
);

logic [7:0] mem_array_3 [2**(SIZE-2)-1:0];
logic [7:0] mem_array_2 [2**(SIZE-2)-1:0];
logic [7:0] mem_array_1 [2**(SIZE-2)-1:0];
logic [7:0] mem_array_0 [2**(SIZE-2)-1:0];

//Instruction bus
always_ff @(posedge clk)
  begin
  o_instbus_req   <= i_instbus_req;    
  o_instbus_ack   <= i_instbus_ack;    
  o_instbus_write <= i_instbus_write;  
  o_instbus_addr  <= i_instbus_addr;   
  o_instbus_data  <= i_instbus_data;   

  if(i_instbus_req &
     i_instbus_addr >= ADDR_BASE &
     i_instbus_addr <= ADDR_BASE + 2**SIZE - 1)
    begin
    o_instbus_req <= '0;    
    o_instbus_ack <= '1;
    //if (i_instbus_write)
    //  begin
    //  mem_array_0[i_instbus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]] <= i_instbus_data[7:0];
    //  mem_array_1[i_instbus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]] <= i_instbus_data[15:8];
    //  mem_array_2[i_instbus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]] <= i_instbus_data[23:16];
    //  mem_array_3[i_instbus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]] <= i_instbus_data[31:24];
    //  end
    o_instbus_data[7:0]   <= mem_array_0[i_instbus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]];
    o_instbus_data[15:8]  <= mem_array_1[i_instbus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]];
    o_instbus_data[23:16] <= mem_array_2[i_instbus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]];
    o_instbus_data[31:24] <= mem_array_3[i_instbus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]];
    end
  //if(rst)
  //  begin
  //  o_instbus_req   <= '0;
  //  o_instbus_ack   <= '0;
  //  end
  end


//Memory bus
always_ff @(posedge clk)
  begin
  o_membus_req   <= i_membus_req;    
  o_membus_ack   <= i_membus_ack;    
  o_membus_write <= i_membus_write;  
  o_membus_addr  <= i_membus_addr;   
  o_membus_data  <= i_membus_data;   

  if(i_membus_req &
     i_membus_addr >= ADDR_BASE &
     i_membus_addr <= ADDR_BASE + 2**SIZE - 1)
    begin
    o_membus_req <= '0;    
    o_membus_ack <= '1;
    if (i_membus_write)
      begin
      mem_array_0[i_membus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]] <= i_membus_data[7:0];
      mem_array_1[i_membus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]] <= i_membus_data[15:8];
      mem_array_2[i_membus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]] <= i_membus_data[23:16];
      mem_array_3[i_membus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]] <= i_membus_data[31:24];
      end
    o_membus_data[7:0]   <= mem_array_0[i_membus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]];
    o_membus_data[15:8]  <= mem_array_1[i_membus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]];
    o_membus_data[23:16] <= mem_array_2[i_membus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]];
    o_membus_data[31:24] <= mem_array_3[i_membus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2]];
    end
  //if(rst)
  //  begin
  //  o_membus_req   <= '0;
  //  o_membus_ack   <= '0;
  //  end
  end

initial
  begin
    $readmemh("../../tests/demo/demo_3.v", mem_array_3);
    $readmemh("../../tests/demo/demo_2.v", mem_array_2);
    $readmemh("../../tests/demo/demo_1.v", mem_array_1);
    $readmemh("../../tests/demo/demo_0.v", mem_array_0);
  end

endmodule
