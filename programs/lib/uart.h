#ifndef	_UART_H_
#define _UART_H_

void uart_set_baud(uint32_t baud);
void uart_write(uint8_t c);
int uart_rxcount(void);
uint8_t uart_getchar(void);

#endif
