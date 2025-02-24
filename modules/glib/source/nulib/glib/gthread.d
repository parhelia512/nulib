/**
    GThread

    Copyright: Copyright © 1995-1997, Peter Mattis, Spencer Kimball and Josh MacDonald
    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(LINK2 https://gitlab.gnome.org/GNOME/glib/-/blob/main/LICENSES/LGPL-2.1-or-later.txt, LGPL-2.1-or-later)
    Authors:   Luna Nielsen
*/
module nulib.glib.gthread;
import nulib.glib.gerror;
import numem.core.traits : isSomeFunction;
import numem.core.hooks : nu_malloc, nu_free;
import hookset;

/**
    A GLib Thread.
*/
struct GThread {
private:

    // Temporary storage type for GThread state.
    // D delegates get mangled during thread creation.
    // this solves that.
    struct gthread_state_t {
        void* function(void* ctx) fptr;
        void* ctxptr;
    }

public:
@nogc:
    @disable this();

    /**
        Tries to spawn a new thread with the given delegate.
    */
    static GThread* run(void* delegate() scope dg) {
        GError* err;
        auto self = GThread.tryRun(dg, err);
        if (err)
            throw err.toException();
        
        return self;
    }

    /**
        Attempts to create a new thread.
    
        T
    */
    static GThread* tryRun(void* delegate() scope dg, ref GError* error) nothrow {
        gthread_state_t* state = cast(gthread_state_t*)nu_malloc(gthread_state_t.sizeof);
        state.ctxptr = dg.ptr;
        state.fptr = cast(void* function(void* ctx))dg.funcptr;

        g_thread_func_t fp = cast(g_thread_func_t)(void* dgIn) {
            gthread_state_t* state = cast(gthread_state_t*)dgIn;
            scope(exit) nu_free(state);
            
            try {
                return state.fptr(state.ctxptr);
            } catch(Exception ex) {
                nu_fatal(ex.msg);
                assert(0);
            }
            
            assert(0);
        };

        return g_thread_try_new(null, fp, state, error);
    }

    /**
        Waits for the thread
    */
    void* join() {
        return g_thread_join(&this);
    }

    /**
        Gets the calling thread.

        Returns:
            A GThread
    */
    static @property GThread* self() nothrow { return g_thread_self(); }
    
    /**
        Yields the calling thread.
    */
    static void yield() nothrow { g_thread_yield(); }

    /**
        Terminates the calling thread.
    */
    static void terminate() nothrow { g_thread_exit(null); }

    /**
        Terminates the calling thread with a given value.

        Params:
            value = The value to pass to $(D join).
    */
    static void exit(void* value) nothrow { g_thread_exit(value); }
}


@("GThread")
unittest {
    __gshared int x;

    GThread* t = GThread.run(() {
        x = 42;
        return cast(void*)x;
    });
    assert(cast(int)t.join() == x);
}

private:
extern(C) nothrow @nogc:

alias g_thread_func_t = extern(C) void* function(void*) @nogc;

extern GThread* g_thread_try_new(const(char)* name, g_thread_func_t func, void* data, ref GError* error);
extern void g_thread_exit(void* retval);
extern GThread* g_thread_self();
extern void g_thread_yield();
extern void* g_thread_join(GThread* thread);