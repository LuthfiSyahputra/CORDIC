// The Trigonomery Identity
// cos(a+b) = cos(a)⋅cos(b) − sin(a)⋅sin(b)
// sin(a+b) = sin(a)⋅cos(b) + cos(a)⋅sin(b)

// The Polar Coordinate system
// (x,y) = (A cos(θ), A sin(θ))
// A = sqrt(x^2 + y^2)
// θ = atan(y/x)

// Because we factor the Amplitude to 1, then the change in rotation would be
// cos(θ+α) = cos(θ)⋅cos(α) − sin(θ)⋅sin(α)
// sin(θ+α) = sin(θ)⋅cos(α) + cos(θ)⋅sin(α)

// Apply the Polar Coordinate System, we got the 2D General Rotation Formula
// cos(θ+α) = x⋅cos(α) − y⋅sin(α)
// sin(θ+α) = y⋅cos(α) + x⋅sin(α)

// Simplify by factoring the equations with cos(α)
// cos(θ+α) = (x − y⋅tan(α)) * cos(α)
// sin(θ+α) = (y + x⋅tan(α)) * cos(α)


// THE CORDIC ALGORITHM
// How it works is by Trial and Error, Rotating each iteration by known value
// We can use the General Rotation Formula to calculate the angle

// rotate the angle by (α), where tan(α) and cos(α) is a known value
// ex: rotate by 30° then tan(α) = √3/2 and cos(α) = 1/2
// apply the formula and we get the value

// However multiplication is extremely expensive and we generally want to avoid it as much as possible
// The long known multiplication trick for computation is to multiply it by base number
// for computer b=2, which only requires shifting

// hence, the choosen angle for the algorithm is base 2
// because the main function in this is tan(x)
// where α such that tan(α) = 2^-i or α = arctan(2^-i)

// tan(θ) = {1.0, 0.5, 0.25, 0.125, 0.0625, ...}
// θ      = {45°, 26.565°, 14.036°, 7.125°, ...} 
// θ      = {0.785, 0.463, 0.2449,  0.1243, ...} rad

// Because Sinusoidal is Periodic with an odd and even Function, we can further narrow down the range to
// θ = [90, 0] or [0.5π, 0] with 4 Quadrant

// THE ITERATION
// Suppose we want to know the value of cos(34°), by applying the General Rotation formula
// cos(θ+34) = (x − y⋅tan(34)) * cos(34), because the origin point is θ = 0° then (x,y) = (1,0)
// cos(0+34) = (1 − 0⋅tan(34)) * cos(34)
// cos(0+34) = 1 * cos(34)  // How odd, Certainly this isn't what we aim for

// Use polar coordinate (x,y) = (cos, sin), we take into account not only cos(x), but y as weel or sin(x) then
// cos(0+34) = (1 − 0⋅tan(34)) * cos(34) - change the left from polar coordinate with (x,y) = (1,0)
// x(34) = (1 − 0⋅tan(34)) * cos(34)
// y(34) = (0 + 1⋅tan(34)) * cos(34)

// x(34) = (1 * cos(34))
// y(34) = (tan(34) * cos(34))

// howver we don't know the value of tan(34) nor cos(34), but we can try to guess from already known value
// x_1(45) = cos(45)
// y_1(45) = tan(45) * cos(45)

// Now we're talking, see that we are reaching the result θ = 33.75, repeat this again for many times as possible
// θ = 45 - 26.565 + 14.036 + 7.125 ... ; θ → 34   


// THE CONSTANT K and COSINE FACTOR
// Notice the isolated cosine factor become the product of each rotation
// because the cosine is an even function cos(x) = cos(-x), no matter the direction of the rotation the value will always be |cos(x)|
// To further optimize the equation, we can calculate product of the cosine beforehand
// ∏(cos(αi)) ; αi = arctan(2^i) 
// ∏ cos( arctan(2^i) ) ; n → ∞

// Make it a constant K then
// K ≈ 0.607252935

// THE CORDIC ALGORITHM
// Take the cosine from the equation and precompute the product of n iteration of cos(x), we have
// x1 = x - y 2^-n  
// y1 = y + x 2^-n
// θ1 = θ + αi
//
// x1 = x - b (y >> n)  ; where b is the direction of the rotation
// y1 = y + b (x >> n)  ; b = sgn(Δθ) ; Δθ = θ target - θi
//
// Iterate it 2^k times, multiply it by the scaling factor from the product of cosine
// where Xn and Yn is the value after final iteration
// X' = Xn * K
// Y' = Yn * K
// we get (x', y') = (cos(θ'), sin(θ'))

// For all the optimization we only need 2 multiplication for the entire process that is the scaling factor

#include <math.h>
#include <stdio.h>



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

typedef struct vec_2d {
    double x;
    double y;

    double r;
    double a;
} vec_2d;

#define INTEGER_WIDTH 2
#define DECIMAL_WIDTH(int_width, type) ((sizeof(type) * 8) - int_width)

typedef union fp{
    long val;
    struct {
#   if (32 - INTEGER_WIDTH) > 0
        unsigned long decimal : DECIMAL_WIDTH(INTEGER_WIDTH, long);
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
        unsigned long long decimal : DECIMAL_WIDTH(INTEGER_WIDTH, long long);
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



#define ITERATION   16
#define ABSOLUTE(x)  x = (x < 0) ? -x : x;

#define DEG_RAD(deg) (deg * (M_PI/180.0))
#define RAD_DEG(rad) (rad * (180.0/M_PI))


double K   = 0.6072529351031395;
double _angles[ITERATION] = {
    0.7853981634, 0.4636476090, 0.2449786631, 0.1243549945,
    0.0624188100, 0.0312398334, 0.0156237286, 0.0078123411,
    0.0039062301, 0.0019531225, 0.0009765622, 0.0004882812,
    0.0002441406, 0.0001220703, 0.0000610352, 0.0000305176
};



vec_2d GRF(coord_lf p, double a);
vec_2d CORDIC(coord_lf p, double a, int mode);
long long lf2fp(double val, int dec_width);
double fp2lf(register long long val, int dec_width);
double func(double A, double w, double t);



#define TARGET DEG_RAD(45)
#define ROTATION_MODE   0
#define VECTORING_MODE  1

#define ITERATION_2 1

#define NANOSECOND  0.000000001
#define CLOCK_H     (5 * NANOSECOND)          // Nanosecond

#define FUNC(A, w, t, phase_diff) (A * sin((w*t) + phase_diff))

#define NUM_OF_SAMPLE  256
fp y_1[NUM_OF_SAMPLE] = { 0 };
fp y_2[NUM_OF_SAMPLE] = { 0 };


FPGA_OUT FPGA(FPGA_IN input);

int main(){




    
    // double signal1 = A * sin((w*t) + phase_diff);
    
    
    double val = 0.5;
    lfp a = {0};
    
    coord_lf init = {1,0};
    for (double angle = 0; angle < 120 ; angle += 5) {
        
        vec_2d a = GRF   (init, DEG_RAD(angle));
        vec_2d b = CORDIC(init, DEG_RAD(angle), VECTORING_MODE);
        printf("[%3.2lf] x: %lf %lf (%lf)\n"  , RAD_DEG(a.a), a.x, b.x, b.x - a.x);
        printf("[%3.2lf] y: %lf %lf (%lf)\n\n", RAD_DEG(b.a), a.y, b.y, b.y - a.y);
        printf("[%3.2lf] r: %lf %lf (%lf)\n\n", RAD_DEG(b.a), a.r, b.r, b.r - a.r);
        // printf("[%3.2lf] y: %lf %lf (%lf)\n\n", RAD_DEG(b.a), a.y, b.y, b.y - a.y);
        
    }

    printf("%llx\n" , lf2fp(1, DECIMAL_WIDTH(INTEGER_WIDTH, sizeof(long long))));    
}


/* =========================================== FUNCTIONS ================================================ */


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

// General Rotation Formula
vec_2d GRF(coord_lf p, double a) {
    vec_2d retval = { 0 };
    retval.x = cos(a) * (p.x - (p.y * tan(a)) );
    retval.y = cos(a) * (p.y + (p.x * tan(a)) );
    retval.r = sqrt(pow(retval.x, 2) + pow(retval.y, 2));
    retval.a = atan2(retval.y, retval.x);
    return retval;
}

// CORDIC Algorithm
vec_2d CORDIC(coord_lf p, double a, int mode) {
    double theta = 0;
    int n = 0;
    
    coord_b p_0 = {lf2fp(p.x, DECIMAL_WIDTH(INTEGER_WIDTH, sizeof(long long))), lf2fp(p.y, DECIMAL_WIDTH(INTEGER_WIDTH, sizeof(long long)))};
    coord_b p_1 = {0};

    // vectoring mode range adjustments, since the range [90, -90], which is only in positive x-axis (+x)
    // if ((mode == VECTORING_MODE) && (p_0.x < 0)) {
    //     ABSOLUTE(p_0.x);
    //     theta -= DEG_RAD(180);
    // }

    for (int i = 0; i < ITERATION; ) {
        if((mode == ROTATION_MODE) ? (a >= theta) : (p_0.y < 0)) {
            p_1.x = p_0.x - (p_0.y >> i);
            p_1.y = p_0.y + (p_0.x >> i);
            theta += _angles[i];
        }
        else {
            p_1.x = p_0.x + (p_0.y >> i);
            p_1.y = p_0.y - (p_0.x >> i);
            theta -= _angles[i];
        }
        p_0.x = p_1.x;
        p_0.y = p_1.y;

        
        if(n >= (ITERATION_2 - 1)) { i++; n = 0;}
        else n++;

        // printf("[%2d] deg: %.2lf   %lf   %lf\n", i, RAD_DEG(theta), 
        //                                         fp2lf(p_0.x, DECIMAL_WIDTH(INTEGER_WIDTH, sizeof(long long))), 
        //                                         fp2lf(p_0.y, DECIMAL_WIDTH(INTEGER_WIDTH, sizeof(long long)))
        // );
    }

    vec_2d retval = { 0 };
    retval.x = fp2lf(p_0.x, DECIMAL_WIDTH(INTEGER_WIDTH, sizeof(long long))) * pow(K, ITERATION_2);
    retval.y = fp2lf(p_0.y, DECIMAL_WIDTH(INTEGER_WIDTH, sizeof(long long))) * pow(K, ITERATION_2);
    retval.a = -theta;
    retval.r = (mode == VECTORING_MODE) ? retval.x : sqrt((retval.x*retval.x) + (retval.y*retval.y));

    return retval;
    
}