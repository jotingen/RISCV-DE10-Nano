#include <stdint.h>
#include <stdio.h>

#include "../lib/csr.h"
#include "../lib/display.h"
#include "../lib/rand.h"
#include "../lib/sdcard.h"

#define LED             (*((volatile unsigned int *) (0xC0000000)))

#define BUTTON_0        (*((volatile unsigned int *) (0xC1000000)))
#define BUTTON_1        (*((volatile unsigned int *) (0xC1000004)))

#define JOYSTICK_UP     (*((volatile unsigned int *) (0xC1000100)))
#define JOYSTICK_RIGHT  (*((volatile unsigned int *) (0xC1000104)))
#define JOYSTICK_SELECT (*((volatile unsigned int *) (0xC1000108)))
#define JOYSTICK_DOWN   (*((volatile unsigned int *) (0xC100010C)))
#define JOYSTICK_LEFT   (*((volatile unsigned int *) (0xC1000110)))

struct __attribute__((__packed__)) partition_entry_t {
  uint8_t status                   [1];
  uint8_t chs_address_first        [3];
  uint8_t partition_type           [1];
  uint8_t chs_address_last         [3];
  uint8_t lba_first_sector         [4];
  uint8_t sectors_in_partition     [4];
};
typedef struct partition_entry_t partition_entry_t;

struct __attribute__((__packed__)) master_boot_record_t {
  uint8_t boot_code                [446];
  partition_entry_t partition      [4];
  uint8_t boot_sector              [2];
};
typedef struct master_boot_record_t master_boot_record_t;

struct __attribute__((__packed__)) boot_sector_t {
  uint8_t jump_instr               [3];
  uint8_t oem_name                 [8];
  uint8_t sector_size              [2];
  uint8_t secter_per_cluster       [1];
  uint8_t reserved_sectors         [2];
  uint8_t number_of_FATs           [1];
  uint8_t number_of_directories    [2];
  uint8_t number_of_sectors_lt32   [2];
  uint8_t media_descriptor         [1];
  uint8_t sectors_per_FAT_table    [2];
  uint8_t sectors_per_track        [2];
  uint8_t number_of_heads          [2];
  uint8_t number_of_hidden_sectors [4];
  uint8_t number_of_sectors_gt32   [4];
  uint8_t drive_number             [1];
  uint8_t current_head             [1];
  uint8_t boot_signature           [1];
  uint8_t volume_id                [4];
  uint8_t volume_label             [11];
  uint8_t file_system_type         [8];
  uint8_t boot_code                [448];
  uint8_t boot_sector              [2];
};
typedef struct boot_sector_t boot_sector_t;

// Function to reverse elements of an array
void reverse(uint8_t arr[], int n) {
	for (int low = 0, high = n - 1; low < high; low++, high--)
	{
		uint8_t temp = arr[low];
		arr[low]     = arr[high];
		arr[high]    = temp;
	}
}

void printBytes(uint8_t byte[], int n) {
    for(int i = n-1; i >= 0; i--) {console_puts(uint8_to_hex(byte[i]));}
    //for(int i = 0; i < n; i++) {console_puts(uint8_to_hex(byte[i]));}
}

void main(void) {
  master_boot_record_t * master_boot_record;
  uint32_t boot_sector_address;
  uint32_t fat_sector_address;
  boot_sector_t * boot_sector;

  //Only use UART, no console buffer
  console_disable();

  //Set UART crazy fast for sims
  //set_uart_baud(921600);
  LED = 0xEE;
  set_uart_baud(9216000);

  LED = 0xFF;
  console_puts("Booting DE10Nano RISCV Bootloader...\n\n");
  LED = 0x0;

  console_puts("Initiating SDCard...");
  sdcard_on();
  console_puts("done\n");

  console_puts("Initiating Random Number Generator...");
  rand_init();
  console_puts("done\n");

  console_puts("SDCard Master Boot Record Parse Test\n");
  sdcard_read(512*0);
  //sdcard_read(sdcard_data,512*0);

  master_boot_record = (master_boot_record_t*)SDCARD_DATA;

  console_puts("boot code                : ");
  printBytes(master_boot_record->boot_code,446);
  console_putc('\n');

  for(int p = 0; p < 4; p++) {
    console_puts("partition[");
    console_puts(uint8_to_hex(p));
    console_puts("]                      : ");
    printBytes((uint8_t*)&master_boot_record->partition[p],16);
    console_putc('\n');
  }

  console_puts("boot sector              : ");
  printBytes(master_boot_record->boot_sector,2);
  console_putc('\n');

  console_puts("Valid Partition Info:\n");
  for(int p = 0; p < 4; p++) {
    if(master_boot_record->partition[p].partition_type[0]) {
      console_puts("partition[");
      console_puts(uint8_to_hex(p));
      console_puts("].status               : ");
      printBytes(master_boot_record->partition[p].status,1);
      console_putc('\n');

      console_puts("partition[");
      console_puts(uint8_to_hex(p));
      console_puts("].chs_address_first    : ");
      printBytes(master_boot_record->partition[p].chs_address_first,2);
      console_putc('\n');

      console_puts("partition[");
      console_puts(uint8_to_hex(p));
      console_puts("].partition_type       : ");
      printBytes(master_boot_record->partition[p].partition_type,1);
      console_putc('\n');

      console_puts("partition[");
      console_puts(uint8_to_hex(p));
      console_puts("].chs_address_last     : ");
      printBytes(master_boot_record->partition[p].chs_address_last,3);
      console_putc('\n');

      console_puts("partition[");
      console_puts(uint8_to_hex(p));
      console_puts("].lba_first_sector     : ");
      printBytes(master_boot_record->partition[p].lba_first_sector,4);
      console_putc('\n');

      console_puts("partition[");
      console_puts(uint8_to_hex(p));
      console_puts("].sectors_in_partition : ");
      printBytes(master_boot_record->partition[p].sectors_in_partition,4);
      console_putc('\n');
    }
  }


  for(int p = 0; p < 4; p++) {
    if(master_boot_record->partition[p].partition_type[0]) {
      console_puts("SDCard Partition ");
      console_puts(uint8_to_hex(p));
      console_puts(" BootSector Parse Test\n");

      boot_sector_address = 0;
      for(int i = 3; i >= 0 ; i--) {
        boot_sector_address = (boot_sector_address << 8) | master_boot_record->partition[p].lba_first_sector[i];
      }
      boot_sector_address *= 512;
      console_puts("Loading Sector ");
      console_puts(uint32_to_hex(boot_sector_address));
      console_putc('\n');
  
      sdcard_read(boot_sector_address);
      boot_sector = (boot_sector_t*)SDCARD_DATA;

      console_puts("jump_instr               : ");
      printBytes(boot_sector->jump_instr,3);
      console_putc('\n');

      console_puts("oem_name                 : ");
      printBytes(boot_sector->oem_name,8);
      console_putc('\n');

      console_puts("sector_size              : ");
      printBytes(boot_sector->sector_size,2);
      console_putc('\n');

      console_puts("secter_per_cluster       : ");
      printBytes(boot_sector->secter_per_cluster,1);
      console_putc('\n');

      console_puts("reserved_sectors         : ");
      printBytes(boot_sector->reserved_sectors,2);
      console_putc('\n');

      console_puts("number_of_FATs           : ");
      printBytes(boot_sector->number_of_FATs,1);
      console_putc('\n');

      console_puts("number_of_directories    : ");
      printBytes(boot_sector->number_of_directories,2);
      console_putc('\n');

      console_puts("number_of_sectors_lt32   : ");
      printBytes(boot_sector->number_of_sectors_lt32,2);
      console_putc('\n');

      console_puts("media_descriptor         : ");
      printBytes(boot_sector->media_descriptor,1);
      console_putc('\n');

      console_puts("sectors_per_FAT_table    : ");
      printBytes(boot_sector->sectors_per_FAT_table,2);
      console_putc('\n');

      console_puts("sectors_per_track        : ");
      printBytes(boot_sector->sectors_per_track,2);
      console_putc('\n');

      console_puts("number_of_heads          : ");
      printBytes(boot_sector->number_of_heads,2);
      console_putc('\n');

      console_puts("number_of_hidden_sectors : ");
      printBytes(boot_sector->number_of_hidden_sectors,4);
      console_putc('\n');

      console_puts("number_of_sectors_gt32   : ");
      printBytes(boot_sector->number_of_sectors_gt32,4);
      console_putc('\n');

      console_puts("drive_number             : ");
      printBytes(boot_sector->drive_number,1);
      console_putc('\n');

      console_puts("current_head             : ");
      printBytes(boot_sector->current_head,1);
      console_putc('\n');

      console_puts("boot_signature           : ");
      printBytes(boot_sector->boot_signature,1);
      console_putc('\n');

      console_puts("volume_id                : ");
      printBytes(boot_sector->volume_id,4);
      console_putc('\n');

      console_puts("volume_label             : ");
      printBytes(boot_sector->volume_label,11);
      console_putc('\n');

      console_puts("file_system_type         : ");
      printBytes(boot_sector->file_system_type,8);
      console_putc('\n');

      console_puts("boot_code                : ");
      printBytes(boot_sector->boot_code,448);
      console_putc('\n');

      console_puts("boot_sector              : ");
      printBytes(boot_sector->boot_sector,2);
      console_putc('\n');


      console_puts("SDCard Partition ");
      console_puts(uint8_to_hex(p));
      console_puts(" FAT Parse Test\n");

      fat_sector_address = 0;
      for(int i = 3; i >= 0 ; i--) {
        fat_sector_address = (fat_sector_address << 8) | boot_sector->number_of_hidden_sectors[i];
      }
      fat_sector_address *= 512;
      fat_sector_address += boot_sector_address;

      console_puts("Loading Sector ");
      console_puts(uint32_to_hex(fat_sector_address));
      console_putc('\n');

      sdcard_read(fat_sector_address);
      printBytes(SDCARD_DATA,514);
      console_puts("\ndone\n");

    }
  }


  while(1);
}


