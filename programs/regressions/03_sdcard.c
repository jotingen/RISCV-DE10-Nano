#include <stdint.h>
#include <stdio.h>

#include "../lib/led.h"
#include "../lib/debug.h"
#include "../lib/sdcard.h"

void main(void) {

  static uint8_t sdcard_data[514];

  sdcard_on();
  sdcard_read(sdcard_data,512*0);
  for(uint16_t i = 0; i < 512; i = i+4) {
    uint32_t data;
    data = sdcard_data[i+0] |
           (sdcard_data[i+1] << 8) |
           (sdcard_data[i+2] << 16) |
           (sdcard_data[i+3] << 24);
    DEBUG_set32(i/4,data);
  }

  while(1) {}
}
