/**
    GArray

    Copyright: Copyright © 1995-1997, Peter Mattis, Spencer Kimball and Josh MacDonald
    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(LINK2 https://gitlab.gnome.org/GNOME/glib/-/blob/main/LICENSES/LGPL-2.1-or-later.txt, LGPL-2.1-or-later)
    Authors:   Luna Nielsen
*/
module nulib.glib.garray;
import numem.core.traits;
import numem;

/**
    A GLib Array.

    GArray is built around having similar semantics to $(D nulib.collections.vector).
    As such you can pass a $(D GArray) into functions which takes D slices.

    Do note that GArray is the owner of the memory, not you.
    Use the refcounting system to handle the memory.
*/
struct GArray(T) {
@nogc nothrow:
private:
    GArrayT* g_self;

    this(GArrayT* self) { g_self = self; }

public:
    alias slice this;
    alias ElementType = T;

    /**
        Gets a D slice from the GArray.
    */
    @property T[] slice() { return (cast(T*)g_self.data)[0..g_self.length]; }

    /**
        Gets the size of elements in the array in bytes.
    */
    @property size_t elementSize() { return g_array_get_element_size(g_self); }

    /* Disabled, since g_self should not be null. */
    @disable this();

    // Destructor
    ~this() { 
        g_array_unref(g_self);
    }

    /**
        Constructs a GArray with a given length.

        Params:
            length = How many elements to preallocate on creation.
                     The size of the array will not change, however. 
    */
    this(size_t length) {
        g_self = g_array_sized_new(
            false, 
            __traits(isZeroInit, T), 
            cast(uint)T.sizeof,
            cast(uint)length
        );
    }

    /**
        Constructs a GArray with a given length.

        Params:
            data = Data to copy into the GArray on creation.
    */
    this(T[] data) {
        this(data.length);

        // NOTE:    g_array_sized_new *reserves* the given amount of space.
        //          So we need to set the size here, if this resize is removed
        //          it will corrupt memory.
        g_self = g_array_set_size(
            g_self, 
            cast(uint)data.length
        );
        
        static if (hasElaborateMove!T) {
            nogc_move(slice, data);
        } else {
            nogc_copy(slice, data);
        }
    }

    /**
        Copy constructor.
    */
    this(ref scope typeof(this) rhs) {
        g_self = g_array_ref(rhs.g_self);
    }

    /**
        Resizes the array.
    */
    void resize(size_t newSize) {
        g_self = g_array_set_size(g_self, cast(uint)newSize);
    }

    /**
        Inserts elements into the array at the given index.

        Params:
            i =         Index to insert the elements.
            elements =  The elements to insert.
    */
    void insert(size_t i, T[] elements) {
        g_self = g_array_insert_vals(g_self, cast(uint)i, elements.ptr, cast(uint)elements.length);
    }

    /**
        Removes an index or range from the array.

        Params:
            i =         Index to remove from.
            length =    The amount of elements to remove.
    */
    void remove(size_t i, size_t length = 1) {
        if (length == 0) 
            return;
            
        if (length == 1) {
            g_self = g_array_remove_index(g_self, cast(uint)i);
            return;
        } 

        g_self = g_array_remove_range(g_self, cast(uint)i, cast(uint)length);
    }

    /**
        Increases the refcount by 1.
    */
    void retain() { g_self = g_array_ref(g_self); }
    
    /**
        Decreases the refcount by 1.
    */
    void release() { g_array_unref(g_self); }
}

@("GArray")
unittest {
    import nulib.collections.vector : vector;
    int[5] tmp = [0, 1, 2, 3, 4];

    GArray!int myArray = tmp;
    assert(myArray == [0, 1, 2, 3, 4]);
}

private:
extern(C) nothrow @nogc:

struct GArrayT {
    void* data;
    uint length;
}

extern GArrayT* g_array_new(bool zeroTerminated, bool clear, uint elementSize);
extern GArrayT* g_array_sized_new(bool zeroTerminated, bool clear, uint elementSize, uint reserved);
extern GArrayT* g_array_copy(GArrayT* array);
extern void g_array_free(GArrayT* array, bool freeSegment);
extern GArrayT* g_array_ref(GArrayT* array);
extern void g_array_unref(GArrayT* array);
extern uint g_array_get_element_size(GArrayT* array);
extern GArrayT* g_array_append_vals(GArrayT* array, const(void)* data, uint length);
extern GArrayT* g_array_prepend_vals(GArrayT* array, const(void)* data, uint length);
extern GArrayT* g_array_insert_vals(GArrayT* array, uint i, const(void)* data, uint length);
extern GArrayT* g_array_set_size(GArrayT* array, uint length);
extern GArrayT* g_array_remove_index(GArrayT* array, uint index);
extern GArrayT* g_array_remove_range(GArrayT* array, uint index, uint length);
