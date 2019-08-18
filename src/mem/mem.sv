module mem #(
  parameter logic [31:0] ADDR_LO = 32'h00000000,
  parameter logic [31:0] ADDR_HI = 32'h0000FFFF
) (
  input  logic           clk,
  input  logic           rst,

  input  logic           bus_req,
  output logic           bus_ack,
  input  logic           bus_write,
  input  logic [31:0]    bus_addr,
  inout  logic [31:0]    bus_data

);

typedef enum {
  IDLE,
  ACCESS,
  DATA
} mem_state_s;

mem_state_s mem_state;

logic wr;
logic rd;
logic [15:0] addr;
logic [31:0] data;
logic [31:0] q;

logic put_data;
assign bus_data = put_data ? q : 'z;
always_ff @(posedge clk)
  begin
  bus_ack  <= 'z;
  wr   <= '0;
  rd   <= '0;
  addr <= addr;
  data <= data;
  put_data <= '0;
  case(mem_state)
    IDLE : begin
           if(bus_req &
	      bus_addr >= ADDR_LO &
	      bus_addr <= ADDR_HI)
             begin
             mem_state <= ACCESS;
             wr <= bus_write;
             addr <= bus_addr - ADDR_LO;
             if(bus_write)
               begin
               wr <= '1;
               data <= bus_data;
               end
             else           
               begin
               rd <= '1;
               end
             end
           end
    ACCESS : begin
             mem_state <= DATA;
             end
    DATA : begin
           mem_state <= IDLE;
           bus_ack <= '1;
           put_data <= '1;
           end
  endcase
  end
             
ram_1r1w_64kbx32b ram (
	.address ( addr ),
	.clock   ( clk ),
	.data    ( data ),
	.rden    ( rd ),
	.wren    ( wr ),
	.q       ( q )
	);

endmodule

