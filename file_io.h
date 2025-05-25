#ifndef FILE_IO
#define FILE_IO
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <memory.h>
#include <string.h>
#include "datatype.h"

typedef FILE* FPTR, FILEPTR;
#define BUFSIZE_H 0x1000

char* graph_plot_csv(coord_lf data[], int n);

// File _Mode
#define FMD_READ         "r"    /* Read-only */
#define FMD_READBIN      "rb"   /* Read-only Binary */
#define FMD_WRITE        "w"    /* Write-only (overwrite) */
#define FMD_WRITEBIN     "wb"   /* Write-only binary (overwrite) */
#define FMD_MODIFY       "r+"   /* Modify (Read and Write) */
#define FMD_MODIFYBIN    "rb+"  /* Modify binary (read and write) */
#define FMD_OVERWRITE    "w+"   /* Modify b */
#define FMD_OVERWRITEBIN "wb+"
#define FMD_APPEND       "a"
#define FMD_APPENDBIN    "ab"
#define FMD_RAPPEND      "a+"
#define FMD_RAPPENDBIN   "ab+"

// windows C GNU mingw-w64 FILE handle

/*
 * == controlling IO buffering ==
 * functions: setbuf(), setvbuf()
 * from stdin and stdout buffer (4096 bytes)
 * 
 * mode
 *  _IONBF: No buffer
 *  _IOLBF: Line (feed) buffer
 *  _IOFBF: Full buffer
*/

/* == Controlling internal File pointer position ==
 * functions: fseek(), ftell(), fgetpos(), ftellpos()
 * success: 0   error: -1
 * moves the file pointer (if any) associated with stream 
 * to a new location that is offset bytes from origin.
 * 
 * origin
 *  SEEK_SET: Beginning of file
 *  SEEK_CUR: Current position of file pointer
 *  SEEK_END: End of file
 * 
 *
*/

#define FPOS(filename, FILE) printf("Fpos {%s}: %d\n", filename, ftell(FILE))
#define FOPEN(FPTR, dir) if((FPTR = fopen(dir, mode)) == NULL) fprintf(stderr_h, "%s error opening file \"%s\" (mode: %s)\n", DEBUG_WARNING, dir, mode);

FILE* fopen_h(const char* restrict dir, const char* restrict mode) {
    FILE* file;
    if((file = fopen(dir, mode)) == NULL) 
        fprintf(stderr, "[WARNING] error opening file \"%s\" (mode: %s)\n", dir, mode);
    return file;
    
}


char* graph_plot_csv(coord_lf data[], int n) {
    int k = 1 +((n * 32) / BUFSIZE_H);
    char* buffer = memset(malloc((k * BUFSIZE_H)), 0, (k * BUFSIZE_H));
    int ptr = sprintf(buffer, "x;y\n");

    for (int i = 0; i < n; i++) {
        ptr += sprintf(&buffer[ptr], "%4.8lf;%4.8lf\n", data[i].x, data[i].y);
    }
    return buffer;
}






#endif