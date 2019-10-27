#include <stdint.h>
#include <stdio.h>

#include "../lib/csr.h"
#include "../lib/display.h"
#include "../lib/rand.h"
#include "../lib/sdcard.h"

#define LED             (*((volatile unsigned int *) (0xC0000000)))

#define BUTTON_0        (*((volatile unsigned int *) (0xC1000000)))
#define BUTTON_1        (*((volatile unsigned int *) (0xC1000004)))

#define JOYSTICK_UP     (*((volatile unsigned int *) (0xC1000100)))
#define JOYSTICK_RIGHT  (*((volatile unsigned int *) (0xC1000104)))
#define JOYSTICK_SELECT (*((volatile unsigned int *) (0xC1000108)))
#define JOYSTICK_DOWN   (*((volatile unsigned int *) (0xC100010C)))
#define JOYSTICK_LEFT   (*((volatile unsigned int *) (0xC1000110)))

//200Hz
#define KEY_TIME        25
//60Hz
//#define DISPLAY_TIME    833333
//30Hz
#define DISPLAY_TIME   166


void paint_pixel(int row, int col, uint8_t * cell) {
  display_pixel_t pixel;
      if(*cell == 0) {
          pixel.R = 0xFC;
          pixel.G = 0xFC;
          pixel.B = 0xFC;
      } else {
        pixel.R = 0x00;
        pixel.G = 0x00;
        pixel.B = 0x00;
      }
      dispbuff_write_pixel(row,col,&pixel);
}

void main(void) {
  uint32_t but0, but1;
  uint32_t joy_sel, joy_up, joy_down, joy_left, joy_right;

  uint32_t key_pressed;

  //uint64_t timestamp;
  //uint64_t keystamp;
  //uint64_t displaystamp;

  uint32_t counter;
  uint32_t led;

  uint8_t life[display_rows()][display_cols()];
  uint8_t life_next[display_rows()][display_cols()];

  display_pixel_t pixel;

  char buff[21];

  counter = 0;
  rand_init();
  display_on();

  sdcard_on();

  while(1);
}

