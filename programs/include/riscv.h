#ifndef	_RISCV_H_
#define _RISCV_H_

#define LED              (*((volatile unsigned int *) (0xC0000000)))

#define DEBUG            (*((volatile unsigned int *) (0xD0000000)))
#define DEBUG_ENTRIES_8B 16384

#endif
