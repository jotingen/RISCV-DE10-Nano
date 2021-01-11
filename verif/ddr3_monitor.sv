class ddr3_monitor;

  logic verbose = 1;
  logic error = 0;

  function logic fail();
    return error;
  endfunction

  function void reset();
    error = 0;
  endfunction

  function void monitor(
    input logic [5:0]       rvfi_valid,
    input logic [5:0][31:0] rvfi_insn,
    input logic [5:0][31:0] rvfi_pc_rdata,
    ref   logic     [127:0] ddr3 [2**(26-4)-1:0]
    );

    for(int i = 0; i <= 5; i++)
    begin
      if(rvfi_valid[i] && 
         rvfi_pc_rdata[i] >= 'h1000_0000 &&
         rvfi_pc_rdata[i] <= 'h13FF_FFFF ) 
      begin
        logic [31:0] ddr3_adr;
        logic [127:0] ddr3_line;
        logic [127:0] ddr3_lineP1;
        logic [9:0][15:0] ddr3_halfwords;
        logic [1:0][15:0] ddr3_data;

        ddr3_adr = rvfi_pc_rdata[i]-'h1000_0000;
        ddr3_line = ddr3[ddr3_adr>>4];
        ddr3_lineP1 = ddr3[(ddr3_adr>>4)+1];
        ddr3_halfwords = {ddr3_lineP1[23:16], ddr3_lineP1[31:24],
                          ddr3_lineP1[7:0],   ddr3_lineP1[15:8],
                          ddr3_line[119:112], ddr3_line[127:120],
                          ddr3_line[103:96],  ddr3_line[111:104],
                          ddr3_line[87:80],   ddr3_line[95:88],
                          ddr3_line[71:64],   ddr3_line[79:72],
                          ddr3_line[55:48],   ddr3_line[63:56],
                          ddr3_line[39:32],   ddr3_line[47:40],
                          ddr3_line[23:16],   ddr3_line[31:24],
                          ddr3_line[7:0],     ddr3_line[15:8]};

        case(ddr3_adr[3:1])
          3'b111: ddr3_data[0] = ddr3_halfwords[6]; 
          3'b110: ddr3_data[0] = ddr3_halfwords[7];
          3'b101: ddr3_data[0] = ddr3_halfwords[4];
          3'b100: ddr3_data[0] = ddr3_halfwords[5];
          3'b011: ddr3_data[0] = ddr3_halfwords[2];
          3'b010: ddr3_data[0] = ddr3_halfwords[3];
          3'b001: ddr3_data[0] = ddr3_halfwords[0];
          3'b000: ddr3_data[0] = ddr3_halfwords[1];
        endcase

        ddr3_data[1] = '0;
        if(ddr3_data[0][1:0] == 2'b11)
        begin
          case(ddr3_adr[3:1])
            3'b111: ddr3_data[1] = ddr3_halfwords[9]; 
            3'b110: ddr3_data[1] = ddr3_halfwords[6];
            3'b101: ddr3_data[1] = ddr3_halfwords[7];
            3'b100: ddr3_data[1] = ddr3_halfwords[4];
            3'b011: ddr3_data[1] = ddr3_halfwords[5];
            3'b010: ddr3_data[1] = ddr3_halfwords[2];
            3'b001: ddr3_data[1] = ddr3_halfwords[3];
            3'b000: ddr3_data[1] = ddr3_halfwords[0];
          endcase
        end 

        if(verbose || rvfi_insn[i] != ddr3_data)
        begin
          //$display("INFO:  [%0t][rvfi_mem_mon]:                                                                    111 110 101 100 011 010 001 000", $time);
          //$display("INFO:  [%0t][rvfi_mem_mon]: adr 0x%08x ddr3_adr 0x%08x ddr3_adr[3:1] %03b  ddr3_line 0x%032X %04x %04x %04x %04x %04x %04x %04x %04x %04x", 
          //  $time,
          //  rvfi_pc_rdata[i], 
          //  ddr3_adr,
          //  ddr3_adr[3:1],
          //  ddr3_line,
          //  ddr3_halfwords[8],
          //  ddr3_halfwords[7],
          //  ddr3_halfwords[6],
          //  ddr3_halfwords[5],
          //  ddr3_halfwords[4],
          //  ddr3_halfwords[3],
          //  ddr3_halfwords[2],
          //  ddr3_halfwords[1],
          //  ddr3_halfwords[0]);

          $display("INFO:  [%0t][rvfi_mem_mon]: RVFI[%1d] Adr 0x%08x Data 0x%08x DDR3 0x%08x", 
            $time, 
            i, 
            rvfi_pc_rdata[i], 
            rvfi_insn[i], 
            ddr3_data);

          error = rvfi_insn[i] != ddr3_data;
        end

        //`FAIL_UNLESS(rvfi_insn[i] == ddr3_data);
      end
    end
    
  endfunction

endclass
