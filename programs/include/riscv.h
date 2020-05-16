#ifndef	_RISCV_H_
#define _RISCV_H_

#define DDR3              (*((volatile unsigned int *) (0x10000000)))
#define DDR3_ENTRIES_8B   0x3FFFFFF
#define DDR3_ENTRIES_16B  (DDR3_ENTRIES_8B>>1)
#define DDR3_ENTRIES_32B  (DDR3_ENTRIES_8B>>2)
#define DDR3_ENTRIES_64B  (DDR3_ENTRIES_8B>>3)

#define LED               (*((volatile unsigned int *) (0xC0000000)))

#define DEBUG             (*((volatile unsigned int *) (0xD0000000)))
#define DEBUG_ENTRIES_8B  0x3FFF
#define DEBUG_ENTRIES_16B (DEBUG_ENTRIES_8B>>1)
#define DEBUG_ENTRIES_32B (DEBUG_ENTRIES_8B>>2)
#define DEBUG_ENTRIES_64B (DEBUG_ENTRIES_8B>>3)

#endif
