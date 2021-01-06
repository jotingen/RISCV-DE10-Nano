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
  rand_seed_init(get_cycle());
  return;
}
extern void     rand_seed_init(uint32_t seed) {
  if(seed == 0) {
    lfsr = get_cycle();
  } else {
    lfsr = seed;
  }
  return;
}
extern uint32_t rand(void) {
  xorshift(&lfsr);
  return get_cycle() ^ lfsr;
}
  
