module nulib.math.fixed;
import numem.casting;
import numem.core.traits;

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
        Division factor for the given precision of float.
    */
    enum DIV_FACT(Y) = cast(Y)(1LU << SHIFT);
    
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
            this.data = cast(T)(cast(T)other << SHIFT);
        } else static if (__traits(isFloating, Y)) {
            this.data = cast(T)(cast(Y)other * DIV_FACT!Y);
        } else static if (isFixed!Y) {

            // Fast path for when you're just assigning between
            // the same type.
            static if (other.SHIFT == this.SHIFT) {
                this.data = cast(T)other.data;
                return;
            }


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
            return cast(Y)(data >> SHIFT);
        } else static if (__traits(isFloating, Y)) {
            return cast(Y)data * (cast(Y)1.0 / DIV_FACT!Y);
        } else static assert(0, "Unsupported cast.");
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
    bool opEquals(R)(const R other) const
    if (__traits(isScalar, R)) {
        return this.data == Fixed!T(other).data;
    }

    pragma(inline, true)
    typeof(this) opBinary(string op, R)(const R rhs) const
    if (isFixed!R) {

        // Convert mismatched Fixed!T
        static if (R.SHIFT != SHIFT) {
            auto other = typeof(this)(rhs);
        } else static if (!is(typeof(R.data) == T)) {
            auto other = typeof(this).fromData(cast(T)rhs.data);
        } else {
            auto other = rhs;
        }

        // Move out to LONG
        long x = cast(long)data;
        long y = cast(long)other.data;
        long result;

        static if (op == "+") {

            result = x + y;
        } else static if (op == "-") {

            result = x - y;
        } else static if (op == "*") {
            
            result = (x * y) >>> SHIFT;
        } else static if (op == "/") {
            static if (T.sizeof < 8 && R.sizeof < 8) {

                // NOTE:    For 32-bit and below division, 64 bit provides
                //          plenty of space to do the operation.
                result = (x << SHIFT) / y;
            } else {

                // NOTE:    Division generally takes up more space as such,
                //          this is the best way to get a mostly correct
                //          result for 64-bit fixed point numbers.
                result = ((x / y) << SHIFT) + ((x % y) << SHIFT) / y;
            }
        } else static assert(0, "Operation not supported (yet)");

        return typeof(this).fromData(cast(T)result);
    }

    pragma(inline, true)
    typeof(this) opBinary(string op, R)(const R rhs) const
    if (__traits(isScalar, R)) {
        return this.opBinary!(op, Fixed!T)(Fixed!T(rhs));
    }
    
    pragma(inline, true)
    typeof(this) opOpAssign(string op, R)(const R rhs)
    if (is(R : const Fixed!T)) {
        this = this.opBinary!(op, R)(rhs);
        return this;
    }
    
    pragma(inline, true)
    typeof(this) opOpAssign(string op, R)(const R rhs)
    if (__traits(isScalar, R)) {
        this = typeof(this)(this.opBinary!(op, Fixed!T)(Fixed!T(rhs)));
        return this;
    }

    pragma(inline, true)
    typeof(this) opAssign(R)(const R rhs)
    if (!is(Unqual!R == Unqual!(typeof(this)))) {
        this.__ctor!R(rhs);
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