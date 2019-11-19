#ifndef	_SDCARD_H_
#define _SDCARD_H_

#include <stdio.h>

extern void     sdcard_on(void);
extern uint64_t sdcard_cmd(uint64_t cmd, uint8_t bytes, uint8_t data);
       void     sdcard_rsp(uint8_t * arr, uint8_t bytes, uint64_t rsp);
extern void     sdcard_read(uint8_t * data, uint32_t addr);

#endif

