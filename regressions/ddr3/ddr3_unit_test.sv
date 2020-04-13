`include "svunit_defines.svh"

`include "clk_and_reset.svh"
`include "ddr3_clk_and_reset.svh"

`include "../../src/de10nano/ddr3/ddr3.sv"
`include "../../src/de10nano/ddr3/ddr3_cache.sv"
`include "../../src/common/lru_32.sv"
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

  localparam      MEM_CYC_DELAY = 25*20/3;
  localparam      VERBOSE = 0;

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

  logic [31:0]    bus_mem_adr_i;
  logic [31:0]    bus_mem_data_i;
  logic           bus_mem_we_i;
  logic  [3:0]    bus_mem_sel_i;
  logic           bus_mem_stb_i;
  logic           bus_mem_cyc_i;
  logic           bus_mem_tga_i;
  logic           bus_mem_tgd_i;
  logic  [3:0]    bus_mem_tgc_i;

  logic           bus_mem_ack_o;
  logic           bus_mem_stall_o;
  logic           bus_mem_err_o;
  logic           bus_mem_rty_o;
  logic [31:0]    bus_mem_data_o;
  logic           bus_mem_tga_o;
  logic           bus_mem_tgd_o;
  logic  [3:0]    bus_mem_tgc_o;

  logic           i_membus_req;
  logic           i_membus_write;
  logic [31:0]    i_membus_addr;
  logic [31:0]    i_membus_data;
  logic  [3:0]    i_membus_data_rd_mask;
  logic  [3:0]    i_membus_data_wr_mask;

  logic           o_membus_ack;
  logic [31:0]    o_membus_data;


  ddr3_mem mem_dut;
  ddr3_mem mem_tst;

  ddr3_wishbone_driver bus_inst_driver;
  ddr3_wishbone_monitor bus_inst_monitor;

  ddr3_wishbone_driver bus_mem_driver;
  ddr3_wishbone_monitor bus_mem_monitor;

  initial
  begin
    mem_dut  = new();
    mem_dut.randomize_mem();
    mem_dut.name  = "mem_dut";
    mem_dut.verbose = VERBOSE;
    mem_tst = new();
    mem_tst.name = "mem_tst";
    mem_tst.verbose = VERBOSE;

    bus_inst_driver = new();
    bus_inst_driver.name = "bus_ins_drv";
    bus_inst_driver.verbose = VERBOSE;

    bus_inst_monitor = new(mem_tst);
    bus_inst_monitor.name = "bus_ins_mon";
    bus_inst_monitor.verbose = VERBOSE;

    bus_mem_driver = new();
    bus_mem_driver.name = "bus_mem_drv";
    bus_mem_driver.verbose = VERBOSE;

    bus_mem_monitor = new(mem_tst);
    bus_mem_monitor.name = "bus_mem_mon";
    bus_mem_monitor.verbose = VERBOSE;
  end

  //DDR3 Emulation
  logic [MEM_CYC_DELAY-1:0][25:0]  ddr3_avl_addr_dly;        
  logic [MEM_CYC_DELAY-1:0][127:0] ddr3_avl_wdata_dly;       
  logic [MEM_CYC_DELAY-1:0]        ddr3_avl_read_req_dly;    
  logic [MEM_CYC_DELAY-1:0]        ddr3_avl_write_req_dly;   
  logic [MEM_CYC_DELAY-1:0][8:0]   ddr3_avl_size_dly;
  logic [25:0]                     ddr3_avl_addr_stgd;        
  logic [127:0]                    ddr3_avl_wdata_stgd;       
  logic                            ddr3_avl_read_req_stgd;    
  logic                            ddr3_avl_write_req_stgd;   
  logic [8:0]                      ddr3_avl_size_stgd;

  always_ff @(posedge ddr3_clk)
  begin
    ddr3_avl_addr_dly[0]      <= ddr3_avl_addr;        
    ddr3_avl_wdata_dly[0]     <= ddr3_avl_wdata;       
    ddr3_avl_read_req_dly[0]  <= ddr3_avl_read_req;    
    ddr3_avl_write_req_dly[0] <= ddr3_avl_write_req;   
    ddr3_avl_size_dly[0]      <= ddr3_avl_size;
    for(int i = 1; i < MEM_CYC_DELAY; i++)
    begin
      ddr3_avl_addr_dly[i]      <= ddr3_avl_addr_dly[i-1];        
      ddr3_avl_wdata_dly[i]     <= ddr3_avl_wdata_dly[i-1];       
      ddr3_avl_read_req_dly[i]  <= ddr3_avl_read_req_dly[i-1];    
      ddr3_avl_write_req_dly[i] <= ddr3_avl_write_req_dly[i-1];   
      ddr3_avl_size_dly[i]      <= ddr3_avl_size_dly[i-1];
    end
    ddr3_avl_addr_stgd      <= ddr3_avl_addr_dly[MEM_CYC_DELAY-1];        
    ddr3_avl_wdata_stgd     <= ddr3_avl_wdata_dly[MEM_CYC_DELAY-1];       
    ddr3_avl_read_req_stgd  <= ddr3_avl_read_req_dly[MEM_CYC_DELAY-1];    
    ddr3_avl_write_req_stgd <= ddr3_avl_write_req_dly[MEM_CYC_DELAY-1];   
    ddr3_avl_size_stgd      <= ddr3_avl_size_dly[MEM_CYC_DELAY-1];
    if(ddr3_rst)
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

  always_ff @(posedge ddr3_clk)
  begin
    ddr3_avl_ready       <= '0;

    ddr3_avl_rdata_valid <= '0;
    ddr3_avl_rdata       <= '0;
    if(ddr3_avl_read_req_stgd)
    begin
      ddr3_avl_rdata_valid <= '1;
      ddr3_avl_rdata <= mem_dut.read(ddr3_avl_addr_stgd);
    end
    if(ddr3_avl_write_req_stgd)
    begin
      mem_dut.write(ddr3_avl_addr_stgd, ddr3_avl_wdata_stgd[127:96], 'h8);
      mem_dut.write(ddr3_avl_addr_stgd, ddr3_avl_wdata_stgd[95:64] , 'h4);
      mem_dut.write(ddr3_avl_addr_stgd, ddr3_avl_wdata_stgd[63:32] , 'h2);
      mem_dut.write(ddr3_avl_addr_stgd, ddr3_avl_wdata_stgd[31:0]  , 'h1);
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
      bus_mem_monitor.monitor(bus_mem_adr_i,
                              bus_mem_data_i,
                              bus_mem_we_i,
                              bus_mem_sel_i,
                              bus_mem_stb_i,
                              bus_mem_cyc_i,
                              bus_mem_tga_i,
                              bus_mem_tgd_i,
                              bus_mem_tgc_i,
                              
                              bus_mem_ack_o,
                              bus_mem_stall_o,
                              bus_mem_err_o,
                              bus_mem_rty_o,
                              bus_mem_data_o,
                              bus_mem_tga_o,
                              bus_mem_tgd_o,
                              bus_mem_tgc_o);
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
    fork
      reset();
      ddr3_reset();
    join

  endtask


  //===================================
  // Here we deconstruct anything we 
  // need after running the Unit Tests
  //===================================
  task teardown();
    svunit_ut.teardown();
    /* Place Teardown Code Here */
    step();

  endtask

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
      bus_mem_driver.drive(bus_mem_adr_i,
                           bus_mem_data_i,
                           bus_mem_we_i,
                           bus_mem_sel_i,
                           bus_mem_stb_i,
                           bus_mem_cyc_i,
                           bus_mem_tga_i,
                           bus_mem_tgd_i,
                           bus_mem_tgc_i,
                           bus_mem_stall_o);
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
    //$dumpvars();
    $dumpvars(100, my_ddr3);
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
  task test_program(int inst_op_count, int mem_op_count);
    time  start_time;
    time  done_time;

    automatic int   inst_ops  = 0;
    automatic int   mem_ops   = 0;
    automatic logic inst_done = '0;
    automatic logic mem_done  = '0;

    //Initial addresses
    automatic logic [31:0] bus_inst_addr = 'd0;
    automatic logic [31:0] bus_mem_addr  = 'd512;

    //Set test mem to dut mem
    foreach(mem_dut.mem[i])
    begin
      mem_tst.mem[i] = mem_dut.mem[i];
    end

    //Generate inst ops
    for(int i = 0; i < inst_op_count; i++)
    begin
      if($urandom_range(25,0) == 0 || bus_inst_addr == 'd511)
        bus_inst_addr = $urandom_range(511,0);
      else
        bus_inst_addr++;

      inst_ops++;
      bus_inst_driver.read(bus_inst_addr<<2);
    end

    //Generate mem ops
    for(int i = 0; i < mem_op_count; i++)
    begin
      if($urandom_range(10,0) == 0 || bus_mem_addr == 'd1023)
        bus_mem_addr = $urandom_range(1023,512);
      else
        bus_mem_addr++;

      if($urandom_range(1,0)>0)
      begin
        mem_ops++;
        bus_mem_driver.write(bus_mem_addr<<2,$urandom());//{32{i[2]^i[0]}});
      end
      else
      begin
        mem_ops++;
        bus_mem_driver.read(bus_mem_addr<<2);
      end
    end

    start_time = $time;
    while(bus_inst_driver.requests_queued() |
          bus_mem_driver.requests_queued() |
          bus_inst_monitor.responses_queued() |
          bus_mem_monitor.responses_queued())
    begin

      step();

      if(($time/20)%1000 == 0)
      begin
        $display("INFO:  [%1t][%s]: Queues - Inst_Drv:%5d Inst_Mon:%5d Mem_Drv:%5d Mem_Mon:%5d", 
          $time, name, 
          bus_inst_driver.requests_queued(),
          bus_inst_monitor.responses_queued(),
          bus_mem_driver.requests_queued(),
          bus_mem_monitor.responses_queued() );
      end

      if(~inst_done &
         bus_inst_driver.requests_queued()==0 &
         bus_inst_monitor.responses_queued()==0)
      begin
        inst_done = '1;
        done_time = $time;
      end

      if(~mem_done &
         bus_mem_driver.requests_queued()==0 &
         bus_mem_monitor.responses_queued()==0)
      begin
        mem_done = '1;
        done_time = $time;
      end
    end
    step(100);
    $display("%1dops/%1dcycles = %fops/cycle", (inst_op_count+mem_op_count), (done_time-start_time)/20, (inst_op_count+mem_op_count)/real'((done_time-start_time)/20));
    $display("%1dcycles/%1dops = %fcycle/op", (done_time-start_time)/20,   (inst_op_count+mem_op_count), (done_time-start_time)/20/real'(inst_op_count+mem_op_count));
  endtask


  `SVUNIT_TESTS_BEGIN

  `SVTEST(INST)
  test_program(500, 0);
  `SVTEST_END


  `SVTEST(MEM)
  test_program(0, 500);
  `SVTEST_END


  `SVTEST(ALL)
  test_program(500, 500);
  `SVTEST_END


  `SVUNIT_TESTS_END

endmodule
