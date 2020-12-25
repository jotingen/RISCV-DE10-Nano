#include <stdint.h>
#include <stdio.h>

#include "../lib/led.h"
#include "../lib/debug.h"

void main(void) {

  uint8_t  test_8  = 0xDE;
  uint16_t test_16 = 0xDEAD;
  uint32_t test_32 = 0xDEADBEEF;
  uint64_t test_64 = 0xDEADBEEFAAAA5555;

  LED_set(0);

  //Save values to debug array
  DEBUG_set8 (0, test_8 );
  LED_set(LED_get() | 0x01);
  DEBUG_set16(1, test_16);
  LED_set(LED_get() | 0x02);
  DEBUG_set32(2, test_32);
  LED_set(LED_get() | 0x04);
  DEBUG_set64(3, test_64);
  LED_set(LED_get() | 0x08);

  //Read back from debug array
  //if it does not match, set LED to 1
  if(DEBUG_get8(0) == test_8) {
    LED_set(LED_get() & 0xFE);
  } else {
    LED_set(LED_get() | 0x10);
  }
  if(DEBUG_get16(1) == test_16) {
    LED_set(LED_get() & 0xFD);
  } else {
    LED_set(LED_get() | 0x20);
  }
  if(DEBUG_get32(2) == test_32) {
    LED_set(LED_get() & 0xFB);
  } else {
    LED_set(LED_get() | 0x40);
  }
  if(DEBUG_get64(3) == test_64) {
    LED_set(LED_get() & 0xF7);
  } else {
    LED_set(LED_get() | 0x80);
  }

  while(1) {}

}
