import wishbone_pkg::*;

module ddr3_cntl #(
  parameter integer      SIZE = 4,
  parameter logic [31:0] ADDR_BASE = 32'h00000000
) (
  input  logic           clk,
  input  logic           rst,

  output logic           flushStart,
  input  logic           flushDone,

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

logic flushing;

always_ff @(posedge clk)
  begin
  bus_data_o.Ack   <= '0;   
  bus_data_o.Stall <= '0; //bus_data_o.Stall; 
  bus_data_o.Err   <= '0; //bus_data_o.Err;   
  bus_data_o.Rty   <= '0; //bus_data_o.Rty;   
  bus_data_o.Data  <= '0; //bus_data_o.Data;  
  bus_data_o.Tga   <= '0; //bus_data_o.Tga;   
  bus_data_o.Tgd   <= '0; //bus_data_o.Tgd;   
  bus_data_o.Tgc   <= '0; //bus_data_o.Tgc;   

  flushing   <= flushing;
  flushStart <= '0;

  if(flushing)
  begin
    if(flushDone)
    begin
      bus_data_o.Ack <= '1;
      bus_data_o.Data      <= '0;
      flushing <= '0;
      flushStart <= '0;
    end
  end
  else if(bus_data_i.Stb &
          bus_data_i.Cyc)
    begin
    case (bus_data_i.Adr[SIZE+2:2])
      'd0:     begin
               if (bus_data_i.We & bus_data_i.Sel[0])
               begin
                 if(bus_data_i.Data[0])
                 begin
                   flushing   <= '1;
                   flushStart <= '1;
                 end
                 else
                 begin
                   bus_data_o.Ack <= '1;
                   bus_data_o.Data      <= '0;
                 end
               end
               end
      default: begin
               bus_data_o.Data      <= '0;
               end
    endcase
    end

  if(rst)
    begin
    flushing <= '0;
    flushStart <= '0;
    end

  end

endmodule
