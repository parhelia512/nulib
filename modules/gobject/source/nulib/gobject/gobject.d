module nulib.gobject.gobject;
import nulib.gobject.internal;
import nulib.gtype;
import numem.object;
import numem.core.traits;
import nulib.string;

/**
    Offset into GObject vtable.
*/
struct g_vtbl_offset { size_t offset; }

/**
    Size of a pointer.
*/
enum g_ptr_size = (void*).sizeof;

template GObjectVTableOffset(T) if (is(T : GTypeClass)) {
    template baseType(X) {
        static if (is(X Y == super))
            alias baseType = Y;
    }

    alias offsets = getUDAs!(T, g_vtbl_offset);
    static if (!is(T == GTypeClass)) {
        static if (offsets.length > 0) {
            enum GObjectVTableOffset = offsets[0].offset + GObjectVTableOffset!(baseType!T);
        } else {
            enum GObjectVTableOffset = GObjectVTableOffset!(baseType!T);
        }
    } else {
        enum GObjectVTableOffset = 0;
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

protected:
    override size_t g_vtbl_padding() { return g_ptr_size*3; }

public:
    void setProperty(uint propertyId, const(void)*, void* pspec) { }
    void getProperty(uint propertyId, void*, void* pspec) { }
    void dispose() { }
    void finalize() { }
    void dispatchPropertiesChanged(uint npspecs, ref void* pspecs) { }
    void notify(void* pspec) { }
    void constructed() { }

    /**
        Creates a new instance of the given type.
    */
    static T create(T = typeof(this), Args...)(const(char)* propertyName, Args args) if (is(T : GObject)) {
        return g_object_realign!T(g_object_new_valist(g_object_get_d_type(T.classinfo), propertyName, args));
    }

    /**
        Creates a new instance of the given type.
    */
    static T create(T = typeof(this), Args...)() if (is(T : GObject)) {
        return g_object_realign!T(g_object_new_with_properties(g_object_get_d_type(T.classinfo), 0, null, null));
    }

    /**
        Adds one to the GObject refcount.
    */
    final GObject retain() => g_object_ref(this);

    /**
        Subtracts one to the GObject refcount.
    */
    final GObject retlease() => g_object_unref(this);

    /**
        Gets a name field from the object's table of associations.
    */
    final void* get(const(char)* key) => g_object_get_data(this, key);

    /**
        Gets a name field from the object's table of associations.
    */
    final void set(const(char)* key, void* data) => g_object_set_data(this, key, data);
}

size_t _g_d_vtbl_offset0 = __traits(getVirtualIndex, GTypeClass.g_vtbl_padding);
size_t _g_d_vtbl_offset1 = __traits(getVirtualIndex, GTypeClass.g_type_initializer);

private
class GTypeClass : NuObject {
extern(D):
@nogc:
private:
    GTypeInstance g_type_instance;

protected:

    /**
        Gets the offset of vtable's beginning.
    */
    size_t g_vtbl_padding() { return g_ptr_size; }

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

public:

    /**
        The GType of this object.
    */
    final
    @property GType type() { return g_type_instance.g_class.g_type; }

    /**
        Gets the name of the GObject.
    */
    override
    string toString() {
        const(char)* typeName = g_type_name(this.type());
        return cast(string)typeName[0..nu_strlen(typeName)];
    }
}

extern(C) @nogc nothrow:

extern GObject g_object_new_valist(GType, const(char)*, ...);
extern GObject g_object_new_with_properties(GType, uint, const(char)**, const(void)*);
extern GObject g_object_ref(GObject);
extern GObject g_object_unref(GObject);
extern void* g_object_get_data(GObject, const(char)*);
extern void g_object_set_data(GObject, const(char)*, void*);