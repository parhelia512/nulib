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

version(LDC) {
public:
@nogc nothrow @safe pure:
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

    float  ldexp(float  n, int exp) { return ldexpImpl(n, exp); }
    double ldexp(double n, int exp) { return ldexpImpl(n, exp); }
    real ldexp(real n, int exp) { return ldexpImpl(n, exp); }

    // Implementation from libmir:
    // https://github.com/libmir/mir-core/blob/master/source/mir/math/ieee.d
    private T ldexpImpl(T)(const T n, int exp) @trusted pure nothrow
    {
        enum RealFormat { ieeeSingle, ieeeDouble, ieeeExtended, ieeeQuadruple }

             static if (T.mant_dig ==  24) enum realFormat = RealFormat.ieeeSingle;
        else static if (T.mant_dig ==  53) enum realFormat = RealFormat.ieeeDouble;
        else static if (T.mant_dig ==  64) enum realFormat = RealFormat.ieeeExtended;
        else static if (T.mant_dig == 113) enum realFormat = RealFormat.ieeeQuadruple;
        else static assert(false, "Unsupported format for " ~ T.stringof);

        version (LittleEndian)
        {
            enum MANTISSA_LSB = 0;
            enum MANTISSA_MSB = 1;
        }
        else
        {
            enum MANTISSA_LSB = 1;
            enum MANTISSA_MSB = 0;
        }

        static if (realFormat == RealFormat.ieeeExtended)
        {
            alias S = int;
            alias U = ushort;
            enum sig_mask = U(1) << (U.sizeof * 8 - 1);
            enum exp_shft = 0;
            enum man_mask = 0;
            version (LittleEndian)
                enum idx = 4;
            else
                enum idx = 0;
        }
        else
        {
            static if (realFormat == RealFormat.ieeeQuadruple || realFormat == RealFormat.ieeeDouble && double.sizeof == size_t.sizeof)
            {
                alias S = long;
                alias U = ulong;
            }
            else
            {
                alias S = int;
                alias U = uint;
            }
            static if (realFormat == RealFormat.ieeeQuadruple)
                alias M = ulong;
            else
                alias M = U;
            enum sig_mask = U(1) << (U.sizeof * 8 - 1);
            enum uint exp_shft = T.mant_dig - 1 - (T.sizeof > U.sizeof ? U.sizeof * 8 : 0);
            enum man_mask = (U(1) << exp_shft) - 1;
            enum idx = T.sizeof > U.sizeof ? MANTISSA_MSB : 0;
        }
        enum exp_mask = (U.max >> (exp_shft + 1)) << exp_shft;
        enum int exp_msh = exp_mask >> exp_shft;
        enum intPartMask = man_mask + 1;

        import core.checkedint : adds;
        alias _expect = llvm_expect;

        enum norm_factor = 1 / T.epsilon;
        T vf = n;

        auto u = (cast(U*)&vf)[idx];
        int e = (u & exp_mask) >> exp_shft;
        if (_expect(e != exp_msh, true))
        {
            if (_expect(e == 0, false)) // subnormals input
            {
                bool overflow;
                vf *= norm_factor;
                u = (cast(U*)&vf)[idx];
                e = int((u & exp_mask) >> exp_shft) - (T.mant_dig - 1);
            }
            bool overflow;
            exp = adds(exp, e, overflow);
            if (_expect(overflow || exp >= exp_msh, false)) // infs
            {
                static if (realFormat == RealFormat.ieeeExtended)
                {
                    return vf * T.infinity;
                }
                else
                {
                    u &= sig_mask;
                    u ^= exp_mask;
                    static if (realFormat == RealFormat.ieeeExtended)
                    {
                        version (LittleEndian)
                            auto mp = cast(ulong*)&vf;
                        else
                            auto mp = cast(ulong*)((cast(ushort*)&vf) + 1);
                        *mp = 0;
                    }
                    else
                    static if (T.sizeof > U.sizeof)
                    {
                        (cast(U*)&vf)[MANTISSA_LSB] = 0;
                    }
                }
            }
            else
            if (_expect(exp > 0, true)) // normal
            {
                u = cast(U)((u & ~exp_mask) ^ (cast(typeof(U.init + 0))exp << exp_shft));
            }
            else // subnormal output
            {
                exp = 1 - exp;
                static if (realFormat != RealFormat.ieeeExtended)
                {
                    auto m = u & man_mask;
                    if (exp > T.mant_dig)
                    {
                        exp = T.mant_dig;
                        static if (T.sizeof > U.sizeof)
                            (cast(U*)&vf)[MANTISSA_LSB] = 0;
                    }
                }
                u &= sig_mask;
                static if (realFormat == RealFormat.ieeeExtended)
                {
                    version (LittleEndian)
                        auto mp = cast(ulong*)&vf;
                    else
                        auto mp = cast(ulong*)((cast(ushort*)&vf) + 1);
                    if (exp >= ulong.sizeof * 8)
                        *mp = 0;
                    else
                        *mp >>>= exp;
                }
                else
                {
                    m ^= intPartMask;
                    static if (T.sizeof > U.sizeof)
                    {
                        int exp2 = exp - int(U.sizeof) * 8;
                        if (exp2 < 0)
                        {
                            (cast(U*)&vf)[MANTISSA_LSB] = ((cast(U*)&vf)[MANTISSA_LSB] >> exp) ^ (m << (U.sizeof * 8 - exp));
                            m >>>= exp;
                            u ^= cast(U) m;
                        }
                        else
                        {
                            exp = exp2;
                            (cast(U*)&vf)[MANTISSA_LSB] = (exp < U.sizeof * 8) ? m >> exp : 0;
                        }
                    }
                    else
                    {
                        m >>>= exp;
                        u ^= cast(U) m;
                    }
                }
            }
            (cast(U*)&vf)[idx] = u;
        }
        return vf;
    }
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