/**
    C Configuration

    Copyright:
        Copyright © 2005-2009, Sean Kelly.
        Copyright © 2025, Kitsunebi Games
        Copyright © 2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Sean Kelly, Alex Rønne Petersen, Luna Nielsen
*/
module nulib.posix.ccfg;

version(GNU) {
    import gcc.builtins;

    alias c_long = __builtin_clong;
    alias c_ulong = __builtin_culong;

    enum __c_long : __builtin_clong;
    enum __c_ulong : __builtin_culong;

    alias cpp_long = __c_long;
    alias cpp_ulong = __c_ulong;

    enum __c_longlong : __builtin_clonglong;
    enum __c_ulonglong : __builtin_culonglong;

    alias cpp_longlong = __c_longlong;
    alias cpp_ulonglong = __c_ulonglong;
} else version(Windows) {
    enum __c_long : int;
    enum __c_ulong : uint;

    alias c_long = int;
    alias c_ulong = uint;

    alias cpp_long = __c_long;
    alias cpp_ulong = __c_ulong;

    alias cpp_longlong = long;
    alias cpp_ulonglong = ulong;
} else version(Posix) {
    static if ((void*).sizeof > int.sizeof) {
        enum __c_longlong : long;
        enum __c_ulonglong : ulong;

        alias c_long = long;
        alias c_ulong = ulong;

        alias cpp_long = long;
        alias cpp_ulong = ulong;

        alias cpp_longlong = __c_longlong;
        alias cpp_ulonglong = __c_ulonglong;
    } else {
        enum __c_long : int;
        enum __c_ulong : uint;

        alias c_long = int;
        alias c_ulong = uint;

        alias cpp_long = __c_long;
        alias cpp_ulong = __c_ulong;

        alias cpp_longlong = long;
        alias cpp_ulonglong = ulong;
    }
} else version (WASI) {
    static if ((void*).sizeof > int.sizeof) {
        enum __c_longlong : long;
        enum __c_ulonglong : ulong;

        alias c_long = long;
        alias c_ulong = ulong;

        alias cpp_long = long;
        alias cpp_ulong = ulong;

        alias cpp_longlong = __c_longlong;
        alias cpp_ulonglong = __c_ulonglong;
    } else {
        enum __c_long : int;
        enum __c_ulong : uint;

        alias c_long = int;
        alias c_ulong = uint;

        alias cpp_long = __c_long;
        alias cpp_ulong = __c_ulong;

        alias cpp_longlong = long;
        alias cpp_ulonglong = ulong;
    }
}