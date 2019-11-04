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

logic [15:0] sck_cnt;
logic        sck_put;

logic  [8:0] bits;

logic [7:0] data;
logic       rdy;

logic [47:0] command;
logic  [2:0] command_cnt;
logic        command_rdy;
logic        command_rd_done;

logic [47:0] cmd;
logic [31:0] rspArrived;
logic [47:0] rsp;
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

  CS    <= CS;
  RS_DC <= RS_DC;
  MOSI  <= MOSI; 

  cmd         <= cmd;         
  rspArrived  <= rspArrived;  
  rsp         <= rsp;         
  dataIn      <= dataIn;      
  dataArrived <= dataArrived; 
  dataOut     <= dataOut;     

  data <= data;

  o_bus_ack   <= '0;
  o_bus_data  <= '0;   

  unique
  case (1'b1)
  state_idle : begin
               if(i_bus_req)
                 begin
                 if(i_bus_write)
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
                              SPIReq                <= '1;
                              state_spi_req         <= '1;
                              end
                     //Cmd Lo
                     'h0002:  begin 
                              cmd[31:24]            <= i_bus_data_wr_mask ? i_bus_data[31:24] : cmd[31:24];
                              cmd[23:16]            <= i_bus_data_wr_mask ? i_bus_data[23:16] : cmd[23:16];
                              cmd[15:8]             <= i_bus_data_wr_mask ? i_bus_data[15:8]  : cmd[15:8] ;
                              cmd[7:0]              <= i_bus_data_wr_mask ? i_bus_data[7:0]   : cmd[7:0]  ;
                              o_bus_ack             <= '1;
                              state_idle <= '1;
                              end
                     //Cmd Hi
                     'h0003:  begin 
                              cmd[47:40]            <= i_bus_data_wr_mask ? i_bus_data[15:8]  : cmd[47:40] ;
                              cmd[39:32]            <= i_bus_data_wr_mask ? i_bus_data[7:0]   : cmd[39:32] ;
                              o_bus_ack             <= '1;
                              state_idle <= '1;
                              end
                     default: begin
                              o_bus_ack      <= '1;
                              o_bus_data[31:24]     <= i_bus_data_wr_mask ? i_bus_data[31:24] : '0;
                              o_bus_data[23:16]     <= i_bus_data_wr_mask ? i_bus_data[23:16] : '0;
                              o_bus_data[15:8]      <= i_bus_data_wr_mask ? i_bus_data[15:8]  : '0;
                              o_bus_data[7:0]       <= i_bus_data_wr_mask ? i_bus_data[7:0]   : '0;
                              state_idle <= '1;
                              end
                   endcase
                   end
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
                        end
                      else
                        begin
                        state_spi_req <= '1;
                        end
                      end
  state_cmd_sending : begin
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
                          rsp <= '1;
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
                        if(bits == 'd7)
                          begin
                          rspArrived <= '1;  
                          state_idle <= '1;
                          o_bus_ack  <= '1;
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
    state_data_recieving <= '0;
    state_data_recieved  <= '0;

    CS    <= '0;
    RS_DC <= '0;
    MOSI  <= '1;

    cmd         <= '0;
    rspArrived  <= '0;
    rsp         <= '0;
    dataIn      <= '0;
    dataArrived <= '0;
    dataOut     <= '0;
    end
  end

//assign SCK_ack = '1;
//spi spi (
//  .clk     (clk    ),
//  .rst     (rst    ),
//        
//  .SPIReq  (SPIReq ),
//  .SPIAck  (SPIAck ),
//  .SPIDone (SPIDone),
//
//  .SCK     (SCK    ),
//  .CS      (CS     ),
//  .RS_DC   (RS_DC  ),
//  .DATA    (DATA   ),
//        
//  .ack     (SCK_ack),      
//  .req     (SCK_req),      
//  .cmd     (SCK_cmd),      
//  .data    (SCK_data),     
//  .bytes   (SCK_bytes),      
//        
//  .rdy     (rdy    )
//);

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
