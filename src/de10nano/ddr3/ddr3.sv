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
  output logic [8:0]     ddr3_avl_size,

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
logic state_load;
logic state_load_pending;
logic state_update;

logic [3:0] flush_cnt;

logic             buffer_vld;
logic [25:4]      buffer_addr;
logic [127:0]     buffer_data;

logic         ddr3_fifo_out_wrreq;
logic         ddr3_fifo_out_rdreq;
logic [127:0] ddr3_fifo_out_data;
logic [25:0]  ddr3_fifo_out_addr;

logic         ddr3_fifo_out_wrreq_q;
logic         ddr3_fifo_out_rdreq_q;
logic [127:0] ddr3_fifo_out_wdata_q;
logic [25:0]  ddr3_fifo_out_addr_q;

logic         ddr3_fifo_out_rdempty;
logic         ddr3_fifo_out_rdack;

logic         ddr3_avl_wait;
logic         ddr3_avl_rd;
logic         ddr3_avl_wr;

logic         ddr3_fifo_in_rdack;
logic         ddr3_fifo_in_wrreq;
logic [189:0] ddr3_fifo_in_q;
logic         ddr3_fifo_in_empty;

always_ff @(posedge clk)
  begin
  state_idle          <= '0;
  state_flush         <= '0;
  state_load          <= '0;
  state_load_pending  <= '0;
  state_update        <= '0;

  flush_cnt <= flush_cnt;

  buffer_vld  <= buffer_vld; 
  buffer_addr <= buffer_addr;
  buffer_data <= buffer_data;

  o_membus_ack   <= '0;    
  o_membus_data  <= i_membus_data;   
  ddr3_fifo_out_wrreq <= '0;
  ddr3_fifo_out_rdreq <= '0;
  ddr3_fifo_out_data  <= ddr3_fifo_out_data;
  ddr3_fifo_out_addr  <= ddr3_fifo_out_addr;
  ddr3_fifo_in_rdack  <= '0;

  case (1'b1)
    state_idle: begin
                if(i_membus_req)
                  begin
                  if(buffer_vld)
                    begin
                    if(buffer_addr[25:4] == i_membus_addr[25:4])
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
                   if(flush_cnt == 0)
                     begin
                     ddr3_fifo_out_wrreq <= '1;
                     buffer_vld <= '0;
                     ddr3_fifo_out_data  <= buffer_data;
                     ddr3_fifo_out_addr  <= {buffer_addr[25:4],4'b0000};
                     flush_cnt <= flush_cnt+1;
                     state_flush <= '1;
                     end
                   else if(flush_cnt == 4'b1111)
                     begin
                     flush_cnt <= flush_cnt+1;
                     state_load <= '1;
                     end
                   else
                     begin
                     flush_cnt <= flush_cnt+1;
                     state_flush <= '1;
                     end
                   end
      state_load: begin             
                  ddr3_fifo_out_rdreq <= '1;
                  ddr3_fifo_out_addr  <= {i_membus_addr[25:4],4'b0000};
                  buffer_addr  <= i_membus_addr[25:4];
                  state_load_pending <= '1;
                  end
      state_load_pending: begin             
                          if(~ddr3_fifo_in_empty)
                            begin
                            ddr3_fifo_in_rdack <= '1;   
                            buffer_vld <= '1;
                            buffer_data <= ddr3_fifo_in_q[127:0];
                            state_update <= '1;
                            end
                          else
                            begin
                            state_load_pending <= '1;
                            end
                          end
      state_update: begin             
                  o_membus_ack   <= '1;    
                  if(i_membus_write)
                    begin
                    case(i_membus_addr[3:2])
                      2'b00: begin
                             buffer_data[31:24]   <= i_membus_data_wr_mask[3] ? i_membus_data[31:24] : buffer_data[31:24]  ;
                             buffer_data[23:16]   <= i_membus_data_wr_mask[2] ? i_membus_data[23:16] : buffer_data[23:16]  ;
                             buffer_data[15:8]    <= i_membus_data_wr_mask[1] ? i_membus_data[15:8]  : buffer_data[15:8]   ;
                             buffer_data[7:0]     <= i_membus_data_wr_mask[0] ? i_membus_data[7:0]   : buffer_data[7:0]    ;
                             end
                      2'b01: begin
                             buffer_data[63:56]   <= i_membus_data_wr_mask[3] ? i_membus_data[31:24] : buffer_data[63:56];
                             buffer_data[55:48]   <= i_membus_data_wr_mask[2] ? i_membus_data[23:16] : buffer_data[55:48];
                             buffer_data[47:40]   <= i_membus_data_wr_mask[1] ? i_membus_data[15:8]  : buffer_data[47:40];
                             buffer_data[39:32]   <= i_membus_data_wr_mask[0] ? i_membus_data[7:0]   : buffer_data[39:32];
                             end
                      2'b10: begin
                             buffer_data[95:88]   <= i_membus_data_wr_mask[3] ? i_membus_data[31:24] : buffer_data[95:88];
                             buffer_data[87:80]   <= i_membus_data_wr_mask[2] ? i_membus_data[23:16] : buffer_data[87:80];
                             buffer_data[79:72]   <= i_membus_data_wr_mask[1] ? i_membus_data[15:8]  : buffer_data[79:72];
                             buffer_data[71:64]   <= i_membus_data_wr_mask[0] ? i_membus_data[7:0]   : buffer_data[71:64];
                             end
                      2'b11: begin
                             buffer_data[127:120] <= i_membus_data_wr_mask[3] ? i_membus_data[31:24] : buffer_data[127:120];
                             buffer_data[119:112] <= i_membus_data_wr_mask[2] ? i_membus_data[23:16] : buffer_data[119:112];
                             buffer_data[111:104] <= i_membus_data_wr_mask[1] ? i_membus_data[15:8]  : buffer_data[111:104];
                             buffer_data[103:96]  <= i_membus_data_wr_mask[0] ? i_membus_data[7:0]   : buffer_data[103:96] ;
                             end
                    endcase
                    end
                  case(i_membus_addr[3:2])
                    2'b00: begin
                           o_membus_data[31:24] <= i_membus_data_rd_mask[3] ? buffer_data[31:24]   : '0;   
                           o_membus_data[23:16] <= i_membus_data_rd_mask[2] ? buffer_data[23:16]   : '0;   
                           o_membus_data[15:8]  <= i_membus_data_rd_mask[1] ? buffer_data[15:8]    : '0;   
                           o_membus_data[7:0]   <= i_membus_data_rd_mask[0] ? buffer_data[7:0]     : '0;   
                           end
                    2'b01: begin
                           o_membus_data[31:24] <= i_membus_data_rd_mask[3] ? buffer_data[63:56]   : '0;   
                           o_membus_data[23:16] <= i_membus_data_rd_mask[2] ? buffer_data[55:48]   : '0;   
                           o_membus_data[15:8]  <= i_membus_data_rd_mask[1] ? buffer_data[47:40]   : '0;   
                           o_membus_data[7:0]   <= i_membus_data_rd_mask[0] ? buffer_data[39:32]   : '0;   
                           end
                    2'b10: begin
                           o_membus_data[31:24] <= i_membus_data_rd_mask[3] ? buffer_data[95:88]   : '0;   
                           o_membus_data[23:16] <= i_membus_data_rd_mask[2] ? buffer_data[87:80]   : '0;   
                           o_membus_data[15:8]  <= i_membus_data_rd_mask[1] ? buffer_data[79:72]   : '0;   
                           o_membus_data[7:0]   <= i_membus_data_rd_mask[0] ? buffer_data[71:64]   : '0;   
                           end
                    2'b11: begin
                           o_membus_data[31:24] <= i_membus_data_rd_mask[3] ? buffer_data[127:120] : '0;   
                           o_membus_data[23:16] <= i_membus_data_rd_mask[2] ? buffer_data[119:112] : '0;   
                           o_membus_data[15:8]  <= i_membus_data_rd_mask[1] ? buffer_data[111:104] : '0;   
                           o_membus_data[7:0]   <= i_membus_data_rd_mask[0] ? buffer_data[103:96]  : '0;   
                           end
                  endcase
                  state_idle <= '1;
                  end
      endcase
 
    if(rst) 
      begin
      state_idle          <= '1;
      state_flush         <= '0;
      state_load          <= '0;
      state_load_pending  <= '0;
      state_update        <= '0;

      flush_cnt <= '0;

      buffer_vld  <= '0;
      buffer_addr <= '0;
      buffer_data <= '0;

      ddr3_fifo_out_wrreq <= '0;
      ddr3_fifo_out_rdreq <= '0;
      end
  end

logic ddr3_state_idle;
logic ddr3_state_pulse;
logic ddr3_state_recieve;
//Force 3 reads/writes to get accurate data back on the 3rd
//still not sure why things are off, maybe ddr3 clock is unnnecessary
logic [1:0] ddr3_cnt;

assign ddr3_avl_wait = ~ddr3_avl_ready;
always_ff @(posedge ddr3_clk)
  begin

  ddr3_state_idle     <= '0;
  ddr3_state_pulse    <= '0;
  ddr3_state_recieve <= '0;

  ddr3_avl_read_req   <= ddr3_avl_read_req;  
  ddr3_avl_write_req  <= ddr3_avl_write_req;  
  ddr3_avl_addr       <= ddr3_avl_addr;
  ddr3_avl_wdata      <= ddr3_avl_wdata; 
  ddr3_avl_size       <= 9'd1;   
  ddr3_fifo_out_rdack <= '0;
  ddr3_fifo_in_wrreq  <= '0;

  case(1'b1)
		ddr3_state_idle: begin
										 if(~ddr3_fifo_out_rdempty)
											 begin
											 ddr3_fifo_out_rdack <= '1;
                       ddr3_avl_read_req   <= ddr3_fifo_out_rdreq_q;  
                       ddr3_avl_write_req  <= ddr3_fifo_out_wrreq_q;  
                       ddr3_avl_addr       <= ddr3_fifo_out_addr_q;
                       ddr3_avl_wdata      <= ddr3_fifo_out_wdata_q; 
											 ddr3_cnt <= '0;
											 ddr3_state_pulse <= '1;
											 end
										 else
										   begin
                       ddr3_state_idle <= '1;
                       end
                     end
    ddr3_state_pulse: begin
                      if(ddr3_cnt == 2) 
                        begin
                        ddr3_cnt <= '0;
                        ddr3_avl_read_req   <= '0;  
                        ddr3_avl_write_req  <= '0;  
                        if(ddr3_avl_read_req)
                          begin
                          ddr3_state_recieve <= '1;
                          end
                        else
                          begin
                          ddr3_state_idle <= '1;
                          end
                        end
                      else
                        begin
                        ddr3_cnt <= ddr3_cnt + 1;
                        ddr3_state_pulse <= '1;
                        end
                      end
   ddr3_state_recieve: begin
                       if(ddr3_avl_rdata_valid)
                         begin
                         if(ddr3_cnt == 2)
                           begin
                           ddr3_fifo_in_wrreq <= '1;
                           ddr3_state_idle <= '1;
                           end
                         else
                           begin
                           ddr3_cnt <= ddr3_cnt + 1;
                           ddr3_state_recieve <= '1;
                           end
                         end
                       else
                         begin
                         ddr3_state_recieve <= '1;
                         end
                       end
  endcase

  if(rst)
    begin
    ddr3_state_idle     <= '1;
    ddr3_state_pulse    <= '0;
    ddr3_state_recieve <= '0;
		ddr3_cnt <= '0;
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
  .wrreq   ( (ddr3_fifo_out_wrreq | ddr3_fifo_out_rdreq) ),
  .q       ( {ddr3_fifo_out_wrreq_q,
              ddr3_fifo_out_rdreq_q,
              ddr3_fifo_out_addr_q,
              ddr3_fifo_out_wdata_q} ),
  .rdempty ( ddr3_fifo_out_rdempty )
);

ddr3_fifo ddr3_fifo_in (
  .aclr    ( rst ),
  .data    ( {62'b0,ddr3_avl_rdata} ),
  .rdclk   ( clk ),
  .rdreq   ( ddr3_fifo_in_rdack ),
  .wrclk   ( ddr3_clk ),
  .wrreq   ( ddr3_fifo_in_wrreq ),
  .q       ( ddr3_fifo_in_q ),
  .rdempty ( ddr3_fifo_in_empty )
);

endmodule
