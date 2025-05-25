#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#include <memory.h>

#define GRAPHMODE_BRUTE 0
#define GRAPHMODE_SEEK  1

#define CLAMP(x, min , max) (x = (x < min) ? min : ((x > max) ? max : x))

typedef struct scr_buf {
    int x, y;
    char* buffer;
} scr_buf;

typedef struct vec_2d {
    double x;
    double y;

    double r;
    double a;
} vec_2d;


#define MIDDLE(a, b) ((a+b) / 2)
#define malloc_clean(size) memset(malloc(size), 0, size)

int graph(double (*func)(double), scr_buf buf, vec_2d range[2], int mode);


scr_buf get_screen_buffer(unsigned int x, unsigned int y) {
    scr_buf retval = {x, y, malloc_clean(x*y)};
    return retval;
}

int _render(scr_buf buf, int mode) {
    for (int i = 0; i < buf.y; i++) {
        for (int j = 0; j < buf.x; j++) {
            putchar((*buf.buffer == 0)? ' ' : *buf.buffer);
            buf.buffer++;
        }
        putchar('\n');
    }   
}

int _graph_background(scr_buf buf, unsigned int density, register char background) {
    CLAMP(density, 1, 256);
    if (background == 0) (background = '.');
    for (int i = 0; i < buf.y; i += density) {
        for (int j = 0; j < buf.x; j += density) {
            *buf.buffer = background;
            buf.buffer += density;
        }
        buf.buffer = buf.buffer + (buf.x * (density - 1)); // skip lines based on density
    }
}

// int graph(double (*func)(double), scr_buf buf, vec_2d range, int mode) {

//     // main graph render
//     if(mode == GRAPHMODE_BRUTE) {
//         for (int i = 0; i < buf.y; i++) {
//             for (int i = 0; i < buf.x; i++) {
                
//             }
            
//         }
        
//     }
// }