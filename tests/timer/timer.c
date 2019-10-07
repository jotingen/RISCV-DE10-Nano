#include <stdint.h>

#include "../lib/counters.h"

#define FINAL_ANSWER (*((volatile unsigned int *) (0x00010000)))
#define LED (*((volatile unsigned int *) (0xC0000000)))


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

