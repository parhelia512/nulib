module nulib.math.fixed;
import numem.casting;

/**
    Gets whether the provided value is a instance of $(D Fixed)
*/
enum isFixed(T) = is(T : Fixed!U, U);

/**
    Fixed-point math type with an even split between
    integer and fractional parts.

    Note:
        When converting a fixed-precision number to a floating point
        number, they may not be exact bit-for-bit equal; as such an
        approximate equals operation is recommended for comparing
        fixed point math with 
*/
struct Fixed(T) if (__traits(isIntegral, T) && !__traits(isUnsigned, T)) {
private:
@nogc nothrow:
    T data;

    // Helper to create a raw instance of Fixed!T
    pragma(inline, true)
    static Fixed!T createRaw(T data) {
        Fixed!T r;
        r.data = data;
        return r;
    }

    enum size_t HALF_BYTES = (T.sizeof/2);
public:

    /**
        Half-sized max value as a float/double/real
    */
    enum HALF_MAX(Y) = cast(Y)(1LU << SHIFT);
    
    /**
        How much to shift the data store in-operation.
    */
    enum T SHIFT = HALF_BYTES*8;
    
    /**
        Mask of fractional part
    */
    enum T FRACT_MASK = (cast(T)1LU << SHIFT) - 1;
    
    /**
        Mask of integer part
    */
    enum T INT_MASK = ~FRACT_MASK;

    /**
        Max value of the fixed-precision value
    */
    enum T max = T.max >>> 1;

    /**
        Max value of the fixed-precision value
    */
    enum T min = T.min;

    /**
        Constructor
    */
    this(Y)(Y data) if(__traits(isScalar, T)) {
        static if (__traits(isIntegral, Y)) {
            this.data = cast(T)(data << SHIFT);
        } else static if (__traits(isFloating, Y)) {
            this.data = cast(T)(data * HALF_MAX!Y);
        } else static if(is(Y : typeof(this))) {

            // Fast path for when you're just assigning between
            // the same type.
            this.data = data.data;  
        } else static if (isFixed!Y) {

            // Shift integer part over so that we can realign it,
            // then add in the factional part from the other; making sure we cut out
            // any fractional part that doesn't fit within our own fractional space.
            T intPart = cast(T)(((data.data & data.INT_MASK) >> data.SHIFT) << SHIFT);
            T fractPart = cast(T)(data.data & data.FRACT_MASK);

            // This step aligns the fractional part with the size of the container.
            static if (data.SHIFT > SHIFT)
                fractPart = (fractPart >> (data.SHIFT-SHIFT));
            else 
                fractPart = (fractPart << (SHIFT-data.SHIFT));
            
            this.data = (intPart & INT_MASK) | (fractPart & FRACT_MASK);
        } else static assert(0, "Unsupported construction");
    }

    pragma(inline, true)
    Y opCast(Y)() const {
        static if (__traits(isIntegral, Y)) {
            return data >> SHIFT;
        } else static if (__traits(isFloating, Y)) {
            return cast(Y)data * (cast(Y)1.0 / HALF_MAX!Y);
        } else static assert(0, "Unsupported cast.");
    }

    pragma(inline, true)
    auto opBinary(string op, R)(const R rhs) const
    if (is(R : Fixed!T)) {
        static if (op == "+") return Fixed!T.createRaw(cast(T)(data + rhs.data));
        else static if (op == "-") return Fixed!T.createRaw(cast(T)(data - rhs.data));
        else static if (op == "*" && T.sizeof <= 4) {
            return Fixed!T.createRaw(cast(T)((cast(long)data * cast(long)rhs.data) >>> SHIFT));
        } else static if (op == "/" && T.sizeof <= 4) {
            return Fixed!T.createRaw(cast(T)((cast(long)data << SHIFT) / rhs.data));
        } else static assert(0, "Operation not supported (yet)");
    }

    pragma(inline, true)
    bool opEquals(R)(const R other) const
    if (is(R : Fixed!T)) {
        return this.data == other.data;
    }
    
    pragma(inline, true)
    auto opOpAssign(string op, R)(const R rhs)
    if (is(R : const Fixed!T)) {
        this = this.opBinary!(op, R)(rhs);
        return this;
    }

    pragma(inline, true)
    auto opBinary(string op, R)(const R rhs) const
    if (__traits(isScalar, R)) {
        return this.opBinary!(op, Fixed!T)(Fixed!T(rhs));
    }

    pragma(inline, true)
    bool opEquals(R)(const R other) const
    if (__traits(isScalar, R)) {
        return this.data == Fixed!T(other).data;
    }
    
    pragma(inline, true)
    auto opOpAssign(string op, R)(const R rhs)
    if (__traits(isScalar, R)) {
        this = this.opBinary!(op, Fixed!T)(Fixed!T(rhs));
        return this;
    }
}

/**
    Q8.8 fixed-point number
*/
alias fixed16 = Fixed!short;

/**
    Q16.16 fixed-point number
*/
alias fixed32 = Fixed!int;

@("fixed32: int->fixed32")
unittest {
    assert(cast(int)fixed32(16) == 16);
}

@("fixed32: fixed32->float")
unittest {
    import std.math : isClose;
    assert(isClose(cast(float)fixed32(32.32f), 32.32f));
}

@("fixed32: +")
unittest {
    assert(fixed32(31) + 1 == 32);
    assert(fixed32(1.5) + 1.5 == 3);
}

@("fixed32: -")
unittest {
    assert(fixed32(32) - 1 == 31);
    assert(fixed32(1.5) - 0.5 == 1.0);
}

@("fixed32: *")
unittest {
    assert(fixed32(16)*2 == 32);
    assert(fixed32(5.5)*2.5 == 5.5*2.5);
}

@("fixed32: /")
unittest {
    assert(fixed32(64) / 2 == 32);
}

@("fixed32: ctor fixed16")
unittest {
    assert(fixed32(fixed16(32)) == 32);
    assert(fixed32(fixed16(32.5)) == 32.5);
}

@("fixed16: +")
unittest {
    assert(fixed16(31) + 1 == 32);
}

@("fixed16: -")
unittest {
    assert(fixed16(32) - 1 == 31);
}

@("fixed16: *")
unittest {
    assert(fixed16(16)*2 == 32);
    assert(fixed16(5.5)*2.5 == 5.5*2.5);
}

@("fixed16: /")
unittest {
    assert(fixed16(64) / 2 == 32);
}

@("fixed16: ctor fixed32")
unittest {
    assert(fixed16(fixed32(32)) == 32);
    assert(fixed16(fixed32(32.5)) == 32.5);
}