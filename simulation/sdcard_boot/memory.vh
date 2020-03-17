initial
  begin
    #1
    $display("I WAS HERE");

    $readmemh("../../output/programs/bootloader/bootloader_sdtest_3.v", dut.mem.mem_array_3);
    $readmemh("../../output/programs/bootloader/bootloader_sdtest_2.v", dut.mem.mem_array_2);
    $readmemh("../../output/programs/bootloader/bootloader_sdtest_1.v", dut.mem.mem_array_1);
    $readmemh("../../output/programs/bootloader/bootloader_sdtest_0.v", dut.mem.mem_array_0);

    $readmemh("../../verif/sdcard.txt", sd.flash_mem);

    //$readmemh("../sdcard.txt", ddr.ddr3);
  end
