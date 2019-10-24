module mmc (

  input  logic           clk,
  input  logic           rst,

  input  logic           riscv_mmc_bus_req,
  input  logic           riscv_mmc_bus_write,
  input  logic [31:0]    riscv_mmc_bus_addr,
  input  logic [31:0]    riscv_mmc_bus_data,
  input  logic  [3:0]    riscv_mmc_bus_data_rd_mask,
  input  logic  [3:0]    riscv_mmc_bus_data_wr_mask,
        
  output logic           mmc_riscv_bus_ack,
  output logic [31:0]    mmc_riscv_bus_data,

  output logic           mmc_mem_bus_req,
  output logic           mmc_mem_bus_write,
  output logic [31:0]    mmc_mem_bus_addr,
  output logic [31:0]    mmc_mem_bus_data,
  output logic  [3:0]    mmc_mem_bus_data_rd_mask,
  output logic  [3:0]    mmc_mem_bus_data_wr_mask,

  input  logic           mem_mmc_bus_ack,
  input  logic [31:0]    mem_mmc_bus_data,

  output logic           mmc_led_bus_req,
  output logic           mmc_led_bus_write,
  output logic [31:0]    mmc_led_bus_addr,
  output logic [31:0]    mmc_led_bus_data,
  output logic  [3:0]    mmc_led_bus_data_rd_mask,
  output logic  [3:0]    mmc_led_bus_data_wr_mask,

  input  logic           led_mmc_bus_ack,
  input  logic [31:0]    led_mmc_bus_data,

  output logic           mmc_keys_bus_req,
  output logic           mmc_keys_bus_write,
  output logic [31:0]    mmc_keys_bus_addr,
  output logic [31:0]    mmc_keys_bus_data,
  output logic  [3:0]    mmc_keys_bus_data_rd_mask,
  output logic  [3:0]    mmc_keys_bus_data_wr_mask,

  input  logic           keys_mmc_bus_ack,
  input  logic [31:0]    keys_mmc_bus_data,

  output logic           mmc_joystick_bus_req,
  output logic           mmc_joystick_bus_write,
  output logic [31:0]    mmc_joystick_bus_addr,
  output logic [31:0]    mmc_joystick_bus_data,
  output logic  [3:0]    mmc_joystick_bus_data_rd_mask,
  output logic  [3:0]    mmc_joystick_bus_data_wr_mask,

  input  logic           joystick_mmc_bus_ack,
  input  logic [31:0]    joystick_mmc_bus_data,

  output logic           mmc_display_bus_req,
  output logic           mmc_display_bus_write,
  output logic [31:0]    mmc_display_bus_addr,
  output logic [31:0]    mmc_display_bus_data,
  output logic  [3:0]    mmc_display_bus_data_rd_mask,
  output logic  [3:0]    mmc_display_bus_data_wr_mask,

  input  logic           display_mmc_bus_ack,
  input  logic [31:0]    display_mmc_bus_data,

  output logic           mmc_dispbuff_bus_req,
  output logic           mmc_dispbuff_bus_write,
  output logic [31:0]    mmc_dispbuff_bus_addr,
  output logic [31:0]    mmc_dispbuff_bus_data,
  output logic  [3:0]    mmc_dispbuff_bus_data_rd_mask,
  output logic  [3:0]    mmc_dispbuff_bus_data_wr_mask,

  input  logic           dispbuff_mmc_bus_ack,
  input  logic [31:0]    dispbuff_mmc_bus_data
        
);

logic null_ack;

//Memory mapping
logic [31:0]    MEM_ADDR_HI      = 'h0001_FFFF;
logic [31:0]    MEM_ADDR_LO      = 'h0000_0000;
logic [31:0]    LED_ADDR_HI      = 'hC000_FFFF;
logic [31:0]    LED_ADDR_LO      = 'hC000_0000;
logic [31:0]    KEYS_ADDR_HI     = 'hC100_FFFF;
logic [31:0]    KEYS_ADDR_LO     = 'hC100_0000;
logic [31:0]    JOYSTICK_ADDR_HI = 'hC101_FFFF;
logic [31:0]    JOYSTICK_ADDR_LO = 'hC101_0000;
logic [31:0]    DISPLAY_ADDR_HI  = 'hC200_FFFF;
logic [31:0]    DISPLAY_ADDR_LO  = 'hC200_0000;
logic [31:0]    DISPBUFF_ADDR_HI = 'hC301_FFFF;
logic [31:0]    DISPBUFF_ADDR_LO = 'hC300_0000;

//CPU to subsystems
always_comb
  begin
  mmc_mem_bus_req      = '0;
  mmc_led_bus_req      = '0;
  mmc_keys_bus_req     = '0;
  mmc_joystick_bus_req = '0;
  mmc_display_bus_req  = '0;
  mmc_dispbuff_bus_req = '0;

  //Generate regs based on memory map
  if(riscv_mmc_bus_addr >= MEM_ADDR_LO &
     riscv_mmc_bus_addr <= MEM_ADDR_HI)
    begin
    mmc_mem_bus_req = riscv_mmc_bus_req;
    end

  if(riscv_mmc_bus_addr >= LED_ADDR_LO &
     riscv_mmc_bus_addr <= LED_ADDR_HI)
    begin
    mmc_led_bus_req = riscv_mmc_bus_req;
    end

  if(riscv_mmc_bus_addr >= KEYS_ADDR_LO &
     riscv_mmc_bus_addr <= KEYS_ADDR_HI)
    begin
    mmc_keys_bus_req = riscv_mmc_bus_req;
    end

  if(riscv_mmc_bus_addr >= JOYSTICK_ADDR_LO &
     riscv_mmc_bus_addr <= JOYSTICK_ADDR_HI)
    begin
    mmc_joystick_bus_req = riscv_mmc_bus_req;
    end

  if(riscv_mmc_bus_addr >= DISPLAY_ADDR_LO &
     riscv_mmc_bus_addr <= DISPLAY_ADDR_HI)
    begin
    mmc_display_bus_req = riscv_mmc_bus_req;
    end

  if(riscv_mmc_bus_addr >= DISPBUFF_ADDR_LO &
     riscv_mmc_bus_addr <= DISPBUFF_ADDR_HI)
    begin
    mmc_dispbuff_bus_req = riscv_mmc_bus_req;
    end


  mmc_mem_bus_write             = riscv_mmc_bus_write;
  mmc_mem_bus_addr              = riscv_mmc_bus_addr - MEM_ADDR_LO;
  mmc_mem_bus_data              = riscv_mmc_bus_data;
  mmc_mem_bus_data_rd_mask      = riscv_mmc_bus_data_rd_mask;
  mmc_mem_bus_data_wr_mask      = riscv_mmc_bus_data_wr_mask;

  mmc_led_bus_write             = riscv_mmc_bus_write;
  mmc_led_bus_addr              = riscv_mmc_bus_addr - LED_ADDR_LO;
  mmc_led_bus_data              = riscv_mmc_bus_data;
  mmc_led_bus_data_rd_mask      = riscv_mmc_bus_data_rd_mask;
  mmc_led_bus_data_wr_mask      = riscv_mmc_bus_data_wr_mask;

  mmc_keys_bus_write            = riscv_mmc_bus_write;
  mmc_keys_bus_addr             = riscv_mmc_bus_addr - KEYS_ADDR_LO;
  mmc_keys_bus_data             = riscv_mmc_bus_data;
  mmc_keys_bus_data_rd_mask     = riscv_mmc_bus_data_rd_mask;
  mmc_keys_bus_data_wr_mask     = riscv_mmc_bus_data_wr_mask;

  mmc_joystick_bus_write        = riscv_mmc_bus_write;
  mmc_joystick_bus_addr         = riscv_mmc_bus_addr - JOYSTICK_ADDR_LO;
  mmc_joystick_bus_data         = riscv_mmc_bus_data;
  mmc_joystick_bus_data_rd_mask = riscv_mmc_bus_data_rd_mask;
  mmc_joystick_bus_data_wr_mask = riscv_mmc_bus_data_wr_mask;

  mmc_display_bus_write         = riscv_mmc_bus_write;
  mmc_display_bus_addr          = riscv_mmc_bus_addr - DISPLAY_ADDR_LO;
  mmc_display_bus_data          = riscv_mmc_bus_data;
  mmc_display_bus_data_rd_mask  = riscv_mmc_bus_data_rd_mask;
  mmc_display_bus_data_wr_mask  = riscv_mmc_bus_data_wr_mask;

  mmc_dispbuff_bus_write        = riscv_mmc_bus_write;
  mmc_dispbuff_bus_addr         = riscv_mmc_bus_addr - DISPBUFF_ADDR_LO;
  mmc_dispbuff_bus_data         = riscv_mmc_bus_data;
  mmc_dispbuff_bus_data_rd_mask = riscv_mmc_bus_data_rd_mask;
  mmc_dispbuff_bus_data_wr_mask = riscv_mmc_bus_data_wr_mask;
  end

//Subsystems to CPU
always_comb
  begin
  mmc_riscv_bus_ack  = '0;
  mmc_riscv_bus_data = '0;

  if(mem_mmc_bus_ack)
    begin
    mmc_riscv_bus_ack  = mem_mmc_bus_ack;
    mmc_riscv_bus_data = mem_mmc_bus_data;
    end

  if(led_mmc_bus_ack)
    begin
    mmc_riscv_bus_ack  = led_mmc_bus_ack;
    mmc_riscv_bus_data = led_mmc_bus_data;
    end

  if(keys_mmc_bus_ack)
    begin
    mmc_riscv_bus_ack  = keys_mmc_bus_ack;
    mmc_riscv_bus_data = keys_mmc_bus_data;
    end

  if(joystick_mmc_bus_ack)
    begin
    mmc_riscv_bus_ack  = joystick_mmc_bus_ack;
    mmc_riscv_bus_data = joystick_mmc_bus_data;
    end

  if(display_mmc_bus_ack)
    begin
    mmc_riscv_bus_ack  = display_mmc_bus_ack;
    mmc_riscv_bus_data = display_mmc_bus_data;
    end

  if(dispbuff_mmc_bus_ack)
    begin
    mmc_riscv_bus_ack  = dispbuff_mmc_bus_ack;
    mmc_riscv_bus_data = dispbuff_mmc_bus_data;
    end

  if(null_ack)
    begin
    mmc_riscv_bus_ack  = null_ack;
    mmc_riscv_bus_data = '0;
    end

  end

//Null address responder
//Return ack in next cycle with 0 data if no address match, avoids hang
always_ff @(posedge clk)
  begin
  null_ack <= '0;
  if( riscv_mmc_bus_req &
     ~mmc_mem_bus_req &
     ~mmc_led_bus_req &
     ~mmc_keys_bus_req &
     ~mmc_joystick_bus_req &
     ~mmc_display_bus_req &
     ~mmc_dispbuff_bus_req)
    begin
    null_ack <= '1;
    end
  if(rst)
    begin
    null_ack <= '0;
    end
  end

endmodule