#include <stdint.h>
#include <stdio.h>

#include "../lib/csr.h"
#include "../lib/display.h"
#include "../lib/rand.h"
#include "../lib/sdcard.h"

#define LED             (*((volatile unsigned int *) (0xC0000000)))

#define DDR3_0        (*((volatile unsigned int *) (0x10000000)))
#define DDR3_1        (*((volatile unsigned int *) (0x10000004)))
#define DDR3_2        (*((volatile unsigned int *) (0x10000008)))
#define DDR3_3        (*((volatile unsigned int *) (0x1000000C)))
#define DDR3_4        (*((volatile unsigned int *) (0x10000010)))
#define DDR3_5        (*((volatile unsigned int *) (0x10000014)))
#define DDR3_6        (*((volatile unsigned int *) (0x10000018)))
#define DDR3_7        (*((volatile unsigned int *) (0x1000001C)))


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

  while(1);
}

