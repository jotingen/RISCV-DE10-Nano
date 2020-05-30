module ddr3_model (
  input  logic         clk,

  output logic         ddr3_avl_ready,       
  input  logic [25:0]  ddr3_avl_addr,        
  output logic         ddr3_avl_rdata_valid, 
  output logic [127:0] ddr3_avl_rdata,       
  input  logic [127:0] ddr3_avl_wdata,       
  input  logic         ddr3_avl_read_req,    
  input  logic         ddr3_avl_write_req,   
  input  logic [8:0]   ddr3_avl_size        
);

localparam DELAY = 1;

logic [127:0] ddr3 [2**(26-4)-1:0];
logic [DELAY:0]        ddr3_avl_rdata_valid_stg; 
logic [DELAY:0][127:0] ddr3_avl_rdata_stg;       
logic         ddr3_avl_rdata_valid_stg2; 
logic [127:0] ddr3_avl_rdata_stg2;       
logic         ddr3_avl_rdata_valid_stg3; 
logic [127:0] ddr3_avl_rdata_stg3;       
logic         ddr3_avl_rdata_valid_stg4; 
logic [127:0] ddr3_avl_rdata_stg4;       
logic         ddr3_avl_rdata_valid_stg5; 
logic [127:0] ddr3_avl_rdata_stg5;       

always_ff @(posedge clk)
  begin
  ddr3_avl_ready <= '0;
  ddr3_avl_rdata_valid_stg[0] <= '0; 
  ddr3_avl_rdata <= '0;       

  if(ddr3_avl_read_req) 
    begin
    ddr3_avl_ready <= '0;
    ddr3_avl_rdata_valid_stg[0] <= '1;
    ddr3_avl_rdata_stg[0] <= ddr3[ddr3_avl_addr[25:4]];
    end
  if(ddr3_avl_write_req) 
    begin
    ddr3_avl_ready <= '0;
    ddr3[ddr3_avl_addr[25:4]] <= ddr3_avl_wdata;
    end

  for(int i = 1; i <= DELAY; i++)
  begin
    ddr3_avl_rdata_valid_stg[i] <= ddr3_avl_rdata_valid_stg[i-1];
    ddr3_avl_rdata_stg[i]       <= ddr3_avl_rdata_stg[i-1];     
  end
  
  ddr3_avl_rdata_valid      <= ddr3_avl_rdata_valid_stg[DELAY];
  ddr3_avl_rdata            <= ddr3_avl_rdata_stg[DELAY];     
  
  end

endmodule
