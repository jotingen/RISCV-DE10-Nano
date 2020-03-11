#include <stdint.h>
#include <stdio.h>

#include "../lib/csr.h"
#include "../lib/rand.h"
#include "../lib/sdcard.h"

#include "../lib/display.h"

#define LED             (*((volatile unsigned int *) (0xC0000000)))

void main(void) {

  //Set UART crazy fast for sims
  //set_uart_baud(921600);
  set_uart_baud(9216000);

  //Straight to app, preload in ddr first
  ((void (*)(void))0x10000000)();

}
