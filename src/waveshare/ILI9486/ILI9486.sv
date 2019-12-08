module ILI9486 (
  input  logic clk,
  input  logic rst,
  
  //////////// SPI //////////
  output logic SPIReq,
  input  logic SPIAck,
  output logic SPIDone,
  output logic SCK,
  output logic RS_DC,
  output logic DATA,
  output logic CS,
  
  //////////// BUS //////////
  input  logic           i_bus_req,
  input  logic           i_bus_write,
  input  logic [31:0]    i_bus_addr,
  input  logic [31:0]    i_bus_data,
  input  logic  [3:0]    i_bus_data_rd_mask,
  input  logic  [3:0]    i_bus_data_wr_mask,
  
  output logic           o_bus_ack,
  output logic [31:0]    o_bus_data
);

logic arst_1;
logic arst_2;
logic arst_3;

logic       SCK_clk;
logic       SCK_empty;
logic       SCK_cmd;
logic [15:0] SCK_data;

logic       req;
logic       cmd;
logic [15:0] data;
logic       rdy;

logic fifo_full;
logic pending_cmd;
logic pending_data;

always_ff @(posedge clk)
  begin
  req  <= '0;
  cmd  <= cmd;
  data <= data;

  o_bus_ack   <= '0;    
  o_bus_data  <= i_bus_data;   

  pending_cmd  <= '0;
  pending_data <= '0;

  if(i_bus_req)
    begin
    if(i_bus_write)
      begin
      case (i_bus_addr[31:2])
        'h0: begin
                 o_bus_ack <= '1;
                 o_bus_data    <= '0;
                 end
        'h1: begin 
                 cmd           <= '1;
                 data          <= i_bus_data;
                 if(fifo_full)
                   begin
                   pending_cmd  <= '1;
                   end
                 else
                   begin
                   req           <= '1;
                   o_bus_ack     <= '1;
                   o_bus_data    <= '0;
                   end
                 end
        'h2: begin 
                 cmd           <= '0;
                 data          <= i_bus_data;
                 if(fifo_full)
                   begin
                   pending_data <= '1;
                   end
                 else
                   begin
                   req           <= '1;
                   o_bus_ack     <= '1;
                   o_bus_data    <= '0;
                   end
                 end
        default: begin
                 o_bus_ack <= '1;
                 o_bus_data    <= '0;
                 end
      endcase
      end
    end

  if(pending_cmd)
    begin
    if(fifo_full)
      begin
      pending_cmd  <= '1;
      end
    else
      begin
      req           <= '1;
      o_bus_ack     <= '1;
      o_bus_data    <= '0;
      end
    end

  if(pending_data)
    begin
    if(fifo_full)
      begin
      pending_data  <= '1;
      end
    else
      begin
      req           <= '1;
      o_bus_ack     <= '1;
      o_bus_data    <= '0;
      end
    end
  end

fifo	fifo (
	.aclr    ( rst ),
	.data    ( {cmd,data} ),
	.rdclk   ( clk ),
	.rdreq   ( SPIDone ),
	.wrclk   ( clk ),
	.wrreq   ( req ),
	.q       ( {SCK_cmd,SCK_data} ),
	.rdempty ( SCK_empty ),
	.rdfull  (  ),
	.rdusedw (  ),
	.wrempty (  ),
	.wrfull  ( fifo_full ),
	.wrusedw (  )
	);

ILI9486_clk sck (
  .clk (clk),
  .rst (rst),
  
  .SCK_clk (SCK_clk),
  .SCK (SCK)
);

ILI9486_transmit transmit (
  .SCK_clk   (SCK_clk),
  .clk       (clk),      
  .rst       (rst),      
                       
  .SPIReq    (SPIReq),
  .SPIAck    (SPIAck),
  .RS_DC     (RS_DC),    
  .DATA      (DATA),     
  .CS        (CS),       
                       
  .req       (~SCK_empty),      
  .cmd       (SCK_cmd),      
  .data      (SCK_data),     
                       
  .SPIDone   (SPIDone),
  .rdy       (rdy)       
);

endmodule
