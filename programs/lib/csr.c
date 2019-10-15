#include <stdio.h>

#include "csr.h"

#define read_csr(reg) ({ unsigned int __tmp;asm volatile ("csrr %0, " #reg : "=r"(__tmp));__tmp; })

#define CSR_CYCLE     0xC00
#define CSR_CYCLE_H   0xC80

#define CSR_TIME      0xC01
#define CSR_TIME_H    0xC81

#define CSR_INSTRET   0xC02
#define CSR_INSTRET_H 0xC82

uint32_t get_csr_cycle() {
  uint32_t csr;
  __asm__(
    "csrrs %[result], cycle, x0" : [result] "=r" (csr)
  );
  return csr;
}

uint32_t get_csr_cycleh() {
  uint32_t csr;
  __asm__(
    "csrrs %[result], cycleh, x0" : [result] "=r" (csr)
  );
  return csr;
}

extern uint64_t get_cycle() {
  uint64_t cycle;
  cycle = 0;
  cycle = cycle | get_csr_cycleh();
  cycle = cycle << 32;
  cycle = cycle | get_csr_cycle();
  return cycle;
}

extern void reset_cycle() {
  __asm__(
    "csrrc x0, cycleh, x0 \n"
    "csrrc x0, cycle, x0 \n"
  );
}

uint32_t get_csr_time() {
  uint32_t csr;
  __asm__(
    "csrrs %[result], time, x0" : [result] "=r" (csr)
  );
  return csr;
}

uint32_t get_csr_timeh() {
  uint32_t csr;
  __asm__(
    "csrrs %[result], timeh, x0" : [result] "=r" (csr)
  );
  return csr;
}

extern uint64_t get_time() {
  uint64_t time;
  time = 0;
  time = time | get_csr_timeh();
  time = time << 32;
  time = time | get_csr_time();
  return time;
}

extern void reset_time() {
  __asm__(
    "csrrc x0, timeh, x0 \n"
    "csrrc x0, time, x0 \n"
  );
}

uint32_t get_csr_instret() {
  uint32_t csr;
  __asm__(
    "csrrs %[result], instret, x0" : [result] "=r" (csr)
  );
  return csr;
}

uint32_t get_csr_instreth() {
  uint32_t csr;
  __asm__(
    "csrrs %[result], instreth, x0" : [result] "=r" (csr)
  );
  return csr;
}

extern uint64_t get_instret() {
  uint64_t instret;
  instret = 0;
  instret = instret | get_csr_instreth();
  instret = instret << 32;
  instret = instret | get_csr_instret();
  return instret;
}

extern void reset_instret() {
  __asm__(
    "csrrc x0, instreth, x0 \n"
    "csrrc x0, instret, x0 \n"
  );
}

