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

/**
    Creates a new
*/
T g_object_new(T, Args...)(Args args) {

}

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
@g_vtbl_offset(g_ptr_size*3)
class GObject : GTypeClass {
private:
@nogc:
    uint ref_count;
    void* qdata;

public:
extern(D):
    void setProperty(uint propertyId, const(void)*, void* pspec);
    void getProperty(uint propertyId, void*, void* pspec);
    void dispose();
    void finalize();
    void dispatchPropertiesChanged(uint npspecs, ref void* pspecs);
    void notify(void* pspec);
    void constructed();
}

private
class GTypeClass : NuObject {
@nogc:
private:
    GTypeInstance g_type_instance;

protected:

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

export
extern(C) void g_object_constructed(GObject object) {
    _g_object_fixup(object);
}