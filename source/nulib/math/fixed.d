module nulib.math.fixed;
import numem.casting;

/**
    Gets whether the provided value is a instance of $(D Fixed)
*/
enum isFixed(T) = is(T : Fixed!U, U...);

/**
    Fixed-point math type, fractional bits can be specified, but
    by default is split evenly; eg Fixed!int will be Q16.16

    Note:
        When converting a fixed-precision number to a floating point
        number, they may not be exact bit-for-bit equal; as such an
        approximate equals operation is recommended for comparing
        fixed point math with 
*/
struct Fixed(T, size_t FRACT_BITS = (8*(T.sizeof/2))) if (__traits(isIntegral, T) && !__traits(isUnsigned, T)) {
public:
@nogc nothrow:
    T data;

    /**
        Half-sized max value as a float/double/real
    */
    enum HALF_MAX(Y) = cast(Y)(1LU << SHIFT);
    
    /**
        How much to shift the data store in-operation.
    */
    enum T SHIFT = FRACT_BITS;
    
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
    enum typeof(this) min = fromData(data: T.min);

    /**
        Max value of the fixed-precision value
    */
    enum typeof(this) max = fromData(data: T.max);

    /**
        Creates a new instance from raw data.
    */
    static auto fromData(T data) {
        typeof(this) t;
        t.data = data;
        return t;
    }

    /**
        Constructor
    */
    this(Y)(Y other) {
        static if (__traits(isIntegral, Y)) {
            this.data = cast(T)(other << SHIFT);
        } else static if (__traits(isFloating, Y)) {
            this.data = cast(T)(other * HALF_MAX!Y);
        } else static if(is(Y : typeof(this))) {

            // Fast path for when you're just assigning between
            // the same type.
            this.data = other.data;  
        } else static if (isFixed!Y) {

            // Shift integer part over so that we can realign it,
            // then add in the factional part from the other; making sure we cut out
            // any fractional part that doesn't fit within our own fractional space.
            T intPart = cast(T)(((other.data & other.INT_MASK) >> other.SHIFT) << SHIFT);
            T fractPart = cast(T)(other.data & other.FRACT_MASK);

            // This step aligns the fractional part with the size of the container.
            static if (other.SHIFT > SHIFT)
                fractPart = (fractPart >> (other.SHIFT-SHIFT));
            else 
                fractPart = (fractPart << (SHIFT-other.SHIFT));
            
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
        static if (op == "+") return Fixed!T.fromData(cast(T)(data + rhs.data));
        else static if (op == "-") return Fixed!T.fromData(cast(T)(data - rhs.data));
        else static if (op == "*") {
            return Fixed!T.fromData(cast(T)((cast(long)data * cast(long)rhs.data) >>> SHIFT));
        } else static if (op == "/") {
            return Fixed!T.fromData(cast(T)((cast(long)data << SHIFT) / rhs.data));
        } else static assert(0, "Operation not supported (yet)");
    }

    pragma(inline, true)
    size_t toHash() const @safe pure nothrow {
        return this.data;
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

    pragma(inline, true)
    auto opAssign(R)(const R rhs)
    if (__traits(isScalar, R)) {
        this = typeof(this)(rhs);
        return this;
    }
}

/**
    Q2.14 fixed-point number (16-bit)
*/
alias fixed2_14 = Fixed!(short, 14);

/**
    Q26.6 fixed-point number (64-bit)
*/
alias fixed26_6 = Fixed!(long, 6);

/**
    Q2.6 fixed-point number (8-bit)
*/
alias fixed2_6 = Fixed!(byte, 6);

/**
    Q8.8 fixed-point number (16-bit)
*/
alias fixed16 = Fixed!short;

/**
    Q16.16 fixed-point number (32-bit)
*/
alias fixed32 = Fixed!int;

/**
    Q32.32 fixed-point number (64-bit)
*/
alias fixed64 = Fixed!long;

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

@("fixed16: ctor fixed2_14")
unittest {
    assert(fixed16(fixed2_14(1.0)) == 1.0);
    assert(fixed16(fixed2_14(0.5)) == 0.5);
}