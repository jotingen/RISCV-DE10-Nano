#include <stdio.h>

#include "led.h"

void LED_set(uint8_t val) {
  LED = val;
}

uint8_t LED_get(void) {
  return LED;
}
