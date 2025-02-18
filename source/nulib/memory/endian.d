/**
    Numem Endianess helpers. 

    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.memory.endian;
import numem.core.traits;

/**
    Endianness
*/
enum Endianess {
    bigEndian = 0,
    littleEndian = 1
}

/**
    The endianness of the target system being compiled for.
*/
version(BigEndian) enum NATIVE_ENDIAN = Endianess.bigEndian;
else enum NATIVE_ENDIAN = Endianess.littleEndian;

/**
    The opposite endianness of what the system being compiled for
    has.
*/
enum Endianess ALT_ENDIAN = cast(Endianess)!NATIVE_ENDIAN;

/**
    Network order endianness.

    Networking gear generally uses a big-endian memory order.
*/
enum Endianess NETWORK_ORDER = Endianess.bigEndian;

/**
    Flips the endianness of the given value.

    Params:
        in_ = the bytes to flip.

    Returns:
        The input with the byte order reversed.
*/
T nu_flip_bytes(T)(T in_) @system @nogc nothrow {
    union _tmp_container {
        T value;
        ubyte[T.sizeof] bytes;
    }

    ubyte swapTmp; // temporar byte for swapping.
    _tmp_container tmp = _tmp_container(in_);
    static foreach(i; 0..T.sizeof/2) {
        swapTmp = tmp.bytes[i];
        tmp.bytes[i] = tmp.bytes[($-1)-i];
        tmp.bytes[($-1)-i] = swapTmp;
    }
    return tmp.value;
}

/**
    Converts big endian type to system endianness.
*/
T nu_betoh(T)(T in_) @system @nogc nothrow {
    return etoh!(T, Endianess.bigEndian)(in_);
}

/**
    Converts a range of big endian values to the system
    endianness.

    Params:
        in_ = the range to flip the individual values within.

    Returns:
        A slice of the input, pointing to the same memory.
*/
T[] nu_betoh(T)(T[] in_) @system @nogc nothrow {
    foreach_reverse(ref element; in_)
        element = nu_betoh(element);
    
    return in_;
}

/**
    Converts little endian type to system endianness.
*/
T nu_letoh(T)(T in_) @system @nogc nothrow {
    return etoh!(T, Endianess.littleEndian)(in_);
}

/**
    Converts a slice of little endian values to the system
    endianness.

    Params:
        in_ = the range to flip the individual values within.

    Returns:
        A slice of the input, pointing to the same memory.
*/
T[] nu_letoh(T)(T[] in_) @system @nogc nothrow {
    foreach_reverse(ref element; in_)
        element = nu_letoh(element);
    
    return in_;
}

/**
    Converts bytes between system and the given endianness.

    This essentially flips the byte-order within the type if
    the given endianness does not match the system endiannes.

    Params:
        in_ = The value to potentially flip.

    Returns:
        If $(D endian) does not match $(D NATIVE_ENDIAN),
        returns the input with the byte order reversed,
        otherwise returns the original value.
*/
T nu_etoh(T, Endianess endian)(T in_) @system @nogc nothrow {
    static if (endian != NATIVE_ENDIAN)
        return nu_flip_bytes!T(in_);
    else
        return in_;
}

