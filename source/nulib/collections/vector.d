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
        if (length == 0) {
            memory = memory.nu_resize(0);
            this.memoryCapacity = 0;
            return;
        }

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

        // Handle array rearrangement.
        ptrdiff_t startIdx = cast(ptrdiff_t)(range.ptr - memory.ptr);
        ptrdiff_t endIdx = startIdx+range.length;
        size_t leftoverCount = (memory.length-endIdx);
        if (startIdx >= 0) {
            
            // Shift old memory in
            if (endIdx <= memory.length) {
                nu_memmove(&memory[startIdx], &memory[endIdx], leftoverCount*T.sizeof);
            }

            // Hide the now invalid memory.
            memory = memory[0..startIdx+leftoverCount];
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
        Gets the internal memory slice.
    */
    @property T[] value() @trusted nothrow pure => memory;

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
    this(T[] rhs) @system {
        if (__ctfe) {
            memory = rhs;
            memoryCapacity = rhs.length;
        } else {
            static if (hasElaborateMove!T) {
                this.resizeImpl(rhs.length);
                nogc_move(memory, rhs);
            } else {
                this.resizeImpl(rhs.length);
                nogc_copy(memory, rhs);
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
        Pops the back element of the vector.
    */
    void popBack() {
        if (!empty) {
            this.deleteRange(memory[$-1..$]);
        }
    }

    /**
        Removes an element from the vector matching the given element.
    */
    void remove(T element) {
        foreach_reverse(i; 0..memory.length) {

            // NOTE:    DRuntime's opEquals implementation is not nogc
            //          as such we need to check whether we can do an equals comparison
            //          in a nogc context.
            //          Otherwise, we try calling opEquals directly, if that fails we try
            //          the `is` operator, and finally if that fails we assert at compile-time.
            static if (is(typeof(() @nogc { return T.init == T.init; }))) {
                if (memory[i] == element) {
                    this.removeAt(i);
                    return;
                }
            } else static if (is(typeof(() @nogc { return T.init.opEquals(T.init); }))) {
                if (memory[i].opEquals(element)) {
                    this.removeAt(i);
                    return;
                }
            } else static if (is(typeof(() @nogc { return T.init is T.init; }))) {
                if (memory[i] is element) {
                    this.removeAt(i);
                    return;
                }
            } else static assert(0, "Failed to find a nogc comparison method!");
        }
    }

    /**
        Removes the element at the given index.
    */
    void removeAt(size_t i) {
        if (i >= 0 && i < memory.length) {
            this.deleteRange(memory[i .. i+1]);
        }
    }

    /**
        Removes the elements at the given index with the given
        element count.
    */
    void removeAt(size_t i, size_t count) {
        if (i >= 0 && i+count < memory.length) {
            this.deleteRange(memory[i .. i+count]);
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

@(".removeAt(index)")
unittest {
    vector!int numbers = [1, 0, 2, 3, 4];

    numbers.removeAt(1);
    assert(numbers == [1, 2, 3, 4]);
}

@(".removeAt(index, count)")
unittest {
    vector!int numbers = [0, 1, 2, 3, 4];

    numbers.removeAt(1, 2);
    assert(numbers == [0, 3, 4]);
}

@(".remove(element)")
unittest {
    vector!int numbers = [0, 1, 255, 2, 3, 4];

    numbers.remove(255);
    assert(numbers == [0, 1, 2, 3, 4]);
}