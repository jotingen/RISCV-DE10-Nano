`include "ddr3_unit_test_header.svh"

module ddr3_unit_test;

  `include "ddr3_unit_test_setup.svh"

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

  `SVTEST(MEM)
  test_program(0, 10000);
  `SVTEST_END

  `SVUNIT_TESTS_END

endmodule
