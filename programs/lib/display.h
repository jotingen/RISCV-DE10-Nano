#ifndef	_DISPLAY_H_
#define _DISPLAY_H_

#include <stdio.h>

#define PXL_BLACK   (struct display_pixel_t) {0x00,0x00,0x00}
#define PXL_WHITE   (struct display_pixel_t) {0x1F,0x3F,0x1F}
#define PXL_RED     (struct display_pixel_t) {0x1F,0x00,0x00}
#define PXL_LIME    (struct display_pixel_t) {0x00,0x3F,0x00}
#define PXL_BLUE    (struct display_pixel_t) {0x00,0x00,0x1F}
#define PXL_YELLOW  (struct display_pixel_t) {0x1F,0x3F,0x00}
#define PXL_CYAN    (struct display_pixel_t) {0x00,0x3F,0x1F}
#define PXL_MAGENTA (struct display_pixel_t) {0x1F,0x00,0x1F}
#define PXL_SILVER  (struct display_pixel_t) {0x18,0x30,0x18}
#define PXL_GRAY    (struct display_pixel_t) {0x10,0x20,0x10}
#define PXL_MAROON  (struct display_pixel_t) {0x10,0x00,0x00}
#define PXL_OLIVE   (struct display_pixel_t) {0x10,0x20,0x00}
#define PXL_GREEN   (struct display_pixel_t) {0x00,0x20,0x00}
#define PXL_PURPLE  (struct display_pixel_t) {0x10,0x00,0x10}
#define PXL_TEAL    (struct display_pixel_t) {0x00,0x20,0x10}
#define PXL_NAVY    (struct display_pixel_t) {0x00,0x00,0x10}

struct __attribute__((__packed__)) display_pixel_t {  
    unsigned int R : 5;
    unsigned int G : 6;
    unsigned int B : 5;
};
typedef struct display_pixel_t display_pixel_t;

struct __attribute__((__packed__)) console_index_t {  
    uint8_t X;
    uint8_t Y;
};
typedef struct console_index_t console_index_t;

extern void     display_on(void);
extern void     display_init(void);
extern uint32_t display_height(void);
extern uint32_t display_width(void);

extern void     dispbuff_write_pixel(uint16_t x, uint16_t y, display_pixel_t pixel);
extern display_pixel_t dispbuff_read_pixel(uint16_t x, uint16_t y);

       void     display_write_start(void);
       void     display_write_pixel(display_pixel_t pixel);


extern void     display_write(void);

struct console_index_t console_curser(void);
void console_curser_set(struct console_index_t index);
void console_clear();
void console_enable();
void console_disable();
void console_put_char(char c);

void console_putc(char c);
void console_puts(char *s);
void console_puthex8(uint8_t val);

void set_uart_baud(uint32_t baud);

char * uint8_to_hex(uint8_t number);
char * uint16_to_hex(uint16_t number);
char * uint32_to_hex(uint32_t number);
char * uint64_to_hex(uint64_t number);

#endif
