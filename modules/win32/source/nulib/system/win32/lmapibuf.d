/**
 * Windows API header module
 *
 * Translated from MinGW Windows headers
 *
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source: $(DRUNTIMESRC core/sys/windows/_lmapibuf.d)
 */
module nulib.system.win32.lmapibuf;

pragma(lib, "netapi32");

import nulib.system.win32.lmcons, nulib.system.win32.windef;

extern (Windows) nothrow @nogc {
    NET_API_STATUS NetApiBufferAllocate(DWORD, PVOID*);
    NET_API_STATUS NetApiBufferFree(PVOID);
    NET_API_STATUS NetApiBufferReallocate(PVOID, DWORD, PVOID*);
    NET_API_STATUS NetApiBufferSize(PVOID, PDWORD);
    NET_API_STATUS NetapipBufferAllocate(DWORD, PVOID*);
}
