module ddr3_cache_set #(
  parameter SETS=1, //Used to determine tag
  parameter WAYS=2
  ) (
  clk,
  rst,

  set_target,

  state_idle,
  state_flush,
  state_load,
  state_load_pending,
  state_update,
  state_flushall,

  bus_req_stgd,
  bus_i_stgd,
  dst_o,
  bus_buff_empty,
  flush_ndx,

  mem_buffer,
  mem_buffer_lru_entry,
  mem_buffer_lru,
  mem_buffer_in_lru,
  mem_buffer_lru_entry_next
);

localparam ADR_TAG_LSB = $clog2(SETS)+4;

typedef struct packed {
  logic             Vld;
  logic      [26:ADR_TAG_LSB] Addr;
  logic             Dirty;
  logic [3:0][31:0] Data;
} buffer_entry_t;

input  logic                     clk;
input  logic                     rst;

input  logic                     set_target;

input  logic                     state_idle;
input  logic                     state_flush;
input  logic                     state_load;
input  logic                     state_load_pending;
input  logic                     state_update;
input  logic                     state_flushall;

input  logic                     bus_req_stgd;
input  wishbone_pkg::bus_req_t   bus_i_stgd;
input  wishbone_pkg::dst_rsp_t   dst_o;
input  logic                     bus_buff_empty;
input  logic [$clog2(WAYS)-1:0]  flush_ndx;

output buffer_entry_t [WAYS-1:0] mem_buffer;
output logic [$clog2(WAYS)-1:0]  mem_buffer_lru_entry;
output logic [$clog2(WAYS)-1:0]  mem_buffer_lru;
output logic                     mem_buffer_in_lru;
output logic [$clog2(WAYS)-1:0]  mem_buffer_lru_entry_next;

logic                            mem_buffer_lru_touch;
logic [(WAYS*(WAYS-1) >> 1)-1:0] lru_reg;
logic [(WAYS*(WAYS-1) >> 1)-1:0] lru_update;
logic [WAYS-1:0]                 lru_access;
logic [WAYS-1:0]                 lru_post;


mor1kx_cache_lru #(.NUMWAYS(WAYS)) mem_lru (
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
    for(int i = 0; i < WAYS; i++)
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
  if(set_target &
     mem_buffer_lru_touch)
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

always_comb
  begin
  mem_buffer_in_lru         = '0;
  mem_buffer_lru_entry_next = '0;
  for(int i = 0; i < WAYS; i++)
    begin
    if(!bus_buff_empty &&
       mem_buffer[i].Vld &&
       mem_buffer[i].Addr[25:ADR_TAG_LSB] == bus_i_stgd.Adr[25:ADR_TAG_LSB])
      begin
      mem_buffer_in_lru         = '1;
      mem_buffer_lru_entry_next =  i;
      end
    end
  end

always_ff @(posedge clk)
begin
  mem_buffer            <= mem_buffer; 
  mem_buffer_lru_entry  <= mem_buffer_lru_entry;
  mem_buffer_lru_touch  <= '0;

  if(set_target)
  begin
    casex (1'b1)
      state_idle: begin
                  if((bus_req_stgd ))
                    begin
                    if(mem_buffer_in_lru)
                      begin
                      mem_buffer_lru_touch <= '1;
                      mem_buffer_lru_entry<= mem_buffer_lru_entry_next;
                      if(bus_i_stgd.We)
                        begin
                        mem_buffer[mem_buffer_lru_entry].Dirty <= '1;
                        end
                      end
                    else
                      begin
                      logic [WAYS-1:0] lru_entry;
                      mem_buffer_lru_touch <= '1;
                      lru_entry = mem_buffer_lru;
                      for(int i = 0; i < WAYS; i++)
                        begin
                        if(~mem_buffer[i].Vld)
                          begin
                          lru_entry = i;
                          break;
                          end
                        end
                      mem_buffer_lru_entry <= lru_entry;
                      end
                    end
                  end
        state_flush: begin             
                     mem_buffer[mem_buffer_lru_entry].Vld <= '0;
                     end
        state_load: begin             
                    mem_buffer[mem_buffer_lru_entry].Vld   <= '0;
                    mem_buffer[mem_buffer_lru_entry].Addr  <= bus_i_stgd.Adr[25:ADR_TAG_LSB];
                    mem_buffer[mem_buffer_lru_entry].Dirty <= '0;
                    end
        state_load_pending: begin             
                            if(dst_o.Ack)
                              begin
                              mem_buffer[mem_buffer_lru_entry].Vld   <= '1;
                              mem_buffer[mem_buffer_lru_entry].Data  <= dst_o.Data;
                              end
                            end
        state_update: begin             
                      if(bus_i_stgd.We)
                        begin
                        mem_buffer[mem_buffer_lru_entry].Dirty <= '1;
                        case(bus_i_stgd.Adr[3:2])
                          2'b00: begin
                                 mem_buffer[mem_buffer_lru_entry].Data[0][31:24] <= bus_i_stgd.Sel[3] ? bus_i_stgd.Data[31:24] : mem_buffer[mem_buffer_lru_entry].Data[0][31:24];
                                 mem_buffer[mem_buffer_lru_entry].Data[0][23:16] <= bus_i_stgd.Sel[2] ? bus_i_stgd.Data[23:16] : mem_buffer[mem_buffer_lru_entry].Data[0][23:16];
                                 mem_buffer[mem_buffer_lru_entry].Data[0][15:8]  <= bus_i_stgd.Sel[1] ? bus_i_stgd.Data[15:8]  : mem_buffer[mem_buffer_lru_entry].Data[0][15:8] ;
                                 mem_buffer[mem_buffer_lru_entry].Data[0][7:0]   <= bus_i_stgd.Sel[0] ? bus_i_stgd.Data[7:0]   : mem_buffer[mem_buffer_lru_entry].Data[0][7:0]  ;
                                 end
                          2'b01: begin
                                 mem_buffer[mem_buffer_lru_entry].Data[1][31:24] <= bus_i_stgd.Sel[3] ? bus_i_stgd.Data[31:24] : mem_buffer[mem_buffer_lru_entry].Data[1][31:24];
                                 mem_buffer[mem_buffer_lru_entry].Data[1][23:16] <= bus_i_stgd.Sel[2] ? bus_i_stgd.Data[23:16] : mem_buffer[mem_buffer_lru_entry].Data[1][23:16];
                                 mem_buffer[mem_buffer_lru_entry].Data[1][15:8]  <= bus_i_stgd.Sel[1] ? bus_i_stgd.Data[15:8]  : mem_buffer[mem_buffer_lru_entry].Data[1][15:8] ;
                                 mem_buffer[mem_buffer_lru_entry].Data[1][7:0]   <= bus_i_stgd.Sel[0] ? bus_i_stgd.Data[7:0]   : mem_buffer[mem_buffer_lru_entry].Data[1][7:0]  ;
                                 end
                          2'b10: begin
                                 mem_buffer[mem_buffer_lru_entry].Data[2][31:24] <= bus_i_stgd.Sel[3] ? bus_i_stgd.Data[31:24] : mem_buffer[mem_buffer_lru_entry].Data[2][31:24];
                                 mem_buffer[mem_buffer_lru_entry].Data[2][23:16] <= bus_i_stgd.Sel[2] ? bus_i_stgd.Data[23:16] : mem_buffer[mem_buffer_lru_entry].Data[2][23:16];
                                 mem_buffer[mem_buffer_lru_entry].Data[2][15:8]  <= bus_i_stgd.Sel[1] ? bus_i_stgd.Data[15:8]  : mem_buffer[mem_buffer_lru_entry].Data[2][15:8] ;
                                 mem_buffer[mem_buffer_lru_entry].Data[2][7:0]   <= bus_i_stgd.Sel[0] ? bus_i_stgd.Data[7:0]   : mem_buffer[mem_buffer_lru_entry].Data[2][7:0]  ;
                                 end
                          2'b11: begin
                                 mem_buffer[mem_buffer_lru_entry].Data[3][31:24] <= bus_i_stgd.Sel[3] ? bus_i_stgd.Data[31:24] : mem_buffer[mem_buffer_lru_entry].Data[3][31:24];
                                 mem_buffer[mem_buffer_lru_entry].Data[3][23:16] <= bus_i_stgd.Sel[2] ? bus_i_stgd.Data[23:16] : mem_buffer[mem_buffer_lru_entry].Data[3][23:16];
                                 mem_buffer[mem_buffer_lru_entry].Data[3][15:8]  <= bus_i_stgd.Sel[1] ? bus_i_stgd.Data[15:8]  : mem_buffer[mem_buffer_lru_entry].Data[3][15:8] ;
                                 mem_buffer[mem_buffer_lru_entry].Data[3][7:0]   <= bus_i_stgd.Sel[0] ? bus_i_stgd.Data[7:0]   : mem_buffer[mem_buffer_lru_entry].Data[3][7:0]  ;
                                 end
                        endcase
                        end
                      end
        state_flushall: begin             
                        mem_buffer[flush_ndx].Vld <= '0;
                        end
    endcase
  end
 
    if(rst) 
      begin
      for(int i = 0; i < WAYS; i++)
      begin
        mem_buffer[i]       <= '0;
      end
      end
  end

endmodule
