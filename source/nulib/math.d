/**
    Math operations

    @nogc math operations independent of what comes with phobos.

    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.math;

/**
    Returns the larger of the 2 given scalar values.
*/
T max(T)(T lhs, T rhs) if (__traits(isScalar, T)) {
    return lhs > rhs ? lhs : rhs;
}

/**
    Returns the smaller of the 2 given scalar values.
*/
T min(T)(T lhs, T rhs) if (__traits(isScalar, T)) {
    return lhs < rhs ? lhs : rhs;
}

/**
    Clamps scalar value into the given range.
*/
T clamp(T)(T value, T min_, T max_) if (__traits(isScalar, T))  {
    return min(max(value, min_), max_);
}