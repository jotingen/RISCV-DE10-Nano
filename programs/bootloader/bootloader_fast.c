#include <stdint.h>
#include <stdio.h>

#include "../lib/csr.h"
#include "../lib/rand.h"
#include "../lib/sdcard.h"

#define LED             (*((volatile unsigned int *) (0xC0000000)))

// Function to reverse elements of an array
void reverse(uint8_t arr[], int n) {
	for (int low = 0, high = n - 1; low < high; low++, high--)
	{
		uint8_t temp = arr[low];
		arr[low]     = arr[high];
		arr[high]    = temp;
	}
}

void main(void) {
  static uint8_t sdcard_data[514];

  static volatile uint32_t * const ddr3 = (volatile uint32_t *) 0x10000000;

  uint32_t sector_index = 0;

  LED = 0x55;

  sdcard_on();

  LED = 0x00;

  while(sector_index < 10) {
    sdcard_read(sdcard_data,512*sector_index);

    for(int i = 0; i < 512; i= i+4) {
      uint32_t word = 0;
      word = (word << 8) | sdcard_data[i+3];
      word = (word << 8) | sdcard_data[i+2];
      word = (word << 8) | sdcard_data[i+1];
      word = (word << 8) | sdcard_data[i+0];
      ddr3[sector_index*512/4+i/4] = word;
    }

    sector_index += 1;
    LED++;
  }

  ((void (*)(void))0x10000000)();

}


