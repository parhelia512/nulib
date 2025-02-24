module nulib.gmodule;
import nulib.glib.gerror;
import nulib.string;

/**
    Flags passed to g_module_open(). Note that these flags are not supported on all platforms.
*/
alias GModuleFlags = uint;
enum GModuleFlags
    G_MODULE_BIND_LAZY = 0x01,
    G_MODULE_BIND_LOCAL = 0x02,
    G_MODULE_BIND_MASK = 0x03;

/**
    The GModule struct is an opaque data structure to 
    represent a dynamically-loaded module.
*/
struct GModule {
@nogc nothrow:
public:
    /**
        Whether dynamic modules are supported on the given platform.
    */
    static @property bool supported() { return g_module_supported(); }

    /**
        Opens a new GModule.
    */
    static GModule* open(const(char)* name, GModuleFlags flags, ref GError* error) {
        return g_module_open_full(name, flags, &error);
    }

    /**
        Gets this application's GModule.
    */
    static @property GModule* application() {
        return g_module_open_full(null, 0, null);
    }

    /**
        Returns the filename that the module was opened with.

        Returns:
            Filename of module or $(D "main") if module refers
            to application. 
    */
    @property const(char)* name() { return g_module_name(&this); }

    /**
        Ensures that a module will never be unloaded.
        Any future $(D close) calls on the module will be ignored.
    */
    void makeResident() { g_module_make_resident(&this); }

    /**
        Closes a module.

        Returns:
            $(D true) on success,
            $(D false) otherwise.
    */
    bool close() { return g_module_close(&this); }

    /**
        Gets a symbol pointer from a module, such as one exported by G_MODULE_EXPORT.
        Note that a valid symbol can be NULL.

        Returns:
            $(D true) on success,
            $(D false) otherwise.
    */
    bool getSymbol(T)(const(char)* name, out T symbol) {
        return g_module_symbol(&this, name, cast(void*)&symbol);
    }
    
    /**
        Gets this module's name as a D slice.
    */
    string toString() const {
        const(char)* text = g_module_name(cast(GModule*)&this);
        return cast(string)text[0..nu_strlen(text)];
    }
}

extern(C) @nogc nothrow:

const(char)* g_module_error();
GQuark g_module_error_quark();
GModule* g_module_open_full (const(char)* file_name, GModuleFlags flags, GError** error);
bool g_module_supported();

bool g_module_close(GModule* mod);
void g_module_make_resident(GModule* mod);
const(char)* g_module_name(GModule* mod);
bool g_module_symbol(GModule* mod, const(char)* symbol_name, void* symbol);