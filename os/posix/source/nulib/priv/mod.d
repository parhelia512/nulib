/**
    POSIX Implementation for nulib.system.mod

    Copyright:
        Copyright © 2025, Kitsunebi Games
        Copyright © 2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.priv.mod;

version (OSX)
    version = Darwin;
else version (iOS)
    version = Darwin;
else version (TVOS)
    version = Darwin;
else version (WatchOS)
    version = Darwin;
else version (VisionOS)
    version = Darwin;

version(Posix):

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
    Function which loads a module from the given path.

    This is implemented by backends to abstract away the OS intricaices
    of loading modules and finding symbols within.
*/
export
void* _nu_module_open(void* path) @nogc nothrow {
    return dlopen(cast(const(wchar)*)path, 0);
}

/*
    Function which loads a module from the given path.

    This is implemented by backends to abstract away the OS intricaices
    of loading modules and finding symbols within.
*/
void _nu_module_close(void* module_) @nogc nothrow {
    cast(void) dlclose(module_);
}

/*
    Function which finds a symbol within a given module

    This is implemented by backends to abstract away the OS intricaices
    of loading modules and finding symbols within.
*/
void* _nu_module_get_symbol(void* module_, const(char)* symbol) @nogc nothrow {
    return dlsym(module_, symbol);
}

/*
    Function which gets the "base address" of the module.

    This is backend implementation defined; but is what should allow
    $(D _nu_module_enumerate_sections) and $(D _nu_module_enumerate_symbols)
    to function.
*/
void* _nu_module_get_base_address(void* module_) @nogc nothrow {

    Dl_info info;
    if (dladdr(module_, info) != 0)
        return info.dli_fbase;

    return null;
}

//
//          SYSTEM SPECIFIC IMPLEMENTATIONS
//

version(Darwin) {

    SectionInfo[] _nu_module_enumerate_sections(void* base) @nogc nothrow {
        load_command* lcmd;
        uint ncmds;
        bool reqFlip;
        bool is32;
        if (!_nu_module_darwin_get_load_cmds(base, lcmd, ncmds, reqFlip, is32))
            return null;
        
        SectionInfo[] allSections;
        foreach(i; 0..ncmds) {

            SectionInfo[] sections;
            uint cmd = reqFlip ? _nu_ntoh(lcmd.cmd) : lcmd.cmd;
            if (cmd == LC_SEGMENT) {

                segment_command_32* segcmd = cast(segment_command_32*)(cast(void*)lcmd);
                sections = sections.nu_resize(segcmd.nsects);
                section_32* sect = cast(section_32*)(cast(void*)lcmd+segment_command_32.sizeof);
                foreach(i; 0..segcmd.nsects) {

                    sections[i].segment = _nu_module_darwin_get_name(sect.segname);
                    sections[i].section = _nu_module_darwin_get_name(sect.sectname);
                    sections[i].start = reqFlip ? 
                        cast(void*)_nu_ntoh(sect.addr) : 
                        cast(void*)sect.addr;
                    sections[i].end = reqFlip ? 
                        cast(void*)_nu_ntoh(sect.addr+sect.size) : 
                        cast(void*)sect.addr+sect.size;

                    // Next section.
                    sect++;
                }

                allSections = _nu_module_darwin_combine_sect_infos(allSections, sections);
            } else if (cmd == LC_SEGMENT_64) {
                
                segment_command_64* segcmd = cast(segment_command_64*)(cast(void*)lcmd);
                sections = sections.nu_resize(segcmd.nsects);
                section_64* sect = cast(section_64*)(cast(void*)lcmd+segment_command_64.sizeof);
                foreach(i; 0..segcmd.nsects) {

                    sections[i].segment = _nu_module_darwin_get_name(sect.segname);
                    sections[i].section = _nu_module_darwin_get_name(sect.sectname);
                    sections[i].start = reqFlip ? 
                        cast(void*)_nu_ntoh(sect.addr) : 
                        cast(void*)sect.addr;
                    sections[i].end = reqFlip ? 
                        cast(void*)_nu_ntoh(sect.addr+sect.size) : 
                        cast(void*)sect.addr+sect.size;

                    // Next section.
                    sect++;
                }
                
                allSections = _nu_module_darwin_combine_sect_infos(allSections, sections);
            }

            lcmd = cast(load_command*)((cast(void*)lcmd)+lcmd.cmdsize);
        }

        return allSections;
    }
    
    string _nu_module_darwin_get_name(ref char[16] name) @nogc nothrow {
        foreach(i; 0..name.length) {
            if (name[i] == '\0')
                return cast(string)name[0..i];
        }
        return cast(string)name;
    }

    SectionInfo[] _nu_module_darwin_combine_sect_infos(SectionInfo[] a, SectionInfo[] b) @nogc nothrow {
        if (!a)
            return b;
        
        SectionInfo[] c;
        c = c.nu_resize(a.length+b.length);
        c[0..a.length]   = a[0..$];
        c[$-b.length..$] = b[0..$];
        
        a = a.nu_resize(0);
        b = b.nu_resize(0);
        return c;
    }

    bool _nu_module_darwin_get_load_cmds(void* base, ref load_command* first, ref uint ncmds, ref bool reqFlip, ref bool is32) @nogc nothrow {
        uint magic = *cast(uint*)base;
        bool isValid = 
            (magic == MH_MAGIC || magic == MH_MAGIC_64) || 
            (magic == MH_CIGAM || magic == MH_CIGAM_64);
        
        if (!isValid)
            return false;

        reqFlip = 
            magic == MH_CIGAM ||
            magic == MH_CIGAM_64;

        is32 = 
            magic == MH_MAGIC || 
            magic == MH_CIGAM;

        if (is32) {

            mach_header_32* hdr = cast(mach_header_32*)base;
            ncmds = reqFlip ? _nu_ntoh(hdr.ncmds) : hdr.ncmds;
            first = cast(load_command*)(base+mach_header_32.sizeof);
        } else {
            
            mach_header_64* hdr = cast(mach_header_64*)base;
            ncmds = reqFlip ? _nu_ntoh(hdr.ncmds) : hdr.ncmds;
            first = cast(load_command*)(base+mach_header_64.sizeof);
        }

        return true;
    }

    Symbol[] _nu_module_enumerate_symbols(void* base) @nogc nothrow {
        load_command* lcmd;
        uint ncmds;
        bool reqFlip;
        bool is32;
        if (!_nu_module_darwin_get_load_cmds(base, lcmd, ncmds, reqFlip, is32))
            return null;
        
        Symbol[] allSymbols;
        foreach(i; 0..ncmds) {

            Symbol[] syms;
            uint cmd = reqFlip ? _nu_ntoh(lcmd.cmd) : lcmd.cmd;
            if (cmd == LC_SYMTAB) {

                // Locate nlists
                void* symbase = cast(void*)lcmd;
                symtab_command* symtab = cast(symtab_command*)symbase;
                nlist[] nlist_ = cast(nlist*)((cast(void*)symtab)+symhdr.symoff)[0..symhdr.nsyms];

                // Fill out symbols.
                syms = sections.nu_resize(symhdr.nsyms);
                foreach(j; 0..symhdr.nsyms) {

                    const(char)* symbol = cast(const(char)*)((symbase+symtab.stroff)+nlist_[j].n_strx);
                    syms[j] = Symbol(_nu_strz(symbol), nlist_[j].n_value);
                }
                
                allSymbols = _nu_module_darwin_combine_syms(allSymbols, syms);
            }

            lcmd = cast(load_command*)((cast(void*)lcmd)+lcmd.cmdsize);
        }

        return allSymbols;
    }

    Symbol[] _nu_module_darwin_combine_syms(Symbol[] a, Symbol[] b) @nogc nothrow {
        if (!a)
            return b;
        
        Symbol[] c;
        c = c.nu_resize(a.length+b.length);
        c[0..a.length]   = a[0..$];
        c[$-b.length..$] = b[0..$];
        
        a = a.nu_resize(0);
        b = b.nu_resize(0);
        return c;
    }
    
} else {

    SectionInfo[] _nu_module_enumerate_sections(void* base) @nogc nothrow {
        SectionInfo[] sections;
    }

    Symbol[] _nu_module_enumerate_symbols(void* base) @nogc nothrow {
        string[] segments;
        string[] sections;
    }
}


//
//          HELPERS
//

extern(D)
string _nu_strz(const(char)* str) @nogc nothrow {
    size_t i = 0;
    while(str[i] != '\0') i++;
    return cast(string)str[0..i];
}

extern(D)
uint _nu_ntoh(uint val) {
    ubyte* bval = cast(ubyte*)cast(uint*)&val;
    return 
        (cast(uint)bval[0] << 24) |
        (cast(uint)bval[1] << 16) |
        (cast(uint)bval[2] << 8 ) |
        (cast(uint)bval[3] << 0 );
}

extern(D)
ulong _nu_ntoh(ulong val) {
    ubyte* bval = cast(ubyte*)cast(ulong*)&val;
    return 
        (cast(ulong)bval[0] << 56) |
        (cast(ulong)bval[1] << 48) |
        (cast(ulong)bval[2] << 40) |
        (cast(ulong)bval[3] << 32) |
        (cast(ulong)bval[4] << 24) |
        (cast(ulong)bval[5] << 16) |
        (cast(ulong)bval[6] << 8 ) |
        (cast(ulong)bval[7] << 0 );
}


//
//          LOCAL BINDINGS
//

extern(C) extern void* dlopen(const(char)*, int) @nogc nothrow;
extern(C) extern void* dlsym(void*, const(char)*) @nogc nothrow;
extern(C) extern int dladdr(const(void)*, ref Dl_info) @nogc nothrow;
extern(C) extern int dlclose(void*) @nogc nothrow;

struct Dl_info {
    const(char)* dli_fname;
    void* dli_fbase;
    const(char)* dli_sname;
    void* dli_saddr;
}

version(Darwin) {
    enum uint
        MH_MAGIC_64 = 0xfeedfacf,
        MH_CIGAM_64 = 0xcffaedfe,
        MH_MAGIC = 0xfeedface,
        MH_CIGAM = 0xcefaedfe;
    
    enum uint
        LC_SEGMENT = 0x1,
        LC_SYMTAB = 0x2,
        LC_SEGMENT_64 = 0x19;

    struct mach_header_32 {
        uint magic;
        int cputype;
        int cpusubtype;
        uint filetype;
        uint ncmds;
        uint sizeofcmds;
        uint flags;
    }

    struct mach_header_64 {
        uint magic;
        int cputype;
        int cpusubtype;
        uint filetype;
        uint ncmds;
        uint sizeofcmds;
        uint flags;
        uint reserved;
    }

    struct load_command {
        uint cmd;
        uint cmdsize;
    }

    struct segment_command_32 {
        uint cmd;
        uint cmdsize;
        char[16] segname = 0;
        uint vmaddr;
        uint vmsize;
        uint fileoff;
        uint filesize;
        int maxprot;
        int initprot;
        uint nsects;
        uint flags;
    }

    struct segment_command_64 {
        uint cmd;
        uint cmdsize;
        char[16] segname = 0;
        ulong vmaddr;
        ulong vmsize;
        ulong fileoff;
        ulong filesize;
        int maxprot;
        int initprot;
        uint nsects;
        uint flags;
    }

    struct section_32 {
        char[16] sectname = 0;
        char[16] segname = 0;
        uint addr;
        uint size;
        uint offset;
        uint align_;
        uint reloff;
        uint nreloc;
        uint flags;
        uint reserved1;
        uint reserved2;
    }

    struct section_64 {
        char[16] sectname = 0;
        char[16] segname = 0;
        ulong addr;
        ulong size;
        uint offset;
        uint align_;
        uint reloff;
        uint nreloc;
        uint flags;
        uint reserved1;
        uint reserved2;
        uint reserved3;
    }

    struct nlist {
        uint n_strx;
        ubyte n_type;
        ubyte n_sect;
        ushort n_desc;
        ulong n_value;
    }

    struct symtab_command {
        uint cmd;
        uint cmdsize;
        uint symoff;
        uint nsyms;
        uint stroff;
        uint strsize;
    }
}
