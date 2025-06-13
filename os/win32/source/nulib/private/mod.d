/**
    Win32 Implementation for nulib.system.mod

    Copyright:
        Copyright © 2025, Kitsunebi Games
        Copyright © 2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.priv.mod;
import numem;

/**
    A symbol within a section.
*/
struct Symbol {
@nogc:

    /**
        Name of the symbol
    */
    string name;
    
    /**
        Pointer to the symbol
    */
    void* ptr;
}

/**
    Information about sections.
*/
struct SectionInfo {
@nogc:
    
    /**
        Segment of the section, if applicable.
    */
    string segment;

    /**
        Name of the section
    */
    string section;

    /**
        Start address of the section
    */
    void* start;

    /**
        End address of the section
    */
    void* end;
}

//
//          FOR IMPLEMENTORS
//

private extern (C):

/*
    Optional helper that defines whether paths are in UTF-16 format.
*/
bool _nu_module_utf16_paths() @nogc nothrow { 
    return true;
}

/*
    Function which loads a module from the given path.

    This is implemented by backends to abstract away the OS intricaices
    of loading modules and finding symbols within.
*/
export
void* _nu_module_open(void* path) @nogc nothrow {

    // NOTE:    This if check simulates dlopen on UNIX.
    //          We want UNIX semantics here because they're nice.
    if (!path)
        return GetModuleHandleW(null);
    return LoadLibraryW(cast(const(wchar)*)path);
}

/*
    Function which loads a module from the given path.

    This is implemented by backends to abstract away the OS intricaices
    of loading modules and finding symbols within.
*/
void _nu_module_close(void* module_) @nogc nothrow {
    cast(void) FreeLibrary(module_);
}

/*
    Function which finds a symbol within a given module

    This is implemented by backends to abstract away the OS intricaices
    of loading modules and finding symbols within.
*/
void* _nu_module_get_symbol(void* module_, const(char)* symbol) @nogc nothrow {
    return GetProcAddress(module_, symbol);
}

/*
    Function which gets the "base address" of the module.

    This is backend implementation defined; but is what should allow
    $(D _nu_module_enumerate_sections) and $(D _nu_module_enumerate_symbols)
    to function.
*/
void* _nu_module_get_base_address(void* module_) @nogc nothrow {
    
    // Just in case we should also just verify the headers
    // here.
    void* handle = _nu_module_win32_verify_pe(cast(void*)module_);
    if (!handle)
        return null;

    return cast(void*)module_;
}

/*
    Function which enumerates all of the sections within a module.

    This is implemented by backends to abstract away the OS intricaices
    of loading modules and finding symbols within.
*/
SectionInfo[] _nu_module_enumerate_sections(void* base) @nogc nothrow {
    void* handle = _nu_module_win32_verify_pe(base);
    if (!handle)
        return null;

    // NOTE:    If a file has no sections we're probably reading a very messed up
    //          PE file, so we'll stop there.
    //
    // NOTE:    shdrs is a slice into existing memory, DO NOT FREE.
    PeSectionHeader[] shdrs = _nu_module_win32_get_section_headers(handle);
    if (shdrs.length == 0)
        return null;
    
    SectionInfo[] sections;
    sections = sections.nu_resize(shdrs.length);
    nogc_initialize(sections[]);

    foreach(i, ref PeSectionHeader shdr; shdrs) {
        sections[i] = SectionInfo(
            null,
            _nu_module_get_sect_name(shdr.mName).nu_dup,
            base+shdr.mVirtualAddress,
            base+shdr.mVirtualAddress+shdr.mVirtualSize 
        );
    }
    return sections;
}

/*
    Function which enumerates all of the exported symbols.

    This is implemented by backends to abstract away the OS intricaices
    of loading modules and finding symbols within.
*/
Symbol[] _nu_module_enumerate_symbols(void* base) @nogc nothrow {
    void* handle = _nu_module_win32_verify_pe(base);
    if (!handle)
        return null;
    
    // No exports since we don't have a table for it.
    PEHeader* nthdr = cast(PEHeader*) handle;
    if (nthdr.mSizeOfOptionalHeader == 0)
        return null;

    uint[2] exportsRVA;
    ushort pMagic = *cast(ushort*)(handle+PEHeader.sizeof);
    if (pMagic == 0x010b) {
        
        // PE32 (32-bit)
        exportsRVA = *cast(uint[2]*)(handle+PEHeader.sizeof+Pe32OptionalHeader.sizeof);
    } else if (pMagic == 0x020b) {
        
        // PE32+ (64-bit)
        exportsRVA = *cast(uint[2]*)(handle+PEHeader.sizeof+Pe32PlusOptionalHeader.sizeof);

    } else {

        // Unrecognized PE format.
        return null;
    }

    PeExportsTableHeader* exportsTable = cast(PeExportsTableHeader*)(base+exportsRVA[0]);

    // NOTE:    Create and *zero initialize* the symbols array.
    //          we wouldn't want to point to garbage data.
    Symbol[] syms;
    syms = syms.nu_resize(exportsTable.mNamePointerEntryCount);
    nogc_initialize(syms[]);

    uint* nameOffsetTable = cast(uint*)(base+exportsTable.mNamePointerRVA);
    uint* addressTable = cast(uint*)(base+exportsTable.mAddressTableRVA);
    ushort* ordinalTable = cast(ushort*)(base+exportsTable.mNameOrdinalTableRVA);
    foreach(i; 0..exportsTable.mNamePointerEntryCount) {
        const(char)* name = cast(const(char)*)(base+nameOffsetTable[i]);
        uint ordinal = ordinalTable[i]+exportsTable.mOrdinalBase;

        // Out of range.
        if (ordinal >= exportsTable.mAddressTableEntryCount)
            continue;

        // NOTE:    Foreign exports should be nulled.
        //          They are denoted by referencing strings *within*
        //          the export table.
        void* paddr = base+addressTable[ordinal];
        if (paddr >= base+exportsRVA[0] && paddr <= base+exportsRVA[0]+exportsRVA[1])
            paddr = null;

        syms[i] = Symbol(_fstrz(name), paddr);
    }
    return syms;
}

void* _nu_module_win32_verify_pe(void* base) @nogc nothrow {
    ushort magic = *cast(ushort*) base;

    // 'MZ' DOS Header
    if (magic != 0x5A4D)
        return null;


    // NOTE:    e_lfanew is at offset 0x3C, always.
    //          it being reserved in the DOS header, means we can make our
    //          life simpler by simply just passing that in from the start.
    int e_lfanew = *cast(int*)(base + 0x3C);
    void* handle = base + e_lfanew;
    PEHeader* nthdr = cast(PEHeader*) handle;

    // Not a PE file?
    if (nthdr.mMagic != 0x00004550)
        return null;

    // No sections? what?
    if (nthdr.mNumberOfSections == 0)
        return null;

    return handle;
}

string _nu_module_get_sect_name(ref char[8] name) @nogc nothrow {
    foreach(i; 0..name.length) {
        if (name[i] == '\0')
            return cast(string)name[0..i];
    }
    return cast(string)name;
}

PeSectionHeader[] _nu_module_win32_get_section_headers(void* handle) @nogc nothrow {
    PEHeader* nthdr = cast(PEHeader*) handle;
    PeSectionHeader* start = cast(PeSectionHeader*)(handle+PEHeader.sizeof+nthdr.mSizeOfOptionalHeader);
    return start[0..nthdr.mNumberOfSections];
}

string _fstrz(const(char)* str) @nogc nothrow {
    size_t i = 0;
    while(str[i] != '\0') i++;
    return cast(string)str[0..i];
}

//
//          LOCAL BINDINGS
//

extern (Windows) extern void* GetModuleHandleW(const(wchar)*) @nogc nothrow;
extern (Windows) extern void* LoadLibraryW(const(wchar)*) @nogc nothrow;
extern (Windows) extern void* GetProcAddress(void*, const(char)*) @nogc nothrow;
extern (Windows) extern bool FreeLibrary(void*) @nogc nothrow;

// Info taken from https://wiki.osdev.org/PE
struct PEHeader {
align(1):
    uint mMagic;
    ushort mMachine;
    ushort mNumberOfSections;
    uint mTimeDateStamp;
    uint mPointerToSymbolTable;
    uint mNumberOfSymbols;
    ushort mSizeOfOptionalHeader;
    ushort mCharacteristics;
}

// 0x010b - PE32
static assert(Pe32OptionalHeader.sizeof == 96);
align(1) struct Pe32OptionalHeader {
align(1):
	ushort mMagic;
	ubyte  mMajorLinkerVersion;
	ubyte  mMinorLinkerVersion;
	uint mSizeOfCode;
	uint mSizeOfInitializedData;
	uint mSizeOfUninitializedData;
	uint mAddressOfEntryPoint;
	uint mBaseOfCode;
	uint mBaseOfData;
	uint mImageBase;
	uint mSectionAlignment;
	uint mFileAlignment;
	ushort mMajorOperatingSystemVersion;
	ushort mMinorOperatingSystemVersion;
	ushort mMajorImageVersion;
	ushort mMinorImageVersion;
	ushort mMajorSubsystemVersion;
	ushort mMinorSubsystemVersion;
	uint mWin32VersionValue;
	uint mSizeOfImage;
	uint mSizeOfHeaders;
	uint mCheckSum;
	ushort mSubsystem;
	ushort mDllCharacteristics;
	uint mSizeOfStackReserve;
	uint mSizeOfStackCommit;
	uint mSizeOfHeapReserve;
	uint mSizeOfHeapCommit;
	uint mLoaderFlags;
	uint mNumberOfRvaAndSizes;
}

// 0x020b - PE32+ (64 bit)
static assert(Pe32PlusOptionalHeader.sizeof == 112);
align(1) struct Pe32PlusOptionalHeader {
align(1):
	ushort mMagic; 
	ubyte  mMajorLinkerVersion;
	ubyte  mMinorLinkerVersion;
	uint mSizeOfCode;
	uint mSizeOfInitializedData;
	uint mSizeOfUninitializedData;
	uint mAddressOfEntryPoint;
	uint mBaseOfCode;
	ulong mImageBase;
	uint mSectionAlignment;
	uint mFileAlignment;
	ushort mMajorOperatingSystemVersion;
	ushort mMinorOperatingSystemVersion;
	ushort mMajorImageVersion;
	ushort mMinorImageVersion;
	ushort mMajorSubsystemVersion;
	ushort mMinorSubsystemVersion;
	uint mWin32VersionValue;
	uint mSizeOfImage;
	uint mSizeOfHeaders;
	uint mCheckSum;
	ushort mSubsystem;
	ushort mDllCharacteristics;
	ulong mSizeOfStackReserve;
	ulong mSizeOfStackCommit;
	ulong mSizeOfHeapReserve;
	ulong mSizeOfHeapCommit;
	uint mLoaderFlags;
	uint mNumberOfRvaAndSizes;
}

// size 40 bytes
static assert(PeExportsTableHeader.sizeof == 40);
struct PeExportsTableHeader {
    uint mExportFlags;
    uint mTimeDateStamp;
    ushort mMajorVersion;
    ushort mMinorVersion;
    uint mNameRVA;
    uint mOrdinalBase;
    uint mAddressTableEntryCount;
    uint mNamePointerEntryCount;
    uint mAddressTableRVA;
    uint mNamePointerRVA;
    uint mNameOrdinalTableRVA;
}

// size 40 bytes
static assert(PeSectionHeader.sizeof == 40);
struct PeSectionHeader {
    char[8] mName;
    uint mVirtualSize;
    uint mVirtualAddress;
    uint mSizeOfRawData;
    uint mPointerToRawData;
    uint mPointerToRelocations;
    uint mPointerToLinenumbers;
    ushort mNumberOfRelocations;
    ushort mNumberOfLinenumbers;
    uint mCharacteristics;
}