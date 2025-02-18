/**
    Dynamic Arrays

    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.collections.vector;
import numem.core.memory : nu_is_overlapping;
import numem.core.hooks;
import numem.core.traits;
import numem;

/**
    A vector which owns the memory it contains.
*/
alias vector(T) = VectorImpl!(T, true);

/**
    A vector which does not own the memory it contains.
*/
alias weak_vector(T) = VectorImpl!(T, false);

/**
    A @nogc dynamic array.
*/
struct VectorImpl(T, bool ownsMemory = true) {
@nogc:
private:
    alias SelfType = typeof(this);

    // Backing slice of the vector.
    T[] memory;

    // Memory capacity of the slice.
    size_t memoryCapacity = 0;

    // Resizing algorithm
    pragma(inline, true)
    void resizeImpl(size_t length) @trusted {
        
        // Early exit.
        if (length == memory.length)
            return;

        // Reserve if over-allocating for the current
        // size.
        if (length > memoryCapacity)
            this.reserveImpl(length);

        // If the new length is lower than the prior length
        // Destroy the prior allocated objects.
        if (length < memory.length) {
            this.deleteRange(memory.ptr[length..memory.length]);
        }

        // If it's bigger, initialize the memory in the new range.
        if (length > memory.length) {
        
            // Initialize the newly prepared memory by
            // bliting T.init to it.
            nogc_initialize(memory.ptr[memory.length..length]);
        }

        memory = memory.ptr[0..length];
    }

    // Reservation algorithm
    pragma(inline, true)
    void reserveImpl(size_t length) @trusted {

        // Resize down if neccesary.
        size_t sliceSize = memory.length;
        if (sliceSize > length) {
            sliceSize = length;
            this.resizeImpl(sliceSize);
        }

        memory = memory.nu_resize(length)[0..sliceSize];
        this.memoryCapacity = length;
    }

    // Range deletion algorithm.
    pragma(inline, true)
    void deleteRange(T[] range) {
        static if (ownsMemory) {
            nogc_delete(range);
        } else {
            nogc_initialize(range);
        }
    }

    // Range move algorithm.
    pragma(inline, true)
    void moveRange(T[] dst, T[] src) {
        static if (hasElaborateMove!T) {
            nogc_move(dst, src);
        } else {
            nogc_copy(dst, src);
        }
    }

    // Range copy for moves internally.
    pragma(inline, true)
    T[] rangeCopy(T[] src) {
        T[] dst;

        dst = dst.nu_resize(src.length);
        this.moveRange(dst, src);
        return dst;
    }

public:
    alias value this;

    /**
        The length of the vector
    */
    @property size_t length() const @safe nothrow => memory.length;

    /**
        The capacity of the vector.
    */
    @property size_t capacity() const @safe nothrow => memoryCapacity;

    /**
        Whether the vector is empty.
    */
    @property bool empty() const @safe nothrow => memory.length == 0;

    /**
        The length of the vector, in bytes.
    */
    @property size_t usage() @safe nothrow => memory.length*T.sizeof;

    /**
        Gets a pointer to the first element of the
        vector.
    */
    @property T* ptr() @system nothrow => memory.ptr;

    /**
        Gets a pointer to the first element of the vector.

        If the vector is empty, the first element will be null.
    */
    @property T* front() @system nothrow => empty ? null : &memory[0];

    /**
        Gets a pointer to the last element of the vector.

        If the vector is empty, the last element will be null.
    */
    @property T* back() @system nothrow => empty ? null : &memory[$-1];

    /**
        Gets the internal memory slice.
    */
    @property T[] value() @trusted nothrow pure => memory;

    ~this() {

        // This essentially frees the memory.
        this.reserveImpl(0);
        this.memoryCapacity = 0;
    }

    /**
        Creates a new vector from a slice.

        Notes:
            Elements will either be copied or moved out of the
            source slice. Pointers will only be weakly referenced.
            If said pointers were allocated with the GC, they may be
            collected!
    */
    this(T[] elements) @system {
        if (__ctfe) {
            memory = elements;
            memoryCapacity = elements.length;
        } else {
            static if (hasElaborateMove!T) {
                this.resizeImpl(elements.length);
                nogc_move(memory, elements);
            } else {
                this.resizeImpl(elements.length);
                nogc_copy(memory, elements);
            }
        }
    }

    /**
        Copy-constructor
    */
    this(ref return scope inout(SelfType) rhs) @trusted {
        if (__ctfe) {
            this.memory = cast(T[])rhs.memory;
            this.memoryCapacity = rhs.memoryCapacity;
        } else {
            static if (hasElaborateMove!T) {
                this.resizeImpl(rhs.length);
                nogc_move(memory, rhs);
            } else {
                this.resizeImpl(rhs.length);
                nogc_copy(memory, cast(SelfType)rhs);
            }
        }
    }

    /**
        Clears the vector, removing all elements from it.
    */
    void clear() @safe {
        this.reserveImpl(0);
    }

    /**
        Attempts to reserve memory in the vector.

        Reserve can *only* grow the allocation; not shrink it.
    */
    void reserve(size_t newSize) {
        if (newSize > memoryCapacity)
            this.reserveImpl(newSize);
    }

    /**
        Resizes the vector.
    */
    void resize(size_t newSize) {
        this.resizeImpl(newSize);
    }

    /**
        Pops the front element of the vector.
    */
    void popFront() {
        if (!empty) {
            this.deleteRange(memory[0..1]);
        }
    }

    /**
        Append a $(D T) to the vector.

        Params:
            value = The value to append.
    */
    void opOpAssign(string op = "~")(ref auto T value) @trusted {
        this.resizeImpl(length+1);

        static if (hasElaborateMove!T) {
            this.memory[$-1] = value.move();
        } else {
            this.memory[$-1] = value;
        }
    }

    /**
        Append a range to the vector.

        Params:
            other = the other range to append.
    */
    void opOpAssign(string op = "~")(T[] other) @trusted {
        size_t srcbytes = other.length*T.sizeof;
        
        // Early escape.
        if (srcbytes == 0)
            return;
        
        if (nu_is_overlapping(other.ptr, srcbytes, memory.ptr, usage)) {

            // If it's overlapping we need to make deeper copies of the unerlying objects.
            // it's not ideal, but otherwise we get memory corruption.
            other = rangeCopy(other);

            size_t start = memory.length;
            this.resizeImpl(memory.length+other.length);
            this.moveRange(memory[start..$], other[0..$]);

            other = other.nu_resize(0);
        } else {

            size_t start = memory.length;
            this.resizeImpl(memory.length+other.length);
            this.moveRange(memory[start..$], other[0..$]);
        }
    }
}

//
//      C and D string handling utilities
//

@nogc pure nothrow {

    /**
        Gets a slice from a C string
    */
    inout(T)[] fromStringz(T)(inout(T)* cString) if (isSomeChar!T)  {
        return cString ? cString[0 .. cstrlen!T(cString)] : null;
    }

    /**
        Gets the length of a C-style string
    */
    size_t cstrlen(T)(inout(T)* s) if (isSomeChar!T)  {
        const(T)* p = s;
        while (*p)
            ++p;
        
        return p - s;
    }
}

@("vector-of-strings")
unittest {
    import nulib.string : nstring;
    vector!nstring strs;
    strs ~= nstring("Hello, world!");
    strs ~= nstring("Hello, world!");
    strs ~= nstring("Hello, world!");
    strs ~= nstring("Hello, world!");
    strs ~= nstring("Hello, world!");
    strs ~= nstring("Hello, world!");

    strs ~= strs;

    import std.stdio : writeln;
    foreach(ref str; strs) {
        assert(str == "Hello, world!");
    }
}