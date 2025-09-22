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
abstract
class NativeMutex : NuObject {
public:
@nogc:

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