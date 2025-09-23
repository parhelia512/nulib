/**
    Common reused definitions.

    Copyright:
        Copyright © 2023-2025, Kitsunebi Games
        Copyright © 2023-2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.win32.common;

extern(Windows) @nogc nothrow:

/// A win32 handle.
alias HANDLE = void*;
enum uint INFINITE           = 0xFFFFFFFF;
enum uint WAIT_OBJECT_0      = 0;
enum uint WAIT_ABANDONED     = 0x00000080;
enum uint WAIT_TIMEOUT       = 0x00000102;
enum uint WAIT_FAILED        = 0xFFFFFFFF;

extern uint CloseHandle(HANDLE);
extern uint WaitForSingleObject(HANDLE, uint);