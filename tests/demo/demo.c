#include <stdint.h>

#define FINAL_ANSWER (*((volatile unsigned int *) (0x00010000)))
#define LED          (*((volatile unsigned int *) (0xC0000000)))
#define BUTTON_0     (*((volatile unsigned int *) (0xC1000000)))
#define BUTTON_1     (*((volatile unsigned int *) (0xC1000004)))

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

void button_0() {
  LED = 0x0F;
}

void button_1() {
  LED = 0xF0;
}

void fibbonacci(uint32_t* a, uint32_t* b) {
  uint32_t c;
  c = *b;
  *b = *a;
  *a = *b + c;
  LED = *a;
}

void main(void) {
  uint32_t a,b,c;
  a = 1;
  b = 1;
  while(1) {
    if(BUTTON_0) {
      button_0();
    } else if(BUTTON_1) {
      button_1();
    } else {
      fibbonacci(&a, &b);
    }

    while(get_time()<50000000) {}

    clear_time();
  }
}

