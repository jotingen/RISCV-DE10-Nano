#include <stdint.h>
#include <stdio.h>

#include "../lib/csr.h"
#include "../lib/display.h"
#include "../lib/font8x8_basic.h"

#define LED             (*((volatile unsigned int *) (0xC0000000)))

#define BUTTON_0        (*((volatile unsigned int *) (0xC1000000)))
#define BUTTON_1        (*((volatile unsigned int *) (0xC1000004)))

#define JOYSTICK_UP     (*((volatile unsigned int *) (0xC1000100)))
#define JOYSTICK_RIGHT  (*((volatile unsigned int *) (0xC1000104)))
#define JOYSTICK_SELECT (*((volatile unsigned int *) (0xC1000108)))
#define JOYSTICK_DOWN   (*((volatile unsigned int *) (0xC100010C)))
#define JOYSTICK_LEFT   (*((volatile unsigned int *) (0xC1000110)))


void display_framebuffer(){//int rows, int cols, uint8_t life[rows][cols]) {
  display_write_start();
  display_pixel_t pixel;
  for(int row = display_rows()-1; row >= 0; row--) {
    for(int col = display_cols()-1; col >= 0; col--) {
      dispbuff_read_pixel(row,col,&pixel);
      display_write_pixel(&pixel);
    }
  }
}

void main(void) {

  uint8_t rows = display_rows();
  uint8_t cols = display_cols();

  LED=0;
  display_on();
  LED=1;

  display_pixel_t pixel;

	//display_write_buffer_pixel(row,col,&pixel);
  while(1) {
     LED=2;
		 for(uint8_t y = 0; y < cols; y++) {
        LED=3;
        pixel.R = 0x00;
        pixel.G = 0x00;
        pixel.B = 0xFF;
				dispbuff_write_pixel(80,y,&pixel);
        LED=4;
     }
        LED=5;
     display_framebuffer();
        LED=6;
	}
}                               
