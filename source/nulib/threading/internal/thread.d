/**
    Native Threading Abstraction

    Copyright:
        Copyright © 2023-2025, Kitsunebi Games
        Copyright © 2023-2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.threading.internal.thread;
import core.attribute : weak;
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
export
abstract
class NativeThread : NuObject {
public:
@nogc:

    /**
        The Thread ID of the calling thread.
    */
    static @property ThreadId selfTid() @safe => _nu_thread_current_tid();

    /**
        Creates a new native thread.
    */
    static NativeThread create(ThreadContext ctx) @safe => _nu_thread_new(ctx);

    /**
        Makes the calling thread sleep for the specified amount
        of time.

        Params:
            ms = Miliseconds that the thread should sleep.
    */
    static void sleep(uint ms) @safe {
        _nu_thread_sleep(ms);
    }

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

/**
    Gets the total number of CPUs in the system.

    Returns:
        The number of CPUs in the system.
*/
int totalCPUs() @weak nothrow @nogc {
    version(Windows) {
        static struct SYSTEM_INFO {
            short wProcessorArchitecture;
            short wReserved;
            int dwPageSize;
            void* lpMinimumApplicationAddress;
            void* lpMaximumApplicationAddress;
            int* dwActiveProcessorMask;
            int dwNumberOfProcessors;
            int dwProcessorType;
            int dwAllocationGranularity;
            short  wProcessorLevel;
            short  wProcessorRevision;
        }

        pragma(mangle, "GetSystemInfo")
        static 
        extern(System) extern void GetSystemInfo(SYSTEM_INFO*) @nogc nothrow;

        SYSTEM_INFO inf;
        GetSystemInfo(&inf);
        return inf.dwNumberOfProcessors;
    } else version(Darwin) {

        pragma(mangle, "sysctlbyname")
        static
        extern(C) int sysctlbyname(const(char)*, void*, size_t*, const(void)*, size_t);
        
        const(char)* nstr = "machdep.cpu.core_count\0";
        size_t len = uint.max;
        uint result;
        cast(void)sysctlbyname(nstr, &result, &len, null, 0);
        return cast(int)result;
    } else version(Posix) {

        import core.sys.posix.unistd : _SC_NPROCESSORS_ONLN, sysconf;
        return cast(int)sysconf(_SC_NPROCESSORS_ONLN);
    } else {
        pragma(msg, "totalCPUs: Platform not supported, will return 1.");

        // Not supported.
        return 1;
    }
}

//
//          FOR IMPLEMENTORS
//

private extern(C):

version(DigitalMars) version = WeakIsBroken;
version(linux) version = WeakIsBroken;
version(WeakIsBroken) {

    // Needed on Linux because we can't specify load order.
    extern(C) extern NativeThread _nu_thread_new(ThreadContext) @trusted @nogc nothrow;
    extern(C) extern ThreadId _nu_thread_current_tid() @trusted @nogc nothrow;
    extern(C) extern void _nu_thread_sleep(uint) @trusted @nogc nothrow;
} else {

    /*
        Function which creates a new native thread.
    */
    NativeThread _nu_thread_new(ThreadContext) @trusted @weak @nogc nothrow { return null; }

    /*
        Function which gets the current Thread ID.
    */
    ThreadId _nu_thread_current_tid() @trusted @weak @nogc nothrow { return 0; }

    /*
        Function which sleeps the calling thread.
    */
    void _nu_thread_sleep(uint) @trusted @weak @nogc nothrow { }
}