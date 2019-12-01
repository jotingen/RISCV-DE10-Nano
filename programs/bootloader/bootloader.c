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
  static uint8_t sdcard_data[514];

  static volatile uint32_t * const console_buffer = (volatile uint32_t *) 0xC3014000;

  uint32_t key_pressed;

  //uint64_t timestamp;
  //uint64_t keystamp;
  //uint64_t displaystamp;

  uint32_t led;

  display_pixel_t pixel;

  char buff[21];

  LED = 0;
  console_clear();
  LED = 1;
  LED = console_curser().X;
  console_putc('T');
  LED = console_curser().X;
  console_putc('E');
  LED = console_curser().X;
  console_putc('S');
  LED = console_curser().X;
  console_putc('T');
  LED = console_curser().X;
  console_putc('\n');
  LED = 2;
  LED = console_buffer[0];
  LED = console_buffer[1];
  LED = console_buffer[2];
  LED = console_buffer[3];
  LED = 3;
  while(get_time() < 1) {} //Wait for SDCARD to warm up

  LED = 4;
  rand_init();

  LED = 5;
  display_on();
  LED = 6;

  display_write();
  LED = 7;

  sdcard_on();
  LED = 8;

  //display_write();
  LED = 9;

  console_puts("Data Read Test\n");
  //display_write();
  LED = 10;
  sdcard_read(sdcard_data,512*0);
  sdcard_read(sdcard_data,512*128);
  //display_write();

  while(1);
}


