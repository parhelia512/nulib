/**
    Threads

    Copyright:
        Copyright © 2023-2025, Kitsunebi Games
        Copyright © 2023-2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.threading.thread;
import it = nulib.threading.internal.thread;
import numem;

/**
    Thread ID
*/
alias ThreadId = it.ThreadId;

/**
    A thread of execution.
*/
class Thread : NuObject {
private:
    it.NativeThread thread_;

protected:
    
    /**
        Virtual function which may be overridden.
    */
    void onExecute() @nogc { }

    /**
        Creates a new thread executing the "onExecute"
        virtual function.
    */
    this() @nogc {
        it.ThreadContext context_;
        context_.userData = cast(void*)this;
        context_.callback = (void* ctx) { (cast(Thread)ctx).onExecute(); };
        this.thread_ = it.NativeThread.create(context_);
    }

public:

    /**
        The Thread ID of the calling thread.
    */
    static @property ThreadId selfTid() @safe => it.NativeThread.selfTid();

    /**
        The thread Id of the given thread.
    */
    final @property ThreadId tid() => thread_.tid();

    /**
        Creates a new thread.
    */
    this(void delegate() callback) @nogc @trusted {
        it.ThreadContext context_;
        context_.userData = callback.ptr;
        context_.callback = cast(void function(void* ptr) @nogc)callback.funcptr;
        this.thread_ = it.NativeThread.create(context_);
    }

    /**
        Creates a new thread.
    */
    this(T)(void function(T) callback, T data) @nogc @trusted {
        it.ThreadContext context_;
        context_.userData = cast(void*)data;
        context_.callback = cast(void function(void* ptr) @nogc)callback;
        this.thread_ = it.NativeThread.create(context_);
    }

    /**
        Makes the calling thread sleep for the specified amount
        of time.

        Params:
            ms = Miliseconds that the thread should sleep.
    */
    static void sleep(uint ms) @nogc @safe {
        it.NativeThread.sleep(ms);
    }

    /**
        Starts executing the thread.

        Returns:
            This thread instance, allowing chaining.
    */
    Thread start() @nogc @safe {
        thread_.start();
        return this;
    }

    /**
        Forcefully cancels the thread, stopping execution.

        This is not a safe operation, as it may lead to memory
        leaks and corrupt state. Only use when ABSOLUTELY neccesary.

        Returns:
            This thread instance, allowing chaining.
    */
    Thread cancel() @nogc @system {
        thread_.cancel();
        return this;
    }

    /**
        Blocks the calling thread until the given thread
        completes.

        Params:
            rethrow =   Whether exections should be rethrown into
                        this thread.

        Returns:
            This thread instance, allowing chaining.
    */
    Thread join(bool rethrow = false) @nogc @safe {
        thread_.join(rethrow);
        return this;
    }
}