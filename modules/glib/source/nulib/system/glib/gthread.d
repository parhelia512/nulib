/**
    GThread

    Copyright: Copyright © 1995-1997, Peter Mattis, Spencer Kimball and Josh MacDonald
    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(LINK2 https://gitlab.gnome.org/GNOME/glib/-/blob/main/LICENSES/LGPL-2.1-or-later.txt, LGPL-2.1-or-later)
    Authors:   Luna Nielsen
*/
module nulib.system.glib.gthread;

/**
    A GLib Thread.
*/
struct GThread {
private nothrow:
@nogc:
    GThreadT* g_self;

    this(GThreadT* g_self) { this.g_self = g_self; }

public:
    
    /* Disabled, since g_self should not be null. */
    @disable this();

    /**
        Creates and starts a new thread.
    */
    this(void delegate() dg)  {
        g_thread_func_t fp = cast(g_thread_func_t)(void* dg) {
            (*cast(void delegate()*)&dg)();
            return null;
        };

        g_self = g_thread_new(null, fp, cast(void*)&dg);
    }

    /**
        Waits for the thread
    */
    void* join() { 
        return g_thread_join(g_self);
    }

    /**
        Gets the calling thread.
    */
    static @property GThread self() { return GThread(g_thread_self()); }
    
    /**
        Yields the calling thread.
    */
    static void yield() { g_thread_yield(); }

    /**
        Terminates the calling thread.
    */
    static void terminate() { g_thread_exit(null); }
}


@("Threading")
unittest {
    int x;
    GThread t = GThread(() {
        x = 42;
    });
}

private:
extern(C) nothrow @nogc:

alias g_thread_func_t = extern(C) void* function(void*) @nogc nothrow;

struct GThreadT;

extern GThreadT* g_thread_new(const(char)* name, g_thread_func_t func, void* data);
extern void g_thread_exit(void* retval);
extern GThreadT* g_thread_self();
extern void g_thread_yield();
extern void* g_thread_join(GThreadT* thread);