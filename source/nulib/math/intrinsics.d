/**
    Bindings to compiler-specific intrinsics wrapped in a nicer interface.

    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(HTTP www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
    Authors:
        Luna Nielsen
*/
module nulib.math.intrinsics;
import nulib.math.fixed;
import dmath = core.math;

version (GNU) import gcc.builtins;
else version (LDC) import ldc.intrinsics;
else {
    import nmath = nulib.math.floating;
    import cmath = core.stdc.math;
}

@safe @nogc nothrow pure:

/**
    Computes the square root of the given value.

    Params:
        x = The value
    
    Returns:
        The square root of $(D x).
*/
pragma(inline, true)
T sqrt(T)(T x) if (__traits(isFloating, T)) {
    return dmath.sqrt(x);
}

/**
    Computes sine of the given value.

    Params:
        x = The value
    
    Returns:
        The sine of $(D x).
*/
pragma(inline, true)
T sin(T)(T x) if (__traits(isFloating, T)) {
    version(LDC) {
        return llvm_sin!T(x);
    } else version(GNU) {
        static if (is(T == float))
            return __builtin_sinf(x);
        else static if (is(T == double))
            return __builtin_sin(x);
        else static if (is(T == real))
            return __builtin_sinl(x);
    } else {
        static if (is(T == float))
            return cmath.sinf(x);
        else static if (is(T == double))
            return cmath.sin(x);
        else static if (is(T == real))
            return cmath.sinl(x);
    }
}

/**
    Computes cosine of the given value.

    Params:
        x = The value
    
    Returns:
        The cosine of $(D x).
*/
pragma(inline, true)
T cos(T)(T x) if (__traits(isFloating, T)) {
    version(LDC) {
        return llvm_cos!T(x);
    } else version(GNU) {
        static if (is(T == float))
            return __builtin_cosf(x);
        else static if (is(T == double))
            return __builtin_cos(x);
        else static if (is(T == real))
            return __builtin_cosl(x);
    } else {
        static if (is(T == float))
            return cmath.cosf(x);
        else static if (is(T == double))
            return cmath.cos(x);
        else static if (is(T == real))
            return cmath.cosl(x);
    }
}

/**
    Computes tangent of the given value.

    Params:
        x = The value
    
    Returns:
        The tangent of $(D x).
*/
pragma(inline, true)
T tan(T)(T x) if (__traits(isFloating, T)) {
    version(LDC) {
        return llvm_tan!T(x);
    } else version(GNU) {
        static if (is(T == float))
            return __builtin_tanf(x);
        else static if (is(T == double))
            return __builtin_tan(x);
        else static if (is(T == real))
            return __builtin_tanl(x);
    } else {
        static if (is(T == float))
            return cmath.tanf(x);
        else static if (is(T == double))
            return cmath.tan(x);
        else static if (is(T == real))
            return cmath.tanl(x);
    }
}

/**
    Computes arc-sine of the given value.

    Params:
        x = The value
    
    Returns:
        The arc-sine of $(D x).
*/
pragma(inline, true)
T asin(T)(T x) if (__traits(isFloating, T)) {
    version(LDC) {
        return llvm_asin!T(x);
    } else version(GNU) {
        static if (is(T == float))
            return __builtin_asinf(x);
        else static if (is(T == double))
            return __builtin_asin(x);
        else static if (is(T == real))
            return __builtin_asinl(x);
    } else {
        static if (is(T == float))
            return cmath.asinf(x);
        else static if (is(T == double))
            return cmath.asin(x);
        else static if (is(T == real))
            return cmath.asinl(x);
    }
}

/**
    Computes arc-cosine of the given value.

    Params:
        x = The value
    
    Returns:
        The arc-cosine of $(D x).
*/
pragma(inline, true)
T acos(T)(T x) if (__traits(isFloating, T)) {
    version(LDC) {
        return llvm_acos!T(x);
    } else version(GNU) {
        static if (is(T == float))
            return __builtin_acosf(x);
        else static if (is(T == double))
            return __builtin_acos(x);
        else static if (is(T == real))
            return __builtin_acosl(x);
    } else {
        static if (is(T == float))
            return cmath.acosf(x);
        else static if (is(T == double))
            return cmath.acos(x);
        else static if (is(T == real))
            return cmath.acosl(x);
    }
}

/**
    Computes arc-tangent of the given value.

    Params:
        x = The value
    
    Returns:
        The arc-tangent of $(D x).
*/
pragma(inline, true)
T atan(T)(T x) if (__traits(isFloating, T)) {
    version(LDC) {
        return llvm_atan!T(x);
    } else version(GNU) {
        static if (is(T == float))
            return __builtin_atanf(x);
        else static if (is(T == double))
            return __builtin_atan(x);
        else static if (is(T == real))
            return __builtin_atanl(x);
    } else version(DigitalMars) {
        return nmath.atan(x); 
    } else {
        static if (is(T == float))
            return cmath.atanf(x);
        else static if (is(T == double))
            return cmath.atan(x);
        else static if (is(T == real))
            return cmath.atanl(x);
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
pragma(inline, true)
T atan2(T)(T y, T x) if (__traits(isFloating, T)) {
    version(LDC) {
        return llvm_atan2!T(y, x);
    } else version(GNU) {
        static if (is(T == float))
            return __builtin_atan2f(y, x);
        else static if (is(T == double))
            return __builtin_atan2(y, x);
        else static if (is(T == real))
            return __builtin_atan2l(y, x);
    } else version(DigitalMars) {
        return nmath.atan2(y, x); 
    } else {
        static if (is(T == float))
            return cmath.atan2f(y, x);
        else static if (is(T == double))
            return cmath.atan2(y, x);
        else static if (is(T == real))
            return cmath.atan2l(y, x);
    }
}

/**
    Computes hyperbolic sine of the given value.

    Params:
        x = The value
    
    Returns:
        The hyperbolic sine of $(D x).
*/
pragma(inline, true)
T sinh(T)(T x) if (__traits(isFloating, T)) {
    version(LDC) {
        return llvm_sinh!T(x);
    } else version(GNU) {
        static if (is(T == float))
            return __builtin_sinhf(x);
        else static if (is(T == double))
            return __builtin_sinh(x);
        else static if (is(T == real))
            return __builtin_sinhl(x);
    } else {
        static if (is(T == float))
            return cmath.sinhf(x);
        else static if (is(T == double))
            return cmath.sinh(x);
        else static if (is(T == real))
            return cmath.sinhl(x);
    }
}

/**
    Computes hyperbolic cosine of the given value.

    Params:
        x = The value
    
    Returns:
        The hyperbolic cosine of $(D x).
*/
pragma(inline, true)
T cosh(T)(T x) if (__traits(isFloating, T)) {
    version(LDC) {
        return llvm_cosh!T(x);
    } else version(GNU) {
        static if (is(T == float))
            return __builtin_coshf(x);
        else static if (is(T == double))
            return __builtin_cohs(x);
        else static if (is(T == real))
            return __builtin_coshl(x);
    } else {
        static if (is(T == float))
            return cmath.coshf(x);
        else static if (is(T == double))
            return cmath.cosh(x);
        else static if (is(T == real))
            return cmath.coshl(x);
    }
}

/**
    Computes hyperbolic tangent of the given value.

    Params:
        x = The value
    
    Returns:
        The hyperbolic tangent of $(D x).
*/
pragma(inline, true)
T tanh(T)(T x) if (__traits(isFloating, T)) {
    version(LDC) {
        return llvm_tanh!T(x);
    } else version(GNU) {
        static if (is(T == float))
            return __builtin_tanhf(x);
        else static if (is(T == double))
            return __builtin_tanh(x);
        else static if (is(T == real))
            return __builtin_tanhl(x);
    } else {
        static if (is(T == float))
            return cmath.tanhf(x);
        else static if (is(T == double))
            return cmath.tanh(x);
        else static if (is(T == real))
            return cmath.tanhl(x);
    }
}

/**
    Computes hyperbolic arc-sine of the given value.

    Params:
        x = The value
    
    Returns:
        The hyperbolic arc-sine of $(D x).
*/
pragma(inline, true)
T asinh(T)(T x) if (__traits(isFloating, T)) {
    version(LDC) {
        return llvm_asin!T(x);
    } else version(GNU) {
        static if (is(T == float))
            return __builtin_asinhf(x);
        else static if (is(T == double))
            return __builtin_asinh(x);
        else static if (is(T == real))
            return __builtin_asinhl(x);
    } else {
        static if (is(T == float))
            return cmath.asinhf(x);
        else static if (is(T == double))
            return cmath.asinh(x);
        else static if (is(T == real))
            return cmath.asinhl(x);
    }
}

/**
    Computes hyperbolic arc-cosine of the given value.

    Params:
        x = The value
    
    Returns:
        The hyperbolic arc-cosine of $(D x).
*/
pragma(inline, true)
T acosh(T)(T x) if (__traits(isFloating, T)) {
    version(LDC) {
        return llvm_acosh!T(x);
    } else version(GNU) {
        static if (is(T == float))
            return __builtin_acoshf(x);
        else static if (is(T == double))
            return __builtin_acosh(x);
        else static if (is(T == real))
            return __builtin_acoshl(x);
    } else {
        static if (is(T == float))
            return cmath.acoshf(x);
        else static if (is(T == double))
            return cmath.acosh(x);
        else static if (is(T == real))
            return cmath.acoshl(x);
    }
}

/**
    Computes hyperbolic arc-tangent of the given value.

    Params:
        x = The value
    
    Returns:
        The hyperbolic arc-tangent of $(D x).
*/
pragma(inline, true)
T atanh(T)(T x) if (__traits(isFloating, T)) {
    version(LDC) {
        return llvm_atanh!T(x);
    } else version(GNU) {
        static if (is(T == float))
            return __builtin_atanhf(x);
        else static if (is(T == double))
            return __builtin_atanh(x);
        else static if (is(T == real))
            return __builtin_atanhl(x);
    } else {
        static if (is(T == float))
            return cmath.atanhf(x);
        else static if (is(T == double))
            return cmath.atanh(x);
        else static if (is(T == real))
            return cmath.atanhl(x);
    }
}

/**
    Computes the nearest integer value lower in magnitude than
    the given value.

    Params:
        x = The value
    
    Returns:
        The nearest integer value lower in magnitude than $(D x).
*/
pragma(inline, true)
T trunc(T)(T x) if (__traits(isFloating, T)) {
    version(LDC) {
        return llvm_trunc!T(x);
    } else version(GNU) {
        static if (is(T == float))
            return __builtin_truncf(x);
        else static if (is(T == double))
            return __builtin_trunc(x);
        else static if (is(T == real))
            return __builtin_truncl(x);
    } else {
        static if (is(T == float))
            return cmath.truncf(x);
        else static if (is(T == double))
            return cmath.trunc(x);
        else static if (is(T == real))
            return cmath.truncl(x);
    }
}

/**
    Computes the nearest integer value, rounded away from 0.

    Params:
        value = Input value
    
    Returns:
        The nearest integer value to $(D x).
*/
T round(T)(T value) if (__traits(isFloating, T)) {
    version(LDC) {
        return llvm_round!T(value);
    } else version(GNU) {
        static if (is(T == float))
            return __builtin_roundf(value);
        else static if (is(T == double))
            return __builtin_round(value);
        else static if (is(T == real))
            return __builtin_roundl(value);
    } else {
        static if (is(T == float))
            return cmath.roundf(value);
        else static if (is(T == double))
            return cmath.round(value);
        else static if (is(T == real))
            return cmath.roundl(value);
    }
}

/**
    Computes the nearest integer value lower than the given value.

    Params:
        value = Input value
    
    Returns:
        The nearest integer value lower than $(D x).
*/
pragma(inline, true)
T floor(T)(T value) if (__traits(isFloating, T)) {
    version(LDC) {
        return llvm_floor!T(value);
    } else version(GNU) {
        static if (is(T == float))
            return __builtin_floorf(value);
        else static if (is(T == double))
            return __builtin_floor(value);
        else static if (is(T == real))
            return __builtin_floorl(value);
    } else {
        static if (is(T == float))
            return cmath.floorf(value);
        else static if (is(T == double))
            return cmath.floor(value);
        else static if (is(T == real))
            return cmath.floorl(value);
    }
}

/**
    Computes the nearest integer value lower than the given value.

    Params:
        value = Input value
    
    Returns:
        The nearest integer value lower than $(D x).
*/
pragma(inline, true)
T ceil(T)(T value) if (__traits(isFloating, T)) {
    version(LDC) {
        return llvm_ceil!T(value);
    } else version(GNU) {
        static if (is(T == float))
            return __builtin_ceilf(value);
        else static if (is(T == double))
            return __builtin_ceil(value);
        else static if (is(T == real))
            return __builtin_ceill(value);
    } else {
        static if (is(T == float))
            return cmath.ceilf(value);
        else static if (is(T == double))
            return cmath.ceil(value);
        else static if (is(T == real))
            return cmath.ceill(value);
    }
}

/**
    Computes the absolute value for the given value.

    Params:
        value = the value
    
    Returns:
        The absolute value of $(D value)
*/
pragma(inline, true)
T abs(T)(T value) if (__traits(isScalar, T)) {
    static if (__traits(isFloating, T)) {
        return dmath.fabs(x);
    } else {
        return value < 0 ? -value : value;
    }
}

/**
    Rounds the given value to the nearest integer,
    using the current rounding mode.

    Params:
        x = The value
    
    Returns:
        $(D x) rounded to the nearest integer 
        in respect to rounding mode.
*/
pragma(inline, true)
T rint(T)(T x) if (__traits(isFloating, T)) {
    return dmath.rint(x);
}

/**
    Computes n * 2$(SUPERSCRIPT exp).

    Params:
        n =     The value
        exp =   The exponent
    
    Returns:
        $(D value * pow(exp, 2)).
*/
pragma(inline, true)
T ldexp(T)(T n, int exp) if (__traits(isFloating, T)) {
    return dmath.ldexp(n, exp);
}



//
//          EXTRAS
//
private:

version(LDC) {

    // Trigonometry
    pragma(LDC_intrinsic, "llvm.tan.f#")
    T llvm_tan(T)(T val) if (__traits(isFloating, T));
    

    pragma(LDC_intrinsic, "llvm.asin.f#")
    T llvm_asin(T)(T val) if (__traits(isFloating, T));
    
    pragma(LDC_intrinsic, "llvm.acos.f#")
    T llvm_acos(T)(T val) if (__traits(isFloating, T));
    
    pragma(LDC_intrinsic, "llvm.atan.f#")
    T llvm_atan(T)(T val) if (__traits(isFloating, T));

    pragma(LDC_intrinsic, "llvm.atan2.f#")
    T llvm_atan2(T)(T y, T x) if (__traits(isFloating, T));
    
    
    pragma(LDC_intrinsic, "llvm.sinh.f#")
    T llvm_sinh(T)(T val) if (__traits(isFloating, T));
    
    pragma(LDC_intrinsic, "llvm.cosh.f#")
    T llvm_cosh(T)(T val) if (__traits(isFloating, T));
    
    pragma(LDC_intrinsic, "llvm.tanh.f#")
    T llvm_tanh(T)(T val) if (__traits(isFloating, T));
    
    

    pragma(LDC_intrinsic, "llvm.asinh.f#")
    T llvm_asinh(T)(T val) if (__traits(isFloating, T));
    
    pragma(LDC_intrinsic, "llvm.acosh.f#")
    T llvm_acosh(T)(T val) if (__traits(isFloating, T));
    
    pragma(LDC_intrinsic, "llvm.atanh.f#")
    T llvm_atanh(T)(T val) if (__traits(isFloating, T));
}