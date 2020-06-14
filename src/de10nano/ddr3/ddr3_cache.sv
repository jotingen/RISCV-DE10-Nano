import wishbone_pkg::*;

module ddr3_cache (
  input  logic           clk,
  input  logic           rst,

  input  logic           flushStart,
  output logic           flushDone,

  input  logic [$bits(wishbone_pkg::bus_req_t)-1:0] bus_i_flat,
  output logic [$bits(wishbone_pkg::bus_rsp_t)-1:0] bus_o_flat,
 
  output logic [$bits(wishbone_pkg::dst_req_t)-1:0] dst_i_flat,
  input  logic [$bits(wishbone_pkg::dst_rsp_t)-1:0] dst_o_flat
);
wishbone_pkg::bus_req_t bus_i;
wishbone_pkg::bus_rsp_t bus_o;
wishbone_pkg::dst_req_t dst_i;
wishbone_pkg::dst_rsp_t dst_o;
always_comb
begin
  bus_i      = bus_i_flat;
  bus_o_flat = bus_o;
  dst_i_flat = dst_i;
  dst_o      = dst_o_flat;
end

localparam BUFFERS = 4;

typedef struct packed {
  logic             Vld;
  logic      [25:4] Addr;
  logic             Dirty;
  logic [3:0][31:0] Data;
} buffer_entry_t;
logic         bus_buff_almost_empty;
logic         bus_buff_empty;

logic  [4:0]  bus_unused_stgd;
logic         bus_req_stgd;
logic [31:0]  bus_adr_stgd;
logic [31:0]  bus_data_stgd;
logic         bus_we_stgd;
logic  [3:0]  bus_sel_stgd;
logic         bus_tga_stgd;
logic         bus_tgd_stgd;
logic  [3:0]  bus_tgc_stgd;

logic         bus_rd_ack;

logic         state_idle;
logic         state_flush;
logic         state_load;
logic         state_load_pending;
logic         state_update;
logic         state_flushall;

logic [$clog2(BUFFERS)-1:0]  flush_ndx;

buffer_entry_t [BUFFERS-1:0]             mem_buffer   ;
logic                       mem_buffer_in_lru;
logic                       mem_buffer_lru_touch;
logic [$clog2(BUFFERS)-1:0] mem_buffer_lru;
logic [$clog2(BUFFERS)-1:0] mem_buffer_lru_entry_next;
logic [$clog2(BUFFERS)-1:0] mem_buffer_lru_entry;

assign bus_req_stgd = ~bus_buff_empty; 
wishbone_buff	bus_buff (
	.clock        ( clk ),
	.data         ( {5'd0,
                   bus_i.Adr,
                   bus_i.Data,
                   bus_i.We,
                   bus_i.Sel,
                   bus_i.Tga,
                   bus_i.Tgd,
                   bus_i.Tgc} ),
	.rdreq        ( bus_rd_ack ),
	.sclr         ( rst ),
	.wrreq        ( bus_i.Cyc & bus_i.Stb & ~bus_o.Stall ),
	.almost_empty ( bus_buff_almost_empty ),
	.almost_full  ( bus_o.Stall ),
	.empty        ( bus_buff_empty ),
	.full         (  ),
	.q            ( {bus_unused_stgd,
                   bus_adr_stgd,
                   bus_data_stgd,
                   bus_we_stgd,
                   bus_sel_stgd,
                   bus_tga_stgd,
                   bus_tgd_stgd,
                   bus_tgc_stgd} ),
	.usedw        (  )
	);

  logic [(BUFFERS*(BUFFERS-1) >> 1)-1:0] lru_reg;
  logic [(BUFFERS*(BUFFERS-1) >> 1)-1:0] lru_update;
  logic [BUFFERS-1:0] lru_access;
  logic [BUFFERS-1:0] lru_post;

mor1kx_cache_lru #(.NUMWAYS(BUFFERS)) mem_lru (
  .current  (lru_reg),
  .update   (lru_update),
  .access   (lru_access),
  .lru_pre  (),
  .lru_post (lru_post)
  );
always_comb
begin
  //Decode touched LRU
  lru_access = '0;
  lru_access[mem_buffer_lru_entry] = mem_buffer_lru_touch;

  //Encode current LRU
  mem_buffer_lru = '0;
    for(int i = 0; i < BUFFERS; i++)
    begin
      if(lru_post[i])
      begin
        mem_buffer_lru = i;
        break;
      end
    end

end


always_ff @(posedge clk)
begin
  if(mem_buffer_lru_touch)
  begin
    lru_reg <= lru_update;
  end
  else
  begin
    lru_reg <= lru_reg;
  end

  if(rst)
  begin
    lru_reg <= '0;
  end
end

//lru_32 mem_lru (
//  .clk,
//  .rst,
//  
//  .lru_touch   (mem_buffer_lru_touch),
//  .lru_touched (mem_buffer_lru_entry),
//
//  
//  .lru         (mem_buffer_lru)
//  );

always_comb
  begin
  mem_buffer_in_lru         = '0;
  mem_buffer_lru_entry_next = '0;
  for(int i = 0; i < BUFFERS; i++)
    begin
    if(!bus_buff_empty &&
       mem_buffer[i].Vld &&
       mem_buffer[i].Addr[25:4] == bus_adr_stgd[25:4])
      begin
      mem_buffer_in_lru         = '1;
      mem_buffer_lru_entry_next =  i;
      end
    end
  end

always_ff @(posedge clk)
begin
  state_idle          <= '0;
  state_flush         <= '0;
  state_load          <= '0;
  state_load_pending  <= '0;
  state_update        <= '0;
  state_flushall      <= '0;

  flush_ndx <= flush_ndx;
  flushDone <= '0;

  mem_buffer          <= mem_buffer; 
  mem_buffer_lru_entry<= mem_buffer_lru_entry;
  mem_buffer_lru_touch  <= '0;

  bus_o.Ack      <= '0;
  bus_o.Err      <= '0;
  bus_o.Rty      <= '0;
  bus_o.Data     <= '0;
  bus_o.Tga      <= '0;
  bus_o.Tgd      <= '0;
  bus_o.Tgc      <= '0;

  bus_rd_ack     <= '0;

  dst_i.Adr  <= '0;
  dst_i.Data <= '0;
  dst_i.We   <= '0;
  dst_i.Sel  <= '0;
  dst_i.Stb  <= '0;
  dst_i.Cyc  <= '0;
  dst_i.Tga  <= '0;
  dst_i.Tgd  <= '0;
  dst_i.Tgc  <= '0;

  casex (1'b1)
    state_idle: begin
                if(flushStart)
                begin
                  flush_ndx <= '0;
                  state_flushall <= '1;
                end
                else if((bus_req_stgd ))
                  begin
                  if(mem_buffer_in_lru)
                    begin
                    bus_rd_ack <= '1;
                    mem_buffer_lru_touch <= '1;
                    mem_buffer_lru_entry<= mem_buffer_lru_entry_next;
                    if(bus_we_stgd)
                      begin
                      mem_buffer[mem_buffer_lru_entry].Dirty <= '1;
                      end
                    state_update <= '1;
                    end
                  else
                    begin
                    logic [BUFFERS-1:0] lru_entry;
                    mem_buffer_lru_touch <= '1;
                    lru_entry = mem_buffer_lru;
                    for(int i = 0; i < BUFFERS; i++)
                      begin
                      if(~mem_buffer[i].Vld)
                        begin
                        lru_entry = i;
                        break;
                        end
                      end
                    mem_buffer_lru_entry <= lru_entry;
                    if(mem_buffer[lru_entry].Vld & mem_buffer[lru_entry].Dirty)
                      begin
                      dst_i.Adr  <= {6'd0,mem_buffer[lru_entry].Addr[25:4],4'd0};
                      dst_i.Data <= mem_buffer[lru_entry].Data;
                      dst_i.We   <= '1;
                      dst_i.Sel  <= '0;
                      dst_i.Stb  <= '1;
                      dst_i.Cyc  <= '1;
                      dst_i.Tga  <= '0;
                      dst_i.Tgd  <= '0;
                      dst_i.Tgc  <= '0;
                      state_flush <= '1;
                      end
                    else
                      begin
                      dst_i.Adr  <= bus_adr_stgd;
                      dst_i.Data <= '0;
                      dst_i.We   <= '0;
                      dst_i.Sel  <= '0;
                      dst_i.Stb  <= '1;
                      dst_i.Cyc  <= '1;
                      dst_i.Tga  <= '0;
                      dst_i.Tgd  <= '0;
                      dst_i.Tgc  <= '0;
                      state_load <= '1;
                      end
                    end
                  end
                else
                  begin
                  state_idle <= '1;
                  end
                end
      state_flush: begin             
                   dst_i.Adr  <= {6'd0,mem_buffer[mem_buffer_lru_entry].Addr[25:4],4'd0};
                   dst_i.Data <= mem_buffer[mem_buffer_lru_entry].Data;
                   dst_i.We   <= '1;
                   dst_i.Sel  <= '0;
                   dst_i.Stb  <= '1;
                   dst_i.Cyc  <= '1;
                   dst_i.Tga  <= '0;
                   dst_i.Tgd  <= '0;
                   dst_i.Tgc  <= '0;

                   mem_buffer[mem_buffer_lru_entry].Vld <= '0;

                   if(dst_o.Stall)
                   begin
                     state_flush <= '1;
                   end
                   else
                   begin
                     dst_i.Adr  <= bus_adr_stgd;
                     dst_i.Data <= '0;
                     dst_i.We   <= '0;
                     dst_i.Sel  <= '0;
                     dst_i.Stb  <= '1;
                     dst_i.Cyc  <= '1;
                     dst_i.Tga  <= '0;
                     dst_i.Tgd  <= '0;
                     dst_i.Tgc  <= '0;
                     state_load <= '1;
                   end
                   end
      state_load: begin             
                  dst_i.Adr  <= bus_adr_stgd;
                  dst_i.Data <= '0;
                  dst_i.We   <= '0;
                  dst_i.Sel  <= '0;
                  dst_i.Stb  <= '1;
                  dst_i.Cyc  <= '1;
                  dst_i.Tga  <= '0;
                  dst_i.Tgd  <= '0;
                  dst_i.Tgc  <= '0;

                  mem_buffer[mem_buffer_lru_entry].Vld   <= '0;
                  mem_buffer[mem_buffer_lru_entry].Addr  <= bus_adr_stgd[25:4];
                  mem_buffer[mem_buffer_lru_entry].Dirty <= '0;

                   if(dst_o.Stall)
                   begin
                     state_load <= '1;
                   end
                   else
                   begin
                     state_load_pending <= '1;
                     dst_i.Stb  <= '0;
                     dst_i.Cyc  <= '0;
                   end
                  end
      state_load_pending: begin             
                          if(dst_o.Ack)
                            begin
                            mem_buffer[mem_buffer_lru_entry].Vld   <= '1;
                            mem_buffer[mem_buffer_lru_entry].Data  <= dst_o.Data;
                            bus_rd_ack <= '1;
                            state_update <= '1;
                            end
                          else
                            begin
                            state_load_pending <= '1;
                            end
                          end
      state_update: begin             
                      bus_o.Ack  <= '1;

                      if(bus_we_stgd)
                        begin
                        mem_buffer[mem_buffer_lru_entry].Dirty <= '1;
                        case(bus_adr_stgd[3:2])
                          2'b00: begin
                                 mem_buffer[mem_buffer_lru_entry].Data[0][31:24] <= bus_sel_stgd[3] ? bus_data_stgd[31:24] : mem_buffer[mem_buffer_lru_entry].Data[0][31:24];
                                 mem_buffer[mem_buffer_lru_entry].Data[0][23:16] <= bus_sel_stgd[2] ? bus_data_stgd[23:16] : mem_buffer[mem_buffer_lru_entry].Data[0][23:16];
                                 mem_buffer[mem_buffer_lru_entry].Data[0][15:8]  <= bus_sel_stgd[1] ? bus_data_stgd[15:8]  : mem_buffer[mem_buffer_lru_entry].Data[0][15:8] ;
                                 mem_buffer[mem_buffer_lru_entry].Data[0][7:0]   <= bus_sel_stgd[0] ? bus_data_stgd[7:0]   : mem_buffer[mem_buffer_lru_entry].Data[0][7:0]  ;
                                 end
                          2'b01: begin
                                 mem_buffer[mem_buffer_lru_entry].Data[1][31:24] <= bus_sel_stgd[3] ? bus_data_stgd[31:24] : mem_buffer[mem_buffer_lru_entry].Data[1][31:24];
                                 mem_buffer[mem_buffer_lru_entry].Data[1][23:16] <= bus_sel_stgd[2] ? bus_data_stgd[23:16] : mem_buffer[mem_buffer_lru_entry].Data[1][23:16];
                                 mem_buffer[mem_buffer_lru_entry].Data[1][15:8]  <= bus_sel_stgd[1] ? bus_data_stgd[15:8]  : mem_buffer[mem_buffer_lru_entry].Data[1][15:8] ;
                                 mem_buffer[mem_buffer_lru_entry].Data[1][7:0]   <= bus_sel_stgd[0] ? bus_data_stgd[7:0]   : mem_buffer[mem_buffer_lru_entry].Data[1][7:0]  ;
                                 end
                          2'b10: begin
                                 mem_buffer[mem_buffer_lru_entry].Data[2][31:24] <= bus_sel_stgd[3] ? bus_data_stgd[31:24] : mem_buffer[mem_buffer_lru_entry].Data[2][31:24];
                                 mem_buffer[mem_buffer_lru_entry].Data[2][23:16] <= bus_sel_stgd[2] ? bus_data_stgd[23:16] : mem_buffer[mem_buffer_lru_entry].Data[2][23:16];
                                 mem_buffer[mem_buffer_lru_entry].Data[2][15:8]  <= bus_sel_stgd[1] ? bus_data_stgd[15:8]  : mem_buffer[mem_buffer_lru_entry].Data[2][15:8] ;
                                 mem_buffer[mem_buffer_lru_entry].Data[2][7:0]   <= bus_sel_stgd[0] ? bus_data_stgd[7:0]   : mem_buffer[mem_buffer_lru_entry].Data[2][7:0]  ;
                                 end
                          2'b11: begin
                                 mem_buffer[mem_buffer_lru_entry].Data[3][31:24] <= bus_sel_stgd[3] ? bus_data_stgd[31:24] : mem_buffer[mem_buffer_lru_entry].Data[3][31:24];
                                 mem_buffer[mem_buffer_lru_entry].Data[3][23:16] <= bus_sel_stgd[2] ? bus_data_stgd[23:16] : mem_buffer[mem_buffer_lru_entry].Data[3][23:16];
                                 mem_buffer[mem_buffer_lru_entry].Data[3][15:8]  <= bus_sel_stgd[1] ? bus_data_stgd[15:8]  : mem_buffer[mem_buffer_lru_entry].Data[3][15:8] ;
                                 mem_buffer[mem_buffer_lru_entry].Data[3][7:0]   <= bus_sel_stgd[0] ? bus_data_stgd[7:0]   : mem_buffer[mem_buffer_lru_entry].Data[3][7:0]  ;
                                 end
                        endcase
                        end
                      case(bus_adr_stgd[3:2])
                        2'b00: begin
                               bus_o.Data[31:24] <= bus_sel_stgd[3] ? mem_buffer[mem_buffer_lru_entry].Data[0][31:24] : '0;   
                               bus_o.Data[23:16] <= bus_sel_stgd[2] ? mem_buffer[mem_buffer_lru_entry].Data[0][23:16] : '0;   
                               bus_o.Data[15:8]  <= bus_sel_stgd[1] ? mem_buffer[mem_buffer_lru_entry].Data[0][15:8]  : '0;   
                               bus_o.Data[7:0]   <= bus_sel_stgd[0] ? mem_buffer[mem_buffer_lru_entry].Data[0][7:0]   : '0;   
                               end
                        2'b01: begin
                               bus_o.Data[31:24] <= bus_sel_stgd[3] ? mem_buffer[mem_buffer_lru_entry].Data[1][31:24] : '0;   
                               bus_o.Data[23:16] <= bus_sel_stgd[2] ? mem_buffer[mem_buffer_lru_entry].Data[1][23:16] : '0;   
                               bus_o.Data[15:8]  <= bus_sel_stgd[1] ? mem_buffer[mem_buffer_lru_entry].Data[1][15:8]  : '0;   
                               bus_o.Data[7:0]   <= bus_sel_stgd[0] ? mem_buffer[mem_buffer_lru_entry].Data[1][7:0]   : '0;   
                               end
                        2'b10: begin
                               bus_o.Data[31:24] <= bus_sel_stgd[3] ? mem_buffer[mem_buffer_lru_entry].Data[2][31:24] : '0;   
                               bus_o.Data[23:16] <= bus_sel_stgd[2] ? mem_buffer[mem_buffer_lru_entry].Data[2][23:16] : '0;   
                               bus_o.Data[15:8]  <= bus_sel_stgd[1] ? mem_buffer[mem_buffer_lru_entry].Data[2][15:8]  : '0;   
                               bus_o.Data[7:0]   <= bus_sel_stgd[0] ? mem_buffer[mem_buffer_lru_entry].Data[2][7:0]   : '0;   
                               end
                        2'b11: begin
                               bus_o.Data[31:24] <= bus_sel_stgd[3] ? mem_buffer[mem_buffer_lru_entry].Data[3][31:24] : '0;   
                               bus_o.Data[23:16] <= bus_sel_stgd[2] ? mem_buffer[mem_buffer_lru_entry].Data[3][23:16] : '0;   
                               bus_o.Data[15:8]  <= bus_sel_stgd[1] ? mem_buffer[mem_buffer_lru_entry].Data[3][15:8]  : '0;   
                               bus_o.Data[7:0]   <= bus_sel_stgd[0] ? mem_buffer[mem_buffer_lru_entry].Data[3][7:0]   : '0;   
                               end
                      endcase
                      bus_o.Tga <= bus_tga_stgd;
                      bus_o.Tgd <= bus_tgd_stgd;
                      bus_o.Tgc <= bus_tgc_stgd;
                  state_idle <= '1;
                  end
      state_flushall: begin             
                        dst_i.Adr  <= {6'd0,mem_buffer[flush_ndx].Addr[25:4],4'd0};
                        dst_i.Data <= mem_buffer[flush_ndx].Data;
                        dst_i.We   <= '1;
                        dst_i.Sel  <= '0;
                        dst_i.Stb  <= '1;
                        dst_i.Cyc  <= '1;
                        dst_i.Tga  <= '0;
                        dst_i.Tgd  <= '0;
                        dst_i.Tgc  <= '0;

                        mem_buffer[flush_ndx].Vld <= '0;

                        if(flush_ndx == '1)
                        begin
                          flushDone <= '1;
                          state_idle <= '1;
                        end
                        else
                        begin
                          if(~dst_o.Stall)
                          begin
                            flush_ndx <= flush_ndx + 'd1;
                          end

                          state_flushall <= '1;
                        end
                      end
      endcase
 
    if(rst) 
      begin
      state_idle          <= '1;
      state_flush         <= '0;
      state_load          <= '0;
      state_load_pending  <= '0;
      state_update        <= '0;

      for(int i = 0; i < BUFFERS; i++)
      begin
        mem_buffer[i]       <= '0;
      end
      end
  end

endmodule
