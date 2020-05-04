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

logic [127:0] ddr3 [2**25-1:0];
logic         ddr3_avl_rdata_valid_stg1; 
logic [127:0] ddr3_avl_rdata_stg1;       
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
  ddr3_avl_rdata_valid_stg1 <= '0; 
  ddr3_avl_rdata <= '0;       

  if(ddr3_avl_read_req) 
    begin
    ddr3_avl_ready <= '0;
    ddr3_avl_rdata_valid_stg1 <= '1;
    ddr3_avl_rdata_stg1 <= ddr3[ddr3_avl_addr[25:4]];
    end
  if(ddr3_avl_write_req) 
    begin
    ddr3_avl_ready <= '0;
    ddr3[ddr3_avl_addr[25:4]] <= ddr3_avl_wdata;
    end

  ddr3_avl_rdata_valid_stg2 <= ddr3_avl_rdata_valid_stg1;
  ddr3_avl_rdata_stg2       <= ddr3_avl_rdata_stg1;     
  
  ddr3_avl_rdata_valid_stg3 <= ddr3_avl_rdata_valid_stg2;
  ddr3_avl_rdata_stg3       <= ddr3_avl_rdata_stg2;     
  
  ddr3_avl_rdata_valid_stg4 <= ddr3_avl_rdata_valid_stg3;
  ddr3_avl_rdata_stg4       <= ddr3_avl_rdata_stg3;     
  
  ddr3_avl_rdata_valid_stg5 <= ddr3_avl_rdata_valid_stg4;
  ddr3_avl_rdata_stg5       <= ddr3_avl_rdata_stg4;     
  
  ddr3_avl_rdata_valid      <= ddr3_avl_rdata_valid_stg5;
  ddr3_avl_rdata            <= ddr3_avl_rdata_stg5;     
  
  end

endmodule
