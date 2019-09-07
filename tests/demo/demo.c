#include <stdint.h>
#include <stdio.h>

#define read_csr(reg) ({ unsigned int __tmp;asm volatile ("csrr %0, " #reg : "=r"(__tmp));__tmp; })
#define CSR_CYCLE     0xC00
#define CSR_CYCLE_H   0xC80
#define CSR_TIME      0xC01
#define CSR_TIME_H    0xC81
#define CSR_INSTRET   0xC02
#define CSR_INSTRET_H 0xC82

#define LED             (*((volatile unsigned int *) (0xC0000000)))

#define BUTTON_0        (*((volatile unsigned int *) (0xC1000000)))
#define BUTTON_1        (*((volatile unsigned int *) (0xC1000004)))

#define JOYSTICK_UP     (*((volatile unsigned int *) (0xC1000100)))
#define JOYSTICK_RIGHT  (*((volatile unsigned int *) (0xC1000104)))
#define JOYSTICK_SELECT (*((volatile unsigned int *) (0xC1000108)))
#define JOYSTICK_DOWN   (*((volatile unsigned int *) (0xC100010C)))
#define JOYSTICK_LEFT   (*((volatile unsigned int *) (0xC1000110)))

#define DISPLAY_NOOP    (*((volatile unsigned int *) (0xC2000000)))
#define DISPLAY_CMD     (*((volatile unsigned int *) (0xC2000004)))
#define DISPLAY_DATA    (*((volatile unsigned int *) (0xC2000008)))

//200Hz
#define KEY_TIME        250000
//60Hz
#define DISPLAY_TIME    833333

unsigned int get_csr_cycle() {
  __asm__(
    "csrrs a0, cycle, x0 \n"
    "lw s0, 12(sp)\n"
    "add sp, sp, 16\n"
    "jr ra\n"
  );
  return 1;
  //return read_csr(cycle);
}
unsigned int get_csr_cycleh() {
  __asm__(
    "csrrs a0, cycleh, x0 \n"
    "lw s0, 12(sp)\n"
    "add sp, sp, 16\n"
    "jr ra\n"
  );
  return 1;
  //return read_csr(cycleh);
}
uint64_t get_time() {
  uint64_t time;
  time = 0;
  time = time | get_csr_cycleh();
  time = time << 32;
  time = time | get_csr_cycle();
  return time;
}

void clear_time() {
  __asm__(
    "add t1, zero, zero \n"
    "not t1, t1 \n"
    "csrrc x0, cycleh, t1 \n"
    "csrrc x0, cycle, t1 \n"
  );
}

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



  //Power On Display
  DISPLAY_CMD = 0x29; // DISPON (29h): Display On 

  while(get_time() < 5000000) {}
  clear_time();

  DISPLAY_CMD = 0x11; //SLPOUT (11h): Sleep Out

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
    //LED = 0x80;
    //Get new timestamp
    timestamp = get_time();

    //Get keypresses if the delta between the current timestamp and last keystamp is >= KEY_TIME
    if ((timestamp-keystamp) >= KEY_TIME) {
    //LED = 0x81;
      if(BUTTON_0        == 1) {key_pressed = 1; but0      = 1;} 
      if(BUTTON_1        == 1) {key_pressed = 1; but1      = 1;} 
      if(JOYSTICK_SELECT == 1) {key_pressed = 1; joy_sel   = 1;}    
      if(JOYSTICK_UP     == 1) {key_pressed = 1; joy_up    = 1;} 
      if(JOYSTICK_DOWN   == 1) {key_pressed = 1; joy_down  = 1;} 
      if(JOYSTICK_LEFT   == 1) {key_pressed = 1; joy_left  = 1;} 
      if(JOYSTICK_RIGHT  == 1) {key_pressed = 1; joy_right = 1;} 
      keystamp = timestamp;
    }
    //LED = 0x82;

    //Step through Fibonnacci if the delta between the current timestamp and last displaystamp is >= DISPLAY_TIME 
    if(timestamp >= DISPLAY_TIME) {
    //LED = 0x83;
      fibbonacci(&a, &b);
    }
    //LED = 0x84;
                                     
    //Update LED/Display if the delta between the current timestamp and last displaystamp is >= DISPLAY_TIME  
    //Reset timer
    //Reset buttons
    if(timestamp >= DISPLAY_TIME) {
    //LED = 0x85;
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

      for(int display_index = 128*160; display_index >=0; display_index--) {
    //LED = 0x86;
        if(display_index == 128*160) {
          DISPLAY_CMD = 0x2C; //  RAMWR (2Ch): Memory Write 
          //display_index = 0;
        } else {
            if((pass + display_index)%4 == 0) {
                DISPLAY_DATA = 0xFC;
                DISPLAY_DATA = 0xFC;
                DISPLAY_DATA = 0xFC;
            } else if((pass + display_index)%4 == 1) {
                DISPLAY_DATA = 0xFC;
                DISPLAY_DATA = 0x80;
                DISPLAY_DATA = 0x80;
            } else if((pass + display_index)%4 == 2) {
                DISPLAY_DATA = 0x80;
                DISPLAY_DATA = 0xFC;
                DISPLAY_DATA = 0x80;
            } else if((pass + display_index)%4 == 3) {
                DISPLAY_DATA = 0x80;
                DISPLAY_DATA = 0x80;
                DISPLAY_DATA = 0xFC;
            }
          //display_index++;
        }
    //LED = 0x87;
      }
      pass++;
        
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

    //LED = 0x88;
      //Reset timers
      clear_time();
      timestamp = 0;
      keystamp  = 0;
    //LED = 0x89;
    }

  }
}

