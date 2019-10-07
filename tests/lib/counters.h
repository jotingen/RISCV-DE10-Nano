#ifndef	_COUNTERS_H_
#define _COUNTERS_H_

#include <stdio.h>

       uint32_t get_csr_cycle();
       uint32_t get_csr_cycleh();
extern uint64_t get_time();
extern void     clear_time();

#endif
