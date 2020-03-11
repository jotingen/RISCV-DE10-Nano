#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "../lib/display.h"

#define LED             (*((volatile unsigned int *) (0xC0000000)))

uint32_t sqrt(uint32_t x)  
{  
    register uint32_t op, res, one;  
  
    op = x;  
    res = 0;  
  
    /* "one" starts at the highest power of four <= than the argument. */  
    one = 1 << 30;  /* second-to-top bit set */  
    while (one > op) one >>= 2;  
  
    while (one != 0) {  
        if (op >= res + one) {  
            op -= res + one;  
            res += one << 1;  // <-- faster than 2 * one  
        }  
        res >>= 1;  
        one >>= 2;  
    }  
    return res;  
}

int main()
{
	
        //set_uart_baud(921600);
        char buffer[80];
  	console_clear();
        console_puts("Prime calculation benchmark\n");
        console_puts("---------------------------\n");
        console_putc('\n');
	LED = 0;
	uint32_t limit = 255;
	size_t primes_size = (limit) * sizeof(uint32_t);
	uint32_t *primes = (uint32_t*)malloc(primes_size);
	uint32_t prime_count = 1; //Seed 2 as first prime
	primes[0] = 2;            //Seed 2 as first prime
        LED = 2;
        //console_puts(uint8_to_hex(LED));
	//console_putc('\n');
        sprintf(buffer,"%d\n",(uint32_t)LED);
        console_puts(buffer);
	for(uint32_t n = 3; n < limit; n++) {
		int is_prime = 1;
		for(uint32_t p = 0; p < prime_count; ++p) {
			if(n % primes[p] == 0) {
				is_prime = 0;
				break;
			}
		}
		if(is_prime) {
			primes[prime_count] = n;
			prime_count++;
			LED = n;
			//console_puts(uint8_to_hex(LED));
			//console_putc('\n');
                        sprintf(buffer,"%d\n",(uint32_t)LED);
                        console_puts(buffer);
		}
	}
	while(1);
};
