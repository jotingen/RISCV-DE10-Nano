module led #(
  parameter integer      SIZE = 4,
  parameter logic [31:0] ADDR_BASE = 32'h00000000
) (
  input  logic           clk,
  input  logic           rst,

  output logic  [7:0]    LED,

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

always_ff @(posedge clk)
  begin
  bus_ack_o   <= '0;   
  bus_stall_o <= '0; //bus_stall_o; 
  bus_err_o   <= '0; //bus_err_o;   
  bus_rty_o   <= '0; //bus_rty_o;   
  bus_data_o  <= '0; //bus_data_o;  
  bus_tga_o   <= '0; //bus_tga_o;   
  bus_tgd_o   <= '0; //bus_tgd_o;   
  bus_tgc_o   <= '0; //bus_tgc_o;   

  LED <= LED;

  if(bus_sel_i &
     bus_cyc_i &
     bus_adr_i >= ADDR_BASE &
     bus_adr_i <= ADDR_BASE + 2**SIZE - 1)
    begin
    bus_ack_o <= '1;
    case (bus_adr_i[SIZE+2:2] - ADDR_BASE[SIZE+2:2])
      'd0:     begin
               if (bus_we_i & bus_sel_i[0])
                 begin
                 LED[7:0]        <= bus_data_i[7:0];
                 end
               bus_data_o      <= '0;
               bus_data_o[7:0] <= LED[7:0];
               end
      default: begin
               bus_data_o      <= '0;
               end
    endcase
    end

  if(rst)
    begin
    LED <= 'hAA;
    end

  end

endmodule
