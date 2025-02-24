/**
    Bindings to C standard library core functions.

    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.c.stdlib;

extern(C) nothrow @nogc:

/**
    Converts given string to double.

    Params:
        str = string to convert.
    
    Returns:
        The floating point value of $(D str) on success,
        $(D 0.0) on failure.
*/
extern double atof(const(char)* str);

/**
    Converts given string to int.

    Params:
        str = string to convert.
    
    Returns:
        The int value of $(D str) on success,
        $(D 0) on failure.
*/
extern int atoi(const(char)* str);

/**
    Converts given string to long.

    Params:
        str = string to convert.
    
    Returns:
        The long value of $(D str) on success,
        $(D 0) on failure.
*/
extern long atoll(const(char)* str);
