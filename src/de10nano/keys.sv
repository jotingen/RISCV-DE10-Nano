import wishbone_pkg::*;

module keys #(
  parameter integer      SIZE = 2,
  parameter logic [31:0] ADDR_BASE = 32'h00000000
) (
  input  logic           clk,
  input  logic           rst,

  input  logic  [1:0]    KEY,

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
  bus_data_o.Ack   <= '0;    
  bus_data_o.Data  <= bus_data_i.Data;   

  if(bus_data_i.Cyc &
     bus_data_i.Stb &
     bus_data_i.Adr >= ADDR_BASE &
     bus_data_i.Adr <= ADDR_BASE + 2**SIZE - 1)
    begin
    bus_data_o.Ack <= '1;
    case (bus_data_i.Adr[SIZE+2:2] - ADDR_BASE[SIZE+2:2])
      'd0:     begin
               bus_data_o.Data <= '0;
               bus_data_o.Data <= BUTTON[0];
               end
      'd1:     begin
               bus_data_o.Data <= '0;
               bus_data_o.Data <= BUTTON[1];
               end
      default: begin
               bus_data_o.Data <= '0;
               end
    endcase
    end
  end


endmodule
