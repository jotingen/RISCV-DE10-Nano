package riscv_pkg;

typedef struct packed {
  logic          Vld;
  logic [31:0]   Inst;
  logic [31:0]   PC;
} ifu_s;

endpackage
