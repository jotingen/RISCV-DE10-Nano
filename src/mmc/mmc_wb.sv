module mmc_wb (

  input  logic           clk,
  input  logic           rst,

  input  logic [31:0]      riscv_mmc_adr_i,
  input  logic [31:0]      riscv_mmc_data_i,
  input  logic             riscv_mmc_we_i,
  input  logic  [3:0]      riscv_mmc_sel_i,
  input  logic             riscv_mmc_stb_i,
  input  logic             riscv_mmc_cyc_i,
  input  logic             riscv_mmc_tga_i,
  input  logic             riscv_mmc_tgd_i,
  input  logic  [3:0]      riscv_mmc_tgc_i,

  output logic             mmc_riscv_ack_o,
  output logic             mmc_riscv_stall_o,
  output logic             mmc_riscv_err_o,
  output logic             mmc_riscv_rty_o,
  output logic [31:0]      mmc_riscv_data_o,
  output logic             mmc_riscv_tga_o,
  output logic             mmc_riscv_tgd_o,
  output logic  [3:0]      mmc_riscv_tgc_o,


  output logic [31:0]      mmc_mem_adr_o,
  output logic [31:0]      mmc_mem_data_o,
  output logic             mmc_mem_we_o,
  output logic  [3:0]      mmc_mem_sel_o,
  output logic             mmc_mem_stb_o,
  output logic             mmc_mem_cyc_o,
  output logic             mmc_mem_tga_o,
  output logic             mmc_mem_tgd_o,
  output logic  [3:0]      mmc_mem_tgc_o,

  input  logic             mem_mmc_ack_i,
  input  logic             mem_mmc_stall_i,
  input  logic             mem_mmc_err_i,
  input  logic             mem_mmc_rty_i,
  input  logic [31:0]      mem_mmc_data_i,
  input  logic             mem_mmc_tga_i,
  input  logic             mem_mmc_tgd_i,
  input  logic  [3:0]      mem_mmc_tgc_i,


  output logic [31:0]      mmc_ddr3_adr_o,
  output logic [31:0]      mmc_ddr3_data_o,
  output logic             mmc_ddr3_we_o,
  output logic  [3:0]      mmc_ddr3_sel_o,
  output logic             mmc_ddr3_stb_o,
  output logic             mmc_ddr3_cyc_o,
  output logic             mmc_ddr3_tga_o,
  output logic             mmc_ddr3_tgd_o,
  output logic  [3:0]      mmc_ddr3_tgc_o,

  input  logic             ddr3_mmc_ack_i,
  input  logic             ddr3_mmc_stall_i,
  input  logic             ddr3_mmc_err_i,
  input  logic             ddr3_mmc_rty_i,
  input  logic [31:0]      ddr3_mmc_data_i,
  input  logic             ddr3_mmc_tga_i,
  input  logic             ddr3_mmc_tgd_i,
  input  logic  [3:0]      ddr3_mmc_tgc_i,


  output logic [31:0]      mmc_led_adr_o,
  output logic [31:0]      mmc_led_data_o,
  output logic             mmc_led_we_o,
  output logic  [3:0]      mmc_led_sel_o,
  output logic             mmc_led_stb_o,
  output logic             mmc_led_cyc_o,
  output logic             mmc_led_tga_o,
  output logic             mmc_led_tgd_o,
  output logic  [3:0]      mmc_led_tgc_o,

  input  logic             led_mmc_ack_i,
  input  logic             led_mmc_stall_i,
  input  logic             led_mmc_err_i,
  input  logic             led_mmc_rty_i,
  input  logic [31:0]      led_mmc_data_i,
  input  logic             led_mmc_tga_i,
  input  logic             led_mmc_tgd_i,
  input  logic  [3:0]      led_mmc_tgc_i,


  output logic [31:0]      mmc_keys_adr_o,
  output logic [31:0]      mmc_keys_data_o,
  output logic             mmc_keys_we_o,
  output logic  [3:0]      mmc_keys_sel_o,
  output logic             mmc_keys_stb_o,
  output logic             mmc_keys_cyc_o,
  output logic             mmc_keys_tga_o,
  output logic             mmc_keys_tgd_o,
  output logic  [3:0]      mmc_keys_tgc_o,

  input  logic             keys_mmc_ack_i,
  input  logic             keys_mmc_stall_i,
  input  logic             keys_mmc_err_i,
  input  logic             keys_mmc_rty_i,
  input  logic [31:0]      keys_mmc_data_i,
  input  logic             keys_mmc_tga_i,
  input  logic             keys_mmc_tgd_i,
  input  logic  [3:0]      keys_mmc_tgc_i,


  output logic [31:0]      mmc_uart_adr_o,
  output logic [31:0]      mmc_uart_data_o,
  output logic             mmc_uart_we_o,
  output logic  [3:0]      mmc_uart_sel_o,
  output logic             mmc_uart_stb_o,
  output logic             mmc_uart_cyc_o,
  output logic             mmc_uart_tga_o,
  output logic             mmc_uart_tgd_o,
  output logic  [3:0]      mmc_uart_tgc_o,

  input  logic             uart_mmc_ack_i,
  input  logic             uart_mmc_stall_i,
  input  logic             uart_mmc_err_i,
  input  logic             uart_mmc_rty_i,
  input  logic [31:0]      uart_mmc_data_i,
  input  logic             uart_mmc_tga_i,
  input  logic             uart_mmc_tgd_i,
  input  logic  [3:0]      uart_mmc_tgc_i,


  output logic [31:0]      mmc_sdcard_adr_o,
  output logic [31:0]      mmc_sdcard_data_o,
  output logic             mmc_sdcard_we_o,
  output logic  [3:0]      mmc_sdcard_sel_o,
  output logic             mmc_sdcard_stb_o,
  output logic             mmc_sdcard_cyc_o,
  output logic             mmc_sdcard_tga_o,
  output logic             mmc_sdcard_tgd_o,
  output logic  [3:0]      mmc_sdcard_tgc_o,

  input  logic             sdcard_mmc_ack_i,
  input  logic             sdcard_mmc_stall_i,
  input  logic             sdcard_mmc_err_i,
  input  logic             sdcard_mmc_rty_i,
  input  logic [31:0]      sdcard_mmc_data_i,
  input  logic             sdcard_mmc_tga_i,
  input  logic             sdcard_mmc_tgd_i,
  input  logic  [3:0]      sdcard_mmc_tgc_i
        
);

logic null_ack;

logic [15:0]    mem_stb_cnt;
logic [15:0]    ddr3_stb_cnt;
logic [15:0]    led_stb_cnt;
logic [15:0]    keys_stb_cnt;
logic [15:0]    uart_stb_cnt;
logic [15:0]    sdcard_stb_cnt;

//Memory mapping
logic [31:0]    MEM_ADDR_LO      = 'h0000_0000;
logic [31:0]    MEM_ADDR_HI      = 'h0000_7FFF;
logic [31:0]    DDR3_ADDR_LO     = 'h1000_0000;
logic [31:0]    DDR3_ADDR_HI     = 'h13FF_FFFF;
logic [31:0]    LED_ADDR_LO      = 'hC000_0000;
logic [31:0]    LED_ADDR_HI      = 'hC000_FFFF;
logic [31:0]    KEYS_ADDR_LO     = 'hC100_0000;
logic [31:0]    KEYS_ADDR_HI     = 'hC100_FFFF;
logic [31:0]    JOYSTICK_ADDR_LO = 'hC101_0000;
logic [31:0]    JOYSTICK_ADDR_HI = 'hC101_FFFF;
logic [31:0]    DISPLAY_ADDR_LO  = 'hC200_0000;
logic [31:0]    DISPLAY_ADDR_HI  = 'hC200_FFFF;
logic [31:0]    DISPBUFF_ADDR_LO = 'hC300_0000;
logic [31:0]    DISPBUFF_ADDR_HI = 'hC302_FFFF;
logic [31:0]    CONSOLEBUFF_ADDR_LO = 'hC303_0000;
logic [31:0]    CONSOLEBUFF_ADDR_HI = 'hC303_FFFF;
logic [31:0]    UART_ADDR_LO     = 'hC304_0000;
logic [31:0]    UART_ADDR_HI     = 'hC304_FFFF;
logic [31:0]    SDCARD_ADDR_LO   = 'hC400_0000;
logic [31:0]    SDCARD_ADDR_HI   = 'hC400_FFFF;

//Instruction counters
always_ff @(posedge clk)
  begin
  mem_stb_cnt    <= mem_stb_cnt    + mmc_mem_stb_o    - mem_mmc_ack_i;
  ddr3_stb_cnt   <= ddr3_stb_cnt   + mmc_ddr3_stb_o   - ddr3_mmc_ack_i;
  led_stb_cnt    <= '0; //led_stb_cnt    + mmc_led_stb_o    - led_mmc_ack_i;
  keys_stb_cnt   <= '0; //keys_stb_cnt   + mmc_keys_stb_o   - keys_mmc_ack_i;
  uart_stb_cnt   <= '0; //uart_stb_cnt   + mmc_uart_stb_o   - uart_mmc_ack_i;
  sdcard_stb_cnt <= '0; //sdcard_stb_cnt + mmc_sdcard_stb_o - sdcard_mmc_ack_i;

  if(rst)
    begin
    mem_stb_cnt    <= '0;
    ddr3_stb_cnt   <= '0;
    led_stb_cnt    <= '0;
    keys_stb_cnt   <= '0;
    uart_stb_cnt   <= '0;
    sdcard_stb_cnt <= '0;
    end
  end
//
//CPU to subsystems
always_comb
  begin
  mmc_mem_stb_o    = '0;
  mmc_ddr3_stb_o   = '0;
  mmc_led_stb_o    = '0;
  mmc_keys_stb_o   = '0;
  mmc_uart_stb_o   = '0;
  mmc_sdcard_stb_o = '0;

  //Generate regs based on memory map
  if(riscv_mmc_adr_i >= MEM_ADDR_LO &
     riscv_mmc_adr_i <= MEM_ADDR_HI)
    begin
    mmc_mem_stb_o = riscv_mmc_stb_i;
    end

  if(riscv_mmc_adr_i >= DDR3_ADDR_LO &
     riscv_mmc_adr_i <= DDR3_ADDR_HI)
    begin
    mmc_ddr3_stb_o = riscv_mmc_stb_i;
    end

  if(riscv_mmc_adr_i >= LED_ADDR_LO &
     riscv_mmc_adr_i <= LED_ADDR_HI)
    begin
    mmc_led_stb_o = riscv_mmc_stb_i;
    end

  if(riscv_mmc_adr_i >= KEYS_ADDR_LO &
     riscv_mmc_adr_i <= KEYS_ADDR_HI)
    begin
    mmc_keys_stb_o = riscv_mmc_stb_i;
    end

  if(riscv_mmc_adr_i >= UART_ADDR_LO &
     riscv_mmc_adr_i <= UART_ADDR_HI)
    begin
    mmc_uart_stb_o = riscv_mmc_stb_i;
    end

  if(riscv_mmc_adr_i >= SDCARD_ADDR_LO &
     riscv_mmc_adr_i <= SDCARD_ADDR_HI)
    begin
    mmc_sdcard_stb_o = riscv_mmc_stb_i;
    end

  mmc_mem_adr_o     = riscv_mmc_adr_i - MEM_ADDR_LO; 
  mmc_mem_data_o    = riscv_mmc_data_i;
  mmc_mem_we_o      = riscv_mmc_we_i;  
  mmc_mem_sel_o     = riscv_mmc_sel_i; 
  mmc_mem_cyc_o     = riscv_mmc_cyc_i; 
  mmc_mem_tga_o     = riscv_mmc_tga_i; 
  mmc_mem_tgd_o     = riscv_mmc_tgd_i; 
  mmc_mem_tgc_o     = riscv_mmc_tgc_i; 


  mmc_ddr3_adr_o    = riscv_mmc_adr_i - DDR3_ADDR_LO; 
  mmc_ddr3_data_o   = riscv_mmc_data_i;
  mmc_ddr3_we_o     = riscv_mmc_we_i;  
  mmc_ddr3_sel_o    = riscv_mmc_sel_i; 
  mmc_ddr3_cyc_o    = riscv_mmc_cyc_i; 
  mmc_ddr3_tga_o    = riscv_mmc_tga_i; 
  mmc_ddr3_tgd_o    = riscv_mmc_tgd_i; 
  mmc_ddr3_tgc_o    = riscv_mmc_tgc_i; 


  mmc_led_adr_o     = riscv_mmc_adr_i - LED_ADDR_LO; 
  mmc_led_data_o    = riscv_mmc_data_i;
  mmc_led_we_o      = riscv_mmc_we_i;  
  mmc_led_sel_o     = riscv_mmc_sel_i; 
  mmc_led_cyc_o     = riscv_mmc_cyc_i; 
  mmc_led_tga_o     = riscv_mmc_tga_i; 
  mmc_led_tgd_o     = riscv_mmc_tgd_i; 
  mmc_led_tgc_o     = riscv_mmc_tgc_i; 


  mmc_keys_adr_o    = riscv_mmc_adr_i - KEYS_ADDR_LO; 
  mmc_keys_data_o   = riscv_mmc_data_i;
  mmc_keys_we_o     = riscv_mmc_we_i;  
  mmc_keys_sel_o    = riscv_mmc_sel_i; 
  mmc_keys_cyc_o    = riscv_mmc_cyc_i; 
  mmc_keys_tga_o    = riscv_mmc_tga_i; 
  mmc_keys_tgd_o    = riscv_mmc_tgd_i; 
  mmc_keys_tgc_o    = riscv_mmc_tgc_i; 


  mmc_uart_adr_o    = riscv_mmc_adr_i - UART_ADDR_LO; 
  mmc_uart_data_o   = riscv_mmc_data_i;
  mmc_uart_we_o     = riscv_mmc_we_i;  
  mmc_uart_sel_o    = riscv_mmc_sel_i; 
  mmc_uart_cyc_o    = riscv_mmc_cyc_i; 
  mmc_uart_tga_o    = riscv_mmc_tga_i; 
  mmc_uart_tgd_o    = riscv_mmc_tgd_i; 
  mmc_uart_tgc_o    = riscv_mmc_tgc_i; 


  mmc_sdcard_adr_o  = riscv_mmc_adr_i - SDCARD_ADDR_LO; 
  mmc_sdcard_data_o = riscv_mmc_data_i;
  mmc_sdcard_we_o   = riscv_mmc_we_i;  
  mmc_sdcard_sel_o  = riscv_mmc_sel_i; 
  mmc_sdcard_cyc_o  = riscv_mmc_cyc_i; 
  mmc_sdcard_tga_o  = riscv_mmc_tga_i; 
  mmc_sdcard_tgd_o  = riscv_mmc_tgd_i; 
  mmc_sdcard_tgc_o  = riscv_mmc_tgc_i; 
  end

//Subsystems to CPU
always_comb
  begin
  mmc_riscv_ack_o   = '0;
  mmc_riscv_stall_o = '0;
  mmc_riscv_err_o   = '0;
  mmc_riscv_rty_o   = '0;
  mmc_riscv_data_o  = '0;
  mmc_riscv_tga_o   = '0;
  mmc_riscv_tgd_o   = '0;
  mmc_riscv_tgc_o   = '0;

  if(mem_stb_cnt)
    begin
    mmc_riscv_stall_o = mem_mmc_stall_i;
    end

  if(ddr3_stb_cnt)
    begin
    mmc_riscv_stall_o = ddr3_mmc_stall_i;
    end

  if(led_stb_cnt)
    begin
    mmc_riscv_stall_o = led_mmc_stall_i;
    end

  if(keys_stb_cnt)
    begin
    mmc_riscv_stall_o = keys_mmc_stall_i;
    end

  if(uart_stb_cnt)
    begin
    mmc_riscv_stall_o = uart_mmc_stall_i;
    end

  if(sdcard_stb_cnt)
    begin
    mmc_riscv_stall_o = sdcard_mmc_stall_i;
    end

  if(mem_mmc_ack_i)
    begin
    mmc_riscv_ack_o   = mem_mmc_ack_i;
    mmc_riscv_err_o   = mem_mmc_err_i;
    mmc_riscv_rty_o   = mem_mmc_rty_i;
    mmc_riscv_data_o  = mem_mmc_data_i;
    mmc_riscv_tga_o   = mem_mmc_tga_i;
    mmc_riscv_tgd_o   = mem_mmc_tgd_i;
    mmc_riscv_tgc_o   = mem_mmc_tgc_i;
    end

  if(ddr3_mmc_ack_i)
    begin
    mmc_riscv_ack_o   = ddr3_mmc_ack_i;
    mmc_riscv_err_o   = ddr3_mmc_err_i;
    mmc_riscv_rty_o   = ddr3_mmc_rty_i;
    mmc_riscv_data_o  = ddr3_mmc_data_i;
    mmc_riscv_tga_o   = ddr3_mmc_tga_i;
    mmc_riscv_tgd_o   = ddr3_mmc_tgd_i;
    mmc_riscv_tgc_o   = ddr3_mmc_tgc_i;
    end

  if(led_mmc_ack_i)
    begin
    mmc_riscv_ack_o   = led_mmc_ack_i;
    mmc_riscv_err_o   = led_mmc_err_i;
    mmc_riscv_rty_o   = led_mmc_rty_i;
    mmc_riscv_data_o  = led_mmc_data_i;
    mmc_riscv_tga_o   = led_mmc_tga_i;
    mmc_riscv_tgd_o   = led_mmc_tgd_i;
    mmc_riscv_tgc_o   = led_mmc_tgc_i;
    end

  if(keys_mmc_ack_i)
    begin
    mmc_riscv_ack_o   = keys_mmc_ack_i;
    mmc_riscv_err_o   = keys_mmc_err_i;
    mmc_riscv_rty_o   = keys_mmc_rty_i;
    mmc_riscv_data_o  = keys_mmc_data_i;
    mmc_riscv_tga_o   = keys_mmc_tga_i;
    mmc_riscv_tgd_o   = keys_mmc_tgd_i;
    mmc_riscv_tgc_o   = keys_mmc_tgc_i;
    end

  if(uart_mmc_ack_i)
    begin
    mmc_riscv_ack_o   = uart_mmc_ack_i;
    mmc_riscv_err_o   = uart_mmc_err_i;
    mmc_riscv_rty_o   = uart_mmc_rty_i;
    mmc_riscv_data_o  = uart_mmc_data_i;
    mmc_riscv_tga_o   = uart_mmc_tga_i;
    mmc_riscv_tgd_o   = uart_mmc_tgd_i;
    mmc_riscv_tgc_o   = uart_mmc_tgc_i;
    end

  if(sdcard_mmc_ack_i)
    begin
    mmc_riscv_ack_o   = sdcard_mmc_ack_i;
    mmc_riscv_err_o   = sdcard_mmc_err_i;
    mmc_riscv_rty_o   = sdcard_mmc_rty_i;
    mmc_riscv_data_o  = sdcard_mmc_data_i;
    mmc_riscv_tga_o   = sdcard_mmc_tga_i;
    mmc_riscv_tgd_o   = sdcard_mmc_tgd_i;
    mmc_riscv_tgc_o   = sdcard_mmc_tgc_i;
    end

  if(null_ack)
    begin
    mmc_riscv_ack_o   = '1;
    mmc_riscv_stall_o = '0;
    mmc_riscv_err_o   = '1;
    mmc_riscv_rty_o   = '0;
    mmc_riscv_data_o  = '0;
    mmc_riscv_tga_o   = '0;
    mmc_riscv_tgd_o   = '0;
    mmc_riscv_tgc_o   = '0;
    end

  end

//Null address responder
//Return ack in next cycle with 0 data if no address match, avoids hang
always_ff @(posedge clk)
  begin
  null_ack <= '0;
  if( riscv_mmc_stb_i &
     ~mmc_mem_stb_o &
     ~mmc_ddr3_stb_o &
     ~mmc_led_stb_o &
     ~mmc_keys_stb_o &
     ~mmc_uart_stb_o &
     ~mmc_sdcard_stb_o)
    begin
    null_ack <= '1;
    end
  if(rst)
    begin
    null_ack <= '0;
    end
  end

endmodule
