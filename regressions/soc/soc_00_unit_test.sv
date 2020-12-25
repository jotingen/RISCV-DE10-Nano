`include "soc_unit_test_header.svh"

module soc_unit_test;
  `include "soc_unit_test_setup.svh"

  defparam de10nano.mem.ram.altsyncram_component.init_file = "../../output/programs/regressions/00_led123.32.hex";

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

  `SVTEST(SOC_00_LED123)
  cycleCount = 0;
  //$readmemh("../../output/programs/regressions/00_led123_3.v", de10nano.mem.mem_array_3);
  //$readmemh("../../output/programs/regressions/00_led123_2.v", de10nano.mem.mem_array_2);
  //$readmemh("../../output/programs/regressions/00_led123_1.v", de10nano.mem.mem_array_1);
  //$readmemh("../../output/programs/regressions/00_led123_0.v", de10nano.mem.mem_array_0);
  $readmemh("../../verif/sdcard.txt", sd.flash_mem);

  while(!( cycleCount > 100000 |
           rvfi_mon.endLoop) )
  begin
    cycleCount++;
    step();
  end

  `FAIL_IF(cycleCount >= 100000);
  $display("End Loop Detected");


  `FAIL_UNLESS(led_mon.q_LED[0] === 'd3 & led_mon.q_LED[1] === 'd2 & led_mon.q_LED[2] === 'd1)
  $display("LED Pattern Detected");

  `SVTEST_END

  `SVUNIT_TESTS_END

endmodule
