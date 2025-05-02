/**
 * Windows API header module
 *
 * Translated from MinGW API for MS-Windows 3.10
 *
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source: $(DRUNTIMESRC core/sys/windows/_lmuseflg.d)
 */
module nulib.system.win32.lmuseflg;


enum : uint {
    USE_NOFORCE = 0,
    USE_FORCE,
    USE_LOTS_OF_FORCE // = 2
}
