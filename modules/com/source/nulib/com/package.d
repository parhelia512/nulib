/**
    COM Interface

    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.com;
import nulib.com.objbase;
import numem.core.atomic : nu_atomic_add_32, nu_atomic_sub_32;
import numem;

public import nulib.com.winerror;
public import nulib.com.unk;
public import nulib.com.objbase :
    CoInitialize,
    CoInitializeEx,
    CoUninitialize,
    CoGetCurrentProcess,
    CoFreeLibrary;

extern(Windows):

/**
    Class Context that covers everything.
*/
enum CLSCTX_ALL    = CLSCTX.CLSCTX_INPROC_SERVER|CLSCTX.CLSCTX_INPROC_HANDLER|CLSCTX.CLSCTX_LOCAL_SERVER;

/**
    Class Context that covers in-process COM.
*/
enum CLSCTX_INPROC = CLSCTX.CLSCTX_INPROC_SERVER|CLSCTX.CLSCTX_INPROC_HANDLER;

/**
    Class Context that covers remote/serverside COM.
*/
enum CLSCTX_SERVER = CLSCTX.CLSCTX_INPROC_SERVER|CLSCTX.CLSCTX_LOCAL_SERVER|CLSCTX.CLSCTX_REMOTE_SERVER;

/**
    Determines the concurrency model used for incoming calls to 
    objects created by this thread.

    This concurrency model can be either apartment-threaded or multithreaded.
*/
enum ComInitFlags {
    
    /**
        Initializes the thread for apartment-threaded object concurrency.
    */
    AppartmentThreaded = 0x2,
    
    /**
        Initializes the thread for multithreaded object concurrency.
    */
    Multithreaded = 0x0,
    
    /**
        Disables DDE for OLE1 support.
    */
    DisableOLE1DDE = 0x4,
    
    /**
        Increase memory usage in an attempt to increase performance.
    */
    SpeedOverMemory = 0x8,
}
alias COINIT = ComInitFlags; /// ditto

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
    */
    extern(D)
    static T CreateInstance(T, I = IUnknown)(CLSCTX context = CLSCTX_INPROC, IUnknown outer = null) 
    if (is(T == class) && is(I == interface) && is(T : IUnknown) && is(I : IUnknown)) {
        const(Guid) clsid = __uuidof!T;
        const(Guid) riid = __uuidof!I;

        T retv;
        CoCreateInstance(&clsid, outer, context, &riid, cast(void*)&retv);
        return retv;
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
    HRESULT QueryInterface(const(Guid)* riid, void** pvObject) {
        if (*riid == IUnknown.IID) {
            *pvObject = cast(void*)cast(IUnknown)this;
            AddRef();
            return S_OK;
        }

        *pvObject = null;
        return E_NOINTERFACE;
    }

    /**
        Increments the reference count for an interface pointer to a COM object.

        You should call this method whenever you make a copy of an interface pointer.

        Returns:
            The new reference count, should only be used for debugging.
    */
    uint AddRef() {
        return nu_atomic_add_32(refcount, 1);
    }
    
    /**
        Decrements the reference count for an interface on a COM object.

        Returns:
            The new reference count, should only be used for debugging.
    */
    uint Release() {
        int lref = nu_atomic_sub_32(refcount, 1);
        if (lref == 0) {
            ComObject self = this;
            nogc_delete(self);
        }
        return cast(uint)lref;
    }
}

version(unittest) {
    
    @Guid(3485702575u, 55414, 4560, 156, 16, 0, 192, 79, 201, 156, 142)
    class XMLDocument : ComObject { }

    pragma(msg, __traits(isCOMClass, XMLDocument));
}

@("COM Instantiate")
unittest {

    CoInitialize(null);
    IUnknown unk = ComObject.CreateInstance!(XMLDocument, IUnknown)();
    assert(unk !is null);
    CoUninitialize();
}