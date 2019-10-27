#include <stdio.h>

#include "sdcard.h"

#define SDCARD_NOOP    (*((volatile uint32_t *) (0xC4000000)))

void sdcard_on(void) {

  SDCARD_NOOP = 1;

  return;
}

