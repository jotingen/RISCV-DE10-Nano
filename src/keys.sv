module keys #(
  parameter integer      SIZE = 2,
  parameter logic [31:0] ADDR_BASE = 32'h00000000
) (
  input  logic           clk,
  input  logic           rst,

  input  logic  [1:0]    KEY,

  input  logic           i_bus_req,
  input  logic           i_bus_ack,
  input  logic           i_bus_write,
  input  logic [31:0]    i_bus_addr,
  input  logic [31:0]    i_bus_data,
  input  logic  [3:0]    i_bus_data_rd_mask,
  input  logic  [3:0]    i_bus_data_wr_mask,

  output logic           o_bus_req,
  output logic           o_bus_ack,
  output logic           o_bus_write,
  output logic [31:0]    o_bus_addr,
  output logic [31:0]    o_bus_data,
  output logic  [3:0]    o_bus_data_rd_mask,
  output logic  [3:0]    o_bus_data_wr_mask
);

logic  [1:0]    BUTTON;

always_ff @(posedge clk)
  begin
  BUTTON[1] <= ~KEY[1];
  BUTTON[0] <= ~KEY[0];
  if(rst)
    begin
    BUTTON[1] <= '0;
    BUTTON[0] <= '0;
    end
  end

always_ff @(posedge clk)
  begin
  o_bus_req   <= i_bus_req;    
  o_bus_ack   <= i_bus_ack;    
  o_bus_write <= i_bus_write;  
  o_bus_addr  <= i_bus_addr;   
  o_bus_data  <= i_bus_data;   
  o_bus_data_rd_mask  <= i_bus_data_rd_mask;   
  o_bus_data_wr_mask  <= i_bus_data_wr_mask;   

  if(i_bus_req &
     i_bus_addr >= ADDR_BASE &
     i_bus_addr <= ADDR_BASE + 2**SIZE - 1)
    begin
    o_bus_req <= '0;    
    o_bus_ack <= '1;
    case (i_bus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2])
      'd0:     begin
               o_bus_data <= '0;
               o_bus_data <= BUTTON[0];
               end
      'd1:     begin
               o_bus_data <= '0;
               o_bus_data <= BUTTON[1];
               end
      default: begin
               o_bus_data <= '0;
               end
    endcase
    end
  end


endmodule
