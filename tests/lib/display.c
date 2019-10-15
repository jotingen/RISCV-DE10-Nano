#include <stdio.h>

#include "display.h"
#include "csr.h"

#define DISPLAY_NOOP    (*((volatile uint32_t *) (0xC2000000)))
#define DISPLAY_CMD     (*((volatile uint32_t *) (0xC2000004)))
#define DISPLAY_DATA    (*((volatile uint32_t *) (0xC2000008)))
#define DISPLAY_BUFF    (*((volatile uint32_t *) (0xC3000000)))  

#define DISPLAY_POWERON_DELAY 5000000

#define DISPLAY_ROWS    128
#define DISPLAY_COLS    160

#define DISPLAY_CMD_DISPON   0x29
#define DISPLAY_CMD_SLEEPOUT 0x11
#define DISPLAY_CMD_RAMWR    0x2C

static volatile uint32_t * const display_buffer = (volatile uint32_t *) 0xC3000000;

void display_on(void) {

  //while(get_time() < DISPLAY_POWERON_DELAY) {}
  //clear_time();
  DISPLAY_CMD = DISPLAY_CMD_DISPON;

  //Wait to take display out of sleep
  //while(get_time() < DISPLAY_POWERON_DELAY) {}
  //clear_time();
  DISPLAY_CMD = DISPLAY_CMD_SLEEPOUT; // SLPOUT (11h): Sleep Out

  return;
}

       uint32_t display_rows(void) {
  return DISPLAY_ROWS;
}

       uint32_t display_cols(void) {
  return DISPLAY_COLS;
}

       void     dispbuff_write_pixel(uint8_t row, uint8_t col, display_pixel_t * pixel) {
  col = DISPLAY_COLS-1-col;
  row = DISPLAY_ROWS-1-row;
  display_buffer[col*DISPLAY_ROWS+row] = 0 | (pixel->R << 16) | (pixel->G << 8) | (pixel->B << 0);
  return;
}

       void     dispbuff_read_pixel(uint8_t row, uint8_t col, display_pixel_t * pixel) {
  uint32_t buff;
  buff = display_buffer[row*DISPLAY_COLS+col];
  pixel->R = (buff >> 16) & 0x000000FF;
  pixel->G = (buff >> 8)  & 0x000000FF;
  pixel->B = (buff >> 0)  & 0x000000FF;
  return;
}


       void     display_write_start(void) {
  //Screen prints top to bottom, right to left
  DISPLAY_CMD = DISPLAY_CMD_RAMWR; //  RAMWR (2Ch): Memory Write 
  return;
}

       void     display_write_pixel(display_pixel_t * pixel) {
  DISPLAY_DATA = 0x80 | pixel->R;
  DISPLAY_DATA = 0x80 | pixel->G;
  DISPLAY_DATA = 0x80 | pixel->B;
  return;
}

       void display_write(void) {
  display_write_start();
  display_pixel_t pixel;
  for(int row = DISPLAY_ROWS-1; row >= 0; row--) {
    for(int col = DISPLAY_COLS-1; col >= 0; col--) {
      dispbuff_read_pixel(row,col,&pixel);
      display_write_pixel(&pixel);
    }
  }
  return;
}
