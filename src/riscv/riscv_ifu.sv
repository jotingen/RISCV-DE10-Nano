import wishbone_pkg::*;

module riscv_ifu (
  input  logic             clk,
  input  logic             rst,

  input  logic             exu_vld,
  input  logic [63:0]      exu_order_next,
  input  logic             exu_retired,
  input  logic             exu_freeze,
  input  logic             exu_br_miss,
  input  logic             exu_trap,
  input  logic [31:0]      exu_PC_next,

  input  logic             idu_vld,
  input  logic             idu_freeze,

  output logic [31:0]      pre_ifu_PC,
  input  logic             pre_ifu_br_pred_taken,
  input  logic [31:0]      pre_ifu_br_pred_PC_next,

  output logic             ifu_vld,
  output logic [31:0]      ifu_inst,
  output logic [63:0]      ifu_inst_order,
  output logic [31:0]      ifu_inst_PC,
  output logic             ifu_inst_br_taken,
  output logic [31:0]      ifu_inst_br_pred_PC_next,

  output wishbone_pkg::bus_req_t bus_inst_o,
  input  wishbone_pkg::bus_rsp_t bus_inst_i

);

//Invalid state  TODO halt?
logic illegal;

//Instruction requested
logic accessing;

//Instruction has been loaded, waiting to send
logic loaded;

//Branch era, used to throw away fetches ona  branch midd
logic [3:0] pre_ifu_era;

logic             pre_ifu_vld;
logic [63:0]      pre_ifu_order;
logic [31:0]      instbus_data;

logic [63:0] ifu_buff_order_in;
logic [63:0] ifu_buff_order_out;

logic        ifu_buff_addr_wrreq;
logic [31:0] ifu_buff_addr_in;
logic        ifu_buff_addr_ack;
logic [31:0] ifu_buff_addr_out;
logic        ifu_buff_addr_empty;
logic        ifu_buff_addr_full;
logic        ifu_buff_addr_clear;
logic  [3:0] ifu_buff_addr_used;

logic        ifu_buff_data_wrreq;
logic [31:0] ifu_buff_data_in;
logic        ifu_buff_data_ack;
logic [31:0] ifu_buff_data_out;
logic        ifu_buff_data_empty;
logic        ifu_buff_data_full;
logic        ifu_buff_data_clear;
logic  [3:0] ifu_buff_data_used;

logic [31:0] ifu_buff_br_taken_in;
logic [31:0] ifu_buff_br_taken_out;

logic [31:0] ifu_buff_br_pred_PC_next_in;
logic [31:0] ifu_buff_br_pred_PC_next_out;

assign bus_inst_o.Stb   = pre_ifu_vld; 
assign bus_inst_o.Cyc   = bus_inst_o.Stb;
assign bus_inst_o.We    = '0;
assign bus_inst_o.Sel   = '1;
assign bus_inst_o.Adr   = pre_ifu_PC;
assign bus_inst_o.Data  = '0;
assign bus_inst_o.Tga   = pre_ifu_br_pred_taken;
assign bus_inst_o.Tgd   = '0;
assign bus_inst_o.Tgc   = pre_ifu_era;

ifu_buff ifu_buff_order_1 (
  .clock ( clk ),
  .data  ( ifu_buff_order_in[63:32] ),
  .rdreq ( ifu_buff_addr_ack ),
  .sclr  ( ifu_buff_addr_clear ),
  .wrreq ( ifu_buff_addr_wrreq ),
  .empty (  ),
  .almost_full  (  ),
  .q     ( ifu_buff_order_out[63:32] ),
  .usedw (  )
  );
ifu_buff ifu_buff_order_0 (
  .clock ( clk ),
  .data  ( ifu_buff_order_in[31:0] ),
  .rdreq ( ifu_buff_addr_ack ),
  .sclr  ( ifu_buff_addr_clear ),
  .wrreq ( ifu_buff_addr_wrreq ),
  .empty (  ),
  .almost_full  (  ),
  .q     ( ifu_buff_order_out[31:0] ),
  .usedw (  )
  );
ifu_buff ifu_buff_addr (
  .clock ( clk ),
  .data  ( ifu_buff_addr_in ),
  .rdreq ( ifu_buff_addr_ack ),
  .sclr  ( ifu_buff_addr_clear ),
  .wrreq ( ifu_buff_addr_wrreq ),
  .empty ( ifu_buff_addr_empty ),
  .almost_full  ( ifu_buff_addr_full ),
  .q     ( ifu_buff_addr_out ),
  .usedw ( ifu_buff_addr_used )
  );
ifu_buff ifu_buff_br_taken (
  .clock ( clk ),
  .data  ( ifu_buff_br_taken_in ),
  .rdreq ( ifu_buff_addr_ack ),
  .sclr  ( ifu_buff_addr_clear ),
  .wrreq ( ifu_buff_addr_wrreq ),
  .empty (  ),
  .almost_full  (  ),
  .q     ( ifu_buff_br_taken_out ),
  .usedw (  )
  );
ifu_buff ifu_buff_br_pred_PC_next (
  .clock ( clk ),
  .data  ( ifu_buff_br_pred_PC_next_in ),
  .rdreq ( ifu_buff_addr_ack ),
  .sclr  ( ifu_buff_addr_clear ),
  .wrreq ( ifu_buff_addr_wrreq ),
  .empty (  ),
  .almost_full  (  ),
  .q     ( ifu_buff_br_pred_PC_next_out ),
  .usedw (  )
  );
ifu_buff ifu_buff_data (
  .clock ( clk ),
  .data  ( ifu_buff_data_in ),
  .rdreq ( ifu_buff_data_ack ),
  .sclr  ( ifu_buff_data_clear ),
  .wrreq ( ifu_buff_data_wrreq ),
  .empty ( ifu_buff_data_empty ),
  .almost_full  ( ifu_buff_data_full ),
  .q     ( ifu_buff_data_out ),
  .usedw ( ifu_buff_data_used )
  );

always_comb
  begin
  pre_ifu_vld  = '0;
  ifu_buff_addr_ack   = '0;
  ifu_buff_data_ack   = '0;
  if(~ifu_buff_addr_full & ~bus_inst_i.Stall)
    begin
    pre_ifu_vld  = '1;
    end
    if(~((exu_vld & exu_freeze)))
      begin
      if(~ifu_buff_addr_empty & ~ifu_buff_data_empty &
         ~ifu_buff_addr_clear & ~ifu_buff_data_clear)
        begin
        ifu_buff_addr_ack = '1;
        ifu_buff_data_ack = '1;
        end
      end
  if(exu_vld & exu_br_miss)
    begin
    ifu_buff_addr_ack = '0;
    ifu_buff_data_ack = '0;
    end

  if(rst)
    begin
    pre_ifu_vld   = '0;
    ifu_buff_addr_ack = '0;
    ifu_buff_data_ack = '0;
    end
  end

always_ff @(posedge clk)
  begin

  ifu_vld           <= ifu_vld;   
  ifu_inst          <= ifu_inst;  
  ifu_inst_order    <= ifu_inst_order;
  ifu_inst_PC       <= ifu_inst_PC;
  ifu_inst_br_taken <= ifu_inst_br_taken;
  ifu_inst_br_pred_PC_next <= ifu_inst_br_pred_PC_next;

  pre_ifu_era          <= pre_ifu_era;

  ifu_buff_order_in    <= '0;
  ifu_buff_addr_in     <= '0;
  ifu_buff_addr_clear  <= '0;
  ifu_buff_addr_wrreq  <= '0;
  ifu_buff_br_taken_in <= '0;
  ifu_buff_br_pred_PC_next_in <= '0;

  ifu_buff_data_in    <= '0;
  ifu_buff_data_clear <= '0;
  ifu_buff_data_wrreq <= '0;



  //Make requests while we have buffers available
  if(~ifu_buff_addr_full & ~bus_inst_i.Stall)
    begin

    if(pre_ifu_br_pred_taken)
      begin
      pre_ifu_order <= pre_ifu_order + 'd1; 
      pre_ifu_PC    <= pre_ifu_br_pred_PC_next;
      end
    else
      begin
      pre_ifu_order <= pre_ifu_order + 'd1;
      pre_ifu_PC    <= pre_ifu_PC + 'd4;
      end

    ifu_buff_addr_wrreq  <= '1;
    ifu_buff_order_in    <= pre_ifu_order;
    ifu_buff_addr_in     <= pre_ifu_PC;
    ifu_buff_br_taken_in <= pre_ifu_br_pred_taken;
    if(pre_ifu_br_pred_taken)
      begin
      ifu_buff_br_pred_PC_next_in <= pre_ifu_br_pred_PC_next;
      end
    else
      begin
      ifu_buff_br_pred_PC_next_in <= pre_ifu_PC + 'd4;
      end
    end

  //Recieve from memory
  if(bus_inst_i.Ack & bus_inst_i.Tgc == pre_ifu_era)
    begin
    ifu_buff_data_wrreq  <= '1;
    ifu_buff_data_in     <= bus_inst_i.Data;
    end

  //TODO put in bypass
  //If not frozen, send from first available buffer
  if(~((exu_vld & exu_freeze)))
    begin
    if(~ifu_buff_addr_empty & ~ifu_buff_data_empty &
       ~ifu_buff_addr_clear & ~ifu_buff_data_clear)
      begin
      ifu_vld           <= '1;
      ifu_inst          <= ifu_buff_data_out;
      ifu_inst_order    <= ifu_buff_order_out;
      ifu_inst_PC       <= ifu_buff_addr_out;
      ifu_inst_br_taken <= ifu_buff_br_taken_out;
      ifu_inst_br_pred_PC_next <= ifu_buff_br_pred_PC_next_out;
      end
    else
      begin
      ifu_vld <= '0;
      end
    end

  //If we branch miss, throw it all away and re-request
  if(exu_vld & exu_br_miss)
    begin
    ifu_vld     <= '0;
    pre_ifu_order  <= exu_order_next;
    pre_ifu_PC <= exu_PC_next;
    pre_ifu_era          <= pre_ifu_era + 'd1;

    ifu_buff_addr_clear <= '1;
    ifu_buff_data_clear <= '1;
    end

  if(rst)
    begin
    pre_ifu_order  <= '0;
    pre_ifu_PC     <= '0;

    pre_ifu_era           <= '0;

    ifu_buff_addr_clear <= '1;
    ifu_buff_data_clear <= '1;

    end

  end


endmodule
