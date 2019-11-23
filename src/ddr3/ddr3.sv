module ddr3 (
  input  logic           clk,
  input  logic           ddr3_clk,
  input  logic           rst,

  input  logic           ddr3_avl_ready,       
  output logic [25:0]    ddr3_avl_addr,        
  input  logic           ddr3_avl_rdata_valid, 
  input  logic [127:0]   ddr3_avl_rdata,       
  output logic [127:0]   ddr3_avl_wdata,       
  output logic           ddr3_avl_read_req,    
  output logic           ddr3_avl_write_req,   
  output logic [0:0]     ddr3_avl_size,

  input  logic           i_membus_req,
  input  logic           i_membus_write,
  input  logic [31:0]    i_membus_addr,
  input  logic [31:0]    i_membus_data,
  input  logic  [3:0]    i_membus_data_rd_mask,
  input  logic  [3:0]    i_membus_data_wr_mask,

  output logic           o_membus_ack,
  output logic [31:0]    o_membus_data
);


logic state_idle;
logic state_flush;
logic state_flush_pending;
logic state_load;
logic state_load_pending;
logic state_update;


logic             buffer_vld;
logic [25:0]      buffer_addr;
logic [3:0][31:0] buffer_data;

logic         ddr3_fifo_out_wrreq;
logic         ddr3_fifo_out_rdreq;
logic [127:0] ddr3_fifo_out_data;
logic [25:0]  ddr3_fifo_out_addr;

logic         ddr3_fifo_out_rdempty;
logic         ddr3_fifo_out_rdack;

logic         ddr3_fifo_in_rdack;
logic [189:0] ddr3_fifo_in_q;
logic         ddr3_fifo_in_empty;

always_ff @(posedge clk)
  begin
  state_idle          <= '0;
  state_flush         <= '0;
  state_flush_pending <= '0;
  state_load          <= '0;
  state_load_pending  <= '0;
  state_update        <= '0;

  buffer_vld  <= buffer_vld; 
  buffer_addr <= buffer_addr;
  buffer_data <= buffer_data;

  o_membus_ack   <= '0;    
  o_membus_data  <= i_membus_data;   
  ddr3_fifo_out_wrreq <= '0;
  ddr3_fifo_out_rdreq <= '0;

                  //o_membus_ack <= '1;
                  //o_membus_data <= '0;

                  //ddr3_fifo_out_wrreq <= i_membus_data_wr_mask;
                  //ddr3_fifo_out_rdreq <= i_membus_data_rd_mask;
                  //ddr3_fifo_out_data  <= {4{i_membus_data}};
                  //ddr3_fifo_out_addr  <= i_membus_addr;
  case (1'b1)
    state_idle: begin
                if(i_membus_req)
                  begin
                  if(buffer_vld)
                    begin
                    if(buffer_addr == i_membus_addr[25:0])
                      begin
                      state_update <= '1;
                      end
                    else
                      begin
                      state_flush <= '1;
                      end
                    end
                  else
                    begin
                    state_load <= '1;
                    end
                  end
                else
                  begin
                  state_idle <= '1;
                  end
                end
      state_flush: begin             
                   ddr3_fifo_out_wrreq <= '1;
                   buffer_vld <= '0;
                   ddr3_fifo_out_data  <= buffer_data;
                   ddr3_fifo_out_addr  <= buffer_addr;
                   state_flush_pending <= '1;
                   end
      state_flush_pending: begin             
                           if(~ddr3_fifo_in_empty)
                             begin
                             ddr3_fifo_in_rdack <= '1;
                             state_load <= '1;
                             end
                           else
                             begin
                             state_flush_pending <= '1;
                             end
                           end
      state_load: begin             
                  ddr3_fifo_out_rdreq <= '1;
                  ddr3_fifo_out_addr  <= i_membus_addr;
                  buffer_addr  <= i_membus_addr;
                  state_load_pending <= '1;
                  end
      state_load_pending: begin             
                          if(~ddr3_fifo_in_empty)
                            begin
                            ddr3_fifo_in_rdack <= '1;   
                            buffer_vld <= '1;
                            buffer_data = ddr3_fifo_in_q[127:0];
                            state_update <= '1;
                            end
                          else
                            begin
                            state_load_pending <= '1;
                            end
                          end
      state_update: begin             
                  case(i_membus_addr[5:4])
                    2'b00: buffer_addr[31:0]   <= i_membus_data;
                    2'b01: buffer_addr[63:32]  <= i_membus_data;
                    2'b10: buffer_addr[95:64]  <= i_membus_data;
                    2'b11: buffer_addr[127:96] <= i_membus_data;
                  endcase
                  state_idle <= '1;
                  end
      endcase
 
    if(rst) 
      begin
      state_idle          <= '1;
      state_flush         <= '0;
      state_flush_pending <= '0;
      state_load          <= '0;
      state_load_pending  <= '0;
      state_update        <= '0;

      buffer_vld  <= '0;
      buffer_addr <= '0;
      buffer_data <= '0;

      ddr3_fifo_out_wrreq <= '0;
      ddr3_fifo_out_rdreq <= '0;
      end
  end

always_ff @(posedge ddr3_clk)
  begin

  ddr3_avl_addr      <= '0;  
  ddr3_avl_wdata     <= '0;  
  ddr3_avl_read_req  <= '0;  
  ddr3_avl_write_req <= '0;  
  ddr3_avl_size      <= '1;   
  ddr3_fifo_out_rdack <= '0;

  if(~ddr3_fifo_out_rdempty & ddr3_avl_ready & ~ddr3_fifo_out_rdack) 
    begin
    ddr3_fifo_out_rdack <= '1;
    end

  end

ddr3_fifo ddr3_fifo_out (
  .aclr    ( rst ),
  .data    ( {45'b0,
              ddr3_fifo_out_wrreq,
              ddr3_fifo_out_rdreq,
              ddr3_fifo_out_addr,
              ddr3_fifo_out_data} ),
  .rdclk   ( ddr3_clk ),
  .rdreq   ( ddr3_fifo_out_rdack ),
  .wrclk   ( clk ),
  .wrreq   ( ddr3_fifo_out_wrreq ),
  .q       ( {ddr3_avl_wr,
              ddr3_avl_rd,
              ddr3_avl_addr,
              ddr3_avl_wdata} ),
  .rdempty ( ddr3_fifo_out_rdempty )
);

ddr3_fifo ddr3_fifo_in (
  .aclr    ( rst ),
  .data    ( {62'b0,ddr3_avl_rdata} ),
  .rdclk   ( clk ),
  .rdreq   ( ddr3_fifo_in_rdack ),
  .wrclk   ( ddr3_clk ),
  .wrreq   ( ddr3_avl_rdata_valid ),
  .q       ( ddr3_fifo_in_q ),
  .rdempty ( ddr3_fifo_in_empty )
);

endmodule
