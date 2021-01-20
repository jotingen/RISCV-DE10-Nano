`include "../../soc_header.svh"

module soc_unit_test;
  `include "../../soc_setup.svh"

  defparam de10nano.mem.ram.altsyncram_component.init_file = "../../../../output/programs/bootloader/bootloader_preloaded.32.hex";

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

  `SVTEST(SOC_06_UART_INTERRUPT)
  logic uart_check;
  uart_check = 0;
  cycleCountMax = 10000;
  cycleCount = 0;
  $readmemh("../../../../output/programs/apps/regressions/06_uart_interrupt.ddr3mem.v", ddr3.ddr3);

  step(1000); //Wait for uart baud to be set

  uart_dvr.putchar("A");
  step(4096);
  uart_dvr.putchar("B");
  step(2048);
  uart_dvr.putchar("C");
  step(1024);
  uart_dvr.putchar("D");
  step(512);
  uart_dvr.putchar("E");
  step(256);
  uart_dvr.putchar("F");
  step(128);
  uart_dvr.putchar("\n");

  while(!( uart_check |
           cycleCount > cycleCountMax) )
  begin
    uart_check = uart_mon.q_UART[6] === "A" &
                 uart_mon.q_UART[5] === "B" &
                 uart_mon.q_UART[4] === "C" &
                 uart_mon.q_UART[3] === "D" &
                 uart_mon.q_UART[2] === "E" &
                 uart_mon.q_UART[1] === "F" &
                 uart_mon.q_UART[0] === "\n";
    cycleCount++;
    step();
  end

  `FAIL_IF(cycleCount >= cycleCountMax);
  $display("UART Pattern Detected");


  //while(!( cycleCount > cycleCountMax |
  //         rvfi_mon.endLoop) )
  //begin
  //  cycleCount++;
  //  step();
  //end

  //`FAIL_IF(cycleCount >= 10000);
  //$display("End Loop Detected");

  `SVTEST_END                        


  `SVUNIT_TESTS_END

endmodule
