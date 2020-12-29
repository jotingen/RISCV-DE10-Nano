class rvfi_monitor;

  logic verbose = 1;

  logic        q_rvfi_valid[$];
  logic [63:0] q_rvfi_order[$];
  logic [31:0] q_rvfi_insn[$];
  logic        q_rvfi_trap[$];
  logic        q_rvfi_halt[$];
  logic        q_rvfi_intr[$];
  logic [ 1:0] q_rvfi_mode[$];
  logic [ 4:0] q_rvfi_rs1_addr[$];
  logic [ 4:0] q_rvfi_rs2_addr[$];
  logic [31:0] q_rvfi_rs1_rdata[$];
  logic [31:0] q_rvfi_rs2_rdata[$];
  logic [ 4:0] q_rvfi_rd_addr[$];
  logic [31:0] q_rvfi_rd_wdata[$];
  logic [31:0] q_rvfi_pc_rdata[$];
  logic [31:0] q_rvfi_pc_wdata[$];
  logic [31:0] q_rvfi_mem_addr[$];
  logic [ 3:0] q_rvfi_mem_rmask[$];
  logic [ 3:0] q_rvfi_mem_wmask[$];
  logic [31:0] q_rvfi_mem_rdata[$];
  logic [31:0] q_rvfi_mem_wdata[$];
       
  logic [63:0] q_rvfi_csr_mcycle_rmask[$];
  logic [63:0] q_rvfi_csr_mcycle_wmask[$];
  logic [63:0] q_rvfi_csr_mcycle_rdata[$];
  logic [63:0] q_rvfi_csr_mcycle_wdata[$];
        
  logic [63:0] q_rvfi_csr_minstret_rmask[$];
  logic [63:0] q_rvfi_csr_minstret_wmask[$];
  logic [63:0] q_rvfi_csr_minstret_rdata[$];
  logic [63:0] q_rvfi_csr_minstret_wdata[$];

  function void reset();
    q_rvfi_valid.delete();
    q_rvfi_order.delete();
    q_rvfi_insn.delete();
    q_rvfi_trap.delete();
    q_rvfi_halt.delete();
    q_rvfi_intr.delete();
    q_rvfi_mode.delete();
    q_rvfi_rs1_addr.delete();
    q_rvfi_rs2_addr.delete();
    q_rvfi_rs1_rdata.delete();
    q_rvfi_rs2_rdata.delete();
    q_rvfi_rd_addr.delete();
    q_rvfi_rd_wdata.delete();
    q_rvfi_pc_rdata.delete();
    q_rvfi_pc_wdata.delete();
    q_rvfi_mem_addr.delete();
    q_rvfi_mem_rmask.delete();
    q_rvfi_mem_wmask.delete();
    q_rvfi_mem_rdata.delete();
    q_rvfi_mem_wdata.delete();
    
    q_rvfi_csr_mcycle_rmask.delete();
    q_rvfi_csr_mcycle_wmask.delete();
    q_rvfi_csr_mcycle_rdata.delete();
    q_rvfi_csr_mcycle_wdata.delete();
    
    q_rvfi_csr_minstret_rmask.delete();
    q_rvfi_csr_minstret_wmask.delete();
    q_rvfi_csr_minstret_rdata.delete();
    q_rvfi_csr_minstret_wdata.delete();
  endfunction

  function void monitor(
    input logic [5:0]       rvfi_valid,
    input logic [5:0][63:0] rvfi_order,
    input logic [5:0][31:0] rvfi_insn,
    input logic [5:0]       rvfi_trap,
    input logic [5:0]       rvfi_halt,
    input logic [5:0]       rvfi_intr,
    input logic [5:0][ 1:0] rvfi_mode,
    input logic [5:0][ 4:0] rvfi_rs1_addr,
    input logic [5:0][ 4:0] rvfi_rs2_addr,
    input logic [5:0][31:0] rvfi_rs1_rdata,
    input logic [5:0][31:0] rvfi_rs2_rdata,
    input logic [5:0][ 4:0] rvfi_rd_addr,
    input logic [5:0][31:0] rvfi_rd_wdata,
    input logic [5:0][31:0] rvfi_pc_rdata,
    input logic [5:0][31:0] rvfi_pc_wdata,
    input logic [5:0][31:0] rvfi_mem_addr,
    input logic [5:0][ 3:0] rvfi_mem_rmask,
    input logic [5:0][ 3:0] rvfi_mem_wmask,
    input logic [5:0][31:0] rvfi_mem_rdata,
    input logic [5:0][31:0] rvfi_mem_wdata,
       
    input logic [5:0][63:0] rvfi_csr_mcycle_rmask,
    input logic [5:0][63:0] rvfi_csr_mcycle_wmask,
    input logic [5:0][63:0] rvfi_csr_mcycle_rdata,
    input logic [5:0][63:0] rvfi_csr_mcycle_wdata,
        
    input logic [5:0][63:0] rvfi_csr_minstret_rmask,
    input logic [5:0][63:0] rvfi_csr_minstret_wmask,
    input logic [5:0][63:0] rvfi_csr_minstret_rdata,
    input logic [5:0][63:0] rvfi_csr_minstret_wdata
    );

    for(int i = 0; i <= 5; i++)
      if(rvfi_valid[i])
      begin
        q_rvfi_valid.push_front(             rvfi_valid[i]             );
        q_rvfi_order.push_front(             rvfi_order[i]             );
        q_rvfi_insn.push_front(              rvfi_insn[i]              );
        q_rvfi_trap.push_front(              rvfi_trap[i]              );
        q_rvfi_halt.push_front(              rvfi_halt[i]              );
        q_rvfi_intr.push_front(              rvfi_intr[i]              );
        q_rvfi_mode.push_front(              rvfi_mode[i]              );
        q_rvfi_rs1_addr.push_front(          rvfi_rs1_addr[i]          );
        q_rvfi_rs2_addr.push_front(          rvfi_rs2_addr[i]          );
        q_rvfi_rs1_rdata.push_front(         rvfi_rs1_rdata[i]         );
        q_rvfi_rs2_rdata.push_front(         rvfi_rs2_rdata[i]         );
        q_rvfi_rd_addr.push_front(           rvfi_rd_addr[i]           );
        q_rvfi_rd_wdata.push_front(          rvfi_rd_wdata[i]          );
        q_rvfi_pc_rdata.push_front(          rvfi_pc_rdata[i]          );
        q_rvfi_pc_wdata.push_front(          rvfi_pc_wdata[i]          );
        q_rvfi_mem_addr.push_front(          rvfi_mem_addr[i]          );
        q_rvfi_mem_rmask.push_front(         rvfi_mem_rmask[i]         );
        q_rvfi_mem_wmask.push_front(         rvfi_mem_wmask[i]         );
        q_rvfi_mem_rdata.push_front(         rvfi_mem_rdata[i]         );
        q_rvfi_mem_wdata.push_front(         rvfi_mem_wdata[i]         );
        
        q_rvfi_csr_mcycle_rmask.push_front(  rvfi_csr_mcycle_rmask[i]  );
        q_rvfi_csr_mcycle_wmask.push_front(  rvfi_csr_mcycle_wmask[i]  );
        q_rvfi_csr_mcycle_rdata.push_front(  rvfi_csr_mcycle_rdata[i]  );
        q_rvfi_csr_mcycle_wdata.push_front(  rvfi_csr_mcycle_wdata[i]  );
        
        q_rvfi_csr_minstret_rmask.push_front(rvfi_csr_minstret_rmask[i]);
        q_rvfi_csr_minstret_wmask.push_front(rvfi_csr_minstret_wmask[i]);
        q_rvfi_csr_minstret_rdata.push_front(rvfi_csr_minstret_rdata[i]);
        q_rvfi_csr_minstret_wdata.push_front(rvfi_csr_minstret_wdata[i]);
        if(!endLoop())
          if(verbose) $display("INFO:  [%0t][rvfi_mon]: Executed order 0x%016x: 0x%08x:0x%08x", $time, rvfi_order[i], rvfi_pc_rdata[i], rvfi_insn[i]);
      end
    
  endfunction

  function logic endLoop(
    );

    if(q_rvfi_insn[0] == 'h0000006f &
       q_rvfi_insn[1] == 'h0000006f)
    begin
      return '1;
    end

    if(q_rvfi_insn[0] == 'h0000a001 &
       q_rvfi_insn[1] == 'h0000a001)
    begin
      return '1;
    end

    return '0;

  endfunction

endclass
