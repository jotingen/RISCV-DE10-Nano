#ifndef	_SDCARD_H_
#define _SDCARD_H_

#include <stdio.h>

static volatile uint32_t * const SDCARD_DATA = (volatile uint32_t *) 0xC4000200;

extern void     sdcard_crc_check_on(void);
extern void     sdcard_crc_check_off(void);
extern void     sdcard_on(void);
extern uint64_t sdcard_cmd(uint64_t cmd, uint8_t bytes, uint8_t data);
       void     sdcard_rsp(uint8_t * arr, uint8_t bytes, uint64_t rsp);
extern void     sdcard_read(uint8_t * data, uint32_t addr);
extern void     sdcard_read2(uint32_t addr);

#endif

