/**
    D Math Intrinsics

    Copyright: Copyright The D Language Foundation 2000 - 2011.
    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(HTTP www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
    Authors:
        $(HTTP digitalmars.com, Walter Bright), 
        Don Clugston,
        Luna Nielsen
*/
module core.math;

//
//          D Math Intrinsics
//

version(LLVM) {
    import ldc.intrinsics;

    alias sin = llvm_sin!float;
    alias sin = llvm_sin!double;
    alias sin = llvm_sin!real;

    alias cos = llvm_cos!float;
    alias cos = llvm_cos!double;
    alias cos = llvm_cos!real;

    // http://llvm.org/docs/LangRef.html#llvm-sqrt-intrinsic
    // sqrt(x) when x is less than zero is undefined
    pragma(inline, true) {
        float  sqrt(float  x) { return x < 0 ? float.nan  : llvm_sqrt(x); }
        double sqrt(double x) { return x < 0 ? double.nan : llvm_sqrt(x); }
        real   sqrt(real   x) { return x < 0 ? real.nan   : llvm_sqrt(x); }
    }

    alias fabs = llvm_fabs!float;
    alias fabs = llvm_fabs!double;
    alias fabs = llvm_fabs!real;
    
    alias rint = llvm_rint!float;
    alias rint = llvm_rint!double;
    alias rint = llvm_rint!real;
} else {

    /**
        Computes the absolute value for the given value.

        Params:
            value = the value
        
        Returns:
            The absolute value of $(D value)
    */
    float fabs(float x) @safe @nogc nothrow pure;
    double fabs(double x) @safe @nogc nothrow pure; // ditto
    real fabs(real x) @safe @nogc nothrow pure; // ditto

    /**
        Computes sine of the given value.

        Params:
            x = The value
        
        Returns:
            The sine of $(D x).
    */
    float sin(float x) @safe @nogc nothrow pure;
    double sin(double x) @safe @nogc nothrow pure; // ditto
    real sin(real x) @safe @nogc nothrow pure; // ditto

    /**
        Computes cosine of the given value.

        Params:
            x = The value
        
        Returns:
            The cosine of $(D x).
    */
    float cos(float x) @safe @nogc nothrow pure;
    double cos(double x) @safe @nogc nothrow pure; // ditto
    real cos(real x) @safe @nogc nothrow pure; // ditto

    /**
        Computes the square root of the given value.

        Params:
            x = The value
        
        Returns:
            The square root of $(D x).
    */
    float sqrt(float x) @safe @nogc nothrow pure;
    double sqrt(double x) @safe @nogc nothrow pure; // ditto
    real sqrt(real x) @safe @nogc nothrow pure; // ditto

    /**
        Computes n * 2$(SUPERSCRIPT exp).

        Params:
            n =     The value
            exp =   The exponent
        
        Returns:
            $(D value * pow(exp, 2)).
    */
    float ldexp(float n, int exp) @safe @nogc nothrow pure;   
    double ldexp(double n, int exp) @safe @nogc nothrow pure; /// ditto
    real ldexp(real n, int exp) @safe @nogc nothrow pure;     /// ditto

    /**
        Computes y * log2(x).

        Params:
            x = value
            y = value
        
        Returns:
            $(D y * log2(x)).
    */
    float yl2x(float x, float y) @safe @nogc nothrow pure;   
    double yl2x(double x, double y) @safe @nogc nothrow pure; /// ditto
    real yl2x(real x, real y) @safe @nogc nothrow pure;       /// ditto

    /**
        Computes y * log2(x+1).

        Params:
            x = value
            y = value
        
        Returns:
            $(D y * log2(x+1)).
    */
    float yl2xp1(float x, float y) @safe @nogc nothrow pure;   
    double yl2xp1(double x, double y) @safe @nogc nothrow pure; /// ditto
    real yl2xp1(real x, real y) @safe @nogc nothrow pure;       /// ditto

    /**
        Rounds the given value to the nearest integer,
        using the current rounding mode.

        Params:
            x = The value
        
        Returns:
            $(D x) rounded to the nearest integer 
            in respect to rounding mode.
    */
    float rint(float x) @safe @nogc nothrow pure;   
    double rint(double x) @safe @nogc nothrow pure; /// ditto
    real rint(real x) @safe @nogc nothrow pure;     /// ditto
}