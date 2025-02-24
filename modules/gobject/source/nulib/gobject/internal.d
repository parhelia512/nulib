module nulib.gobject.internal;
import nulib.glib;
import nulib.gmodule;
import nulib.gobject.gobject;
import nulib.gtype;
import nulib.collections.map : weak_map;
import nulib.string;
import numem;
import core.stdc.time;

nothrow @nogc:

/**
    Gets whether a D type was already bound.
*/
extern(C)
bool g_object_has_d_type(TypeInfo_Class ti) {
    GType type = _g_object_try_get_type(ti);
    if (type == G_TYPE_INVALID)
        return false;
    
    return _G_TYPE_MAP.contains(type);
}

/**
    Registers a D type binding.
*/
extern(C)
void g_object_register_d_type(TypeInfo_Class ti) {
    g_assert(GObject.classinfo.base.isBaseOf(ti), "D Types need to inherit from GTypeClass!");

    nstring g_class_name = _g_extract_class_name(ti);
    GType type = _g_object_try_get_type(ti);
    g_assert(type != G_TYPE_INVALID, "Could not find type %s! Is the library for it linked in?", g_class_name.ptr);
    g_errorif(!_G_TYPE_MAP.contains(type), "Attempted to re-register %s", g_type_name(type));

    _G_TYPE_MAP[type] = ti;
    d_log(G_LOG_LEVEL_INFO, "Registered %p as %s...", cast(void*)ti, g_type_name(type));
}

/**
    Logging function used by GObject bridge system.
*/
pragma(inline, true)
void d_log(Args...)(GLogLevel log_level, const(char)* format, Args args) {
    
    import nulib.glib.gerror : g_intern_static_string;
    g_log(g_intern_static_string("nulib-gobject"), log_level, format, args);
}

/**
    Logging function used by GObject bridge system.
*/
pragma(inline, true)
void g_assert(T, Args...)(T expr, const(char)* format, Args args) {
    if (!expr)
        d_log(G_LOG_LEVEL_CRITICAL | G_LOG_FLAG_FATAL, format, args);
}

/**
    Logging function used by GObject bridge system.
*/
pragma(inline, true)
void g_errorif(T, Args...)(T expr, const(char)* format, Args args) {
    if (!expr)
        d_log(G_LOG_LEVEL_ERROR, format, args);
}

package(nulib.gobject):

const(char)[] _g_extract_class_name(TypeInfo_Class ti) {
    foreach_reverse(i, c; ti.name) {
        if (c == '.') {
            return ti.name[i+1..$];
        }
    }
    return ti.name;
}

/**
    Gets whether the given version number is compatible.
*/
bool _g_version_compatible(uint major, uint minor, uint patch = 0) {
    return glib_check_version(major, minor, patch) is null;
}

/**
    Type pre-fixup, turning it from "just" a GObject
    to a GObject wrapped in a NuObject.
*/
void _g_object_pre_fixup(ref GObject object, TypeInfo_Class ti) {
    g_assert(ti, "Attempted null pre-fixup for %p", object);

    // Unhide our private data section.
    // this is where our hybrid GObject-D class *really*
    // begins.
    void* objptr = cast(void*)object;
    objptr += _G_GOBJECT_PRIVATE_OFFSET;
    object = cast(GObject)objptr;

    // Replace vtable with the one from our GObject
    // wrapper.
    // This wrapper *should* only feature the basic GObject vtable.
    auto vptr = cast(void***)&object.__vptr;
    *vptr = ti.vtbl.ptr;
}

/**
    Fixup a GObject-derived class using a D TypeInfo.
*/
void _g_object_fixup(ref GObject object, TypeInfo_Class ti = null) {
    if (!ti)
        ti = typeid(GObject);

    // Class has already been fixed up.
    if (object.__vptr && (object.__vptr[0] == ti.vtbl[0])) {
        debug d_log(G_LOG_LEVEL_DEBUG, "Attempted to fixup %p which already has been fixed up!", object);
        return;
    }

    // Do the pre-fixup step.
    _g_object_pre_fixup(object, ti);
}

auto _g_object_get_gobject() {
    return _g_object_get_class(G_TYPE_OBJECT);
}

/**
    Attempts to find a type by its name
*/
GType _g_object_try_get_type(TypeInfo_Class ti) {
    auto typeName = _g_extract_class_name(ti);

    // Type is already loaded, just return it.
    if (GType type = g_type_from_name(typeName.ptr))
        return type;

    nstring initializer = _g_get_type_initializer_name(ti, typeName);

    // Type was not loaded already, try to load it.
    GType function() @nogc nothrow sym;
    if (_G_APPLICATION_SELF.getSymbol(initializer.ptr, sym)) {
        return sym();
    }
    
    // We could not find the type.
    return G_TYPE_INVALID;
}

nstring _g_get_type_initializer_name(TypeInfo_Class ti, const(char)[] typeName) {
    nstring out_;

    // Type has an initializer declared.
    if (ti.vtbl[$-1]) {
        auto g_init_name_func = cast(immutable(char)[] function(void*) @nogc nothrow)ti.vtbl[$-1];
        out_ ~= g_init_name_func(null);
    } else {
        nstring g_d_typename = ti.name;

        d_log(G_LOG_LEVEL_WARNING, "%s does not have an initializer function!", g_d_typename.ptr);
        out_ ~= g_to_snake_case(typeName);
    }

    // NOTE:    type_name_get_type is the name of the function we're looking for.
    out_ ~= "_get_type";
    return out_;
}

nstring g_to_snake_case(const(char)[] typeName) {

    import nulib.glib.gstring : g_ascii_tolower;
    nstring out_;
    out_ ~= g_ascii_tolower(typeName[0]);
    foreach(c; typeName[1..$]) {
        if (c >= 'A' && c <= 'Z') {
            out_ ~= "_";
            out_ ~= g_ascii_tolower(c);
            continue;
        }

        out_ ~= c;
    }
    return out_;
}

auto _g_object_get_class(GType type) {
    if (auto obj = g_type_class_peek_static(type))
        return obj;

    if (_g_version_compatible(2, 84))
        return g_type_class_get(type);
    return g_type_class_ref(type);
}

void _g_object_vtbl_init() {
    auto g_vtbl = _g_object_get_gobject();
    size_t g_vtbl_offset = GObjectVTableOffset!GObject;

    TypeInfo_Class gobject_ti = typeid(GObject);
    debug d_log(G_LOG_LEVEL_DEBUG, "Replacing d vtable starting at %p...", gobject_ti.vtbl.ptr+_G_DVPTR_OFFSET);
    foreach(i; _G_DVPTR_OFFSET..gobject_ti.vtbl.length) {
        gobject_ti.vtbl[i] = (cast(void**)g_vtbl)[g_vtbl_offset+i];
    }
    debug d_log(G_LOG_LEVEL_DEBUG, "Done!");
}

/**
    This constructor hooks in to GType and forces the padding of GObject
    to align with $(D NuObject).
*/
void _g_dinterop_init() {
    import numem.core.traits : AllocSize;
    d_log(G_LOG_LEVEL_INFO, "Initializing GObject<->D bridge...");
    
    // Adjust GObject private offset to fit a D Object.
    int allocSize = AllocSize!NuObject;
    auto g_object_class = _g_object_get_gobject();
    g_type_class_adjust_private_offset(g_object_class, &allocSize);

    // Setup internal state for the fixup system.
    _G_DVPTR_OFFSET = _g_get_base_type().vtbl.length*g_ptr_size;
    _G_GOBJECT_PRIVATE_OFFSET = g_type_class_get_instance_private_offset(g_object_class);
    debug {
        d_log(G_LOG_LEVEL_DEBUG, "GObject private offset=%lli", _G_GOBJECT_PRIVATE_OFFSET);
        d_log(G_LOG_LEVEL_DEBUG, "D vtable offset=%llu", _G_DVPTR_OFFSET);
    }

    int instanceCount = g_type_get_instance_count(G_TYPE_OBJECT);
    assert(_G_GOBJECT_PRIVATE_OFFSET <= -allocSize, "Failed to adjust GObject type offset!");
    if (instanceCount > 0) {
        d_log(G_LOG_LEVEL_WARNING, "GObjects instantiated prior to nulib-gobject are likely corrupted...");
    }

    // Fixup basic GObject<->D type vtable.
    _g_object_vtbl_init();
    _G_APPLICATION_SELF = GModule.application;
    d_log(G_LOG_LEVEL_INFO, "Initialization completed!");
}

/**
    Gets the base type.
*/
TypeInfo_Class _g_get_base_type() {
    return typeid(GObject).base;
}

private:

/**
    Variable used by the fixup function to properly align the vtables.

    This is essentially the offset into NuObject's vtable where the
    GObject should begin.
*/
__gshared size_t _G_DVPTR_OFFSET = 0;

/**
    The offset into a GObject instance that the private
    data begins.

    Ideally this should align perfectly with the D class
    instance ABI.
*/
__gshared ptrdiff_t _G_GOBJECT_PRIVATE_OFFSET = 0;

/**
    The internal type map shared across all threads.

    This type map lives for the duration of the program.
*/
__gshared weak_map!(GType, TypeInfo_Class) _G_TYPE_MAP;

/**
    A reference to this application.
*/
__gshared GModule* _G_APPLICATION_SELF;