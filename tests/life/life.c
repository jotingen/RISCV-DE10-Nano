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
#define DISPLAY_ROWS    160
#define DISPLAY_COLS    128

//200Hz
#define KEY_TIME        250000
//60Hz
//#define DISPLAY_TIME    833333
//30Hz
#define DISPLAY_TIME   1666666

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

void xorshift(uint32_t* lfsr) {
  uint32_t new = *lfsr;
  new ^= new << 13;
  new ^= new >> 17;
  new ^= new << 5;
  *lfsr = new;
}

void main(void) {
  uint32_t  MADCTL;

  uint32_t but0, but1;
  uint32_t joy_sel, joy_up, joy_down, joy_left, joy_right;

  uint32_t key_pressed;

  uint64_t timestamp;
  uint64_t keystamp;
  uint64_t displaystamp;

  uint32_t led;

  uint32_t lfsr;

  uint8_t life[DISPLAY_ROWS][DISPLAY_COLS];
  uint8_t life_next[DISPLAY_ROWS][DISPLAY_COLS];

  lfsr = 1;

  //Power On Display
  DISPLAY_CMD = 0x29; // DISPON (29h): Display On 

  //Wait to take display out of sleep
  while(get_time() < 5000000) {}
  clear_time();
  DISPLAY_CMD = 0x11; // SLPOUT (11h): Sleep Out
  //DISPLAY_CMD = 0x36; // MADCTL (36h): Memory Data Access Control  
  //  //Set up refresh rate to match orientation of shield
  //  MADCTL = 0;
  //  MADCTL = MADCTL | (0 << 7); //MY
  //  MADCTL = MADCTL | (1 << 6); //MX 
  //  MADCTL = MADCTL | (1 << 5); //MV
  //  MADCTL = MADCTL | (0 << 4); //ML
  //  MADCTL = MADCTL | (0 << 3); //RGB
  //  MADCTL = MADCTL | (1 << 2); //MH
  //  DISPLAY_DATA = MADCTL;

      LED = 1;
  //Get initial timestamps
  timestamp   = get_time();
  keystamp    = timestamp;

      LED = 2;
  //Initialize life
  for(int row = 0; row < DISPLAY_ROWS; row++) {
    for(int col = 0; col < DISPLAY_COLS; col++) {
      xorshift(&lfsr);
      //if(lfsr%5 == 0) { //GCC having issues with modulo
      if((lfsr >> 29) == 0) {
        life[row][col] = 1;
      } else {
        life[row][col] = 0;
      }
    }
  }
      LED = 3;

  //Main loop
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

                                     
    //Update LED/Display if the delta between the current timestamp and last displaystamp is >= DISPLAY_TIME  
    //Reset timer
    //Reset buttons
    if(timestamp >= DISPLAY_TIME) {
      //Prep LED
      led = 0;

      //If key_pressed, change LED to reflect keypress
      if(key_pressed) {
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

      LED = 4;
      //Screen prints top to bottom, right to left
      DISPLAY_CMD = 0x2C; //  RAMWR (2Ch): Memory Write 
      for(int row = DISPLAY_ROWS-1; row >= 0; row--) {
        for(int col = DISPLAY_COLS-1; col >= 0; col--) {
          if(life[row][col] == 0) {
            DISPLAY_DATA = 0xFC;
            DISPLAY_DATA = 0xFC;
            DISPLAY_DATA = 0xFC;
	  } else {
            DISPLAY_DATA = 0x80;
            DISPLAY_DATA = 0x80;
            DISPLAY_DATA = 0x80;
          }
        }
      }
        
      LED = 5;
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
      clear_time();
      timestamp = 0;
      keystamp  = 0;

      LED = 6;
      //Update life
      xorshift(&lfsr);
      for(int row = 0; row < DISPLAY_ROWS; row++) {
        for(int col = 0; col < DISPLAY_COLS; col++) {
          int row_upper, row_middle, row_lower;
          int col_left,  col_middle, col_right;
          int neighbors = 0;
          
          if(row == DISPLAY_ROWS-1) {
            row_upper  = 0;
            row_middle = row;
            row_lower  = row - 1;
          } else if(row == 0) {
            row_upper  = row + 1;
            row_middle = row;
            row_lower  = DISPLAY_ROWS-1;
          } else {
            row_upper  = row + 1;
            row_middle = row;
            row_lower  = row - 1;
          }

          if(col == DISPLAY_COLS-1) {
            col_left   = col - 1;
            col_middle = col;
            col_right  = 0;
          } else if(col == 0) {
            col_left   = DISPLAY_COLS-1;
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
      LED = 7;
      for(int row = 0; row < DISPLAY_ROWS; row++) {
        for(int col = 0; col < DISPLAY_COLS; col++) {
            life[row][col] = life_next[row][col];
        }
      }

      LED = 8;
    }

  }
}

