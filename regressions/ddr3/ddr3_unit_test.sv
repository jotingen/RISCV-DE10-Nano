`include "svunit_defines.svh"

`include "clk_and_reset.svh"
`include "ddr3_clk_and_reset.svh"

`include "../../src/de10nano/ddr3/ddr3.sv"
`include "../../src/common/lru_16.sv"

`include "../../src/de10nano/ddr3/ddr3_fifo.v"
`include "../../src/quartus/wishbone_buff/wishbone_buff.v"
`include "/mnt/c/intelFPGA_lite/19.1/quartus/eda/sim_lib/altera_mf.v"

`include "ddr3_mem.sv"
`include "ddr3_wishbone_driver.sv"
`include "ddr3_wishbone_monitor.sv"

module ddr3_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "ddr3_ut";
  svunit_testcase svunit_ut;


  `CLK_RESET_FIXTURE(20,10)
  `DDR3_CLK_RESET_FIXTURE(3,10)

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

  ddr3_mem dut_mem;
  ddr3_mem test_mem;

  ddr3_wishbone_driver bus_inst_driver;
  ddr3_wishbone_monitor bus_inst_monitor;

  initial
  begin
    dut_mem  = new();
    test_mem = new dut_mem;
    dut_mem.name  = "dut_mem";
    test_mem.name = "test_mem";

    bus_inst_driver = new();
    bus_inst_driver.name = "bus_inst";

    bus_inst_monitor = new();
    bus_inst_monitor.name = "bus_inst";
  end

  //DDR3 Monitor
  logic [9:0][25:0]    ddr3_avl_addr_dly;        
  logic [9:0][127:0]   ddr3_avl_wdata_dly;       
  logic [9:0]          ddr3_avl_read_req_dly;    
  logic [9:0]          ddr3_avl_write_req_dly;   
  logic [9:0][8:0]     ddr3_avl_size_dly;
  logic [25:0]    ddr3_avl_addr_stgd;        
  logic [127:0]   ddr3_avl_wdata_stgd;       
  logic           ddr3_avl_read_req_stgd;    
  logic           ddr3_avl_write_req_stgd;   
  logic [8:0]     ddr3_avl_size_stgd;

  always_ff @(posedge ddr3_clk)
  begin
    ddr3_avl_addr_dly[0]      <= ddr3_avl_addr;        
    ddr3_avl_wdata_dly[0]     <= ddr3_avl_wdata;       
    ddr3_avl_read_req_dly[0]  <= ddr3_avl_read_req;    
    ddr3_avl_write_req_dly[0] <= ddr3_avl_write_req;   
    ddr3_avl_size_dly[0]      <= ddr3_avl_size;
    for(int i = 1; i < 10; i++)
    begin
      ddr3_avl_addr_dly[i]      <= ddr3_avl_addr_dly[i-1];        
      ddr3_avl_wdata_dly[i]     <= ddr3_avl_wdata_dly[i-1];       
      ddr3_avl_read_req_dly[i]  <= ddr3_avl_read_req_dly[i-1];    
      ddr3_avl_write_req_dly[i] <= ddr3_avl_write_req_dly[i-1];   
      ddr3_avl_size_dly[i]      <= ddr3_avl_size_dly[i-1];
    end
    ddr3_avl_addr_stgd      <= ddr3_avl_addr_dly[9];        
    ddr3_avl_wdata_stgd     <= ddr3_avl_wdata_dly[9];       
    ddr3_avl_read_req_stgd  <= ddr3_avl_read_req_dly[9];    
    ddr3_avl_write_req_stgd <= ddr3_avl_write_req_dly[9];   
    ddr3_avl_size_stgd      <= ddr3_avl_size_dly[9];
    if(rst)
    begin
      ddr3_avl_addr_dly       <= '0;
      ddr3_avl_wdata_dly      <= '0;
      ddr3_avl_read_req_dly   <= '0;
      ddr3_avl_write_req_dly  <= '0;
      ddr3_avl_size_dly       <= '0;
      ddr3_avl_addr_stgd      <= '0;
      ddr3_avl_wdata_stgd     <= '0;
      ddr3_avl_read_req_stgd  <= '0;
      ddr3_avl_write_req_stgd <= '0;
      ddr3_avl_size_stgd      <= '0;
    end
  end


  initial
  begin
    forever
    begin
      #0
      if(ddr3_avl_read_req_stgd)
      begin
        ddr3_avl_rdata_valid = '1;
        ddr3_avl_rdata = dut_mem.read(ddr3_avl_addr_stgd);
      end
      if(ddr3_avl_write_req_stgd)
      begin
        dut_mem.write(ddr3_avl_addr_stgd, ddr3_avl_wdata_stgd, 'hF);
      end
      ddr3_step();
    end
  end

  //Monitors
  initial
  begin
    forever
    begin
      nextSamplePoint();
      bus_inst_monitor.monitor(bus_inst_adr_i,
                               bus_inst_data_i,
                               bus_inst_we_i,
                               bus_inst_sel_i,
                               bus_inst_stb_i,
                               bus_inst_cyc_i,
                               bus_inst_tga_i,
                               bus_inst_tgd_i,
                               bus_inst_tgc_i,
                               
                               bus_inst_ack_o,
                               bus_inst_stall_o,
                               bus_inst_err_o,
                               bus_inst_rty_o,
                               bus_inst_data_o,
                               bus_inst_tga_o,
                               bus_inst_tgd_o,
                               bus_inst_tgc_o);
      step();
    end
  end
  
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

  //Wishbone Driver
  initial
    begin
    forever
      begin
      bus_inst_driver.drive(bus_inst_adr_i,
                            bus_inst_data_i,
                            bus_inst_we_i,
                            bus_inst_sel_i,
                            bus_inst_stb_i,
                            bus_inst_cyc_i,
                            bus_inst_tga_i,
                            bus_inst_tgd_i,
                            bus_inst_tgc_i,
                            bus_inst_stall_o);
      step();
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
  step(10);
  for(int i = 0; i < 'h7F; i++)
  begin
    bus_inst_driver.read($urandom_range(511,0)<<2);
    //bus_inst_driver.write(i<<2, {32{i[2]^i[0]}});
    //bus_inst_cyc_i = '1;
    //bus_inst_stb_i = '1;
    //bus_inst_we_i  = '1;
    //bus_inst_adr_i = i * 4;//$random() & 32'h01FF_FFFC;//i * 4;
    //bus_inst_data_i = {32{i[2]^i[0]}};//$random() & 32'h01FF_FFFC;//i * 4;
    //test_mem.write(bus_inst_adr_i>>4,bus_inst_data_i,{(bus_inst_adr_i>>2)&'h3==3,
    //                                                  (bus_inst_adr_i>>2)&'h3==2,
    //                                                  (bus_inst_adr_i>>2)&'h3==1,
    //                                                  (bus_inst_adr_i>>2)&'h3==0});
    //step();
  end
  while(bus_inst_driver.requests_queued())
  begin
    step();
  end
  step(100);
  `SVTEST_END


  `SVUNIT_TESTS_END

endmodule
