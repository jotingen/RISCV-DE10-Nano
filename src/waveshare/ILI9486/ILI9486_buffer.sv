module ILI9486_buffer (
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

logic         buffer_R_0_wren;
logic [7:0]   buffer_R_0_out;
logic         buffer_R_1_wren;
logic [7:0]   buffer_R_1_out;
logic         buffer_R_2_wren;
logic [7:0]   buffer_R_2_out;
logic         buffer_G_0_wren;
logic [7:0]   buffer_G_0_out;
logic         buffer_G_1_wren;
logic [7:0]   buffer_G_1_out;
logic         buffer_G_2_wren;
logic [7:0]   buffer_G_2_out;
logic         buffer_B_0_wren;
logic [7:0]   buffer_B_0_out;
logic         buffer_B_1_wren;
logic [7:0]   buffer_B_1_out;
logic         buffer_B_2_wren;
logic [7:0]   buffer_B_2_out;

logic           membus_req;
logic           membus_ack;
logic           membus_write;
logic [31:0]    membus_addr;
logic [31:0]    membus_data;
logic  [3:0]    membus_data_rd_mask;
logic  [3:0]    membus_data_wr_mask;

logic         idle;
logic         accessing;


always_comb
  begin
  buffer_R_0_wren = '0;
  buffer_R_1_wren = '0;
  buffer_R_2_wren = '0;
  buffer_G_0_wren = '0;
  buffer_G_1_wren = '0;
  buffer_G_2_wren = '0;
  buffer_B_0_wren = '0;
  buffer_B_1_wren = '0;
  buffer_B_2_wren = '0;

  if(i_membus_req)
    begin
    if (i_membus_write & i_membus_data_wr_mask[0])
      begin
      if(i_membus_addr[31:16] == 'h0000)
        begin
        buffer_B_0_wren = '1;
        end
      if(i_membus_addr[31:16] == 'h0001)
        begin
        buffer_B_1_wren = '1;
        end
      if(i_membus_addr[31:16] == 'h0010)
        begin
        buffer_B_2_wren = '1;
        end
      end
    if (i_membus_write & i_membus_data_wr_mask[1])
      begin
      if(i_membus_addr[31:16] == 'h0000)
        begin
        buffer_G_0_wren = '1;
        end
      if(i_membus_addr[31:16] == 'h0001)
        begin
        buffer_G_1_wren = '1;
        end
      if(i_membus_addr[31:16] == 'h0010)
        begin
        buffer_G_2_wren = '1;
        end
      end
    if (i_membus_write & i_membus_data_wr_mask[2])
      begin
      if(i_membus_addr[31:16] == 'h0000)
        begin
        buffer_R_0_wren = '1;
        end
      if(i_membus_addr[31:16] == 'h0001)
        begin
        buffer_R_1_wren = '1;
        end
      if(i_membus_addr[31:16] == 'h0010)
        begin
        buffer_R_2_wren = '1;
        end
      end
    end
  end

always_ff @(posedge clk)
  begin
  o_membus_ack           <= '0;
  o_membus_data          <= '0;

  idle <= '0;
  accessing <= '0;

  case(1'b1) 
  idle :      begin
              if(i_membus_req)
                begin
                accessing <= '1;
                end 
              else 
                begin
                  idle <= '1;
                end
              end
  accessing : begin
              idle <= '1;
              o_membus_ack <= '1;
              if(i_membus_addr[31:16] == 'h0000)
                begin
                o_membus_data[7:0]     <= buffer_B_0_out;
                o_membus_data[15:8]    <= buffer_G_0_out;
                o_membus_data[23:16]   <= buffer_R_0_out;
                o_membus_data[31:24]   <= '0;
                end
              if(i_membus_addr[31:16] == 'h0001)
                begin
                o_membus_data[7:0]     <= buffer_B_1_out;
                o_membus_data[15:8]    <= buffer_G_1_out;
                o_membus_data[23:16]   <= buffer_R_1_out;
                o_membus_data[31:24]   <= '0;
                end
              if(i_membus_addr[31:16] == 'h0010)
                begin
                o_membus_data[7:0]     <= buffer_B_2_out;
                o_membus_data[15:8]    <= buffer_G_2_out;
                o_membus_data[23:16]   <= buffer_R_2_out;
                o_membus_data[31:24]   <= '0;
                end
              end
    
  endcase
  
  if(rst) 
    begin
    idle <= '1;
    accessing <= '0;
    end
  end

//display_buffer display_buffer_R_0 (
//  .clock ( clk ),
//  .data ( i_membus_data[23:16] ),
//  .rdaddress ( i_membus_addr ),
//  .wraddress ( i_membus_addr ),
//  .wren ( buffer_R_0_wren ),
//  .q ( buffer_R_0_out )
//  );
//display_buffer display_buffer_R_1 (
//  .clock ( clk ),
//  .data ( i_membus_data[23:16] ),
//  .rdaddress ( i_membus_addr ),
//  .wraddress ( i_membus_addr ),
//  .wren ( buffer_R_1_wren ),
//  .q ( buffer_R_1_out )
//  );
//display_buffer_32k display_buffer_R_2 (
//  .clock ( clk ),
//  .data ( i_membus_data[23:16] ),
//  .rdaddress ( i_membus_addr ),
//  .wraddress ( i_membus_addr ),
//  .wren ( buffer_R_2_wren ),
//  .q ( buffer_R_2_out )
//  );
//
//display_buffer display_buffer_G_0 (
//  .clock ( clk ),
//  .data ( i_membus_data[15:8] ),
//  .rdaddress ( i_membus_addr[15:0] ),
//  .wraddress ( i_membus_addr[15:0] ),
//  .wren ( buffer_G_0_wren ),
//  .q ( buffer_G_0_out )
//  );
//display_buffer display_buffer_G_1 (
//  .clock ( clk ),
//  .data ( i_membus_data[15:8] ),
//  .rdaddress ( i_membus_addr[15:0] ),
//  .wraddress ( i_membus_addr[15:0] ),
//  .wren ( buffer_G_1_wren ),
//  .q ( buffer_G_1_out )
//  );
//display_buffer_32k display_buffer_G_2 (
//  .clock ( clk ),
//  .data ( i_membus_data[15:8] ),
//  .rdaddress ( i_membus_addr[15:0] ),
//  .wraddress ( i_membus_addr[15:0] ),
//  .wren ( buffer_G_2_wren ),
//  .q ( buffer_G_2_out )
//  );
//
//display_buffer display_buffer_B_0 (
//  .clock ( clk ),
//  .data ( i_membus_data[7:0] ),
//  .rdaddress ( i_membus_addr[15:0] ),
//  .wraddress ( i_membus_addr[15:0] ),
//  .wren ( buffer_B_0_wren ),
//  .q ( buffer_B_0_out )
//  );
//display_buffer display_buffer_B_1 (
//  .clock ( clk ),
//  .data ( i_membus_data[7:0] ),
//  .rdaddress ( i_membus_addr[15:0] ),
//  .wraddress ( i_membus_addr[15:0] ),
//  .wren ( buffer_B_1_wren ),
//  .q ( buffer_B_1_out )
//  );
//display_buffer_32k display_buffer_B_2 (
//  .clock ( clk ),
//  .data ( i_membus_data[7:0] ),
//  .rdaddress ( i_membus_addr[15:0] ),
//  .wraddress ( i_membus_addr[15:0] ),
//  .wren ( buffer_B_2_wren ),
//  .q ( buffer_B_2_out )
//  );

endmodule
