/**
    POSIX Implementation for nulib.threading.internal.semaphore

    Copyright:
        Copyright © 2025, Kitsunebi Games
        Copyright © 2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.posix.threading.semaphore;
import nulib.threading.internal.semaphore;
import numem;


extern(C) export
NativeSemaphore _nu_semaphore_new(uint count) @trusted @nogc nothrow {
    return null;
}

//
//          BINDINGS
//