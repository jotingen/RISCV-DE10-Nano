

# RISCV CPU implemented on an FGPA

## Playing the Game of Life
![Life](life.gif)

## What Why
Back in college I built a Little Computer 3 that eventually was run on an FPGA and made lights flicker. I work with FPGAs at work and I had the thought one day that it would be interesting to build the LC3 again on an FPGA and make it do something more useful than flicker lights.
 At work I use Quartus to build FPGA designs, and there is a free lite version that I could make use of. It limited the FPGA search to Altera/Intel, but familiarity with the software would make that part of the project easier. After some searching I chose the DE10Nano-Lite since it had a lot of built in things I could try and drive, such as HDMI, GPIO, Shield, DDR3, etc, for a sane amount of money.
 As I was starting to plan out I remembered back to how annoying it was to write in assembly for LC3, and I was not sure if there was a C compiler available for it. So I looked into other architectures. Z80 seemed to have a good library to work from, maybe the 68000 would to. Then I looked into this RISCV thing everyone was talking about, and its instruction set was simple enough at ~40 ops that I could fairly easily get it implemented. Plus there were different feature sets, so in the future I could expand on it (I ended up adding the Mulipliy/Divide instructions pretty early on). Another big plus was that that GCC can compile RISCV code, so I can wright things in C instead of assembly.  
 So far it has paid off for itself with experience of demystifying the magic that goes on between softwae/cpu/devices. I had to learn I2C/SPI interfacing, driving a display chip, reading form SDCards, the Wishbone Bus, etc. 
 The end goal at the moment is, of course, to play Doom on it.

## The System

### CPU
The CPU is a 32 bit RISCV with the multiplication instruction additions. There is one instruction port and one data port. I opted for two ports early on since the built in FPGA memory has 2 ports available. The instruction bus has been ported to Wishbone to enable pipelined requests. One of the biggest bottlenecks early on was just waiting for instructions to come in. The CPU is divided into stages that seem pretty standard for CPU designs:
**Instruction Fetch**
Responsible for constantly requesting instructions from memory. There is a 8 instruction buffer that is filled while the CPU is waiting for some op to finish. Originally the code I was running had a 96% branch miss rate, so I recently added a simple branch predictor which cut the miss rate down to 6% or so.
**Instruction Decode**
Breaks down the instructions into their peices. The RISCV instruction set is slick in that generally the same field use the same bits for all ops.
**Instruction Dispatch**
Is responsible fordeciding what section of the CPU to send the op to. In the future I hope to get some out of order functionality implemented, in which this stage will need to be expanded to handle more than one instruction at a time.
**Execution**
Originally all ops were processed by the same block of logic, but it quickly turned into a huge timing issue for Quartus. Now it is being split into seperate blocks, a Branch Unit, Load/Store Unit, Division Unit, Multiplication Unit, and an ALU for everything else.
**Write Back**
Handles storing the new values of registers. Its more desirable to have them written in the previous stage, but the amount of muxing caused a big mess with timing.

### Display
I am using a touch display to give more feedback than just flashing lights. It is based around the Arduino Shield format, and is driven via SPI.
### UART
Discovered the existance of UART later into the project, and now there is a block for driving that. Via a UART-USB adaptor I am able to recieve text on a terminal interface. Right now it can only be written to, in the future I'll expand it to accept input form whatever it is connectd to.
### SDCard
The display shield also has a sdcard port on it, accessed via SPI. I've figured out how to handshake with an SDCARD and am able to read sectors from it. The next step here is to work on a FAT driver so I will be able to load a program from it.
### DDR3
This one has been the most tricky. For this I have to interface with the ARM chip built into the FPGA to get to DDR3. The provided example isnt very complete and is buggy. I've managed to get it working, but there are a lot of unresolved timings. Essentially for each request I drive 3 of them back to back, afterwards they seem to take. More work to do here, but I really needed to get access to memory outside of the FPGA since memory limited in the FPGA

## TODO:

 - ~~SDCard read/write~~
 - ~~DDR3 read/write~~
 - ~~Branch Predictor~~
 - Out-of-order Execution
 - Decode FAT table
 - Implement Wishbone Bus
 - Interrupts

## Memory map:
| Device | Addr High | Addr Low |
|--|--|--|
|LCL MEM | 'h0001_FFFF | 'h0000_0000|
|DDR3 MEM | 'h13FF_FFFF|'h1000_0000|
|LED | 'hC000_FFFF|'hC000_0000|
|KEYS | 'hC100_FFFF|'hC100_0000|
|JOYSTICK | 'hC101_FFFF|'hC101_0000|
|DISPLAY | 'hC200_FFFF|'hC200_0000|
|DISPBUFF | 'hC301_FFFF|'hC300_0000|
|SDCARD | 'hC400_FFFF|'hC400_0000|

## Device Register Mapping
|Display ||
|--|--|
|'hC200_0000 | NoOp|
|'hC200_0004 | Cmd|
|'hC200_0008 | Data|
|'hC200_0100 | Text Clear|
|'hC200_0104 | Text Cursor [23:16]-X [15:8]-Y|
|'hC200_0108 | Text Put                       [7:0]-Char|
|'hC200_010C | Text Put At [23:16]-X [15:8]-Y [7:0]-Char|
|'hC200_0110 | Text Color  [21:16]-R [13:8]-G [5:0]-B |

|DispBuff ||
|--|--|
|'hC300_0000 | Framebuffer (0,0)|
|'hC300_0004 | Framebuffer (1,0)|
|...|...|
|'hC301_3FF8 | Framebuffer (158,127)|
|'hC301_3FFC | Framebuffer (159,127)|
|'hC301_4000 | Textbuffer  (0,0)|
|'hC301_4004 | Textbuffer  (1,0)|
|...|...|
|'hC301_44F8 | Textbuffer  (18,15)|
|'hC301_44FC | Textbuffer  (19,15)|

|SDCard ||
|--|--|
|'hC400_0000 | NoOp|
|'hC400_0004 | Cmd Send|
|'hC400_0008 | Cmd [31:0]|
|'hC400_000C | Cmd [47:32]|
|'hC400_0010 | Cmd Rsp Arrived|
|'hC400_0014 | Cmd Rsp [31:0]|
|'hC400_0018 | Cmd Rsp [47:32]|
|'hC400_001C | Data In|
|'hC400_0020 | Data Out|

## DDR3 Caching

Starting work on using better caches for DDR3 access.

Emulting a ~25 cycle access time, with 500 instruction and memory ops

| Inst | Mem | Inst+Mem | Config |
|--|--|--|--|
|26.3cyc/op|33.6cyc/op|29.8cyc/op| 1 entry for inst, 16 entry lru for mem|
|22.8cyc/op|25.4cyc/op|20.8cyc/op| Cache extracted from DDR3 and modularized. Inst cache matched to mem. Mem interface ported to wishbone.
