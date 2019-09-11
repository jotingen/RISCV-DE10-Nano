module led #(
  parameter integer      SIZE = 4,
  parameter logic [31:0] ADDR_BASE = 32'h00000000
) (
  input  logic           clk,
  input  logic           rst,

  output logic  [7:0]    LED,

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

always_ff @(posedge clk)
  begin
  o_bus_req   <= i_bus_req;    
  o_bus_ack   <= i_bus_ack;    
  o_bus_write <= i_bus_write;  
  o_bus_addr  <= i_bus_addr;   
  o_bus_data  <= i_bus_data;   

  LED <= LED;

  if(i_bus_req &
     i_bus_addr >= ADDR_BASE &
     i_bus_addr <= ADDR_BASE + 2**SIZE - 1)
    begin
    o_bus_req <= '0;    
    o_bus_ack <= '1;
    case (i_bus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2])
      'd0:     begin
               if (i_bus_write)
                 begin
                 LED[7:0]        <= i_bus_data[7:0];
                 end
               o_bus_data      <= '0;
               o_bus_data[7:0] <= LED[7:0];
               end
      default: begin
               o_bus_data      <= '0;
               end
    endcase
    end

  if(rst)
    begin
    LED <= 'hAA;
    end

  end

endmodule
