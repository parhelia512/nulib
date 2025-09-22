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
extern
abstract
class NativeSemaphore : NuObject {
public:
@nogc:

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