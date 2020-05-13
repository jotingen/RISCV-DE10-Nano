#ifndef	_LED_H_
#define _LED_H_

#include <stdio.h>

#include "../include/riscv.h"

extern void LED_set(uint8_t val);
extern uint8_t LED_get(void);

#endif

