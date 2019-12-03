#include <stdint.h>
#include <stdio.h>

#include "../lib/csr.h"
#include "../lib/display.h"
#include "../lib/rand.h"
#include "../lib/sdcard.h"

#define LED             (*((volatile unsigned int *) (0xC0000000)))

#define BUTTON_0        (*((volatile unsigned int *) (0xC1000000)))
#define BUTTON_1        (*((volatile unsigned int *) (0xC1000004)))

#define JOYSTICK_UP     (*((volatile unsigned int *) (0xC1000100)))
#define JOYSTICK_RIGHT  (*((volatile unsigned int *) (0xC1000104)))
#define JOYSTICK_SELECT (*((volatile unsigned int *) (0xC1000108)))
#define JOYSTICK_DOWN   (*((volatile unsigned int *) (0xC100010C)))
#define JOYSTICK_LEFT   (*((volatile unsigned int *) (0xC1000110)))

#define DDR3            (*((volatile unsigned int *) (0x10000010)))

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
  static uint8_t sdcard_data[514];

  static volatile uint32_t * const console_buffer = (volatile uint32_t *) 0xC3020000;
  static volatile uint32_t * const ddr3 = (volatile uint32_t *) 0x10000010;

  console_clear();
  display_on();
  display_write();

  console_puts("Booting DE10Nano RISCV Bootloader...\n\n");
  display_write();

  console_puts("Initiating SDCard...");
  display_write();
  sdcard_on();
  console_puts("done\n");
  display_write();

  console_puts("Initiating Random Number Generator...");
  display_write();
  rand_init();
  console_puts("done\n");
  display_write();

  console_puts("Testing SDCard read of Sector 0...");
  display_write();
  sdcard_read(sdcard_data,512*0);
  for(int i = 0; i < 514; i++) {
    console_puts(uint8_to_hex(sdcard_data[i]));
  }
  console_puts("\ndone\n");
  display_write();

  console_puts("DDR3 Test");
  console_puts("Writing SDCard Sector 0 to DDR3...");
  for(int i = 0; i < 514; i++) {
    uint32_t word = 0;
    word = word | sdcard_data[i];
    ddr3[i] = word;
  }
  console_puts("done\n");
  console_puts("Reading SDCard Sector 0 from DDR3...\n");
  display_write();
  for(int i = 0; i < 514; i++) {
    console_puts(uint8_to_hex(ddr3[i] & 0xFF));
  }
  console_puts("\ndone\n");
  display_write();

  while(1);
}


