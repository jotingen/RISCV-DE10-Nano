#include <stdint.h>
#include <stdio.h>

#include "../lib/csr.h"
#include "../lib/rand.h"
#include "../lib/sdcard.h"

#define LED             (*((volatile unsigned int *) (0xC0000000)))

void main(void) {

  //Straight to app, preload in ddr first
  ((void (*)(void))0x10000000)();

}
