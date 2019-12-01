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

logic         buffer_R_wren;
logic [7:0]   buffer_R_out;
logic         buffer_G_wren;
logic [7:0]   buffer_G_out;
logic         buffer_B_wren;
logic [7:0]   buffer_B_out;

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
  buffer_R_wren = '0;
  buffer_G_wren = '0;
  buffer_B_wren = '0;

  if(i_membus_req)
    begin
    if (i_membus_write & i_membus_data_wr_mask[0])
      begin
      buffer_B_wren = '1;
      end
    if (i_membus_write & i_membus_data_wr_mask[1])
      begin
      buffer_G_wren = '1;
      end
    if (i_membus_write & i_membus_data_wr_mask[2])
      begin
      buffer_R_wren = '1;
      end
    end
  end

always_ff @(posedge clk)
  begin
  //o_membus_req           <= '0;
  o_membus_ack           <= '0;
  //o_membus_write         <= '0;
  //o_membus_addr          <= '0;
  o_membus_data          <= '0;
  //o_membus_data_rd_mask  <= '0;
  //o_membus_data_wr_mask  <= '0;

  idle <= '0;
  accessing <= '0;

  case(1'b1) 
  idle :      begin
              if(i_membus_req)
                begin
                accessing <= '1;
                //membus_req           <= i_membus_req;    
                //membus_ack           <= i_membus_ack;    
                //membus_write         <= i_membus_write;  
                //membus_addr          <= i_membus_addr;   
                //membus_data          <= i_membus_data;   
                //membus_data_rd_mask  <= i_membus_data_rd_mask;   
                //membus_data_wr_mask  <= i_membus_data_wr_mask;   
                end else begin
                  idle <= '1;
                  //o_membus_req           <= i_membus_req;    
                  //o_membus_ack           <= i_membus_ack;    
                  //o_membus_write         <= i_membus_write;  
                  //o_membus_addr          <= i_membus_addr;   
                  //o_membus_data          <= i_membus_data;   
                  //o_membus_data_rd_mask  <= i_membus_data_rd_mask;   
                  //o_membus_data_wr_mask  <= i_membus_data_wr_mask;   
                end
              end
  accessing : begin
              idle <= '1;
              //o_membus_req <= '0;    
              o_membus_ack <= '1;
              //o_membus_write         <= membus_write;  
              //o_membus_addr          <= membus_addr;   
              o_membus_data[7:0]     <= buffer_B_out;
              o_membus_data[15:8]    <= buffer_G_out;
              o_membus_data[23:16]   <= buffer_R_out;
              o_membus_data[31:24]   <= '0;
              //o_membus_data_rd_mask  <= membus_data_rd_mask;   
              //o_membus_data_wr_mask  <= membus_data_wr_mask;   
              end
    
  endcase
  
  if(rst) 
    begin
    idle <= '1;
    accessing <= '0;
    end
  end

display_buffer display_buffer_R (
  .clock ( clk ),
  .data ( i_membus_data[23:16] ),
  .rdaddress ( i_membus_addr ),
  .wraddress ( i_membus_addr ),
  .wren ( buffer_R_wren ),
  .q ( buffer_R_out )
  );

display_buffer display_buffer_G (
  .clock ( clk ),
  .data ( i_membus_data[15:8] ),
  .rdaddress ( i_membus_addr ),
  .wraddress ( i_membus_addr ),
  .wren ( buffer_G_wren ),
  .q ( buffer_G_out )
  );

display_buffer display_buffer_B (
  .clock ( clk ),
  .data ( i_membus_data[7:0] ),
  .rdaddress ( i_membus_addr ),
  .wraddress ( i_membus_addr ),
  .wren ( buffer_B_wren ),
  .q ( buffer_B_out )
  );

endmodule
