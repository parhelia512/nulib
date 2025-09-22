/**
    Semaphores

    Copyright:
        Copyright © 2023-2025, Kitsunebi Games
        Copyright © 2023-2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.threading.semaphore;
import nulib.threading.internal.semaphore;
import numem;

/**
    A sempahore.
*/
class Semaphore : NuObject {
private:
@nogc:
    NativeSemaphore semaphore_;

public:

    /// Destructor
    ~this() {
        nogc_delete(semaphore_);
    }

    /**
        Constructs a new Mutex.
    */
    this() {
        this.semaphore_ = NativeSemaphore.create();
        enforce(semaphore_, "Semaphore is not supported on this platform.");
    }

    /**
        Signals the semaphore.

        Note:
            Control is not transferred to the waiter.
    */
    void signal() {
        semaphore_.signal();
    }

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
    bool await(ulong timeout = 0) {
        return semaphore_.await(timeout);
    }

    /**
        Checks if the semaphore is signalled then
        awaits on it if is.

        Returns:
            $(D true) if the semaphore was signalled,
            $(D false) otherwise.
    */
    bool tryAwait() {
        return semaphore_.tryAwait();
    }
}

//
//          FOR IMPLEMENTORS
//

private extern(C):
import core.attribute : weak;

/*
    Optional helper which gets the current running process.
*/
Semaphore _nu_semaphore_new() @weak @nogc nothrow { return null; }