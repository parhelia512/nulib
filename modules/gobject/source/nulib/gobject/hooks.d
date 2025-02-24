/**
    Nulib GType Hooks.

    Copyright: Copyright © 1995-1997, Peter Mattis, Spencer Kimball and Josh MacDonald
    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(LINK2 https://gitlab.gnome.org/GNOME/glib/-/blob/main/LICENSES/LGPL-2.1-or-later.txt, LGPL-2.1-or-later)
    Authors:   Luna Nielsen
*/
module nulib.gobject.hooks;
import nulib.gobject.internal;
import nulib.gobject.gobject;
import nulib.gtype;
import nulib.glib;
import numem;

/**
    Initializes GObject.
*/
export
extern(C) void nu_gobject_init() {
    _g_dinterop_init();
    foreach(module_; ModuleInfo) {
        nu_gobject_register(module_);
    }
}

/**
    Template which adds a CRT constructor to your application,
    making the GObject binding system load before main().
*/
mixin template GObjectEntrypoint() {
    pragma(crt_constructor)
    extern(C) void _d_gobject_ctor() {
        nu_gobject_init();
    }
}

private:

void nu_gobject_register(ModuleInfo* module_) {
    
    // Skip loading class-less modules.
    if (module_.localClasses.length == 0)
        return;

    debug d_log(G_LOG_LEVEL_DEBUG, "Scanning %s...", module_.name.ptr);

    auto base_type = _g_get_base_type();
    foreach(TypeInfo_Class klass; module_.localClasses) {
        
        // Base type does not need to be registered,
        // it doesn't have an exact GObject equivalent.
        if (klass == base_type)
            continue;

        // Skip Non-GObject classes.
        if (!base_type.isBaseOf(klass))
            continue;

        // Skip already-registered types.
        if (g_object_has_d_type(klass))
            continue;
        
        g_object_register_d_type(klass);
        // TODO: Fixup vtables for the new types.
    }
}