/**
 * Windows API header module
 *
 * Translated from MinGW Windows headers
 *
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source: $(DRUNTIMESRC core/sys/windows/_lmconfig.d)
 */
module nulib.system.win32.lmconfig;


// All functions in this file are deprecated!

import nulib.system.win32.lmcons, nulib.system.win32.windef;

deprecated {
    struct CONFIG_INFO_0 {
        LPWSTR cfgi0_key;
        LPWSTR cfgi0_data;
    }

    alias CONFIG_INFO_0* PCONFIG_INFO_0, LPCONFIG_INFO_0;

    extern (Windows) {
        NET_API_STATUS NetConfigGet(LPCWSTR, LPCWSTR, LPCWSTR, PBYTE*);
        NET_API_STATUS NetConfigGetAll(LPCWSTR, LPCWSTR, PBYTE*);
        NET_API_STATUS NetConfigSet(LPCWSTR, LPCWSTR, LPCWSTR, DWORD, DWORD,
          PBYTE, DWORD);
    }
}
