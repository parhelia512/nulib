/**
    Win32 Core Definitions

    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.win32.core;
public import numem;
public import nulib.uuid;

/**
    Windows calls them GUIDs.
*/
alias GUID = UUID;

/**
    Attribute which specifies which DLL the function came from.
*/
struct DllImport {

    /**
        Name of the DLL.
    */
    string name;
}

/**
    Gets the GUID attribute of a type.

    See_Also:
        $(LINK2 https://github.com/rumbu13/windows-d/blob/master/cfg/core.d#L56, windows-d source)
*/
template GUIDOF(T, A...)
{
    static if (A.length == 0)
        alias GUIDOF = GUIDOF!(T, __traits(getAttributes, T));
    else static if (A.length == 1)
    {
        static assert(is(typeof(A[0]) == GUID), T.stringof ~ "doesn't have a @GUID attribute attached to it");
        enum GUIDOF = A;
    }
    else static if (is(typeof(A[0]) == GUID))
        enum GUIDOF = A[0];
    else
        alias GUIDOF = GUIDOF!(T, A[1 .. $]);
}

// TODO: Move "RAII" stuff into numem instead.
// Then alias it here.

/**
    Attribute which indicates that the resource should be freed with
    the given handler in a RAII context.
*/
struct RAIIFree(alias H) {
    private alias Handler = H;
}