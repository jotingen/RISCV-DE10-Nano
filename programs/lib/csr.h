#ifndef	_COUNTERS_H_
#define _COUNTERS_H_

#include <stdio.h>

#define CSR_MSTATUS_SD   0x80000000
#define CSR_MSTATUS_TSR  0x00800000
#define CSR_MSTATUS_TW   0x00400000
#define CSR_MSTATUS_TVM  0x00200000
#define CSR_MSTATUS_MXR  0x00100000
#define CSR_MSTATUS_SUM  0x00080000
#define CSR_MSTATUS_MPRV 0x00040000
#define CSR_MSTATUS_XS   0x00030000
#define CSR_MSTATUS_FS   0x0000C000
#define CSR_MSTATUS_MPP  0x00003000
#define CSR_MSTATUS_SPP  0x00000200
#define CSR_MSTATUS_MPIE 0x00000100
#define CSR_MSTATUS_SPIE 0x00000020
#define CSR_MSTATUS_UPIE 0x00000010
#define CSR_MSTATUS_MIE  0x00000008
#define CSR_MSTATUS_SIE  0x00000002
#define CSR_MSTATUS_UIE  0x00000001

#define CSR_MIE_MEIE     0x00000800
#define CSR_MIE_SEIE     0x00000200
#define CSR_MIE_UEIE     0x00000100
#define CSR_MIE_MTIE     0x00000080
#define CSR_MIE_STIE     0x00000020
#define CSR_MIE_UTIE     0x00000010
#define CSR_MIE_MSIE     0x00000008
#define CSR_MIE_SSIE     0x00000002
#define CSR_MIE_USIE     0x00000001
               
#define CSR_MTVEC_Base   0xFFFFFFFC
#define CSR_MTVEC_Mode   0x00000003

#define CSR_MIP_MEIP     0x00000800
#define CSR_MIP_SEIP     0x00000200
#define CSR_MIP_UEIP     0x00000100
#define CSR_MIP_MTIP     0x00000080
#define CSR_MIP_STIP     0x00000020
#define CSR_MIP_UTIP     0x00000010
#define CSR_MIP_MSIP     0x00000008
#define CSR_MIP_SSIP     0x00000002
#define CSR_MIP_USIP     0x00000001

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

       uint32_t get_csr_mstatus();
extern uint32_t get_mstatus();
       uint32_t clr_csr_mstatus(uint32_t);
extern uint32_t clr_mstatus(uint32_t);
       uint32_t set_csr_mstatus(uint32_t);
extern uint32_t set_mstatus(uint32_t);

       uint32_t get_csr_mie();
extern uint32_t get_mie();
       uint32_t clr_csr_mie(uint32_t);
extern uint32_t clr_mie(uint32_t);
       uint32_t set_csr_mie(uint32_t);
extern uint32_t set_mie(uint32_t);

       uint32_t get_csr_mtvec();
extern uint32_t get_mtvec();
       uint32_t clr_csr_mtvec(uint32_t);
extern uint32_t clr_mtvec(uint32_t);
       uint32_t set_csr_mtvec(uint32_t);
extern uint32_t set_mtvec(uint32_t);

       uint32_t get_csr_mip();
extern uint32_t get_mip();
       uint32_t clr_csr_mip(uint32_t);
extern uint32_t clr_mip(uint32_t);
       uint32_t set_csr_mip(uint32_t);
extern uint32_t set_mip(uint32_t);


#endif
