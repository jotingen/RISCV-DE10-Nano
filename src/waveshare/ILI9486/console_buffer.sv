import wishbone_pkg::*;

module console_buffer (
  input  logic           clk,
  input  logic           rst,

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

logic [7:0] mem_array_3 [2399:0];
logic [7:0] mem_array_2 [2399:0];
logic [7:0] mem_array_1 [2399:0];
logic [7:0] mem_array_0 [2399:0];

`ifdef RISCV_FORMAL
logic [19:0][7:0] dbg_console_00;
logic [19:0][7:0] dbg_console_01;
logic [19:0][7:0] dbg_console_02;
logic [19:0][7:0] dbg_console_03;
logic [19:0][7:0] dbg_console_04;
logic [19:0][7:0] dbg_console_05;
logic [19:0][7:0] dbg_console_06;
logic [19:0][7:0] dbg_console_07;
logic [19:0][7:0] dbg_console_08;
logic [19:0][7:0] dbg_console_09;
logic [19:0][7:0] dbg_console_10;
logic [19:0][7:0] dbg_console_11;
logic [19:0][7:0] dbg_console_12;
logic [19:0][7:0] dbg_console_13;
logic [19:0][7:0] dbg_console_14;
logic [19:0][7:0] dbg_console_15;
always_comb
  begin
  for(int x = 0; x < 20; x++)
    begin
    dbg_console_00[x] = { << {mem_array_0[00*20 + x]}};
    dbg_console_01[x] = { << {mem_array_0[01*20 + x]}};
    dbg_console_02[x] = { << {mem_array_0[02*20 + x]}};
    dbg_console_03[x] = { << {mem_array_0[03*20 + x]}};
    dbg_console_04[x] = { << {mem_array_0[04*20 + x]}};
    dbg_console_05[x] = { << {mem_array_0[05*20 + x]}};
    dbg_console_06[x] = { << {mem_array_0[06*20 + x]}};
    dbg_console_07[x] = { << {mem_array_0[07*20 + x]}};
    dbg_console_08[x] = { << {mem_array_0[08*20 + x]}};
    dbg_console_09[x] = { << {mem_array_0[09*20 + x]}};
    dbg_console_10[x] = { << {mem_array_0[10*20 + x]}};
    dbg_console_11[x] = { << {mem_array_0[11*20 + x]}};
    dbg_console_12[x] = { << {mem_array_0[12*20 + x]}};
    dbg_console_13[x] = { << {mem_array_0[13*20 + x]}};
    dbg_console_14[x] = { << {mem_array_0[14*20 + x]}};
    dbg_console_15[x] = { << {mem_array_0[15*20 + x]}};
    end
  end
`endif

always_ff @(posedge clk)
  begin
  bus_data_o.Ack   <= '0;   
  bus_data_o.Data  <= '0;   

  if(bus_data_i.Cyc & bus_data_i.Stb)
    begin
    bus_data_o.Ack <= '1;
    if (bus_data_i.We & bus_data_i.Sel[0])
      begin
      mem_array_0[bus_data_i.Adr[31:2]] <= bus_data_i.Data[7:0];
      end
    if (bus_data_i.We & bus_data_i.Sel[1])
      begin
      mem_array_1[bus_data_i.Adr[31:2]] <= bus_data_i.Data[15:8];
      end
    if (bus_data_i.We & bus_data_i.Sel[2])
      begin
      mem_array_2[bus_data_i.Adr[31:2]] <= bus_data_i.Data[23:16];
      end
    if (bus_data_i.We & bus_data_i.Sel[3])
      begin
      mem_array_3[bus_data_i.Adr[31:2]] <= bus_data_i.Data[31:24];
      end
    bus_data_o.Data[7:0]   <= mem_array_0[bus_data_i.Adr[31:2]];
    bus_data_o.Data[15:8]  <= mem_array_1[bus_data_i.Adr[31:2]];
    bus_data_o.Data[23:16] <= mem_array_2[bus_data_i.Adr[31:2]];
    bus_data_o.Data[31:24] <= mem_array_3[bus_data_i.Adr[31:2]];
    end
  end

endmodule
