import wishbone_pkg::*;

module mmc_wb (

  input  logic           clk,
  input  logic           rst,

  input  logic [$bits(wishbone_pkg::bus_req_t)-1:0] riscv_mmc_flat_i,
  output logic [$bits(wishbone_pkg::bus_rsp_t)-1:0] mmc_riscv_flat_o,

  output logic [$bits(wishbone_pkg::bus_req_t)-1:0] mmc_mem_flat_o,
  input  logic [$bits(wishbone_pkg::bus_rsp_t)-1:0] mem_mmc_flat_i,

  output logic [$bits(wishbone_pkg::bus_req_t)-1:0] mmc_ddr3_flat_o,
  input  logic [$bits(wishbone_pkg::bus_rsp_t)-1:0] ddr3_mmc_flat_i,

  output logic [$bits(wishbone_pkg::bus_req_t)-1:0] mmc_ddr3cntl_flat_o,
  input  logic [$bits(wishbone_pkg::bus_rsp_t)-1:0] ddr3cntl_mmc_flat_i,

  output logic [$bits(wishbone_pkg::bus_req_t)-1:0] mmc_led_flat_o,
  input  logic [$bits(wishbone_pkg::bus_rsp_t)-1:0] led_mmc_flat_i,

  output logic [$bits(wishbone_pkg::bus_req_t)-1:0] mmc_keys_flat_o,
  input  logic [$bits(wishbone_pkg::bus_rsp_t)-1:0] keys_mmc_flat_i,

  output logic [$bits(wishbone_pkg::bus_req_t)-1:0] mmc_uart_flat_o,
  input  logic [$bits(wishbone_pkg::bus_rsp_t)-1:0] uart_mmc_flat_i,

  output logic [$bits(wishbone_pkg::bus_req_t)-1:0] mmc_sdcard_flat_o,
  input  logic [$bits(wishbone_pkg::bus_rsp_t)-1:0] sdcard_mmc_flat_i,

  output logic [$bits(wishbone_pkg::bus_req_t)-1:0] mmc_debug_flat_o,
  input  logic [$bits(wishbone_pkg::bus_rsp_t)-1:0] debug_mmc_flat_i

);
  wishbone_pkg::bus_req_t riscv_mmc_i;
  wishbone_pkg::bus_rsp_t mmc_riscv_o;

  wishbone_pkg::bus_req_t mmc_mem_o;
  wishbone_pkg::bus_rsp_t mem_mmc_i;

  wishbone_pkg::bus_req_t mmc_ddr3_o;
  wishbone_pkg::bus_rsp_t ddr3_mmc_i;

  wishbone_pkg::bus_req_t mmc_ddr3cntl_o;
  wishbone_pkg::bus_rsp_t ddr3cntl_mmc_i;

  wishbone_pkg::bus_req_t mmc_led_o;
  wishbone_pkg::bus_rsp_t led_mmc_i;

  wishbone_pkg::bus_req_t mmc_keys_o;
  wishbone_pkg::bus_rsp_t keys_mmc_i;

  wishbone_pkg::bus_req_t mmc_uart_o;
  wishbone_pkg::bus_rsp_t uart_mmc_i;

  wishbone_pkg::bus_req_t mmc_sdcard_o;
  wishbone_pkg::bus_rsp_t sdcard_mmc_i;

  wishbone_pkg::bus_req_t mmc_debug_o;
  wishbone_pkg::bus_rsp_t debug_mmc_i;

always_comb
begin
  riscv_mmc_i         = riscv_mmc_flat_i;
  mmc_riscv_flat_o    = mmc_riscv_o;

  mmc_mem_flat_o      = mmc_mem_o;
  mem_mmc_i           = mem_mmc_flat_i;

  mmc_ddr3_flat_o     = mmc_ddr3_o;
  ddr3_mmc_i          = ddr3_mmc_flat_i;

  mmc_ddr3cntl_flat_o = mmc_ddr3cntl_o;
  ddr3cntl_mmc_i      = ddr3cntl_mmc_flat_i;

  mmc_led_flat_o      = mmc_led_o;
  led_mmc_i           = led_mmc_flat_i;

  mmc_keys_flat_o     = mmc_keys_o;
  keys_mmc_i          = keys_mmc_flat_i;

  mmc_uart_flat_o     = mmc_uart_o;
  uart_mmc_i          = uart_mmc_flat_i;

  mmc_sdcard_flat_o   = mmc_sdcard_o;
  sdcard_mmc_i        = sdcard_mmc_flat_i;

  mmc_debug_flat_o    = mmc_debug_o;
  debug_mmc_i         = debug_mmc_flat_i;
end


logic null_ack;

logic [15:0]    mem_stb_cnt;
logic [15:0]    ddr3_stb_cnt;
logic [15:0]    ddr3cntl_stb_cnt;
logic [15:0]    led_stb_cnt;
logic [15:0]    keys_stb_cnt;
logic [15:0]    uart_stb_cnt;
logic [15:0]    sdcard_stb_cnt;
logic [15:0]    debug_stb_cnt;

//Memory mapping
logic [31:0]    MEM_ADDR_LO      = 'h0000_0000;
logic [31:0]    MEM_ADDR_HI      = 'h0000_7FFF;
logic [31:0]    DDR3_ADDR_LO     = 'h1000_0000;
logic [31:0]    DDR3_ADDR_HI     = 'h13FF_FFFF;
logic [31:0]    LED_ADDR_LO      = 'hC000_0000;
logic [31:0]    LED_ADDR_HI      = 'hC000_FFFF;
logic [31:0]    KEYS_ADDR_LO     = 'hC100_0000;
logic [31:0]    KEYS_ADDR_HI     = 'hC100_FFFF;
logic [31:0]    UART_ADDR_LO     = 'hC304_0000;
logic [31:0]    UART_ADDR_HI     = 'hC304_FFFF;
logic [31:0]    SDCARD_ADDR_LO   = 'hC400_0000;
logic [31:0]    SDCARD_ADDR_HI   = 'hC400_FFFF;
logic [31:0]    DDR3CNTL_ADDR_LO = 'hC500_0000;
logic [31:0]    DDR3CNTL_ADDR_HI = 'hC500_FFFF;
logic [31:0]    DEBUG_ADDR_LO    = 'hD000_0000;
logic [31:0]    DEBUG_ADDR_HI    = 'hD000_07FF;

//Instruction counters
always_ff @(posedge clk)
  begin
  mem_stb_cnt      <= mem_stb_cnt      + {{15{1'b0}},mmc_mem_o.Stb}      - {{15{1'b0}},mem_mmc_i.Ack};
  ddr3_stb_cnt     <= ddr3_stb_cnt     + {{15{1'b0}},mmc_ddr3_o.Stb}     - {{15{1'b0}},ddr3_mmc_i.Ack};
  ddr3cntl_stb_cnt <= ddr3cntl_stb_cnt + {{15{1'b0}},mmc_ddr3cntl_o.Stb} - {{15{1'b0}},ddr3cntl_mmc_i.Ack};
  led_stb_cnt      <= led_stb_cnt      + {{15{1'b0}},mmc_led_o.Stb}      - {{15{1'b0}},led_mmc_i.Ack};
  keys_stb_cnt     <= keys_stb_cnt     + {{15{1'b0}},mmc_keys_o.Stb}     - {{15{1'b0}},keys_mmc_i.Ack};
  uart_stb_cnt     <= uart_stb_cnt     + {{15{1'b0}},mmc_uart_o.Stb}     - {{15{1'b0}},uart_mmc_i.Ack};
  sdcard_stb_cnt   <= sdcard_stb_cnt   + {{15{1'b0}},mmc_sdcard_o.Stb}   - {{15{1'b0}},sdcard_mmc_i.Ack};
  debug_stb_cnt    <= debug_stb_cnt    + {{15{1'b0}},mmc_debug_o.Stb}    - {{15{1'b0}},debug_mmc_i.Ack};

  if(rst)
    begin
    mem_stb_cnt      <= '0;
    ddr3_stb_cnt     <= '0;
    ddr3cntl_stb_cnt <= '0;
    led_stb_cnt      <= '0;
    keys_stb_cnt     <= '0;
    uart_stb_cnt     <= '0;
    sdcard_stb_cnt   <= '0;
    debug_stb_cnt    <= '0;
    end
  end
//
//CPU to subsystems
always_comb
  begin
  mmc_mem_o.Stb    = '0;
  mmc_ddr3_o.Stb   = '0;
  mmc_ddr3cntl_o.Stb   = '0;
  mmc_led_o.Stb    = '0;
  mmc_keys_o.Stb   = '0;
  mmc_uart_o.Stb   = '0;
  mmc_sdcard_o.Stb = '0;
  mmc_debug_o.Stb = '0;

  //Generate regs based on memory map
  if(riscv_mmc_i.Adr >= MEM_ADDR_LO &
     riscv_mmc_i.Adr <= MEM_ADDR_HI)
    begin
    mmc_mem_o.Stb = riscv_mmc_i.Stb;
    end

  if(riscv_mmc_i.Adr >= DDR3_ADDR_LO &
     riscv_mmc_i.Adr <= DDR3_ADDR_HI)
    begin
    mmc_ddr3_o.Stb = riscv_mmc_i.Stb;
    end

  if(riscv_mmc_i.Adr >= DDR3CNTL_ADDR_LO &
     riscv_mmc_i.Adr <= DDR3CNTL_ADDR_HI)
    begin
    mmc_ddr3cntl_o.Stb = riscv_mmc_i.Stb;
    end

  if(riscv_mmc_i.Adr >= LED_ADDR_LO &
     riscv_mmc_i.Adr <= LED_ADDR_HI)
    begin
    mmc_led_o.Stb = riscv_mmc_i.Stb;
    end

  if(riscv_mmc_i.Adr >= KEYS_ADDR_LO &
     riscv_mmc_i.Adr <= KEYS_ADDR_HI)
    begin
    mmc_keys_o.Stb = riscv_mmc_i.Stb;
    end

  if(riscv_mmc_i.Adr >= UART_ADDR_LO &
     riscv_mmc_i.Adr <= UART_ADDR_HI)
    begin
    mmc_uart_o.Stb = riscv_mmc_i.Stb;
    end

  if(riscv_mmc_i.Adr >= SDCARD_ADDR_LO &
     riscv_mmc_i.Adr <= SDCARD_ADDR_HI)
    begin
    mmc_sdcard_o.Stb = riscv_mmc_i.Stb;
    end

  if(riscv_mmc_i.Adr >= DEBUG_ADDR_LO &
     riscv_mmc_i.Adr <= DEBUG_ADDR_HI)
    begin
    mmc_debug_o.Stb = riscv_mmc_i.Stb;
    end

  mmc_mem_o.Adr       = riscv_mmc_i.Adr - MEM_ADDR_LO;
  mmc_mem_o.Data      = riscv_mmc_i.Data;
  mmc_mem_o.We        = riscv_mmc_i.We;
  mmc_mem_o.Sel       = riscv_mmc_i.Sel;
  mmc_mem_o.Cyc       = riscv_mmc_i.Cyc;
  mmc_mem_o.Tga       = riscv_mmc_i.Tga;
  mmc_mem_o.Tgd       = riscv_mmc_i.Tgd;
  mmc_mem_o.Tgc       = riscv_mmc_i.Tgc;


  mmc_ddr3_o.Adr      = riscv_mmc_i.Adr - DDR3_ADDR_LO;
  mmc_ddr3_o.Data     = riscv_mmc_i.Data;
  mmc_ddr3_o.We       = riscv_mmc_i.We;
  mmc_ddr3_o.Sel      = riscv_mmc_i.Sel;
  mmc_ddr3_o.Cyc      = riscv_mmc_i.Cyc;
  mmc_ddr3_o.Tga      = riscv_mmc_i.Tga;
  mmc_ddr3_o.Tgd      = riscv_mmc_i.Tgd;
  mmc_ddr3_o.Tgc      = riscv_mmc_i.Tgc;


  mmc_ddr3cntl_o.Adr  = riscv_mmc_i.Adr - DDR3CNTL_ADDR_LO;
  mmc_ddr3cntl_o.Data = riscv_mmc_i.Data;
  mmc_ddr3cntl_o.We   = riscv_mmc_i.We;
  mmc_ddr3cntl_o.Sel  = riscv_mmc_i.Sel;
  mmc_ddr3cntl_o.Cyc  = riscv_mmc_i.Cyc;
  mmc_ddr3cntl_o.Tga  = riscv_mmc_i.Tga;
  mmc_ddr3cntl_o.Tgd  = riscv_mmc_i.Tgd;
  mmc_ddr3cntl_o.Tgc  = riscv_mmc_i.Tgc;


  mmc_led_o.Adr       = riscv_mmc_i.Adr - LED_ADDR_LO;
  mmc_led_o.Data      = riscv_mmc_i.Data;
  mmc_led_o.We        = riscv_mmc_i.We;
  mmc_led_o.Sel       = riscv_mmc_i.Sel;
  mmc_led_o.Cyc       = riscv_mmc_i.Cyc;
  mmc_led_o.Tga       = riscv_mmc_i.Tga;
  mmc_led_o.Tgd       = riscv_mmc_i.Tgd;
  mmc_led_o.Tgc       = riscv_mmc_i.Tgc;


  mmc_keys_o.Adr      = riscv_mmc_i.Adr - KEYS_ADDR_LO;
  mmc_keys_o.Data     = riscv_mmc_i.Data;
  mmc_keys_o.We       = riscv_mmc_i.We;
  mmc_keys_o.Sel      = riscv_mmc_i.Sel;
  mmc_keys_o.Cyc      = riscv_mmc_i.Cyc;
  mmc_keys_o.Tga      = riscv_mmc_i.Tga;
  mmc_keys_o.Tgd      = riscv_mmc_i.Tgd;
  mmc_keys_o.Tgc      = riscv_mmc_i.Tgc;


  mmc_uart_o.Adr      = riscv_mmc_i.Adr - UART_ADDR_LO;
  mmc_uart_o.Data     = riscv_mmc_i.Data;
  mmc_uart_o.We       = riscv_mmc_i.We;
  mmc_uart_o.Sel      = riscv_mmc_i.Sel;
  mmc_uart_o.Cyc      = riscv_mmc_i.Cyc;
  mmc_uart_o.Tga      = riscv_mmc_i.Tga;
  mmc_uart_o.Tgd      = riscv_mmc_i.Tgd;
  mmc_uart_o.Tgc      = riscv_mmc_i.Tgc;


  mmc_sdcard_o.Adr    = riscv_mmc_i.Adr - SDCARD_ADDR_LO;
  mmc_sdcard_o.Data   = riscv_mmc_i.Data;
  mmc_sdcard_o.We     = riscv_mmc_i.We;
  mmc_sdcard_o.Sel    = riscv_mmc_i.Sel;
  mmc_sdcard_o.Cyc    = riscv_mmc_i.Cyc;
  mmc_sdcard_o.Tga    = riscv_mmc_i.Tga;
  mmc_sdcard_o.Tgd    = riscv_mmc_i.Tgd;
  mmc_sdcard_o.Tgc    = riscv_mmc_i.Tgc;


  mmc_debug_o.Adr     = riscv_mmc_i.Adr - DEBUG_ADDR_LO;
  mmc_debug_o.Data    = riscv_mmc_i.Data;
  mmc_debug_o.We      = riscv_mmc_i.We;
  mmc_debug_o.Sel     = riscv_mmc_i.Sel;
  mmc_debug_o.Cyc     = riscv_mmc_i.Cyc;
  mmc_debug_o.Tga     = riscv_mmc_i.Tga;
  mmc_debug_o.Tgd     = riscv_mmc_i.Tgd;
  mmc_debug_o.Tgc     = riscv_mmc_i.Tgc;
  end

//Subsystems to CPU
always_comb
  begin
  mmc_riscv_o.Ack   = '0;
  mmc_riscv_o.Stall = '0;
  mmc_riscv_o.Err   = '0;
  mmc_riscv_o.Rty   = '0;
  mmc_riscv_o.Data  = '0;
  mmc_riscv_o.Tga   = '0;
  mmc_riscv_o.Tgd   = '0;
  mmc_riscv_o.Tgc   = '0;

  if(mem_stb_cnt > 0)
    begin
    mmc_riscv_o.Stall = mem_mmc_i.Stall;
    end

  if(ddr3_stb_cnt > 0)
    begin
    mmc_riscv_o.Stall = ddr3_mmc_i.Stall;
    end

  if(ddr3cntl_stb_cnt > 0)
    begin
    mmc_riscv_o.Stall = ddr3cntl_mmc_i.Stall;
    end

  if(led_stb_cnt > 0)
    begin
    mmc_riscv_o.Stall = led_mmc_i.Stall;
    end

  if(keys_stb_cnt > 0)
    begin
    mmc_riscv_o.Stall = keys_mmc_i.Stall;
    end

  if(uart_stb_cnt > 0)
    begin
    mmc_riscv_o.Stall = uart_mmc_i.Stall;
    end

  if(sdcard_stb_cnt > 0)
    begin
    mmc_riscv_o.Stall = sdcard_mmc_i.Stall;
    end

  if(debug_stb_cnt > 0)
    begin
    mmc_riscv_o.Stall = debug_mmc_i.Stall;
    end

  if(mem_mmc_i.Ack | mem_mmc_i.Err | mem_mmc_i.Rty)
    begin
    mmc_riscv_o.Ack   = mem_mmc_i.Ack;
    mmc_riscv_o.Err   = mem_mmc_i.Err;
    mmc_riscv_o.Rty   = mem_mmc_i.Rty;
    mmc_riscv_o.Data  = mem_mmc_i.Data;
    mmc_riscv_o.Tga   = mem_mmc_i.Tga;
    mmc_riscv_o.Tgd   = mem_mmc_i.Tgd;
    mmc_riscv_o.Tgc   = mem_mmc_i.Tgc;
    end

  if(ddr3_mmc_i.Ack | ddr3_mmc_i.Err | ddr3_mmc_i.Rty)
    begin
    mmc_riscv_o.Ack   = ddr3_mmc_i.Ack;
    mmc_riscv_o.Err   = ddr3_mmc_i.Err;
    mmc_riscv_o.Rty   = ddr3_mmc_i.Rty;
    mmc_riscv_o.Data  = ddr3_mmc_i.Data;
    mmc_riscv_o.Tga   = ddr3_mmc_i.Tga;
    mmc_riscv_o.Tgd   = ddr3_mmc_i.Tgd;
    mmc_riscv_o.Tgc   = ddr3_mmc_i.Tgc;
    end

  if(ddr3cntl_mmc_i.Ack | ddr3cntl_mmc_i.Err | ddr3cntl_mmc_i.Rty)
    begin
    mmc_riscv_o.Ack   = ddr3cntl_mmc_i.Ack;
    mmc_riscv_o.Err   = ddr3cntl_mmc_i.Err;
    mmc_riscv_o.Rty   = ddr3cntl_mmc_i.Rty;
    mmc_riscv_o.Data  = ddr3cntl_mmc_i.Data;
    mmc_riscv_o.Tga   = ddr3cntl_mmc_i.Tga;
    mmc_riscv_o.Tgd   = ddr3cntl_mmc_i.Tgd;
    mmc_riscv_o.Tgc   = ddr3cntl_mmc_i.Tgc;
    end

  if(led_mmc_i.Ack | led_mmc_i.Err | led_mmc_i.Rty)
    begin
    mmc_riscv_o.Ack   = led_mmc_i.Ack;
    mmc_riscv_o.Err   = led_mmc_i.Err;
    mmc_riscv_o.Rty   = led_mmc_i.Rty;
    mmc_riscv_o.Data  = led_mmc_i.Data;
    mmc_riscv_o.Tga   = led_mmc_i.Tga;
    mmc_riscv_o.Tgd   = led_mmc_i.Tgd;
    mmc_riscv_o.Tgc   = led_mmc_i.Tgc;
    end

  if(keys_mmc_i.Ack | keys_mmc_i.Err | keys_mmc_i.Rty)
    begin
    mmc_riscv_o.Ack   = keys_mmc_i.Ack;
    mmc_riscv_o.Err   = keys_mmc_i.Err;
    mmc_riscv_o.Rty   = keys_mmc_i.Rty;
    mmc_riscv_o.Data  = keys_mmc_i.Data;
    mmc_riscv_o.Tga   = keys_mmc_i.Tga;
    mmc_riscv_o.Tgd   = keys_mmc_i.Tgd;
    mmc_riscv_o.Tgc   = keys_mmc_i.Tgc;
    end

  if(uart_mmc_i.Ack | uart_mmc_i.Err | uart_mmc_i.Rty)
    begin
    mmc_riscv_o.Ack   = uart_mmc_i.Ack;
    mmc_riscv_o.Err   = uart_mmc_i.Err;
    mmc_riscv_o.Rty   = uart_mmc_i.Rty;
    mmc_riscv_o.Data  = uart_mmc_i.Data;
    mmc_riscv_o.Tga   = uart_mmc_i.Tga;
    mmc_riscv_o.Tgd   = uart_mmc_i.Tgd;
    mmc_riscv_o.Tgc   = uart_mmc_i.Tgc;
    end

  if(sdcard_mmc_i.Ack | sdcard_mmc_i.Err | sdcard_mmc_i.Rty)
    begin
    mmc_riscv_o.Ack   = sdcard_mmc_i.Ack;
    mmc_riscv_o.Err   = sdcard_mmc_i.Err;
    mmc_riscv_o.Rty   = sdcard_mmc_i.Rty;
    mmc_riscv_o.Data  = sdcard_mmc_i.Data;
    mmc_riscv_o.Tga   = sdcard_mmc_i.Tga;
    mmc_riscv_o.Tgd   = sdcard_mmc_i.Tgd;
    mmc_riscv_o.Tgc   = sdcard_mmc_i.Tgc;
    end

  if(debug_mmc_i.Ack | debug_mmc_i.Err | debug_mmc_i.Rty)
    begin
    mmc_riscv_o.Ack   = debug_mmc_i.Ack;
    mmc_riscv_o.Err   = debug_mmc_i.Err;
    mmc_riscv_o.Rty   = debug_mmc_i.Rty;
    mmc_riscv_o.Data  = debug_mmc_i.Data;
    mmc_riscv_o.Tga   = debug_mmc_i.Tga;
    mmc_riscv_o.Tgd   = debug_mmc_i.Tgd;
    mmc_riscv_o.Tgc   = debug_mmc_i.Tgc;
    end

  if(null_ack)
    begin
    mmc_riscv_o.Ack   = '1;
    mmc_riscv_o.Stall = '0;
    mmc_riscv_o.Err   = '1;
    mmc_riscv_o.Rty   = '0;
    mmc_riscv_o.Data  = '0;
    mmc_riscv_o.Tga   = '0;
    mmc_riscv_o.Tgd   = '0;
    mmc_riscv_o.Tgc   = '0;
    end

  end

//Null address responder
//Return ack in next cycle with 0 data if no address match, avoids hang
always_ff @(posedge clk)
  begin
  null_ack <= '0;
  if( riscv_mmc_i.Stb &
     ~mmc_mem_o.Stb &
     ~mmc_ddr3_o.Stb &
     ~mmc_ddr3cntl_o.Stb &
     ~mmc_led_o.Stb &
     ~mmc_keys_o.Stb &
     ~mmc_uart_o.Stb &
     ~mmc_sdcard_o.Stb &
     ~mmc_debug_o.Stb)
    begin
    null_ack <= '1;
    end
  if(rst)
    begin
    null_ack <= '0;
    end
  end

endmodule
