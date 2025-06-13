/**
    Bindings to C standard library math functions.

    Copyright:
        Copyright © 2023-2025, Kitsunebi Games
        Copyright © 2023-2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.c.math;

extern(C) nothrow @nogc pure:

/**
    Computes the absolute value for the given value.

    Params:
        value = the value
    
    Returns:
        The absolute value of $(D value)
*/
extern double fabs(double value);
/// ditto
extern float fabsf(float value);
/// ditto
extern int labs(int value);
/// ditto
extern long llabs(long value);

/**
    Computes the remainder of the floating point division.

    Params:
        x = The base
        y = The divisor
    
    Returns:
        The remainder of $(D x / y).
*/
extern double fmod(double x, double y);
/// ditto
extern float fmodf(float x, float y);

/**
    Computes the remainder of the floating point division.

    Note:
        As opposed to $(D fmod), the return value is $(B not)
        guaranteed to be the same sign as $(D x).

    Params:
        x = The base
        y = The divisor
    
    Returns:
        The remainder of $(D x / y).
*/
extern double remainder(double x, double y);
/// ditto
extern float remainderf(float x, float y);

/**
    Computes the fused-multiply-add operation.

    Params:
        x = value
        y = value
        z = value
    
    Returns:
        The result of $(D (x * y) + z) as a fused operation.
*/
extern double fma(double x, double y, double z);
/// ditto
extern float fmaf(float x, float y, float z);

/**
    Computes the positive difference between 2 values.

    Params:
        x = value
        y = value
    
    Returns:
        The positive difference between $(D x) and $(D y).
        If the result is negative, returns +0.
*/
extern double fdim(double x, double y);
/// ditto
extern float fdimf(float x, float y);

/**
    Computes $(I e) raised to the given power.

    Params:
        arg = The power to raise it by.
    
    Returns:
        $(I e) raised to the power of $(D arg).
*/
extern double exp(double arg);
/// ditto
extern float expf(float arg);

/**
    Computes $(I 2) raised to the given power.

    Params:
        arg = The power to raise it by.
    
    Returns:
        $(I 2) raised to the power of $(D arg).
*/
extern double exp2(double arg);
/// ditto
extern float exp2f(float arg);

/**
    Computes $(I e) raised to the given power minus one.

    Params:
        arg = The power to raise it by.
    
    Returns:
        $(I e) raised to the power of $(D arg), subtracted by 1.
*/
extern double expm1(double arg);
/// ditto
extern float expm1f(float arg);

/**
    Computes the natural (base-e) logarithm.

    Params:
        arg = The value to compute the logarithm of
    
    Returns:
        The natural base logarithm of $(D arg).
*/
extern double log(double arg);
/// ditto
extern float logf(float arg);

/**
    Computes the common (base-10) logarithm.

    Params:
        arg = The value to compute the logarithm of
    
    Returns:
        The common base logarithm of $(D arg).
*/
extern double log10(double arg);
/// ditto
extern float log10f(float arg);

/**
    Computes the binary (base-2) logarithm.

    Params:
        arg = The value to compute the logarithm of
    
    Returns:
        The base-2 logarithm of $(D arg).
*/
extern double log2(double arg);
/// ditto
extern float log2f(float arg);

/**
    Computes a value raised to a given power.

    Params:
        x = The base
        y = The power
    
    Returns:
        $(D x) raised to the power of $(D y)
*/
extern double pow(double x, double y);
/// ditto
extern float powf(float x, float y);

/**
    Computes the square root of the given value.

    Params:
        x = The value
    
    Returns:
        The square root of $(D x).
*/
extern double sqrt(double x);
/// ditto
extern float sqrtf(float x);

/**
    Computes the cube root of the given value.

    Params:
        x = The value
    
    Returns:
        The cube root of $(D x).
*/
extern double cbrt(double x);
/// ditto
extern float cbrtf(float x);

/**
    Computes the square root of the sum of the squares of the 
    given values.

    Params:
        x = value
        y = value
    
    Returns:
        The equivalent of $(D sqrt(pow(x, 2) + pow(y, 2))).
*/
extern double hypot(double x, double y);
/// ditto
extern float hypotf(float x, float y);

/**
    Computes sine of the given value.

    Params:
        x = The value
    
    Returns:
        The sine of $(D x).
*/
extern double sin(double x);
/// ditto
extern float sinf(float x);

/**
    Computes cosine of the given value.

    Params:
        x = The value
    
    Returns:
        The cosine of $(D x).
*/
extern double cos(double x);
/// ditto
extern float cosf(float x);

/**
    Computes tangent of the given value.

    Params:
        x = The value
    
    Returns:
        The tangent of $(D x).
*/
extern double tan(double x);
/// ditto
extern float tanf(float x);

/**
    Computes arc-sine of the given value.

    Params:
        x = The value
    
    Returns:
        The arc-sine of $(D x).
*/
extern double asin(double x);
/// ditto
extern float asinf(float x);

/**
    Computes arc-cosine of the given value.

    Params:
        x = The value
    
    Returns:
        The arc-cosine of $(D x).
*/
extern double acos(double x);
/// ditto
extern float acosf(float x);

/**
    Computes arc-tangent of the given value.

    Params:
        x = The value
    
    Returns:
        The arc-tangent of $(D x).
*/
extern double atan(double x);
/// ditto
extern float atanf(float x);

/**
    Computes arc-tangent of the given value, using signs to determine quadrant.

    Params:
        y = value
        x = value
    
    Returns:
        The arc-tangent of $(D y / x).
*/
extern double atan2(double y, double x);
/// ditto
extern float atan2f(float y, float x);

/**
    Computes hyperbolic sine of the given value.

    Params:
        x = The value
    
    Returns:
        The hyperbolic sine of $(D x).
*/
extern double sinh(double x);
/// ditto
extern float sinhf(float x);

/**
    Computes hyperbolic cosine of the given value.

    Params:
        x = The value
    
    Returns:
        The hyperbolic cosine of $(D x).
*/
extern double cosh(double x);
/// ditto
extern float coshf(float x);

/**
    Computes hyperbolic tangent of the given value.

    Params:
        x = The value
    
    Returns:
        The hyperbolic tangent of $(D x).
*/
extern double tanh(double x);
/// ditto
extern float tanhf(float x);

/**
    Computes hyperbolic arc-sine of the given value.

    Params:
        x = The value
    
    Returns:
        The hyperbolic arc-sine of $(D x).
*/
extern double asinh(double x);
/// ditto
extern float asinhf(float x);

/**
    Computes hyperbolic arc-cosine of the given value.

    Params:
        x = The value
    
    Returns:
        The hyperbolic arc-cosine of $(D x).
*/
extern double acosh(double x);
/// ditto
extern float acoshf(float x);

/**
    Computes hyperbolic arc-tangent of the given value.

    Params:
        x = The value
    
    Returns:
        The hyperbolic arc-tangent of $(D x).
*/
extern double atanh(double x);
/// ditto
extern float atanhf(float x);

/**
    Computes the error function of the given value.

    Params:
        x = The value
    
    Returns:
        The error function of $(D x).

    See_Also:
        $(LINK2 https://en.wikipedia.org/wiki/Error_function, Error Function on Wikipedia)
*/
extern double erf(double x);
/// ditto
extern float erff(float x);

/**
    Computes the complementary error function of the given value.

    Params:
        x = The value
    
    Returns:
        The complementary error function of $(D x).

    See_Also:
        $(LINK2 https://en.wikipedia.org/wiki/Error_function#Complementary_error_function, Error Function on Wikipedia)
*/
extern double erfc(double x);
/// ditto
extern float erfcf(float x);

/**
    Computes the gamma function of the given value.

    Params:
        x = The value
    
    Returns:
        The gamma function of $(D x).

    See_Also:
        $(LINK2 https://en.wikipedia.org/wiki/Gamma_function, Gamma Function on Wikipedia)
*/
extern double tgamma(double x);
/// ditto
extern float tgammaf(float x);

/**
    Computes the natural (base-e) logarithm of the gamma function 
    of the given value.

    Params:
        x = The value
    
    Returns:
        The natural logarithm of the gamma function of $(D x).

    See_Also:
        $(LINK2 https://en.wikipedia.org/wiki/Gamma_function, Gamma Function on Wikipedia)
*/
extern double lgamma(double x);
/// ditto
extern float lgammaf(float x);

/**
    Computes the nearest integer value greater than the given value.

    Params:
        x = The value
    
    Returns:
        The nearest integer value greater than $(D x).
*/
extern double ceil(double x);
/// ditto
extern float ceilf(float x);

/**
    Computes the nearest integer value lower than the given value.

    Params:
        x = The value
    
    Returns:
        The nearest integer value lower than $(D x).
*/
extern double floor(double x);
/// ditto
extern float floorf(float x);

/**
    Computes the nearest integer value lower in magnitude than
    the given value.

    Params:
        x = The value
    
    Returns:
        The nearest integer value lower in magnitude than $(D x).
*/
extern double trunc(double x);
/// ditto
extern float truncf(float x);

/**
    Computes the nearest integer value, rounded away from 0.

    Params:
        x = The value
    
    Returns:
        The nearest integer value to $(D x).
*/
extern double round(double x);
/// ditto
extern float roundf(float x);
