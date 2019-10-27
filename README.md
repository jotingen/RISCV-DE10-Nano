RISCV CPU implemented on an FGPA

Life
![Life](life.gif)

TODO:
SDCard read/write
DDR3 read/write

Memory map:
LCL MEM     'h0001_FFFF - 'h0000_0000;
LED         'hC000_FFFF - 'hC000_0000;
KEYS        'hC100_FFFF - 'hC100_0000;
JOYSTICK    'hC101_FFFF - 'hC101_0000;
DISPLAY     'hC200_FFFF - 'hC200_0000;
DISPBUFF    'hC301_FFFF - 'hC300_0000;
SDCARD      'hC400_FFFF - 'hC400_0000;

CPU/Life IPC counts:
Original .17 IPC
Add FrameBuffer .12
Replace Mem Ring with MMC .22
Change framebuffer writes to only write changed pixels .23
Reduce multiply cycles from 10 to 2, and divide cycles from 10 to 7 .24
