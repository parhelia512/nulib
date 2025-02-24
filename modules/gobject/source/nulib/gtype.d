/**
    GType Bindings

    Copyright: Copyright © 1995-1997, Peter Mattis, Spencer Kimball and Josh MacDonald
    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(LINK2 https://gitlab.gnome.org/GNOME/glib/-/blob/main/LICENSES/LGPL-2.1-or-later.txt, LGPL-2.1-or-later)
    Authors:   Luna Nielsen
*/
module nulib.gtype;
import nulib.glib.gerror;
import core.attribute : weak;

enum G_TYPE_FUNDAMENTAL_SHIFT = 2;

/**
    Base GType type.
*/
alias GType = size_t;
enum GType 
    G_TYPE_FUNDAMENTAL_MAX = (255 << G_TYPE_FUNDAMENTAL_SHIFT),
    G_TYPE_INVALID = (0 << G_TYPE_FUNDAMENTAL_SHIFT),
    G_TYPE_NONE = (1 << G_TYPE_FUNDAMENTAL_SHIFT),
    G_TYPE_INTERFACE = (2 << G_TYPE_FUNDAMENTAL_SHIFT),
    G_TYPE_CHAR = (3 << G_TYPE_FUNDAMENTAL_SHIFT),
    G_TYPE_UCHAR = (4 << G_TYPE_FUNDAMENTAL_SHIFT),
    G_TYPE_BOOLEAN = (5 << G_TYPE_FUNDAMENTAL_SHIFT),
    G_TYPE_INT = (6 << G_TYPE_FUNDAMENTAL_SHIFT),
    G_TYPE_UINT = (7 << G_TYPE_FUNDAMENTAL_SHIFT),
    G_TYPE_LONG = (8 << G_TYPE_FUNDAMENTAL_SHIFT),
    G_TYPE_ULONG = (9 << G_TYPE_FUNDAMENTAL_SHIFT),
    G_TYPE_INT64 = (10 << G_TYPE_FUNDAMENTAL_SHIFT),
    G_TYPE_UINT64 = (11 << G_TYPE_FUNDAMENTAL_SHIFT),
    G_TYPE_ENUM = (12 << G_TYPE_FUNDAMENTAL_SHIFT),
    G_TYPE_FLAGS = (13 << G_TYPE_FUNDAMENTAL_SHIFT),
    G_TYPE_FLOAT = (14 << G_TYPE_FUNDAMENTAL_SHIFT),
    G_TYPE_DOUBLE = (15 << G_TYPE_FUNDAMENTAL_SHIFT),
    G_TYPE_STRING = (16 << G_TYPE_FUNDAMENTAL_SHIFT),
    G_TYPE_POINTER = (17 << G_TYPE_FUNDAMENTAL_SHIFT),
    G_TYPE_BOXED = (18 << G_TYPE_FUNDAMENTAL_SHIFT),
    G_TYPE_PARAM = (19 << G_TYPE_FUNDAMENTAL_SHIFT),
    G_TYPE_OBJECT = (20 << G_TYPE_FUNDAMENTAL_SHIFT),
    G_TYPE_VARIANT = (21 << G_TYPE_FUNDAMENTAL_SHIFT);

alias GTypeFlags = int;
enum GTypeFlags
    G_TYPE_FLAG_ABSTRACT = (1 << 4),
    G_TYPE_FLAG_VALUE_ABSTRACT = (1 << 5);

alias GTypeFundamentalFlags = int;
enum GTypeFundamentalFlags
    G_TYPE_FLAG_CLASSED = (1 << 0),
    G_TYPE_FLAG_INSTANTIATABLE = (1 << 1),
    G_TYPE_FLAG_DERIVABLE = (1 << 2),
    G_TYPE_FLAG_DEEP_DERIVABLE = (1 << 3);

struct _GTypeClass {
    GType g_type;
}

struct GTypeInstance {
    _GTypeClass* g_class;
}

struct GTypeInterface {
    GType g_type;
    GType g_instance_type;
}

struct GTypeInfo {
    ushort class_size;

    GBaseInitFunc base_init;
    GBaseFinalizeFunc base_finalize;

    /* interface types, classed types, instantiated types */
    GClassInitFunc class_init;
    GClassFinalizeFunc class_finalize;
    void* class_data;

    /* instantiated types */
    ushort instance_size;
    ushort n_preallocs;
    GInstanceInitFunc instance_init;

    const(GTypeValueTable)* value_table;
}

struct GTypeFundamentalInfo {
    GTypeFundamentalFlags type_flags;
}

struct GInterfaceInfo {
    GInterfaceInitFunc interface_init;
    GInterfaceFinalizeFunc interface_finalize;
    void* interface_data;
}

alias GValue = void*;
alias GTypeCValue = void*;
struct GTypeValueTable {
    void function(GValue* value) value_init;
    void function(GValue* value) value_free;
    void function(const(GValue)* src_value, GValue* dest_value) value_copy;

    /* varargs functionality (optional) */
    void* function(const(GValue)* value) value_peek_pointer;
    const(char)* collect_format;

    char* function(GValue* value,
        uint n_collect_values,
        GTypeCValue* collect_values,
        uint collect_flags) collect_value;
    const(char)* lcopy_format;
    char* function(const GValue* value,
        uint n_collect_values,
        GTypeCValue* collect_values,
        uint collect_flags) lcopy_value;
}

/**
    A structure holding information for a specific type.
    It is filled in by the g_type_query() function.
*/
struct GTypeQuery {
    GType type;
    const(char)* type_name;
    uint class_size;
    uint instance_size;
}


extern (C) nothrow @nogc:

alias GBaseInitFunc = void function(void*);
alias GBaseFinalizeFunc = void function(void*);
alias GClassInitFunc = void function(void*, void*);
alias GClassFinalizeFunc = void function(void*, void*);
alias GInstanceInitFunc = void function(GTypeInstance*, void*);
alias GInterfaceInitFunc = void function(void*, void*);
alias GInterfaceFinalizeFunc = void function(void*, void*);
alias _GTypeClassCacheFunc = void function(void*, _GTypeClass*);
alias GTypeInterfaceCheckFunc = void function(void*, void*);

// Type Introspection
extern const(char)* g_type_name(GType);
extern GQuark g_type_qname(GType);
extern GType g_type_from_name(const(char)*);
extern GType g_type_parent(GType);
extern uint g_type_depth(GType);
extern GType g_type_next_base(GType, GType);
extern bool g_type_is_a(GType, GType);
@weak extern _GTypeClass* g_type_class_get(GType type) { return g_type_class_ref(type); }
extern _GTypeClass* g_type_class_ref(GType);
extern _GTypeClass* g_type_class_peek(GType);
extern _GTypeClass* g_type_class_peek_static(GType);
extern void g_type_class_unref(_GTypeClass*);
extern void* g_type_class_peek_parent(void*);
extern void* g_type_interface_peek(void*, GType);
extern void* g_type_interface_peek_parent(void*);
extern void* g_type_default_interface_ref(GType);
extern void* g_type_default_interface_peek(GType);
extern void g_type_default_interface_unref(void*);
extern GType* g_type_children(GType, uint*);
extern GType* g_type_interfaces(GType, uint*);
extern void g_type_set_qdata(GType, GQuark, void*);
extern void* g_type_get_qdata(GType, GQuark);
extern void g_type_query(GType, ref GTypeQuery);
extern int g_type_get_instance_count(GType);

// Type Registration
extern GType g_type_register_static(GType parent_type, const(char)* type_name, const(GTypeInfo)* info, GTypeFlags flags);
extern GType g_type_add_interface_static(GType instance_type, GType interface_type, const(GInterfaceInfo)* info);
extern void g_type_add_instance_private(GType class_type, size_t private_size);
extern void g_type_class_adjust_private_offset(void* g_class, int* privateSizeOrOffset);
extern int g_type_class_get_instance_private_offset(void* g_class);

// Fundamental Types
extern GType g_type_fundamental_next();
extern GType g_type_fundamental(GType);
extern GTypeInstance* g_type_create_instance(GType);
extern void g_type_free_instance(GType);
extern GTypeValueTable* g_type_value_table_peek(GType);
extern GType g_type_register_fundamental(GType type_id, const(char)* type_name, const(GTypeInfo)* info, const(GTypeFundamentalInfo)* finfo, GTypeFlags flags);
