
module riscv_ifu (
  input  logic             clk,
  input  logic             rst,

  input  logic             alu_vld,
  input  logic             alu_retired,
  input  logic             alu_freeze,
  input  logic             alu_br_miss,
  input  logic             alu_trap,
  input  logic [31:0]      alu_PC_next,

  input  logic             idu_vld,
  input  logic             idu_freeze,

  output logic             ifu_vld,
  output logic [31:0]      ifu_inst,
  output logic [31:0]      ifu_inst_PC,

  output logic [31:0]      bus_inst_adr_o,
  output logic [31:0]      bus_inst_data_o,
  output logic             bus_inst_we_o,
  output logic  [3:0]      bus_inst_sel_o,
  output logic             bus_inst_stb_o,
  output logic             bus_inst_cyc_o,
  output logic             bus_inst_tga_o,
  output logic             bus_inst_tgd_o,
  output logic  [3:0]      bus_inst_tgc_o,

  input  logic             bus_inst_ack_i,
  input  logic             bus_inst_stall_i,
  input  logic             bus_inst_err_i,
  input  logic             bus_inst_rty_i,
  input  logic [31:0]      bus_inst_data_i,
  input  logic             bus_inst_tga_i,
  input  logic             bus_inst_tgd_i,
  input  logic  [3:0]      bus_inst_tgc_i
   

);

//Invalid state  TODO halt?
logic illegal;

//Instruction requested
logic accessing;

//Instruction has been loaded, waiting to send
logic loaded;

//Branch era, used to throw away fetches ona  branch midd
logic [3:0] era;

logic [31:0] PC;
logic             instbus_req;
//logic             instbus_write;
logic [31:0]      instbus_addr;
logic [31:0]      instbus_data;

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

assign bus_inst_stb_o   = instbus_req; //(instbus_req | accessing) & ~(alu_vld & (alu_trap | alu_br_miss)); 
assign bus_inst_cyc_o   = bus_inst_stb_o;
assign bus_inst_we_o    = '0;
assign bus_inst_sel_o   = '1;
assign bus_inst_adr_o   = instbus_addr;
assign bus_inst_data_o  = '0;
assign bus_inst_tga_o   = '0;
assign bus_inst_tgd_o   = '0;
assign bus_inst_tgc_o   = era;

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
  instbus_req  = '0;
  ifu_buff_addr_ack   = '0;
  ifu_buff_data_ack   = '0;
  if(~ifu_buff_addr_full & ~bus_inst_stall_i)
    begin
    instbus_req  = '1;
    end
    if(~((alu_vld & alu_freeze)))
      begin
      if(~ifu_buff_addr_empty & ~ifu_buff_data_empty &
         ~ifu_buff_addr_clear & ~ifu_buff_data_clear)
        begin
        ifu_buff_addr_ack = '1;
        ifu_buff_data_ack = '1;
        end
      end
  if(alu_vld & alu_br_miss)
    begin
    ifu_buff_addr_ack = '0;
    ifu_buff_data_ack = '0;
    end

  if(rst)
    begin
    instbus_req   = '0;
    ifu_buff_addr_ack = '0;
    ifu_buff_data_ack = '0;
    end
  end

always_ff @(posedge clk)
  begin

  ifu_vld     <= ifu_vld;   
  ifu_inst    <= ifu_inst;  
  ifu_inst_PC <= ifu_inst_PC;

  era          <= era;

  ifu_buff_addr_in    <= '0;
  ifu_buff_addr_clear <= '0;
  ifu_buff_addr_wrreq <= '0;

  ifu_buff_data_in    <= '0;
  ifu_buff_data_clear <= '0;
  ifu_buff_data_wrreq <= '0;

  //Make requests while we have buffers available
  if(~ifu_buff_addr_full & ~bus_inst_stall_i)
    begin
    //instbus_req  <= '1;
    instbus_addr <= instbus_addr + 'd4;

    ifu_buff_addr_wrreq <= '1;
    ifu_buff_addr_in    <= instbus_addr;
    end

  //Recieve from memory
  if(bus_inst_ack_i & bus_inst_tgc_i == era)
    begin
    ifu_buff_data_wrreq <= '1;
    ifu_buff_data_in    <= bus_inst_data_i;
    end

  //TODO put in bypass
  //If not frozen, send from first available buffer
  if(~((alu_vld & alu_freeze)))
    begin
    if(~ifu_buff_addr_empty & ~ifu_buff_data_empty &
       ~ifu_buff_addr_clear & ~ifu_buff_data_clear)
      begin
      ifu_vld     <= '1;
      ifu_inst    <= ifu_buff_data_out;
      ifu_inst_PC <= ifu_buff_addr_out;
      end
    else
      begin
      ifu_vld <= '0;
      end
    end

  //If we branch miss, throw it all away and re-request
  if(alu_vld & alu_br_miss)
    begin
    ifu_vld     <= '0;
    instbus_addr <= alu_PC_next;
    era          <= era + 'd1;

    ifu_buff_addr_clear <= '1;
    ifu_buff_data_clear <= '1;
    end

  if(rst)
    begin
    //instbus_req   <= '0;
    instbus_addr  <= '0;

    era           <= '0;

    ifu_buff_addr_clear <= '1;
    ifu_buff_data_clear <= '1;

    end

  //illegal         <= '0;
  //accessing       <= accessing;
  //loaded          <= loaded;
  //era <= era;
  //instbus_req   <= instbus_req;
  //instbus_write <= instbus_write;
  //instbus_addr  <= instbus_addr;
  //instbus_data  <= instbus_data;
  //
  //ifu_vld     <= '0;
  //ifu_inst    <= ifu_inst;
  //ifu_inst_PC <= ifu_inst_PC;
  //if(bus_inst_ack_i & accessing)
  //  begin
  //  ifu_inst    <= bus_inst_data_i;
  //  ifu_inst_PC <= instbus_addr;
  //  end
  //PC      <= PC;

  //if(alu_vld && alu_br_miss)
  //  begin
  //  era <= era + 1'd1;
  //  end

  //unique
  //casex({accessing,loaded,alu_vld,alu_retired,alu_freeze,alu_trap,alu_br_miss,idu_vld,idu_freeze,bus_inst_ack_i})
  //  'b00_0xxxx_0x_0: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= PC;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC+4;
  //                   illegal         <= '0;
  //                   end
  //  'b00_0xxxx_0x_1: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= PC;
  //                   ifu_vld         <= '1;
  //                   PC              <= PC+4;
  //                   illegal         <= '0;
  //                   end
  //  'b00_0xxxx_10_0: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= PC;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC+4;
  //                   illegal         <= '0;
  //                   end
  //  'b00_0xxxx_10_1: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= PC;
  //                   ifu_vld         <= '1;
  //                   PC              <= PC+4;
  //                   illegal         <= '0;
  //                   end
  //  'b00_0xxxx_11_0: begin
  //                   accessing       <= '0;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC;
  //                   illegal         <= '0;
  //                   end
  //  'b00_0xxxx_11_1: begin
  //                   accessing       <= '0;
  //                   loaded          <= '1;
  //                   instbus_req   <= '1;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '1;
  //                   PC              <= PC;
  //                   illegal         <= '0;
  //                   end


  //  'b00_10xxx_0x_0: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= PC;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC+4;
  //                   illegal         <= '0;
  //                   end
  //  'b00_10xxx_0x_1: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= PC;
  //                   ifu_vld         <= '1;
  //                   PC              <= PC+4;
  //                   illegal         <= '0;
  //                   end
  //  'b00_10xxx_10_0: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= PC;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC+4;
  //                   illegal         <= '0;
  //                   end
  //  'b00_10xxx_10_1: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= PC;
  //                   ifu_vld         <= '1;
  //                   PC              <= PC+4;
  //                   illegal         <= '0;
  //                   end
  //  'b00_10xxx_11_0: begin
  //                   accessing       <= '0;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC;
  //                   illegal         <= '0;
  //                   end
  //  'b00_10xxx_11_1: begin
  //                   accessing       <= '0;
  //                   loaded          <= '1;
  //                   instbus_req   <= '1;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '1;
  //                   PC              <= PC;
  //                   illegal         <= '0;
  //                   end


  //  'b00_11000_0x_0: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= PC;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC+4;
  //                   illegal         <= '0;
  //                   end
  //  'b00_11000_0x_1: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= PC;
  //                   ifu_vld         <= '1;
  //                   PC              <= PC+4;
  //                   illegal         <= '0;
  //                   end
  //  'b00_11000_10_0: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= PC;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC+4;
  //                   illegal         <= '0;
  //                   end
  //  'b00_11000_10_1: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= PC;
  //                   ifu_vld         <= '1;
  //                   PC              <= PC+4;
  //                   illegal         <= '0;
  //                   end
  //  'b00_11000_11_0: begin
  //                   accessing       <= '0;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC;
  //                   illegal         <= '0;
  //                   end
  //  'b00_11000_11_1: begin
  //                   accessing       <= '0;
  //                   loaded          <= '1;
  //                   instbus_req   <= '1;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '1;
  //                   PC              <= PC;
  //                   illegal         <= '0;
  //                   end


  //  'b00_11001_xx_x: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= alu_PC_next;
  //                   ifu_vld         <= '0;
  //                   PC              <= alu_PC_next+4;
  //                   illegal         <= '0;
  //                   end


  //  'b00_1101x_xx_x: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= alu_PC_next;
  //                   ifu_vld         <= '0;
  //                   PC              <= alu_PC_next+4;
  //                   illegal         <= '0;
  //                   end


  //  'b00_11100_xx_x: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC+4;
  //                   illegal         <= '0;
  //                   end


  //  'b00_11101_xx_x: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= alu_PC_next;
  //                   illegal         <= '0;
  //                   end


  //  'b00_1111x_xx_x: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= alu_PC_next;
  //                   illegal         <= '0;
  //                   end


  //  'b01_0xxxx_0x_0: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= PC;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC+4;
  //                   illegal         <= '0;
  //                   end
  //  'b01_0xxxx_0x_1: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= PC;
  //                   ifu_vld         <= '1;
  //                   PC              <= PC+4;
  //                   illegal         <= '1;
  //                   end
  //  'b01_0xxxx_10_0: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= PC;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC+4;
  //                   illegal         <= '0;
  //                   end
  //  'b01_0xxxx_10_1: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= PC;
  //                   ifu_vld         <= '1;
  //                   PC              <= PC+4;
  //                   illegal         <= '1;
  //                   end
  //  'b01_0xxxx_11_0: begin
  //                   accessing       <= '0;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC;
  //                   illegal         <= '0;
  //                   end
  //  'b01_0xxxx_11_1: begin
  //                   accessing       <= '0;
  //                   loaded          <= '1;
  //                   instbus_req   <= '1;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '1;
  //                   PC              <= PC;
  //                   illegal         <= '1;
  //                   end


  //  'b01_100xx_0x_0: begin
  //                   accessing       <= '0;
  //                   loaded          <= '1;
  //                   instbus_req   <= '0;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC;
  //                   illegal         <= '0;
  //                   end
  //  'b01_100xx_0x_1: begin
  //                   accessing       <= '0;
  //                   loaded          <= '1;
  //                   instbus_req   <= '0;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC;
  //                   illegal         <= '1;
  //                   end
  //  'b01_100xx_10_0: begin
  //                   accessing       <= '0;
  //                   loaded          <= '1;
  //                   instbus_req   <= '0;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC;
  //                   illegal         <= '0;
  //                   end
  //  'b01_100xx_10_1: begin
  //                   accessing       <= '0;
  //                   loaded          <= '1;
  //                   instbus_req   <= '0;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC;
  //                   illegal         <= '1;
  //                   end
  //  'b01_100xx_11_0: begin
  //                   accessing       <= '0;
  //                   loaded          <= '1;
  //                   instbus_req   <= '0;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC;
  //                   illegal         <= '0;
  //                   end
  //  'b01_100xx_11_1: begin
  //                   accessing       <= '0;
  //                   loaded          <= '1;
  //                   instbus_req   <= '0;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC;
  //                   illegal         <= '1;
  //                   end


  //  'b01_101xx_xx_0: begin
  //                   accessing       <= '0;
  //                   loaded          <= '1;
  //                   instbus_req   <= '0;
  //                   //instbus_addr  <= 0;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC;
  //                   illegal         <= '0;
  //                   end
  //  'b01_101xx_xx_1: begin
  //                   accessing       <= '0;
  //                   loaded          <= '1;
  //                   instbus_req   <= '0;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC;
  //                   illegal         <= '1;
  //                   end


  //  'b01_11000_0x_0: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req     <= '1;
  //                   instbus_addr    <= PC;
  //                   ifu_vld         <= '1;
  //                   PC              <= PC+4;
  //                   illegal         <= '0;
  //                   end
  //  'b01_11000_0x_1: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= PC;
  //                   ifu_vld         <= '1;
  //                   PC              <= PC+4;
  //                   illegal         <= '1;
  //                   end
  //  'b01_11000_10_0: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= PC;
  //                   ifu_vld         <= '1;
  //                   PC              <= PC+4;
  //                   illegal         <= '0;
  //                   end
  //  'b01_11000_10_1: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= PC;
  //                   ifu_vld         <= '1;
  //                   PC              <= PC+4;
  //                   illegal         <= '1;
  //                   end
  //  'b01_11000_11_0: begin
  //                   accessing       <= '0;
  //                   loaded          <= '1;
  //                   instbus_req     <= '0;
  //                   //instbus_addr    <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC;
  //                   illegal         <= '0;
  //                   end
  //  'b01_11000_11_1: begin
  //                   accessing       <= '0;
  //                   loaded          <= '1;
  //                   instbus_req     <= '1;
  //                   //instbus_addr    <= '0;
  //                   ifu_vld         <= '1;
  //                   PC              <= PC;
  //                   illegal         <= '1;
  //                   end


  //  'b01_11001_xx_0: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= alu_PC_next;
  //                   ifu_vld         <= '0;
  //                   PC              <= alu_PC_next+4;
  //                   illegal         <= '0;
  //                   end
  //  'b01_11001_xx_1: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= alu_PC_next;
  //                   ifu_vld         <= '0;
  //                   PC              <= alu_PC_next+4;
  //                   illegal         <= '1;
  //                   end


  //  'b01_1101x_xx_0: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= alu_PC_next;
  //                   ifu_vld         <= '0;
  //                   PC              <= alu_PC_next+4;
  //                   illegal         <= '0;
  //                   end
  //  'b01_1101x_xx_1: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= alu_PC_next;
  //                   ifu_vld         <= '0;
  //                   PC              <= alu_PC_next+4;
  //                   illegal         <= '1;
  //                   end


  //  'b01_11100_xx_0: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC+4;
  //                   illegal         <= '0;
  //                   end
  //  'b01_11100_xx_1: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC+4;
  //                   illegal         <= '1;
  //                   end


  //  'b01_11101_xx_0: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= alu_PC_next;
  //                   illegal         <= '0;
  //                   end
  //  'b01_11101_xx_1: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= alu_PC_next;
  //                   illegal         <= '1;
  //                   end


  //  'b01_1111x_xx_0: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= alu_PC_next;
  //                   illegal         <= '0;
  //                   end
  //  'b01_1111x_xx_1: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= alu_PC_next;
  //                   illegal         <= '1;
  //                   end


  //  'b10_0xxxx_0x_0: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '0;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC;
  //                   illegal         <= '0;
  //                   end
  //  'b10_0xxxx_0x_1: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= PC;
  //                   ifu_vld         <= '1;
  //                   PC              <= PC+4;
  //                   illegal         <= '0;
  //                   end
  //  'b10_0xxxx_10_0: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '0;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC;
  //                   illegal         <= '0;
  //                   end
  //  'b10_0xxxx_10_1: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= PC;
  //                   ifu_vld         <= '1;
  //                   PC              <= PC+4;
  //                   illegal         <= '0;
  //                   end
  //  'b10_0xxxx_11_0: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '0;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC;
  //                   illegal         <= '0;
  //                   end
  //  'b10_0xxxx_11_1: begin
  //                   accessing       <= '0;
  //                   loaded          <= '1;
  //                   instbus_req   <= '0;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC;
  //                   illegal         <= '0;
  //                   end


  //  'b10_100xx_0x_0: begin                     
  //                   accessing       <= '1;    
  //                   loaded          <= '0;    
  //                   instbus_req   <= '0;    
  //                   //instbus_addr  <= '0;    
  //                   ifu_vld         <= '0;    
  //                   PC              <= PC;    
  //                   illegal         <= '0;    
  //                   end                       
  //  'b10_100xx_0x_1: begin                     
  //                   accessing       <= '1;    
  //                   loaded          <= '0;    
  //                   instbus_req   <= '1;    
  //                   instbus_addr  <= PC;    
  //                   ifu_vld         <= '1;    
  //                   PC              <= PC+4;  
  //                   illegal         <= '0;    
  //                   end                       
  //  'b10_100xx_10_0: begin                     
  //                   accessing       <= '1;    
  //                   loaded          <= '0;    
  //                   instbus_req   <= '0;    
  //                   //instbus_addr  <= '0;    
  //                   ifu_vld         <= '0;    
  //                   PC              <= PC;    
  //                   illegal         <= '0;    
  //                   end                       
  //  'b10_100xx_10_1: begin                     
  //                   accessing       <= '1;    
  //                   loaded          <= '0;    
  //                   instbus_req   <= '1;    
  //                   instbus_addr  <= PC;    
  //                   ifu_vld         <= '1;    
  //                   PC              <= PC+4;  
  //                   illegal         <= '0;    
  //                   end                       
  //  'b10_100xx_11_0: begin                     
  //                   accessing       <= '1;    
  //                   loaded          <= '0;    
  //                   instbus_req   <= '0;    
  //                   //instbus_addr  <= '0;    
  //                   ifu_vld         <= '0;    
  //                   PC              <= PC;    
  //                   illegal         <= '0;    
  //                   end                       
  //  'b10_100xx_11_1: begin                     
  //                   accessing       <= '0;    
  //                   loaded          <= '1;    
  //                   instbus_req   <= '0;    
  //                   //instbus_addr  <= '0;    
  //                   ifu_vld         <= '1;    
  //                   PC              <= PC;    
  //                   illegal         <= '0;    
  //                   end                       


  //  'b10_101xx_xx_0: begin                     
  //                   accessing       <= '1;    
  //                   loaded          <= '0;    
  //                   instbus_req   <= '0;    
  //                   //instbus_addr  <= '0;    
  //                   ifu_vld         <= '0;    
  //                   PC              <= PC;    
  //                   illegal         <= '0;    
  //                   end                       
  //  'b10_101xx_xx_1: begin                     
  //                   accessing       <= '0;    
  //                   loaded          <= '1;    
  //                   instbus_req   <= '0;    
  //                   //instbus_addr  <= '0;    
  //                   ifu_vld         <= '0;    
  //                   PC              <= PC;  
  //                   illegal         <= '0;    
  //                   end                       


  //  'b10_11000_0x_0: begin                    
  //                   accessing       <= '1;   
  //                   loaded          <= '0;   
  //                   instbus_req   <= '0;   
  //                   //instbus_addr  <= '0;   
  //                   ifu_vld         <= '0;   
  //                   PC              <= PC;   
  //                   illegal         <= '0;   
  //                   end                      
  //  'b10_11000_0x_1: begin                    
  //                   accessing       <= '1;   
  //                   loaded          <= '0;   
  //                   instbus_req   <= '1;   
  //                   instbus_addr  <= PC;   
  //                   ifu_vld         <= '1;   
  //                   PC              <= PC+4; 
  //                   illegal         <= '0;   
  //                   end                      
  //  'b10_11000_10_0: begin                    
  //                   accessing       <= '1;   
  //                   loaded          <= '0;   
  //                   instbus_req   <= '0;   
  //                   //instbus_addr  <= '0;   
  //                   ifu_vld         <= '0;   
  //                   PC              <= PC;   
  //                   illegal         <= '0;   
  //                   end                      
  //  'b10_11000_10_1: begin                    
  //                   accessing       <= '1;   
  //                   loaded          <= '0;   
  //                   instbus_req   <= '1;   
  //                   instbus_addr  <= PC;   
  //                   ifu_vld         <= '1;   
  //                   PC              <= PC+4; 
  //                   illegal         <= '0;   
  //                   end                      
  //  'b10_11000_11_0: begin                    
  //                   accessing       <= '1;   
  //                   loaded          <= '0;   
  //                   instbus_req   <= '0;   
  //                   //instbus_addr  <= '0;   
  //                   ifu_vld         <= '0;   
  //                   PC              <= PC;   
  //                   illegal         <= '0;   
  //                   end                      
  //  'b10_11000_11_1: begin                    
  //                   accessing       <= '0;   
  //                   loaded          <= '1;   
  //                   instbus_req   <= '0;   
  //                   //instbus_addr  <= '0;   
  //                   ifu_vld         <= '0;   
  //                   PC              <= PC;   
  //                   illegal         <= '0;   
  //                   end                      


  //  'b10_11001_xx_0: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= alu_PC_next;
  //                   ifu_vld         <= '0;
  //                   PC              <= alu_PC_next+4;
  //                   illegal         <= '0;
  //                   end
  //  'b10_11001_xx_1: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= alu_PC_next;
  //                   ifu_vld         <= '0;
  //                   PC              <= alu_PC_next+4;
  //                   illegal         <= '0;
  //                   end


  //  'b10_1101x_xx_0: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= alu_PC_next;
  //                   ifu_vld         <= '0;
  //                   PC              <= alu_PC_next+4;
  //                   illegal         <= '0;
  //                   end
  //  'b10_1101x_xx_1: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '1;
  //                   instbus_addr  <= alu_PC_next;
  //                   ifu_vld         <= '0;
  //                   PC              <= alu_PC_next+4;
  //                   illegal         <= '0;
  //                   end


  //  'b10_11100_xx_0: begin
  //                   accessing       <= '1;
  //                   loaded          <= '0;
  //                   instbus_req   <= '0;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC;
  //                   illegal         <= '0;
  //                   end
  //  'b10_11100_xx_1: begin
  //                   accessing       <= '0;
  //                   loaded          <= '1;
  //                   instbus_req   <= '0;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC;
  //                   illegal         <= '0;
  //                   end


  //  'b10_11101_xx_0: begin
  //                   accessing       <= '0;
  //                   loaded          <= '0;
  //                   instbus_req   <= '0;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= alu_PC_next;
  //                   illegal         <= '0;
  //                   end
  //  'b10_11101_xx_1: begin
  //                   accessing       <= '0;
  //                   loaded          <= '0;
  //                   instbus_req   <= '0;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= alu_PC_next;
  //                   illegal         <= '0;
  //                   end


  //  'b10_1111x_xx_0: begin
  //                   accessing       <= '0;
  //                   loaded          <= '0;
  //                   instbus_req   <= '0;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= alu_PC_next;
  //                   illegal         <= '0;
  //                   end
  //  'b10_1111x_xx_1: begin
  //                   accessing       <= '0;
  //                   loaded          <= '0;
  //                   instbus_req   <= '0;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= alu_PC_next;
  //                   illegal         <= '0;
  //                   end

  //  default:         begin
  //                   accessing       <= '0;
  //                   loaded          <= '0;
  //                   instbus_req   <= '0;
  //                   //instbus_addr  <= '0;
  //                   ifu_vld         <= '0;
  //                   PC              <= PC;
  //                   illegal         <= '1;
  //                   end 
  //endcase

  //if(rst)
  //  begin
  //  illegal <= '1;

  //  PC <= '0;

  //  ifu_vld <= '0;
  //  ifu_inst <= '0;
  //  ifu_inst_PC <= '0;

  //  accessing <= '0;
  //  loaded <= '0;
  //  era <= '0;
  //  instbus_req <= '0;
  //  instbus_write <= '0;
  //  instbus_addr <= '0;
  //  instbus_data <= '0;
  //  end
  end


endmodule
