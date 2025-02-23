/**
    GLib Mutexes

    Copyright: Copyright © 1995-1997, Peter Mattis, Spencer Kimball and Josh MacDonald
    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(LINK2 https://gitlab.gnome.org/GNOME/glib/-/blob/main/LICENSES/LGPL-2.1-or-later.txt, LGPL-2.1-or-later)
    Authors:   Luna Nielsen
*/
module nulib.system.glib.gmutex;

//  NOTE:   DLang has stricter guarantees for struct instantiation.
//          Given g_self is set to null it should always be
//          zero-initialized by default.
//          
//          As such, we don't have g_mutex_init; GMutex.init would
//          do the same thing.

/**
    A GLib Mutex
*/
struct GMutex {
@nogc nothrow:
private:
    void* g_self = null;

public:

    /**
        Frees the resources allocated to a mutex.
    */
    void clear() @safe { g_mutex_clear(this); }

    /**
        Locks the mutex, if the mutex is already locked,
        blocks the calling thread until the mutex is unlocked.
    */
    void lock() @safe { g_mutex_lock(this); }

    /**
        Tries to lock the mutex and returns whether this succeeded.

        Returns:
            $(D true) if the mutex was locked,
            $(D false) otherwise.
    */
    bool tryLock() @safe { return g_mutex_trylock(this); }

    /**
        Unlocks the mutex.
    */
    void unlock() @safe { g_mutex_unlock(this); }
}

private:

extern(C) @nogc nothrow:

extern void g_mutex_clear(ref GMutex mutex);
extern void g_mutex_lock(ref GMutex mutex);
extern bool g_mutex_trylock(ref GMutex mutex);
extern void g_mutex_unlock(ref GMutex mutex);