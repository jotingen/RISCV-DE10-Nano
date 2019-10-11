#include <stdint.h>
#include <stdio.h>

#include "../lib/counters.h"
#include "../lib/display.h"

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


uint32_t xorshift(uint32_t lfsr) {
  uint32_t bit = ((lfsr >> 5) ^ (lfsr >> 13) ^ (lfsr >> 17));
  return (lfsr >> 1) | (bit << 31);
}

void paint_framebuffer(int rows, int cols, uint8_t life[rows][cols]) {
  display_pixel_t pixel;
  for(int row = display_rows()-1; row >= 0; row--) {
    for(int col = display_cols()-1; col >= 0; col--) {
      if(life[row][col] == 0) {
        pixel.R = 0xFF;
        pixel.G = 0xFF;
        pixel.B = 0xFF;
      } else {
        pixel.R = 0x00;
        pixel.G = 0x00;
        pixel.B = 0x00;
      }
      display_write_buffer(row,col,pixel);
    }
  }
  display_write_start();
  for(int row = display_rows()-1; row >= 0; row--) {
    for(int col = display_cols()-1; col >= 0; col--) {
      display_write_pixel(display_read_buffer(row,col));
    }
  }
}

void main(void) {
  uint32_t  MADCTL;

  uint32_t but0, but1;
  uint32_t joy_sel, joy_up, joy_down, joy_left, joy_right;

  uint32_t key_pressed;

  //uint64_t timestamp;
  //uint64_t keystamp;
  //uint64_t displaystamp;

  uint32_t led;

  uint32_t lfsr;

  uint8_t life[display_rows()][display_cols()];
  uint8_t life_next[display_rows()][display_cols()];

  display_pixel_t test_pixel;

  lfsr = 0xAAAAAAAA;

      LED = 0;
        test_pixel.R = 0x00;
        test_pixel.G = 0x3F;
        test_pixel.B = 0x3F;
      LED = 2;
      display_write_buffer(0,0,test_pixel);
        test_pixel.R = 0x3F;
        test_pixel.G = 0x00;
        test_pixel.B = 0x00;
      display_write_buffer(display_rows()-1,display_cols()-1,test_pixel);
      LED = 3;
      test_pixel = display_read_buffer(0,0);
      LED = 4;
      test_pixel = display_read_buffer(display_rows()-1,display_cols()-1);
      LED = 5;

  display_on();

      LED = 6;

  //Get initial timestamps
  //timestamp   = get_time();
  //keystamp    = timestamp;

      LED = 7;
      //LED = lfsr;
  //Initialize life
  for(int row = 0; row < display_rows(); row++) {
    for(int col = 0; col < display_cols(); col++) {
      lfsr = xorshift(lfsr);
      if(lfsr%3 == 0) { 
        life[row][col] = 1;
      } else {
        life[row][col] = 0;
      }
    }
  }
      LED = 8;

  //Main loop
  while(1) {
    //Get new timestamp
    //timestamp = get_time();

    //Get keypresses if the delta between the current timestamp and last keystamp is >= KEY_TIME
    //if ((timestamp-keystamp) >= KEY_TIME) {
    //  if(BUTTON_0        == 1) {key_pressed = 1; but0      = 1;} 
    //  if(BUTTON_1        == 1) {key_pressed = 1; but1      = 1;} 
    //  if(JOYSTICK_SELECT == 1) {key_pressed = 1; joy_sel   = 1;}    
    //  if(JOYSTICK_UP     == 1) {key_pressed = 1; joy_up    = 1;} 
    //  if(JOYSTICK_DOWN   == 1) {key_pressed = 1; joy_down  = 1;} 
    //  if(JOYSTICK_LEFT   == 1) {key_pressed = 1; joy_left  = 1;} 
    //  if(JOYSTICK_RIGHT  == 1) {key_pressed = 1; joy_right = 1;} 
    //  keystamp = timestamp;
    //}

                                     
    //Update LED/Display if the delta between the current timestamp and last displaystamp is >= DISPLAY_TIME  
    //Reset timer
    //Reset buttons
    //if(timestamp >= DISPLAY_TIME) {
      ////Prep LED
      //led = 0;

      ////If key_pressed, change LED to reflect keypress
      //if(key_pressed) {
      //  if(but0     ) led = led | 0x01;
      //  if(but1     ) led = led | 0x02;
      //  if(joy_sel  ) led = led | 0x04;
      //  if(joy_up   ) led = led | 0x08;
      //  if(joy_down ) led = led | 0x10;
      //  if(joy_left ) led = led | 0x20;
      //  if(joy_right) led = led | 0x40;
      //}

      ////Update LED
      //LED = led;

      //Update frame buffer
      LED = 9;
      paint_framebuffer(display_rows(),display_cols(),life);
        
      LED = 10;
      //Reset timers
      //clear_time();
      //timestamp = 0;
      //keystamp  = 0;

      LED = 11;
      //if(but0     ) {
        //Update life
        for(int row = 0; row < display_rows(); row++) {
          for(int col = 0; col < display_cols(); col++) {
            int row_upper, row_middle, row_lower;
            int col_left,  col_middle, col_right;
            int neighbors = 0;
            
            if(row == display_rows()-1) {
              row_upper  = 0;
              row_middle = row;
              row_lower  = row - 1;
            } else if(row == 0) {
              row_upper  = row + 1;
              row_middle = row;
              row_lower  = display_rows()-1;
            } else {
              row_upper  = row + 1;
              row_middle = row;
              row_lower  = row - 1;
            }

            if(col == display_cols()-1) {
              col_left   = col - 1;
              col_middle = col;
              col_right  = 0;
            } else if(col == 0) {
              col_left   = display_cols()-1;
              col_middle = col;
              col_right  = col + 1;
            } else {
              col_left   = col - 1;
              col_middle = col;
              col_right  = col + 1;
            }
            
            if(life[row_upper ][col_left  ]) neighbors++;
            if(life[row_upper ][col_middle]) neighbors++;
            if(life[row_upper ][col_right ]) neighbors++;
            if(life[row_middle][col_left  ]) neighbors++;
            if(life[row_middle][col_right ]) neighbors++;
            if(life[row_lower ][col_left  ]) neighbors++;
            if(life[row_lower ][col_middle]) neighbors++;
            if(life[row_lower ][col_right ]) neighbors++;

            if(life[row][col]) {
              if(neighbors < 2 ) {
                life_next[row][col] = 0;
              } else if(neighbors > 3 ) {
                life_next[row][col] = 0;
              } else {
                life_next[row][col] = 1;
              }
            } else {
              if(neighbors == 3 ) {
                life_next[row][col] = 1;
              } else {
                life_next[row][col] = 0;
              }
            }
          }
        }
        LED = 12;
        for(int row = 0; row < display_rows(); row++) {
          for(int col = 0; col < display_cols(); col++) {
              life[row][col] = life_next[row][col];
          }
        }
      //while(BUTTON_0        == 1) {} 
      //}

      LED = 13;

      //Clear keypresses
      but0        = 0;
      but1        = 0;
      joy_sel     = 0;
      joy_up      = 0;
      joy_down    = 0;
      joy_left    = 0;
      joy_right   = 0;
      key_pressed = 0;

    //}

  }
}

