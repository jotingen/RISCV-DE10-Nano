import wishbone_pkg::*;

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
  input  logic [$bits(wishbone_pkg::bus_req_t)-1:0] bus_data_flat_i,
  output logic [$bits(wishbone_pkg::bus_rsp_t)-1:0] bus_data_flat_o
);

wishbone_pkg::bus_req_t bus_data_i;
wishbone_pkg::bus_rsp_t bus_data_o;
always_comb
begin
  bus_data_i      = bus_data_flat_i;
  bus_data_flat_o = bus_data_o;
end


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

  bus_data_o.Ack   <= '0;    
  bus_data_o.Data  <= bus_data_i.Data;   

  pending_cmd  <= '0;
  pending_data <= '0;

  if(bus_data_i.Cyc & bus_data_i.Stb)
    begin
    if(bus_data_i.We)
      begin
      case (bus_data_i.Adr[31:2])
        'h0: begin
                 bus_data_o.Ack <= '1;
                 bus_data_o.Data    <= '0;
                 end
        'h1: begin 
                 cmd           <= '1;
                 data          <= bus_data_i.Data;
                 if(fifo_full)
                   begin
                   pending_cmd  <= '1;
                   end
                 else
                   begin
                   req           <= '1;
                   bus_data_o.Ack     <= '1;
                   bus_data_o.Data    <= '0;
                   end
                 end
        'h2: begin 
                 cmd           <= '0;
                 data          <= bus_data_i.Data;
                 if(fifo_full)
                   begin
                   pending_data <= '1;
                   end
                 else
                   begin
                   req           <= '1;
                   bus_data_o.Ack     <= '1;
                   bus_data_o.Data    <= '0;
                   end
                 end
        default: begin
                 bus_data_o.Ack <= '1;
                 bus_data_o.Data    <= '0;
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
      bus_data_o.Ack     <= '1;
      bus_data_o.Data    <= '0;
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
      bus_data_o.Ack     <= '1;
      bus_data_o.Data    <= '0;
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
