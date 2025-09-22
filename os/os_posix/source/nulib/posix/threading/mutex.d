/**
    POSIX Implementation for nulib.threading.internal.mutex

    Copyright:
        Copyright © 2025, Kitsunebi Games
        Copyright © 2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.posix.threading.mutex;
import nulib.threading.internal.mutex;
import numem;

extern(C) export
NativeMutex _nu_mutex_new() @trusted @nogc nothrow {
    return null;
}

//
//          BINDINGS
//