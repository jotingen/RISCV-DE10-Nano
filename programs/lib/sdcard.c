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

  // uint64_t cmd_reversed = 0;
  // for(uint8_t i=0;i<48;i++) {
  //    cmd_reversed |= ((cmd>>i) & 1)<<(47-i);
  // }
  // //cmd_reversed = cmd_reversed >> 16;

  // for(uint8_t i = 0; i < 6; i++) {
  //   SDCARD_CMD = (cmd_reversed >> (i*8)) & 0xFF;
  // }

  for(int i = 5; i >= 0; i--) {
    SDCARD_CMD = (cmd >> (i*8)) & 0xFF;
  }
  SDCARD_CMD = 0;
  SDCARD_CMD = 0;
  return;
}
