#ifndef NUMBER_CONVERTER
#define NUMBER_CONVERTER

#include <math.h>
#include "datatype.h"


long long lf2fp(double val, int dec_width);
double fp2lf(register long long val, int dec_width);

// Floating-Point to Fixed-Point Converter
long long lf2fp(double val, int dec_width) {
    register unsigned long long temp = 0;
    // if(val == 0) return 0;
    
    // because the size of [s][E][M] with ||s|| + ||E|| = 12 and ||M|| = 52
    // the integer part of the transformation in [temp] will only have ||s + E|| range (12)
    // the number bigger than it will be lost, there is a need to optimize and do the shift early with E
    
    // // transform to real value with ||dec|| = ||M||
    // register int E = (( *(long long*)&val & 0x7ff0000000000000 ) >> 52) - 1023;
    // if(E >= 0) { temp = (((*(long long*)&val | 0x0010000000000000) & 0x001fffffffffffff) << E) ;}
    // else       { temp = (((*(long long*)&val | 0x0010000000000000) & 0x001fffffffffffff) >> -E) ;}
    
    // // translate to the corresponding decimal width
    // E = 52 - dec_width;
    // if(E >= 0) temp = temp >> E;
    // else       temp = temp << -E;
    // printf("%d %16llx %16llx [%lf]\n",E, temp, *(long long*)&val, val);

    
    // translate and transform
    // [Translate] Change the global point-coordinate by Δ||dec|| = ||dec fp|| - ||M|| = dec_width - 52
    // [Transform] from floating-point to fixed-point (1.M) * 2^(e -1023) -> 2^i . 2^-(j+1)
    // the total bit-shift is E = (e -1023) + Δ||dec||
    register int E = ((*(unsigned long long*)&val & 0x7ff0000000000000 ) >> 52) - 1023 - 52 + dec_width; 
    if(E >= 64)  return __LONG_LONG_MAX__; // if the Exponent value too big 
    if(E <= -64) return 0;                 // if the Exponent value too small
    
    if(E >= 0) { temp = (((*(unsigned long long*)&val | 0x0010000000000000) & 0x001fffffffffffff) << E) ;}
    else       { temp = (((*(unsigned long long*)&val | 0x0010000000000000) & 0x001fffffffffffff) >> -E) ;}
    
    // check the sign
    if(*( long long*)&val & 0x8000000000000000) temp = -temp;
    return temp;
}

// Fixed-Point to Floating-Point Converter
double fp2lf(register long long val, int dec_width){
    if (val == 0) return 0;
    double temp = (double)val * pow(2, -dec_width);
    
    return temp;
}


#define _BIN_TEMPBUF_N 0x10
char _bin_buf[_BIN_TEMPBUF_N][64] = {0};
char _bin_buf_cnt = 0;

char* bin_str(register size_t val, int bit_size, register char* _buf) {
    if(bit_size > 64) {
        return NULL;
    }

    if(_buf == NULL) {
        _buf = _bin_buf[_bin_buf_cnt];
        _bin_buf_cnt = (_bin_buf_cnt < _BIN_TEMPBUF_N) ? (_bin_buf_cnt + 1) : 0;
    }

    char* retval = _buf;
    for (int i = bit_size - 1; i >= 0; i--) {
        *_buf = (val & (1 << i)) ? '1' : '0';
        _buf++;
    }
    *_buf = '\0';
    
    return retval;
}


#endif