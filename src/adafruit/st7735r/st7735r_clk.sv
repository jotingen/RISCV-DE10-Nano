module st7735r_clk (
input  logic clk,
input  logic rst,

output logic SCK_clk,
output logic SCK
);

//Clock boundary
logic clk_pulse;
logic [1:0] clk_pulse_cnt;
always_ff @(posedge clk)
  begin
  if(rst)
    begin
    clk_pulse <= '0;
    clk_pulse_cnt <= '0;
    end
  else
    begin
    case (clk_pulse_cnt)
      'd0:      begin
                clk_pulse_cnt <= clk_pulse_cnt + 1;
                clk_pulse <= '1;
                end
      default:  begin
                clk_pulse_cnt <= clk_pulse_cnt + 1;
                clk_pulse <= '0;
                end
    endcase
    end
  end
assign SCK_clk = clk_pulse;

//Clock signal
logic [1:0] sck_cnt;
always_ff @(posedge clk)
  begin
  if(rst)
    begin
    SCK <= '0;
    sck_cnt <= '0;
    end
  else
    begin
    case (sck_cnt)
      'd0:      begin
                if(clk_pulse)
                  sck_cnt <= sck_cnt + 1;
                else
                  sck_cnt <= sck_cnt;
                SCK <= '0;
                end
      'd2,'d3:  
                begin
                sck_cnt <= sck_cnt + 1;
                SCK <= '1;
                end
      default:  begin
                sck_cnt <= sck_cnt + 1;
                SCK <= '0;
                end
    endcase
    end
  end

endmodule
