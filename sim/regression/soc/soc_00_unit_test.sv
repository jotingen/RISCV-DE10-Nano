`include "../../soc_header.svh"

module soc_unit_test;
  `include "../../soc_setup.svh"

  defparam de10nano.mem.ram.altsyncram_component.init_file = "../../../../target/programs/regressions/00_led123.32.hex";

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

  `SVTEST(SOC_00_LED123)
  cycleCountMax = 10000;
  cycleCount = 0;

  while(!( cycleCount > cycleCountMax |
           rvfi_mon.endLoop) )
  begin
    cycleCount++;
    step();
  end

  `FAIL_IF(cycleCount >= 10000);
  $display("End Loop Detected");


  `FAIL_UNLESS(led_mon.q_LED[0] === 'd3 & led_mon.q_LED[1] === 'd2 & led_mon.q_LED[2] === 'd1)
  $display("LED Pattern Detected");

  `SVTEST_END

  `SVUNIT_TESTS_END

endmodule
