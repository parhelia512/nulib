/**
    Type Conversion Utilities

    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.conv;
import nulib.string;

// TODO: redo all this, this is old implementation from
//       numem.

/**
    Parses an integer from the given string, with the given radix.
*/
T toInt(T)(string text, uint radix) @nogc nothrow if (__traits(isIntegral, T)) {
    T val = 0;

    switch(radix) {
        case 16:
            // TODO: Base 16
            break;

        case 10:
            foreach(char digit; text) 
                val = cast(T)(val * 10 + (digit - '0'));

            break;
        
        default:
            break;
    }
    return val;
}

/**
    Converts an integer type into a hex string
*/
nstring toHexString(T, bool upper=false)(T num, bool pad=false) if (__traits(isIntegral, T)) {
    const string hexStr = upper ? "0123456789ABCDEF" : "0123456789abcdef";
    nstring str;

    // Sign
    if (num < 0)
        str ~= '-';

    ptrdiff_t i = T.sizeof*2;
    while(num > 0) {
        str ~= hexStr[num % 16];
        i--;
        num /= 16;
    }

    str.reverse();

    // Add padding
    if (pad) {
        nstring padding;
        while(i-- > 0)
            padding ~= '0';

        padding ~= str;
        return padding;
    }

    // No padding
    return str;
}