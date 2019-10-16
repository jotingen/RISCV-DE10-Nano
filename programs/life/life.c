#include <stdint.h>
#include <stdio.h>

#include "../lib/csr.h"
#include "../lib/display.h"
#include "../lib/rand.h"
#include "../lib/font8x8/font8x8_basic.h"

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

      LED = 0;
        pixel.R = 0x00;
        pixel.G = 0x3F;
        pixel.B = 0x3F;
      LED = 1;
      dispbuff_write_pixel(0,0,&pixel);
        pixel.R = 0x3F;
        pixel.G = 0x00;
        pixel.B = 0x00;
      dispbuff_write_pixel(display_rows()-1,display_cols()-1,&pixel);
      LED = 2;
      dispbuff_read_pixel(0,0,&pixel);
      LED = 3;
      dispbuff_read_pixel(display_rows()-1,display_cols()-1,&pixel);
      LED = 4;
        for (int8_t x=0; x < 8; x++) {
          for (int8_t y=7; y >= 0; y--) {
              uint8_t set = font8x8_basic['J'][x] & (1 << y);
              display_pixel_t pixel;
              if(set) {
                pixel.R = 0xFF;
                pixel.G = 0x00;
                pixel.B = 0x00;
                dispbuff_write_pixel(x,y,&pixel);
                dispbuff_write_pixel(168/2-4+x,120/2-4-y,&pixel);
              }
          }
        }

counter = 0;
rand_init();
  display_on();
      LED = 5;

      //sprintf(buff, "Cycle %5d", get_time());

      LED = 6;

  //Get initial timestamps
  //timestamp   = get_time();
  //keystamp    = timestamp;

      LED = 7;
  //Initialize life and frame buffer
  for(int row = 0; row < display_rows(); row++) {
    for(int col = 0; col < display_cols(); col++) {
      if(rand()%3 == 0) { 
        life[row][col] = 1;
      } else {
        life[row][col] = 0;
      }
      paint_pixel(row,col,&life[row][col]);
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

      //Displayframe buffer
      LED = 9;
      display_write();
        
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
            //if(life[row][col] != life_next[row][col]) {
              paint_pixel(row,col,&life_next[row][col]);
            //}
          }
        }
        //Draw random letter
        //x=50
        //y=30
        for (uint8_t x=0; x < 8; x++) {
          for (uint8_t y=0; y < 8; y++) {
          //for (int8_t y=7; y >= 0; y--) {
              uint8_t set = font8x8_basic[0x30 + counter%10][x] & (1 << y);
              display_pixel_t pixel;
              if(set) {
                pixel.R = 0xFF;
                pixel.G = 0x00;
                pixel.B = 0x00;
                dispbuff_write_pixel(7-x,y,&pixel);
                dispbuff_write_pixel(168/2-4+7-x,120/2-4+y,&pixel);
              }
          }
        }
        LED = 13;
        //Promote life_next to life
        for(int row = 0; row < display_rows(); row++) {
          for(int col = 0; col < display_cols(); col++) {
              life[row][col] = life_next[row][col];
          }
        }
      //while(BUTTON_0        == 1) {} 
      //}

      LED = 14;

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

    counter++;
  }
}

