/**
    POSIX Implementation for nulib.threading.internal.thread

    Copyright:
        Copyright © 2025, Kitsunebi Games
        Copyright © 2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.posix.threading.thread;
import nulib.threading.internal.thread;

extern(C) @nogc nothrow:

/*
    Function which creates a new native thread.
*/
export
NativeThread _nu_thread_new(ThreadContext ctx) @trusted @nogc nothrow { return null; }

/*
    Function which gets the current Thread ID.
*/
export
ThreadId _nu_thread_current_tid() @trusted @nogc nothrow { return 0; }

/*
    Function which sleeps the calling thread.
*/
export
void _nu_thread_sleep(uint) @trusted @nogc nothrow { }