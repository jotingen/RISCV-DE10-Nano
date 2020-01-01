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

  input  logic [31:0]    bus_inst_adr_i,
  input  logic [31:0]    bus_inst_data_i,
  input  logic           bus_inst_we_i,
  input  logic  [3:0]    bus_inst_sel_i,
  input  logic           bus_inst_stb_i,
  input  logic           bus_inst_cyc_i,
  input  logic           bus_inst_tga_i,
  input  logic           bus_inst_tgd_i,
  input  logic  [3:0]    bus_inst_tgc_i,

  output logic           bus_inst_ack_o,
  output logic           bus_inst_stall_o,
  output logic           bus_inst_err_o,
  output logic           bus_inst_rty_o,
  output logic [31:0]    bus_inst_data_o,
  output logic           bus_inst_tga_o,
  output logic           bus_inst_tgd_o,
  output logic  [3:0]    bus_inst_tgc_o,

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

logic         bus_inst_buff_almost_empty;
logic         bus_inst_buff_empty;

logic         bus_inst_req_stgd;
logic [31:0]  bus_inst_adr_stgd;
logic [31:0]  bus_inst_data_stgd;
logic         bus_inst_we_stgd;
logic  [3:0]  bus_inst_sel_stgd;
logic         bus_inst_tga_stgd;
logic         bus_inst_tgd_stgd;
logic  [3:0]  bus_inst_tgc_stgd;

logic         bus_inst_rd_ack;

logic         instbus_req_stgd;
logic [31:0]  instbus_addr_stgd;

logic         membus_req_stgd;
logic         membus_write_stgd;
logic [31:0]  membus_addr_stgd;
logic [31:0]  membus_data_stgd;
logic  [3:0]  membus_data_rd_mask_stgd;
logic  [3:0]  membus_data_wr_mask_stgd;

logic         arb_inst;
logic         arb_mem;

logic         state_inst;
logic         state_mem;
logic         state_idle;
logic         state_flush;
logic         state_load;
logic         state_load_pending;
logic         state_update;
logic         state_fifo_load;

logic [3:0]   flush_cnt;

logic         inst_buffer_vld;
logic [25:4]  inst_buffer_addr;
logic [127:0] inst_buffer_data;
logic         mem_buffer_vld;
logic [25:4]  mem_buffer_addr;
logic [127:0] mem_buffer_data;

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

assign bus_inst_req_stgd = ~bus_inst_buff_empty; 
wishbone_buff	bus_inst_buff (
	.clock        ( clk ),
	.data         ( {bus_inst_adr_i,
                         bus_inst_data_i,
                         bus_inst_we_i,
                         bus_inst_sel_i,
                         bus_inst_tga_i,
                         bus_inst_tgd_i,
                         bus_inst_tgc_i} ),
	.rdreq        ( bus_inst_rd_ack ),
	.sclr         ( rst ),
	.wrreq        ( bus_inst_cyc_i & bus_inst_stb_i & ~bus_inst_stall_o ),
	.almost_empty ( bus_inst_buff_almost_empty ),
	.almost_full  ( bus_inst_stall_o ),
	.empty        ( bus_inst_buff_empty ),
	.full         (  ),
	.q            ( {bus_inst_adr_stgd,
                         bus_inst_data_stgd,
                         bus_inst_we_stgd,
                         bus_inst_sel_stgd,
                         bus_inst_tga_stgd,
                         bus_inst_tgd_stgd,
                         bus_inst_tgc_stgd} ),
	.usedw        (  )
	);

always_ff @(posedge clk)
  begin
  arb_inst            <= arb_inst;
  arb_mem             <= arb_mem; 
      
  state_idle          <= '0;
  state_flush         <= '0;
  state_load          <= '0;
  state_load_pending  <= '0;
  state_update        <= '0;

  flush_cnt           <= flush_cnt;

  inst_buffer_vld     <= inst_buffer_vld; 
  inst_buffer_addr    <= inst_buffer_addr;
  inst_buffer_data    <= inst_buffer_data;
  mem_buffer_vld      <= mem_buffer_vld; 
  mem_buffer_addr     <= mem_buffer_addr;
  mem_buffer_data     <= mem_buffer_data;

  bus_inst_ack_o      <= '0;
  bus_inst_err_o      <= '0;
  bus_inst_rty_o      <= '0;
  bus_inst_data_o     <= '0;
  bus_inst_tga_o      <= '0;
  bus_inst_tgd_o      <= '0;
  bus_inst_tgc_o      <= '0;

  bus_inst_rd_ack     <= '0;

  o_instbus_ack       <= '0;    
  o_instbus_data      <= '0;   

  o_membus_ack        <= '0;    
  o_membus_data       <= membus_data_stgd;   

  ddr3_fifo_out_wrreq <= '0;
  ddr3_fifo_out_rdreq <= '0;
  ddr3_fifo_out_data  <= ddr3_fifo_out_data;
  ddr3_fifo_out_addr  <= ddr3_fifo_out_addr;
  ddr3_fifo_in_rdack  <= '0;

  if(i_instbus_req)
    begin
    instbus_req_stgd  <= i_instbus_req;
    instbus_addr_stgd <= i_instbus_addr;
    end

  if(i_membus_req)
    begin
    membus_req_stgd          <= i_membus_req;
    membus_write_stgd        <= i_membus_write;
    membus_addr_stgd         <= i_membus_addr;
    membus_data_stgd         <= i_membus_data;
    membus_data_rd_mask_stgd <= i_membus_data_rd_mask;
    membus_data_wr_mask_stgd <= i_membus_data_wr_mask;
    end


  case (1'b1)
    state_idle: begin
                if((arb_mem  & membus_req_stgd) |
                   (arb_inst & membus_req_stgd & ~bus_inst_req_stgd))
                  begin
                  arb_inst <= '1;
                  arb_mem  <= '0;
                  state_inst <= '0;
                  state_mem  <= '1;
                  if(mem_buffer_vld)
                    begin
                    if(mem_buffer_addr[25:4] == membus_addr_stgd[25:4])
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
                else if((arb_inst & bus_inst_req_stgd & ~bus_inst_buff_almost_empty) |
                        (arb_mem  & bus_inst_req_stgd & ~bus_inst_buff_almost_empty & ~membus_req_stgd))
                  begin
                  arb_inst <= '0;
                  arb_mem  <= '1;
                  state_inst <= '1;
                  state_mem  <= '0;
                  if(inst_buffer_vld)
                    begin
                    if(inst_buffer_addr[25:4] == bus_inst_adr_stgd[25:4])
                      begin
                      state_update <= '1;
                      end
                    else
                      begin
                      state_load <= '1; //Instructions never write
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
                     mem_buffer_vld <= '0;
                     ddr3_fifo_out_data  <= mem_buffer_data;
                     ddr3_fifo_out_addr  <= {mem_buffer_addr[25:4],4'b0000};
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
                  if(state_inst)
                    begin
                    ddr3_fifo_out_addr  <= {bus_inst_adr_stgd[25:4],4'b0000};
                    inst_buffer_addr  <= bus_inst_adr_stgd[25:4];
                    end
                  if(state_mem)
                    begin
                    ddr3_fifo_out_addr  <= {membus_addr_stgd[25:4],4'b0000};
                    mem_buffer_addr  <= membus_addr_stgd[25:4];
                    end
                  state_load_pending <= '1;
                  end
      state_load_pending: begin             
                          if(~ddr3_fifo_in_empty)
                            begin
                            ddr3_fifo_in_rdack <= '1;   
                            if(state_inst)
                              begin
                              inst_buffer_vld <= '1;
                              inst_buffer_data <= ddr3_fifo_in_q[127:0];
                              end
                            if(state_mem)
                              begin
                              mem_buffer_vld <= '1;
                              mem_buffer_data <= ddr3_fifo_in_q[127:0];
                              end
                            state_update <= '1;
                            end
                          else
                            begin
                            state_load_pending <= '1;
                            end
                          end
      state_update: begin             
                    if(state_inst)
                      begin
                      instbus_req_stgd <= '0;
		      bus_inst_rd_ack <= '1;
                      bus_inst_ack_o  <= '1;
                      o_instbus_ack   <= '1;    
                      case(bus_inst_adr_stgd[3:2])
                        2'b00: begin
                               bus_inst_data_o[31:24] <= inst_buffer_data[31:24]  ;   
                               bus_inst_data_o[23:16] <= inst_buffer_data[23:16]  ;   
                               bus_inst_data_o[15:8]  <= inst_buffer_data[15:8]   ;   
                               bus_inst_data_o[7:0]   <= inst_buffer_data[7:0]    ;   
                               o_instbus_data[31:24] <= inst_buffer_data[31:24]  ;   
                               o_instbus_data[23:16] <= inst_buffer_data[23:16]  ;   
                               o_instbus_data[15:8]  <= inst_buffer_data[15:8]   ;   
                               o_instbus_data[7:0]   <= inst_buffer_data[7:0]    ;   
                               end
                        2'b01: begin
                               bus_inst_data_o[31:24] <= inst_buffer_data[63:56]  ;   
                               bus_inst_data_o[23:16] <= inst_buffer_data[55:48]  ;   
                               bus_inst_data_o[15:8]  <= inst_buffer_data[47:40]  ;   
                               bus_inst_data_o[7:0]   <= inst_buffer_data[39:32]  ;   
                               o_instbus_data[31:24] <= inst_buffer_data[63:56]  ;   
                               o_instbus_data[23:16] <= inst_buffer_data[55:48]  ;   
                               o_instbus_data[15:8]  <= inst_buffer_data[47:40]  ;   
                               o_instbus_data[7:0]   <= inst_buffer_data[39:32]  ;   
                               end
                        2'b10: begin
                               bus_inst_data_o[31:24] <= inst_buffer_data[95:88]  ;   
                               bus_inst_data_o[23:16] <= inst_buffer_data[87:80]  ;   
                               bus_inst_data_o[15:8]  <= inst_buffer_data[79:72]  ;   
                               bus_inst_data_o[7:0]   <= inst_buffer_data[71:64]  ;   
                               o_instbus_data[31:24] <= inst_buffer_data[95:88]  ;   
                               o_instbus_data[23:16] <= inst_buffer_data[87:80]  ;   
                               o_instbus_data[15:8]  <= inst_buffer_data[79:72]  ;   
                               o_instbus_data[7:0]   <= inst_buffer_data[71:64]  ;   
                               end
                        2'b11: begin
                               bus_inst_data_o[31:24] <= inst_buffer_data[127:120];   
                               bus_inst_data_o[23:16] <= inst_buffer_data[119:112];   
                               bus_inst_data_o[15:8]  <= inst_buffer_data[111:104];   
                               bus_inst_data_o[7:0]   <= inst_buffer_data[103:96] ;   
                               o_instbus_data[31:24] <= inst_buffer_data[127:120];   
                               o_instbus_data[23:16] <= inst_buffer_data[119:112];   
                               o_instbus_data[15:8]  <= inst_buffer_data[111:104];   
                               o_instbus_data[7:0]   <= inst_buffer_data[103:96] ;   
                               end
                      endcase
                      bus_inst_tga_o <= bus_inst_tga_stgd;
                      bus_inst_tgd_o <= bus_inst_tgd_stgd;
                      bus_inst_tgc_o <= bus_inst_tgc_stgd;
                      end
                    if(state_mem)
                      begin
                      membus_req_stgd <= '0;
                      o_membus_ack   <= '1;    
                      if(membus_write_stgd)
                        begin
                        case(membus_addr_stgd[3:2])
                          2'b00: begin
                                 mem_buffer_data[31:24]   <= membus_data_wr_mask_stgd[3] ? membus_data_stgd[31:24] : mem_buffer_data[31:24]  ;
                                 mem_buffer_data[23:16]   <= membus_data_wr_mask_stgd[2] ? membus_data_stgd[23:16] : mem_buffer_data[23:16]  ;
                                 mem_buffer_data[15:8]    <= membus_data_wr_mask_stgd[1] ? membus_data_stgd[15:8]  : mem_buffer_data[15:8]   ;
                                 mem_buffer_data[7:0]     <= membus_data_wr_mask_stgd[0] ? membus_data_stgd[7:0]   : mem_buffer_data[7:0]    ;
                                 end
                          2'b01: begin
                                 mem_buffer_data[63:56]   <= membus_data_wr_mask_stgd[3] ? membus_data_stgd[31:24] : mem_buffer_data[63:56];
                                 mem_buffer_data[55:48]   <= membus_data_wr_mask_stgd[2] ? membus_data_stgd[23:16] : mem_buffer_data[55:48];
                                 mem_buffer_data[47:40]   <= membus_data_wr_mask_stgd[1] ? membus_data_stgd[15:8]  : mem_buffer_data[47:40];
                                 mem_buffer_data[39:32]   <= membus_data_wr_mask_stgd[0] ? membus_data_stgd[7:0]   : mem_buffer_data[39:32];
                                 end
                          2'b10: begin
                                 mem_buffer_data[95:88]   <= membus_data_wr_mask_stgd[3] ? membus_data_stgd[31:24] : mem_buffer_data[95:88];
                                 mem_buffer_data[87:80]   <= membus_data_wr_mask_stgd[2] ? membus_data_stgd[23:16] : mem_buffer_data[87:80];
                                 mem_buffer_data[79:72]   <= membus_data_wr_mask_stgd[1] ? membus_data_stgd[15:8]  : mem_buffer_data[79:72];
                                 mem_buffer_data[71:64]   <= membus_data_wr_mask_stgd[0] ? membus_data_stgd[7:0]   : mem_buffer_data[71:64];
                                 end
                          2'b11: begin
                                 mem_buffer_data[127:120] <= membus_data_wr_mask_stgd[3] ? membus_data_stgd[31:24] : mem_buffer_data[127:120];
                                 mem_buffer_data[119:112] <= membus_data_wr_mask_stgd[2] ? membus_data_stgd[23:16] : mem_buffer_data[119:112];
                                 mem_buffer_data[111:104] <= membus_data_wr_mask_stgd[1] ? membus_data_stgd[15:8]  : mem_buffer_data[111:104];
                                 mem_buffer_data[103:96]  <= membus_data_wr_mask_stgd[0] ? membus_data_stgd[7:0]   : mem_buffer_data[103:96] ;
                                 end
                        endcase
                        end
                      case(membus_addr_stgd[3:2])
                        2'b00: begin
                               o_membus_data[31:24] <= membus_data_rd_mask_stgd[3] ? mem_buffer_data[31:24]   : '0;   
                               o_membus_data[23:16] <= membus_data_rd_mask_stgd[2] ? mem_buffer_data[23:16]   : '0;   
                               o_membus_data[15:8]  <= membus_data_rd_mask_stgd[1] ? mem_buffer_data[15:8]    : '0;   
                               o_membus_data[7:0]   <= membus_data_rd_mask_stgd[0] ? mem_buffer_data[7:0]     : '0;   
                               end
                        2'b01: begin
                               o_membus_data[31:24] <= membus_data_rd_mask_stgd[3] ? mem_buffer_data[63:56]   : '0;   
                               o_membus_data[23:16] <= membus_data_rd_mask_stgd[2] ? mem_buffer_data[55:48]   : '0;   
                               o_membus_data[15:8]  <= membus_data_rd_mask_stgd[1] ? mem_buffer_data[47:40]   : '0;   
                               o_membus_data[7:0]   <= membus_data_rd_mask_stgd[0] ? mem_buffer_data[39:32]   : '0;   
                               end
                        2'b10: begin
                               o_membus_data[31:24] <= membus_data_rd_mask_stgd[3] ? mem_buffer_data[95:88]   : '0;   
                               o_membus_data[23:16] <= membus_data_rd_mask_stgd[2] ? mem_buffer_data[87:80]   : '0;   
                               o_membus_data[15:8]  <= membus_data_rd_mask_stgd[1] ? mem_buffer_data[79:72]   : '0;   
                               o_membus_data[7:0]   <= membus_data_rd_mask_stgd[0] ? mem_buffer_data[71:64]   : '0;   
                               end
                        2'b11: begin
                               o_membus_data[31:24] <= membus_data_rd_mask_stgd[3] ? mem_buffer_data[127:120] : '0;   
                               o_membus_data[23:16] <= membus_data_rd_mask_stgd[2] ? mem_buffer_data[119:112] : '0;   
                               o_membus_data[15:8]  <= membus_data_rd_mask_stgd[1] ? mem_buffer_data[111:104] : '0;   
                               o_membus_data[7:0]   <= membus_data_rd_mask_stgd[0] ? mem_buffer_data[103:96]  : '0;   
                               end
                      endcase
                      end
                  state_fifo_load <= '1;
                  end
      state_fifo_load: begin             
                       state_idle <= '1;
                       end
      endcase
 
    if(rst) 
      begin
      instbus_req_stgd  <= '0;
      instbus_addr_stgd <= '0;

      membus_req_stgd          <= '0;
      membus_write_stgd        <= '0;
      membus_addr_stgd         <= '0;
      membus_data_stgd         <= '0;
      membus_data_rd_mask_stgd <= '0;
      membus_data_wr_mask_stgd <= '0;

      arb_inst            <= '0;
      arb_mem             <= '1;
      
      state_inst          <= '0;
      state_mem           <= '1;
      state_idle          <= '1;
      state_flush         <= '0;
      state_load          <= '0;
      state_load_pending  <= '0;
      state_update        <= '0;

      flush_cnt <= '0;

      inst_buffer_vld  <= '0;
      inst_buffer_addr <= '0;
      inst_buffer_data <= '0;

      mem_buffer_vld  <= '0;
      mem_buffer_addr <= '0;
      mem_buffer_data <= '0;

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
