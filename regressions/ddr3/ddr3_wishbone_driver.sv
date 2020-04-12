class ddr3_wishbone_driver;
  string name = "ddr3_wishbone_driver";

  logic verbose = '0;
  logic        we[$];
  logic [31:0] adr[$];
  logic [31:0] data[$];

  function new();
  endfunction

  function write(logic [31:0] adr, logic [31:0] data);
    this.we.push_back('1);
    this.adr.push_back(adr);
    this.data.push_back(data);
  endfunction

  function read(logic [31:0] adr);
    this.we.push_back('0);
    this.adr.push_back(adr);
  endfunction

  function drive(ref logic [31:0]    adr_i,
                 ref logic [31:0]    data_i,
                 ref logic           we_i,
                 ref logic  [3:0]    sel_i,
                 ref logic           stb_i,
                 ref logic           cyc_i,
                 ref logic           tga_i,
                 ref logic           tgd_i,
                 ref logic  [3:0]    tgc_i,
                     logic           stall_o);
    //if(verbose) $display("  [%s]: Entries Remaining: %d",name, we.size());
    if(requests_queued() && !stall_o && $urandom_range(10,0)>1)
    begin
      adr_i = adr.pop_front();
      we_i = we.pop_front();
      if(we_i)
        data_i = data.pop_front();
      else
        data_i = '0;
      sel_i = 'hF;
      stb_i = '1;
      cyc_i = '1;
      tga_i = '0;
      tgd_i = '0;
      tgc_i = '0;
    end
    else
    begin
      adr_i = '0;
      we_i = '0;
      data_i = '0;
      sel_i = 'h0;
      stb_i = '0;
      cyc_i = '0;
      tga_i = '0;
      tgd_i = '0;
      tgc_i = '0;
    end
  endfunction

  function int requests_queued();
    return we.size();
  endfunction

endclass


