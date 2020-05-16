module ddr3_cache (
  input  logic           clk,
  input  logic           rst,

  input  logic [31:0]    bus_adr_i,
  input  logic [31:0]    bus_data_i,
  input  logic           bus_we_i,
  input  logic  [3:0]    bus_sel_i,
  input  logic           bus_stb_i,
  input  logic           bus_cyc_i,
  input  logic           bus_tga_i,
  input  logic           bus_tgd_i,
  input  logic  [3:0]    bus_tgc_i,

  output logic           bus_ack_o,
  output logic           bus_stall_o,
  output logic           bus_err_o,
  output logic           bus_rty_o,
  output logic [31:0]    bus_data_o,
  output logic           bus_tga_o,
  output logic           bus_tgd_o,
  output logic  [3:0]    bus_tgc_o,

  output logic [31:0]    dst_adr_i,
  output logic [127:0]   dst_data_i,
  output logic           dst_we_i,
  output logic  [3:0]    dst_sel_i,
  output logic           dst_stb_i,
  output logic           dst_cyc_i,
  output logic           dst_tga_i,
  output logic           dst_tgd_i,
  output logic  [3:0]    dst_tgc_i,

  input  logic           dst_ack_o,
  input  logic           dst_stall_o,
  input  logic           dst_err_o,
  input  logic           dst_rty_o,
  input  logic [127:0]   dst_data_o,
  input  logic           dst_tga_o,
  input  logic           dst_tgd_o,
  input  logic  [3:0]    dst_tgc_o
);

typedef struct packed {
  logic         Vld;
  logic [25:4]  Addr;
  logic         Dirty;
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

buffer_entry_t [31:0]        mem_buffer;
logic               mem_buffer_in_lru;
logic               mem_buffer_lru_touch;
logic [4:0]         mem_buffer_lru;
logic [4:0]         mem_buffer_lru_entry_next;
logic [4:0]         mem_buffer_lru_entry;

assign bus_req_stgd = ~bus_buff_empty; 
wishbone_buff	bus_buff (
	.clock        ( clk ),
	.data         ( {5'd0,
                   bus_adr_i,
                   bus_data_i,
                   bus_we_i,
                   bus_sel_i,
                   bus_tga_i,
                   bus_tgd_i,
                   bus_tgc_i} ),
	.rdreq        ( bus_rd_ack ),
	.sclr         ( rst ),
	.wrreq        ( bus_cyc_i & bus_stb_i & ~bus_stall_o ),
	.almost_empty ( bus_buff_almost_empty ),
	.almost_full  ( bus_stall_o ),
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

lru_32 mem_lru (
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
  for(int i = 0; i < 32; i++)
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

  mem_buffer          <= mem_buffer; 
  mem_buffer_lru_entry<= mem_buffer_lru_entry;
  mem_buffer_lru_touch  <= '0;

  bus_ack_o      <= '0;
  bus_err_o      <= '0;
  bus_rty_o      <= '0;
  bus_data_o     <= '0;
  bus_tga_o      <= '0;
  bus_tgd_o      <= '0;
  bus_tgc_o      <= '0;

  bus_rd_ack     <= '0;

  dst_adr_i  <= '0;
  dst_data_i <= '0;
  dst_we_i   <= '0;
  dst_sel_i  <= '0;
  dst_stb_i  <= '0;
  dst_cyc_i  <= '0;
  dst_tga_i  <= '0;
  dst_tgd_i  <= '0;
  dst_tgc_i  <= '0;

  casex (1'b1)
    state_idle: begin
                if((bus_req_stgd ))
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
                    logic [4:0] lru_entry;
                    mem_buffer_lru_touch <= '1;
                    lru_entry = mem_buffer_lru;
                    for(int i = 0; i < 32; i++)
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
                      dst_adr_i  <= {6'd0,mem_buffer[lru_entry].Addr[25:4],4'd0};
                      dst_data_i <= mem_buffer[lru_entry].Data;
                      dst_we_i   <= '1;
                      dst_sel_i  <= '0;
                      dst_stb_i  <= '1;
                      dst_cyc_i  <= '1;
                      dst_tga_i  <= '0;
                      dst_tgd_i  <= '0;
                      dst_tgc_i  <= '0;
                      state_flush <= '1;
                      end
                    else
                      begin
                      dst_adr_i  <= bus_adr_stgd;
                      dst_data_i <= '0;
                      dst_we_i   <= '0;
                      dst_sel_i  <= '0;
                      dst_stb_i  <= '1;
                      dst_cyc_i  <= '1;
                      dst_tga_i  <= '0;
                      dst_tgd_i  <= '0;
                      dst_tgc_i  <= '0;
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
                   dst_adr_i  <= {6'd0,mem_buffer[mem_buffer_lru_entry].Addr[25:4],4'd0};
                   dst_data_i <= mem_buffer[mem_buffer_lru_entry].Data;
                   dst_we_i   <= '1;
                   dst_sel_i  <= '0;
                   dst_stb_i  <= '1;
                   dst_cyc_i  <= '1;
                   dst_tga_i  <= '0;
                   dst_tgd_i  <= '0;
                   dst_tgc_i  <= '0;

                   mem_buffer[mem_buffer_lru_entry].Vld <= '0;

                   if(dst_stall_o)
                   begin
                     state_flush <= '1;
                   end
                   else
                   begin
                     dst_adr_i  <= bus_adr_stgd;
                     dst_data_i <= '0;
                     dst_we_i   <= '0;
                     dst_sel_i  <= '0;
                     dst_stb_i  <= '1;
                     dst_cyc_i  <= '1;
                     dst_tga_i  <= '0;
                     dst_tgd_i  <= '0;
                     dst_tgc_i  <= '0;
                     state_load <= '1;
                   end
                   end
      state_load: begin             
                  dst_adr_i  <= bus_adr_stgd;
                  dst_data_i <= '0;
                  dst_we_i   <= '0;
                  dst_sel_i  <= '0;
                  dst_stb_i  <= '1;
                  dst_cyc_i  <= '1;
                  dst_tga_i  <= '0;
                  dst_tgd_i  <= '0;
                  dst_tgc_i  <= '0;

                  mem_buffer[mem_buffer_lru_entry].Vld   <= '0;
                  mem_buffer[mem_buffer_lru_entry].Addr  <= bus_adr_stgd[25:4];
                  mem_buffer[mem_buffer_lru_entry].Dirty <= '0;

                   if(dst_stall_o)
                   begin
                     state_load <= '1;
                   end
                   else
                   begin
                     state_load_pending <= '1;
                     dst_stb_i  <= '0;
                     dst_cyc_i  <= '0;
                   end
                  end
      state_load_pending: begin             
                          if(dst_ack_o)
                            begin
                            mem_buffer[mem_buffer_lru_entry].Vld   <= '1;
                            mem_buffer[mem_buffer_lru_entry].Data  <= dst_data_o;
                            bus_rd_ack <= '1;
                            state_update <= '1;
                            end
                          else
                            begin
                            state_load_pending <= '1;
                            end
                          end
      state_update: begin             
                      bus_ack_o  <= '1;

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
                               bus_data_o[31:24] <= bus_sel_stgd[3] ? mem_buffer[mem_buffer_lru_entry].Data[0][31:24] : '0;   
                               bus_data_o[23:16] <= bus_sel_stgd[2] ? mem_buffer[mem_buffer_lru_entry].Data[0][23:16] : '0;   
                               bus_data_o[15:8]  <= bus_sel_stgd[1] ? mem_buffer[mem_buffer_lru_entry].Data[0][15:8]  : '0;   
                               bus_data_o[7:0]   <= bus_sel_stgd[0] ? mem_buffer[mem_buffer_lru_entry].Data[0][7:0]   : '0;   
                               end
                        2'b01: begin
                               bus_data_o[31:24] <= bus_sel_stgd[3] ? mem_buffer[mem_buffer_lru_entry].Data[1][31:24] : '0;   
                               bus_data_o[23:16] <= bus_sel_stgd[2] ? mem_buffer[mem_buffer_lru_entry].Data[1][23:16] : '0;   
                               bus_data_o[15:8]  <= bus_sel_stgd[1] ? mem_buffer[mem_buffer_lru_entry].Data[1][15:8]  : '0;   
                               bus_data_o[7:0]   <= bus_sel_stgd[0] ? mem_buffer[mem_buffer_lru_entry].Data[1][7:0]   : '0;   
                               end
                        2'b10: begin
                               bus_data_o[31:24] <= bus_sel_stgd[3] ? mem_buffer[mem_buffer_lru_entry].Data[2][31:24] : '0;   
                               bus_data_o[23:16] <= bus_sel_stgd[2] ? mem_buffer[mem_buffer_lru_entry].Data[2][23:16] : '0;   
                               bus_data_o[15:8]  <= bus_sel_stgd[1] ? mem_buffer[mem_buffer_lru_entry].Data[2][15:8]  : '0;   
                               bus_data_o[7:0]   <= bus_sel_stgd[0] ? mem_buffer[mem_buffer_lru_entry].Data[2][7:0]   : '0;   
                               end
                        2'b11: begin
                               bus_data_o[31:24] <= bus_sel_stgd[3] ? mem_buffer[mem_buffer_lru_entry].Data[3][31:24] : '0;   
                               bus_data_o[23:16] <= bus_sel_stgd[2] ? mem_buffer[mem_buffer_lru_entry].Data[3][23:16] : '0;   
                               bus_data_o[15:8]  <= bus_sel_stgd[1] ? mem_buffer[mem_buffer_lru_entry].Data[3][15:8]  : '0;   
                               bus_data_o[7:0]   <= bus_sel_stgd[0] ? mem_buffer[mem_buffer_lru_entry].Data[3][7:0]   : '0;   
                               end
                      endcase
                      bus_tga_o <= bus_tga_stgd;
                      bus_tgd_o <= bus_tgd_stgd;
                      bus_tgc_o <= bus_tgc_stgd;
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

      mem_buffer          <= '0;
      end
  end

endmodule
