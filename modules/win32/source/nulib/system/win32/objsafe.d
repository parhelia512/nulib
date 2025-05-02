/**
 * Windows API header module
 *
 * Translated from MinGW Windows headers
 *
 * Authors: Stewart Gordon
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source: $(DRUNTIMESRC core/sys/windows/_objsafe.d)
 */
module nulib.system.win32.objsafe;
import nulib.system.win32.windef;
import nulib.system.com;

enum {
    INTERFACESAFE_FOR_UNTRUSTED_CALLER = 1,
    INTERFACESAFE_FOR_UNTRUSTED_DATA
}

interface IObjectSafety : IUnknown {
    HRESULT GetInterfaceSafetyOptions(REFIID, DWORD*, DWORD*);
    HRESULT SetInterfaceSafetyOptions(REFIID, DWORD, DWORD);
}
