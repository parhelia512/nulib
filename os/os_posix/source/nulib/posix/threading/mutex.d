/**
    POSIX Implementation for nulib.threading.internal.mutex

    Copyright:
        Copyright © 2025, Kitsunebi Games
        Copyright © 2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.posix.threading.mutex;
import nulib.threading.internal.mutex;
import nulib.posix.pthread;
import numem;

/**
    Native implementation of a mutually exclusive lock.
*/
class PosixMutex : NativeMutex {
private:
@nogc:
    pthread_mutex_t handle_;

public:

    ~this() nothrow {
        assert(!pthread_mutex_destroy(&handle_), "Failed to destroy mutex!");
    }

    this() nothrow {
        pthread_mutexattr_t attr = void;
        assert(!pthread_mutexattr_init(&attr), "Failed to create mutex!");
        scope(exit) assert(!pthread_mutexattr_destroy(&attr), "Failed to create mutex!");

        assert(!pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE), "Failed to create mutex!");
        assert(!pthread_mutex_init(&handle_, &attr), "Failed to create mutex!");
    }

    /**
        Increments the internal lock counter.
    */
    override
    void lock() nothrow @trusted {
        if (pthread_mutex_lock(&handle_) == 0)
            return;
        
        assert(0, "Failed to lock mutex!");
    }

    /**
        Tries to increment the internal lock counter.

        Returns:
            $(D true) if the mutex was locked,
            $(D false) otherwise.
    */
    override
    bool tryLock() nothrow @trusted {
        return pthread_mutex_trylock(&handle_) == 0;
    }

    /**
        Decrements the internal lock counter,
        If the counter reaches 0, the lock is released.
    */
    override
    void unlock() nothrow @trusted {
        if (pthread_mutex_lock(&handle_) == 0)
            return;

        assert(0, "Failed to unlock mutex!");
    }
}

extern(C) export
NativeMutex _nu_mutex_new() @trusted @nogc nothrow {
    return nogc_new!PosixMutex();
}

//
//          BINDINGS
//