#ifndef	_COUNTERS_H_
#define _COUNTERS_H_

#include <stdio.h>

       uint32_t get_csr_time();
       uint32_t get_csr_timeh();
extern uint64_t get_time();
extern void     reset_time();

       uint32_t get_csr_cycle();
       uint32_t get_csr_cycleh();
extern uint64_t get_cycle();
extern void     reset_cycle();

       uint32_t get_csr_instret();
       uint32_t get_csr_instreth();
extern uint64_t get_instret();
extern void     reset_instret();

#endif
