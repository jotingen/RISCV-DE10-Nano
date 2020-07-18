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

#define DDR3            (*((volatile unsigned int *) (0x10000000)))

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
  uint8_t checksum                 [2];
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
  uint8_t checksum                 [2];
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

void main(void) {

  static volatile uint32_t * const ddr3 = (volatile uint32_t *) 0x10000000;

  master_boot_record_t * master_boot_record;
  uint32_t boot_sector_address;
  uint32_t fat_sector_address;
  boot_sector_t * boot_sector;

  display_pixel_t pixel;
  uint16_t x_grid;
  uint16_t y_grid;

  //Set UART crazy fast for sims
  //set_uart_baud(921600);
  set_uart_baud(9216000);
  //set_uart_baud(921600);

  console_clear();
  display_on();
  //display_write();

  console_puts("Generating test image...\n");
  for(uint16_t y = 0; y < display_height(); y++) {
    for(uint16_t x = 0; x < display_width(); x++) {
      x_grid = x/30;
      y_grid = y/20;
      if(x == 0 || x == display_width()-1 ||
         y == 0 || y == display_height()-1) {
        dispbuff_write_pixel(y,x,PXL_SILVER);

      } else if(y_grid >=1  && y_grid <= 1 &&
                x_grid >=1  && x_grid <= 2) {
        dispbuff_write_pixel(y,x,PXL_RED);
      } else if(y_grid >=1  && y_grid <= 1 &&
                x_grid >=4  && x_grid <= 5) {
        dispbuff_write_pixel(y,x,PXL_LIME);
      } else if(y_grid >=1  && y_grid <= 1 &&
                x_grid >=7  && x_grid <= 8) {
        dispbuff_write_pixel(y,x,PXL_BLUE);
      } else if(y_grid >=1  && y_grid <= 1 &&
                x_grid >=11 && x_grid <= 14) {
        dispbuff_write_pixel(y,x,PXL_SILVER);

      } else if(y_grid >=4  && y_grid <= 6 &&
                x_grid >=1  && x_grid <= 3) {
        dispbuff_write_pixel(y,x,PXL_NAVY);
      } else if(y_grid >=4  && y_grid <= 6 &&
                x_grid >=4  && x_grid <= 6) {
        dispbuff_write_pixel(y,x,PXL_SILVER);
      } else if(y_grid >=4  && y_grid <= 6 &&
                x_grid >=7  && x_grid <= 9) {
        dispbuff_write_pixel(y,x,PXL_PURPLE);
      } else if(y_grid >=4  && y_grid <= 6 &&
                x_grid >=10 && x_grid <= 14) {
        dispbuff_write_pixel(y,x,PXL_GRAY);

      } else if(y_grid >=7  && y_grid <= 7 &&
                x_grid >=1  && x_grid <= 2) {
        dispbuff_write_pixel(y,x,PXL_BLUE);
      } else if(y_grid >=7  && y_grid <= 7 &&
                x_grid >=3  && x_grid <= 4) {
        dispbuff_write_pixel(y,x,PXL_BLACK);
      } else if(y_grid >=7  && y_grid <= 7 &&
                x_grid >=5  && x_grid <= 6) {
        dispbuff_write_pixel(y,x,PXL_MAGENTA);
      } else if(y_grid >=7  && y_grid <= 7 &&
                x_grid >=7  && x_grid <= 8) {
        dispbuff_write_pixel(y,x,PXL_BLACK);
      } else if(y_grid >=7  && y_grid <= 7 &&
                x_grid >=9  && x_grid <= 10) {
        dispbuff_write_pixel(y,x,PXL_CYAN);
      } else if(y_grid >=7  && y_grid <= 7 &&
                x_grid >=11 && x_grid <= 12) {
        dispbuff_write_pixel(y,x,PXL_BLACK);
      } else if(y_grid >=7  && y_grid <= 7 &&
                x_grid >=13 && x_grid <= 14) {
        dispbuff_write_pixel(y,x,PXL_SILVER);

      } else if(y_grid >=8  && y_grid <= 14 &&
                x_grid >=1  && x_grid <= 2) {
        dispbuff_write_pixel(y,x,PXL_SILVER);
      } else if(y_grid >=8  && y_grid <= 14 &&
                x_grid >=3  && x_grid <= 4) {
        dispbuff_write_pixel(y,x,PXL_YELLOW);
      } else if(y_grid >=8  && y_grid <= 14 &&
                x_grid >=5  && x_grid <= 6) {
        dispbuff_write_pixel(y,x,PXL_CYAN);
      } else if(y_grid >=8  && y_grid <= 14 &&
                x_grid >=7  && x_grid <= 8) {
        dispbuff_write_pixel(y,x,PXL_GREEN);
      } else if(y_grid >=8  && y_grid <= 14 &&
                x_grid >=9  && x_grid <= 10) {
        dispbuff_write_pixel(y,x,PXL_MAGENTA);
      } else if(y_grid >=8  && y_grid <= 14 &&
                x_grid >=11 && x_grid <= 12) {
        dispbuff_write_pixel(y,x,PXL_RED);
      } else if(y_grid >=8  && y_grid <= 14 &&
                x_grid >=13 && x_grid <= 14) {
        dispbuff_write_pixel(y,x,PXL_BLUE);

      } else {
        dispbuff_write_pixel(y,x,PXL_BLACK);
      }

    }
  }
  console_puts("Writing test image...\n");
  display_write();
  console_puts("Wrote test image...\n");

  console_puts("Booting DE10Nano RISCV Bootloader...\n\n");
  display_write();

  console_puts("Initiating SDCard...");
  display_write();
  sdcard_on();
  console_puts("done\n");
  display_write();

  console_puts("Initiating Random Number Generator...");
  display_write();
  rand_init();
  console_puts("done\n");
  display_write();

  console_puts("Testing SDCard read of Sector 0...");
  display_write();
  sdcard_read(512*0);
  for(int i = 0; i < 514; i++) {
    console_puts(uint8_to_hex(SDCARD_DATA_8B[i]));
  }
  console_puts("\ndone\n");
  display_write();

  console_puts("DDR3 Test");
  console_puts("Writing SDCard Sector 0 to DDR3...");
  for(int i = 0; i < 514; i++) {
    uint32_t word = 0;
    word = word | SDCARD_DATA_8B[i];
    ddr3[i] = word;
  }
  console_puts("done\n");
  console_puts("Reading SDCard Sector 0 from DDR3...\n");
  display_write();
  for(int i = 0; i < 514; i++) {
    console_puts(uint8_to_hex(ddr3[i] & 0xFF));
  }
  console_puts("\ndone\n");
  display_write();

  console_puts("SDCard Master Boot Record Parse Test\n");
  sdcard_read(512*0);

  master_boot_record = (master_boot_record_t*)SDCARD_DATA_8B;

  //Convert little endian to big endian
  for(int i = 0; i < 4; i++) {
  	reverse(master_boot_record->partition[i].status               ,1);
  	reverse(master_boot_record->partition[i].chs_address_first    ,3);
  	reverse(master_boot_record->partition[i].partition_type       ,1);
  	reverse(master_boot_record->partition[i].chs_address_last     ,3);
  	reverse(master_boot_record->partition[i].lba_first_sector     ,4);
  	reverse(master_boot_record->partition[i].sectors_in_partition ,4);
  }
  reverse(master_boot_record->boot_sector ,2);
  reverse(master_boot_record->checksum    ,2);


  console_puts("boot code                : ");
  for(int i = 0; i < 446; i++) {console_puts(uint8_to_hex(master_boot_record->boot_code[i]));}
  console_putc('\n');

  console_puts("partition[0].status               : ");
  for(int i = 0; i < 1; i++) {console_puts(uint8_to_hex(master_boot_record->partition[0].status[i]));}
  console_putc('\n');

  console_puts("partition[0].chs_address_first    : ");
  for(int i = 0; i < 3; i++) {console_puts(uint8_to_hex(master_boot_record->partition[0].chs_address_first[i]));}
  console_putc('\n');

  console_puts("partition[0].partition_type       : ");
  for(int i = 0; i < 1; i++) {console_puts(uint8_to_hex(master_boot_record->partition[0].partition_type[i]));}
  console_putc('\n');

  console_puts("partition[0].chs_address_last     : ");
  for(int i = 0; i < 3; i++) {console_puts(uint8_to_hex(master_boot_record->partition[0].chs_address_last[i]));}
  console_putc('\n');

  console_puts("partition[0].lba_first_sector     : ");
  for(int i = 0; i < 4; i++) {console_puts(uint8_to_hex(master_boot_record->partition[0].lba_first_sector[i]));}
  console_putc('\n');

  console_puts("partition[0].sectors_in_partition : ");
  for(int i = 0; i < 4; i++) {console_puts(uint8_to_hex(master_boot_record->partition[0].sectors_in_partition[i]));}
  console_putc('\n');

  console_puts("partition[1].status               : ");
  for(int i = 0; i < 1; i++) {console_puts(uint8_to_hex(master_boot_record->partition[1].status[i]));}
  console_putc('\n');

  console_puts("partition[1].chs_address_first    : ");
  for(int i = 0; i < 3; i++) {console_puts(uint8_to_hex(master_boot_record->partition[1].chs_address_first[i]));}
  console_putc('\n');

  console_puts("partition[1].partition_type       : ");
  for(int i = 0; i < 1; i++) {console_puts(uint8_to_hex(master_boot_record->partition[1].partition_type[i]));}
  console_putc('\n');

  console_puts("partition[1].chs_address_last     : ");
  for(int i = 0; i < 3; i++) {console_puts(uint8_to_hex(master_boot_record->partition[1].chs_address_last[i]));}
  console_putc('\n');

  console_puts("partition[1].lba_first_sector     : ");
  for(int i = 0; i < 4; i++) {console_puts(uint8_to_hex(master_boot_record->partition[1].lba_first_sector[i]));}
  console_putc('\n');

  console_puts("partition[1].sectors_in_partition : ");
  for(int i = 0; i < 4; i++) {console_puts(uint8_to_hex(master_boot_record->partition[1].sectors_in_partition[i]));}
  console_putc('\n');

  console_puts("partition[2].status               : ");
  for(int i = 0; i < 1; i++) {console_puts(uint8_to_hex(master_boot_record->partition[2].status[i]));}
  console_putc('\n');

  console_puts("partition[2].chs_address_first    : ");
  for(int i = 0; i < 3; i++) {console_puts(uint8_to_hex(master_boot_record->partition[2].chs_address_first[i]));}
  console_putc('\n');

  console_puts("partition[2].partition_type       : ");
  for(int i = 0; i < 1; i++) {console_puts(uint8_to_hex(master_boot_record->partition[2].partition_type[i]));}
  console_putc('\n');

  console_puts("partition[2].chs_address_last     : ");
  for(int i = 0; i < 3; i++) {console_puts(uint8_to_hex(master_boot_record->partition[2].chs_address_last[i]));}
  console_putc('\n');

  console_puts("partition[2].lba_first_sector     : ");
  for(int i = 0; i < 4; i++) {console_puts(uint8_to_hex(master_boot_record->partition[2].lba_first_sector[i]));}
  console_putc('\n');

  console_puts("partition[2].sectors_in_partition : ");
  for(int i = 0; i < 4; i++) {console_puts(uint8_to_hex(master_boot_record->partition[2].sectors_in_partition[i]));}
  console_putc('\n');

  console_puts("partition[3].status               : ");
  for(int i = 0; i < 1; i++) {console_puts(uint8_to_hex(master_boot_record->partition[3].status[i]));}
  console_putc('\n');

  console_puts("partition[3].chs_address_first    : ");
  for(int i = 0; i < 3; i++) {console_puts(uint8_to_hex(master_boot_record->partition[3].chs_address_first[i]));}
  console_putc('\n');

  console_puts("partition[3].partition_type       : ");
  for(int i = 0; i < 1; i++) {console_puts(uint8_to_hex(master_boot_record->partition[3].partition_type[i]));}
  console_putc('\n');

  console_puts("partition[3].chs_address_last     : ");
  for(int i = 0; i < 3; i++) {console_puts(uint8_to_hex(master_boot_record->partition[3].chs_address_last[i]));}
  console_putc('\n');

  console_puts("partition[3].lba_first_sector     : ");
  for(int i = 0; i < 4; i++) {console_puts(uint8_to_hex(master_boot_record->partition[3].lba_first_sector[i]));}
  console_putc('\n');

  console_puts("partition[3].sectors_in_partition : ");
  for(int i = 0; i < 4; i++) {console_puts(uint8_to_hex(master_boot_record->partition[3].sectors_in_partition[i]));}
  console_putc('\n');

  console_puts("boot sector              : ");
  for(int i = 0; i < 2; i++) {console_puts(uint8_to_hex(master_boot_record->boot_sector[i]));}
  console_putc('\n');

  console_puts("checksum                 : ");
  for(int i = 0; i < 2; i++) {console_puts(uint8_to_hex(master_boot_record->checksum[i]));}
  console_putc('\n');

  display_write();


  console_puts("SDCard Partition 0 BootSector Parse Test\n");

  boot_sector_address = 0;
  for(int i = 0; i < 4 ; i++) {
    boot_sector_address = (boot_sector_address << 8) | master_boot_record->partition[0].lba_first_sector[i];
  }
  boot_sector_address *= 512;
  console_puts(uint32_to_hex(boot_sector_address));
  console_putc('\n');
  
  sdcard_read(boot_sector_address);
  boot_sector = (boot_sector_t*)SDCARD_DATA_8B;
  //Convert little endian to big endian
  reverse(master_boot_record->boot_code   ,446);
  reverse(boot_sector->jump_instr               ,3);
  reverse(boot_sector->oem_name                 ,8);
  reverse(boot_sector->sector_size              ,2);
  reverse(boot_sector->secter_per_cluster       ,1);
  reverse(boot_sector->reserved_sectors         ,2);
  reverse(boot_sector->number_of_FATs           ,1);
  reverse(boot_sector->number_of_directories    ,2);
  reverse(boot_sector->number_of_sectors_lt32   ,2);
  reverse(boot_sector->media_descriptor         ,1);
  reverse(boot_sector->sectors_per_FAT_table    ,2);
  reverse(boot_sector->sectors_per_track        ,2);
  reverse(boot_sector->number_of_heads          ,2);
  reverse(boot_sector->number_of_hidden_sectors ,4);
  reverse(boot_sector->number_of_sectors_gt32   ,4);
  reverse(boot_sector->drive_number             ,1);
  reverse(boot_sector->current_head             ,1);
  reverse(boot_sector->boot_signature           ,1);
  reverse(boot_sector->volume_id                ,4);
  reverse(boot_sector->volume_label             ,11);
  reverse(boot_sector->file_system_type         ,8);
  reverse(boot_sector->boot_code                ,448);
  reverse(boot_sector->boot_sector              ,2);
  reverse(boot_sector->checksum                 ,2);

  console_puts("jump_instr               : ");
  for(int i = 0; i < 3; i++) {console_puts(uint8_to_hex(boot_sector->jump_instr[i]));}
  console_putc('\n');

  console_puts("oem_name                 : ");
  for(int i = 0; i < 8  ; i++) {console_puts(uint8_to_hex(boot_sector->oem_name                [i]));}
  console_putc('\n');

  console_puts("sector_size              : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->sector_size             [i]));}
  console_putc('\n');

  console_puts("secter_per_cluster       : ");
  for(int i = 0; i < 1  ; i++) {console_puts(uint8_to_hex(boot_sector->secter_per_cluster      [i]));}
  console_putc('\n');

  console_puts("reserved_sectors         : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->reserved_sectors        [i]));}
  console_putc('\n');

  console_puts("number_of_FATs           : ");
  for(int i = 0; i < 1  ; i++) {console_puts(uint8_to_hex(boot_sector->number_of_FATs          [i]));}
  console_putc('\n');

  console_puts("number_of_directories    : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->number_of_directories   [i]));}
  console_putc('\n');

  console_puts("number_of_sectors_lt32   : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->number_of_sectors_lt32  [i]));}
  console_putc('\n');

  console_puts("media_descriptor         : ");
  for(int i = 0; i < 1  ; i++) {console_puts(uint8_to_hex(boot_sector->media_descriptor        [i]));}
  console_putc('\n');

  console_puts("sectors_per_FAT_table    : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->sectors_per_FAT_table   [i]));}
  console_putc('\n');

  console_puts("sectors_per_track        : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->sectors_per_track       [i]));}
  console_putc('\n');

  console_puts("number_of_heads          : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->number_of_heads         [i]));}
  console_putc('\n');

  console_puts("number_of_hidden_sectors : ");
  for(int i = 0; i < 4  ; i++) {console_puts(uint8_to_hex(boot_sector->number_of_hidden_sectors[i]));}
  console_putc('\n');

  console_puts("number_of_sectors_gt32   : ");
  for(int i = 0; i < 4  ; i++) {console_puts(uint8_to_hex(boot_sector->number_of_sectors_gt32  [i]));}
  console_putc('\n');

  console_puts("drive_number             : ");
  for(int i = 0; i < 1  ; i++) {console_puts(uint8_to_hex(boot_sector->drive_number            [i]));}
  console_putc('\n');

  console_puts("current_head             : ");
  for(int i = 0; i < 1  ; i++) {console_puts(uint8_to_hex(boot_sector->current_head            [i]));}
  console_putc('\n');

  console_puts("boot_signature           : ");
  for(int i = 0; i < 1  ; i++) {console_puts(uint8_to_hex(boot_sector->boot_signature          [i]));}
  console_putc('\n');

  console_puts("volume_id                : ");
  for(int i = 0; i < 4  ; i++) {console_puts(uint8_to_hex(boot_sector->volume_id               [i]));}
  console_putc('\n');

  console_puts("volume_label             : ");
  for(int i = 0; i < 11 ; i++) {console_puts(uint8_to_hex(boot_sector->volume_label            [i]));}
  console_putc('\n');

  console_puts("file_system_type         : ");
  for(int i = 0; i < 8  ; i++) {console_puts(uint8_to_hex(boot_sector->file_system_type        [i]));}
  console_putc('\n');

  console_puts("boot_code                : ");
  for(int i = 0; i < 448; i++) {console_puts(uint8_to_hex(boot_sector->boot_code               [i]));}
  console_putc('\n');

  console_puts("boot_sector              : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->boot_sector             [i]));}
  console_putc('\n');

  console_puts("checksum                 : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->checksum                [i]));}
  console_putc('\n');

  display_write();


  console_puts("SDCard Partition 0 FAT Parse Test\n");

  fat_sector_address = 0;
  for(int i = 0; i < 4 ; i++) {
    fat_sector_address = (fat_sector_address << 8) | boot_sector->number_of_hidden_sectors[i];
  }
  fat_sector_address *= 512;
  fat_sector_address += boot_sector_address;

  console_puts(uint32_to_hex(fat_sector_address));
  console_putc('\n');

  sdcard_read(fat_sector_address);
  for(int i = 0; i < 514; i++) {
    console_puts(uint8_to_hex(SDCARD_DATA_8B[i]));
  }
  console_puts("\ndone\n");
  display_write();



  console_puts("SDCard Partition 1 BootSector Parse Test\n");

  boot_sector_address = 0;
  console_puts(uint32_to_hex(boot_sector_address));
  console_putc('\n');
  for(int i = 0; i < 4 ; i++) {
    boot_sector_address = (boot_sector_address << 8) | master_boot_record->partition[1].lba_first_sector[4-1-i];
    console_puts(uint32_to_hex(boot_sector_address));
    console_putc('\n');
  }
  boot_sector_address *= 512;
  console_puts(uint32_to_hex(boot_sector_address));
  console_putc('\n');
  
  sdcard_read(boot_sector_address);
  boot_sector = (boot_sector_t*)SDCARD_DATA_8B;
  //Convert little endian to big endian
  reverse(master_boot_record->boot_code   ,446);
  reverse(boot_sector->jump_instr               ,3);
  reverse(boot_sector->oem_name                 ,8);
  reverse(boot_sector->sector_size              ,2);
  reverse(boot_sector->secter_per_cluster       ,1);
  reverse(boot_sector->reserved_sectors         ,2);
  reverse(boot_sector->number_of_FATs           ,1);
  reverse(boot_sector->number_of_directories    ,2);
  reverse(boot_sector->number_of_sectors_lt32   ,2);
  reverse(boot_sector->media_descriptor         ,1);
  reverse(boot_sector->sectors_per_FAT_table    ,2);
  reverse(boot_sector->sectors_per_track        ,2);
  reverse(boot_sector->number_of_heads          ,2);
  reverse(boot_sector->number_of_hidden_sectors ,4);
  reverse(boot_sector->number_of_sectors_gt32   ,4);
  reverse(boot_sector->drive_number             ,1);
  reverse(boot_sector->current_head             ,1);
  reverse(boot_sector->boot_signature           ,1);
  reverse(boot_sector->volume_id                ,4);
  reverse(boot_sector->volume_label             ,11);
  reverse(boot_sector->file_system_type         ,8);
  reverse(boot_sector->boot_code                ,448);
  reverse(boot_sector->boot_sector              ,2);
  reverse(boot_sector->checksum                 ,2);

  console_puts("jump_instr               : ");
  for(int i = 0; i < 3; i++) {console_puts(uint8_to_hex(boot_sector->jump_instr[i]));}
  console_putc('\n');

  console_puts("oem_name                 : ");
  for(int i = 0; i < 8  ; i++) {console_puts(uint8_to_hex(boot_sector->oem_name                [i]));}
  console_putc('\n');

  console_puts("sector_size              : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->sector_size             [i]));}
  console_putc('\n');

  console_puts("secter_per_cluster       : ");
  for(int i = 0; i < 1  ; i++) {console_puts(uint8_to_hex(boot_sector->secter_per_cluster      [i]));}
  console_putc('\n');

  console_puts("reserved_sectors         : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->reserved_sectors        [i]));}
  console_putc('\n');

  console_puts("number_of_FATs           : ");
  for(int i = 0; i < 1  ; i++) {console_puts(uint8_to_hex(boot_sector->number_of_FATs          [i]));}
  console_putc('\n');

  console_puts("number_of_directories    : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->number_of_directories   [i]));}
  console_putc('\n');

  console_puts("number_of_sectors_lt32   : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->number_of_sectors_lt32  [i]));}
  console_putc('\n');

  console_puts("media_descriptor         : ");
  for(int i = 0; i < 1  ; i++) {console_puts(uint8_to_hex(boot_sector->media_descriptor        [i]));}
  console_putc('\n');

  console_puts("sectors_per_FAT_table    : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->sectors_per_FAT_table   [i]));}
  console_putc('\n');

  console_puts("sectors_per_track        : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->sectors_per_track       [i]));}
  console_putc('\n');

  console_puts("number_of_heads          : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->number_of_heads         [i]));}
  console_putc('\n');

  console_puts("number_of_hidden_sectors : ");
  for(int i = 0; i < 4  ; i++) {console_puts(uint8_to_hex(boot_sector->number_of_hidden_sectors[i]));}
  console_putc('\n');

  console_puts("number_of_sectors_gt32   : ");
  for(int i = 0; i < 4  ; i++) {console_puts(uint8_to_hex(boot_sector->number_of_sectors_gt32  [i]));}
  console_putc('\n');

  console_puts("drive_number             : ");
  for(int i = 0; i < 1  ; i++) {console_puts(uint8_to_hex(boot_sector->drive_number            [i]));}
  console_putc('\n');

  console_puts("current_head             : ");
  for(int i = 0; i < 1  ; i++) {console_puts(uint8_to_hex(boot_sector->current_head            [i]));}
  console_putc('\n');

  console_puts("boot_signature           : ");
  for(int i = 0; i < 1  ; i++) {console_puts(uint8_to_hex(boot_sector->boot_signature          [i]));}
  console_putc('\n');

  console_puts("volume_id                : ");
  for(int i = 0; i < 4  ; i++) {console_puts(uint8_to_hex(boot_sector->volume_id               [i]));}
  console_putc('\n');

  console_puts("volume_label             : ");
  for(int i = 0; i < 11 ; i++) {console_puts(uint8_to_hex(boot_sector->volume_label            [i]));}
  console_putc('\n');

  console_puts("file_system_type         : ");
  for(int i = 0; i < 8  ; i++) {console_puts(uint8_to_hex(boot_sector->file_system_type        [i]));}
  console_putc('\n');

  console_puts("boot_code                : ");
  for(int i = 0; i < 448; i++) {console_puts(uint8_to_hex(boot_sector->boot_code               [i]));}
  console_putc('\n');

  console_puts("boot_sector              : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->boot_sector             [i]));}
  console_putc('\n');

  console_puts("checksum                 : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->checksum                [i]));}
  console_putc('\n');

  display_write();


  console_puts("SDCard Partition 1 FAT Parse Test\n");

  fat_sector_address = 0;
  for(int i = 0; i < 4 ; i++) {
    fat_sector_address = (fat_sector_address << 8) | boot_sector->number_of_hidden_sectors[i];
  }
  fat_sector_address *= 512;
  fat_sector_address += boot_sector_address;

  console_puts(uint32_to_hex(fat_sector_address));
  console_putc('\n');

  sdcard_read(fat_sector_address);
  for(int i = 0; i < 514; i++) {
    console_puts(uint8_to_hex(SDCARD_DATA_8B[i]));
  }
  console_puts("\ndone\n");
  display_write();



  console_puts("SDCard Partition 2 BootSector Parse Test\n");

  boot_sector_address = 0;
  for(int i = 0; i < 4 ; i++) {
    boot_sector_address = (boot_sector_address << 8) | master_boot_record->partition[2].lba_first_sector[i];
  }
  boot_sector_address *= 512;
  console_puts(uint32_to_hex(boot_sector_address));
  console_putc('\n');
  
  sdcard_read(boot_sector_address);
  boot_sector = (boot_sector_t*)SDCARD_DATA_8B;
  //Convert little endian to big endian
  reverse(master_boot_record->boot_code   ,446);
  reverse(boot_sector->jump_instr               ,3);
  reverse(boot_sector->oem_name                 ,8);
  reverse(boot_sector->sector_size              ,2);
  reverse(boot_sector->secter_per_cluster       ,1);
  reverse(boot_sector->reserved_sectors         ,2);
  reverse(boot_sector->number_of_FATs           ,1);
  reverse(boot_sector->number_of_directories    ,2);
  reverse(boot_sector->number_of_sectors_lt32   ,2);
  reverse(boot_sector->media_descriptor         ,1);
  reverse(boot_sector->sectors_per_FAT_table    ,2);
  reverse(boot_sector->sectors_per_track        ,2);
  reverse(boot_sector->number_of_heads          ,2);
  reverse(boot_sector->number_of_hidden_sectors ,4);
  reverse(boot_sector->number_of_sectors_gt32   ,4);
  reverse(boot_sector->drive_number             ,1);
  reverse(boot_sector->current_head             ,1);
  reverse(boot_sector->boot_signature           ,1);
  reverse(boot_sector->volume_id                ,4);
  reverse(boot_sector->volume_label             ,11);
  reverse(boot_sector->file_system_type         ,8);
  reverse(boot_sector->boot_code                ,448);
  reverse(boot_sector->boot_sector              ,2);
  reverse(boot_sector->checksum                 ,2);

  console_puts("jump_instr               : ");
  for(int i = 0; i < 3; i++) {console_puts(uint8_to_hex(boot_sector->jump_instr[i]));}
  console_putc('\n');

  console_puts("oem_name                 : ");
  for(int i = 0; i < 8  ; i++) {console_puts(uint8_to_hex(boot_sector->oem_name                [i]));}
  console_putc('\n');

  console_puts("sector_size              : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->sector_size             [i]));}
  console_putc('\n');

  console_puts("secter_per_cluster       : ");
  for(int i = 0; i < 1  ; i++) {console_puts(uint8_to_hex(boot_sector->secter_per_cluster      [i]));}
  console_putc('\n');

  console_puts("reserved_sectors         : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->reserved_sectors        [i]));}
  console_putc('\n');

  console_puts("number_of_FATs           : ");
  for(int i = 0; i < 1  ; i++) {console_puts(uint8_to_hex(boot_sector->number_of_FATs          [i]));}
  console_putc('\n');

  console_puts("number_of_directories    : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->number_of_directories   [i]));}
  console_putc('\n');

  console_puts("number_of_sectors_lt32   : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->number_of_sectors_lt32  [i]));}
  console_putc('\n');

  console_puts("media_descriptor         : ");
  for(int i = 0; i < 1  ; i++) {console_puts(uint8_to_hex(boot_sector->media_descriptor        [i]));}
  console_putc('\n');

  console_puts("sectors_per_FAT_table    : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->sectors_per_FAT_table   [i]));}
  console_putc('\n');

  console_puts("sectors_per_track        : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->sectors_per_track       [i]));}
  console_putc('\n');

  console_puts("number_of_heads          : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->number_of_heads         [i]));}
  console_putc('\n');

  console_puts("number_of_hidden_sectors : ");
  for(int i = 0; i < 4  ; i++) {console_puts(uint8_to_hex(boot_sector->number_of_hidden_sectors[i]));}
  console_putc('\n');

  console_puts("number_of_sectors_gt32   : ");
  for(int i = 0; i < 4  ; i++) {console_puts(uint8_to_hex(boot_sector->number_of_sectors_gt32  [i]));}
  console_putc('\n');

  console_puts("drive_number             : ");
  for(int i = 0; i < 1  ; i++) {console_puts(uint8_to_hex(boot_sector->drive_number            [i]));}
  console_putc('\n');

  console_puts("current_head             : ");
  for(int i = 0; i < 1  ; i++) {console_puts(uint8_to_hex(boot_sector->current_head            [i]));}
  console_putc('\n');

  console_puts("boot_signature           : ");
  for(int i = 0; i < 1  ; i++) {console_puts(uint8_to_hex(boot_sector->boot_signature          [i]));}
  console_putc('\n');

  console_puts("volume_id                : ");
  for(int i = 0; i < 4  ; i++) {console_puts(uint8_to_hex(boot_sector->volume_id               [i]));}
  console_putc('\n');

  console_puts("volume_label             : ");
  for(int i = 0; i < 11 ; i++) {console_puts(uint8_to_hex(boot_sector->volume_label            [i]));}
  console_putc('\n');

  console_puts("file_system_type         : ");
  for(int i = 0; i < 8  ; i++) {console_puts(uint8_to_hex(boot_sector->file_system_type        [i]));}
  console_putc('\n');

  console_puts("boot_code                : ");
  for(int i = 0; i < 448; i++) {console_puts(uint8_to_hex(boot_sector->boot_code               [i]));}
  console_putc('\n');

  console_puts("boot_sector              : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->boot_sector             [i]));}
  console_putc('\n');

  console_puts("checksum                 : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->checksum                [i]));}
  console_putc('\n');

  display_write();


  console_puts("SDCard Partition 2 FAT Parse Test\n");

  fat_sector_address = 0;
  for(int i = 0; i < 4 ; i++) {
    fat_sector_address = (fat_sector_address << 8) | boot_sector->number_of_hidden_sectors[i];
  }
  fat_sector_address *= 512;
  fat_sector_address += boot_sector_address;

  console_puts(uint32_to_hex(fat_sector_address));
  console_putc('\n');

  sdcard_read(fat_sector_address);
  for(int i = 0; i < 514; i++) {
    console_puts(uint8_to_hex(SDCARD_DATA_8B[i]));
  }
  console_puts("\ndone\n");
  display_write();



  console_puts("SDCard Partition 3 BootSector Parse Test\n");

  boot_sector_address = 0;
  for(int i = 0; i < 4 ; i++) {
    boot_sector_address = (boot_sector_address << 8) | master_boot_record->partition[3].lba_first_sector[i];
  }
  boot_sector_address *= 512;
  console_puts(uint32_to_hex(boot_sector_address));
  console_putc('\n');
  
  sdcard_read(boot_sector_address);
  boot_sector = (boot_sector_t*)SDCARD_DATA_8B;
  //Convert little endian to big endian
  reverse(master_boot_record->boot_code   ,446);
  reverse(boot_sector->jump_instr               ,3);
  reverse(boot_sector->oem_name                 ,8);
  reverse(boot_sector->sector_size              ,2);
  reverse(boot_sector->secter_per_cluster       ,1);
  reverse(boot_sector->reserved_sectors         ,2);
  reverse(boot_sector->number_of_FATs           ,1);
  reverse(boot_sector->number_of_directories    ,2);
  reverse(boot_sector->number_of_sectors_lt32   ,2);
  reverse(boot_sector->media_descriptor         ,1);
  reverse(boot_sector->sectors_per_FAT_table    ,2);
  reverse(boot_sector->sectors_per_track        ,2);
  reverse(boot_sector->number_of_heads          ,2);
  reverse(boot_sector->number_of_hidden_sectors ,4);
  reverse(boot_sector->number_of_sectors_gt32   ,4);
  reverse(boot_sector->drive_number             ,1);
  reverse(boot_sector->current_head             ,1);
  reverse(boot_sector->boot_signature           ,1);
  reverse(boot_sector->volume_id                ,4);
  reverse(boot_sector->volume_label             ,11);
  reverse(boot_sector->file_system_type         ,8);
  reverse(boot_sector->boot_code                ,448);
  reverse(boot_sector->boot_sector              ,2);
  reverse(boot_sector->checksum                 ,2);

  console_puts("jump_instr               : ");
  for(int i = 0; i < 3; i++) {console_puts(uint8_to_hex(boot_sector->jump_instr[i]));}
  console_putc('\n');

  console_puts("oem_name                 : ");
  for(int i = 0; i < 8  ; i++) {console_puts(uint8_to_hex(boot_sector->oem_name                [i]));}
  console_putc('\n');

  console_puts("sector_size              : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->sector_size             [i]));}
  console_putc('\n');

  console_puts("secter_per_cluster       : ");
  for(int i = 0; i < 1  ; i++) {console_puts(uint8_to_hex(boot_sector->secter_per_cluster      [i]));}
  console_putc('\n');

  console_puts("reserved_sectors         : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->reserved_sectors        [i]));}
  console_putc('\n');

  console_puts("number_of_FATs           : ");
  for(int i = 0; i < 1  ; i++) {console_puts(uint8_to_hex(boot_sector->number_of_FATs          [i]));}
  console_putc('\n');

  console_puts("number_of_directories    : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->number_of_directories   [i]));}
  console_putc('\n');

  console_puts("number_of_sectors_lt32   : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->number_of_sectors_lt32  [i]));}
  console_putc('\n');

  console_puts("media_descriptor         : ");
  for(int i = 0; i < 1  ; i++) {console_puts(uint8_to_hex(boot_sector->media_descriptor        [i]));}
  console_putc('\n');

  console_puts("sectors_per_FAT_table    : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->sectors_per_FAT_table   [i]));}
  console_putc('\n');

  console_puts("sectors_per_track        : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->sectors_per_track       [i]));}
  console_putc('\n');

  console_puts("number_of_heads          : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->number_of_heads         [i]));}
  console_putc('\n');

  console_puts("number_of_hidden_sectors : ");
  for(int i = 0; i < 4  ; i++) {console_puts(uint8_to_hex(boot_sector->number_of_hidden_sectors[i]));}
  console_putc('\n');

  console_puts("number_of_sectors_gt32   : ");
  for(int i = 0; i < 4  ; i++) {console_puts(uint8_to_hex(boot_sector->number_of_sectors_gt32  [i]));}
  console_putc('\n');

  console_puts("drive_number             : ");
  for(int i = 0; i < 1  ; i++) {console_puts(uint8_to_hex(boot_sector->drive_number            [i]));}
  console_putc('\n');

  console_puts("current_head             : ");
  for(int i = 0; i < 1  ; i++) {console_puts(uint8_to_hex(boot_sector->current_head            [i]));}
  console_putc('\n');

  console_puts("boot_signature           : ");
  for(int i = 0; i < 1  ; i++) {console_puts(uint8_to_hex(boot_sector->boot_signature          [i]));}
  console_putc('\n');

  console_puts("volume_id                : ");
  for(int i = 0; i < 4  ; i++) {console_puts(uint8_to_hex(boot_sector->volume_id               [i]));}
  console_putc('\n');

  console_puts("volume_label             : ");
  for(int i = 0; i < 11 ; i++) {console_puts(uint8_to_hex(boot_sector->volume_label            [i]));}
  console_putc('\n');

  console_puts("file_system_type         : ");
  for(int i = 0; i < 8  ; i++) {console_puts(uint8_to_hex(boot_sector->file_system_type        [i]));}
  console_putc('\n');

  console_puts("boot_code                : ");
  for(int i = 0; i < 448; i++) {console_puts(uint8_to_hex(boot_sector->boot_code               [i]));}
  console_putc('\n');

  console_puts("boot_sector              : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->boot_sector             [i]));}
  console_putc('\n');

  console_puts("checksum                 : ");
  for(int i = 0; i < 2  ; i++) {console_puts(uint8_to_hex(boot_sector->checksum                [i]));}
  console_putc('\n');

  display_write();


  console_puts("SDCard Partition 3 FAT Parse Test\n");

  fat_sector_address = 0;
  for(int i = 0; i < 4 ; i++) {
    fat_sector_address = (fat_sector_address << 8) | boot_sector->number_of_hidden_sectors[i];
  }
  fat_sector_address *= 512;
  fat_sector_address += boot_sector_address;

  console_puts(uint32_to_hex(fat_sector_address));
  console_putc('\n');

  sdcard_read(fat_sector_address);
  for(int i = 0; i < 514; i++) {
    console_puts(uint8_to_hex(SDCARD_DATA_8B[i]));
  }
  console_puts("\ndone\n");
  display_write();

  while(1);
}


