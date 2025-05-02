/**
 * Windows API header module
 *
 * Translated from MinGW API for MS-Windows 3.10
 *
 * Authors: Stewart Gordon
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source: $(DRUNTIMESRC core/sys/windows/_isguids.d)
 */
module nulib.system.win32.isguids;


import nulib.system.win32.basetyps;

extern (C) extern const GUID
    CLSID_InternetShortcut,
    IID_IUniformResourceLocator;
