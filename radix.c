#include <stdio.h>
#include "num_conv.h"
#include "file_io.h"

char buf[0x40000] = { 0 };

#define ITERATION 16
double _angles[ITERATION] = {
    0.7853981634, 0.4636476090, 0.2449786631, 0.1243549945,
    0.0624188100, 0.0312398334, 0.0156237286, 0.0078123411,
    0.0039062301, 0.0019531225, 0.0009765622, 0.0004882812,
    0.0002441406, 0.0001220703, 0.0000610352, 0.0000305176
};

int main(){
    FILE* fptr = fopen_h("radix", FMD_OVERWRITE);

    int bufpos = 0;
    size_t tempval = 0;
    fp fixedpoint;
    
    double value[] = {3.943632, 13.0493183278};
    double result = value[0]/value[1];
    
    fixedpoint.val = lf2fp(result, 26);
    bufpos += sprintf(&buf[bufpos], "A: %s  B: %s\n", bin_str(lf2fp(value[0], 26), 32, NULL), bin_str(lf2fp(value[1], 26), 32, NULL));
    bufpos += sprintf(&buf[bufpos], "%lf   %x  %6d.%-13d\n", result, fixedpoint.val, fixedpoint.integer, fixedpoint.decimal);
    bufpos += sprintf(&buf[bufpos], "%lf   val: %s  fp: %s.%s\n", result, bin_str(fixedpoint.val, 32, NULL),
                                                            bin_str(fixedpoint.integer, 32-26, NULL), bin_str(fixedpoint.decimal, 26, NULL));

    // for (int i = 0; i < ITERATION; i++) {
    //     tempval = lf2fp(_angles[i], 24-2);
    //     fixedpoint.val = tempval;
    //     bufpos += snprintf(&buf[bufpos], 128, "%s  %x\n", bin_str(tempval, 24, NULL), tempval);
    //     printf("%.8lf %16lx    %2x.%13x\n",_angles[i], tempval, fixedpoint.integer, fixedpoint.decimal);
    // }
    
    printf(buf);
    fwrite(buf, bufpos, 1, fptr);


    fclose(fptr);
}
