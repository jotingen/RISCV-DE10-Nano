module spi_arb (
input  logic clk,
input  logic rst,

output logic SCK,
output logic DISPLAY_CS,
output logic SDCARD_CS,
output logic RS_DC,
output logic DATA,

input  logic display_SPIReq,
input  logic display_SPIDone,
input  logic display_SCK,
input  logic display_CS,
input  logic display_RS_DC,
input  logic display_DATA,

output logic display_SPIAck,

input  logic sdcard_SPIReq,
input  logic sdcard_SPIDone,
input  logic sdcard_SCK,
input  logic sdcard_CS,
input  logic sdcard_RS_DC,
input  logic sdcard_DATA,

output logic sdcard_SPIAck
);

logic display_current;

logic sdcard_current;

logic arb_bit;

logic clk_stgd;
logic clk_pulse;
logic [6:0] cycles_settled;
logic clk_settled;

logic state_idle;
logic state_requested;
logic state_granted;

always_ff @(posedge clk)
  begin

  display_current <= display_current;
  display_SPIAck  <= '0;//display_SPIAck;

  sdcard_current  <= sdcard_current; 
  sdcard_SPIAck   <= '0;//sdcard_SPIAck;
                                      
  arb_bit         <= arb_bit;        

  clk_stgd        <= SCK;
  clk_pulse       <= SCK != clk_stgd & SCK == '0;
  cycles_settled  <= cycles_settled; 
  clk_settled     <= clk_settled; 
                                      
  state_idle      <= '0;
  state_requested <= '0;
  state_granted   <= '0;

	unique
	case(1'b1)
	  display_current : begin
                      SCK        <= display_SCK;   
                      DISPLAY_CS <= display_CS;    
                      SDCARD_CS  <= '1;
                      RS_DC      <= display_RS_DC; 
                      DATA       <= display_DATA;  
		                  end
	  sdcard_current  : begin
                      SCK        <= sdcard_SCK;   
                      DISPLAY_CS <= '1;
                      SDCARD_CS  <= sdcard_CS;    
                      RS_DC      <= sdcard_RS_DC; 
                      DATA       <= sdcard_DATA;  
		                  end
	  default         : begin
                      SCK        <= '0;
                      DISPLAY_CS <= '1;
                      SDCARD_CS  <= '1;
                      RS_DC      <= '0;
                      DATA       <= '0;
		                  end
	endcase

	unique
	case(1'b1)
	  state_idle :      begin
		                  if(display_SPIReq & sdcard_SPIReq) 
											  begin
												if(arb_bit)
													begin
												  state_requested <= '1;
													display_current <= '1;
													sdcard_current  <= '0;
													if(sdcard_current)
														begin
														cycles_settled <= '0;
														clk_settled    <= '0;
														end
													end
											  else
													begin
												  state_requested <= '1;
													display_current <= '0;
													sdcard_current  <= '1;
													if(display_current)
														begin
														cycles_settled <= 0;
														clk_settled    <= '0;
														end
													end
												end
										  else if(display_SPIReq)
												begin
												state_requested <= '1;
												display_current <= '1;
												sdcard_current  <= '0;
												if(sdcard_current)
													begin
													cycles_settled <= 0;
													clk_settled    <= '0;
													end
												end
										  else if(sdcard_SPIReq)
												begin
												state_requested <= '1;
												display_current <= '0;
												sdcard_current  <= '1;
												if(display_current)
													begin
													cycles_settled <= 0;
													clk_settled    <= '0;
													end
												end
										  else 
												begin
												state_idle <= '1;
												end
		                  end
	  state_requested : begin
		                  if(clk_settled)
												begin
												state_granted <= '1;
												if(display_current)
													begin
                          display_SPIAck <= '1;
													end
												if(sdcard_current)
													begin
                          sdcard_SPIAck <= '1;
													end
												end
										  else 
												begin
												state_requested <= '1;
												end
		                  end
	  state_granted :   begin
											if(display_SPIDone | sdcard_SPIDone)
												begin
												state_idle <= '1;
                        //display_SPIAck <= '0;
                        //sdcard_SPIAck <= '0;
												end
											else
												begin
											  state_granted <= '1;
												end
		                  end
    default :         begin
		                  state_idle <= '1;
											end
  endcase


  //Clk cycle settling
	if(clk_pulse) 
		begin
			cycles_settled  <= cycles_settled + 1;
    end

  if(cycles_settled >= 'd100)
		begin
		clk_settled <= '1;
		end

  //Reset
  if(rst)
		begin
		display_current   <= '1;
    display_SPIAck    <= '0;

		sdcard_current    <= '0;
    sdcard_SPIAck     <= '0;

		arb_bit <= '0;

    clk_stgd        <= SCK;
    clk_pulse       <= '0;
		cycles_settled  <= '0;
		clk_settled     <= '0;

    state_idle      <= '1;
    state_requested <= '0;
    state_granted   <= '0;
		end
  end
endmodule

