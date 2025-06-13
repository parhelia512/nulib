/**
    COM Object Base Functions

    Copyright:
        Copyright © 2023-2025, Kitsunebi Games
        Copyright © 2023-2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.system.com.objbase;
import nulib.system.com.uuid;
import nulib.system.com.hresult;
import nulib.system.com.unk;

extern(Windows) @nogc nothrow:

enum CLSCTX : uint {
    CLSCTX_INPROC_SERVER    = 0x1,
    CLSCTX_INPROC_HANDLER   = 0x2,
    CLSCTX_LOCAL_SERVER     = 0x4,
    CLSCTX_INPROC_SERVER16  = 0x8,
    CLSCTX_REMOTE_SERVER    = 0x10,
    CLSCTX_INPROC_HANDLER16 = 0x20,
    CLSCTX_INPROC_SERVERX86 = 0x40,
    CLSCTX_INPROC_HANDLERX86 = 0x80,
}

/**
    Determines the concurrency model used for incoming calls to objects created by this thread.
    This concurrency model can be either apartment-threaded or multithreaded.

    Remarks:
        $(P 
            When a thread is initialized through a call to CoInitializeEx, 
            you choose whether to initialize it as apartment-threaded or multithreaded by 
            designating one of the members of COINIT as its second parameter.

            This designates how incoming calls to any object created by that thread are handled, 
            that is, the object's concurrency.
        )
        $(P 
            Apartment-threading, while allowing for multiple threads of execution, 
            serializes all incoming calls by requiring that calls to methods of objects created by 
            this thread always run on the same thread, i.e. the apartment/thread that created them.

            In addition, calls can arrive only at message-queue boundaries.

            Because of this serialization, it is not typically necessary to write concurrency 
            control into the code for the object, other than to avoid calls to PeekMessage and 
            SendMessage during processing that must not be interrupted by other method invocations 
            or calls to other objects in the same apartment/thread.
        )
        $(P
            Multi-threading (also called free-threading) allows calls to methods of objects 
            created by this thread to be run on any thread.
            There is no serialization of calls, i.e. many calls may occur to the same method 
            or to the same object or simultaneously.

            Multi-threaded object concurrency offers the highest performance and takes the best 
            advantage of multiprocessor hardware for cross-thread, cross-process, and cross-machine 
            calling, since calls to objects are not serialized in any way.
            This means, however, that the code for objects must enforce its own concurrency model, 
            typically through the use of synchronization primitives, such as critical sections, 
            semaphores, or mutexes.

            In addition, because the object doesn't control the lifetime of the threads 
            that are accessing it, no thread-specific state may be stored in the object 
            (in Thread Local Storage).
        )

    Notes:
        $(P
            The multi-threaded apartment is intended for use by non-GUI threads.
            Threads in multi-threaded apartments should not perform UI actions.
            This is because UI threads require a message pump, and COM does not pump messages for 
            threads in a multi-threaded apartment.
        )
*/
enum COINIT : uint {
    
    /**
        Initializes the thread for apartment-threaded object concurrency (see Remarks).
    */
    APARTMENTTHREADED = 0x2,
    
    /**
        Initializes the thread for multithreaded object concurrency (see Remarks).
    */
    MULTITHREADED = 0x0,
    
    /**
        Disables DDE for OLE1 support.
    */
    DISABLE_OLE1DDE = 0x4,
    
    /**
        Increase memory usage in an attempt to increase performance.
    */
    SPEED_OVER_MEMORY = 0x8
}


/**
    Initializes the COM library on the current thread and 
    identifies the concurrency model as single-thread apartment (STA).

    Params:
        pvReserved = Reserved, must be $(D null).
    
    Returns:
        An HRESULT indicating the error code.
*/
extern HRESULT CoInitialize(void* pvReserved = null);
extern HRESULT CoInitializeEx(uint, void*);
extern void CoUninitialize();
extern uint CoGetCurrentProcess();
extern HRESULT CoCreateInstance(const(IID)*, IUnknown, CLSCTX, const(CLSID)*, void**);
extern void CoFreeLibrary(void*);
extern void CoFreeAllLibraries();
extern void CoFreeUnusedLibraries();
extern void* MIDL_user_allocate(size_t);
extern void MIDL_user_free(void*);

debug {
    extern uint DebugCoGetRpcFault();
    extern void DebugCoSetRpcFault(uint);
}