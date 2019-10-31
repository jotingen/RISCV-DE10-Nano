#include <stdio.h>

#include "sdcard.h"

#define SDCARD_NOOP    (*((volatile uint32_t *) (0xC4000000)))
#define SDCARD_CMD     (*((volatile uint32_t *) (0xC4000004)))
#define SDCARD_DATA    (*((volatile uint32_t *) (0xC4000008)))

void sdcard_on(void) {

  sdcard_cmd(0x400000000095);
  sdcard_cmd(0x48000001AA87);

  return;
}

void sdcard_cmd(uint64_t cmd) {

  for(uint8_t i = 0; i < 6; i++) {
    SDCARD_CMD = (cmd >> (i*8)) & 0xFF;
  }

  return;
}
