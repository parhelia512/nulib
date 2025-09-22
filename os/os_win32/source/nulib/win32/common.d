/**
    Common reused definitions.

    Copyright:
        Copyright © 2023-2025, Kitsunebi Games
        Copyright © 2023-2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.win32.common;

/// A win32 handle.
alias HANDLE = void*;

extern(Windows) @nogc nothrow:

extern uint CloseHandle(HANDLE);