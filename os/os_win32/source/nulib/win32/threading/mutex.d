/**
    Win32 Implementation for nulib.threading.internal.mutex

    Copyright:
        Copyright © 2025, Kitsunebi Games
        Copyright © 2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.win32.threading.mutex;
import nulib.threading.internal.mutex;
import nulib.win32.common;
import numem;

/**
    Native implementation of a mutually exclusive lock.
*/
class Win32Mutex : NativeMutex {
private:
    CRITICAL_SECTION* handle_;

public:
@nogc:

    /// Destructor
    ~this() nothrow {
        DeleteCriticalSection(handle_);
        nu_free(handle_);
    }

    /**
        Constructs a mutex.
    */
    this() nothrow {
        this.handle_ = cast(CRITICAL_SECTION*)nu_malloc(CRITICAL_SECTION.sizeof);

        // Cargo-culting the spin-count in WTF::Lock
        // See: https://webkit.org/blog/6161/locking-in-webkit/
        cast(void)InitializeCriticalSectionAndSpinCount(handle_, 40);
    }

    /**
        Increments the internal lock counter.
    */
    override
    void lock() nothrow @trusted {
        EnterCriticalSection(handle_);
    }

    /**
        Tries to increment the internal lock counter.

        Returns:
            $(D true) if the mutex was locked,
            $(D false) otherwise.
    */
    override
    bool tryLock() nothrow @trusted {
        return TryEnterCriticalSection(handle_) != 0;
    }

    /**
        Decrements the internal lock counter,
        If the counter reaches 0, the lock is released.
    */
    override
    void unlock() nothrow @trusted {
        LeaveCriticalSection(handle_);
    }
}

extern(C) export
NativeMutex _nu_mutex_new() @trusted @nogc nothrow {
    return nogc_new!Win32Mutex();
}

//
//          BINDINGS
//
extern(Windows) @nogc nothrow:

/// A critical section object.
struct CRITICAL_SECTION {
    void*   DebugInfo;
    int     LockCount;
    int     RecursionCount;
    void*   OwningThread;
    void*   LockSemaphore;
    size_t  SpinCount;
}

extern void DeleteCriticalSection(CRITICAL_SECTION*);
extern uint InitializeCriticalSectionAndSpinCount(CRITICAL_SECTION*, uint);
extern void EnterCriticalSection(CRITICAL_SECTION*);
extern void LeaveCriticalSection(CRITICAL_SECTION*);
extern uint TryEnterCriticalSection(CRITICAL_SECTION*);