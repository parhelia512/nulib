/**
    nogc strings

    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.string;
import numem.core.hooks;
import numem.core.traits;
import numem.core.memory;
import numem;    
import nulib.text.unicode : 
    encode, 
    decode;

//
//              STRING TRAITS
//




/// Gets whether the provided type is some type of string.
enum isSomeString(T) =
    isSomeSafeString!T ||
    isSomeCString!T;

/**
    Gets whether the provided type is some type of string
    which is length denoted and therefore "safe"
*/
enum isSomeSafeString(T) =
    isSomeNString!T ||
    isSomeDString!T;


/// Gets whether the provided type is some type of nstring.
enum isSomeNString(T) = 
    is(inout(T) == inout(StringImpl!C), C) && isSomeChar!C;

/// Gets whether the provided type is some type of null terminated C string.
enum isSomeCString(T) =
    is(T == C*, C) && isSomeChar!C;

/// Gets whether the provided type is some type of D string slice.
enum isSomeDString(T) =
    is(immutable(T) == immutable(C[]), C) && isSomeChar!C;

/// Gets whether the provided type is a character
enum isSomeChar(T) =
    is(T : char) || is(T : wchar) || is(T : dchar);

/**
    Gets whether [T] is convertible to any form of [nstring]
*/
enum isStringable(T) = 
    __traits(hasMember, T, "toString") &&
    isSomeString!(ReturnType!(T.toString));

/**
    Gets the size of the element in a string-ish type in bytes.
*/
enum StringCharSize(T) =
    StringCharType!T.sizeof;

/**
    Gets the type of the element in a string-ish type.
*/
template StringCharType(T) {
    static if (isSomeString!T) {
        static if(isSomeNString!T)
            alias StringCharType = Unqual!(T.CharType);
        else
            alias StringCharType = Unqual!(typeof(T.init[0].init));
    } else {
        alias StringCharType = void;
    }
}


//
//              NSTRING ALIASES
//

/**
    A @nogc UTF-8 string

    Note:
        $(D nstring) is passed $(B by value), this effectively means
        that if you do not pass it as $(D ref) you will end up copying
        the contents of the string.
    
    See_Also:
        $(D nwstring)
        $(D ndstring)
*/
alias nstring = StringImpl!(char);

/**
    A @nogc UTF-16 string

    Note:
        $(D nwstring) is passed $(B by value), this effectively means
        that if you do not pass it as $(D ref) you will end up copying
        the contents of the string.
    
    See_Also:
        $(D nstring)
        $(D ndstring)
*/
alias nwstring = StringImpl!(wchar);

/**
    A @nogc UTF-32 string

    Note:
        $(D ndstring) is passed $(B by value), this effectively means
        that if you do not pass it as $(D ref) you will end up copying
        the contents of the string.
    
    See_Also:
        $(D nstring)
        $(D nwstring)
*/
alias ndstring = StringImpl!(dchar);


//
//          STRING IMPLEMENTATION.
//



/**
    The underlying implementation of a numem string.
*/
struct StringImpl(T) if (isSomeChar!T) {
@nogc:
private:
    alias SelfType = typeof(this);
    
    // Backing slice of the string.
    immutable(T)[] memory = null;

    // Resizing algorithm
    pragma(inline, true)
    void resizeImpl(size_t newLength) @trusted {
        if (newLength == 0) {
            if (memory.ptr !is null)
                memory.nu_resize(0);
            
            nogc_zeroinit(memory);
            return;
        }

        // NOTE: nu_terminatd re-allocates the slice twice,
        // As such we put a smaller implementation here.
        memory.nu_resize(newLength+1);
        (cast(T*)memory.ptr)[newLength] = '\0';
        memory = memory[0..$-1];
    }

    // Range set algorithm
    pragma(inline, true)
    void setRangeImpl(inout(T)[] dst, inout(T)[] src) {
        if (memory)
            nu_memmove(cast(void*)dst.ptr, cast(void*)src.ptr, src.length*T.sizeof);
    }

    // Char set algorithm
    pragma(inline, true)
    void setCharImpl(void* at, T c) {
        if (memory)
            *(cast(T*)at) = c;
    }

public:
    alias value this;

    /**
        The type of character the string contains.
    */
    alias CharType = T;

    /**
        The length of the string.
    */
    @property size_t length() @safe nothrow => memory.length;

    /**
        Gets the length of the string, with the null terminator.
    */
    @property size_t realLength() @safe nothrow => memory.ptr ? memory.length+1 : 0;
    
    /**
        The length of the string, in bytes.
    */
    @property size_t usage() @safe nothrow => memory.length*T.sizeof;

    /**
        Whether the string is empty.
    */
    @property bool empty() @safe nothrow => memory.length == 0;

    /**
        Gets a C string pointer to the nstring.
    */
    @property const(T)* ptr() @system nothrow => cast(const(T)*)memory.ptr;

    /**
        Gets the internal memory slice.
    */
    @property immutable(T)[] value() inout @trusted nothrow pure => memory;

    // Aliases for legacy purposes.
    alias toDString = value;
    alias toCString = ptr;

    ~this() {
        this.resizeImpl(0);
    }

    /**
        Creates an nstring
    */
    this(inout(T)[] rhs) @system {
        if (__ctfe) {
            this.memory = cast(immutable(T)[])rhs;
        } else if (rhs) {
            this.memory = cast(immutable(T)[])rhs.nu_idup;
            nu_terminate(this.memory);
        } else {
            nogc_zeroinit(this.memory);
        }
    }

    /**
        Creates a string from a null-terminated C string.
    */
    this(const(T)* rhs) @system {
        if (rhs) {
            this.memory = fromStringz(rhs).nu_idup;
        } else {
            nogc_zeroinit(this.memory);
        }
    }
    
    /**
        Creates a string from a string from any other UTF encoding.
    */
    this(U)(inout(U)[] rhs) @system if (isSomeChar!U) {
        if (rhs) {
            auto dec = decode(rhs, true);
            this = encode!(SelfType)(dec, true);
        } else {
            nogc_zeroinit(this.memory);
        }
    }

    /**
        Copy-constructor
    */
    this(ref return scope inout(SelfType) rhs) @trusted {
        if (__ctfe) {
            this.memory = rhs.memory;
        } else if (rhs) {
            this.memory = rhs.memory.nu_idup;
        } else {
            nogc_zeroinit(this.memory);
        }
    }

    /**
        Clears the string, equivalent to resizing it to 0.
    */
    void clear() {
        this.resizeImpl(0);
    }

    /**
        Reverses the contents of the string
    */
    void reverse() {
        import nulib.memory.endian : nu_flip_bytes;
        nu_flip_bytes(memory);
    }

    /**
        Resizes the string.

        Params:
            newLength = The amount of characters the string should be.

        Note:
            The contents when increasing the size of a string with this
            function is undefined. A null terminator will be appended 
            automatically.
    */
    void resize(size_t newLength) {
        this.resizeImpl(newLength);
    }

    /**
        Appends a character to this string.
    */
    void opOpAssign(string op = "~")(ref auto inout(T) value) @trusted {
        this.resizeImpl(length+1);
        this.setCharImpl(cast(void*)(&memory[$-1]), value);
    }

    /**
        Appends a string to this string.
    */
    void opOpAssign(string op = "~")(inout(T)[] other) @trusted {
        size_t start = memory.length;
        this.resizeImpl(memory.length+other.length);
        this.setRangeImpl(memory[start..$], other[0..$]);
    }

    /**
        Appends a c string to this string.
    */
    void opOpAssign(string op = "~")(inout(T)* other) @system {
        this.opOpAssign!"~"(fromStringz!T(other));
    }
}

@("nstring: char append")
unittest {
    // appending a char
    nstring s;
    nwstring ws;
    ndstring ds;
    s  ~= 'c';
    ws ~= '\u4567';
    ds ~= '\U0000ABCD';
    assert(s == "c" 
       && ws == "\u4567"w 
       && ds == "\U0000ABCD"d);

    // Not working yet: append to itself
    s ~= s;
    assert(s == "cc");
}

@("nstring: append")
unittest {
    const(char)* cstr1 = "a zero-terminated string";
    const(wchar)* cstr2 = "hey";
    const(dchar)* cstr3 = "ho";

    nstring s;
    s ~= cast(string)null;
    s ~= "";
    s ~= cstr1;
    assert(s == "a zero-terminated string");

    nwstring ws;
    ws ~= cstr2;
    assert(ws.length == 3);

    ndstring wd;
    wd ~= cstr3;
    assert(wd == "ho"d);
}

@("nstring: string in map")
unittest {
    import nulib.collections.map : map;
    map!(nstring, int) kv;
    kv[nstring("uwu")] = 42;

    assert(kv[nstring("uwu")] == 42);
}

@("nstring: length")
unittest {
    nstring str = "Test string";
    assert(str.usage() == 11);
    assert(str.length() == 11);
    assert(str.realLength() == 12);
}

@("nstring: emptiness")
unittest {
    nstring str;

    assert(str.empty());

    // Should add null terminator.
    str.clear();
    assert(str.empty);
    assert(str.ptr is null);
}

//
//      C and D string handling utilities
//

/**
    Gets a slice from a null-terminated string.

    Params:
        str = the null terminated string to slice.

    Returns:
        A new slice over the string, stopping before the null terminator.
        If $(D str) is not null terminated the return value
        is undefined and likely corrupted.
*/
inout(T)[] fromStringz(T)(inout(T)* str) @system @nogc pure nothrow
if (isSomeChar!T) {
    return str ? str[0 .. nu_strlen!T(str)] : null;
}

/**
    Gets the length of a null-terminated string.

    Params:
        str = the string to check the length of.
    
    Returns:
        The length of the string in code units.
        If $(D str) is not null terminated the return value
        is undefined.
*/
size_t nu_strlen(T)(inout(T)* str) @system @nogc pure nothrow
if (isSomeChar!T) {
    const(T)* p = str;
    while (*p)
        ++p;
    
    return p - str;
}