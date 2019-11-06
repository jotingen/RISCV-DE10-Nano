#ifndef	_DISPLAY_H_
#define _DISPLAY_H_

#include <stdio.h>

struct display_pixel_t {  
    uint8_t R;
    uint8_t G;
    uint8_t B;
};
typedef struct display_pixel_t display_pixel_t;

struct console_index_t {  
    uint8_t X;
    uint8_t Y;
};
typedef struct console_index_t console_index_t;

extern void     display_on(void);
extern uint32_t display_rows(void);
extern uint32_t display_cols(void);

extern void     dispbuff_write_pixel(uint8_t row, uint8_t col, display_pixel_t * pixel);
extern void     dispbuff_read_pixel(uint8_t row, uint8_t col, display_pixel_t * pixel);

       void     display_write_start(void);
       void     display_write_pixel(display_pixel_t * pixel);


extern void     display_write(void);

struct console_index_t console_curser(void);
void console_curser_set(struct console_index_t index);
void console_clear();
void console_put_char(char c);

#endif
