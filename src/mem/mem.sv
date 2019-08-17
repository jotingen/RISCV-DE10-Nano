module mem #(
  parameter logic [15:0] ADDR_LO = 16'h0000,
  parameter logic [15:0] ADDR_HI = 16'h1FFF
) (
  input  logic           clk,
  input  logic           rst,

  input  logic           bus_req,
  output logic           bus_ack,
  input  logic           bus_write,
  input  logic [15:0]    bus_addr,
  inout  logic [15:0]    bus_data,

  output logic [12:0]    DRAM_ADDR,
  output logic  [1:0]    DRAM_BA,
  output logic           DRAM_CAS_N,
  output logic           DRAM_CKE,
  output logic           DRAM_CLK,
  output logic           DRAM_CS_N,
  inout  logic [15:0]    DRAM_DQ,
  output logic  [1:0]    DRAM_DQM,
  output logic           DRAM_RAS_N,
  output logic           DRAM_WE_N
);


always_comb
  begin
  DRAM_CLK = clk;
  if(bus_req &
     bus_addr >= ADDR_LO &
     bus_addr <= ADDR_HI)
    begin
    logic [15:0] bus_addr_adjusted;

    bus_ack = '1;

    bus_addr_adjusted = bus_addr - ADDR_LO;
    DRAM_ADDR  = bus_addr_adjusted[12:0]; 
    DRAM_BA    = '1;
    DRAM_CAS_N = '1;
    DRAM_CKE   = '1;
    DRAM_CS_N  = '1;
    DRAM_DQM   = '1;
    DRAM_RAS_N = '1;

    if(bus_write)
      begin
      DRAM_WE_N  = '1;
      //DRAM_DQ    = bus_data;
      //bus_data   = 'z;
      end
    else
      begin
      DRAM_WE_N  = '0;
      //bus_data   = DRAM_DQ;
      //DRAM_DQ    = 'z;
      end
    end
  else
    begin
    bus_ack = 'z;

    DRAM_ADDR  = '0;
    DRAM_BA    = '0;
    DRAM_CAS_N = '0;
    DRAM_CKE   = '0;
    DRAM_CS_N  = '0;
    DRAM_DQM   = '0;
    DRAM_RAS_N = '0;

    DRAM_WE_N  = '0;
    //bus_data   = 'z;
    //DRAM_DQ    = 'z;
    end
  end


endmodule

