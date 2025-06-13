/**
    Shared Library Modules

    Copyright:
        Copyright © 2025, Kitsunebi Games
        Copyright © 2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.system.mod;
import nulib.system;
import nulib.string;
import numem;

/**
    A higher level wrapper over OS level modules/shared libraries.
*/
class Module : NuRefCounted {
private:
@nogc:
    Handle handle;
    Section[] sections;

public:

    /**
        Constructs a new module.
    */
    this(string path) { 
        this.handle = _nu_open_module(path);
        this.sections = _nu_module_enumerate_sections(handle);
    }

    /**
        Destructor
    */
    ~this() {
        foreach(ref section; sections)
            nogc_delete(section);
        this.sections = sections.nu_resize(0);

        _nu_close_module(handle);
    }
    
    /**
        Gets a symbol from the module.

        Params:
            sym = The name of the symbol to get.
        
        Returns:
            A pointer to the symbol or $(D null) if the
            symbol was not found.
    */
    final
    void* getSymbol(string sym) {
        return _nu_module_get_symbol(handle, sym);
    }
}

/**
    A section within a module
*/
class Section : NuObject {
private:
@nogc:
    Module module_;
    Symbol[] symbols_;
    string segmentName;
    string sectionName;

public:

    /**
        The name of the segment this section resides in
    */
    @property string segment() { return segmentName; }

    /**
        The name of this section
    */
    @property string section() { return sectionName; }

    /**
        The name of this section
    */
    @property Symbol[] symbols() { return symbols_; }

    /**
        Destructor
    */
    ~this() {
        this.module_.release();

        // Free symbols and names.
        foreach(ref symbol; symbols_)
            symbol.name = symbol.name.nu_resize(0);
        this.symbols_ = symbols_.nu_resize(0);
        this.segmentName = segmentName.nu_resize(0);
        this.sectionName = sectionName.nu_resize(0);
    }

    /**
        Constructor
    */
    this(Module module_, Symbol[] symbols, string segment, string section) {
        this.module_ = module_.retained;
        this.symbols_ = symbols;
        this.segmentName = segment;
        this.sectionName = section;
    }
}

/**
    A symbol within a section.
*/
struct Symbol {

    /**
        Name of the symbol
    */
    string name;
    
    /**
        Pointer to the symbol
    */
    void* ptr;
}



//
//          FOR IMPLEMENTORS
//

private extern(C):
import core.attribute : weak;

/*
    Function which loads a module from the given path.

    This is implemented by backends to abstract away the OS intricaices
    of loading modules and finding symbols within.
*/
Handle _nu_open_module(string path) @weak @nogc nothrow { return null; }

/*
    Function which loads a module from the given path.

    This is implemented by backends to abstract away the OS intricaices
    of loading modules and finding symbols within.
*/
void _nu_close_module(Handle module_) @weak @nogc nothrow { return; }

/*
    Function which finds a symbol within a given module

    This is implemented by backends to abstract away the OS intricaices
    of loading modules and finding symbols within.
*/
void* _nu_module_get_symbol(Handle module_, string symbol) @weak @nogc nothrow { return null; }

/**
    Function which enumerates the sections in a module.

    This is implemented by backends to abstract away the OS intricaices
    of loading modules and finding symbols within.
*/
Section[] _nu_module_enumerate_sections(Handle handle) @weak @nogc nothrow { return null; }