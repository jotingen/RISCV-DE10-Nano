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

#define CONSOLE_ROWS    16
#define CONSOLE_COLS    20

#define DISPLAY_CMD_DISPON   0x29
#define DISPLAY_CMD_SLEEPOUT 0x11
#define DISPLAY_CMD_RAMWR    0x2C
#define LED             (*((volatile unsigned int *) (0xC0000000)))

static volatile uint32_t * const display_buffer = (volatile uint32_t *) 0xC3000000;
static volatile uint32_t * const console_buffer = (volatile uint32_t *) 0xC3014000;

console_index_t curser_index = { 0, 0};

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

struct console_index_t console_curser(void) {
  return curser_index;
}

void console_curser_set(struct console_index_t index) {
  if(index.X > CONSOLE_COLS) {
    index.X = CONSOLE_COLS-1;
  }
  if(index.Y > CONSOLE_ROWS) {
    index.Y = CONSOLE_ROWS-1;
  }
  curser_index = index;
  return;
}

void console_clear() {
  curser_index.X = 0;
  curser_index.Y = 0;
  for(int y = 0; y < CONSOLE_ROWS; y++) {
    for(int x = 0; x < CONSOLE_COLS; x++) {
      LED = 0xFF;
      LED = x;
      LED = y;
      console_buffer[y*CONSOLE_COLS+x] = 0;
    }
  }
  return;
}
  
void console_put_char(char c) {
  if(c == '\n') {
    //If curser is at bottom, shift everything up by one row
    if(curser_index.Y == CONSOLE_ROWS-1) {
      for(int y = 0; y < CONSOLE_ROWS-1; y++) {
        for(int x = 0; x < CONSOLE_COLS; x++) {
          console_buffer[y*CONSOLE_COLS+x] = console_buffer[(y+1)*CONSOLE_COLS+x];
        }
      }
      curser_index.Y = curser_index.Y - 1;
    }
      
      curser_index.X = 0;
      curser_index.Y = curser_index.Y + 1;
  } else {
    //If curser is at bottom right, shift everything up by one row
    if(curser_index.X == CONSOLE_COLS-1 && curser_index.Y == CONSOLE_ROWS-1) {
      for(int y = 0; y < CONSOLE_ROWS-1; y++) {
        for(int x = 0; x < CONSOLE_COLS; x++) {
          console_buffer[y*CONSOLE_COLS+x] = console_buffer[(y+1)*CONSOLE_COLS+x];
        }
      }
      curser_index.Y = curser_index.Y - 1;
    }
      
    //Put character at console
    console_buffer[curser_index.Y*CONSOLE_COLS+curser_index.X] = c;
  
    //Advance curser
    if(curser_index.X == CONSOLE_COLS-1) {
      curser_index.X = 0;
      curser_index.Y = curser_index.Y + 1;
    } else {
      curser_index.X = curser_index.X + 1;
    }
  }
    
  return;
}
  
char * uint32_to_hex(uint32_t number) {
  static char s[8];
  for(int d = 0; d < 8; d++) {
    uint8_t hex = (number >> (d*4)) & 0xF;
    if(hex < 10) {
      s[d] = hex+48;
    } else {
      s[d] = hex+55;
    }
  }
  return s;
}
  
char * uint64_to_hex(uint64_t number) {
  static char s[16];
  for(int d = 0; d < 16; d++) {
    uint8_t hex = (number >> (d*4)) & 0xF;
    if(hex < 10) {
      s[d] = hex+48;
    } else {
      s[d] = hex+55;
    }
  }
  return s;
}
