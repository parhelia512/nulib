module nulib.gobject.internal;
import nulib.glib;
import nulib.gmodule;
import nulib.gobject.gobject;
import nulib.gtype;
import nulib.collections.map : weak_map;
import numem.core.memory : nu_dup;
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
    g_assert(_g_get_base_type().isBaseOf(ti), "D Types need to inherit from GTypeClass!");
    if (ti is _g_get_base_type())
        return;

    nstring g_class_name = _g_extract_class_name(ti);
    GType type = _g_object_try_get_type(ti);
    const(char)* _g_type_name = g_type_name(type);

    g_assert(type != G_TYPE_INVALID, "Could not find type %s! Is the library for it linked in?", g_class_name.ptr);
    g_errorif(_G_TYPE_MAP.contains(type), "Attempted to re-register %s", _g_type_name);

    if (type != G_TYPE_INVALID) {
        _G_TYPE_MAP[type] = ti;
        _g_object_fixup(type, ti);
        d_log(G_LOG_LEVEL_INFO, "Registered %p as %s...", cast(void*)ti, _g_type_name);
    }
}

/**
    Gets the type associated with the given class typeinfo,
    if the class is not registered within the system, the system
    will attempt to register it for you.
*/
GType g_object_get_d_type(TypeInfo_Class ti) {
    GType type = _g_object_try_get_type(ti);
    if (type == G_TYPE_INVALID) {
        g_object_register_d_type(ti);
    }
    
    type = _g_object_try_get_type(ti);
    if (type == G_TYPE_INVALID) {
        return G_TYPE_NONE;
    }

    return _g_object_try_get_type(ti);
}

/**
    Type pre-fixup, turning it from "just" a GObject
    to a GObject wrapped in a NuObject.
*/
T g_object_fixup(T)(GObject object, TypeInfo_Class ti = T.classinfo) {
    if (object.__vptr[0] == ti.vtbl[0])
        return cast(T)object;

    // Unhide our private data section.
    // this is where our hybrid GObject-D class *really*
    // begins.
    object = g_object_realign(object);

    // Add vtable.
    *(cast(void***)object) = _G_D_VTABLE_REGISTRY[cast(void*)ti].ptr;
    return cast(T)object;
}

GObject g_object_realign(GObject object) {
    GTypeInstance* ti = cast(GTypeInstance*)object;
    if (ti && ti.g_class) {
        if (g_type_fundamental(ti.g_class.g_type) == G_TYPE_OBJECT)
            return cast(GObject)(cast(void*)object + _G_GOBJECT_PRIVATE_OFFSET);
    }
    return cast(GObject)(cast(void*)object - _G_GOBJECT_PRIVATE_OFFSET);
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
    if (expr)
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
    Fixup a GObject-derived class using a D TypeInfo.
*/
void _g_object_fixup(GType g_type, TypeInfo_Class ti) {

    // Handle dependency objects
    if (ti.base !is _g_get_base_type()) {
        auto parent = g_object_get_d_type(ti.base);
        if (parent != G_TYPE_NONE && !_G_TYPE_MAP.contains(parent)) {
            g_object_register_d_type(ti.base);
        }
    }

    d_log(G_LOG_LEVEL_DEBUG, "Running fixups for %s...", g_type_name(g_type));
    _G_D_VTABLE_REGISTRY[cast(void*)ti] = ti.vtbl.nu_dup;
    _g_object_blit_d_vtbls(_G_D_VTABLE_REGISTRY[cast(void*)ti], ti);
    _g_object_fixup_vtbls(g_type, ti, ti);
}

struct _g_object_fixup_vtblc {
    size_t d_offset;
    size_t g_offset;
}

// Blits D vtables first.
auto _g_object_blit_d_vtbls(void*[] vtbl, TypeInfo_Class target) {
    
    // First entry will always be the type-info.
    // as such we skip it.
    foreach(i; 1..target.vtbl.length) {
        auto symptr = _g_find_first_sym_ptr(target, i);
        vtbl[i] = symptr;
    }
}

T* _g_object_vtbl_entry(T)(TypeInfo_Class ti, size_t offset) {
    if (ti.vtbl[offset])
        return cast(T*)ti.vtbl[offset];

    if (_G_D_VTABLE_REGISTRY.contains(cast(void*)ti))
        return cast(T*)_G_D_VTABLE_REGISTRY[cast(void*)ti][offset];
    
    return null;
}

// Recursively traverses ti until it finds a vtbl entry for the given
// index, or returns null if no entries for that was found.
void* _g_find_first_sym_ptr(ref TypeInfo_Class ti, size_t index) {
    if (index >= ti.vtbl.length)
        return null;
    
    // Look at base impl.
    if (ti.vtbl[index] is null)
        return _g_find_first_sym_ptr(ti.base, index);

    return ti.vtbl[index];
}

// Overwrites D vtbl entries that are still 0.
auto _g_object_fixup_vtbls(GType g_type, TypeInfo_Class ti, TypeInfo_Class target) {
    if (ti is _g_get_base_type()) {
        size_t padding = _g_object_get_ti_vtbl_padding(ti);
        return _g_object_fixup_vtblc(_G_DVPTR_OFFSET, 3);
    }

    GTypeQuery query;
    g_type_query(g_type, query);

    // Get the fixup offset for both GObject and our type info.
    auto f_offset = _g_object_fixup_vtbls(g_type_parent(g_type), ti.base, target);

    // Short-circuit if we don't have any more vtbl space left.
    if (f_offset.d_offset >= (query.class_size / g_ptr_size) || f_offset.g_offset >= target.vtbl.length)
        return f_offset;

    auto g_vtbl = _g_object_get_class(g_type);

    size_t vtcount = target.vtbl.length - f_offset.d_offset;
    foreach(i; 0..vtcount) {
        size_t g_offset = f_offset.g_offset + i;
        size_t d_offset = f_offset.d_offset+i;
        auto g_table_entry = &(cast(void**)g_vtbl)[g_offset];
        auto d_table_entry = &(_G_D_VTABLE_REGISTRY[cast(void*)target][d_offset]);
        
        // Implementation was overwritten!
        if (*d_table_entry) {
            *g_table_entry = *d_table_entry;
            continue;
        }

        // GObject Implementation is the winner.
        if (*g_table_entry) {
            *d_table_entry = *g_table_entry;
            continue;
        }
    }

    size_t padding = _g_object_get_ti_vtbl_padding(ti);
    return _g_object_fixup_vtblc(ti.vtbl.length, (query.class_size / g_ptr_size)+padding);
}

/**
    Gets the padding of a type, if the vtable entry is unchanged (vtbl offset function
    wasn't overriden), then 0 will be returned, otherwise the given offset is returned.
*/
size_t _g_object_get_ti_vtbl_padding(TypeInfo_Class ti) {
    void* paddingFuncPtr = _g_object_vtbl_entry!(void*)(ti, _g_d_vtbl_offset0);
    if (!paddingFuncPtr)
        return 0;

    auto paddingFunc = cast(size_t function(void*) @nogc nothrow)paddingFuncPtr;
    return paddingFunc(null);
}

auto _g_object_get_gobject() {
    return _g_object_get_class(G_TYPE_OBJECT);
}

/**
    Tries to get a function with the given signature
*/
auto _g_object_try_get_vtbl_function(RetT, Args...)(void*[] vtbl, ptrdiff_t offset) {
    if (offset < 0)
        offset = vtbl.length-offset;

    return cast(RetT function(void*, Args...) @nogc nothrow)vtbl[offset];
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

    if (auto typeInitPtr = ti.vtbl[_g_d_vtbl_offset1]) {
        auto typeInitFunc = cast(immutable(char)[] function(void*) @nogc nothrow)typeInitPtr;
        out_ ~= typeInitFunc(null);
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

/**
    This constructor hooks in to GType and forces the padding of GObject
    to align with $(D NuObject).
*/
void _g_dinterop_init() {
    
    // Already initialized...
    if (_G_APPLICATION_SELF)
        return;

    import numem.core.traits : AllocSize;
    d_log(G_LOG_LEVEL_INFO, "Initializing GObject<->D bridge...");
    
    // Adjust GObject private offset to fit a D Object.
    int allocSize = AllocSize!NuObject;
    auto g_object_class = _g_object_get_gobject();
    g_type_class_adjust_private_offset(g_object_class, &allocSize);

    // Setup internal state for the fixup system.
    _G_DVPTR_OFFSET = _g_get_base_type().vtbl.length;
    _G_GOBJECT_PRIVATE_OFFSET = g_type_class_get_instance_private_offset(g_object_class);
    debug {
        d_log(G_LOG_LEVEL_DEBUG, "GObject private offset=%lli", _G_GOBJECT_PRIVATE_OFFSET);
        d_log(G_LOG_LEVEL_DEBUG, "DGObject vtable offset=%llu", _G_DVPTR_OFFSET);
    }

    int instanceCount = g_type_get_instance_count(G_TYPE_OBJECT);
    assert(_G_GOBJECT_PRIVATE_OFFSET <= -allocSize, "Failed to adjust GObject type offset!");
    if (instanceCount > 0) {
        d_log(G_LOG_LEVEL_WARNING, "GObjects instantiated prior to nulib-gobject are likely corrupted...");
    }

    _G_APPLICATION_SELF = GModule.application;
    d_log(G_LOG_LEVEL_INFO, "Initialization completed!");
}

/**
    Gets the base type.
*/
TypeInfo_Class _g_get_base_type() {
    return typeid(GObject).base;
}

enum _GOBJECT_VTBL_BEGIN_PADDING = 3;

/**
    Variable used by the fixup function to properly align the vtables.

    This is essentially the offset into NuObject's vtable where the
    GObject should begin.
*/
extern(C)
export __gshared size_t _G_DVPTR_OFFSET = 0;

/**
    The offset into a GObject instance that the private
    data begins.

    Ideally this should align perfectly with the D class
    instance ABI.
*/
extern(C)
export __gshared ptrdiff_t _G_GOBJECT_PRIVATE_OFFSET = 0;

/**
    The internal type map shared across all threads.

    This type map lives for the duration of the program.
*/
extern(C)
export __gshared static weak_map!(GType, TypeInfo_Class) _G_TYPE_MAP;

/**
    Modified copies of each class's vtables.

    This is cursed I know but until I add extern(GObject) this is the
    best we get.
*/
extern(C)
export __gshared static weak_map!(void*, void*[]) _G_D_VTABLE_REGISTRY;

/**
    A reference to this application.
*/
extern(C)
export __gshared static GModule* _G_APPLICATION_SELF;

/**
    Symbol which is always null.
*/
extern(C)
export __gshared static void* _NULL_SYM = null;