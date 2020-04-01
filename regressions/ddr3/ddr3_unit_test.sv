`include "svunit_defines.svh"

`include "clk_and_reset.svh"
`include "ddr3_clk_and_reset.svh"

`include "../../src/de10nano/ddr3/ddr3.sv"
`include "../../src/common/lru_16.sv"

`include "../../src/de10nano/ddr3/ddr3_fifo.v"
`include "../../src/quartus/wishbone_buff/wishbone_buff.v"
`include "/mnt/c/intelFPGA_lite/19.1/quartus/eda/sim_lib/altera_mf.v"

module ddr3_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "ddr3_ut";
  svunit_testcase svunit_ut;

  `CLK_RESET_FIXTURE(20000,10)
  `DDR3_CLK_RESET_FIXTURE(3000,10)

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

  initial
    begin
    forever
      begin
      ddr3_step();
      ddr3_avl_ready       = '0;
      ddr3_avl_rdata_valid = '0;
      ddr3_avl_rdata       = '0;
      end
    end

  initial
    begin
    forever
      begin
      step();
      bus_inst_adr_i  = '0;
      bus_inst_data_i = '0;
      bus_inst_we_i   = '0;
      bus_inst_sel_i  = '0;
      bus_inst_stb_i  = '0;
      bus_inst_cyc_i  = '0;
      bus_inst_tga_i  = '0;
      bus_inst_tgd_i  = '0;
      bus_inst_tgc_i  = '0;

      i_membus_req          = '0;
      i_membus_write        = '0;
      i_membus_addr         = '0;
      i_membus_data         = '0;
      i_membus_data_rd_mask = '0;
      i_membus_data_wr_mask = '0;
      end
    end

  initial
    begin
    forever
      begin
      step();
      end
    end

  initial
    begin
    forever
      begin
      ddr3_step();
      end
    end

  initial
    begin
    $dumpfile("sim.vcd");
    $dumpvars;
    end

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
  reset();
  step(100);
  for(int i = 0; i < 25; i++)
    begin
    bus_inst_cyc_i = '1;
    bus_inst_stb_i = '1;
    step();
    end
  step(100);
  `SVTEST_END


  `SVUNIT_TESTS_END

endmodule
