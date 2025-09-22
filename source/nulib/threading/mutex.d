/**
    Mutually Exclusive Locks

    Copyright:
        Copyright © 2023-2025, Kitsunebi Games
        Copyright © 2023-2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.threading.mutex;
import nulib.threading.internal.mutex;
import numem;

/**
    A mutually exclusive lock.
*/
class Mutex : NuObject {
private:
@nogc:
    NativeMutex mutex_;

public:

    /// Destructor
    ~this() {
        nogc_delete(mutex_);
    }

    /**
        Constructs a new Mutex.
    */
    this() {
        this.mutex_ = NativeMutex.create();
        enforce(mutex_, "Mutex is not supported on this platform.");
    }

    /**
        Increments the internal lock counter.
    */
    void lock() nothrow @safe {
        mutex_.lock();
    }

    /**
        Tries to increment the internal lock counter.

        Returns:
            $(D true) if the mutex was locked,
            $(D false) otherwise.
    */
    bool tryLock() nothrow @safe {
        return mutex_.tryLock();
    }

    /**
        Decrements the internal lock counter,
        If the counter reaches 0, the lock is released.
    */
    void unlock() nothrow @safe {
        mutex_.unlock();
    }
}

@("lock and unlock")
unittest {
    Mutex m = nogc_new!Mutex();
    m.lock();
    m.unlock();
    nogc_delete(m);
}