#include <stdio.h>

#include "csr.h"

#define read_csr(reg) ({ unsigned int __tmp;asm volatile ("csrr %0, " #reg : "=r"(__tmp));__tmp; })

#define CSR_CYCLE     0xC00
#define CSR_CYCLE_H   0xC80

#define CSR_TIME      0xC01
#define CSR_TIME_H    0xC81

#define CSR_INSTRET   0xC02
#define CSR_INSTRET_H 0xC82

//Machine Information Registers

#define CSR_MVENDORID 0xF11
#define CSR_MARCHID   0xF12
#define CSR_MIMPID    0xF13
#define CSR_MHARTID   0xF14

//Machine Trap Setup

#define CSR_MSTATUS    0x300
#define CSR_MISA       0x301
#define CSR_MEDELEG    0x302
#define CSR_MIDELEG    0x303
#define CSR_MIE        0x304
#define CSR_MTVEC      0x305
#define CSR_MCOUNTEREN 0x306

//Machine Trap Handling

#define CSR_MSCRATCH 0x340 
#define CSR_MEPC     0x341 
#define CSR_MCAUSE   0x342 
#define CSR_MTVAL    0x343 
#define CSR_MIP      0x344 

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

uint32_t get_csr_mstatus() {
  uint32_t csr;
  __asm__(
    "csrrs %[result], mstatus, x0" : [result] "=r" (csr)
  );
  return csr;
}

extern uint32_t get_mstatus() {
  uint32_t mstatus;
  mstatus = get_csr_mstatus();
  return mstatus;
}

       uint32_t clr_csr_mstatus(uint32_t mask) {
  __asm__(
    "csrc mstatus, %[mask]" : [mask] "=r" (mask)
  );
}

extern uint32_t clr_mstatus(uint32_t mask) {
	clr_csr_mstatus(mask);
}

       uint32_t set_csr_mstatus(uint32_t mask) {
  __asm__(
    "csrs mstatus, %[mask]" : [mask] "=r" (mask)
  );
}

extern uint32_t set_mstatus(uint32_t mask) {
	set_csr_mstatus(mask);
}

uint32_t get_csr_mie() {
  uint32_t csr;
  __asm__(
    "csrrs %[result], mie, x0" : [result] "=r" (csr)
  );
  return csr;
}

extern uint32_t get_mie() {
  uint32_t mie;
  mie = get_csr_mie();
  return mie;
}

       uint32_t clr_csr_mie(uint32_t mask) {
  __asm__(
    "csrc mie, %[mask]" : [mask] "=r" (mask)
  );
}

extern uint32_t clr_mie(uint32_t mask) {
	clr_csr_mie(mask);
}

       uint32_t set_csr_mie(uint32_t mask) {
  __asm__(
    "csrs mie, %[mask]" : [mask] "=r" (mask)
  );
}

extern uint32_t set_mie(uint32_t mask) {
	set_csr_mie(mask);
}


uint32_t get_csr_mtvec() {
  uint32_t csr;
  __asm__(
    "csrrs %[result], mtvec, x0" : [result] "=r" (csr)
  );
  return csr;
}

extern uint32_t get_mtvec() {
  uint32_t mtvec;
  mtvec = get_csr_mtvec();
  return mtvec;
}

       uint32_t clr_csr_mtvec(uint32_t mask) {
  __asm__(
    "csrc mtvec, %[mask]" : [mask] "=r" (mask)
  );
}

extern uint32_t clr_mtvec(uint32_t mask) {
	clr_csr_mtvec(mask);
}

       uint32_t set_csr_mtvec(uint32_t mask) {
  __asm__(
    "csrs mtvec, %[mask]" : [mask] "=r" (mask)
  );
}

extern uint32_t set_mtvec(uint32_t mask) {
	set_csr_mtvec(mask);
}


uint32_t get_csr_mip() {
  uint32_t csr;
  __asm__(
    "csrrs %[result], mip, x0" : [result] "=r" (csr)
  );
  return csr;
}

extern uint32_t get_mip() {
  uint32_t mip;
  mip = get_csr_mip();
  return mip;
}

       uint32_t clr_csr_mip(uint32_t mask) {
  __asm__(
    "csrc mip, %[mask]" : [mask] "=r" (mask)
  );
}

extern uint32_t clr_mip(uint32_t mask) {
	clr_csr_mip(mask);
}

       uint32_t set_csr_mip(uint32_t mask) {
  __asm__(
    "csrs mip, %[mask]" : [mask] "=r" (mask)
  );
}

extern uint32_t set_mip(uint32_t mask) {
	set_csr_mip(mask);
}
