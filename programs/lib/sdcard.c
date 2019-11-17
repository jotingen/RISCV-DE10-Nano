//CRC generation code improted from: https://github.com/hazelnusse/crc7/blob/master/crc7.cc
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

uint8_t CRCTable[256];

void generateCRCTable(void) {
	int i, j;
	uint8_t CRCPoly = 0x89;  // the value of our CRC-7 polynomial

	// generate a table value for all 256 possible byte values
	for (i = 0; i < 256; ++i) {
		CRCTable[i] = (i & 0x80) ? i ^ CRCPoly : i;
		for (j = 1; j < 8; ++j) {
			CRCTable[i] <<= 1;
			if (CRCTable[i] & 0x80)
				CRCTable[i] ^= CRCPoly;
		}
	}
}

// adds a message byte to the current CRC-7 to get a the new CRC-7
uint8_t CRCAdd(uint8_t CRC, uint8_t message_byte) {
				return CRCTable[(CRC << 1) ^ message_byte];
}

uint8_t getCRC(uint64_t message, unsigned int bytes) {
				int i;
				uint8_t CRC = 0;

				for (i = 0; i < bytes; ++i) {
								CRC = CRCAdd(CRC, (message >> ((bytes-1-i)*8)) & 0xFF);
				}

				return CRC;
}

uint64_t genSDCardMsg(uint8_t op, uint32_t args) {
  uint64_t msg = 0x400000000001;

  //Add operand
  msg = msg | ((uint64_t)op << 40);

  //Add args
  msg = msg | ((uint64_t)args << 8);

  //Add CRC
  msg = msg | (getCRC(msg>>8,6) << 1);

  return msg;
}

void printSDMsg(uint64_t message) {
  char * message_string;
  message_string = uint64_to_hex(message);
  for(int i = 0; i < 12; i++) {
    console_put_char(message_string[11-i]);
  }
}

void printSDResult(uint64_t result, unsigned int bytes) {
  char * result_string;
  result_string = uint64_to_hex(result);
  for(int i = 0; i < bytes; i++) {
    console_put_char(result_string[bytes-1-i]);
  }
}

void sdcard_on(void) {

  uint64_t message;
  uint64_t rsp;

  generateCRCTable();


  //CMD0

  message = genSDCardMsg(0x00,0x00000000);

  printSDMsg(message);
  console_put_char('\n');

  rsp = sdcard_cmd(message);

  console_put_char('-');
  printSDResult(rsp,12);
  console_put_char('\n');

  display_write();


  //CMD8

//  cmd = 0x48000001AA87; //CMD8
  message = genSDCardMsg(0x08,0x000001AA);

  printSDMsg(message);
  console_put_char('\n');

  rsp = sdcard_cmd(message);

  console_put_char('-');
  printSDResult(rsp,12);
  console_put_char('\n');

  display_write();


  //cmd = 0x48000001AA87; //ACMD41
  //cmd_string = uint64_to_hex(cmd);
  //console_put_char('\n');
  //for(int i = 0; i < 12; i++) {
  //  console_put_char(cmd_string[11-i]);
  //}
  //rsp = sdcard_cmd(cmd);
  //rsp_string = uint64_to_hex(rsp);
  //console_put_char('\n');
  //console_put_char('-');
  //for(int i = 0; i < 12; i++) {
  //  console_put_char(rsp_string[11-i]);
  //}

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
