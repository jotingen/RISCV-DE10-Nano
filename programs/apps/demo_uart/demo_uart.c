#include <stdint.h>
//#include <stdio.h>

#include "../../lib/utils.h"
#include "../../lib/uart.h"
#include "../../lib/printf.h"


void main(void) {

  uart_set_baud(9216000);

  uart_write('A');
  uart_write('B');
  uart_write('C');
  uart_write('\n');

  printf("test\n");

  uart_write('D');
  uart_write('E');
  uart_write('F');
  uart_write('\n');

  while(1);
}
