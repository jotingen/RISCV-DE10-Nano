#include <stdio.h>

#include "counters.h"

#define read_csr(reg) ({ unsigned int __tmp;asm volatile ("csrr %0, " #reg : "=r"(__tmp));__tmp; })

#define CSR_CYCLE     0xC00
#define CSR_CYCLE_H   0xC80

#define CSR_TIME      0xC01
#define CSR_TIME_H    0xC81

#define CSR_INSTRET   0xC02
#define CSR_INSTRET_H 0xC82

uint32_t get_csr_cycle() {
  __asm__(
    "csrrs a0, cycle, x0 \n"
    "lw s0, 12(sp)\n"
    "add sp, sp, 16\n"
    "jr ra\n"
  );
  return 1;
}

uint32_t get_csr_cycleh() {
  __asm__(
    "csrrs a0, cycleh, x0 \n"
    "lw s0, 12(sp)\n"
    "add sp, sp, 16\n"
    "jr ra\n"
  );
  return 1;
}

extern uint64_t get_time() {
  uint64_t time;
  time = 0;
  time = time | get_csr_cycleh();
  time = time << 32;
  time = time | get_csr_cycle();
  return time;
}

extern void clear_time() {
  __asm__(
    "add t1, zero, zero \n"
    "not t1, t1 \n"
    "csrrc x0, cycleh, t1 \n"
    "csrrc x0, cycle, t1 \n"
  );
}

