#include <stdio.h>

#include "csr.h"
#include "display.h"

#include "font8x8_basic.h"

#define DISPLAY_NOOP    (*((volatile uint32_t *) (0xC2000000)))
#define DISPLAY_CMD     (*((volatile uint32_t *) (0xC2000004)))
#define DISPLAY_DATA    (*((volatile uint32_t *) (0xC2000008)))
#define DISPLAY_BUFF    (*((volatile uint32_t *) (0xC3000000)))  

#define DISPLAY_POWERON_DELAY 120

#define DISPLAY_HEIGHT    128
#define DISPLAY_WIDTH    160

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


  //timestamp = get_time();
  while(get_time() < 1) {}

  DISPLAY_CMD = DISPLAY_CMD_DISPON;
  DISPLAY_CMD = DISPLAY_CMD_SLEEPOUT; // SLPOUT (11h): Sleep Out

  return;
}

       uint32_t display_height(void) {
  return DISPLAY_HEIGHT;
}

       uint32_t display_width(void) {
  return DISPLAY_WIDTH;
}

       void     dispbuff_write_pixel(uint8_t y, uint8_t x, display_pixel_t * pixel) {
  x = DISPLAY_WIDTH-1-x;
  y = DISPLAY_HEIGHT-1-y;
  display_buffer[x*DISPLAY_HEIGHT+y] = 0 | (pixel->R << 16) | (pixel->G << 8) | (pixel->B << 0);
  return;
}

       void     dispbuff_read_pixel(uint8_t y, uint8_t x, display_pixel_t * pixel) {
  uint32_t buff;
  buff = display_buffer[y*DISPLAY_WIDTH+x];
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
  for(int x = DISPLAY_WIDTH-1; x >= 0; x--) {
    for(int y = DISPLAY_HEIGHT-1; y >= 0; y--) {
      int consoleX = x/8;
      int consoleY = y/8;
      int charX = x%8;
      int charY = y%8;
      uint8_t char_set = font8x8_basic[console_buffer[consoleY*CONSOLE_COLS+(DISPLAY_WIDTH/8-1-consoleX)]][charY] & (1 << (7-charX));
      if(char_set) {
        pixel.R = 0x3F;
        pixel.G = 0x3F;
        pixel.B = 0x3F;
      } else {
        dispbuff_read_pixel(y,x,&pixel);
      }
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
      //Clear last line
      for(int x = 0; x < CONSOLE_COLS; x++) {
        console_buffer[(CONSOLE_ROWS-1)*CONSOLE_COLS+x] = ' ';
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
      //Clear last line
      for(int x = 0; x < CONSOLE_COLS; x++) {
        console_buffer[(CONSOLE_ROWS-1)*CONSOLE_COLS+x] = ' ';
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

void console_putc(char c) {
  console_put_char(c);
  return;
}

void console_puts(char *s) {
  while (*s > 0) console_putc(*s++);
  return;
}

void console_puthex8(uint8_t val)
{
	// extract upper and lower nibbles from input value
	uint8_t upperNibble = (val & 0xF0) >> 4;
	uint8_t lowerNibble = val & 0x0F;

	// convert nibble to its ASCII hex equivalent
	upperNibble += upperNibble > 9 ? 'A' - 10 : '0';
	lowerNibble += lowerNibble > 9 ? 'A' - 10 : '0';

	// print the characters
	console_putc(upperNibble);
	console_putc(lowerNibble);
}
  
char * uint8_to_hex(uint8_t number) {
  static char s[3];
  for(int d = 0; d < 2; d++) {
    uint8_t hex = (number >> ((2-1-d)*4)) & 0xF;
    if(hex < 10) {
      s[d] = hex+48;
    } else {
      s[d] = hex+55;
    }
  }
  s[3] = '\0';
  return s;
}
  
char * uint32_to_hex(uint32_t number) {
  static char s[9];
  for(int d = 0; d < 8; d++) {
    uint8_t hex = (number >> ((8-1-d)*4)) & 0xF;
    if(hex < 10) {
      s[d] = hex+48;
    } else {
      s[d] = hex+55;
    }
  }
  s[8] = '\0';
  return s;
}
  
char * uint64_to_hex(uint64_t number) {
  static char s[17];
  for(int d = 0; d < 16; d++) {
    uint8_t hex = (number >> ((16-1-d)*4)) & 0xF;
    if(hex < 10) {
      s[d] = hex+48;
    } else {
      s[d] = hex+55;
    }
  }
  s[16] = '\0';
  return s;
}
