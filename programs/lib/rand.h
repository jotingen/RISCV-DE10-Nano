#ifndef	_RAND_H_
#define _RAND_H_

       void xorshift(uint32_t * lfsr);

extern void     rand_init(void);
extern void     rand_seed_init(uint32_t seed);
extern uint32_t rand(void);

#endif
