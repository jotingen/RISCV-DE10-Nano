module riscv_wbu #(
  parameter M_EXT = 1
)  (              
  output logic        wbu_vld,
  output logic [31:0] wbu_inst,
  output logic [63:0] wbu_order,
  output logic        wbu_retired,
  output logic        wbu_freeze,
  output logic        wbu_br,
  output logic        wbu_br_taken,
  output logic        wbu_br_miss,
  output logic        wbu_trap,
  output logic [31:0] wbu_PC,
  output logic [31:0] wbu_PC_next,
  output logic  [4:0] wbu_rs1,
  output logic  [4:0] wbu_rs2,
  output logic [31:0] wbu_rs1_data,
  output logic [31:0] wbu_rs2_data,
  output logic        wbu_rd_wr,
  output logic  [4:0] wbu_rd,
  output logic [31:0] wbu_rd_data,
  output logic [31:0] wbu_mem_rdata,

  output logic [31:0]       x_wr,
  output logic [31:0]       x00_in,
  output logic [31:0]       x01_in,
  output logic [31:0]       x02_in,
  output logic [31:0]       x03_in,
  output logic [31:0]       x04_in,
  output logic [31:0]       x05_in,
  output logic [31:0]       x06_in,
  output logic [31:0]       x07_in,
  output logic [31:0]       x08_in,
  output logic [31:0]       x09_in,
  output logic [31:0]       x10_in,
  output logic [31:0]       x11_in,
  output logic [31:0]       x12_in,
  output logic [31:0]       x13_in,
  output logic [31:0]       x14_in,
  output logic [31:0]       x15_in,
  output logic [31:0]       x16_in,
  output logic [31:0]       x17_in,
  output logic [31:0]       x18_in,
  output logic [31:0]       x19_in,
  output logic [31:0]       x20_in,
  output logic [31:0]       x21_in,
  output logic [31:0]       x22_in,
  output logic [31:0]       x23_in,
  output logic [31:0]       x24_in,
  output logic [31:0]       x25_in,
  output logic [31:0]       x26_in,
  output logic [31:0]       x27_in,
  output logic [31:0]       x28_in,
  output logic [31:0]       x29_in,
  output logic [31:0]       x30_in,
  output logic [31:0]       x31_in,

  input  logic        alu_vld,
  input  logic [31:0] alu_inst,
  input  logic [63:0] alu_order,
  input  logic        alu_trap,
  input  logic [31:0] alu_PC,
  input  logic [31:0] alu_PC_next,
  input  logic  [4:0] alu_rs1,
  input  logic  [4:0] alu_rs2,
  input  logic [31:0] alu_rs1_data,
  input  logic [31:0] alu_rs2_data,
  input  logic        alu_rd_wr,
  input  logic  [4:0] alu_rd,
  input  logic [31:0] alu_rd_data,
           
  input  logic        mpu_vld,
  input  logic [31:0] mpu_inst,
  input  logic [63:0] mpu_order,
  input  logic        mpu_retired,
  input  logic        mpu_freeze,
  input  logic        mpu_trap,
  input  logic [31:0] mpu_PC,
  input  logic [31:0] mpu_PC_next,
  input  logic  [4:0] mpu_rs1,
  input  logic  [4:0] mpu_rs2,
  input  logic [31:0] mpu_rs1_data,
  input  logic [31:0] mpu_rs2_data,
  input  logic        mpu_rd_wr,
  input  logic  [4:0] mpu_rd,
  input  logic [31:0] mpu_rd_data,
           
  input  logic        dvu_vld,
  input  logic [31:0] dvu_inst,
  input  logic [63:0] dvu_order,
  input  logic        dvu_retired,
  input  logic        dvu_freeze,
  input  logic        dvu_trap,
  input  logic [31:0] dvu_PC,
  input  logic [31:0] dvu_PC_next,
  input  logic  [4:0] dvu_rs1,
  input  logic  [4:0] dvu_rs2,
  input  logic [31:0] dvu_rs1_data,
  input  logic [31:0] dvu_rs2_data,
  input  logic        dvu_rd_wr,
  input  logic  [4:0] dvu_rd,
  input  logic [31:0] dvu_rd_data,
           
  input  logic        lsu_vld,
  input  logic [31:0] lsu_inst,
  input  logic [63:0] lsu_order,
  input  logic        lsu_retired,
  input  logic        lsu_freeze,
  input  logic        lsu_trap,
  input  logic [31:0] lsu_PC,
  input  logic [31:0] lsu_PC_next,
  input  logic  [4:0] lsu_rs1,
  input  logic  [4:0] lsu_rs2,
  input  logic [31:0] lsu_rs1_data,
  input  logic [31:0] lsu_rs2_data,
  input  logic        lsu_rd_wr,
  input  logic  [4:0] lsu_rd,
  input  logic [31:0] lsu_rd_data,
  input  logic [31:0] lsu_mem_rdata,
           
  input  logic        csu_vld,
  input  logic [31:0] csu_inst,
  input  logic [63:0] csu_order,
  input  logic        csu_retired,
  input  logic        csu_freeze,
  input  logic        csu_trap,
  input  logic [31:0] csu_PC,
  input  logic [31:0] csu_PC_next,
  input  logic  [4:0] csu_rs1,
  input  logic  [4:0] csu_rs2,
  input  logic [31:0] csu_rs1_data,
  input  logic [31:0] csu_rs2_data,
  input  logic        csu_rd_wr,
  input  logic  [4:0] csu_rd,
  input  logic [31:0] csu_rd_data,
           
  input  logic        bru_vld,
  input  logic [31:0] bru_inst,
  input  logic [63:0] bru_order,
  input  logic        bru_br,
  input  logic        bru_br_taken,
  input  logic        bru_br_miss,
  input  logic        bru_trap,
  input  logic [31:0] bru_PC,
  input  logic [31:0] bru_PC_next,
  input  logic  [4:0] bru_rs1,
  input  logic  [4:0] bru_rs2,
  input  logic [31:0] bru_rs1_data,
  input  logic [31:0] bru_rs2_data,
  input  logic        bru_rd_wr,
  input  logic  [4:0] bru_rd,
  input  logic [31:0] bru_rd_data
);

always_comb
  begin
  wbu_vld      = alu_vld | 
                 mpu_vld |
                 dvu_vld |
                 lsu_vld |
                 csu_vld |
                 bru_vld;     
  wbu_inst     = ({32{alu_vld}} & alu_inst) | 
                 ({32{mpu_vld}} & mpu_inst) |
                 ({32{dvu_vld}} & dvu_inst) |
                 ({32{lsu_vld}} & lsu_inst) |
                 ({32{csu_vld}} & csu_inst) |
                 ({32{bru_vld}} & bru_inst);                  
  wbu_order    = ({64{alu_vld}} & alu_order) | 
                 ({64{mpu_vld}} & mpu_order) |
                 ({64{dvu_vld}} & dvu_order) |
                 ({64{lsu_vld}} & lsu_order) |
                 ({64{csu_vld}} & csu_order) |
                 ({64{bru_vld}} & bru_order);                  
  wbu_retired  = alu_vld | 
                 (mpu_vld & mpu_retired)|
                 (dvu_vld & dvu_retired)|
                 (lsu_vld & lsu_retired)|
                 (csu_vld & csu_retired)|
                 bru_vld;     
  wbu_freeze   = (mpu_vld & mpu_freeze)|
                 (dvu_vld & dvu_freeze)|
                 (lsu_vld & lsu_freeze)|
                 (csu_vld & csu_freeze);
  wbu_br       = (bru_vld & bru_br);      
  wbu_br_taken = (bru_vld & bru_br_taken);
  wbu_br_miss  = (bru_vld & bru_br_miss); 
  wbu_trap     = (alu_vld & alu_trap) | 
                 (mpu_vld & mpu_trap) |
                 (dvu_vld & dvu_trap) |
                 (lsu_vld & lsu_trap) |
                 (csu_vld & csu_trap) |
                 (bru_vld & bru_trap);    
  wbu_PC       = ({32{alu_vld}} & alu_PC) | 
                 ({32{mpu_vld}} & mpu_PC) |
                 ({32{dvu_vld}} & dvu_PC) |
                 ({32{lsu_vld}} & lsu_PC) |
                 ({32{csu_vld}} & csu_PC) |
                 ({32{bru_vld}} & bru_PC);                  
  wbu_PC_next  = ({32{alu_vld}} & alu_PC_next) | 
                 ({32{mpu_vld}} & mpu_PC_next) |
                 ({32{dvu_vld}} & dvu_PC_next) |
                 ({32{lsu_vld}} & lsu_PC_next) |
                 ({32{csu_vld}} & csu_PC_next) |
                 ({32{bru_vld}} & bru_PC_next);                     
  wbu_rs1      = ({5{alu_vld}} & alu_rs1) | 
                 ({5{mpu_vld}} & mpu_rs1) |
                 ({5{dvu_vld}} & dvu_rs1) |
                 ({5{lsu_vld}} & lsu_rs1) |
                 ({5{csu_vld}} & csu_rs1) |
                 ({5{bru_vld}} & bru_rs1);                  
  wbu_rs2      = ({5{alu_vld}} & alu_rs2) | 
                 ({5{mpu_vld}} & mpu_rs2) |
                 ({5{dvu_vld}} & dvu_rs2) |
                 ({5{lsu_vld}} & lsu_rs2) |
                 ({5{csu_vld}} & csu_rs2) |
                 ({5{bru_vld}} & bru_rs2);                  
  wbu_rs1_data = ({32{alu_vld}} & alu_rs1_data) | 
                 ({32{mpu_vld}} & mpu_rs1_data) |
                 ({32{dvu_vld}} & dvu_rs1_data) |
                 ({32{lsu_vld}} & lsu_rs1_data) |
                 ({32{csu_vld}} & csu_rs1_data) |
                 ({32{bru_vld}} & bru_rs1_data);                  
  wbu_rs2_data = ({32{alu_vld}} & alu_rs2_data) | 
                 ({32{mpu_vld}} & mpu_rs2_data) |
                 ({32{dvu_vld}} & dvu_rs2_data) |
                 ({32{lsu_vld}} & lsu_rs2_data) |
                 ({32{csu_vld}} & csu_rs2_data) |
                 ({32{bru_vld}} & bru_rs2_data);                  
  wbu_rd_wr    = ({32{alu_vld}} & alu_rd_wr) | 
                 ({32{mpu_vld}} & mpu_rd_wr) |
                 ({32{dvu_vld}} & dvu_rd_wr) |
                 ({32{lsu_vld}} & lsu_rd_wr) |
                 ({32{csu_vld}} & csu_rd_wr) |
                 ({32{bru_vld}} & bru_rd_wr);                  
  wbu_rd       = ({5{alu_vld}} & alu_rd) | 
                 ({5{mpu_vld}} & mpu_rd) |
                 ({5{dvu_vld}} & dvu_rd) |
                 ({5{lsu_vld}} & lsu_rd) |
                 ({5{csu_vld}} & csu_rd) |
                 ({5{bru_vld}} & bru_rd);                  
  wbu_rd_data  = ({32{alu_vld}} & alu_rd_data) | 
                 ({32{mpu_vld}} & mpu_rd_data) |
                 ({32{dvu_vld}} & dvu_rd_data) |
                 ({32{lsu_vld}} & lsu_rd_data) |
                 ({32{csu_vld}} & csu_rd_data) |
                 ({32{bru_vld}} & bru_rd_data);                  
  wbu_mem_rdata= ({32{lsu_vld}} & lsu_mem_rdata); 
  x_wr = '0;
  x_wr[wbu_rd] = wbu_rd_wr;
  x00_in = wbu_rd_data;
  x01_in = wbu_rd_data;
  x02_in = wbu_rd_data;
  x03_in = wbu_rd_data;
  x04_in = wbu_rd_data;
  x05_in = wbu_rd_data;
  x06_in = wbu_rd_data;
  x07_in = wbu_rd_data;
  x08_in = wbu_rd_data;
  x09_in = wbu_rd_data;
  x10_in = wbu_rd_data;
  x11_in = wbu_rd_data;
  x12_in = wbu_rd_data;
  x13_in = wbu_rd_data;
  x14_in = wbu_rd_data;
  x15_in = wbu_rd_data;
  x16_in = wbu_rd_data;
  x17_in = wbu_rd_data;
  x18_in = wbu_rd_data;
  x19_in = wbu_rd_data;
  x20_in = wbu_rd_data;
  x21_in = wbu_rd_data;
  x22_in = wbu_rd_data;
  x23_in = wbu_rd_data;
  x24_in = wbu_rd_data;
  x25_in = wbu_rd_data;
  x26_in = wbu_rd_data;
  x27_in = wbu_rd_data;
  x28_in = wbu_rd_data;
  x29_in = wbu_rd_data;
  x30_in = wbu_rd_data;
  x31_in = wbu_rd_data;
  end
endmodule
