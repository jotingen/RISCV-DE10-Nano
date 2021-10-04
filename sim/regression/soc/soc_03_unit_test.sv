`include "../../soc_header.svh"

module soc_unit_test;
  `include "../../soc_setup.svh"

  defparam de10nano.mem.ram.altsyncram_component.init_file = "../../../../target/programs/regressions/03_sdcard.32.hex";

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

  `SVTEST(SOC_03_SDCARD)
  cycleCountMax = 2000000;
  cycleCount = 0;
  $readmemh("../../../../verif/sdcard.txt", sd.flash_mem);

  while(!( cycleCount > cycleCountMax |
           rvfi_mon.endLoop) )
  begin
    cycleCount++;
    step();
  end

  `FAIL_IF(cycleCount >= cycleCountMax);
  $display("End Loop Detected");

  for(int i = 0; i < 127; i++)
  begin
//    if(sd.flash_mem[4*i+0] !== de10nano.debug.mem_array_0[i])
//    begin
//      $display("sd.flash_mem[%1d]:%02X !== de10nano.debug.mem_array_0[%1d]:%02X",
//        i,sd.flash_mem[4*i+0],
//        i,de10nano.debug.mem_array_0[i]);
//    end
//    `FAIL_IF(sd.flash_mem[4*i+0] !== de10nano.debug.mem_array_0[i])
//
//    if(sd.flash_mem[4*i+1] !== de10nano.debug.mem_array_1[i])
//    begin
//      $display("sd.flash_mem[%1d]:%02X !== de10nano.debug.mem_array_1[%1d]:%02X",
//        i,sd.flash_mem[4*i+1],
//        i,de10nano.debug.mem_array_1[i]);
//    end
//    `FAIL_IF(sd.flash_mem[4*i+1] !== de10nano.debug.mem_array_1[i])
//
//    if(sd.flash_mem[4*i+2] !== de10nano.debug.mem_array_2[i])
//    begin
//      $display("sd.flash_mem[%1d]:%02X !== de10nano.debug.mem_array_2[%1d]:%02X",
//        i,sd.flash_mem[4*i+2],
//        i,de10nano.debug.mem_array_2[i]);
//    end
//    `FAIL_IF(sd.flash_mem[4*i+2] !== de10nano.debug.mem_array_2[i])
//
//    if(sd.flash_mem[4*i+3] !== de10nano.debug.mem_array_3[i])
//    begin
//      $display("sd.flash_mem[%1d]:%02X !== de10nano.debug.mem_array_3[%1d]:%02X",
//        i,sd.flash_mem[4*i+3],
//        i,de10nano.debug.mem_array_3[i]);
//    end
//    `FAIL_IF(sd.flash_mem[4*i+3] !== de10nano.debug.mem_array_3[i])
  end

  `SVTEST_END                        


  `SVUNIT_TESTS_END

endmodule
