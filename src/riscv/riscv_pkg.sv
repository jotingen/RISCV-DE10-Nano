package riscv_pkg;

//Max number of packages retired per cycle, for formal test
localparam NRET = 1;

typedef struct packed {
  logic          Vld;
  logic [31:0]   Inst;
  logic [31:0]   PC;
} ifu_s;

endpackage
