`include "svunit_defines.svh"

`include "../../src/de10nano/ddr3/ddr3.sv"
`include "../../src/common/lru_16.sv"

`include "../../src/de10nano/ddr3/ddr3_fifo.v"
`include "../../src/quartus/wishbone_buff/wishbone_buff.v"
`include "/mnt/c/intelFPGA_lite/19.1/quartus/eda/sim_lib/altera_mf.v"

module ddr3_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "ddr3_ut";
  svunit_testcase svunit_ut;

  logic           clk;
  logic           ddr3_clk;
  logic           rst;

  logic           ddr3_avl_ready;       
  logic [25:0]    ddr3_avl_addr;        
  logic           ddr3_avl_rdata_valid; 
  logic [127:0]   ddr3_avl_rdata;       
  logic [127:0]   ddr3_avl_wdata;       
  logic           ddr3_avl_read_req;    
  logic           ddr3_avl_write_req;   
  logic [8:0]     ddr3_avl_size;

  logic [31:0]    bus_inst_adr_i;
  logic [31:0]    bus_inst_data_i;
  logic           bus_inst_we_i;
  logic  [3:0]    bus_inst_sel_i;
  logic           bus_inst_stb_i;
  logic           bus_inst_cyc_i;
  logic           bus_inst_tga_i;
  logic           bus_inst_tgd_i;
  logic  [3:0]    bus_inst_tgc_i;

  logic           bus_inst_ack_o;
  logic           bus_inst_stall_o;
  logic           bus_inst_err_o;
  logic           bus_inst_rty_o;
  logic [31:0]    bus_inst_data_o;
  logic           bus_inst_tga_o;
  logic           bus_inst_tgd_o;
  logic  [3:0]    bus_inst_tgc_o;

  logic           i_membus_req;
  logic           i_membus_write;
  logic [31:0]    i_membus_addr;
  logic [31:0]    i_membus_data;
  logic  [3:0]    i_membus_data_rd_mask;
  logic  [3:0]    i_membus_data_wr_mask;

  logic           o_membus_ack;
  logic [31:0]    o_membus_data;

  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  ddr3 my_ddr3(.*);


  //===================================
  // Build
  //===================================
  function void build();
    svunit_ut = new(name);

    //my_ddr3 = new(/* New arguments if needed */);
  endfunction


  //===================================
  // Setup for running the Unit Tests
  //===================================
  task setup();
    svunit_ut.setup();
    /* Place Setup Code Here */

  endtask


  //===================================
  // Here we deconstruct anything we 
  // need after running the Unit Tests
  //===================================
  task teardown();
    svunit_ut.teardown();
    /* Place Teardown Code Here */

  endtask


  //===================================
  // All tests are defined between the
  // SVUNIT_TESTS_BEGIN/END macros
  //
  // Each individual test must be
  // defined between `SVTEST(_NAME_)
  // `SVTEST_END
  //
  // i.e.
  //   `SVTEST(mytest)
  //     <test code>
  //   `SVTEST_END
  //===================================
  `SVUNIT_TESTS_BEGIN

  `SVTEST(TEST)
  $display("TEST");
  `SVTEST_END


  `SVUNIT_TESTS_END

endmodule
