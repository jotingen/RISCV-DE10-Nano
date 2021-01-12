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

wishbone_pkg::bus_req_t bus_inst_i;
wishbone_pkg::bus_rsp_t bus_inst_o;
wishbone_pkg::bus_req_t bus_data_i;
wishbone_pkg::bus_rsp_t bus_data_o;

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

ddr3_wishbone_driver bus_data_driver;
ddr3_wishbone_monitor bus_data_monitor;

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

  bus_data_driver = new();
  bus_data_driver.name = "bus_data_drv";
  bus_data_driver.verbose = VERBOSE;

  bus_data_monitor = new(mem_tst);
  bus_data_monitor.name = "bus_data_mon";
  bus_data_monitor.verbose = VERBOSE;
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
    bus_inst_monitor.monitor(bus_inst_i.Adr,
                             bus_inst_i.Data,
                             bus_inst_i.We,
                             bus_inst_i.Sel,
                             bus_inst_i.Stb,
                             bus_inst_i.Cyc,
                             bus_inst_i.Tga,
                             bus_inst_i.Tgd,
                             bus_inst_i.Tgc,
                             
                             bus_inst_o.Ack,
                             bus_inst_o.Stall,
                             bus_inst_o.Err,
                             bus_inst_o.Rty,
                             bus_inst_o.Data,
                             bus_inst_o.Tga,
                             bus_inst_o.Tgd,
                             bus_inst_o.Tgc);
    bus_data_monitor.monitor(bus_data_i.Adr,
                            bus_data_i.Data,
                            bus_data_i.We,
                            bus_data_i.Sel,
                            bus_data_i.Stb,
                            bus_data_i.Cyc,
                            bus_data_i.Tga,
                            bus_data_i.Tgd,
                            bus_data_i.Tgc,
                            
                            bus_data_o.Ack,
                            bus_data_o.Stall,
                            bus_data_o.Err,
                            bus_data_o.Rty,
                            bus_data_o.Data,
                            bus_data_o.Tga,
                            bus_data_o.Tgd,
                            bus_data_o.Tgc);
    step();
  end
end

//===================================
// This is the UUT that we're 
// running the Unit Tests on
//===================================
ddr3 my_ddr3(.*,

             .bus_cntl_flat_i ('0),
             .bus_cntl_flat_o (),
                            
             .bus_inst_flat_i (bus_inst_i),
             .bus_inst_flat_o (bus_inst_o),
                            
             .bus_data_flat_i (bus_data_i),
             .bus_data_flat_o (bus_data_o));


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
    bus_inst_driver.drive(bus_inst_i.Adr,
                          bus_inst_i.Data,
                          bus_inst_i.We,
                          bus_inst_i.Sel,
                          bus_inst_i.Stb,
                          bus_inst_i.Cyc,
                          bus_inst_i.Tga,
                          bus_inst_i.Tgd,
                          bus_inst_i.Tgc,
                          bus_inst_o.Stall);
    bus_data_driver.drive(bus_data_i.Adr,
                         bus_data_i.Data,
                         bus_data_i.We,
                         bus_data_i.Sel,
                         bus_data_i.Stb,
                         bus_data_i.Cyc,
                         bus_data_i.Tga,
                         bus_data_i.Tgd,
                         bus_data_i.Tgc,
                         bus_data_o.Stall);
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

task test_program(int inst_op_count, int mem_op_count);
  time  start_time;
  time  done_time;

  automatic int   inst_ops  = 0;
  automatic int   mem_ops   = 0;
  automatic logic inst_done = '0;
  automatic logic mem_done  = '0;

  //Initial addresses
  automatic logic [31:0] bus_inst_addr = 'd0;
  automatic logic [31:0] bus_data_addr  = 'd1024;

  //Set test mem to dut mem
  foreach(mem_dut.mem[i])
  begin
    mem_tst.mem[i] = mem_dut.mem[i];
  end

  //Generate inst ops
  for(int i = 0; i < inst_op_count; i++)
  begin
    if($urandom_range(25,0) == 0 || bus_inst_addr >= 'd508)
      bus_inst_addr = $urandom_range(508,0);
    else
      bus_inst_addr += 4;

    inst_ops++;
    bus_inst_driver.read(bus_inst_addr);
  end

  //Generate mem ops
  for(int i = 0; i < mem_op_count; i++)
  begin
    if($urandom_range(10,0) == 0 || bus_data_addr >= 'd4092)
      bus_data_addr = $urandom_range(4092,1024);
    else
      bus_data_addr += 4;

    if($urandom_range(1,0)>0)
    begin
      mem_ops++;
      bus_data_driver.write(bus_data_addr,$urandom());//{32{i[2]^i[0]}});
    end
    else
    begin
      mem_ops++;
      bus_data_driver.read(bus_data_addr);
    end
  end

  start_time = $time;
  while(bus_inst_driver.requests_queued() |
        bus_data_driver.requests_queued() |
        bus_inst_monitor.responses_queued() |
        bus_data_monitor.responses_queued())
  begin

    step();

    if(($time/20)%1000 == 0)
    begin
      $display("INFO:  [%1t][%s]: Queues - Inst_Drv:%5d Inst_Mon:%5d Mem_Drv:%5d Mem_Mon:%5d", 
        $time, name, 
        bus_inst_driver.requests_queued(),
        bus_inst_monitor.responses_queued(),
        bus_data_driver.requests_queued(),
        bus_data_monitor.responses_queued() );
    end

    if(~inst_done &
       bus_inst_driver.requests_queued()==0 &
       bus_inst_monitor.responses_queued()==0)
    begin
      inst_done = '1;
      done_time = $time;
    end

    if(~mem_done &
       bus_data_driver.requests_queued()==0 &
       bus_data_monitor.responses_queued()==0)
    begin
      mem_done = '1;
      done_time = $time;
    end
  end
  step(100);
  $display("%1dops/%1dcycles = %fops/cycle", (inst_op_count+mem_op_count), (done_time-start_time)/20, (inst_op_count+mem_op_count)/real'((done_time-start_time)/20));
  $display("%1dcycles/%1dops = %fcycle/op", (done_time-start_time)/20,   (inst_op_count+mem_op_count), (done_time-start_time)/20/real'(inst_op_count+mem_op_count));
endtask

