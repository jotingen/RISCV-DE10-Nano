class wishbone_monitor;

  string name = "wishbone_mon";

  logic verbose = 1;

  logic write;
  
  function void monitor(
    input wishbone_pkg::bus_req_t bus_req,
    input wishbone_pkg::bus_rsp_t bus_rsp
    );

    if(bus_req.Cyc & bus_req.Stb)
    begin
      if(bus_req.We)
      begin
        write = 1;
        if(verbose) $display("INFO:  [%0t][%s]: Req Write 0x%08X: 0x%08X", $time, name, bus_req.Adr, bus_req.Data);
      end
      else
      begin
        write = 0;
        if(verbose) $display("INFO:  [%0t][%s]: Req Read 0x%08X", $time, name, bus_req.Adr);
      end
    end

    if(bus_rsp.Stall)
    begin
        if(verbose) $display("INFO:  [%0t][%s]: Stall", $time, name);
    end

    if(bus_rsp.Ack)
    begin
      if(write)
      begin
        if(verbose) $display("INFO:  [%0t][%s]: Rsp", $time, name);
      end 
      else
      begin
        if(verbose) $display("INFO:  [%0t][%s]: Rsp 0x%08X", $time, name, bus_rsp.Data);
      end
    end

  endfunction

endclass
