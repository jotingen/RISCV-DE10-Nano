`include "../../soc_header.svh"

module soc_unit_test;
  `include "../../soc_setup.svh"

  defparam de10nano.mem.ram.altsyncram_component.init_file = "../../../../../target/programs/bootloader/bootloader_preloaded.32.hex";

  `SVUNIT_TESTS_BEGIN

  `SVTEST(DUNGEON_CRAWLER)
  cycleCountMax = 1000000;
  cycleCount = 0;
  $readmemh("../../../../../target/programs/apps/dungeon_crawler/dungeon_crawler.ddr3mem.v", ddr3.ddr3);

  while(!( cycleCount > cycleCountMax |
           rvfi_mon.endLoop) )
  begin
    cycleCount++;
    step();
  end

  `FAIL_IF(cycleCount >= cycleCountMax);


  `SVTEST_END                        


  `SVUNIT_TESTS_END

endmodule
