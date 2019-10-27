module spi (
input  logic clk,
input  logic rst,

output logic SCK,
output logic CS,
output logic RS_DC,
output logic DATA,

input  logic       req,
input  logic       cmd,
input  logic [7:0] data,

output logic     rd_done,
output logic     rdy
);

parameter PERIOD_20ns = 125;


logic [15:0] sck_cnt;
logic  [2:0] data_cnt;

always_ff @(posedge clk)
  begin

  integer unsigned data_ndx;

  rd_done <= '0;
  rdy      <= '1;
  CS       <= CS   ;
  RS_DC    <= RS_DC;
  DATA     <= DATA ;

  data_cnt <= data_cnt;

  if(data_cnt == 3'b000)
    data_ndx = 7;
  if(data_cnt == 3'b001)
    data_ndx = 6;
  if(data_cnt == 3'b010)
    data_ndx = 5;
  if(data_cnt == 3'b011)
    data_ndx = 4;
  if(data_cnt == 3'b100)
    data_ndx = 3;
  if(data_cnt == 3'b101)
    data_ndx = 2;
  if(data_cnt == 3'b110)
    data_ndx = 1;
  if(data_cnt == 3'b111)
    data_ndx = 0;

  if(sck_cnt==0)
  begin
    case (data_cnt)
      '0:       begin
                if(req)
                  begin
                  CS    <= '0;
                  RS_DC <= ~cmd;
                  DATA  <= data[data_ndx];
                  data_cnt <= data_cnt + 1;
                  end
                else
                  begin
                  CS <= '1;
                  end
                end
      'd7:      begin
		rd_done <= '1;
                DATA  <= data[data_ndx];
                data_cnt <= data_cnt + 1;
                end
      default:  begin
                DATA  <= data[data_ndx];
                data_cnt <= data_cnt + 1;
                end
    endcase
  end

  if(rst)
    begin
    CS       <= '1;
    RS_DC    <= '0;
    DATA     <= '0;
    data_cnt <= '0;       
    end
  end
          
//Clock signal
always_ff @(posedge clk)
  begin
  if(rst)
    begin
    SCK <= '0;
    sck_cnt <= '0;
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
      sck_cnt <= '0;
      end
    else
      begin
      sck_cnt <= sck_cnt + 1;
      end
    end
  end
endmodule

