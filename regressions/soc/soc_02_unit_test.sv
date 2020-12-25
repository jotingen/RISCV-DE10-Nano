`include "soc_unit_test_header.svh"

module soc_unit_test;
  `include "soc_unit_test_setup.svh"

  defparam de10nano.mem.ram.altsyncram_component.init_file = "../../output/programs/regressions/02_debug_sweep.32.hex";

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

  int cycleCount;
  `SVUNIT_TESTS_BEGIN

  `SVTEST(SOC_02_DEBUG_SWEEP)
  cycleCount = 0;
  //$readmemh("../../output/programs/regressions/02_debug_sweep_3.v", de10nano.mem.mem_array_3);
  //$readmemh("../../output/programs/regressions/02_debug_sweep_2.v", de10nano.mem.mem_array_2);
  //$readmemh("../../output/programs/regressions/02_debug_sweep_1.v", de10nano.mem.mem_array_1);
  //$readmemh("../../output/programs/regressions/02_debug_sweep_0.v", de10nano.mem.mem_array_0);
  $readmemh("../../verif/sdcard.txt", sd.flash_mem);

  while(!( cycleCount > 1000000 |
           rvfi_mon.endLoop) )
  begin
    cycleCount++;
    step();
  end

  `FAIL_IF(cycleCount >= 1000000);
  $display("End Loop Detected");

  `FAIL_UNLESS(led_mon.q_LED[0] === 'd0)
  $display("LED Pattern Detected");

  `SVTEST_END                        


  `SVUNIT_TESTS_END

endmodule
