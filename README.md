RISCV CPU implemented on an FGPA

Life
![Life](life.gif)


CPU/Life IPC counts:
Original .17 IPC
Add FrameBuffer .12
Replace Mem Ring with MMC .22
Change framebuffer writes to only write changed pixels .23
Reduce multiply cycles from 10 to 2, and divide cycles from 10 to 7 .24
