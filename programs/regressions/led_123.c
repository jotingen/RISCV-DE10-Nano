#include <stdint.h>
#include <stdio.h>

#define LED             (*((volatile unsigned int *) (0xC0000000)))

void main(void) {
  LED = 1;
  LED = 2;
  LED = 3;
}
