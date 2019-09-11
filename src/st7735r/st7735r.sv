module st7735r #(
  parameter integer      SIZE = 2,
  parameter logic [31:0] ADDR_BASE = 32'h00000000
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
input  logic           i_bus_ack,
input  logic           i_bus_write,
input  logic [31:0]    i_bus_addr,
input  logic [31:0]    i_bus_data,

output logic           o_bus_req,
output logic           o_bus_ack,
output logic           o_bus_write,
output logic [31:0]    o_bus_addr,
output logic [31:0]    o_bus_data
);

logic arst_1;
logic arst_2;
logic arst_3;

logic       SCK_rst;
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

  o_bus_req   <= i_bus_req;    
  o_bus_ack   <= i_bus_ack;    
  o_bus_write <= i_bus_write;  
  o_bus_addr  <= i_bus_addr;   
  o_bus_data  <= i_bus_data;   

  if(i_bus_req &
     i_bus_addr >= ADDR_BASE &
     i_bus_addr <= ADDR_BASE + 2**SIZE - 1)
    begin
    o_bus_req <= '0;    
    o_bus_ack <= '1;
    case (i_bus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2])
      'h00: begin
               o_bus_data    <= '0;
               o_bus_data[0] <= rdy;
               end
      'h1: begin 
               req           <= '1;
               cmd           <= '1;
               data          <= i_bus_data;
               o_bus_data    <= '0;
               end
      'h2: begin 
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

always @(posedge clk)
  begin
  arst_1  <= arst;
  arst_2  <= arst_1;
  arst_3  <= arst_2;
  SCK_rst <= arst_3;
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

st7735r_clk sck (
  .clk (clk),
  .rst (rst),
  
  .SCK_clk (SCK_clk),
  .SCK (SCK)
);

st7735r_transmit transmit (
  .SCK_clk   (SCK_clk),
  .clk       (clk),      
  .rst       (rst),      
                       
  .RS_DC     (RS_DC),    
  .DATA      (DATA),     
  .CS        (CS),       
                       
  .req       (~SCK_empty),      
  .cmd       (SCK_cmd),      
  .data      (SCK_data),     
                       
  .rd_done   ( rd_done ),
  .rdy       (rdy)       
);

endmodule
