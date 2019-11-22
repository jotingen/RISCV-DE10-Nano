module console_buffer (
  input  logic           clk,
  input  logic           rst,

  input  logic           i_membus_req,
  input  logic           i_membus_write,
  input  logic [31:0]    i_membus_addr,
  input  logic [31:0]    i_membus_data,
  input  logic  [3:0]    i_membus_data_rd_mask,
  input  logic  [3:0]    i_membus_data_wr_mask,

  output logic           o_membus_ack,
  output logic [31:0]    o_membus_data
);

logic [7:0] mem_array_3 [319:0];
logic [7:0] mem_array_2 [319:0];
logic [7:0] mem_array_1 [319:0];
logic [7:0] mem_array_0 [319:0];

`ifdef RISCV_FORMAL
logic [19:0][7:0] dbg_console_00;
logic [19:0][7:0] dbg_console_01;
logic [19:0][7:0] dbg_console_02;
logic [19:0][7:0] dbg_console_03;
logic [19:0][7:0] dbg_console_04;
logic [19:0][7:0] dbg_console_05;
logic [19:0][7:0] dbg_console_06;
logic [19:0][7:0] dbg_console_07;
logic [19:0][7:0] dbg_console_08;
logic [19:0][7:0] dbg_console_09;
logic [19:0][7:0] dbg_console_10;
logic [19:0][7:0] dbg_console_11;
logic [19:0][7:0] dbg_console_12;
logic [19:0][7:0] dbg_console_13;
logic [19:0][7:0] dbg_console_14;
logic [19:0][7:0] dbg_console_15;
always_comb
  begin
  for(int x = 0; x < 20; x++)
    begin
    dbg_console_00[x] = { << {mem_array_0[00*20 + x]}};
    dbg_console_01[x] = { << {mem_array_0[01*20 + x]}};
    dbg_console_02[x] = { << {mem_array_0[02*20 + x]}};
    dbg_console_03[x] = { << {mem_array_0[03*20 + x]}};
    dbg_console_04[x] = { << {mem_array_0[04*20 + x]}};
    dbg_console_05[x] = { << {mem_array_0[05*20 + x]}};
    dbg_console_06[x] = { << {mem_array_0[06*20 + x]}};
    dbg_console_07[x] = { << {mem_array_0[07*20 + x]}};
    dbg_console_08[x] = { << {mem_array_0[08*20 + x]}};
    dbg_console_09[x] = { << {mem_array_0[09*20 + x]}};
    dbg_console_10[x] = { << {mem_array_0[10*20 + x]}};
    dbg_console_11[x] = { << {mem_array_0[11*20 + x]}};
    dbg_console_12[x] = { << {mem_array_0[12*20 + x]}};
    dbg_console_13[x] = { << {mem_array_0[13*20 + x]}};
    dbg_console_14[x] = { << {mem_array_0[14*20 + x]}};
    dbg_console_15[x] = { << {mem_array_0[15*20 + x]}};
    end
  end
`endif

always_ff @(posedge clk)
  begin
  o_membus_ack   <= '0;   
  o_membus_data  <= '0;   

  if(i_membus_req)
    begin
    o_membus_ack <= '1;
    if (i_membus_write & i_membus_data_wr_mask[0])
      begin
      mem_array_0[i_membus_addr[31:2]] <= i_membus_data[7:0];
      end
    if (i_membus_write & i_membus_data_wr_mask[1])
      begin
      mem_array_1[i_membus_addr[31:2]] <= i_membus_data[15:8];
      end
    if (i_membus_write & i_membus_data_wr_mask[2])
      begin
      mem_array_2[i_membus_addr[31:2]] <= i_membus_data[23:16];
      end
    if (i_membus_write & i_membus_data_wr_mask[3])
      begin
      mem_array_3[i_membus_addr[31:2]] <= i_membus_data[31:24];
      end
    o_membus_data[7:0]   <= mem_array_0[i_membus_addr[31:2]];
    o_membus_data[15:8]  <= mem_array_1[i_membus_addr[31:2]];
    o_membus_data[23:16] <= mem_array_2[i_membus_addr[31:2]];
    o_membus_data[31:24] <= mem_array_3[i_membus_addr[31:2]];
    end
  end

endmodule
