module nulib.gobject.gobject;
import nulib.gobject.internal;
import nulib.gtype;
import numem.object;
import numem.core.traits;
import nulib.string;
import core.attribute;

/**
    Size of a pointer.
*/
enum g_ptr_size = (void*).sizeof;

/**
    Wraps $(D g_object_ref) to be compatible with the hybrid GObject-
    D types.
*/
extern(C)
GObject d_object_ref(GObject obj) @nogc nothrow {
    return g_object_realign(
        g_object_ref(
            g_object_realign(obj)
        )
    );
}

/**
    Wraps $(D g_object_unref) to be compatible with the hybrid GObject-
    D types.
*/
extern(C)
void d_object_unref(GObject obj) @nogc nothrow {
    g_object_unref(
        g_object_realign(obj)
    );
}

/**
    Generates dummy fields to inject into the VTable.
*/
mixin template G_DUMMY(size_t count) {
    static foreach(i; 0..count) {
        mixin("abstract void __DUMMY_", typeof(this), __LINE__, "();");
    }
}

/**
    Base class of all GObject classes.
*/
abstract
class GObject : GTypeClass {
extern(D):
private:
@nogc:
    uint ref_count;
    void* qdata;

public:
    abstract void setProperty(uint propertyId, const(void)*, void* pspec);
    abstract void getProperty(uint propertyId, void*, void* pspec);
    abstract void dispose();
    abstract void finalize();
    abstract void dispatchPropertiesChanged(uint npspecs, void** pspecs);
    abstract void notify(void* pspec);
    abstract void constructed();

    /**
        Creates a new instance of the given type.
    */
    static T create(T = typeof(this), Args...)(const(char)* propertyName, Args args) if (is(T : GObject)) {
        return g_object_fixup!T(g_object_new_valist(g_object_get_d_type(T.classinfo), propertyName, args));
    }

    /**
        Creates a new instance of the given type.
    */
    static T create(T = typeof(this), Args...)() if (is(T : GObject)) {
        return g_object_fixup!T(g_object_new_with_properties(g_object_get_d_type(T.classinfo), 0, null, null));
    }

    /**
        Adds one to the GObject refcount.
    */
    final GObject retain() => d_object_ref(this);

    /**
        Subtracts one to the GObject refcount.
    */
    final void release() => d_object_unref(this);

    /**
        Gets a name field from the object's table of associations.
    */
    final void* get(const(char)* key) => g_object_get_data(this, key);

    /**
        Gets a name field from the object's table of associations.
    */
    final void set(const(char)* key, void* data) => g_object_set_data(this, key, data);

    /**
        Gets the name of the GObject.
    */
    override
    string toString() {
        const(char)* typeName = g_type_name(this.type());
        return cast(string)typeName[0..nu_strlen(typeName)];
    }
}

size_t _g_d_vtbl_offset0 = __traits(getVirtualIndex, GTypeClass.g_vtbl_padding);
size_t _g_d_vtbl_offset1 = __traits(getVirtualIndex, GTypeClass.g_type_initializer);

/**
    The lowest level base class of the GObject Type System.

    This can not be directly created, and shouldn't be.
*/
class GTypeClass : NuObject {
extern(D):
@nogc private:
    GTypeInstance g_type_instance;

protected:

    /**
        Gets the offset of vtable's beginning.
    */
    ptrdiff_t g_vtbl_padding() { return 3; }

    /**
        Gets the name of the initializer for this type.
        eg. $(D g_application)
    */
    abstract immutable(char)[] g_type_initializer();

    /**
        The GObject vtable.
    */
    final
    @property auto g_class() { return g_type_instance.g_class; }

    /**
        The original base GObject alignment of this object.
    */
    final
    @property void* g_base_align() {
        return (cast(void*)this)-_G_GOBJECT_PRIVATE_OFFSET;
    }

public:

    /**
        The GType of this object.
    */
    final
    @property GType type() { return g_type_instance.g_class.g_type; }
}

extern(C) @nogc nothrow:

extern GObject g_object_new_valist(GType, const(char)*, ...);
extern GObject g_object_new_with_properties(GType, uint, const(char)**, const(void)*);
extern GObject g_object_ref(GObject);
extern void g_object_unref(GObject);
extern void* g_object_get_data(GObject, const(char)*);
extern void g_object_set_data(GObject, const(char)*, void*);