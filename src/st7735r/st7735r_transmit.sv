module st7735r_transmit (
input  logic SCK_clk,
input  logic clk,
input  logic rst,

output logic RS_DC,
output logic DATA,
output logic CS,

input  logic       req,
input  logic       cmd,
input  logic [7:0] data,

output logic     rd_done,
output logic     rdy
);

logic [20:0] cooldown_cnt;
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
  cooldown_cnt <= cooldown_cnt;

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

  if(SCK_clk)
  begin
    case (data_cnt)
      '0:       begin
                if(cooldown_cnt != 0)
                  begin
                  CS    <= '1;
        	  rdy   <= '0;
                  cooldown_cnt <= cooldown_cnt - 1;
                  end
                else if(req)
                  begin
                  CS    <= '0;
                  RS_DC <= ~cmd;
                  DATA  <= data[data_ndx];
                  data_cnt <= data_cnt + 1;
                  //cooldown_cnt <= 'd625000;
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
    cooldown_cnt <= 'd625000; //Power on with a cooldown timer 
    end
  end
          
endmodule
