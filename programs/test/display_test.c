#include <stdint.h>
#include <stdio.h>

#include "../lib/csr.h"
#include "../lib/display.h"


static volatile uint32_t * const console_buffer = (volatile uint32_t *) 0xC3020000;
static volatile uint16_t * const ddr3 = (volatile uint16_t *) 0x10000000;

void main(void) {
  display_on();

  display_pixel_t pixel;

  display_write_start();

  //Checking how DDR3 behaves, treating like second framebuffer
  for(int y = 0; y < display_height(); y++) {
    for(int x = 0; x < display_width(); x++) {
      pixel.R = x+y;
      pixel.G = x+y;
      pixel.B = x+y;
      ddr3[display_width()*y+x] = *(uint16_t*)&pixel;
    }
  }
  for(int y = 0; y < display_height(); y++) {
    for(int x = 0; x < display_width(); x++) {
      uint16_t pixel_16b;
      pixel_16b = ddr3[display_width()*y+x];
      pixel = *(display_pixel_t*)&pixel_16b;
      display_write_pixel(pixel);
    }
  }

  while(1);
}
