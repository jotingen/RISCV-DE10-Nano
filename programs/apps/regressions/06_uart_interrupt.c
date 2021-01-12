#include <stdint.h>
#include <stdio.h>

#include "../../lib/utils.h"
#include "../../lib/led.h"
#include "../../lib/uart.h"

void main(void) {

  int count = 0;

  while(count < 3) {
    if(uart_rxcount() > 0) {
      _putchar(uart_getchar());
      count++;
    }
  }
  _putchar('\n');

  while(1) {}
}
