class ddr3_wishbone_monitor;
  string name = "ddr3_wishbone_monitor";

  function new();
  endfunction

  function monitor(logic [31:0]    adr_i,
                   logic [31:0]    data_i,
                   logic           we_i,
                   logic  [3:0]    sel_i,
                   logic           stb_i,
                   logic           cyc_i,
                   logic           tga_i,
                   logic           tgd_i,
                   logic  [3:0]    tgc_i,
                   logic           ack_o,
                   logic           stall_o,
                   logic           err_o,
                   logic           rty_o,
                   logic [31:0]    data_o,
                   logic           tga_o,
                   logic           tgd_o,
                   logic  [3:0]    tgc_o);
    if(stb_i & cyc_i)
    begin
      if(we_i)
      begin
        $display("  [%s]: Write Request addr=0x%08X data=0x%08X", name, adr_i, data_i);
      end
      else
      begin
        $display("  [%s]: Read Request addr=0x%08X", name, adr_i);
      end
    end
  endfunction

endclass

