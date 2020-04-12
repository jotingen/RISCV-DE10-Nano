class ddr3_mem;
  string name = "DDR3_MEM";

  logic verbose = '0;
  logic [127:0] mem[2**25-1:0];

  function new();
    $display("INFO:  [%1t][%s]: Initializing Memory", $time, name);
  endfunction

  task randomize_mem();
    foreach(mem[i])
    begin
      mem[i] = {$random(),$random(),$random(),$random()};
    end
  endtask

  function logic [127:0] read(logic [31:0] addr);
    if(verbose) $display("INFO:  [%1t][%s]: Read mem[0x%08X] = 0x%032X", $time, name, addr, mem[addr]);
    return mem[addr];
  endfunction

  function void write(logic [31:0] addr, logic [31:0] data, logic [3:0] wen);
    if(verbose) $display("INFO:  [%1t][%s]: write addr:0x%08X data:0x%08X wen:0x%1X", $time, name, addr, data, wen  );
    if(verbose) if(wen[3]) $display("INFO:  [%1t][%s]: Write mem[0x%08X][0x3] = 0x%08X", $time, name, addr, data);
    if(verbose) if(wen[2]) $display("INFO:  [%1t][%s]: Write mem[0x%08X][0x2] = 0x%08X", $time, name, addr, data);
    if(verbose) if(wen[1]) $display("INFO:  [%1t][%s]: Write mem[0x%08X][0x1] = 0x%08X", $time, name, addr, data);
    if(verbose) if(wen[0]) $display("INFO:  [%1t][%s]: Write mem[0x%08X][0x0] = 0x%08X", $time, name, addr, data);
    if(verbose) $display("INFO:  [%1t][%s]:   Before: 0x%032X", $time, name, mem[addr]  );
    if(wen[3]) mem[addr][127:96] = data;
    if(wen[2]) mem[addr][95:64]  = data;
    if(wen[1]) mem[addr][63:32]  = data;
    if(wen[0]) mem[addr][31:0]   = data;
    if(verbose) $display("INFO:  [%1t][%s]:   After:  0x%032X", $time, name, mem[addr]  );
  endfunction

endclass
