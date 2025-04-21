module nulib.system.com.com;
import nulib.system.com.objbase;
import numem.core.atomic : nu_atomic_add_32, nu_atomic_sub_32;
import numem;

public import nulib.system.com.winerror;
public import nulib.system.com.unk;
import nulib.system.com.objbase :
    CoInitialize,
    CoInitializeEx,
    CoUninitialize,
    CoGetCurrentProcess,
    CoFreeLibrary,
    CoFreeUnusedLibraries,
    CLSIDFromProgID;

/**
    Class Context for COM Object Instantiation.
*/
enum ComClassContext : CLSCTX {
    
    /**
        Class Context that covers everything.
    */
    all =       CLSCTX.CLSCTX_INPROC_SERVER|CLSCTX.CLSCTX_INPROC_HANDLER|CLSCTX.CLSCTX_LOCAL_SERVER,
        
    /**
        Class Context that covers in-process COM.
    */
    inProcess = CLSCTX.CLSCTX_INPROC_SERVER|CLSCTX.CLSCTX_INPROC_HANDLER,

    /**
        Class Context that covers remote/serverside COM.
    */
    server =    CLSCTX.CLSCTX_INPROC_SERVER|CLSCTX.CLSCTX_LOCAL_SERVER|CLSCTX.CLSCTX_REMOTE_SERVER,
}

/**
    Determines the concurrency model used for incoming calls to 
    objects created by this thread.

    This concurrency model can be either apartment-threaded or multithreaded.
*/
enum ComInitFlags : uint {
    
    /**
        Initializes the thread for (single) apartment-threaded object concurrency.
    */
    appartmentThreaded = 0x2,
    
    /**
        Initializes the thread for multithreaded object concurrency.
    */
    multithreaded = 0x0,
    
    /**
        Disables DDE for OLE1 support.
    */
    disableOLE1DDE = 0x4,
    
    /**
        Increase memory usage in an attempt to increase performance.
    */
    speedOverMemory = 0x8,
}
alias COINIT = ComInitFlags; /// ditto

/**
    Initializes the COM Framework.
    
    Returns:
        $(D true) if the COM framework was initialized,
        $(D false) otherwise.
*/
extern(C)
bool nu_com_init(ComInitFlags flags = ComInitFlags.appartmentThreaded) {
    return CoInitializeEx(flags, null) == S_OK;
}

/**
    Closes the COM Framework.
*/
extern(C)
void nu_com_quit() {
    CoUninitialize();
}

/**
    Gets the current COM Thread ID. 
*/
extern(C)
uint nu_com_gettid() {
    return CoGetCurrentProcess();
}

/**
    Frees specified library or unused libraries if $(D lib) is $(D null)

    Params:
        lib = the library to free, or $(D null) to free unused.
*/
extern(C)
void nu_com_freelibrary(void* lib) {
    if (lib)
        CoFreeLibrary(lib);
    else
        CoFreeUnusedLibraries();
}

/**
    Base COM Class for D extensions to the COM API.
*/
@nu_autoreleasewith!((ref obj) { obj.Release(); })
class ComObject : IUnknown {
extern(Windows) @nogc:
private:
    uint refcount;

public:

    /**
        Creates and default-initializes a single object of the class specified.

        Params:
            target =    The target interface to put the class instance into.
            context =   The context in which the class will be instantiated.
            outer =     The outer class instance that this instance should be instantiated
                        within, or $(D null) if it's not an aggregate COM Object.

        Returns:
            $(D HRESULT) describing whether the operation succeeded.
            Check against $(D S_OK).
    */
    extern(D)
    static HRESULT createInstance(T, I = IUnknown)(ref I target, CLSCTX context = CLSCTX_INPROC, IUnknown outer = null) 
    if (is(T == class) && is(I == interface) && is(T : IUnknown) && is(I : IUnknown)) {
        const(Guid) clsid = __uuidof!T;
        const(Guid) riid = __uuidof!I;
        return CoCreateInstance(&clsid, outer, context, &riid, cast(void**)&target);
    }

    /**
        Params:
            progID =    ProgID of the class to instantiate in any encoding.
                        The encoding is automatically converted to the correct format.
            target =    The target instance to create
            context =   The class context
            outer =     The outer class
    */
    extern(D)
    static HRESULT createInstance(T, I = IUnknown)(inout(T)[] progID, ref I target, ComClassContext context = ComClassContext.inProcess, IUnknown outer = null) 
    if (is(I == interface) && is(I : IUnknown)) {
        import nulib.string : nwstring;

        nwstring clsname = progID;
        const(Guid) riid = __uuidof!I;
        const(Guid) clsid;
        
        CLSIDFromProgID(clsname.ptr, &clsid);
        return CoCreateInstance(&clsid, outer, context, &riid, cast(void**)&target);
    }

    /**
        Queries a COM object for a pointer to one of its interface.

        Note:
            Because you pass the address of an interface pointer, 
            the method can overwrite that address with the pointer to the interface being queried for.
            Upon successful return, $(D *ppvObject) (the dereferenced address) contains a pointer to 
            the requested interface.
            If the object doesn't support the interface, the method sets $(D *ppvObject) 
            (the dereferenced address) to $(D null).

        Params:
            riid = Pointer to the Guid of the interface being queried for.
            ppvObject = Pointer to pointer to store result of operation.

        Returns:
            $(D S_OK) if supported, $(D E_NOINTERFACE) otherwise.
            If ppvObject is $(D null), returns $(D E_POINTER). 
    */
    HRESULT QueryInterface(const(IID)* riid, void** ppvObject) { // @suppress(dscanner.style.phobos_naming_convention)
        if (*riid == IUnknown.iid) {
            *ppvObject = cast(void*)cast(IUnknown)this;
            AddRef();
            return S_OK;
        }

        *ppvObject = null;
        return E_NOINTERFACE;
    }

    /**
        Increments the reference count for an interface pointer to a COM object.

        You should call this method whenever you make a copy of an interface pointer.

        Returns:
            The new reference count, should only be used for debugging.
    */
    uint AddRef() { // @suppress(dscanner.style.phobos_naming_convention)
        return nu_atomic_add_32(refcount, 1);
    }
    
    /**
        Decrements the reference count for an interface on a COM object.

        Returns:
            The new reference count, should only be used for debugging.
    */
    uint Release() { // @suppress(dscanner.style.phobos_naming_convention)
        int lref = nu_atomic_sub_32(refcount, 1);
        if (lref == 0) {
            ComObject self = this;
            nogc_delete(self);
        }
        return cast(uint)lref;
    }
}
