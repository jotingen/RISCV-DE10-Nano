#include <stdint.h>
#include <stdio.h>

#include "../lib/led.h"
#include "../lib/debug.h"
#include "../lib/sdcard.h"

void main(void) {

  uint32_t * ddr3_mem = (uint32_t*)&DDR3;

  LED_set(0);

  for(uint32_t i = 0; i < 128; i++) {
  ddr3_mem[i] = (i<<16)|i;
  }
  for(uint32_t i = DDR3_ENTRIES_32B-128; i < DDR3_ENTRIES_32B; i++) {
  ddr3_mem[i] = (i<<16)|i;
  }

  LED_set(0x0A);
  LED_set(0);

  for(uint32_t i = 0; i < 128; i++) {
    if(ddr3_mem[i] != ((i<<16)|i)) {
      LED_set(0x01);
    }
  }
  for(uint32_t i = DDR3_ENTRIES_32B-128; i < DDR3_ENTRIES_32B; i++) {
    if(ddr3_mem[i] != ((i<<16)|i)) {
      LED_set(0x01);
    }
  }

  while(1) {}
}
