#define FINAL_ANSWER (*((volatile unsigned int *) (0x00010100)))
#define LED (*((volatile unsigned int *) (0xC0000000)))

int get_time() {
  __asm__(
    "csrrs a0, cycle, x0 \n"
    "lw s0, 12(sp)\n"
    "add sp, sp, 16\n"
    "jr ra\n"
  );
  return 1;
}

int main(void) {
  int a,b,c;
  a = 1;
  b = 1;
  while(get_time()<1000) {
    c = b;
    b = a;
    a = b + c;
  }
  FINAL_ANSWER = a;
  LED = a;
  while(1);
}

