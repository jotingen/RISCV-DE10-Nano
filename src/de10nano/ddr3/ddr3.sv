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
logic         state_load_0;
logic         state_load_1;

logic [3:0]   flush_cnt;

logic         inst_buffer_vld;
logic [25:4]  inst_buffer_addr;
logic [127:0] inst_buffer_data;

logic [15:0]        mem_buffer_vld;
logic [15:0][25:4]  mem_buffer_addr;
logic [15:0][127:0] mem_buffer_data;
logic               mem_buffer_in_lru;
logic               mem_buffer_lru_touch;
logic [3:0]         mem_buffer_lru;
logic [3:0]         mem_buffer_lru_entry_next;
logic [3:0]         mem_buffer_lru_entry;

logic         mem_buffer_0_vld;
logic [25:4]  mem_buffer_0_addr;
logic [127:0] mem_buffer_0_data;

logic         mem_buffer_1_vld;
logic [25:4]  mem_buffer_1_addr;
logic [127:0] mem_buffer_1_data;

logic         mem_buffer_2_vld;
logic [25:4]  mem_buffer_2_addr;
logic [127:0] mem_buffer_2_data;

logic         mem_buffer_3_vld;
logic [25:4]  mem_buffer_3_addr;
logic [127:0] mem_buffer_3_data;

logic         mem_buffer_4_vld;
logic [25:4]  mem_buffer_4_addr;
logic [127:0] mem_buffer_4_data;

logic         mem_buffer_5_vld;
logic [25:4]  mem_buffer_5_addr;
logic [127:0] mem_buffer_5_data;

logic         mem_buffer_6_vld;
logic [25:4]  mem_buffer_6_addr;
logic [127:0] mem_buffer_6_data;

logic         mem_buffer_7_vld;
logic [25:4]  mem_buffer_7_addr;
logic [127:0] mem_buffer_7_data;

logic         mem_buffer_8_vld;
logic [25:4]  mem_buffer_8_addr;
logic [127:0] mem_buffer_8_data;

logic         mem_buffer_9_vld;
logic [25:4]  mem_buffer_9_addr;
logic [127:0] mem_buffer_9_data;

logic         mem_buffer_10_vld;
logic [25:4]  mem_buffer_10_addr;
logic [127:0] mem_buffer_10_data;

logic         mem_buffer_11_vld;
logic [25:4]  mem_buffer_11_addr;
logic [127:0] mem_buffer_11_data;

logic         mem_buffer_12_vld;
logic [25:4]  mem_buffer_12_addr;
logic [127:0] mem_buffer_12_data;

logic         mem_buffer_13_vld;
logic [25:4]  mem_buffer_13_addr;
logic [127:0] mem_buffer_13_data;

logic         mem_buffer_14_vld;
logic [25:4]  mem_buffer_14_addr;
logic [127:0] mem_buffer_14_data;

logic         mem_buffer_15_vld;
logic [25:4]  mem_buffer_15_addr;
logic [127:0] mem_buffer_15_data;

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

assign mem_buffer_0_vld       = mem_buffer_vld[0];      
assign mem_buffer_0_addr      = mem_buffer_addr[0];     
assign mem_buffer_0_data      = mem_buffer_data[0];       

assign mem_buffer_1_vld       = mem_buffer_vld[1];     
assign mem_buffer_1_addr      = mem_buffer_addr[1];    
assign mem_buffer_1_data      = mem_buffer_data[1];      

assign mem_buffer_2_vld       = mem_buffer_vld[2];     
assign mem_buffer_2_addr      = mem_buffer_addr[2];    
assign mem_buffer_2_data      = mem_buffer_data[2];      

assign mem_buffer_3_vld       = mem_buffer_vld[3];     
assign mem_buffer_3_addr      = mem_buffer_addr[3];    
assign mem_buffer_3_data      = mem_buffer_data[3];      

assign mem_buffer_4_vld       = mem_buffer_vld[4];     
assign mem_buffer_4_addr      = mem_buffer_addr[4];    
assign mem_buffer_4_data      = mem_buffer_data[4];      

assign mem_buffer_5_vld       = mem_buffer_vld[5];     
assign mem_buffer_5_addr      = mem_buffer_addr[5];    
assign mem_buffer_5_data      = mem_buffer_data[5];      

assign mem_buffer_6_vld       = mem_buffer_vld[6];     
assign mem_buffer_6_addr      = mem_buffer_addr[6];    
assign mem_buffer_6_data      = mem_buffer_data[6];      

assign mem_buffer_7_vld       = mem_buffer_vld[7];     
assign mem_buffer_7_addr      = mem_buffer_addr[7];    
assign mem_buffer_7_data      = mem_buffer_data[7];      

assign mem_buffer_8_vld       = mem_buffer_vld[8];     
assign mem_buffer_8_addr      = mem_buffer_addr[8];    
assign mem_buffer_8_data      = mem_buffer_data[8];      

assign mem_buffer_9_vld       = mem_buffer_vld[9];     
assign mem_buffer_9_addr      = mem_buffer_addr[9];    
assign mem_buffer_9_data      = mem_buffer_data[9];      

assign mem_buffer_10_vld      = mem_buffer_vld[10];     
assign mem_buffer_10_addr     = mem_buffer_addr[10];    
assign mem_buffer_10_data     = mem_buffer_data[10];      

assign mem_buffer_11_vld      = mem_buffer_vld[11];     
assign mem_buffer_11_addr     = mem_buffer_addr[11];    
assign mem_buffer_11_data     = mem_buffer_data[11];      

assign mem_buffer_12_vld      = mem_buffer_vld[12];     
assign mem_buffer_12_addr     = mem_buffer_addr[12];    
assign mem_buffer_12_data     = mem_buffer_data[12];      

assign mem_buffer_13_vld      = mem_buffer_vld[13];     
assign mem_buffer_13_addr     = mem_buffer_addr[13];    
assign mem_buffer_13_data     = mem_buffer_data[13];      

assign mem_buffer_14_vld      = mem_buffer_vld[14];     
assign mem_buffer_14_addr     = mem_buffer_addr[14];    
assign mem_buffer_14_data     = mem_buffer_data[14];      

assign mem_buffer_15_vld      = mem_buffer_vld[15];     
assign mem_buffer_15_addr     = mem_buffer_addr[15];    
assign mem_buffer_15_data     = mem_buffer_data[15];      

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

lru_16 mem_lru (
  .clk,
  .rst,
  
  .lru_touch   (mem_buffer_lru_touch),
  .lru_touched (mem_buffer_lru_entry),

  
  .lru         (mem_buffer_lru)
  );
always_comb
  begin
  mem_buffer_in_lru         = '0;
  mem_buffer_lru_entry_next = '0;
  for(int i = 0; i < 16; i++)
    begin
    if(mem_buffer_vld[i] &&
       mem_buffer_addr[i][25:4] == membus_addr_stgd[25:4])
      begin
      mem_buffer_in_lru         = '1;
      mem_buffer_lru_entry_next =  i;
      end
    end
  end

always_ff @(posedge clk)
  begin
  arb_inst            <= arb_inst;
  arb_mem             <= arb_mem; 
      
  state_idle          <= '0;
  state_flush         <= '0;
  state_load          <= '0;
  state_load_pending  <= '0;
  state_update        <= '0;
  state_load_0        <= '0;
  state_load_1        <= '0;

  flush_cnt           <= flush_cnt;

  inst_buffer_vld     <= inst_buffer_vld; 
  inst_buffer_addr    <= inst_buffer_addr;
  inst_buffer_data    <= inst_buffer_data;
  mem_buffer_vld      <= mem_buffer_vld; 
  mem_buffer_addr     <= mem_buffer_addr;
  mem_buffer_data     <= mem_buffer_data;
  mem_buffer_lru_entry<= mem_buffer_lru_entry;
  mem_buffer_lru_touch  <= '0;

  bus_inst_ack_o      <= '0;
  bus_inst_err_o      <= '0;
  bus_inst_rty_o      <= '0;
  bus_inst_data_o     <= '0;
  bus_inst_tga_o      <= '0;
  bus_inst_tgd_o      <= '0;
  bus_inst_tgc_o      <= '0;

  bus_inst_rd_ack     <= '0;

  o_membus_ack        <= '0;    
  o_membus_data       <= membus_data_stgd;   

  ddr3_fifo_out_wrreq <= '0;
  ddr3_fifo_out_rdreq <= '0;
  ddr3_fifo_out_data  <= ddr3_fifo_out_data;
  ddr3_fifo_out_addr  <= ddr3_fifo_out_addr;
  ddr3_fifo_in_rdack  <= '0;

  if(i_membus_req)
    begin
    membus_req_stgd          <= i_membus_req;
    membus_write_stgd        <= i_membus_write;
    membus_addr_stgd         <= i_membus_addr;
    membus_data_stgd         <= i_membus_data;
    membus_data_rd_mask_stgd <= i_membus_data_rd_mask;
    membus_data_wr_mask_stgd <= i_membus_data_wr_mask;
    end


  casex (1'b1)
    state_idle: begin
                if((arb_mem  & membus_req_stgd) |
                   (arb_inst & membus_req_stgd & ~bus_inst_req_stgd))
                  begin
                  arb_inst <= '1;
                  arb_mem  <= '0;
                  state_inst <= '0;
                  state_mem  <= '1;
                  if(mem_buffer_in_lru)
                    begin
                    state_update <= '1;
                    mem_buffer_lru_touch <= '1;
                    mem_buffer_lru_entry<= mem_buffer_lru_entry_next;
                    end
                  //else
                  //  begin
                  //  state_flush <= '1;
                  //  end
                  //if(mem_buffer_vld)
                  //  begin
                  //  if(mem_buffer_addr[25:4] == membus_addr_stgd[25:4])
                  //    begin
                  //    state_update <= '1;
                  //    end
                  //  else
                  //    begin
                  //    state_flush <= '1;
                  //    end
                  //  end
                  else
                    begin
                    state_load <= '1;
                    mem_buffer_lru_touch <= '1;
                    mem_buffer_lru_entry<= mem_buffer_lru;
                    for(int i = 0; i < 16; i++)
                      begin
                      if(~mem_buffer_vld[i])
                        begin
                        mem_buffer_lru_entry <= i;
                        break;
                        end
                      end
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
                     ddr3_fifo_out_data  <= mem_buffer_data[mem_buffer_lru_entry];
                     ddr3_fifo_out_addr  <= {mem_buffer_addr[mem_buffer_lru_entry][25:4],4'b0000};
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
                    inst_buffer_addr    <= bus_inst_adr_stgd[25:4];
                    end
                  if(state_mem)
                    begin
                    ddr3_fifo_out_addr  <= {membus_addr_stgd[25:4],4'b0000};
                    mem_buffer_vld[mem_buffer_lru_entry]  <= '0;
                    mem_buffer_addr[mem_buffer_lru_entry]     <= membus_addr_stgd[25:4];
                    end
                  state_load_pending    <= '1;
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
                              mem_buffer_vld[mem_buffer_lru_entry]  <= '1;
                              mem_buffer_data[mem_buffer_lru_entry] <= ddr3_fifo_in_q[127:0];
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
		      bus_inst_rd_ack <= '1;
                      bus_inst_ack_o  <= '1;
                      case(bus_inst_adr_stgd[3:2])
                        2'b00: begin
                               bus_inst_data_o[31:24] <= inst_buffer_data[31:24]  ;   
                               bus_inst_data_o[23:16] <= inst_buffer_data[23:16]  ;   
                               bus_inst_data_o[15:8]  <= inst_buffer_data[15:8]   ;   
                               bus_inst_data_o[7:0]   <= inst_buffer_data[7:0]    ;   
                               end
                        2'b01: begin
                               bus_inst_data_o[31:24] <= inst_buffer_data[63:56]  ;   
                               bus_inst_data_o[23:16] <= inst_buffer_data[55:48]  ;   
                               bus_inst_data_o[15:8]  <= inst_buffer_data[47:40]  ;   
                               bus_inst_data_o[7:0]   <= inst_buffer_data[39:32]  ;   
                               end
                        2'b10: begin
                               bus_inst_data_o[31:24] <= inst_buffer_data[95:88]  ;   
                               bus_inst_data_o[23:16] <= inst_buffer_data[87:80]  ;   
                               bus_inst_data_o[15:8]  <= inst_buffer_data[79:72]  ;   
                               bus_inst_data_o[7:0]   <= inst_buffer_data[71:64]  ;   
                               end
                        2'b11: begin
                               bus_inst_data_o[31:24] <= inst_buffer_data[127:120];   
                               bus_inst_data_o[23:16] <= inst_buffer_data[119:112];   
                               bus_inst_data_o[15:8]  <= inst_buffer_data[111:104];   
                               bus_inst_data_o[7:0]   <= inst_buffer_data[103:96] ;   
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
                                 mem_buffer_data[mem_buffer_lru_entry][31:24]   <= membus_data_wr_mask_stgd[3] ? membus_data_stgd[31:24] : mem_buffer_data[mem_buffer_lru_entry][31:24]  ;
                                 mem_buffer_data[mem_buffer_lru_entry][23:16]   <= membus_data_wr_mask_stgd[2] ? membus_data_stgd[23:16] : mem_buffer_data[mem_buffer_lru_entry][23:16]  ;
                                 mem_buffer_data[mem_buffer_lru_entry][15:8]    <= membus_data_wr_mask_stgd[1] ? membus_data_stgd[15:8]  : mem_buffer_data[mem_buffer_lru_entry][15:8]   ;
                                 mem_buffer_data[mem_buffer_lru_entry][7:0]     <= membus_data_wr_mask_stgd[0] ? membus_data_stgd[7:0]   : mem_buffer_data[mem_buffer_lru_entry][7:0]    ;
                                 end
                          2'b01: begin
                                 mem_buffer_data[mem_buffer_lru_entry][63:56]   <= membus_data_wr_mask_stgd[3] ? membus_data_stgd[31:24] : mem_buffer_data[mem_buffer_lru_entry][63:56];
                                 mem_buffer_data[mem_buffer_lru_entry][55:48]   <= membus_data_wr_mask_stgd[2] ? membus_data_stgd[23:16] : mem_buffer_data[mem_buffer_lru_entry][55:48];
                                 mem_buffer_data[mem_buffer_lru_entry][47:40]   <= membus_data_wr_mask_stgd[1] ? membus_data_stgd[15:8]  : mem_buffer_data[mem_buffer_lru_entry][47:40];
                                 mem_buffer_data[mem_buffer_lru_entry][39:32]   <= membus_data_wr_mask_stgd[0] ? membus_data_stgd[7:0]   : mem_buffer_data[mem_buffer_lru_entry][39:32];
                                 end
                          2'b10: begin
                                 mem_buffer_data[mem_buffer_lru_entry][95:88]   <= membus_data_wr_mask_stgd[3] ? membus_data_stgd[31:24] : mem_buffer_data[mem_buffer_lru_entry][95:88];
                                 mem_buffer_data[mem_buffer_lru_entry][87:80]   <= membus_data_wr_mask_stgd[2] ? membus_data_stgd[23:16] : mem_buffer_data[mem_buffer_lru_entry][87:80];
                                 mem_buffer_data[mem_buffer_lru_entry][79:72]   <= membus_data_wr_mask_stgd[1] ? membus_data_stgd[15:8]  : mem_buffer_data[mem_buffer_lru_entry][79:72];
                                 mem_buffer_data[mem_buffer_lru_entry][71:64]   <= membus_data_wr_mask_stgd[0] ? membus_data_stgd[7:0]   : mem_buffer_data[mem_buffer_lru_entry][71:64];
                                 end
                          2'b11: begin
                                 mem_buffer_data[mem_buffer_lru_entry][127:120] <= membus_data_wr_mask_stgd[3] ? membus_data_stgd[31:24] : mem_buffer_data[mem_buffer_lru_entry][127:120];
                                 mem_buffer_data[mem_buffer_lru_entry][119:112] <= membus_data_wr_mask_stgd[2] ? membus_data_stgd[23:16] : mem_buffer_data[mem_buffer_lru_entry][119:112];
                                 mem_buffer_data[mem_buffer_lru_entry][111:104] <= membus_data_wr_mask_stgd[1] ? membus_data_stgd[15:8]  : mem_buffer_data[mem_buffer_lru_entry][111:104];
                                 mem_buffer_data[mem_buffer_lru_entry][103:96]  <= membus_data_wr_mask_stgd[0] ? membus_data_stgd[7:0]   : mem_buffer_data[mem_buffer_lru_entry][103:96] ;
                                 end
                        endcase
                        end
                      case(membus_addr_stgd[3:2])
                        2'b00: begin
                               o_membus_data[31:24] <= membus_data_rd_mask_stgd[3] ? mem_buffer_data[mem_buffer_lru_entry][31:24]   : '0;   
                               o_membus_data[23:16] <= membus_data_rd_mask_stgd[2] ? mem_buffer_data[mem_buffer_lru_entry][23:16]   : '0;   
                               o_membus_data[15:8]  <= membus_data_rd_mask_stgd[1] ? mem_buffer_data[mem_buffer_lru_entry][15:8]    : '0;   
                               o_membus_data[7:0]   <= membus_data_rd_mask_stgd[0] ? mem_buffer_data[mem_buffer_lru_entry][7:0]     : '0;   
                               end
                        2'b01: begin
                               o_membus_data[31:24] <= membus_data_rd_mask_stgd[3] ? mem_buffer_data[mem_buffer_lru_entry][63:56]   : '0;   
                               o_membus_data[23:16] <= membus_data_rd_mask_stgd[2] ? mem_buffer_data[mem_buffer_lru_entry][55:48]   : '0;   
                               o_membus_data[15:8]  <= membus_data_rd_mask_stgd[1] ? mem_buffer_data[mem_buffer_lru_entry][47:40]   : '0;   
                               o_membus_data[7:0]   <= membus_data_rd_mask_stgd[0] ? mem_buffer_data[mem_buffer_lru_entry][39:32]   : '0;   
                               end
                        2'b10: begin
                               o_membus_data[31:24] <= membus_data_rd_mask_stgd[3] ? mem_buffer_data[mem_buffer_lru_entry][95:88]   : '0;   
                               o_membus_data[23:16] <= membus_data_rd_mask_stgd[2] ? mem_buffer_data[mem_buffer_lru_entry][87:80]   : '0;   
                               o_membus_data[15:8]  <= membus_data_rd_mask_stgd[1] ? mem_buffer_data[mem_buffer_lru_entry][79:72]   : '0;   
                               o_membus_data[7:0]   <= membus_data_rd_mask_stgd[0] ? mem_buffer_data[mem_buffer_lru_entry][71:64]   : '0;   
                               end
                        2'b11: begin
                               o_membus_data[31:24] <= membus_data_rd_mask_stgd[3] ? mem_buffer_data[mem_buffer_lru_entry][127:120] : '0;   
                               o_membus_data[23:16] <= membus_data_rd_mask_stgd[2] ? mem_buffer_data[mem_buffer_lru_entry][119:112] : '0;   
                               o_membus_data[15:8]  <= membus_data_rd_mask_stgd[1] ? mem_buffer_data[mem_buffer_lru_entry][111:104] : '0;   
                               o_membus_data[7:0]   <= membus_data_rd_mask_stgd[0] ? mem_buffer_data[mem_buffer_lru_entry][103:96]  : '0;   
                               end
                      endcase
                      end
                  state_load_0 <= '1;
                  end
      state_load_0: begin             
                    state_load_1 <= '1;
                    end
      state_load_1: begin             
                    state_idle <= '1;
                    end
      endcase
 
    if(rst) 
      begin
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

  casex(1'b1)
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
