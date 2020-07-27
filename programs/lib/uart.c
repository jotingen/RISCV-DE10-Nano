#include <stdio.h> 

#include "uart.h"

#define UART            (*((volatile uint32_t *) (0xC3040000)))  
#define UART_BAUD       (*((volatile uint32_t *) (0xC3040004)))  

void uart_set_baud(uint32_t baud)
{
  UART_BAUD = 50000000/baud;
}
  
void uart_write(uint8_t c)
{
  UART = c;
}
  
