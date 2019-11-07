#include <stdio.h>

#include "sdcard.h"
#include "display.h"

#define SDCARD_NOOP        (*((volatile uint32_t *) (0xC4000000)))
#define SDCARD_CMD_SEND    (*((volatile uint32_t *) (0xC4000004)))
#define SDCARD_CMD_LO      (*((volatile uint32_t *) (0xC4000008)))
#define SDCARD_CMD_HI      (*((volatile uint32_t *) (0xC400000C)))
#define SDCARD_RSP_ARRIVED (*((volatile uint32_t *) (0xC4000010)))
#define SDCARD_RSP_LO      (*((volatile uint32_t *) (0xC4000014)))
#define SDCARD_RSP_HI      (*((volatile uint32_t *) (0xC4000018)))
#define SDCARD_DATA_IN     (*((volatile uint32_t *) (0xC400001C)))
#define SDCARD_DATA_OUT    (*((volatile uint32_t *) (0xC4000020)))

void sdcard_on(void) {

  uint64_t cmd;
  uint64_t rsp;
  char * cmd_string;
  char * rsp_string;

  cmd = 0x400000000095;
  cmd_string = uint64_to_hex(cmd);
  console_put_char('\n');
  for(int i = 0; i < 12; i++) {
    console_put_char(cmd_string[11-i]);
  }
  rsp = sdcard_cmd(cmd);
  rsp_string = uint64_to_hex(rsp);
  console_put_char('\n');
  console_put_char('-');
  for(int i = 0; i < 12; i++) {
    console_put_char(rsp_string[11-i]);
  }

  cmd = 0x48000001AA87;
  cmd_string = uint64_to_hex(cmd);
  console_put_char('\n');
  for(int i = 0; i < 12; i++) {
    console_put_char(cmd_string[11-i]);
  }
  rsp = sdcard_cmd(cmd);
  rsp_string = uint64_to_hex(rsp);
  console_put_char('\n');
  console_put_char('-');
  for(int i = 0; i < 12; i++) {
    console_put_char(rsp_string[11-i]);
  }

  return;
}

uint64_t sdcard_cmd(uint64_t cmd) {

  uint64_t rsp = 0;
  // uint64_t cmd_reversed = 0;
  // for(uint8_t i=0;i<48;i++) {
  //    cmd_reversed |= ((cmd>>i) & 1)<<(47-i);
  // }
  // //cmd_reversed = cmd_reversed >> 16;

  // for(uint8_t i = 0; i < 6; i++) {
  //   SDCARD_CMD = (cmd_reversed >> (i*8)) & 0xFF;
  // }

  //for(int i = 5; i >= 0; i--) {
  //  SDCARD_CMD = (cmd >> (i*8)) & 0xFF;
  //}
  //SDCARD_CMD = 0;
  //SDCARD_CMD = 0;

  SDCARD_CMD_LO   = cmd & 0xFFFFFFFF;
  SDCARD_CMD_HI   = (cmd >> 32) & 0xFFFF;
  SDCARD_CMD_SEND = 1;

  while(SDCARD_RSP_ARRIVED == 0) {};
  
  rsp = SDCARD_RSP_HI;
  rsp = rsp << 32;
  rsp = rsp | SDCARD_RSP_LO;

  return rsp;
}
