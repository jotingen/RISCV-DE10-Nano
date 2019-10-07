#ifndef	_DISPLAY_H_
#define _DISPLAY_H_

#include <stdio.h>

#define DISPLAY_ROWS    160
#define DISPLAY_COLS    128

struct display_pixel_t {  
    uint8_t R;
    uint8_t G;
    uint8_t B;
};
typedef struct display_pixel_t display_pixel_t;

extern void     display_on(void);
extern uint32_t display_rows(void);
extern uint32_t display_cols(void);
extern void     display_write_start(void);
extern void     display_write_pixel(display_pixel_t pixel);

#endif
