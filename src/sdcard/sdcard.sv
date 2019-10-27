module sdcard #(
  parameter integer      SIZE = 2
) (
input  logic clk,
input  logic rst,
input  logic arst,

//////////// SPI //////////
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

output logic [31:0]    o_bus_ack,
output logic [31:0]    o_bus_data
);

logic arst_1;
logic arst_2;
logic arst_3;

logic       SCK_clk;
logic       SCK_empty;
logic       SCK_cmd;
logic [7:0] SCK_data;

logic       req;
logic       cmd;
logic [7:0] data;
logic       rd_done;
logic       rdy;

always_ff @(posedge clk)
  begin
  req  <= '0;
  cmd  <= cmd;
  data <= data;

  o_bus_ack   <= '0;
  o_bus_data  <= i_bus_data;   

  if(i_bus_req)
    begin
    o_bus_ack <= '1;
    if(i_bus_write)
      begin
      case (i_bus_addr[15:2])
        'h0000:  begin
                 o_bus_data    <= '0;
                 o_bus_data[0] <= rdy;
                 end
        'h0001:  begin 
                 req           <= '1;
                 cmd           <= '1;
                 data          <= i_bus_data;
                 o_bus_data    <= '0;
                 end
        'h0002:  begin 
                 req           <= '1;
                 cmd           <= '0;
                 data          <= i_bus_data; 
                 o_bus_data    <= '0;
                 end
        default: begin
                 o_bus_data    <= '0;
                 o_bus_data[0] <= rdy;
                 end
      endcase
      end
    end
  end

fifo	fifo (
	.aclr    ( rst ),
	.data    ( {cmd,data} ),
	.rdclk   ( clk ),
	.rdreq   ( rd_done ),
	.wrclk   ( clk ),
	.wrreq   ( req ),
	.q       ( {SCK_cmd,SCK_data} ),
	.rdempty ( SCK_empty ),
	.rdfull  (  ),
	.rdusedw (  ),
	.wrempty (  ),
	.wrfull  (  ),
	.wrusedw (  )
	);

spi spi (
  .clk     (clk    ),
  .rst     (rst    ),
        
  .SCK     (SCK    ),
  .CS      (CS     ),
  .RS_DC   (RS_DC  ),
  .DATA    (DATA   ),
        
  .req     (req    ),
  .cmd     (cmd    ),
  .data    (data   ),
        
  .rd_done (rd_done),
  .rdy     (rdy    )
);

//st7735r_clk sck (
//  .clk (clk),
//  .rst (rst),
//  
//  .SCK_clk (SCK_clk),
//  .SCK (SCK)
//);
//
//st7735r_transmit transmit (
//  .SCK_clk   (SCK_clk),
//  .clk       (clk),      
//  .rst       (rst),      
//                       
//  .RS_DC     (RS_DC),    
//  .DATA      (DATA),     
//  .CS        (CS),       
//                       
//  .req       (~SCK_empty),      
//  .cmd       (SCK_cmd),      
//  .data      (SCK_data),     
//                       
//  .rd_done   ( rd_done ),
//  .rdy       (rdy)       
//);

endmodule
