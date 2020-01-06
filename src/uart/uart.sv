module uart (
  input logic clk,
  input logic rst,
  
  output logic GND,
  output logic TXD,
  input  logic RXD,
  input  logic CTS,
  output logic RTS,

  input  logic           i_bus_req,
  input  logic           i_bus_write,
  input  logic [31:0]    i_bus_addr,
  input  logic [31:0]    i_bus_data,
  input  logic  [3:0]    i_bus_data_rd_mask,
  input  logic  [3:0]    i_bus_data_wr_mask,

  output logic           o_bus_ack,
  output logic [31:0]    o_bus_data
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

  o_bus_ack   <= '0;    
  o_bus_data  <= i_bus_data;   

  msg_bit <= msg_bit;
  clk_cnt <= clk_cnt;
  baud_rate <= baud_rate;

  TXD <= TXD;

  if(i_bus_req)
    begin
    case (i_bus_addr[31:2])
      'd0:     begin
               state_sending <= '1;
               msg <= {2'b11,
                       ^i_bus_data[7:0],
                       i_bus_data[7:0],
                       1'b0};
               o_bus_data <= '0;
               o_bus_data <= '0;
               end
      'd1:     begin
               state_idle    <= '1;
               baud_rate <= i_bus_data;
               o_bus_ack <= '1;
               o_bus_data <= '0;
               end
      default: begin
               state_idle    <= '1;
               o_bus_ack <= '1;
               o_bus_data <= '0;
               end
    endcase
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
        o_bus_ack <= '1;
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
    state_idle <= '1;
    state_sending <= '0;
    msg_bit <= '0;
    clk_cnt <= '0;
    baud_rate <= 'd5050;
    end
  end

endmodule
