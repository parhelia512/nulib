module nulib.collections.internal.marray;
import numem.core.memory : nu_is_overlapping;
import numem.core.hooks;
import numem.core.traits;
import numem;

/**
    A managed array with utilities for range manipulation
*/
struct ManagedArray(T, bool ownsMemory = true) {
    alias memory this;

    // Backing slice of the vector.
    T[] memory;

    // Memory capacity of the slice.
    size_t capacity = 0;

    // Resizing algorithm
    pragma(inline, true)
    void resize(size_t length) @trusted {
        
        // Early exit.
        if (length == memory.length)
            return;

        // Reserve if over-allocating for the current
        // size.
        if (length > capacity)
            this.reserve(length);

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
    void reserve(size_t length) @trusted {
        if (length == 0) {
            memory = memory.nu_resize(0);
            this.capacity = 0;
            return;
        }

        // Resize down if neccesary.
        size_t sliceSize = memory.length;
        if (sliceSize > length) {
            sliceSize = length;
            this.reserve(sliceSize);
        }

        memory = memory.nu_resize(length)[0..sliceSize];
        this.capacity = length;
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
            if (endIdx < memory.length) {
                nu_memmove(&memory[startIdx], &memory[endIdx], leftoverCount*T.sizeof);
            }

            // Hide the now invalid memory.
            memory = memory[0..startIdx+leftoverCount];
        }
    }

    // Checks whether src or dst is moving into our memory slice.
    // This is used in moveRange to allow for overlapping moves.
    pragma(inline, true)
    bool isMovingIntoSelf(T[] dst, T[] src) {
        return 
            nu_is_overlapping(memory.ptr, memory.length*T.sizeof, dst.ptr, dst.length*T.sizeof) && 
            nu_is_overlapping(memory.ptr, memory.length*T.sizeof, src.ptr, src.length*T.sizeof);
    }

    // Checks whether src or dst is moving into our memory slice.
    // This is used in moveRange to allow for overlapping moves.
    pragma(inline, true)
    bool isMovingIntoSelf(T[] src) {
        return 
            nu_is_overlapping(memory.ptr, memory.length*T.sizeof, src.ptr, src.length*T.sizeof);
    }

    // Range move algorithm.
    pragma(inline, true)
    void moveRange(T[] dst, T[] src) {

        // Handle overlapping moves.
        if (isMovingIntoSelf(dst, src)) {
            src = rangeCopy(src);
            static if (hasElaborateMove!T) {
                nogc_move(dst, src);
            } else {
                nogc_copy(dst, src);
            }
            src = src.nu_resize(0);
            return;
        }

        // Non-overlapping moves.
        static if (hasElaborateMove!T) {
            nogc_move(dst, src);
        } else {
            nogc_copy(dst, src);
        }
    }
}

// Range copy for moves internally.
pragma(inline, true)
T[] rangeCopy(T)(T[] src) {
    T[] dst;

    dst = dst.nu_resize(src.length);
    static if (hasElaborateMove!T) {
        nogc_move(dst, src);
    } else {
        nogc_copy(dst, src);
    }
    return dst;
}