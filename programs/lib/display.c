#include <stdio.h>

#include "csr.h"
#include "display.h"

#include "font8x8_basic.h"

#define DISPLAY_NOOP    (*((volatile uint32_t *) (0xC2000000)))
#define DISPLAY_CMD     (*((volatile uint32_t *) (0xC2000004)))
#define DISPLAY_DATA    (*((volatile uint32_t *) (0xC2000008)))
#define DISPLAY_BUFF    (*((volatile uint32_t *) (0xC3000000)))  

#define UART            (*((volatile uint32_t *) (0xC3040000)))  
#define UART_BAUD       (*((volatile uint32_t *) (0xC3040004)))  

#define DISPLAY_WAIT_DELAY 1 //TODO was 120

#ifndef SIMULATION
  #define DISPLAY_HEIGHT    320
  #define DISPLAY_WIDTH    480
#else
  #define DISPLAY_HEIGHT    16
  #define DISPLAY_WIDTH    24
#endif

#define CONSOLE_ROWS    DISPLAY_HEIGHT/8
#define CONSOLE_COLS    DISPLAY_WIDTH/8

#define DISPLAY_CMD_DISPON   0x29
#define DISPLAY_CMD_SLEEPOUT 0x11
#define DISPLAY_CMD_RAMWR    0x2C

static volatile display_pixel_t * const display_buffer = (volatile display_pixel_t *) 0x10001000;
static volatile uint32_t * const console_buffer = (volatile uint32_t *) 0x10080000;

console_index_t curser_index = { 0, 0};

void display_on(void) {
  uint64_t timestamp;
  #ifndef NO_UART
    console_puts("Entering display_on...\n");
  #endif

  #ifndef SIMULATION
    timestamp = get_time();
    while(get_time()-timestamp < DISPLAY_WAIT_DELAY) {}
  #endif

  #ifndef NO_UART
    console_puts("Sending initialization settings...\n");
  #endif
  display_init();

  #ifndef NO_UART
    console_puts("Sending SLEEPOUT on...\n");
  #endif
  DISPLAY_CMD = DISPLAY_CMD_SLEEPOUT; // SLPOUT (11h): Sleep Out

  #ifndef SIMULATION
    timestamp = get_time();
    while(get_time()-timestamp < DISPLAY_WAIT_DELAY) {}
  #endif

  #ifndef NO_UART
    console_puts("Sending DISPON...\n");
  #endif
  DISPLAY_CMD = DISPLAY_CMD_DISPON;

  #ifndef SIMULATION
    timestamp = get_time();
    while(get_time()-timestamp < DISPLAY_WAIT_DELAY) {}
  #endif

  #ifndef NO_UART
    console_puts("Leaving display_on...\n");
  #endif

  return;
}

void display_init(void) {
  DISPLAY_CMD  = 0xC0; //Power Control 1
  DISPLAY_DATA = 0x19; //VREG1OUT POSITIVE
  DISPLAY_DATA = 0x1A; //VREG2OUT NEGATIVE

  DISPLAY_CMD  = 0xC1;
  DISPLAY_DATA = 0x45;//VGH,VGL    VGH>=14V.
  DISPLAY_DATA = 0x00;

  DISPLAY_CMD  = 0xC2;//Normal mode, increase can change the display quality, while increasing power consumption
  DISPLAY_DATA = 0x33;

  DISPLAY_CMD  = 0XC5;
  DISPLAY_DATA = 0x00;
  DISPLAY_DATA = 0x28;//VCM_REG[7:0]. <=0X80.

  DISPLAY_CMD  = 0xB1;//Sets the frame frequency of full color normal mode
  DISPLAY_DATA = 0xA0;//0XB0 =70HZ, <=0XB0.0xA0=62HZ
  DISPLAY_DATA = 0x11;

  DISPLAY_CMD  = 0xB4;
  DISPLAY_DATA = 0x02; //2 DOT FRAME MODE,F<=70HZ.

  DISPLAY_CMD  = 0xB6;//
  DISPLAY_DATA = 0x00;
  DISPLAY_DATA = 0x42;//0 GS SS SM ISC[3:0];
  DISPLAY_DATA = 0x3B;

  DISPLAY_CMD  = 0xB7;
  DISPLAY_DATA = 0x07;

  DISPLAY_CMD  = 0xE0;
  DISPLAY_DATA = 0x1F;
  DISPLAY_DATA = 0x25;
  DISPLAY_DATA = 0x22;
  DISPLAY_DATA = 0x0B;
  DISPLAY_DATA = 0x06;
  DISPLAY_DATA = 0x0A;
  DISPLAY_DATA = 0x4E;
  DISPLAY_DATA = 0xC6;
  DISPLAY_DATA = 0x39;
  DISPLAY_DATA = 0x00;
  DISPLAY_DATA = 0x00;
  DISPLAY_DATA = 0x00;
  DISPLAY_DATA = 0x00;
  DISPLAY_DATA = 0x00;
  DISPLAY_DATA = 0x00;

  DISPLAY_CMD  = 0XE1;
  DISPLAY_DATA = 0x1F;
  DISPLAY_DATA = 0x3F;
  DISPLAY_DATA = 0x3F;
  DISPLAY_DATA = 0x0F;
  DISPLAY_DATA = 0x1F;
  DISPLAY_DATA = 0x0F;
  DISPLAY_DATA = 0x46;
  DISPLAY_DATA = 0x49;
  DISPLAY_DATA = 0x31;
  DISPLAY_DATA = 0x05;
  DISPLAY_DATA = 0x09;
  DISPLAY_DATA = 0x03;
  DISPLAY_DATA = 0x1C;
  DISPLAY_DATA = 0x1A;
  DISPLAY_DATA = 0x00;

  DISPLAY_CMD  = 0XF1;
  DISPLAY_DATA = 0x36;
  DISPLAY_DATA = 0x04;
  DISPLAY_DATA = 0x00;
  DISPLAY_DATA = 0x3C;
  DISPLAY_DATA = 0x0F;
  DISPLAY_DATA = 0x0F;
  DISPLAY_DATA = 0xA4;
  DISPLAY_DATA = 0x02;

  DISPLAY_CMD  = 0XF2;
  DISPLAY_DATA = 0x18;
  DISPLAY_DATA = 0xA3;
  DISPLAY_DATA = 0x12;
  DISPLAY_DATA = 0x02;
  DISPLAY_DATA = 0x32;
  DISPLAY_DATA = 0x12;
  DISPLAY_DATA = 0xFF;
  DISPLAY_DATA = 0x32;
  DISPLAY_DATA = 0x00;

  DISPLAY_CMD  = 0XF4;
  DISPLAY_DATA = 0x40;
  DISPLAY_DATA = 0x00;
  DISPLAY_DATA = 0x08;
  DISPLAY_DATA = 0x91;
  DISPLAY_DATA = 0x04;

  DISPLAY_CMD  = 0XF8;
  DISPLAY_DATA = 0x21;
  DISPLAY_DATA = 0x04;

  DISPLAY_CMD  = 0X3A;//Set Interface Pixel Format
  DISPLAY_DATA = 0x55;

  //Set scan direction, U2D,L2R
  DISPLAY_CMD  = 0XB6;
  DISPLAY_DATA = 0x00;
  DISPLAY_DATA = 0x22;
  DISPLAY_CMD  = 0X36;
  DISPLAY_DATA = 0x08;
}

       uint32_t display_height(void) {
  return DISPLAY_HEIGHT;
}

       uint32_t display_width(void) {
  return DISPLAY_WIDTH;
}

       void     dispbuff_write_pixel(uint16_t y, uint16_t x, display_pixel_t pixel) {
  display_buffer[y*DISPLAY_WIDTH+x] = pixel;
  return;
}

  display_pixel_t dispbuff_read_pixel(uint16_t y, uint16_t x) {
  return display_buffer[y*DISPLAY_WIDTH+x];
}


       void     display_write_start(void) {
  //Screen prints top to bottom, right to left
  DISPLAY_CMD = DISPLAY_CMD_RAMWR; //  RAMWR (2Ch): Memory Write 
  return;
}

       void     display_write_pixel(display_pixel_t pixel) {
  DISPLAY_DATA = *(uint32_t*)&pixel;
  return;
}

       void display_write(void) {
  display_write_start();
  display_pixel_t pixel;
  for(int x = 0; x < DISPLAY_WIDTH; x++) {
    for(int y = 0; y < DISPLAY_HEIGHT; y++) {
      int consoleX = x/8;
      int consoleY = y/8;
      int charX = x%8;
      int charY = y%8;
      uint8_t char_set = font8x8_basic[console_buffer[(DISPLAY_HEIGHT/8-1-consoleY)*CONSOLE_COLS+consoleX]][7-charY] & (1 << charX);
      if(char_set) {
        pixel = PXL_WHITE;
      } else {
        pixel = dispbuff_read_pixel(y,x);
      }
      display_write_pixel(pixel);
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
      console_buffer[y*CONSOLE_COLS+x] = 0;
    }
  }
  return;
}
  
void console_put_char(char c) {
  if(c == '\n') {
    UART = '\r';
  }
  UART = c;

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

void set_uart_baud(uint32_t baud)
{
  UART_BAUD = 50000000/baud;
}
  
char * uint8_to_hex(uint8_t number) {
  static char s[3];
  for(int8_t d = 0; d < 2; d++) {
    uint8_t hex = (number >> ((2-1-d)*4)) & 0xF;
    if(hex < 10) {
      s[d] = hex+48;
    } else {
      s[d] = hex+55;
    }
  }
  s[2] = '\0';
  return s;
}
  
char * uint32_to_hex(uint32_t number) {
  static char s[9];
  for(int32_t d = 0; d < 8; d++) {
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
  for(int64_t d = 0; d < 16; d++) {
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
