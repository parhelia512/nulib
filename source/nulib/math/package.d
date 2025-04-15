/**
    Math Functions

    Important:
        When possible compiler level intrinsics will be used, but in some cases
        this is not possible; in those cases we opt to focus on readability over performance.

        As such these math functions may not be the most performant.

    Copyright: Copyright The D Language Foundation 2000 - 2011.
    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(HTTP www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
    Authors:
        $(HTTP digitalmars.com, Walter Bright), 
        Don Clugston,
        Luna Nielsen

    Macros:
        SUB = $1<sub>$2</sub>
        PI = &pi;
        SQRT = &radic;
        HALF = &frac12;
*/
module nulib.math;
public import core.math;

// Values obtained from Wolfram Alpha. 116 bits ought to be enough for anybody.
// Wolfram Alpha LLC. 2011. Wolfram|Alpha. http://www.wolframalpha.com/input/?i=e+in+base+16 (access July 6, 2011).
enum real E =          0x1.5bf0a8b1457695355fb8ac404e7a8p+1L; /** e = 2.718281... */
enum real LOG2T =      0x1.a934f0979a3715fc9257edfe9b5fbp+1L; /** $(SUB log, 2)10 = 3.321928... */
enum real LOG2E =      0x1.71547652b82fe1777d0ffda0d23a8p+0L; /** $(SUB log, 2)e = 1.442695... */
enum real LOG2 =       0x1.34413509f79fef311f12b35816f92p-2L; /** $(SUB log, 10)2 = 0.301029... */
enum real LOG10E =     0x1.bcb7b1526e50e32a6ab7555f5a67cp-2L; /** $(SUB log, 10)e = 0.434294... */
enum real LN2 =        0x1.62e42fefa39ef35793c7673007e5fp-1L; /** ln 2  = 0.693147... */
enum real LN10 =       0x1.26bb1bbb5551582dd4adac5705a61p+1L; /** ln 10 = 2.302585... */
enum real PI =         0x1.921fb54442d18469898cc51701b84p+1L; /** &pi; = 3.141592... */
enum real PI_2 =       PI/2;                                  /** $(PI) / 2 = 1.570796... */
enum real PI_4 =       PI/4;                                  /** $(PI) / 4 = 0.785398... */
enum real M_1_PI =     0x1.45f306dc9c882a53f84eafa3ea69cp-2L; /** 1 / $(PI) = 0.318309... */
enum real M_2_PI =     2*M_1_PI;                              /** 2 / $(PI) = 0.636619... */
enum real M_2_SQRTPI = 0x1.20dd750429b6d11ae3a914fed7fd8p+0L; /** 2 / $(SQRT)$(PI) = 1.128379... */
enum real SQRT2 =      0x1.6a09e667f3bcc908b2fb1366ea958p+0L; /** $(SQRT)2 = 1.414213... */
enum real SQRT1_2 =    SQRT2/2;                               /** $(SQRT)$(HALF) = 0.707106... */

/**
    Returns the larger of the 2 given scalar values.

    Params:
        rhs = value
        lhs = value
    
    Returns:
        The largest of the 2 given values.
*/
T max(T)(T lhs, T rhs) if (__traits(isScalar, T)) {
    return lhs > rhs ? lhs : rhs;
}

/**
    Returns the smaller of the 2 given scalar values.

    Params:
        rhs = value
        lhs = value
    
    Returns:
        The smallest of the 2 given values.
*/
T min(T)(T lhs, T rhs) if (__traits(isScalar, T)) {
    return lhs < rhs ? lhs : rhs;
}

/**
    Clamps scalar value into the given range.

    Params:
        value   = The value to clamp,
        min_    = The minimum value
        max_    = The maximum value.
    
    Returns:
        $(D value) clamped between $(D min_) and $(D max_),
        equivalent of $(D min(max(value, min_), max_))
*/
T clamp(T)(T value, T min_, T max_) if (__traits(isScalar, T))  {
    return min(max(value, min_), max_);
}

/**
    Determines whether the given value is NaN (Not a Number)

    Params:
        x   = The value to check
    
    Returns:
        $(D true) if $(D x) is NaN,
        $(D false) otherwise.
*/
bool isNaN(T)(T x) @safe @nogc nothrow pure if (__traits(isFloating, T)) {
    return x != x;
}

/**
    Determines whether the given value is a finite number.

    Params:
        x   = The value to check
    
    Returns:
        $(D true) if $(D x) is a finite, valid number,
        $(D false) otherwise.
*/
bool isFinite(T)(T x) @safe @nogc nothrow pure if (__traits(isFloating, T)) {
    return x == x && x != T.infinity && x != -T.infinity;
}

/**
    Determines whether the given value is an infinite number.

    Params:
        x   = The value to check
    
    Returns:
        $(D true) if $(D x) is an infinite floating point number,
        $(D false) otherwise.
*/
bool isInfinity(T)(T x) @safe @nogc nothrow pure if (__traits(isFloating, T)) {
    static if (is(T == float)) {
        return ((*cast(uint *)&x) & 0x7FFF_FFFF) == 0x7F80_0000;
    } else static if (is(T == double)) {
        return ((*cast(ulong *)&x) & 0x7FFF_FFFF_FFFF_FFFF)
            == 0x7FF0_0000_0000_0000;
    } else return (x < -T.max) || (T.max < x);
}

/**
    Gets whether the value's sign bit is set.

*/
bool signbit(T)(T x) @trusted @nogc nothrow pure {
    static if (__traits(isFloating, T)) {

        double tmp = cast(double)x;
        return 0 > (*cast(long*)&tmp);
    } else {

        return 0 > x;
    }
}

/**
    Gets the given value with the sign bit of another.
*/
T copysign(T)(T to, T from) @safe @nogc nothrow pure {
    return signbit(to) == signbit(from) ? to : -to;
}

// NOTE:    Currently support for `real` arithmetic is not implemented for the
//          non-IEEE `real` format. Only float and double are supported by these
//          functions

/**
    Computes tangent of the given value.

    Params:
        x = The value
    
    Returns:
        The tangent of $(D x).
*/
T tan(T)(T x) @safe @nogc nothrow pure {
    version(LLVM) {
        return cast(T)__llvm_tan(x);
    } else {
        static if (is(T == float) && T.mant_dig == 24) {
            static immutable T[6] P = [
                3.33331568548E-1,
                1.33387994085E-1,
                5.34112807005E-2,
                2.44301354525E-2,
                3.11992232697E-3,
                9.38540185543E-3,
            ];

            enum T P1 = 0.78515625;
            enum T P2 = 2.4187564849853515625E-4;
            enum T P3 = 3.77489497744594108E-8;
            
        } else static if (is(T == double)) {
            static immutable T[3] P = [
            -1.7956525197648487798769E7L,
                1.1535166483858741613983E6L,
            -1.3093693918138377764608E4L,
            ];
            static immutable T[5] Q = [
            -5.3869575592945462988123E7L,
                2.5008380182335791583922E7L,
            -1.3208923444021096744731E6L,
                1.3681296347069295467845E4L,
                1.0000000000000000000000E0L,
            ];

            enum T P1 = 7.853981554508209228515625E-1L;
            enum T P2 = 7.946627356147928367136046290398E-9L;
            enum T P3 = 3.061616997868382943065164830688E-17L;
            
        } else static assert(0, T.stringof~" is not supported currently!");

        // Special cases.
        if (x == cast(T) 0.0 || isNaN(x))
            return x;
        if (isInfinity(x))
            return T.nan;

        bool sign = signbit(x);
        if (sign)
            x = -1;
    }
}

/**
    Computes arc-tangent of the given value.

    Params:
        x = The value
    
    Returns:
        The arc-tangent of $(D x).
*/
T atan(T)(T x) @safe @nogc nothrow pure {
    version(LLVM) {
        return cast(T)__llvm_atan(x);
    } else {
        static if (is(T == float) && T.mant_dig == 24) {

            static immutable T[4] P = [
            -3.33329491539E-1,
                1.99777106478E-1,
            -1.38776856032E-1,
                8.05374449538E-2,
            ];
        } else static if (is(T == double)) {

            static immutable T[5] P = [
            -6.485021904942025371773E1L,
            -1.228866684490136173410E2L,
            -7.500855792314704667340E1L,
            -1.615753718733365076637E1L,
            -8.750608600031904122785E-1L,
            ];
            static immutable T[6] Q = [
                1.945506571482613964425E2L,
                4.853903996359136964868E2L,
                4.328810604912902668951E2L,
                1.650270098316988542046E2L,
                2.485846490142306297962E1L,
                1.000000000000000000000E0L,
            ];

            enum T MOREBITS = 6.123233995736765886130E-17L;
            
        } else static assert(0, T.stringof~" is not supported currently!");

        // tan(PI/8)
        enum T TAN_PI_8 = 0.414213562373095048801688724209698078569672L;

        // tan(3 * PI/8)
        enum T TAN3_PI_8 = 2.414213562373095048801688724209698078569672L;

        // Special cases.
        if (x == cast(T) 0.0)
            return x;
        if (isInfinity(x))
            return copysign(cast(T) PI_2, x);

        // Make argument positive but save the sign.
        bool sign = false;
        if (signbit(x)) {
            sign = true;
            x = -x;
        }

        static if (is(T == float) && T.mant_dig == 24) {

            // Range reduction.
            T y;
            if (x > TAN3_PI_8) {

                y = PI_2;
                x = -((cast(T) 1.0) / x);
            } else if (x > TAN_PI_8) {
                
                y = PI_4;
                x = (x - cast(T) 1.0)/(x + cast(T) 1.0);
            } else y = 0.0;

            // Rational form in x^^2.
            const T z = x * x;
            y += poly(z, P) * z * x + x;
            
        } else {
            short flag = 0;
            T y;
            if (x > TAN3_PI_8) {
                y = PI_2;
                flag = 1;
                x = -(1.0 / x);
            } else if (x <= 0.66) {
                y = 0.0;
            } else {
                y = PI_4;
                flag = 2;
                x = (x - 1.0)/(x + 1.0);
            }

            T z = x * x;
            z = z * poly(z, P) / poly(z, Q);
            z = x * z + x;

            if (flag == 2)
                z += 0.5 * MOREBITS;
            else if (flag == 1)
                z += MOREBITS;
            
            y = y + z;
        }

        return sign ? -y : y;
    }
}

/**
    Computes arc-tangent of the given value, using signs to determine quadrant.

    Params:
        y = value
        x = value
    
    Returns:
        The arc-tangent of $(D y / x).
*/
T atan2(T)(T y, T x) @safe pure nothrow @nogc {
    version(LLVM) {
        return cast(T)__llvm_atan2(x);
    } else {

        // Special cases.
        if (isNaN(x) || isNaN(y))
            return T.nan;
        
        if (y == cast(T) 0.0) {
            if (x >= 0 && !signbit(x))
                return copysign(0, y);
            else
                return copysign(cast(T) PI, y);
        } if (x == cast(T) 0.0)
            return copysign(cast(T) PI_2, y);
        
        if (isInfinity(x)) {
            if (signbit(x)) {
                if (isInfinity(y))
                    return copysign(3 * cast(T) PI_4, y);
                else
                    return copysign(cast(T) PI, y);
            } else {
                if (isInfinity(y))
                    return copysign(cast(T) PI_4, y);
                else
                    return copysign(cast(T) 0.0, y);
            }
        }

        if (isInfinity(y))
            return copysign(cast(T) PI_2, y);

        // Call atan and determine the quadrant.
        T z = atan(y / x);

        if (signbit(x)) {
            if (signbit(y))
                z = z - cast(T) PI;
            else
                z = z + cast(T) PI;
        }

        if (z == cast(T) 0.0)
            return copysign(z, y);

        return z;
    }
}

//
//      Compiler Specific Intrinsics
//

version(LLVM) {
private:
    pragma(LDC_intrinsic, "llvm.tan.f32")
    float __llvm_tan(float);

    pragma(LDC_intrinsic, "llvm.tan.f64")
    double __llvm_tan(double);

    pragma(LDC_intrinsic, "llvm.atan.f32")
    float __llvm_atan(float);

    pragma(LDC_intrinsic, "llvm.atan.f64")
    double __llvm_atan(double);

    pragma(LDC_intrinsic, "llvm.atan2.f32")
    float __llvm_atan2(float);

    pragma(LDC_intrinsic, "llvm.atan2.f64")
    double __llvm_atan2(double);

} else version(GDC) {

} else {

}

//
//      Private Helpers
//

private:
T poly(T)(T x, T[] y) @safe @nogc nothrow pure {
    ptrdiff_t i = y.length - 1;
    T r = y[i];
    while (--i >= 0) {
        r *= x;
        r += y[i];
    }
    return r;
}
