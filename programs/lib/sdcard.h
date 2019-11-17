#ifndef	_SDCARD_H_
#define _SDCARD_H_

#include <stdio.h>

extern void     sdcard_on(void);
extern uint64_t sdcard_cmd(uint64_t cmd, unsigned int bytes);
       void     sdcard_rsp(uint8_t * arr, unsigned int bytes, uint64_t rsp);

#endif

