module mem #(
  parameter logic [31:0] ADDR_LO = 32'h00000000,
  parameter logic [31:0] ADDR_HI = 32'h0007FFFF
) (
  input  logic           clk,
  input  logic           rst,

  input  logic           bus_req,
  output logic           bus_ack,
  input  logic           bus_write,
  input  logic [31:0]    bus_addr,
  inout  logic [31:0]    bus_data

);

logic [7:0] mem_array_3 [2**(18-2)-1:0];
logic [7:0] mem_array_2 [2**(18-2)-1:0];
logic [7:0] mem_array_1 [2**(18-2)-1:0];
logic [7:0] mem_array_0 [2**(18-2)-1:0];

typedef enum {
  IDLE,
  ACCESS,
  DATA
} mem_state_s;

mem_state_s mem_state;

logic wr;
logic rd;
logic [18:2] addr;      //512KB
logic [18:2] addr_stgd;
logic [31:0] data;
logic [31:0] q;

logic put_data;
assign bus_data = put_data ? q : 'z;
always_ff @(posedge clk)
  begin
  bus_ack  <= 'z;
  wr   <= '0;
  rd   <= '0;
  addr_stgd <= addr;
  addr <= addr;
  data <= data;
  //mem_array <= mem_array;
  put_data <= '0;
  case(mem_state)
    IDLE : begin
           if(bus_req &
	      bus_addr >= ADDR_LO &
	      bus_addr <= ADDR_HI)
             begin
             mem_state <= ACCESS;
             wr <= bus_write;
             addr <= bus_addr[18:2] - ADDR_LO[18:2];
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
             if(wr)
               begin
               mem_state <= IDLE;
               //mem_array[addr+3] <= data[31:24];
               //mem_array[addr+2] <= data[23:16];
               //mem_array[addr+1] <= data[15:8];
               //mem_array[addr+0] <= data[7:0];
               end
             else
               begin
               mem_state <= DATA;
               //q[31:24] <= mem_array[addr+3];
               //q[23:16] <= mem_array[addr+2];
               //q[15:8]  <= mem_array[addr+1];
               //q[7:0]   <= mem_array[addr+0];
               end
             end
    DATA : begin
           mem_state <= IDLE;
           bus_ack <= '1;
           put_data <= '1;
           end
  endcase
  end
             
always_ff @(posedge clk)
  begin
  if (wr)
    begin
    mem_array_0[addr] <= data[7:0];
    mem_array_1[addr] <= data[15:8];
    mem_array_2[addr] <= data[23:16];
    mem_array_3[addr] <= data[31:24];
    end
  q[7:0]   <= mem_array_0[addr_stgd];
  q[15:8]  <= mem_array_1[addr_stgd];
  q[23:16] <= mem_array_2[addr_stgd];
  q[31:24] <= mem_array_3[addr_stgd];
  end
//ram_1r1w_64kbx32b ram (
//	.address ( addr ),
//	.clock   ( clk ),
//	.data    ( data ),
//	.rden    ( rd ),
//	.wren    ( wr ),
//	.q       ( q )
//	);

endmodule

