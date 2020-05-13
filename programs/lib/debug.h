#ifndef	_DEBUG_H_
#define _DEBUG_H_

#include <stdio.h>

#include "../include/riscv.h"

extern void DEBUG_set8 (uint16_t addr, uint8_t  val);
extern void DEBUG_set16(uint16_t addr, uint16_t val);
extern void DEBUG_set32(uint16_t addr, uint32_t val);
extern void DEBUG_set64(uint16_t addr, uint64_t val);

extern uint8_t  DEBUG_get8 (uint16_t addr);
extern uint16_t DEBUG_get16(uint16_t addr);
extern uint32_t DEBUG_get32(uint16_t addr);
extern uint64_t DEBUG_get64(uint16_t addr);

#endif

