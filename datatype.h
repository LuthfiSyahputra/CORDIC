#ifndef DATATYPE_H
#define DATATYPE_H


#define FLAG_CHECK(val, flag) ((val & (flag)) && flag)

#define INTEGER_WIDTH 6
#define DECIMAL_WIDTH(int_width, sizeof_type) ((sizeof_type * 8) - int_width)

typedef union fp{
    long val;
    struct {
#   if (32 - INTEGER_WIDTH) > 0
        unsigned long decimal : DECIMAL_WIDTH(INTEGER_WIDTH, sizeof(long));
        unsigned long integer : INTEGER_WIDTH;
#   else
        unsigned long decimal : 31;
        unsigned long integer : 1;
#   endif
    };
} fp;

typedef union lfp{
    long long val;
    struct {
#   if (64 - INTEGER_WIDTH) > 0
        unsigned long long decimal : DECIMAL_WIDTH(INTEGER_WIDTH, sizeof(long long));
        long long integer : INTEGER_WIDTH;

#   else
        unsigned long long decimal : 63;
        unsigned long long integer : 1;
#   endif
    };
    
} lfp;

typedef union lf_fmt {
    double val;
    struct {
        unsigned long long M : 52;
        unsigned long long e : 11;
        unsigned long long sgn : 1;
    };
} lf_fmt;

typedef struct coord_lf {
    double x;
    double y;
} coord_lf;

typedef struct coord_b {
    long long x;
    long long y;
} coord_b;

typedef struct polar {
    double r;
    double a;
} polar;



typedef char state_in;

typedef struct FPGA_IN {
    double y_1;
    double y_2;
    state_in mode;
} FPGA_IN;

typedef struct FPGA_OUT {
    double y_1;
    double y_2;
} FPGA_OUT;

#endif