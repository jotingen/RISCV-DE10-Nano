import wishbone_pkg::*;

module uart (
  input logic clk,
  input logic rst,
  
  output logic GND,
  output logic TXD,
  input  logic RXD,
  input  logic CTS,
  output logic RTS,

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

logic [12:0] clk_cnt;

logic [31:0] baud_rate;

logic [11:0] msg;
logic [3:0]  msg_bit;

logic state_idle;
logic state_sending;

assign GND = '0;
assign RTS = '0;

always_ff @(posedge clk)
  begin
  state_idle    <= '0;
  state_sending <= '0;

  bus_data_o.Ack   <= '0;   
  bus_data_o.Stall <= '0; //bus_data_o.Stall; 
  bus_data_o.Err   <= '0; //bus_data_o.Err;   
  bus_data_o.Rty   <= '0; //bus_data_o.Rty;   
  bus_data_o.Data  <= '0; //bus_data_o.Data;  
  bus_data_o.Tga   <= '0; //bus_data_o.Tga;   
  bus_data_o.Tgd   <= '0; //bus_data_o.Tgd;   
  bus_data_o.Tgc   <= '0; //bus_data_o.Tgc;   

  msg_bit <= msg_bit;
  clk_cnt <= clk_cnt;
  baud_rate <= baud_rate;

  TXD <= TXD;

  if(bus_data_i.Stb & bus_data_i.Cyc)
    begin
    case (bus_data_i.Adr[31:2])
      'd0:     begin
               state_sending <= '1;
               msg <= {2'b11,
                       ^bus_data_i.Data[31:24],
                       bus_data_i.Data[31:24],
                       1'b0};
               bus_data_o.Data <= '0;
               bus_data_o.Data <= '0;
               end
      'd1:     begin
               state_idle    <= '1;
               baud_rate <= {bus_data_i.Data[7:0],   
                             bus_data_i.Data[15:8],    
                             bus_data_i.Data[23:16],  
                             bus_data_i.Data[31:24]};
               bus_data_o.Ack <= '1;
               bus_data_o.Data <= '0;
               end
      default: begin
               state_idle    <= '1;
               bus_data_o.Ack <= '1;
               bus_data_o.Data <= '0;
               end
    endcase
    end
  else
    begin
    state_idle    <= '1;
    end


  if(state_sending)
    begin
    clk_cnt <= clk_cnt + 1;
    if(clk_cnt == baud_rate)
      begin
      TXD <= msg[msg_bit];
      msg_bit <= msg_bit + 1;
      clk_cnt   <= '0;
      if(msg_bit == 'd11)
        begin
        bus_data_o.Ack <= '1;
        msg_bit <= '0;
        state_idle <= '1;
        end
      else
        begin
        state_sending <= '1;
        end
      end
    else
      begin
      state_sending <= '1;
      end
    end

  if(rst)
    begin
    TXD <= '1;
    state_idle <= '1;
    state_sending <= '0;
    msg_bit <= '0;
    clk_cnt <= '0;
    baud_rate <= 'd5050;
    end
  end

endmodule
