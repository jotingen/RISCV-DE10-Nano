#include <stdio.h>

#include "debug.h"

static volatile uint8_t  * const debug_array_8  = (volatile uint8_t *)&DEBUG;
static volatile uint16_t * const debug_array_16 = (volatile uint16_t*)&DEBUG;
static volatile uint32_t * const debug_array_32 = (volatile uint32_t*)&DEBUG;
static volatile uint64_t * const debug_array_64 = (volatile uint64_t*)&DEBUG;

void DEBUG_set8 (uint16_t addr, uint8_t  val) {
  if(addr < DEBUG_ENTRIES_8B) {
    debug_array_8[addr] = val;
  }
}

void DEBUG_set16(uint16_t addr, uint16_t val) {
  if(addr < DEBUG_ENTRIES_8B >> 1) {
    debug_array_16[addr] = val;
  }
}

void DEBUG_set32(uint16_t addr, uint32_t val) {
  if(addr < DEBUG_ENTRIES_8B >> 2) {
    debug_array_32[addr] = val;
  }
}

void DEBUG_set64(uint16_t addr, uint64_t val) {
  if(addr < DEBUG_ENTRIES_8B >> 3) {
    debug_array_64[addr] = val;
  }
}


uint8_t  DEBUG_get8 (uint16_t addr) {
  if(addr < DEBUG_ENTRIES_8B) {
    return debug_array_8[addr];
  }
  return 0;
}

uint16_t DEBUG_get16(uint16_t addr) {
  if(addr < DEBUG_ENTRIES_16B) {
    return debug_array_16[addr];
  }
  return 0;
}

uint32_t DEBUG_get32(uint16_t addr) {
  if(addr < DEBUG_ENTRIES_32B) {
    return debug_array_32[addr];
  }
  return 0;
}

uint64_t DEBUG_get64(uint16_t addr) {
  if(addr < DEBUG_ENTRIES_64B) {
    return debug_array_64[addr];
  }
  return 0;
}

