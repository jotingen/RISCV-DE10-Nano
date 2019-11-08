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

Display RegMap
'hC200_0000 - NoOp
'hC200_0004 - Cmd
'hC200_0008 - Data
'hC200_0100 - Text Clear
'hC200_0104 - Text Cursor [23:16]-X [15:8]-Y
'hC200_0108 - Text Put                       [7:0]-Char
'hC200_010C - Text Put At [23:16]-X [15:8]-Y [7:0]-Char
'hC200_0110 - Text Color  [21:16]-R [13:8]-G [5:0]-B 

DispBuff RegMap
'hC300_0000 - Framebuffer (0,0)
'hC300_0004 - Framebuffer (1,0)
...
'hC301_3FF8 - Framebuffer (158,127)
'hC301_3FFC - Framebuffer (159,127)
'hC301_4000 - Textbuffer  (0,0)
'hC301_4004 - Textbuffer  (1,0)
..
'hC301_44F8 - Textbuffer  (18,15)
'hC301_44FC - Textbuffer  (19,15)

SDCard RegMap
'hC400_0000 - NoOp
'hC400_0004 - Cmd Send
'hC400_0008 - Cmd [31:0]
'hC400_000C - Cmd [47:32]
'hC400_0010 - Cmd Rsp Arrived
'hC400_0014 - Cmd Rsp [31:0]
'hC400_0018 - Cmd Rsp [47:32]
'hC400_001C - Data In
'hC400_0020 - Data Out


