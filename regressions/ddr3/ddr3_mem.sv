class ddr3_mem;
  string name = "DDR3_MEM";

  logic [127:0] mem[2**25-1:0];

  function new();
    $display("  [%s]: Initializing Memory", name);
    foreach(mem[i])
    begin
      mem[i] = {$random(),$random(),$random(),$random()};
    end
  endfunction

  function logic [127:0] read(logic [31:0] addr);
    $display("  [%s]: Read mem[0x%08X] = 0x%032X", name, addr & 32'h01FF_FFFC, mem[addr & 32'h01FF_FFFC]);
    return mem[addr & 32'h01FF_FFFC];
  endfunction

  function void write(logic [31:0] addr, logic [127:0] data, logic [3:0] wen);
    $display("  [%s]: Write mem[0x%08X] = 0x%032X", name, addr & 32'h01FF_FFFC, data);
    if(wen[3]) mem[addr & 32'h01FF_FFFC][127:96] = data[127:96];
    if(wen[2]) mem[addr & 32'h01FF_FFFC][95:64] = data[95:64];
    if(wen[1]) mem[addr & 32'h01FF_FFFC][63:32] = data[63:32];
    if(wen[0]) mem[addr & 32'h01FF_FFFC][31:0] = data[31:0];
  endfunction

endclass
