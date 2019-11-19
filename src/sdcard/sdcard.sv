module sdcard #(
  parameter integer      SIZE = 2
) (
input  logic clk,
input  logic rst,
input  logic arst,

//////////// SPI //////////
output logic SPIReq,
input  logic SPIAck,
output logic SPIDone,

output logic SCK,
output logic RS_DC,
output logic MOSI,
output logic CS,
input  logic MISO,

//////////// BUS //////////
input  logic           i_bus_req,
input  logic           i_bus_write,
input  logic [31:0]    i_bus_addr,
input  logic [31:0]    i_bus_data,
input  logic  [3:0]    i_bus_data_rd_mask,
input  logic  [3:0]    i_bus_data_wr_mask,

output logic           o_bus_ack,
output logic [31:0]    o_bus_data
);

parameter PERIOD_20ns = 125;

parameter R1_BITS  = 1*8;
parameter R1B_BITS = 1*8;
parameter R2_BITS  = 2*8;
parameter R3_BITS  = 5*8;
parameter R7_BITS  = 5*8;

logic [15:0] sck_cnt;
logic        sck_put;

logic  [12:0] bits;
logic  [8:0]  rsp_bits;
logic  [12:0] data_bits;

logic [63:0] cmd;
logic [31:0] rspArrived;
logic [47:0] rsp;
logic             data_capture;
logic [512*8+16-1:0] data;
logic [8:0] data_32b_out;

logic [31:0] dataIn;
logic [31:0] dataArrived;
logic [31:0] dataOut;

logic state_idle;
logic state_spi_req;
logic state_cmd_sending;
logic state_rsp_pending;
logic state_rsp_recieved;
logic state_data_pending;
logic state_data_recieving;
logic state_data_recieved;

always_comb
  begin
  data_capture = cmd[63];
  rsp_bits = cmd[62:56]*8;
  end

always_ff @(posedge clk)
  begin
  state_idle           <= '0;
  state_spi_req        <= '0;
  state_cmd_sending    <= '0;
  state_rsp_pending    <= '0;
  state_rsp_recieved   <= '0;
  state_data_pending   <= '0;
  state_data_recieving <= '0;
  state_data_recieved  <= '0;

  SPIDone  <= '0;
  SPIReq   <= SPIReq;
  CS       <= CS;
  RS_DC    <= RS_DC;
  MOSI     <= MOSI; 

  cmd         <= cmd;         
  rspArrived  <= rspArrived;  
  rsp         <= rsp;         
  data        <= data;
  data_32b_out<= data_32b_out;
  dataIn      <= dataIn;      
  dataArrived <= dataArrived; 
  dataOut     <= dataOut;     

  o_bus_ack   <= '0;
  o_bus_data  <= '0;   

  unique
  case (1'b1)
  state_idle : begin
               if(i_bus_req)
                 begin
                 unique
                 case (i_bus_addr[31:2])
                   //NoOp
                   'h0000:  begin
                            o_bus_ack             <= '1;
                            state_idle <= '1;
                            end
                   //Cmd Send
                   'h0001:  begin 
                            if(i_bus_write)
                              begin
                              rspArrived            <= '0;
                              rsp                   <= '0;
                              SPIReq                <= '1;
                              state_spi_req         <= '1;
                              end
                            end
                   //Cmd Lo
                   'h0002:  begin 
                           if(i_bus_write)
                             begin
                             cmd[31:24]            <= i_bus_data_wr_mask ? i_bus_data[31:24] : cmd[31:24];
                             cmd[23:16]            <= i_bus_data_wr_mask ? i_bus_data[23:16] : cmd[23:16];
                             cmd[15:8]             <= i_bus_data_wr_mask ? i_bus_data[15:8]  : cmd[15:8] ;
                             cmd[7:0]              <= i_bus_data_wr_mask ? i_bus_data[7:0]   : cmd[7:0]  ;
                             end
                            o_bus_ack             <= '1;
                            o_bus_data[31:24]     <= i_bus_data_rd_mask ? cmd[31:24] : '0;
                            o_bus_data[23:16]     <= i_bus_data_rd_mask ? cmd[23:16] : '0;
                            o_bus_data[15:8]      <= i_bus_data_rd_mask ? cmd[15:8]  : '0;
                            o_bus_data[7:0]       <= i_bus_data_rd_mask ? cmd[7:0]   : '0;
                            state_idle <= '1;
                            end
                   //Cmd Hi
                   'h0003:  begin 
                            if(i_bus_write)
                              begin
                              cmd[63:56]            <= i_bus_data_wr_mask ? i_bus_data[31:24] : cmd[63:56] ;
                              cmd[55:48]            <= i_bus_data_wr_mask ? i_bus_data[23:16] : cmd[55:48] ;
                              cmd[47:40]            <= i_bus_data_wr_mask ? i_bus_data[15:8]  : cmd[47:40] ;
                              cmd[39:32]            <= i_bus_data_wr_mask ? i_bus_data[7:0]   : cmd[39:32] ;
                              end
                            o_bus_ack             <= '1;
                            o_bus_data[31:24]     <= i_bus_data_rd_mask ? cmd[63:56]  : '0;
                            o_bus_data[23:16]     <= i_bus_data_rd_mask ? cmd[55:48]  : '0;
                            o_bus_data[15:8]      <= i_bus_data_rd_mask ? cmd[47:40]  : '0;
                            o_bus_data[7:0]       <= i_bus_data_rd_mask ? cmd[39:32]  : '0;
                            state_idle <= '1;
                            end
                   //Rsp  Arrived
                   'h0004:  begin 
                            o_bus_ack             <= '1;
                            o_bus_data[31:24]     <= i_bus_data_rd_mask ? rspArrived[31:24] : '0;
                            o_bus_data[23:16]     <= i_bus_data_rd_mask ? rspArrived[23:16] : '0;
                            o_bus_data[15:8]      <= i_bus_data_rd_mask ? rspArrived[15:8]  : '0;
                            o_bus_data[7:0]       <= i_bus_data_rd_mask ? rspArrived[7:0]   : '0;
                            state_idle <= '1;
                            end
                   //Rsp Lo
                   'h0005:  begin 
                            o_bus_ack             <= '1;
                            o_bus_data[31:24]     <= i_bus_data_rd_mask ? rsp[31:24] : '0;
                            o_bus_data[23:16]     <= i_bus_data_rd_mask ? rsp[23:16] : '0;
                            o_bus_data[15:8]      <= i_bus_data_rd_mask ? rsp[15:8]  : '0;
                            o_bus_data[7:0]       <= i_bus_data_rd_mask ? rsp[7:0]   : '0;
                            state_idle <= '1;
                            end
                   //Rsp Hi
                   'h0006:  begin 
                            o_bus_ack             <= '1;
                            o_bus_data[15:8]      <= i_bus_data_rd_mask ? rsp[47:40]  : '0;
                            o_bus_data[7:0]       <= i_bus_data_rd_mask ? rsp[39:32]  : '0;
                            state_idle <= '1;
                            end
                   //Data
                   'h0007:  begin 
                            o_bus_ack             <= '1;
                            if(data_32b_out < 'd128) 
                              begin
                              for(int i = 0; i < 8; i++)
                                begin
                                o_bus_data[i+24]     <= i_bus_data_rd_mask ? data[31-i] : '0; //Reverse bytes to compensate for stream
                                o_bus_data[i+16]     <= i_bus_data_rd_mask ? data[23-i] : '0; //Reverse bytes to compensate for stream
                                o_bus_data[i+8]      <= i_bus_data_rd_mask ? data[15-i] : '0; //Reverse bytes to compensate for stream
                                o_bus_data[i+0]      <= i_bus_data_rd_mask ? data[7-i]  : '0; //Reverse bytes to compensate for stream
                                end
                              data <= {data[31:0],data[512*8+16-1:32]};
                              data_32b_out <= data_32b_out+1;
                              end
                            state_idle <= '1;
                            end
                   default: begin
                            o_bus_ack      <= '1;
                            o_bus_data[31:24]     <= i_bus_data_rd_mask ? i_bus_data[31:24] : '0;
                            o_bus_data[23:16]     <= i_bus_data_rd_mask ? i_bus_data[23:16] : '0;
                            o_bus_data[15:8]      <= i_bus_data_rd_mask ? i_bus_data[15:8]  : '0;
                            o_bus_data[7:0]       <= i_bus_data_rd_mask ? i_bus_data[7:0]   : '0;
                            state_idle <= '1;
                            end
                 endcase
                 end
               else
                 begin
                 state_idle <= '1;
                 end
               end
  state_spi_req : begin
                      if(SPIAck)
                        begin
                        bits              <= 'd48;
                        state_cmd_sending <= '1;
                        SPIReq                <= '0;
                        end
                      else
                        begin
                        state_spi_req <= '1;
                        end
                      end
  state_cmd_sending : begin
                      CS <= '0;
                      if(sck_put)
                        begin
                        if(bits == 'd0)
                          begin
                          state_rsp_pending    <= '1;
		          end
                        else
                          begin
                          MOSI <= cmd[bits - 'd1];
                          bits <= bits - 'd1;
                          state_cmd_sending    <= '1;
		          end
			end
                      else
                        begin
                        state_cmd_sending    <= '1;
			end
                      end
  state_rsp_pending : begin
                      if(sck_put)
                        begin
                        if(~MISO)
                          begin
                          bits <= 'd1;
                          rsp[0] <= '0;
                          state_rsp_recieved <= '1;
                          end
			else
			  begin
                          state_rsp_pending    <= '1;
                          end
			end
                      else
                        begin
                        state_rsp_pending    <= '1;
			end
                      end
  state_rsp_recieved : begin
                      if(sck_put)
                        begin
                        rsp <= {rsp[46:0],MISO};
                        if(bits == rsp_bits-1)
                          begin
                          if(data_capture)
                            begin
                            data <= '0;
                            rspArrived <= '1;  
                            state_data_pending <= '1;
                            end
			  else
			    begin
                            CS <= '1;
                            SPIDone    <= '1;
                            rspArrived <= '1;  
                            state_idle <= '1;
                            o_bus_ack  <= '1;
                            end
                          end
                        else
                          begin
                          bits <= bits + 'd1;
                          state_rsp_recieved <= '1;
                          end
                        end
                      else
                        begin
                        state_rsp_recieved <= '1;
			end
                      end
  state_data_pending : begin
                      if(sck_put)
                        begin
                       data <= {MISO,data[512*8+16-1:1]};
                       if({MISO,data[512*8+16-1:512*8+16-1-6]} == 'h7F)
                         begin
                         bits <= 'd1;
                         state_data_recieved <= '1;
                         end
                       else
                         begin
                         state_data_pending <= '1;
                         end
                        end
                      else
                        begin
                        state_data_pending <= '1;
			end
                       end
  state_data_recieved : begin
                      if(sck_put)
                        begin
                        data <= {MISO,data[512*8+16-1:1]};
                        if(bits == 512*8+16)
                          begin
                          CS <= '1;
                          SPIDone     <= '1;
                          dataArrived <= '1;  
                          state_idle  <= '1;
                          o_bus_ack   <= '1;
                          end
                        else
                          begin
                          bits <= bits + 'd1;
                          state_data_recieved <= '1;
                          end
                        end
                      else
                        begin
                        state_data_recieved <= '1;
			end
                        end
  default :    begin
               state_idle <= '1;
               end
  endcase
 
  if(rst)
    begin
    state_idle           <= '1;
    state_spi_req        <= '0;
    state_cmd_sending    <= '0;
    state_rsp_pending    <= '0;
    state_rsp_recieved   <= '0;
    state_data_pending   <= '0;
    state_data_recieved  <= '0;

    SPIReq   <= '0;
    CS    <= '1;
    RS_DC <= '0;
    MOSI  <= '1;

    cmd         <= '0;
    rspArrived  <= '0;
    rsp         <= '0;
    data        <= '0;
    dataIn      <= '0;
    dataArrived <= '0;
    dataOut     <= '0;
    end
  end

//Clock signal
always_ff @(posedge clk)
  begin
  sck_put <= '0;
  if(rst)
    begin
    SCK <= '0;
    sck_cnt <= '0;
    sck_put <= '0;
    end
  else
    begin
    if(sck_cnt >= PERIOD_20ns*1/4 && sck_cnt <= PERIOD_20ns*3/4)
      begin 
      SCK <= '1;
      end
    else
      begin
      SCK <= '0;
      end
    if(sck_cnt >= PERIOD_20ns)
      begin
      sck_put <= '1;
      sck_cnt <= '0;
      end
    else
      begin
      sck_cnt <= sck_cnt + 1;
      end
    end
  end

endmodule
