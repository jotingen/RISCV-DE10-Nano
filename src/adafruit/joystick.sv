module joystick #(
  parameter integer      SIZE = 2,
  parameter logic [31:0] ADDR_BASE = 32'h00000000
) (

input  logic           clk,
input  logic           rst,

//////////// ADC //////////
output logic           ADC_CONVST,
output logic           ADC_SCK,
output logic           ADC_SDI,
input  logic           ADC_SDO,  

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

logic [11:0] CH0;     
logic [11:0] CH1;     
logic [11:0] CH2;     
logic [11:0] CH3;     
logic [11:0] CH4;     
logic [11:0] CH5;     
logic [11:0] CH6;     
logic [11:0] CH7;     

logic        JOY_UP;
logic        JOY_RIGHT;
logic        JOY_SELECT;
logic        JOY_DOWN;
logic        JOY_LEFT;

ADC adc (
  .CLOCK    (clk),    
  .RESET    (rst),    
  .CH0      (CH0),    
  .CH1      (CH1),    
  .CH2      (CH2),    
  .CH3      (CH3),    
  .CH4      (CH4),    
  .CH5      (CH5),    
  .CH6      (CH6),    
  .CH7      (CH7),    
  .ADC_SCLK (ADC_SCK),
  .ADC_CS_N (ADC_CONVST),
  .ADC_DOUT (ADC_SDO),   
  .ADC_DIN  (ADC_SDI)    
);

always_ff @(posedge clk)
  begin
  JOY_UP     <= CH3[11:9] == 'b101; // UP    
  JOY_RIGHT  <= CH3[11:9] == 'b011; // RIGHT 
  JOY_SELECT <= CH3[11:9] == 'b010; // SELECT
  JOY_DOWN   <= CH3[11:9] == 'b001; // DOWN  
  JOY_LEFT   <= CH3[11:9] == 'b000; // LEFT  
  end

always_ff @(posedge clk)
  begin
  o_bus_ack   <= '0;    
  o_bus_data  <= i_bus_data;   

  if(i_bus_req &
     i_bus_addr >= ADDR_BASE &
     i_bus_addr <= ADDR_BASE + 2**SIZE - 1)
    begin
    o_bus_ack <= '1;
    case (i_bus_addr[SIZE+2:2] - ADDR_BASE[SIZE+2:2])
      'd0:     begin
               o_bus_data <= '0;
               o_bus_data <= JOY_UP;
               end
      'd1:     begin
               o_bus_data <= '0;
               o_bus_data <= JOY_RIGHT;
               end
      'd2:     begin
               o_bus_data <= '0;
               o_bus_data <= JOY_SELECT;
               end
      'd3:     begin
               o_bus_data <= '0;
               o_bus_data <= JOY_DOWN;
               end
      'd4:     begin
               o_bus_data <= '0;
               o_bus_data <= JOY_LEFT;
               end
      default: begin
               o_bus_data <= '0;
               end
    endcase
    end
  end

endmodule

