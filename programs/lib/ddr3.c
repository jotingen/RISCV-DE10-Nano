#include <stdio.h>

#include "ddr3.h"

void DDR3_flush() {
  DDR3CNTL_FLUSH = 1;
}

