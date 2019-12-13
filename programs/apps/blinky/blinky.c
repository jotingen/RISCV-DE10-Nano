#include <stdint.h>
#include <stdio.h>

#define LED             (*((volatile unsigned int *) (0xC0000000)))

void main(void) {
  LED = 0x00;

  while(1) {
    LED++;
  }

  while(1);
}
