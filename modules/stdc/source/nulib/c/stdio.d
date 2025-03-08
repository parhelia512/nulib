/**
    Bindings to C standard library I/O functions.

    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.c.stdio;

extern(C) nothrow @nogc:

/**
    Prints a formatted string.

    Params:
        format = The format string.

    Returns:
        On success, the total number of characters written is returned.
*/
pragma(printf)
extern int printf(const(char)* format, ...) @trusted pure;

/**
    Prints a formatted string to a sized buffer.

    Params:
        buffer =    The buffer to write to.
        size =      The size of the buffer.
        format =    The format string.

    Returns:
        On success, the total number of characters written is returned.
        A terminating $(D '\0') is automatically written to the buffer after
        the content.
*/
pragma(printf)
extern int snprintf(char* buffer, size_t size, const(char)* format, ...) @trusted pure;

/**
    Prints a formatted string to a buffer.

    Params:
        buffer =    The buffer to write to.
        format =    The format string.

    Returns:
        On success, the total number of characters written is returned.
        A terminating $(D '\0') is automatically written to the buffer after
        the content.
*/
pragma(printf)
extern int sprintf(char* buffer, const(char)* format, ...) @system pure;

/**
    Reads a data from stdin with a given format.

    Params:
        format = The format string.

    Returns:
        The amount of items successfully filled.
*/
pragma(scanf)
extern int scanf(const(char)* format, ...) @trusted pure;

/**
    Reads a data from a string with a given format.

    Params:
        s       = The input string.
        format  = The format string.

    Returns:
        The amount of items successfully filled.
*/
pragma(scanf)
extern int sscanf(const(char)* s, const(char)* format, ...) @trusted pure;
