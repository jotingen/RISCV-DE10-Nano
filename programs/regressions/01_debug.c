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
  DEBUG_set16(1, test_16);
  DEBUG_set32(2, test_32);
  DEBUG_set64(3, test_64);

  //Read back from debug array
  //if it does not match, set LED to 1
  if(DEBUG_get8(0) != test_8) {
   LED_set(0x01);
  }
  if(DEBUG_get16(1) != test_16) {
    LED_set(0x02);
  }
  if(DEBUG_get32(2) != test_32) {
    LED_set(0x04);
  }
  if(DEBUG_get64(3) != test_64) {
    LED_set(0x08);
  }

  while(1) {}

}
