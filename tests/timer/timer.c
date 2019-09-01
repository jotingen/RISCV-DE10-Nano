#include <stdint.h>

#define FINAL_ANSWER (*((volatile unsigned int *) (0x00010000)))
#define LED (*((volatile unsigned int *) (0xC0000000)))

unsigned int get_csr_cycle() {
  __asm__(
    "csrrs a0, cycle, x0 \n"
    "lw s0, 12(sp)\n"
    "add sp, sp, 16\n"
    "jr ra\n"
  );
  return 1;
}
unsigned int get_csr_cycleh() {
  __asm__(
    "csrrs a0, cycleh, x0 \n"
    "lw s0, 12(sp)\n"
    "add sp, sp, 16\n"
    "jr ra\n"
  );
  return 1;
}
uint64_t get_time() {
  uint64_t time;
  time = 0;
  time = time | get_csr_cycleh();
  time = time << 32;
  time = time | get_csr_cycle();
  return time;
}

void clear_time() {
  __asm__(
    "add t1, zero, zero \n"
    "not t1, t1 \n"
    "csrrc x0, cycleh, t1 \n"
    "csrrc x0, cycle, t1 \n"
  );
}

int main(void) {
  unsigned int a,b,c;
  a = 1;
  b = 1;
  while(1) {
    LED = a;
    c = b;
    b = a;
    a = b + c;
    while(get_time()<50000000) {}
    clear_time();
  }
  FINAL_ANSWER = a;
  LED = a;
  while(1);
}

