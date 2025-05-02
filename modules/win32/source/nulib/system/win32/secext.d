/**
 * Windows API header module
 *
 * Translated from MinGW Windows headers
 *
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source: $(DRUNTIMESRC core/sys/windows/_secext.d)
 */
// Don't include this file directly, use nulib.system.win32.security instead.
module nulib.system.win32.secext;


version (ANSI) {} else version = Unicode;
pragma(lib, "secur32");

import nulib.system.win32.w32api, nulib.system.win32.windef;

static assert (_WIN32_WINNT >= 0x501,
  "SecExt is only available on WindowsXP and later");

enum EXTENDED_NAME_FORMAT {
    NameUnknown,
    NameFullyQualifiedDN,
    NameSamCompatible,
    NameDisplay,          // =  3
    NameUniqueId             =  6,
    NameCanonical,
    NameUserPrincipal,
    NameCanonicalEx,
    NameServicePrincipal, // = 10
    NameDnsDomain            = 12
}
alias PEXTENDED_NAME_FORMAT = EXTENDED_NAME_FORMAT*;

extern (Windows) {
    BOOLEAN GetComputerObjectNameA(EXTENDED_NAME_FORMAT, LPSTR, PULONG);
    BOOLEAN GetComputerObjectNameW(EXTENDED_NAME_FORMAT, LPWSTR, PULONG);
    BOOLEAN GetUserNameExA(EXTENDED_NAME_FORMAT, LPSTR, PULONG);
    BOOLEAN GetUserNameExW(EXTENDED_NAME_FORMAT, LPWSTR, PULONG);
    BOOLEAN TranslateNameA(LPCSTR, EXTENDED_NAME_FORMAT,
      EXTENDED_NAME_FORMAT, LPSTR, PULONG);
    BOOLEAN TranslateNameW(LPCWSTR, EXTENDED_NAME_FORMAT,
      EXTENDED_NAME_FORMAT, LPWSTR, PULONG);
}

version (Unicode) {
    alias GetComputerObjectName = GetComputerObjectNameW;
    alias GetUserNameEx = GetUserNameExW;
    alias TranslateName = TranslateNameW;
} else {
    alias GetComputerObjectName = GetComputerObjectNameA;
    alias GetUserNameEx = GetUserNameExA;
    alias TranslateName = TranslateNameA;
}
