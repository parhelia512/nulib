/**
    COM Object Base Functions

    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.system.com.objbase;
import nulib.system.com.winerror;
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

HRESULT CoInitialize(void*);
HRESULT CoInitializeEx(uint, void*);
void CoUninitialize();
uint CoGetCurrentProcess();
HRESULT CoCreateInstance(const(IID)*, IUnknown, CLSCTX, const(CLSID)*, void**);
void CoFreeLibrary(void*);
void CoFreeAllLibraries();
void CoFreeUnusedLibraries();
HRESULT CLSIDFromProgID(const(wchar)*, const(IID)*);