/**
 * Windows API header module
 *
 * Translated from MinGW Windows headers
 *
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source: $(DRUNTIMESRC core/sys/windows/_shldisp.d)
 */
module nulib.system.win32.shldisp;
import nulib.system.win32.windef;
import nulib.system.win32.wtypes;
import nulib.system.com;

// options for IAutoComplete2
enum DWORD ACO_AUTOSUGGEST = 0x01;

interface IAutoComplete : IUnknown {
    HRESULT Init(HWND, IUnknown, LPCOLESTR, LPCOLESTR);
    HRESULT Enable(BOOL);
}
alias LPAUTOCOMPLETE = IAutoComplete;

interface IAutoComplete2 : IAutoComplete {
    HRESULT SetOptions(DWORD);
    HRESULT GetOptions(DWORD*);
}
alias LPAUTOCOMPLETE2 = IAutoComplete2;
