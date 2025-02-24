/**
    Math operations

    @nogc math operations independent of what comes with phobos.

    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.math;

public import nulib.math.constants;
public import nulib.c.math;

/**
    Returns the larger of the 2 given scalar values.

    Params:
        rhs = value
        lhs = value
    
    Returns:
        The largest of the 2 given values.
*/
T max(T)(T lhs, T rhs) if (__traits(isScalar, T)) {
    return lhs > rhs ? lhs : rhs;
}

/**
    Returns the smaller of the 2 given scalar values.

    Params:
        rhs = value
        lhs = value
    
    Returns:
        The smallest of the 2 given values.
*/
T min(T)(T lhs, T rhs) if (__traits(isScalar, T)) {
    return lhs < rhs ? lhs : rhs;
}

/**
    Clamps scalar value into the given range.

    Params:
        value   = The value to clamp,
        min_    = The minimum value
        max_    = The maximum value.
    
    Returns:
        $(D value) clamped between $(D min_) and $(D max_),
        equivalent of $(D min(max(value, min_), max_))
*/
T clamp(T)(T value, T min_, T max_) if (__traits(isScalar, T))  {
    return min(max(value, min_), max_);
}