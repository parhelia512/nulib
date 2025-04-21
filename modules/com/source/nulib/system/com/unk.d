/**
    COM Base Interfaces

    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.system.com.unk;
import nulib.system.com.winerror;
import nulib.system.com.objbase;
import numem.core.traits : getUDAs, hasUDA;
import nulib.uuid;

/**
    A Compile-Time Globally Unique Identifier.
*/
enum Guid(string guid) = CTUUID!(guid);

/**
    A Globally Unique Identifier.
*/
enum Guid(uint time_low, ushort time_mid, ushort time_hi_and_version, ubyte clk0, ubyte clk1, ubyte d0, ubyte d1, ubyte d2, ubyte d3, ubyte d4, ubyte d5) = 
    UUID(time_low, time_mid, time_hi_and_version, clk0, clk1, d0, d1, d2, d3, d4, d5);

alias GUID = UUID;
alias IID = UUID;
alias CLSID = UUID;

/**
    Gets the $(D Guid) for the given type if possible.

    You can check if a type has a Guid with a $(D is(__uuidof!T)) expression.
*/
template __uuidof(T, A...) {
    import nulib.system.com.unk : Guid;

    static if (A.length == 0)
        alias __uuidof = __uuidof!(T, __traits(getAttributes, T));
    else static if (A.length == 1) {
        static assert (is(typeof(A[0]) == UUID), T.stringof~" lacks a GUID!");
        enum __uuidof = A[0];
    } else static if (is(typeof(A[0]) == UUID)) {
        enum __uuidof = A[0];
    } else {
        alias __uuidof = __uuidof!(T, A[1 .. $]);
    }
}

/**
    Fundamental interface within the COM Programming Model.

    All COM classes must derive from this interface.
*/
@Guid!(0, 0, 0, 192, 0, 0, 0, 0, 0, 0, 70)
interface IUnknown {
extern(Windows) @nogc:
public:
    /**
        Helper type for getting the GUID of IUnknown.
    */
    extern(D) __gshared const IID iid = __uuidof!IUnknown;

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
    HRESULT QueryInterface(const(IID)* riid, void** ppvObject);
    
    /**
        A helper function that infers an interface identifier.
    */
    extern(D)
    HRESULT QueryInterface(T)(T** pvObject) if(is(__uuidof!T)) {
        return QueryInterface(__uuidof!T, pvObject);
    }

    /**
        Increments the reference count for an interface pointer to a COM object.

        You should call this method whenever you make a copy of an interface pointer.

        Returns:
            The new reference count, should only be used for debugging.
    */
    uint AddRef();
    
    /**
        Decrements the reference count for an interface on a COM object.

        Returns:
            The new reference count, should only be used for debugging.
    */
    uint Release();
}

/**
    A class factory.

    Class factories allows classes to be instantiated in an uninitialized state.
*/
interface IClassFactory : IUnknown {
extern(Windows) @nogc:
    
    /**
        Creates an uninitialized object.

        Params:
            outer =     If the object is an aggregate, specify controlling $(D IUnknown) 
                        interface, otherwise set this to $(D null)
            riid =      The identifier of the interface to be used to communicate with
                        the newly created object. If $(D outer) is $(D null), this must
                        be set to $(D IUnknown.IID).
            ppvObject = The address of pointer variable that receives the interface 
                        pointer requested in $(D riid).

        Returns:
            $(D S_OK) if creation succeeded, 
            $(D CLASS_E_NOAGGREGATION) if object doesn't support aggregation, 
            $(D E_NOINTERFACE) if the $(D riid) interface isn't supported,
            or either of $(D E_INVALIDARG), $(D E_OUTOFMEMORY) and $(D E_UNEXPECTED).
    */
    HRESULT CreateInterface(IUnknown outer, const(IID)* riid, void** ppvObject);

    /**
        Locks an object application open in memory. 
        This enables instances to be created more quickly.
    
        Params:
            fLock = If $(D true) increments lock count, otherwise the lock count
                    is decremented.
        
        Returns:
            Either of $(D S_OK), $(D E_FAIL), $(D E_UNEXPECTED) or $(D E_OUTOFMEMORY)
    */
    HRESULT LockServer(bool fLock);
}
