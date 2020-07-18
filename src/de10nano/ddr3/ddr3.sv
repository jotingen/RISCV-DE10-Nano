import wishbone_pkg::*;

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

  input  logic [$bits(wishbone_pkg::bus_req_t)-1:0] bus_cntl_flat_i,
  output logic [$bits(wishbone_pkg::bus_rsp_t)-1:0] bus_cntl_flat_o,

  input  logic [$bits(wishbone_pkg::bus_req_t)-1:0] bus_inst_flat_i,
  output logic [$bits(wishbone_pkg::bus_rsp_t)-1:0] bus_inst_flat_o,

  input  logic [$bits(wishbone_pkg::bus_req_t)-1:0] bus_data_flat_i,
  output logic [$bits(wishbone_pkg::bus_rsp_t)-1:0] bus_data_flat_o
);

wishbone_pkg::bus_req_t bus_cntl_i;
wishbone_pkg::bus_rsp_t bus_cntl_o;
wishbone_pkg::bus_req_t bus_inst_i;
wishbone_pkg::bus_rsp_t bus_inst_o;
wishbone_pkg::bus_req_t bus_data_i;
wishbone_pkg::bus_rsp_t bus_data_o;
always_comb
begin
  bus_cntl_i      = bus_cntl_flat_i;
  bus_cntl_flat_o = bus_cntl_o;
  bus_inst_i      = bus_inst_flat_i;
  bus_inst_flat_o = bus_inst_o;
  bus_data_i      = bus_data_flat_i;
  bus_data_flat_o = bus_data_o;
end


logic         state_inst;
logic         state_mem;
logic         state_idle;
logic         state_req;
logic         state_rsp;

logic         flushStart;
logic         flushDone;

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

wishbone_pkg::dst_req_t dst_inst_i;
wishbone_pkg::dst_rsp_t dst_inst_o;

wishbone_pkg::dst_req_t dst_data_i;
wishbone_pkg::dst_rsp_t dst_data_o;

wishbone_pkg::dst_req_t dst_i;
wishbone_pkg::dst_rsp_t dst_o;

ddr3_cntl cntl (
  .clk                    (clk),                       
  .rst                    (rst),                       

  .flushStart             (flushStart),
  .flushDone              (flushDone),

  .bus_data_flat_i        (bus_cntl_i),
  .bus_data_flat_o        (bus_cntl_o)
);
     
ddr3_cache #(.SETS(8), .WAYS(4)) inst_cache (
  .clk                    (clk),                       
  .rst                    (rst),                       
                                                     
  .flushStart             ('0),
  .flushDone              (),

  .bus_i_flat             (bus_inst_i),                 
  .bus_o_flat             (bus_inst_o),                 

  .dst_i_flat             (dst_inst_i), 
  .dst_o_flat             (dst_inst_o)
);

  ddr3_cache #(.SETS(16), .WAYS(4)) mem_cache (
  .clk                    (clk),                       
  .rst                    (rst),                       
                                                     
  .flushStart             (flushStart),
  .flushDone              (flushDone),

  .bus_i_flat             (bus_data_i),                 
  .bus_o_flat             (bus_data_o),                 

  .dst_i_flat             (dst_data_i), 
  .dst_o_flat             (dst_data_o)
);


always_ff @(posedge clk)
begin
  state_inst <= state_inst;
  state_mem  <= state_mem;
  state_idle <= '0;
  state_req  <= '0;
  state_rsp  <= '0;

  dst_i  <= dst_i;

  dst_inst_o.Ack   <= '0;
  dst_inst_o.Stall <= '1;
  dst_inst_o.Err   <= '0;
  dst_inst_o.Rty   <= '0;
  dst_inst_o.Data  <= '0;
  dst_inst_o.Tga   <= '0;
  dst_inst_o.Tgd   <= '0;
  dst_inst_o.Tgc   <= '0;

  dst_data_o.Ack   <= '0;
  dst_data_o.Stall <= '1;
  dst_data_o.Err   <= '0;
  dst_data_o.Rty   <= '0;
  dst_data_o.Data  <= '0;
  dst_data_o.Tga   <= '0;
  dst_data_o.Tgd   <= '0;
  dst_data_o.Tgc   <= '0;

  ddr3_fifo_out_wrreq <= '0;
  ddr3_fifo_out_rdreq <= '0;
  ddr3_fifo_out_data  <= ddr3_fifo_out_data;
  ddr3_fifo_out_addr  <= ddr3_fifo_out_addr;
  ddr3_fifo_in_rdack  <= '0;
 
  casex (1'b1)
    state_idle: begin
                if(state_inst)
                  begin
                  if(dst_inst_i.Stb)
                    begin
                    dst_i.Adr  <= dst_inst_i.Adr;
                    dst_i.Data <= dst_inst_i.Data;
                    dst_i.We   <= dst_inst_i.We;
                    dst_i.Sel  <= dst_inst_i.Sel;
                    dst_i.Tga  <= dst_inst_i.Tga;
                    dst_i.Tgd  <= dst_inst_i.Tgd;
                    dst_i.Tgc  <= dst_inst_i.Tgc;
                    state_req  <= '1;
                    end
                  else
                    begin
                    dst_data_o.Stall <= '0;
                    state_inst <= '0;
                    state_mem  <= '1;
                    state_idle <= '1;
                    end
                  end
                if(state_mem)
                  begin
                  if(dst_data_i.Stb)
                    begin
                    dst_i.Adr  <= dst_data_i.Adr;
                    dst_i.Data <= dst_data_i.Data;
                    dst_i.We   <= dst_data_i.We;
                    dst_i.Sel  <= dst_data_i.Sel;
                    dst_i.Tga  <= dst_data_i.Tga;
                    dst_i.Tgd  <= dst_data_i.Tgd;
                    dst_i.Tgc  <= dst_data_i.Tgc;
                    state_req  <= '1;
                    end
                  else
                    begin
                    dst_inst_o.Stall <= '0;
                    state_inst <= '1;
                    state_mem  <= '0;
                    state_idle <= '1;
                    end
                  end
                end
    state_req: begin
               ddr3_fifo_out_wrreq <= dst_i.We;
               ddr3_fifo_out_rdreq <= ~dst_i.We;
               ddr3_fifo_out_data  <= dst_i.Data;
               ddr3_fifo_out_addr  <= dst_i.Adr[25:0];

               if(dst_i.We)
                 begin
                 state_inst <= ~state_inst;
                 state_mem  <= ~state_mem;
                 state_idle <= '1;
                 end
               else
                 begin
                 state_rsp <= '1;
                 end
               end
    state_rsp: begin
               if(~ddr3_fifo_in_empty )
                 begin
                 ddr3_fifo_in_rdack  <= '1;

                 if(state_inst)
                   begin
                   dst_inst_o.Ack  <= '1;
                   dst_inst_o.Err  <= '0;
                   dst_inst_o.Rty  <= '0;
                   dst_inst_o.Data <= ddr3_fifo_in_q[127:0];
                   dst_inst_o.Tga  <= dst_i.Tga;
                   dst_inst_o.Tgd  <= dst_i.Tgd;
                   dst_inst_o.Tgc  <= dst_i.Tgc;
                   end

                 if(state_mem)
                   begin
                   dst_data_o.Ack  <= '1;
                   dst_data_o.Err  <= '0;
                   dst_data_o.Rty  <= '0;
                   dst_data_o.Data <= ddr3_fifo_in_q[127:0];
                   dst_data_o.Tga  <= dst_i.Tga;
                   dst_data_o.Tgd  <= dst_i.Tgd;
                   dst_data_o.Tgc  <= dst_i.Tgc;
                   end

                 if(state_inst)
                   begin
                   dst_data_o.Stall <= '0;
                   state_inst <= '0;
                   state_mem  <= '1;
                   end
                 if(state_mem)
                   begin
                   dst_inst_o.Stall <= '0;
                   state_inst <= '1;
                   state_mem  <= '0;
                   end
                 state_idle <= '1;
                 end
               else
                 begin
                 state_rsp <= '1;
                 end
               end
               
  endcase

  if(rst) 
  begin
    state_inst <= '1;
    state_mem  <= '0;

    state_idle   <= '1;
    state_req <= '0;
    state_rsp <= '0;

    ddr3_fifo_out_wrreq <= '0;
    ddr3_fifo_out_rdreq <= '0;

    ddr3_fifo_in_rdack  <= '0;
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
                       ddr3_cnt            <= '0;
                       ddr3_state_pulse    <= '1;
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
                         if(ddr3_cnt == 1)
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

logic [35:0] ddr3_fifo_out_unused;

ddr3_fifo ddr3_fifo_out (
  .aclr    ( rst ),
  .data    ( {36'b0,
              ddr3_fifo_out_wrreq,
              ddr3_fifo_out_rdreq,
              ddr3_fifo_out_addr,
              ddr3_fifo_out_data} ),
  .rdclk   ( ddr3_clk ),
  .rdreq   ( ddr3_fifo_out_rdack ),
  .wrclk   ( clk ),
  .wrreq   ( (ddr3_fifo_out_wrreq | ddr3_fifo_out_rdreq) ),
  .q       ( {ddr3_fifo_out_unused,
              ddr3_fifo_out_wrreq_q,
              ddr3_fifo_out_rdreq_q,
              ddr3_fifo_out_addr_q,
              ddr3_fifo_out_wdata_q} ),
  .rdempty ( ddr3_fifo_out_rdempty )
);

logic [1:0] ddr3_fifo_in_unused;

ddr3_fifo ddr3_fifo_in (
  .aclr    ( rst ),
  .data    ( {64'b0,ddr3_avl_rdata} ),
  .rdclk   ( clk ),
  .rdreq   ( ddr3_fifo_in_rdack ),
  .wrclk   ( ddr3_clk ),
  .wrreq   ( ddr3_fifo_in_wrreq ),
  .q       ( {ddr3_fifo_in_unused,
              ddr3_fifo_in_q} ),
  .rdempty ( ddr3_fifo_in_empty )
);

endmodule
