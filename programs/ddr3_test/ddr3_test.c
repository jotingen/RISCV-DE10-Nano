#include <stdint.h>
#include <stdio.h>

#include "../lib/csr.h"
#include "../lib/display.h"
#include "../lib/rand.h"
#include "../lib/sdcard.h"

#define LED             (*((volatile unsigned int *) (0xC0000000)))

#define DDR3_0        (*((volatile unsigned int *) (0x10000010)))
#define DDR3_1        (*((volatile unsigned int *) (0x10000014)))
#define DDR3_2        (*((volatile unsigned int *) (0x10000018)))
#define DDR3_3        (*((volatile unsigned int *) (0x1000001C)))
#define DDR3_4        (*((volatile unsigned int *) (0x10000080)))
#define DDR3_5        (*((volatile unsigned int *) (0x10000084)))
#define DDR3_6        (*((volatile unsigned int *) (0x10000088)))
#define DDR3_7        (*((volatile unsigned int *) (0x1000008C)))


#define BUTTON_0        (*((volatile unsigned int *) (0xC1000000)))
#define BUTTON_1        (*((volatile unsigned int *) (0xC1000004)))

#define JOYSTICK_UP     (*((volatile unsigned int *) (0xC1000100)))
#define JOYSTICK_RIGHT  (*((volatile unsigned int *) (0xC1000104)))
#define JOYSTICK_SELECT (*((volatile unsigned int *) (0xC1000108)))
#define JOYSTICK_DOWN   (*((volatile unsigned int *) (0xC100010C)))
#define JOYSTICK_LEFT   (*((volatile unsigned int *) (0xC1000110)))


void main(void) {
  
  DDR3_0 = 0x55555555;
  DDR3_1 = 0xAAAAAAAA;
  DDR3_2 = 0x55555555;
  DDR3_3 = 0xAAAAAAAA;
  DDR3_4 = 0xFFFFFFFF;
  DDR3_5 = 0xEEEEEEEE;
  DDR3_6 = 0xDDDDDDDD;
  DDR3_7 = 0xCCCCCCCC;

  LED = DDR3_0;
  LED = DDR3_4;
  LED = DDR3_1;
  LED = DDR3_5;
  LED = DDR3_2;
  LED = DDR3_6;
  LED = DDR3_3;
  LED = DDR3_7;

  while(1);
}

