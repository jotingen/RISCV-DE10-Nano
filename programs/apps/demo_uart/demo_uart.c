#include <stdint.h>
//#include <stdio.h>

#include "../../lib/led.h"
#include "../../lib/utils.h"
#include "../../lib/uart.h"
#include "../../lib/printf.h"


void main(void) {

  uart_set_baud(9216000);

  uart_write('A');
  LED_set('A');
  uart_write('B');
  LED_set('B');
  uart_write('C');
  LED_set('C');
  uart_write('\n');

  printf("test\n");

  uart_write('D');
  LED_set('D');
  uart_write('E');
  LED_set('E');
  uart_write('F');
  LED_set('F');
  uart_write('\n');

  while(1);
}
