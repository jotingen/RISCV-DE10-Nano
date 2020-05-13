import wishbone_pkg::*;

module mem #(
  parameter SIZE = 15
) (
  input  logic           clk,
  input  logic           rst,

  input  logic [$bits(wishbone_pkg::bus_req_t)-1:0] bus_inst_flat_i,
  output logic [$bits(wishbone_pkg::bus_rsp_t)-1:0] bus_inst_flat_o,

  input  logic [$bits(wishbone_pkg::bus_req_t)-1:0] bus_data_flat_i,
  output logic [$bits(wishbone_pkg::bus_rsp_t)-1:0] bus_data_flat_o
);

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

logic [7:0] mem_array_3 [2**(SIZE-2)-1:0];
logic [7:0] mem_array_2 [2**(SIZE-2)-1:0];
logic [7:0] mem_array_1 [2**(SIZE-2)-1:0];
logic [7:0] mem_array_0 [2**(SIZE-2)-1:0];

//Instruction bus
always_ff @(posedge clk)
  begin
  bus_inst_o.Ack         <= bus_inst_i.Cyc & bus_inst_i.Stb;    
  bus_inst_o.Stall       <= '0;
  bus_inst_o.Err         <= '0;
  bus_inst_o.Rty         <= '0;
  bus_inst_o.Data[31:24] <= {8{bus_inst_i.Sel[3]}} & mem_array_3[bus_inst_i.Adr[SIZE+2:2]];
  bus_inst_o.Data[23:16] <= {8{bus_inst_i.Sel[2]}} & mem_array_2[bus_inst_i.Adr[SIZE+2:2]];
  bus_inst_o.Data[15:8]  <= {8{bus_inst_i.Sel[1]}} & mem_array_1[bus_inst_i.Adr[SIZE+2:2]];
  bus_inst_o.Data[7:0]   <= {8{bus_inst_i.Sel[0]}} & mem_array_0[bus_inst_i.Adr[SIZE+2:2]];
  bus_inst_o.Tga         <= bus_inst_i.Tga;
  bus_inst_o.Tgd         <= bus_inst_i.Tgd;
  bus_inst_o.Tgc         <= bus_inst_i.Tgc;
  end


//Memory bus
always_ff @(posedge clk)
  begin
  if (bus_data_i.Cyc & bus_data_i.Stb)
  begin     
    if (bus_data_i.We & bus_data_i.Sel[0])
      begin
      mem_array_0[bus_data_i.Adr[SIZE+2:2]] <= bus_data_i.Data[7:0];
      end
    if (bus_data_i.We & bus_data_i.Sel[1])
      begin
      mem_array_1[bus_data_i.Adr[SIZE+2:2]] <= bus_data_i.Data[15:8];
      end
    if (bus_data_i.We & bus_data_i.Sel[2])
      begin
      mem_array_2[bus_data_i.Adr[SIZE+2:2]] <= bus_data_i.Data[23:16];
      end
    if (bus_data_i.We & bus_data_i.Sel[3])
      begin
      mem_array_3[bus_data_i.Adr[SIZE+2:2]] <= bus_data_i.Data[31:24];
      end
  end

  bus_data_o.Ack         <= bus_data_i.Cyc & bus_data_i.Stb;    
  bus_data_o.Stall       <= '0;
  bus_data_o.Err         <= '0;
  bus_data_o.Rty         <= '0;
  bus_data_o.Data[31:24] <= {8{bus_data_i.Sel[3]}} & mem_array_3[bus_data_i.Adr[SIZE+2:2]];
  bus_data_o.Data[23:16] <= {8{bus_data_i.Sel[2]}} & mem_array_2[bus_data_i.Adr[SIZE+2:2]];
  bus_data_o.Data[15:8]  <= {8{bus_data_i.Sel[1]}} & mem_array_1[bus_data_i.Adr[SIZE+2:2]];
  bus_data_o.Data[7:0]   <= {8{bus_data_i.Sel[0]}} & mem_array_0[bus_data_i.Adr[SIZE+2:2]];
  bus_data_o.Tga         <= bus_data_i.Tga;
  bus_data_o.Tgd         <= bus_data_i.Tgd;
  bus_data_o.Tgc         <= bus_data_i.Tgc;
  end

initial
  begin
    //$readmemh("../../output/programs/bootloader/bootloader_3.v", mem_array_3);
    //$readmemh("../../output/programs/bootloader/bootloader_2.v", mem_array_2);
    //$readmemh("../../output/programs/bootloader/bootloader_1.v", mem_array_1);
    //$readmemh("../../output/programs/bootloader/bootloader_0.v", mem_array_0);

    //$readmemh("../../output/programs/bootloader/bootloader_fast_3.v", mem_array_3);
    //$readmemh("../../output/programs/bootloader/bootloader_fast_2.v", mem_array_2);
    //$readmemh("../../output/programs/bootloader/bootloader_fast_1.v", mem_array_1);
    //$readmemh("../../output/programs/bootloader/bootloader_fast_0.v", mem_array_0);

    //$readmemh("../../output/programs/bootloader/bootloader_preloaded_3.v", mem_array_3);
    //$readmemh("../../output/programs/bootloader/bootloader_preloaded_2.v", mem_array_2);
    //$readmemh("../../output/programs/bootloader/bootloader_preloaded_1.v", mem_array_1);
    //$readmemh("../../output/programs/bootloader/bootloader_preloaded_0.v", mem_array_0);
  end

endmodule
