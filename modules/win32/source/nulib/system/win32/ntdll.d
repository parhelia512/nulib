/**
 * Windows API header module
 *
 * Translated from MinGW API for MS-Windows 3.10
 *
 * Authors: Stewart Gordon
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source: $(DRUNTIMESRC core/sys/windows/_ntdll.d)
 */
module nulib.system.win32.ntdll;


import nulib.system.win32.w32api;


enum SHUTDOWN_ACTION {
    ShutdownNoReboot,
    ShutdownReboot,
    ShutdownPowerOff
}

extern (Windows) nothrow @nogc uint NtShutdownSystem(SHUTDOWN_ACTION Action);
