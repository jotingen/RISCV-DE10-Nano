//CRC generation code improted from: https://github.com/hazelnusse/crc7/blob/master/crc7.cc
#include <stdio.h>

#include "csr.h"
#include "sdcard.h"
#include "display.h"

#define LED             (*((volatile unsigned int *) (0xC0000000)))

#define SDCARD_NOOP        (*((volatile uint32_t *) (0xC4000000)))
#define SDCARD_CMD_SEND    (*((volatile uint32_t *) (0xC4000004)))
#define SDCARD_CMD_LO      (*((volatile uint32_t *) (0xC4000008)))
#define SDCARD_CMD_HI      (*((volatile uint32_t *) (0xC400000C)))
#define SDCARD_RSP_ARRIVED (*((volatile uint32_t *) (0xC4000010)))
#define SDCARD_RSP_LO      (*((volatile uint32_t *) (0xC4000014)))
#define SDCARD_RSP_HI      (*((volatile uint32_t *) (0xC4000018)))

uint8_t CRCCheckEnable = 1;
uint8_t CRCTableGenerated = 0;
uint8_t CRCTable[256];

void sdcard_crc_check_on(void){
	CRCCheckEnable = 1;
}

void sdcard_crc_check_off(void){
	CRCCheckEnable = 0;
}

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
        CRCTableGenerated = 1;
}

// adds a message byte to the current CRC-7 to get a the new CRC-7
uint8_t CRCAdd(uint8_t CRC, uint8_t message_byte) {
	if(!CRCTableGenerated) {
		generateCRCTable();
	}
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
  msg = msg | (((uint64_t)op << 20) << 20);

  //Add args
  msg = msg | ((uint64_t)args << 8);

  //Add CRC
  if(CRCCheckEnable) {
    msg = msg | (getCRC(msg>>8,6) << 1);
  }

  return msg;
}

void printSDMsg(uint64_t message) {
  char *s;
  s = uint64_to_hex(message);
  for(int i = 4; i < 20; i++) {
    console_putc(s[i]);
  }
}

void printSDResult(uint64_t result, unsigned int bytes) {
  char *s;
  s = uint64_to_hex(result);
  for(int i = 0; i < bytes*2; i++) {
    console_putc(s[bytes*2-i]);
  }
}

#define PARAM_ERROR(X)      X & 0b01000000
#define ADDR_ERROR(X)       X & 0b00100000
#define ERASE_SEQ_ERROR(X)  X & 0b00010000
#define CRC_ERROR(X)        X & 0b00001000
#define ILLEGAL_CMD(X)      X & 0b00000100
#define ERASE_RESET(X)      X & 0b00000010
#define IN_IDLE(X)          X & 0b00000001

void SD_printR1(uint8_t res)
{
    if(res & 0b10000000)
        { console_puts("  Error: MSB = 1\n"); return; }
    if(res == 0)
        { console_puts("  Card Ready\n"); return; }
    if(PARAM_ERROR(res))
        console_puts("  Parameter Error\n");
    if(ADDR_ERROR(res))
        console_puts("  Address Error\n");
    if(ERASE_SEQ_ERROR(res))
        console_puts("  Erase Sequence Error\n");
    if(CRC_ERROR(res))
        console_puts("  CRC Error\n");
    if(ILLEGAL_CMD(res))
        console_puts("  Illegal Command\n");
    if(ERASE_RESET(res))
        console_puts("  Erase Reset Error\n");
    if(IN_IDLE(res))
        console_puts("  In Idle State\n");
}

#define POWER_UP_STATUS(X)  X & 0x40
#define CCS_VAL(X)          X & 0x40
#define VDD_2728(X)         X & 0b10000000
#define VDD_2829(X)         X & 0b00000001
#define VDD_2930(X)         X & 0b00000010
#define VDD_3031(X)         X & 0b00000100
#define VDD_3132(X)         X & 0b00001000
#define VDD_3233(X)         X & 0b00010000
#define VDD_3334(X)         X & 0b00100000
#define VDD_3435(X)         X & 0b01000000
#define VDD_3536(X)         X & 0b10000000

void SD_printR3(uint8_t *res)
{
    SD_printR1(res[0]);

    if(res[0] > 1) return;

    console_puts("  Card Power Up Status: ");
    if(POWER_UP_STATUS(res[1]))
    {
        console_puts("READY\n");
        console_puts("  CCS Status: ");
        if(CCS_VAL(res[1])){ console_puts("1\n"); }
        else console_puts("0\n");
    }
    else
    {
        console_puts("BUSY\n");
    }

    console_puts("  VDD Window: ");
    if(VDD_2728(res[3])) console_puts("2.7-2.8, ");
    if(VDD_2829(res[2])) console_puts("2.8-2.9, ");
    if(VDD_2930(res[2])) console_puts("2.9-3.0, ");
    if(VDD_3031(res[2])) console_puts("3.0-3.1, ");
    if(VDD_3132(res[2])) console_puts("3.1-3.2, ");
    if(VDD_3233(res[2])) console_puts("3.2-3.3, ");
    if(VDD_3334(res[2])) console_puts("3.3-3.4, ");
    if(VDD_3435(res[2])) console_puts("3.4-3.5, ");
    if(VDD_3536(res[2])) console_puts("3.5-3.6");
    console_puts("\n");
}

#define CMD_VER(X)          ((X >> 4) & 0xF0)
#define VOL_ACC(X)          (X & 0x1F)

#define VOLTAGE_ACC_27_33   0b00000001
#define VOLTAGE_ACC_LOW     0b00000010
#define VOLTAGE_ACC_RES1    0b00000100
#define VOLTAGE_ACC_RES2    0b00001000

void SD_printR7(uint8_t *res)
{
    SD_printR1(res[0]);

    if(res[0] > 1) return;

    console_puts("  Command Version: ");
    console_puthex8(CMD_VER(res[1]));
    console_puts("\n");

    console_puts("  Voltage Accepted: ");
    if(VOL_ACC(res[3]) == VOLTAGE_ACC_27_33)
        console_puts("2.7-3.6V\n");
    else if(VOL_ACC(res[3]) == VOLTAGE_ACC_LOW)
        console_puts("LOW VOLTAGE\n");
    else if(VOL_ACC(res[3]) == VOLTAGE_ACC_RES1)
        console_puts("RESERVED\n");
    else if(VOL_ACC(res[3]) == VOLTAGE_ACC_RES2)
        console_puts("RESERVED\n");
    else
        console_puts("NOT DEFINED\n");

    console_puts("  Echo: ");
    console_puthex8(res[4]);
    console_puts("\n");
}

void sdcard_on(void) {

  uint64_t message;
  uint64_t rsp;
  uint8_t  rsp_arr[5];
  uint32_t cnt = 0;

  if(CRCCheckEnable) {
    generateCRCTable();
  }


  //CMD0

  message = genSDCardMsg(0,0x00000000);

  //console_puts("  MSG:");
  //printSDMsg(message);
  //console_putc('\n');
  //display_write();

  rsp = sdcard_cmd(message,1,0);
  sdcard_rsp(rsp_arr, 1, rsp);

  //console_puts("  RSP:");
  //printSDResult(rsp,1);
  //console_putc('\n');
  //display_write();

  //SD_printR1(rsp_arr[0]);

  //display_write();


  //CMD8

  message = genSDCardMsg(8,0x000001AA);

  //console_puts("  MSG:");
  //printSDMsg(message);
  //console_putc('\n');

  rsp = sdcard_cmd(message,5,0);
  sdcard_rsp(rsp_arr, 5, rsp);

  //console_puts("  RSP:");
  //printSDResult(rsp,5);
  //console_putc('\n');

  //SD_printR7(rsp_arr);

  //display_write();


  //CMD58

  message = genSDCardMsg(58,0x00000000);

  //console_puts("  MSG:");
  //printSDMsg(message);
  //console_putc('\n');

  rsp = sdcard_cmd(message,5,0);
  sdcard_rsp(rsp_arr, 5, rsp);

  //console_puts("  RSP:");
  //printSDResult(rsp,5);
  //console_putc('\n');

  //SD_printR3(rsp_arr);

  //display_write();


  //CMD ACDM41
  do {
    uint64_t timestamp;

    message = genSDCardMsg(55,0x00000000);
  
    //console_puts("  MSG:");
    //printSDMsg(message);
    //console_putc('\n');

    rsp = sdcard_cmd(message,1,0);
    sdcard_rsp(rsp_arr, 1, rsp);

    //console_puts("  RSP:");
    //printSDResult(rsp,1);
    //console_putc('\n');

    //SD_printR1(rsp_arr[0]);



    message = genSDCardMsg(41,0x00000000);
  
    //console_puts("  MSG:");
    //printSDMsg(message);
    //console_putc('\n');

    rsp = sdcard_cmd(message,1,0);
    sdcard_rsp(rsp_arr, 1, rsp);

    //console_puts("  RSP:");
    //printSDResult(rsp,1);
    //console_putc('\n');

    //SD_printR1(rsp_arr[0]);

    //console_puts(uint32_to_hex(cnt));
    //console_putc('\n');

    //display_write();

    timestamp = get_time();
    while(get_time()-timestamp < 1); //TODO was 10
    cnt++;

  } while (rsp_arr[0] != 0);

  //CMD58

  message = genSDCardMsg(58,0x00000000);

  //console_puts("  MSG:");
  //printSDMsg(message);
  //console_putc('\n');

  rsp = sdcard_cmd(message,5,0);
  sdcard_rsp(rsp_arr, 5, rsp);

  //console_puts("  RSP:");
  //printSDResult(rsp,5);
  //console_putc('\n');

  //SD_printR3(rsp_arr);

  //display_write();
  //console_puts("Ready...");
  //display_write;

  return;
}

void sdcard_rsp(uint8_t * arr, uint8_t bytes, uint64_t rsp) {
    for(int i = 0; i < bytes; i++) {
      arr[i] = (rsp >> ((bytes-1-i)*8)) & 0xFF;
    }
    return;
}
void     sdcard_read(uint32_t addr) {
  //LED = 0x11;
  uint64_t message;
  uint64_t rsp;
  uint8_t  rsp_arr[5];

  message = genSDCardMsg(17,addr);

  //console_puts("  MSG:");
  //printSDMsg(message);
  //console_putc('\n');
  //display_write();

  rsp = sdcard_cmd(message,1,1);
  sdcard_rsp(rsp_arr, 1, rsp);

  //console_puts("  RSP:");
  //printSDResult(rsp,1);
  //console_putc('\n');
  //display_write();

  //console_puts("  ");
  //SD_printR1(rsp_arr[0]);

  //console_putc('\n');
  //console_puts("Read data captured\n");
  //display_write();
  //LED = 0x22;
  return;
}

uint64_t sdcard_cmd(uint64_t cmd, uint8_t bytes, uint8_t data) {

  uint64_t rsp = 0;

  SDCARD_CMD_LO   = cmd;
  
  SDCARD_CMD_HI   = cmd >> 32;

  SDCARD_CMD_HI  |= (uint32_t)bytes << 24;

  SDCARD_CMD_HI  |= (uint32_t)data << 31;

  //console_puts(uint64_to_hex(SDCARD_CMD_LO));
  //console_putc('\n');

  //console_puts(uint64_to_hex(SDCARD_CMD_HI));
  //console_putc('\n');

  SDCARD_CMD_SEND = 1;

  while(SDCARD_RSP_ARRIVED == 0) {};
  
  rsp = SDCARD_RSP_HI;
  rsp = rsp << 32;
  rsp = rsp | SDCARD_RSP_LO;

  return rsp;
}
