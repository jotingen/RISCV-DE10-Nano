#include <stdint.h>
#include <stdio.h>

#include "../lib/led.h"
#include "../lib/debug.h"
#include "../lib/sdcard.h"

void main(void) {

  sdcard_crc_check_off();
  sdcard_on();
  sdcard_read2(512*0);
  for(uint16_t i = 0; i < 512/4; i++) {
    DEBUG_set32(i,SDCARD_DATA[i]);
  }

  while(1) {}
}
