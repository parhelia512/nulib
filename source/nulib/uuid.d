module nulib.uuid;
import nulib.random;
import nulib.string;
import nulib.memory.endian;
import nulib.text.ascii;
import nulib.conv;
import numem;

/**
    UUID Variants
*/
enum UUIDVariant {
    ncs,
    rfc4122,
    microsoft,
    reserved
}

/**
    Creates a UUID object at compile time from a UUID string.

    Params:
        uuid = The UUID string to generate a UUID object from.
*/
template CTUUID(string uuid) {
    UUID genUUID(string slice) {
        import std.conv : to;

        UUID uuid;
        if (__ctfe) {
            if (!UUID.validate(slice))
                return uuid;

            uuid.time_low = slice[0..8].to!uint(16);
            slice = slice[9..$];

            uuid.time_mid = slice[0..4].to!ushort(16);
            slice = slice[5..$];

            uuid.time_hi_and_version = slice[0..4].to!ushort(16);
            slice = slice[5..$];

            uuid.clk_seq = slice[0..4].to!ushort(16);
            slice = slice[5..$];

            static foreach(i; 0..6) {
                uuid.node[i] = slice[0..2].to!ubyte(16);
                slice = slice[2..$];
            }
        }
        return uuid;
    }

    enum CTUUID = genUUID(uuid);
}

/**
    RFC4122 compliant UUIDs
*/
struct UUID {
@nogc nothrow:
private:
    enum VERSION_BITMASK = 0b11110000_00000000;

    enum VARIANT_BITMASK = 0b11100000_00000000;

    union {
        struct {
            uint time_low;
            ushort time_mid;
            ushort time_hi_and_version;
            ushort clk_seq;
            ubyte[6] node;
        }
        ubyte[16] bdata;
        ulong[2] ldata;
    }
    
    this(ulong[2] data) inout {
        this.ldata = data;
    }

public:

    /**
        Length of a UUID string
    */
    enum uuidStringLength = 36;

    /**
        Special "nil" UUID
    */
    enum UUID nil = UUID([0LU, 0LU]);
    alias min = nil;

    /**
        Special "max" UUID
    */
    enum UUID max = UUID([ulong.max, ulong.max]);

    /**
        The underlying data of the UUID.
    */
    @property ubyte[] data() return { return this.bdata[0..$]; }

    /**
        The version of the UUID structure
    */
    @property int uuidVersion() {
        return cast(int)(time_hi_and_version >> 12);
    }

    deprecated("use .uuidVersion instead!")
    alias getVersion = uuidVersion;

    /**
        The variant of the UUID structure
    */
    @property UUIDVariant uuidVariant() {
        enum ncsMask = 0b00000100;
        enum rfcMask = 0b00000110;
        enum msMask = 0b00000110;
        ubyte variant = cast(ubyte)(clk_seq >> 13);
        
        if ((variant & ncsMask) == 0) 
            return UUIDVariant.ncs;
        if ((variant & rfcMask) == 4) 
            return UUIDVariant.rfc4122;
        if ((variant & msMask) == 6) 
            return UUIDVariant.microsoft;
        
        return UUIDVariant.reserved;
    }
    
    deprecated("use .uuidVariant instead!")
    alias getVariant = uuidVariant;

    /**
        Constructs a UUID from the specified byte slice
    */
    this(ubyte[16] bytes) {
        this.bdata = bytes;
        this.time_low = nu_ntoh(this.time_low);
        this.time_mid = nu_ntoh(this.time_mid);
        this.time_hi_and_version = nu_ntoh(this.time_hi_and_version);
    }

    /**
        Provides compatibility with .NET's Guid struct.
    */
    this(uint time_low, ushort time_mid, ushort time_hi_and_version, ubyte clk0, ubyte clk1, ubyte d0, ubyte d1, ubyte d2, ubyte d3, ubyte d4, ubyte d5) {
        this.time_low = time_low;
        this.time_mid = time_mid;
        this.time_hi_and_version = time_hi_and_version;
        this.node[0] = d0;
        this.node[1] = d0;
        this.node[2] = d0;
        this.node[3] = d0;
        this.node[4] = d0;
        this.node[5] = d0;
    }   

    /**
        Constructs a UUID from the specified string.
    */
    this(string text) {
        this = UUID.parse(text);
    }

    /**
        Validates the correctness of a UUID string.

        Params:
            slice = The string slice to validate
        
        Returns:
            $(D true) if the slice is a valid UUID string,
            $(D false) otherwise.
    */
    static bool validate(string slice) {

        // Incorrect length
        if (slice.length != UUID.uuidStringLength)
            return false;

        foreach(i; 0..UUID.uuidStringLength) {
            
            // Dash positions
            if (i == 8 || i == 13 || i == 18 || i == 23) {
                if (slice[i] != '-') 
                    return false;
                else
                    continue;
            }

            // Hex positions
            if (!isHex(slice[i]))
                return false;
        }

        return true;
    }

    /**
        Creates a new UUIDv3 with a specified random number generator.

        Params:
            random = The random number generator to use.
        
        Returns:
            A new psuedorandomly generated UUID.
    */
    static UUID createRandom(RandomBase random) {
        UUID uuid;
        uuid.time_hi_and_version &= 0x0FFF;
        uuid.time_hi_and_version |= (3 << 12);
        uuid.clk_seq &= 0x3F;
        uuid.clk_seq |= 0x80;

        ubyte[] dst = uuid.node[0..$];
        random.next(dst);
        return uuid;
    }

    /**
        Tries to parse a UUID from a string.
        
        Params:
            slice = The string slice to parse.

        Returns:
            A new UUID parsed from the string, or a nil UUID on failure.
    */
    static UUID parse(string slice) {
        if (!UUID.validate(slice))
            return UUID.nil;

        UUID uuid;

        // Get from string
        uuid.time_low = slice[0..8].toInt!uint(16);
        slice = slice[9..$];

        uuid.time_mid = slice[0..4].toInt!ushort(16);
        slice = slice[5..$];

        uuid.time_hi_and_version = slice[0..4].toInt!ushort(16);
        slice = slice[5..$];

        uuid.clk_seq = slice[0..4].toInt!ushort(16);
        slice = slice[5..$];

        // Get bytes
        static foreach(i; 0..6) {
            uuid.node[i] = slice[0..2].toInt!ubyte(16);
            slice = slice[2..$];
        }
        return uuid;
    }

    /**
        Returns byte stream from UUID with data in network order.
    */
    ubyte[16] toBytes() {
        UUID datacopy;
        datacopy.bdata[0..$] = bdata[0..$];

        datacopy.time_low = nu_ntoh(this.time_low);
        datacopy.time_mid = nu_ntoh(this.time_mid);
        datacopy.time_hi_and_version = nu_ntoh(this.time_hi_and_version);
        return datacopy.bdata;
    }

    /**
        Returns UUID string
    */
    nstring toString() {
        nstring str = "00000000-0000-0000-0000-000000000000";
        char* cstr = cast(char*)str.ptr;

        // Add hex data
        cstr[0..8] = time_low.toHexString(true)[0..8];
        cstr[9..13] = time_mid.toHexString(true)[0..4];
        cstr[14..18] = time_hi_and_version.toHexString(true)[0..4];
        cstr[19..23] = clk_seq.toHexString(true)[0..4];

        cstr += 24;

        static foreach(i; 0..6) {
            cstr[0..2] = node[i].toHexString(true)[0..2];
            cstr += 2;
        }

        return str;
    }

    /**
        Checks equality between 2 UUIDs.
    */
    bool opEquals(const UUID other) const {
        return this.ldata[0] == other.ldata[0] && this.ldata[1] == other.ldata[1];
    }

    /**
        Compares 2 UUIDs lexically.

        Lexical order is NOT temporal!
    */
    int opCmp(const UUID other) const {

        // First check things which are endian dependent.
        if (this.time_low != other.time_low) 
            return this.time_low < other.time_low;

        if (this.time_mid != other.time_mid) 
            return this.time_mid < other.time_mid;

        if (this.time_hi_and_version != other.time_hi_and_version) 
            return this.time_hi_and_version < other.time_hi_and_version;
        
        // Then check all the nodes
        static foreach(i; 0..6) {
            if (this.node[i] < other.node[i]) return -1;
            if (this.node[i] > other.node[i]) return 1;
        }

        // They're the same.
        return 0;
    }
}

@("uuid: parsing")
unittest {
    const string[4] tests = [
        "ce1a553c-762d-11ef-b864-0242ac120002",
        "56ba8f28-d9aa-4452-80c1-4ce66d064f6c",
        "01920815-46af-71fa-9025-35d7592a401b",
        "7f204bc7-53fe-4ffb-acaf-3f0cd0cf69cb"
    ];

    const int[4] versions = [
        1,
        4,
        7,
        4
    ];

    foreach(i; 0..4) {
        import std.format : format;
        import std.conv : text;
        UUID uuid = UUID.parse(tests[i]);

        assert(
            uuid.uuidVariant == UUIDVariant.rfc4122,
            "Expected RFC4122, got %s".format(uuid.uuidVariant.text)
        );

        assert(
            uuid.uuidVersion == versions[i], 
            "uuid=%s (test %s), version=%s, expected=%s!".format(tests[i], i+1, uuid.uuidVersion, versions[i])
        );
    }
}

@("uuid: comparison")
unittest {
    UUID uuid1 = UUID.parse("ce1a553c-762d-11ef-b864-0242ac120002");
    UUID uuid2 = UUID.parse("56ba8f28-d9aa-4452-80c1-4ce66d064f6c");
    UUID uuid3 = UUID.parse("ce1a553c-762d-11ef-b864-0242ac120002");

    assert(uuid1 == uuid3);
    assert(uuid1 != uuid2);
}

@("uuid: toString")
unittest {
    UUID uuid1 = UUID.parse("ce1a553c-762d-11ef-b864-0242ac120002");
    nstring str = uuid1.toString();
    assert(str == "ce1a553c-762d-11ef-b864-0242ac120002", str);
}

@("uuid: generation")
unittest {
    import numem.core;

    Random random = nogc_new!Random(42);
    scope(exit) nogc_delete(random);

    UUID uuid = UUID.createRandom(random);
    scope(exit) nogc_delete(uuid);
    assert(uuid != UUID.nil);
}

@("uuid: UUID.validate")
unittest {
    assert( UUID.validate("6ba7b810-9dad-11d1-80b4-00c04fd430c8"));
    assert( UUID.validate("449ed9d5-6810-44c6-9506-504ceeb27e0d"));
    assert(!UUID.validate(""));
    assert(!UUID.validate("6ba7b81i-9dad-11d1-80b4-00c04fd430c8"));
    assert(!UUID.validate("\0\0\0\0\0\0\0\0\0\0\0\0\0\0"));
}