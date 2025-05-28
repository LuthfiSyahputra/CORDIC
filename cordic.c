// The Trigonomery Identity
// cos(a+b) = cos(a)⋅cos(b) − sin(a)⋅sin(b)
// sin(a+b) = sin(a)⋅cos(b) + cos(a)⋅sin(b)

// The Polar Coordinate system
// (x,y) = (A cos(θ), A sin(θ))
// A = sqrt(x^2 + y^2)
// θ = atan(y/x)

// Becaus) e we factor the Amplitude to 1, then the change in rotation would be
// cos(θ+α) = cos(θ)⋅cos(α) − sin(θ)⋅sin(α)
// sin(θ+α) = sin(θ)⋅cos(α) + cos(θ)⋅sin(α)

// Apply the Polar Coordinate System, we got the 2D General Rotation Formula
// cos(θ+α) = x⋅cos(α) − y⋅sin(α)
// sin(θ+α= y⋅cos(α) + x⋅sin(α)

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

// r2 = x2 + y2
// x  = sqrt r2-y2

#include <math.h>
#include <stdio.h>
#include <conio.h>
#include "render.h"
#include "datatype.h"
#include "file_io.h"

#define HALT_KEY(msg)  {printf("%s", msg); getch();}



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
vec_2d CORDIC(coord_lf p, coord_lf target, double a, int mode);
long long lf2fp(double val, int dec_width);
double fp2lf(register long long val, int dec_width);
double func(double A, double w, double t);



#define TARGET DEG_RAD(45)
#define ROTATION_MODE   0
#define VECTORING_MODE  1
#define NEGATIVE        0x2     // Negative slope / derivative
#define CONJUNGATE      0x4     // Conjugate Technique

#define ITERATION_2 2
#define TARGET_ANGLE 120
#define MY_WAY 1

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

    
    coord_lf init = {pow(K, ITERATION_2) ,0};
    coord_lf target;
    FILE* fptr = fopen_h("result cordic.csv", FMD_RAPPEND);
    
    
    for (double angle = TARGET_ANGLE ; angle < 361  ; angle +=9000) {
        double target_theta = DEG_RAD(angle);
        target = (coord_lf) {0, sin(target_theta)};
        
        vec_2d a = GRF   (init, 0);
        vec_2d b = CORDIC(init, target, DEG_RAD(60), VECTORING_MODE | ((cos(target_theta) < 0) ? (CONJUNGATE | NEGATIVE) : 0));
        printf("[%3.2lf] x: %lf %lf (%lf)\n"  , RAD_DEG(a.a), a.x, b.x, b.x - a.x);
        printf("[%3.2lf] y: %lf %lf (%lf)\n", RAD_DEG(b.a), a.y, b.y, b.y - a.y);
        printf("[%3.2lf] r: %lf %lf (%lf)\n\n", RAD_DEG(b.a), a.r, b.r, b.r - a.r);
        printf("[%3.2lf] y: %lf %lf (%lf)\n\n", RAD_DEG(b.a), a.y, b.y, b.y - a.y);

        
    }

    double o = 0;
    for (int i = 0; i < 16; i++) {
        o += _angles[i];
    }
    
    printf("O: %lf", RAD_DEG(o));
    printf("%llx\n" , lf2fp(1, DECIMAL_WIDTH(INTEGER_WIDTH, sizeof(long long))));   
    
    // scr_buf buffer = get_screen_buffer(128, 64);
    // _graph_background(buffer, 2, '.');
    // _render(buffer, 0);

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
vec_2d CORDIC(coord_lf p, coord_lf target, double a, int mode) {
    double theta = 0;
    int n = 0;
    
    coord_b p_0 = {lf2fp(p.x, DECIMAL_WIDTH(INTEGER_WIDTH, sizeof(long long))), lf2fp(p.y, DECIMAL_WIDTH(INTEGER_WIDTH, sizeof(long long)))};
    coord_b target_b = {lf2fp(target.x, DECIMAL_WIDTH(INTEGER_WIDTH, sizeof(long long))), lf2fp(target.y, DECIMAL_WIDTH(INTEGER_WIDTH, sizeof(long long)))};
    coord_b p_1 = {0};

    coord_lf temp_result[(ITERATION * ITERATION_2) + 2] = {0};

    // vectoring mode range adjustments, since the range [90, -90], which is only in positive x-axis (+x)
    // if ((mode == VECTORING_MODE) && (p_0.x < 0)) {
    //     ABSOLUTE(p_0.x);
    //     theta -= DEG_RAD(180);
    // }

    printf("[init] deg: %-6.2lf   x: %-10lf   y: %-10lf  y_target: %lf\n\n", RAD_DEG(theta), 
    fp2lf(p_0.x, DECIMAL_WIDTH(INTEGER_WIDTH, sizeof(long long))), 
    fp2lf(p_0.y, DECIMAL_WIDTH(INTEGER_WIDTH, sizeof(long long))),
    fp2lf(target_b.y, DECIMAL_WIDTH(INTEGER_WIDTH, sizeof(long long)))
    );

    temp_result[0] = p;
    int A,B,C;

    int temp_i = 1;
    for (int i = 0; i < ITERATION; ) {
        A = (p_0.x < 0);
        B = (p_0.y < 0);
        C = (p_0.y < target_b.y);

        // In vectoring mode, we try to keep the range between [-90, 90]
        // and mirror (conjugate) the real part (x), based from the derivative
        // Hence the logic is f(A,B,C) = (AB) + (C ~A); Where {true = +α, false = -α}

#if MY_WAY
        if( ((mode & VECTORING_MODE) ? ((A && B) || (C && !A)) : (theta <= a))) {
#else
        if( ((mode & VECTORING_MODE) ? (p_0.y < target_b.y) : (theta <= a))) {
#endif

            p_1.x = p_0.x - (p_0.y >> i);
            p_1.y = p_0.y + (p_0.x >> i);
        
            // target_b.y -= lf2fp(pow(2, -i-1), DECIMAL_WIDTH(INTEGER_WIDTH, sizeof(long long)));
            theta += _angles[i];

        }
        else {
            p_1.x = p_0.x + (p_0.y >> i);
            p_1.y = p_0.y - (p_0.x >> i);

            // target_b.y += lf2fp(pow(2, -i-1), DECIMAL_WIDTH(INTEGER_WIDTH, sizeof(long long)));
            theta -= _angles[i];
        }
        p_0.x = p_1.x;
        p_0.y = p_1.y;

        p.x = fp2lf(p_0.x, DECIMAL_WIDTH(INTEGER_WIDTH, sizeof(long long)));
        p.y = fp2lf(p_0.y, DECIMAL_WIDTH(INTEGER_WIDTH, sizeof(long long)));
        target.y = fp2lf(target_b.y, DECIMAL_WIDTH(INTEGER_WIDTH, sizeof(long long)));

        HALT_KEY("");
        printf("[%2d] deg: %-6.2lf   x: %-10lf   y: %-10lf  y_target: %lf\n", i, RAD_DEG(theta), p.x, p.y, target.y);
        temp_result[temp_i++] = p;

        if(n >= (ITERATION_2 - 1)) { i++; n = 0;}
        else n++;

    }

#if MY_WAY
    // TECHNIQUE 2: REAL CONJUNGATE
    if (FLAG_CHECK(mode, CONJUNGATE | NEGATIVE)) {
        p_0.x = -p_0.x;
        p.x = -p.x;
        theta = M_PI - theta;
    }
#endif

    temp_result[temp_i] = p;
    printf("[%2d] deg: %-6.2lf   x: %-10lf   y: %-10lf  y_target: %lf\n", 99, RAD_DEG(theta), p.x, p.y, target.y);

    vec_2d retval = { 0 };
    retval.x = fp2lf(p_0.x, DECIMAL_WIDTH(INTEGER_WIDTH, sizeof(long long))) /* * pow(K, ITERATION_2) */;
    retval.y = fp2lf(p_0.y, DECIMAL_WIDTH(INTEGER_WIDTH, sizeof(long long))) /* * pow(K, ITERATION_2) */;
    retval.a = theta;
    retval.r = (mode == VECTORING_MODE) ? retval.x : sqrt((retval.x*retval.x) + (retval.y*retval.y));
    
    

    char* buffer = graph_plot_csv(temp_result, (ITERATION * ITERATION_2) + 2);
    int buflen = strlen(buffer);

    FILE* fptr = fopen_h("plot.csv", FMD_OVERWRITE);
    fwrite(buffer, 1, buflen, fptr);
    fclose(fptr);




    return retval;
    
}