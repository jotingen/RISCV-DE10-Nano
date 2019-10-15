#include <stdint.h>
#include <stdio.h>

#include "../lib/csr.h"
#include "../lib/display.h"
#include "../lib/rand.h"

#define DISPLAY_CMD     (*((volatile unsigned int *) (0xC2000004)))
#define DISPLAY_DATA    (*((volatile unsigned int *) (0xC2000008)))

#define LED             (*((volatile unsigned int *) (0xC0000000)))

#define BUTTON_0        (*((volatile unsigned int *) (0xC1000000)))
#define BUTTON_1        (*((volatile unsigned int *) (0xC1000004)))

#define JOYSTICK_UP     (*((volatile unsigned int *) (0xC1000100)))
#define JOYSTICK_RIGHT  (*((volatile unsigned int *) (0xC1000104)))
#define JOYSTICK_SELECT (*((volatile unsigned int *) (0xC1000108)))
#define JOYSTICK_DOWN   (*((volatile unsigned int *) (0xC100010C)))
#define JOYSTICK_LEFT   (*((volatile unsigned int *) (0xC1000110)))

//200Hz
#define KEY_TIME        250000
//60Hz
#define DISPLAY_TIME    833333


void fibbonacci(uint32_t* a, uint32_t* b) {
  uint32_t c;
  c = *b;
  *b = *a;
  *a = *b + c;
}

void main(void) {
  uint32_t inv;
  uint32_t color;
  uint32_t colordata;
  uint32_t pass;
  //uint32_t display_index;

  uint32_t but0, but1;
  uint32_t joy_sel, joy_up, joy_down, joy_left, joy_right;

  uint32_t key_pressed;

  uint64_t timestamp;
  uint64_t keystamp;
  uint64_t displaystamp;

  uint32_t led;

  uint32_t a,b,c;



  display_on();

  //DISPLAY_CMD = 0x2C; //  RAMWR (2Ch): Memory Write 

  //display_index = 128*160+1;
  inv = 0;
  color = 0;
  pass = 0;

  timestamp   = get_time();
  keystamp    = timestamp;

  but0      = 0;
  but1      = 0;
  joy_sel   = 0;
  joy_up    = 0;
  joy_down  = 0;
  joy_left  = 0;
  joy_right = 0;
  key_pressed = 0;

  a = 1;
  b = 1;


  while(1) {
    //Get new timestamp
    timestamp = get_time();

    //Get keypresses if the delta between the current timestamp and last keystamp is >= KEY_TIME
    if ((timestamp-keystamp) >= KEY_TIME) {
      if(BUTTON_0        == 1) {key_pressed = 1; but0      = 1;} 
      if(BUTTON_1        == 1) {key_pressed = 1; but1      = 1;} 
      if(JOYSTICK_SELECT == 1) {key_pressed = 1; joy_sel   = 1;}    
      if(JOYSTICK_UP     == 1) {key_pressed = 1; joy_up    = 1;} 
      if(JOYSTICK_DOWN   == 1) {key_pressed = 1; joy_down  = 1;} 
      if(JOYSTICK_LEFT   == 1) {key_pressed = 1; joy_left  = 1;} 
      if(JOYSTICK_RIGHT  == 1) {key_pressed = 1; joy_right = 1;} 
      keystamp = timestamp;
    }

    //Step through Fibonnacci if the delta between the current timestamp and last displaystamp is >= DISPLAY_TIME 
    if(timestamp >= DISPLAY_TIME) {
      fibbonacci(&a, &b);
    }
                                     
    //Update LED/Display if the delta between the current timestamp and last displaystamp is >= DISPLAY_TIME  
    //Reset timer
    //Reset buttons
    if(timestamp >= DISPLAY_TIME) {
      //Prep LED with 'a' value from fibonnacci
      led = a;

      //If key_pressed, change LED to reflect keypress
      if(key_pressed) {
        led = 0;
        if(but0     ) led = led | 0x01;
        if(but1     ) led = led | 0x02;
        if(joy_sel  ) led = led | 0x04;
        if(joy_up   ) led = led | 0x08;
        if(joy_down ) led = led | 0x10;
        if(joy_left ) led = led | 0x20;
        if(joy_right) led = led | 0x40;
      }

      //Update LED
      LED = led;

      if(but0) {
        for(int row = display_rows()-1; row >= 0; row--) {
          for(int col = display_cols()-1; col >= 0; col--) {
            if((pass + row*col)%4 == 0) {
                //screen[row][col].R = 0xFC;
                //screen[row][col].G = 0xFC;
                //screen[row][col].B = 0xFC;
            } else if((pass + row*col)%4 == 1) {
                //screen[row][col].R = 0xFC;
                //screen[row][col].G = 0x80;
                //screen[row][col].B = 0x80;
            } else if((pass + row*col)%4 == 2) {
                //screen[row][col].R = 0x80;
                //screen[row][col].G = 0xFC;
                //screen[row][col].B = 0x80;
            } else if((pass + row*col)%4 == 3) {
                //screen[row][col].R = 0x80;
                //screen[row][col].G = 0x80;
                //screen[row][col].B = 0xFC;
            }
            //display_index++;
          }
        }
        pass++;
      } else {
        for(int row = display_rows()-1; row >= 0; row--) {
          for(int col = display_cols()-1; col >= 0; col--) {
            rand();
            //screen[row][col].R = 0x80 | ((lfsr >> 0) & 0x7F);
            //screen[row][col].G = 0x80 | ((lfsr >> 7) & 0x7F);
            //screen[row][col].B = 0x80 | ((lfsr >> 14) & 0x7F);
          }
        }
      }
      //display_write();
        
        
      ////Invert Display
      //if(inv) {
      //  DISPLAY_CMD = 0x20; // INVOFF (20h): Display Inversion Off 
      //  inv = 0;
      //} else {     
      //  DISPLAY_CMD = 0x21; // INVON (21h): Display Inversion On 
      //  inv = 1;
      //}

      //Clear keypresses
      but0        = 0;
      but1        = 0;
      joy_sel     = 0;
      joy_up      = 0;
      joy_down    = 0;
      joy_left    = 0;
      joy_right   = 0;
      key_pressed = 0;

      //Reset timers
      reset_time();
      timestamp = 0;
      keystamp  = 0;
    }

  }
}

