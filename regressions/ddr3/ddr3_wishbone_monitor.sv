class ddr3_wishbone_monitor;
  string name = "ddr3_wishbone_monitor";

  logic verbose = '0;
  ddr3_mem mem;
  typedef struct {
    logic           we;
    logic [31:0]    adr;
    logic           err;
    logic           rty;
    logic [31:0]    data;
    logic           tga;
    logic           tgd;
    logic  [3:0]    tgc;
  } response_t;
  response_t exp_rsp[$];

  function new(ref ddr3_mem mem);
    this.mem = mem;
  endfunction

  task monitor(logic [31:0]    adr_i,
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
      if(verbose) $display("INFO:  [%1t][%s]: Request we:%1b adr:0x%08X sel:0x%1X data:0x%08X tga:0x%X tgd:0x%X tgc:0x%X", 
        $time,
        name, 
        we_i,
        adr_i,
        sel_i,
        data_i,
        tga_i,
        tgd_i,
        tgc_i);
      if(we_i)
      begin
        mem.write(adr_i,data_i,{(((adr_i>>2)&'h3)==3),
                                   (((adr_i>>2)&'h3)==2),
                                   (((adr_i>>2)&'h3)==1),
                                   (((adr_i>>2)&'h3)==0)});
        exp_rsp.push_back(response_t'{'1,adr_i,'0,'0,'0,tga_i,tgd_i,tgc_i});
        //if(verbose) $display("INFO:  [%1t][%s]: Write Request addr=0x%08X data=0x%08X", $time, name, adr_i, data_i);
      end
      else
      begin
        logic [127:0] exp_data;
        logic [31:0]  exp_data_word;
        exp_data = mem.read(adr_i);
        if(adr_i[3:2]==3) exp_data_word = exp_data[127:96]; 
        if(adr_i[3:2]==2) exp_data_word = exp_data[95:64];  
        if(adr_i[3:2]==1) exp_data_word = exp_data[63:32];  
        if(adr_i[3:2]==0) exp_data_word = exp_data[31:0];   
        if(verbose) $display("INFO:  [%1t][%s]: Expected Response addr:0x%08X data=0x%08X tga:0x%X tgd:0x%X tgc:0x%X", 
          $time, 
          name, 
          adr_i,
          exp_data_word,
          tga_i,
          tgd_i,
          tgc_i);
        exp_rsp.push_back(response_t'{'0,adr_i,'0,'0,exp_data_word,tga_i,tgd_i,tgc_i});
        //if(verbose) $display("INFO:  [%1t][%s]: Read Request addr=0x%08X", $time, name, adr_i);
      end
    end

    if(ack_o)
    begin
      response_t exp;
      exp = exp_rsp.pop_front();
      if(verbose) $display("INFO:  [%1t][%s]: Response addr:0x%08X err:%1b rty:0x%1b data:0x%08X tga:0x%X tgd:0x%X tgc:0x%X", 
        $time, 
        name,
        exp.adr,
        err_o,
        rty_o,
        data_o,
        tga_o,
        tgd_o,
        tgc_o);
      if(err_o != exp.err) $display("INFO:  [%1t][%s]: Error: err does not match. Exp=0x%1b Actual=0x%1b", $time, name, exp.err, err_o);
      `FAIL_IF(err_o != exp.err);
      if(rty_o != exp.rty) $display("INFO:  [%1t][%s]: Error: rty does not match. Exp=0x%1b Actual=0x%1b", $time, name, exp.rty, rty_o);
      `FAIL_IF(rty_o != exp.rty);
      if(!exp.we)
      begin
        if(data_o != exp.data) $display("INFO:  [%1t][%s]: Error: data does not match. Exp=0x%08X Actual=0x%08X", $time, name, exp.data, data_o);
        `FAIL_IF(data_o != exp.data);
      end
      if(tga_o != exp.tga) $display("INFO:  [%1t][%s]: Error: tga does not match. Exp=0x%X Actual=0x%X", $time, name, exp.tga, tga_o);
      `FAIL_IF(tga_o != exp.tga);                                                                           
      if(tgd_o != exp.tgd) $display("INFO:  [%1t][%s]: Error: tgd does not match. Exp=0x%X Actual=0x%X", $time, name, exp.tgd, tgd_o);
      `FAIL_IF(tgd_o != exp.tgd);                                                                           
      if(tgc_o != exp.tgc) $display("INFO:  [%1t][%s]: Error: tgc does not match. Exp=0x%X Actual=0x%X", $time, name, exp.tgc, tgc_o);
      `FAIL_IF(tgc_o != exp.tgc);


    end
  endtask

  function int responses_queued();
    return exp_rsp.size();
  endfunction

endclass

