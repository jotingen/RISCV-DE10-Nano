class debug_monitor;
  
  function void monitor(
    input wishbone_pkg::bus_req_t mmc_debug_data,
    input wishbone_pkg::bus_rsp_t debug_mmc_data
    );

    if(mmc_debug_data.Cyc & mmc_debug_data.Stb)
    begin
      if(mmc_debug_data.We)
      begin
        $display("INFO:  [%0t][debug_mon]: Write 0x%08X: 0x%08X", $time, mmc_debug_data.Adr, mmc_debug_data.Data);
      end
      else
      begin
        $display("INFO:  [%0t][debug_mon]: Read 0x%08X", $time, mmc_debug_data.Adr);
      end
    end

  endfunction

endclass
