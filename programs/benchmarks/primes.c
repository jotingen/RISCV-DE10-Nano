#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
//#include <math.h>

#define test(p) (primes[p >> 6] & 1 << (p & 0x3f))
#define set(p) (primes[p >> 6] |= 1 << (p & 0x3f))
#define is_prime(p) !test(p)

#define LED             (*((volatile unsigned int *) (0xC0000000)))

uint64_t sqrt(uint64_t x)  
{  
    register uint64_t op, res, one;  
  
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
	int64_t limit = 33333333;
	size_t primes_size = ((limit >> 6) + 1) * sizeof(uint64_t);
	uint64_t *primes = (uint64_t*)malloc(primes_size);
	int64_t p = 2, sqrt_limit = (int64_t)sqrt((uint64_t)limit);
	while (p <= limit >> 1) {
		for (int64_t n = 2 * p; n <= limit; n += p) if (!test(n)) set(n);
		while (++p <= sqrt_limit && test(p));
	}
	for (int i = limit; i > 0; i--) {
		if (is_prime(i)) {
			//printf("%d\n", i);
			LED = i;
			return 0;
		}
	}
};

