module uart (
  input logic clk,
  input logic rst,
  
  output logic GND,
  output logic TXD,
  input  logic RXD,
  input  logic CTS,
  output logic RTS,

  input  logic [31:0]    bus_adr_i,
  input  logic [31:0]    bus_data_i,
  input  logic           bus_we_i,
  input  logic  [3:0]    bus_sel_i,
  input  logic           bus_stb_i,
  input  logic           bus_cyc_i,
  input  logic           bus_tga_i,
  input  logic           bus_tgd_i,
  input  logic  [3:0]    bus_tgc_i,

  output logic           bus_ack_o,
  output logic           bus_stall_o,
  output logic           bus_err_o,
  output logic           bus_rty_o,
  output logic [31:0]    bus_data_o,
  output logic           bus_tga_o,
  output logic           bus_tgd_o,
  output logic  [3:0]    bus_tgc_o
);

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

  bus_ack_o   <= '0;   
  bus_stall_o <= '0; //bus_stall_o; 
  bus_err_o   <= '0; //bus_err_o;   
  bus_rty_o   <= '0; //bus_rty_o;   
  bus_data_o  <= '0; //bus_data_o;  
  bus_tga_o   <= '0; //bus_tga_o;   
  bus_tgd_o   <= '0; //bus_tgd_o;   
  bus_tgc_o   <= '0; //bus_tgc_o;   

  msg_bit <= msg_bit;
  clk_cnt <= clk_cnt;
  baud_rate <= baud_rate;

  TXD <= TXD;

  if(bus_stb_i & bus_cyc_i)
    begin
    case (bus_adr_i[31:2])
      'd0:     begin
               state_sending <= '1;
               msg <= {2'b11,
                       ^bus_data_i[7:0],
                       bus_data_i[7:0],
                       1'b0};
               bus_data_o <= '0;
               bus_data_o <= '0;
               end
      'd1:     begin
               state_idle    <= '1;
               baud_rate <= bus_data_i;
               bus_ack_o <= '1;
               bus_data_o <= '0;
               end
      default: begin
               state_idle    <= '1;
               bus_ack_o <= '1;
               bus_data_o <= '0;
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
        bus_ack_o <= '1;
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
