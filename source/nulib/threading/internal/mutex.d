/**
    Native Mutex Abstraction

    Copyright:
        Copyright © 2023-2025, Kitsunebi Games
        Copyright © 2023-2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.threading.internal.mutex;
import numem;

/**
    Native implementation of a mutually exclusive lock.
*/
export
abstract
class NativeMutex : NuObject {
public:
@nogc:

    /**
        Creates a new native mutex using a linked backend.

        Returns:
            A new $(D NativeMutex) or $(D null) if the
            platform does not support mutexes.
    */
    static NativeMutex create() {
        return _nu_mutex_new();
    }

    /**
        Increments the internal lock counter.
    */
    abstract void lock() nothrow @trusted;

    /**
        Tries to increment the internal lock counter.

        Returns:
            $(D true) if the mutex was locked,
            $(D false) otherwise.
    */
    abstract bool tryLock() nothrow @trusted;

    /**
        Decrements the internal lock counter,
        If the counter reaches 0, the lock is released.
    */
    abstract void unlock() nothrow @trusted;
}

//
//          FOR IMPLEMENTORS
//

private extern(C):
import core.attribute : weak;

version(DigitalMars) version = WeakIsBroken;
version(linux) version = WeakIsBroken;
version(WeakIsBroken) {

    // Needed on Linux because we can't specify load order.
    extern(C) extern NativeMutex _nu_mutex_new() @nogc @trusted nothrow;
} else {
    
    /*
        Backend function used to create a new mutex object.
    */
    NativeMutex _nu_mutex_new() @weak @nogc nothrow { return null; }
}