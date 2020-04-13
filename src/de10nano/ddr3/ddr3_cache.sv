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

logic         bus_buff_almost_empty;
logic         bus_buff_empty;

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

assign bus_req_stgd = ~bus_buff_empty; 
wishbone_buff	bus_buff (
	.clock        ( clk ),
	.data         ( {bus_adr_i,
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
	.q            ( {bus_adr_stgd,
                   bus_data_stgd,
                   bus_we_stgd,
                   bus_sel_stgd,
                   bus_tga_stgd,
                   bus_tgd_stgd,
                   bus_tgc_stgd} ),
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
    if(!bus_buff_empty &&
       mem_buffer_vld[i] &&
       mem_buffer_addr[i][25:4] == bus_adr_stgd[25:4])
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

  mem_buffer_vld      <= mem_buffer_vld; 
  mem_buffer_addr     <= mem_buffer_addr;
  mem_buffer_data     <= mem_buffer_data;
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
                    state_update <= '1;
                    mem_buffer_lru_touch <= '1;
                    mem_buffer_lru_entry<= mem_buffer_lru_entry_next;
                    end
                  else
                    begin
                    logic [3:0] lru_entry;
                    mem_buffer_lru_touch <= '1;
                    lru_entry = mem_buffer_lru;
                    for(int i = 0; i < 16; i++)
                      begin
                      if(~mem_buffer_vld[i])
                        begin
                        lru_entry = i;
                        break;
                        end
                      end
                    mem_buffer_lru_entry <= lru_entry;
                    if(mem_buffer_vld[lru_entry])
                      begin
                      dst_adr_i  <= {6'd0,mem_buffer_addr[lru_entry],4'd0};
                      dst_data_i <= mem_buffer_data[lru_entry];
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
                   dst_adr_i  <= {6'd0,mem_buffer_addr[mem_buffer_lru_entry],4'd0};
                   dst_data_i <= mem_buffer_data[mem_buffer_lru_entry];
                   dst_we_i   <= '1;
                   dst_sel_i  <= '0;
                   dst_stb_i  <= '1;
                   dst_cyc_i  <= '1;
                   dst_tga_i  <= '0;
                   dst_tgd_i  <= '0;
                   dst_tgc_i  <= '0;

                   mem_buffer_vld[mem_buffer_lru_entry] <= '0;

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

                  mem_buffer_vld[mem_buffer_lru_entry]  <= '0;
                  mem_buffer_addr[mem_buffer_lru_entry] <= bus_adr_stgd[25:4];

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
                            mem_buffer_vld[mem_buffer_lru_entry]  <= '1;
                            mem_buffer_data[mem_buffer_lru_entry] <= dst_data_o;
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
                        case(bus_adr_stgd[3:2])
                          2'b00: begin
                                 mem_buffer_data[mem_buffer_lru_entry][31:24]   <= bus_sel_stgd[3] ? bus_data_stgd[31:24] : mem_buffer_data[mem_buffer_lru_entry][31:24]  ;
                                 mem_buffer_data[mem_buffer_lru_entry][23:16]   <= bus_sel_stgd[2] ? bus_data_stgd[23:16] : mem_buffer_data[mem_buffer_lru_entry][23:16]  ;
                                 mem_buffer_data[mem_buffer_lru_entry][15:8]    <= bus_sel_stgd[1] ? bus_data_stgd[15:8]  : mem_buffer_data[mem_buffer_lru_entry][15:8]   ;
                                 mem_buffer_data[mem_buffer_lru_entry][7:0]     <= bus_sel_stgd[0] ? bus_data_stgd[7:0]   : mem_buffer_data[mem_buffer_lru_entry][7:0]    ;
                                 end
                          2'b01: begin
                                 mem_buffer_data[mem_buffer_lru_entry][63:56]   <= bus_sel_stgd[3] ? bus_data_stgd[31:24] : mem_buffer_data[mem_buffer_lru_entry][63:56];
                                 mem_buffer_data[mem_buffer_lru_entry][55:48]   <= bus_sel_stgd[2] ? bus_data_stgd[23:16] : mem_buffer_data[mem_buffer_lru_entry][55:48];
                                 mem_buffer_data[mem_buffer_lru_entry][47:40]   <= bus_sel_stgd[1] ? bus_data_stgd[15:8]  : mem_buffer_data[mem_buffer_lru_entry][47:40];
                                 mem_buffer_data[mem_buffer_lru_entry][39:32]   <= bus_sel_stgd[0] ? bus_data_stgd[7:0]   : mem_buffer_data[mem_buffer_lru_entry][39:32];
                                 end
                          2'b10: begin
                                 mem_buffer_data[mem_buffer_lru_entry][95:88]   <= bus_sel_stgd[3] ? bus_data_stgd[31:24] : mem_buffer_data[mem_buffer_lru_entry][95:88];
                                 mem_buffer_data[mem_buffer_lru_entry][87:80]   <= bus_sel_stgd[2] ? bus_data_stgd[23:16] : mem_buffer_data[mem_buffer_lru_entry][87:80];
                                 mem_buffer_data[mem_buffer_lru_entry][79:72]   <= bus_sel_stgd[1] ? bus_data_stgd[15:8]  : mem_buffer_data[mem_buffer_lru_entry][79:72];
                                 mem_buffer_data[mem_buffer_lru_entry][71:64]   <= bus_sel_stgd[0] ? bus_data_stgd[7:0]   : mem_buffer_data[mem_buffer_lru_entry][71:64];
                                 end
                          2'b11: begin
                                 mem_buffer_data[mem_buffer_lru_entry][127:120] <= bus_sel_stgd[3] ? bus_data_stgd[31:24] : mem_buffer_data[mem_buffer_lru_entry][127:120];
                                 mem_buffer_data[mem_buffer_lru_entry][119:112] <= bus_sel_stgd[2] ? bus_data_stgd[23:16] : mem_buffer_data[mem_buffer_lru_entry][119:112];
                                 mem_buffer_data[mem_buffer_lru_entry][111:104] <= bus_sel_stgd[1] ? bus_data_stgd[15:8]  : mem_buffer_data[mem_buffer_lru_entry][111:104];
                                 mem_buffer_data[mem_buffer_lru_entry][103:96]  <= bus_sel_stgd[0] ? bus_data_stgd[7:0]   : mem_buffer_data[mem_buffer_lru_entry][103:96] ;
                                 end
                        endcase
                        end
                      case(bus_adr_stgd[3:2])
                        2'b00: begin
                               bus_data_o[31:24] <= bus_sel_stgd[3] ? mem_buffer_data[mem_buffer_lru_entry][31:24]   : '0;   
                               bus_data_o[23:16] <= bus_sel_stgd[2] ? mem_buffer_data[mem_buffer_lru_entry][23:16]   : '0;   
                               bus_data_o[15:8]  <= bus_sel_stgd[1] ? mem_buffer_data[mem_buffer_lru_entry][15:8]    : '0;   
                               bus_data_o[7:0]   <= bus_sel_stgd[0] ? mem_buffer_data[mem_buffer_lru_entry][7:0]     : '0;   
                               end
                        2'b01: begin
                               bus_data_o[31:24] <= bus_sel_stgd[3] ? mem_buffer_data[mem_buffer_lru_entry][63:56]   : '0;   
                               bus_data_o[23:16] <= bus_sel_stgd[2] ? mem_buffer_data[mem_buffer_lru_entry][55:48]   : '0;   
                               bus_data_o[15:8]  <= bus_sel_stgd[1] ? mem_buffer_data[mem_buffer_lru_entry][47:40]   : '0;   
                               bus_data_o[7:0]   <= bus_sel_stgd[0] ? mem_buffer_data[mem_buffer_lru_entry][39:32]   : '0;   
                               end
                        2'b10: begin
                               bus_data_o[31:24] <= bus_sel_stgd[3] ? mem_buffer_data[mem_buffer_lru_entry][95:88]   : '0;   
                               bus_data_o[23:16] <= bus_sel_stgd[2] ? mem_buffer_data[mem_buffer_lru_entry][87:80]   : '0;   
                               bus_data_o[15:8]  <= bus_sel_stgd[1] ? mem_buffer_data[mem_buffer_lru_entry][79:72]   : '0;   
                               bus_data_o[7:0]   <= bus_sel_stgd[0] ? mem_buffer_data[mem_buffer_lru_entry][71:64]   : '0;   
                               end
                        2'b11: begin
                               bus_data_o[31:24] <= bus_sel_stgd[3] ? mem_buffer_data[mem_buffer_lru_entry][127:120] : '0;   
                               bus_data_o[23:16] <= bus_sel_stgd[2] ? mem_buffer_data[mem_buffer_lru_entry][119:112] : '0;   
                               bus_data_o[15:8]  <= bus_sel_stgd[1] ? mem_buffer_data[mem_buffer_lru_entry][111:104] : '0;   
                               bus_data_o[7:0]   <= bus_sel_stgd[0] ? mem_buffer_data[mem_buffer_lru_entry][103:96]  : '0;   
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

      mem_buffer_vld  <= '0;
      mem_buffer_addr <= '0;
      mem_buffer_data <= '0;
      end
  end

endmodule
