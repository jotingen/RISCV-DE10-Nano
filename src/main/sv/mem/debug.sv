import wishbone_pkg::*;

module debug #(
  parameter SIZE = 15
) (
  input  logic           clk,
  input  logic           rst,

  input  logic [$bits(wishbone_pkg::bus_req_t)-1:0] bus_inst_flat_i,
  output logic [$bits(wishbone_pkg::bus_rsp_t)-1:0] bus_inst_flat_o,

  input  logic [$bits(wishbone_pkg::bus_req_t)-1:0] bus_data_flat_i,
  output logic [$bits(wishbone_pkg::bus_rsp_t)-1:0] bus_data_flat_o
);

logic	[31:0]  q_a;
logic	[31:0]  q_b;

wishbone_pkg::bus_req_t bus_inst_i;
wishbone_pkg::bus_rsp_t bus_inst_o;
wishbone_pkg::bus_req_t bus_data_i;
wishbone_pkg::bus_rsp_t bus_data_o;
always_comb
begin
  bus_inst_i      = bus_inst_flat_i;
  bus_inst_flat_o = bus_inst_o;
  bus_data_i      = bus_data_flat_i;
  bus_data_flat_o = bus_data_o;
end

ram_debug ram (
  .clock (clk),
  .address_a (bus_inst_i.Adr[9:2]),
  .wren_a    (bus_inst_i.Cyc &
              bus_inst_i.Stb &
              bus_inst_i.We),
  .byteena_a (bus_inst_i.Sel[3:0]),
  .data_a    (bus_inst_i.Data[31:0]),
  .q_a       (q_a),
  .address_b (bus_data_i.Adr[9:2]),
  .wren_b    (bus_data_i.Cyc &
              bus_data_i.Stb &
              bus_data_i.We),
  .byteena_b (bus_data_i.Sel[3:0]),
  .data_b    (bus_data_i.Data[31:0]),
  .q_b       (q_b));
  
//Instruction bus
always_ff @(posedge clk)
  begin
  bus_inst_o.Ack         <= bus_inst_i.Cyc & bus_inst_i.Stb;    
  bus_inst_o.Stall       <= '0;
  bus_inst_o.Err         <= '0;
  bus_inst_o.Rty         <= '0;
  bus_inst_o.Tga         <= bus_inst_i.Tga;
  bus_inst_o.Tgd         <= bus_inst_i.Tgd;
  bus_inst_o.Tgc         <= bus_inst_i.Tgc;
  end
always_comb
begin
  bus_inst_o.Data = '0;
  bus_inst_o.Data = {q_a[31:0]};
end


//Memory bus
always_ff @(posedge clk)
  begin
  bus_data_o.Ack         <= bus_data_i.Cyc & bus_data_i.Stb;    
  bus_data_o.Stall       <= '0;
  bus_data_o.Err         <= '0;
  bus_data_o.Rty         <= '0;
  bus_data_o.Tga         <= bus_data_i.Tga;
  bus_data_o.Tgd         <= bus_data_i.Tgd;
  bus_data_o.Tgc         <= bus_data_i.Tgc;
  end
always_comb
begin
  bus_data_o.Data = '0;
  bus_data_o.Data = {q_b[31:0]};
end


endmodule
