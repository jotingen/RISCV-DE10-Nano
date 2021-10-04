import wishbone_pkg::*;

module ILI9486_buffer (
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

logic         buffer_R_0_wren;
logic [7:0]   buffer_R_0_out;
logic         buffer_R_1_wren;
logic [7:0]   buffer_R_1_out;
logic         buffer_R_2_wren;
logic [7:0]   buffer_R_2_out;
logic         buffer_G_0_wren;
logic [7:0]   buffer_G_0_out;
logic         buffer_G_1_wren;
logic [7:0]   buffer_G_1_out;
logic         buffer_G_2_wren;
logic [7:0]   buffer_G_2_out;
logic         buffer_B_0_wren;
logic [7:0]   buffer_B_0_out;
logic         buffer_B_1_wren;
logic [7:0]   buffer_B_1_out;
logic         buffer_B_2_wren;
logic [7:0]   buffer_B_2_out;

logic           membus_req;
logic           membus_ack;
logic           membus_write;
logic [31:0]    membus_addr;
logic [31:0]    membus_data;
logic  [3:0]    membus_data_rd_mask;
logic  [3:0]    membus_data_wr_mask;

logic         idle;
logic         accessing;


always_comb
  begin
  buffer_R_0_wren = '0;
  buffer_R_1_wren = '0;
  buffer_R_2_wren = '0;
  buffer_G_0_wren = '0;
  buffer_G_1_wren = '0;
  buffer_G_2_wren = '0;
  buffer_B_0_wren = '0;
  buffer_B_1_wren = '0;
  buffer_B_2_wren = '0;

  if(bus_data_i.Cyc & bus_data_i.Stb)
    begin
    if (bus_data_i.We & bus_data_i.Sel[0])
      begin
      if(bus_data_i.Adr[31:16] == 'h0000)
        begin
        buffer_B_0_wren = '1;
        end
      if(bus_data_i.Adr[31:16] == 'h0001)
        begin
        buffer_B_1_wren = '1;
        end
      if(bus_data_i.Adr[31:16] == 'h0010)
        begin
        buffer_B_2_wren = '1;
        end
      end
    if (bus_data_i.We & bus_data_i.Sel[1])
      begin
      if(bus_data_i.Adr[31:16] == 'h0000)
        begin
        buffer_G_0_wren = '1;
        end
      if(bus_data_i.Adr[31:16] == 'h0001)
        begin
        buffer_G_1_wren = '1;
        end
      if(bus_data_i.Adr[31:16] == 'h0010)
        begin
        buffer_G_2_wren = '1;
        end
      end
    if (bus_data_i.We & bus_data_i.Sel[2])
      begin
      if(bus_data_i.Adr[31:16] == 'h0000)
        begin
        buffer_R_0_wren = '1;
        end
      if(bus_data_i.Adr[31:16] == 'h0001)
        begin
        buffer_R_1_wren = '1;
        end
      if(bus_data_i.Adr[31:16] == 'h0010)
        begin
        buffer_R_2_wren = '1;
        end
      end
    end
  end

always_ff @(posedge clk)
  begin
  bus_data_o.Ack           <= '0;
  bus_data_o.Data          <= '0;

  idle <= '0;
  accessing <= '0;

  case(1'b1) 
  idle :      begin
              if(bus_data_i.Cyc & bus_data_i.Stb)
                begin
                accessing <= '1;
                end 
              else 
                begin
                  idle <= '1;
                end
              end
  accessing : begin
              idle <= '1;
              bus_data_o.Ack <= '1;
              if(bus_data_i.Adr[31:16] == 'h0000)
                begin
                bus_data_o.Data[7:0]     <= buffer_B_0_out;
                bus_data_o.Data[15:8]    <= buffer_G_0_out;
                bus_data_o.Data[23:16]   <= buffer_R_0_out;
                bus_data_o.Data[31:24]   <= '0;
                end
              if(bus_data_i.Adr[31:16] == 'h0001)
                begin
                bus_data_o.Data[7:0]     <= buffer_B_1_out;
                bus_data_o.Data[15:8]    <= buffer_G_1_out;
                bus_data_o.Data[23:16]   <= buffer_R_1_out;
                bus_data_o.Data[31:24]   <= '0;
                end
              if(bus_data_i.Adr[31:16] == 'h0010)
                begin
                bus_data_o.Data[7:0]     <= buffer_B_2_out;
                bus_data_o.Data[15:8]    <= buffer_G_2_out;
                bus_data_o.Data[23:16]   <= buffer_R_2_out;
                bus_data_o.Data[31:24]   <= '0;
                end
              end
    
  endcase
  
  if(rst) 
    begin
    idle <= '1;
    accessing <= '0;
    end
  end

endmodule
