#include <stdint.h>
#include <stdio.h>

#include "../../lib/utils.h"
#include "../../lib/led.h"
#include "../../lib/uart.h"
#include "../../lib/csr.h"

void interrupt_handler(void) __attribute__ ((interrupt));
void uart_rx_to_tx(void);


void interrupt_handler(void) {
  uart_rx_to_tx();
}

void uart_rx_to_tx(void) {
  _putchar(uart_getchar());
}

void main(void) {

  int count = 0;

  //Set MTVec
  uint32_t mtvec = 0;
  mtvec |= ((uint32_t)interrupt_handler & CSR_MTVEC_Base);
  mtvec |= (0x00 & CSR_MTVEC_Mode) ;
  set_mtvec(mtvec);

  //Set MIE
  uint32_t mstatus_en = 0;
  mstatus_en |= CSR_MSTATUS_MIE;
  set_mstatus(mstatus_en);

  //Set MEIE
  uint32_t mie_en = 0;
  mie_en |= CSR_MIE_MEIE;
  set_mie(mie_en);

  LED_set(0);

  while(1) {
    LED_set(LED_get() + 1);
  }
}

