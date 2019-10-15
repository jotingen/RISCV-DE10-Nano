#include <stdio.h>

#include "rand.h"
#include "csr.h"

uint32_t lfsr;

void xorshift(uint32_t * lfsr) {
  uint32_t bit = ((*lfsr >> 5) ^ (*lfsr >> 13) ^ (*lfsr >> 17));
  *lfsr =  (*lfsr >> 1) | (bit << 31);
  return;
}

extern void     rand_init(void) {
  lfsr = get_cycle();
  return;
}
extern uint32_t rand(void) {
  xorshift(&lfsr);
  return get_cycle() ^ lfsr;
}
  
