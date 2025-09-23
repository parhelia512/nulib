/**
    Native Threading Abstraction

    Copyright:
        Copyright © 2023-2025, Kitsunebi Games
        Copyright © 2023-2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.threading.internal.thread;
import numem;

/**
    Thread ID
*/
alias ThreadId = size_t;

/**
    A thread context.
*/
struct ThreadContext {
    void* userData;
    void function(void* userData) callback;
    Exception ex;
}

/**
    Base class of native threading implementations.
*/
extern
abstract
class NativeThread : NuObject {
public:
@nogc:

    /**
        ID of the thread.    
    */
    abstract @property ThreadId tid() @safe;

    /**
        Whether the thread is currently running.
    */
    abstract @property bool isRunning() @safe;

    /**
        Starts the given thread.
    */
    abstract void start() @safe;

    /**
        Forcefully cancels the thread, stopping execution.

        This is not a safe operation, as it may lead to memory
        leaks and corrupt state. Only use when ABSOLUTELY neccesary.
    */
    abstract void cancel() @system;

    /**
        Waits for the thread to finish execution.
    
        Params:
            timeout = How long to wait for the thread to exit.
            rethrow = Whether execptions thrown in the thread should be rethrown.
    */
    abstract bool join(uint timeout, bool rethrow) @safe;
}

