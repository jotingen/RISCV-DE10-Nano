module mem (
  input  logic           clk,
  input  logic           rst,

  input  logic           i_instbus_req,
  input  logic [31:0]    i_instbus_addr,

  output logic           o_instbus_ack,
  output logic [31:0]    o_instbus_data,

  input  logic           i_membus_req,
  input  logic           i_membus_write,
  input  logic [31:0]    i_membus_addr,
  input  logic [31:0]    i_membus_data,
  input  logic  [3:0]    i_membus_data_rd_mask,
  input  logic  [3:0]    i_membus_data_wr_mask,

  output logic           o_membus_ack,
  output logic [31:0]    o_membus_data
);

localparam SIZE = 15;

logic [7:0] mem_array_3 [2**(SIZE-2)-1:0];
logic [7:0] mem_array_2 [2**(SIZE-2)-1:0];
logic [7:0] mem_array_1 [2**(SIZE-2)-1:0];
logic [7:0] mem_array_0 [2**(SIZE-2)-1:0];

//Instruction bus
always_ff @(posedge clk)
  begin
  o_instbus_ack   <= '0;    
  o_instbus_data  <= '0;   

  if(i_instbus_req)
    begin
    o_instbus_ack <= '1;
    o_instbus_data[7:0]   <= mem_array_0[i_instbus_addr[SIZE+2:2]];
    o_instbus_data[15:8]  <= mem_array_1[i_instbus_addr[SIZE+2:2]];
    o_instbus_data[23:16] <= mem_array_2[i_instbus_addr[SIZE+2:2]];
    o_instbus_data[31:24] <= mem_array_3[i_instbus_addr[SIZE+2:2]];
    end
  end


//Memory bus
always_ff @(posedge clk)
  begin
  o_membus_ack   <= '0;   
  o_membus_data  <= '0;   

  if(i_membus_req)
    begin
    o_membus_ack <= '1;
    if (i_membus_write & i_membus_data_wr_mask[0])
      begin
      mem_array_0[i_membus_addr[SIZE+2:2]] <= i_membus_data[7:0];
      end
    if (i_membus_write & i_membus_data_wr_mask[1])
      begin
      mem_array_1[i_membus_addr[SIZE+2:2]] <= i_membus_data[15:8];
      end
    if (i_membus_write & i_membus_data_wr_mask[2])
      begin
      mem_array_2[i_membus_addr[SIZE+2:2]] <= i_membus_data[23:16];
      end
    if (i_membus_write & i_membus_data_wr_mask[3])
      begin
      mem_array_3[i_membus_addr[SIZE+2:2]] <= i_membus_data[31:24];
      end
    o_membus_data[7:0]   <= mem_array_0[i_membus_addr[SIZE+2:2]];
    o_membus_data[15:8]  <= mem_array_1[i_membus_addr[SIZE+2:2]];
    o_membus_data[23:16] <= mem_array_2[i_membus_addr[SIZE+2:2]];
    o_membus_data[31:24] <= mem_array_3[i_membus_addr[SIZE+2:2]];
    end
  end

initial
  begin
    //$readmemh("../../output/programs/bootloader/bootloader_3.v", mem_array_3);
    //$readmemh("../../output/programs/bootloader/bootloader_2.v", mem_array_2);
    //$readmemh("../../output/programs/bootloader/bootloader_1.v", mem_array_1);
    //$readmemh("../../output/programs/bootloader/bootloader_0.v", mem_array_0);
    $readmemh("../../output/programs/bootloader/bootloader_fast_3.v", mem_array_3);
    $readmemh("../../output/programs/bootloader/bootloader_fast_2.v", mem_array_2);
    $readmemh("../../output/programs/bootloader/bootloader_fast_1.v", mem_array_1);
    $readmemh("../../output/programs/bootloader/bootloader_fast_0.v", mem_array_0);
    //$readmemh("../../output/programs/test/display_test_3.v", mem_array_3);
    //$readmemh("../../output/programs/test/display_test_2.v", mem_array_2);
    //$readmemh("../../output/programs/test/display_test_1.v", mem_array_1);
    //$readmemh("../../output/programs/test/display_test_0.v", mem_array_0);
  end

endmodule
