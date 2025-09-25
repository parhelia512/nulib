/**
    Native Semaphore Abstraction

    Copyright:
        Copyright © 2023-2025, Kitsunebi Games
        Copyright © 2023-2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.threading.internal.semaphore;
import numem;

/**
    Native implementation of a semaphore.
*/
export
abstract
class NativeSemaphore : NuObject {
public:
@nogc:

    /**
        Creates a new native semaphore using a linked backend.

        Returns:
            A new $(D NativeSemaphore) or $(D null) if the
            platform does not support mutexes.
    */
    static NativeSemaphore create(uint count) => _nu_semaphore_new(count);

    /**
        Signals the semaphore.

        Note:
            Control is not transferred to the waiter.
    */
    abstract void signal();

    /**
        Suspends the thread until the semaphore is signaled,
        or the timeout is reached.

        Params:
            timeout =   Timeout in miliseconds to block the 
                        calling thread before giving up.

        Returns:
            $(D true) if the semaphore was signaled in time,
            $(D false) otherwise.
    */
    abstract bool await(ulong timeout = 0);

    /**
        Checks if the semaphore is signalled then
        awaits on it if is.

        Returns:
            $(D true) if the semaphore was signalled,
            $(D false) otherwise.
    */
    abstract bool tryAwait();
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
    extern(C) extern NativeSemaphore _nu_semaphore_new(uint count) @nogc nothrow;
} else {

    /*
        Function which creates a new native semaphore.
    */
    NativeSemaphore _nu_semaphore_new(uint count) @weak @nogc nothrow { return null; }
}