#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#define LED             (*((volatile unsigned int *) (0xC0000000)))

int main()
{
	LED = 0;
	uint64_t limit = 255;
	size_t primes_size = (limit) * sizeof(uint64_t);
	uint64_t *primes = (uint64_t*)malloc(primes_size);
	for(uint64_t n = 2; n < limit; n++) {
		LED = n;
		primes[n] = 1;
		for(uint64_t i = 2; i <= n; ++i) {
			if(n % i == 0) {
				primes[n] = 0;
				break;
			}
		}
	}
	LED = 0;
	for(uint64_t n = 2; n < limit; n++) {
		if(primes[n]) {
			LED = n;
		}
	}
	while(1);
};
