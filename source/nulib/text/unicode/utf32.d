/**
    UTF-32 Utilities
    
    Copyright:
        Copyright © 2023-2025, Kitsunebi Games
        Copyright © 2023-2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.text.unicode.utf32;
import nulib.text.unicode;
import nulib.memory.endian;
import nulib.string;

@nogc:

/**
    Validates a UTF32 codepoint
*/
bool validate(dchar c) {

    // Name conflict, so we just import it locally.
    import uni = nulib.text.unicode;
    return uni.validate(c);
}

/**
    Validates a UTF32 string
*/
bool validate(ndstring str) {
    return validate(str[]);
}

/**
    Validates a UTF32 string
*/
bool validate(inout(dchar)[] str) {
    ndstring tmp = str;

    // Handle endianess.
    codepoint bom = getBOM(str);
    if (bom != 0 && getEndianFromBOM(bom) != NATIVE_ENDIAN) {
        tmp = toMachineOrder(str);
    }

    foreach(dchar c; tmp) {
        if (!validate(c)) 
            return false;
    }

    return true;
}

/**
    Gets the BOM
*/
codepoint getBOM(inout(dchar)[] str) {
    if (str.length == 0)
        return 0;
    
    // This is UTF32.
    if (isBOM(str[0]))
        return str[0];

    return 0;
}

/**
    Returns a string which is [str] converted to machine order.

    If the string has no BOM the specified fallback endian will be used.
*/
ndstring toMachineOrder(inout(dchar)[] str, Endianess fallbackEndian = NATIVE_ENDIAN) {
    
    // Empty string early escape.
    if (str.length == 0) 
        return ndstring.init;

    codepoint bom = getBOM(str);
    Endianess endian = getEndianFromBOM(bom);
    if (bom == 0)
        endian = fallbackEndian;
    
    if (endian != NATIVE_ENDIAN) {

        // Flip all the bytes around
        ndstring tmp;
        foreach(i, ref const(dchar) c; str) {
            tmp ~= c.nu_etoh(endian);
        }

        return tmp;
    }

    return ndstring(str);
}

/**
    Decodes a single UTF-32 character
*/
codepoint decode(dchar c) {
    if (!validate(c))
        return unicodeReplacementCharacter;
    return c;
}

/**
    Decodes a single UTF-32 string
*/
UnicodeSequence decode(inout(dchar)[] str, bool stripBOM = false) {
    ndstring tmp;
    size_t start = 0;

    // Handle BOM
    if (getBOM(str) != 0) {
        tmp = toMachineOrder(str);
        start = stripBOM ? 1 : 0;
    }

    foreach(ref c; str[start..$]) {
        tmp ~= cast(wchar)decode(c);
    }

    return UnicodeSequence(cast(uint[])tmp[]);
}

/**
    Decodes a single UTF-32 string
*/
UnicodeSequence decode(ndstring str, bool stripBOM = false) {
    return decode(str[], stripBOM);
}

/**
    Encodes a UTF-32 string.

    Since UnicodeSequence is already technically
    UTF-32 this doesn't do much other than
    throw the data into a nwstring.
*/
ndstring encode(UnicodeSlice slice, bool addBOM = false) {
    ndstring out_;
    
    if (addBOM && slice.length > 0 && slice[0] != UNICODE_BOM) {
        out_ ~= UNICODE_BOM;
    }

    out_ ~= ndstring(cast(dchar[])slice[0..$]);
    return out_;
}

/**
    Encodes a UTF-32 string.

    Since UnicodeSequence is already technically
    UTF-32 this doesn't do much other than
    throw the data into a nwstring.
*/
ndstring encode(ref UnicodeSequence seq, bool addBOM = false) {
    return encode(seq[0..$], addBOM);
}