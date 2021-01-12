`include "svunit_defines.svh"

`include "clk_and_reset.svh"
`include "ddr3_clk_and_reset.svh"

`include "../../../src/rtl/wishbone/wishbone_pkg.sv"

`include "../../../submodules/mor1kx/rtl/verilog/mor1kx_cache_lru.v"

`include "../../../src/rtl/de10nano/ddr3/ddr3.sv"
`include "../../../src/rtl/de10nano/ddr3/ddr3_cntl.sv"
`include "../../../src/rtl/de10nano/ddr3/ddr3_cache.sv"
`include "../../../src/rtl/de10nano/ddr3/ddr3_cache_set.sv"
`include "../../../src/rtl/common/lru_32.sv"
`include "../../../src/rtl/common/lru_16.sv"

`include "../../../src/rtl/de10nano/ddr3/ddr3_fifo.v"
`include "../../../src/rtl/quartus/wishbone_buff/wishbone_buff.v"

`include "ddr3_mem.sv"
`include "ddr3_wishbone_driver.sv"
`include "ddr3_wishbone_monitor.sv"

