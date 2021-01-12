`include "../../soc_header.svh"

module soc_unit_test;
  `include "../../soc_setup.svh"

  defparam de10nano.mem.ram.altsyncram_component.init_file = "../../../../output/programs/regressions/01_debug.32.hex";

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

  `SVTEST(SOC_01_DEBUG)
  cycleCountMax = 1000000;
  cycleCount = 0;

  while(!( cycleCount > cycleCountMax |
           rvfi_mon.endLoop) )
  begin
    cycleCount++;
    step();
  end

  `FAIL_IF(cycleCount >= cycleCountMax);
  $display("End Loop Detected");

  `FAIL_UNLESS(led_mon.q_LED[0] === 'd0)
  $display("LED Pattern Detected");

  `SVTEST_END                        

  `SVUNIT_TESTS_END

endmodule
