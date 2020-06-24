import wishbone_pkg::*;

module ddr3_cache #(
  parameter SETS=1,
  parameter WAYS=2
  ) (
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

typedef struct packed {
  logic             Vld;
  logic      [26:4] Addr;
  logic             Dirty;
  logic [3:0][31:0] Data;
} buffer_entry_t;
logic                            bus_buff_almost_empty;
logic                            bus_buff_empty;

logic  [4:0]                     bus_unused_stgd;
wishbone_pkg::bus_req_t          bus_i_stgd;

logic                            bus_rd_ack;

logic                            state_idle;
logic                            state_flush;
logic                            state_load;
logic                            state_load_pending;
logic                            state_update;
logic                            state_flushall;

logic [$clog2(WAYS)-1:0]         flush_ndx;

buffer_entry_t [WAYS-1:0]        mem_buffer;
logic                            mem_buffer_in_lru;
logic [$clog2(WAYS)-1:0]         mem_buffer_lru;
logic [$clog2(WAYS)-1:0]         mem_buffer_lru_entry_next;
logic [$clog2(WAYS)-1:0]         mem_buffer_lru_entry;

logic                            bu_req_stgd;

///////////////////////////////////////////////////////////////////////////////
// Incoming buffer
///////////////////////////////////////////////////////////////////////////////
assign bus_req_stgd = ~bus_buff_empty; 
wishbone_buff	bus_buff (
	.clock        ( clk ),
	.data         ( {5'd0,
                   bus_i} ),
	.rdreq        ( bus_rd_ack ),
	.sclr         ( rst ),
	.wrreq        ( bus_i.Cyc & bus_i.Stb & ~bus_o.Stall ),
	.almost_empty ( bus_buff_almost_empty ),
	.almost_full  ( bus_o.Stall ),
	.empty        ( bus_buff_empty ),
	.full         (  ),
	.q            ( {bus_unused_stgd,
                   bus_i_stgd} ),
	.usedw        (  )
	);

///////////////////////////////////////////////////////////////////////////////
// Sets
///////////////////////////////////////////////////////////////////////////////

generate
  genvar s;
  for(s = 0; s < SETS; s++)
  begin : gen_set
    ddr3_cache_set #(.WAYS(WAYS)) set (
      .clk                       (clk                      ),
      .rst                       (rst                      ),
                              
      .state_idle                (state_idle               ),
      .state_flush               (state_flush              ),
      .state_load                (state_load               ),
      .state_load_pending        (state_load_pending       ),
      .state_update              (state_update             ),
      .state_flushall            (state_flushall           ),
                              
      .bus_req_stgd              (bus_req_stgd             ),
      .bus_i_stgd                (bus_i_stgd               ),
      .dst_o                     (dst_o                    ),
      .bus_buff_empty            (bus_buff_empty           ),
      .flush_ndx                 (flush_ndx                ),
                              
      .mem_buffer                (mem_buffer               ),
      .mem_buffer_lru_entry      (mem_buffer_lru_entry     ),
      .mem_buffer_lru            (mem_buffer_lru           ),
      .mem_buffer_in_lru         (mem_buffer_in_lru        ),
      .mem_buffer_lru_entry_next (mem_buffer_lru_entry_next)
    );
  end
endgenerate

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
                    if(bus_i_stgd.We)
                      begin
                      end
                    state_update <= '1;
                    end
                  else
                    begin
                    logic [WAYS-1:0] lru_entry;
                    lru_entry = mem_buffer_lru;
                    for(int i = 0; i < WAYS; i++)
                      begin
                      if(~mem_buffer[i].Vld)
                        begin
                        lru_entry = i;
                        break;
                        end
                      end
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
                      dst_i.Adr  <= bus_i_stgd.Adr;
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

                   if(dst_o.Stall)
                   begin
                     state_flush <= '1;
                   end
                   else
                   begin
                     dst_i.Adr  <= bus_i_stgd.Adr;
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
                  dst_i.Adr  <= bus_i_stgd.Adr;
                  dst_i.Data <= '0;
                  dst_i.We   <= '0;
                  dst_i.Sel  <= '0;
                  dst_i.Stb  <= '1;
                  dst_i.Cyc  <= '1;
                  dst_i.Tga  <= '0;
                  dst_i.Tgd  <= '0;
                  dst_i.Tgc  <= '0;

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
                      case(bus_i_stgd.Adr[3:2])
                        2'b00: begin
                               bus_o.Data[31:24] <= bus_i_stgd.Sel[3] ? mem_buffer[mem_buffer_lru_entry].Data[0][31:24] : '0;   
                               bus_o.Data[23:16] <= bus_i_stgd.Sel[2] ? mem_buffer[mem_buffer_lru_entry].Data[0][23:16] : '0;   
                               bus_o.Data[15:8]  <= bus_i_stgd.Sel[1] ? mem_buffer[mem_buffer_lru_entry].Data[0][15:8]  : '0;   
                               bus_o.Data[7:0]   <= bus_i_stgd.Sel[0] ? mem_buffer[mem_buffer_lru_entry].Data[0][7:0]   : '0;   
                               end
                        2'b01: begin
                               bus_o.Data[31:24] <= bus_i_stgd.Sel[3] ? mem_buffer[mem_buffer_lru_entry].Data[1][31:24] : '0;   
                               bus_o.Data[23:16] <= bus_i_stgd.Sel[2] ? mem_buffer[mem_buffer_lru_entry].Data[1][23:16] : '0;   
                               bus_o.Data[15:8]  <= bus_i_stgd.Sel[1] ? mem_buffer[mem_buffer_lru_entry].Data[1][15:8]  : '0;   
                               bus_o.Data[7:0]   <= bus_i_stgd.Sel[0] ? mem_buffer[mem_buffer_lru_entry].Data[1][7:0]   : '0;   
                               end
                        2'b10: begin
                               bus_o.Data[31:24] <= bus_i_stgd.Sel[3] ? mem_buffer[mem_buffer_lru_entry].Data[2][31:24] : '0;   
                               bus_o.Data[23:16] <= bus_i_stgd.Sel[2] ? mem_buffer[mem_buffer_lru_entry].Data[2][23:16] : '0;   
                               bus_o.Data[15:8]  <= bus_i_stgd.Sel[1] ? mem_buffer[mem_buffer_lru_entry].Data[2][15:8]  : '0;   
                               bus_o.Data[7:0]   <= bus_i_stgd.Sel[0] ? mem_buffer[mem_buffer_lru_entry].Data[2][7:0]   : '0;   
                               end
                        2'b11: begin
                               bus_o.Data[31:24] <= bus_i_stgd.Sel[3] ? mem_buffer[mem_buffer_lru_entry].Data[3][31:24] : '0;   
                               bus_o.Data[23:16] <= bus_i_stgd.Sel[2] ? mem_buffer[mem_buffer_lru_entry].Data[3][23:16] : '0;   
                               bus_o.Data[15:8]  <= bus_i_stgd.Sel[1] ? mem_buffer[mem_buffer_lru_entry].Data[3][15:8]  : '0;   
                               bus_o.Data[7:0]   <= bus_i_stgd.Sel[0] ? mem_buffer[mem_buffer_lru_entry].Data[3][7:0]   : '0;   
                               end
                      endcase
                      bus_o.Tga <= bus_i_stgd.Tga;
                      bus_o.Tgd <= bus_i_stgd.Tgd;
                      bus_o.Tgc <= bus_i_stgd.Tgc;
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

      end
end

endmodule
