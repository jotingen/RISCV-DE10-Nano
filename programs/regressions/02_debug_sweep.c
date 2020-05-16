#include <stdint.h>
#include <stdio.h>

#include "../lib/led.h"
#include "../lib/debug.h"

void main(void) {

  LED_set(0);

  for(uint16_t i = 0; i < 128; i++) {
    DEBUG_set32(i, (i<<16)|i);
  }
  for(uint16_t i = DEBUG_ENTRIES_32B-128; i < DEBUG_ENTRIES_32B; i++) {
    DEBUG_set32(i, (i<<16)|i);
  }

  LED_set(0x0A);
  LED_set(0);

  for(uint16_t i = 0; i < 128; i++) {
    if(DEBUG_get32(i) != ((i<<16)|i)) {
      LED_set(0x01);
    }
  }
  for(uint16_t i = DEBUG_ENTRIES_32B-128; i < DEBUG_ENTRIES_32B; i++) {
    if(DEBUG_get32(i) != ((i<<16)|i)) {
      LED_set(0x01);
    }
  }

  while(1) {}
}

