/**
 * Windows API header module
 *
 * Translated from MinGW Windows headers
 *
 * Authors: Stewart Gordon
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source: $(DRUNTIMESRC core/sys/windows/_windef.d)
 */
module nulib.system.win32.windef;


public import nulib.system.win32.winnt;
import nulib.system.win32.w32api;

enum size_t MAX_PATH = 260;

pure nothrow @nogc {
    ushort MAKEWORD(ubyte a, ubyte b) {
        return cast(ushort) ((b << 8) | a);
    }

    ushort MAKEWORD(ushort a, ushort b) {
        assert((a & 0xFF00) == 0);
        assert((b & 0xFF00) == 0);
        return MAKEWORD(cast(ubyte)a, cast(ubyte)b);
    }

    uint MAKELONG(ushort a, ushort b) {
        return cast(uint) ((b << 16) | a);
    }

    uint MAKELONG(uint a, uint b) {
        assert((a & 0xFFFF0000) == 0);
        assert((b & 0xFFFF0000) == 0);
        return MAKELONG(cast(ushort)a, cast(ushort)b);
    }

    ushort LOWORD(ulong l) {
        return cast(ushort) l;
    }

    ushort HIWORD(ulong l) {
        return cast(ushort) (l >>> 16);
    }

    ubyte LOBYTE(ushort w) {
        return cast(ubyte) w;
    }

    ubyte HIBYTE(ushort w) {
        return cast(ubyte) (w >>> 8);
    }
}

enum NULL = null;
static assert (is(typeof({
    void test(int* p) {}
    test(NULL);
})));

alias ubyte        BYTE;
alias PBYTE = ubyte*;
alias LPBYTE = ubyte*;
alias USHORT = ushort;
alias WORD = ushort;
alias ATOM = ushort;
alias PUSHORT = ushort*;
alias PWORD = ushort*;
alias LPWORD = ushort*;
alias ULONG = uint;
alias DWORD = uint;
alias UINT = uint;
alias COLORREF = uint;
alias PULONG = uint*;
alias PDWORD = uint*;
alias LPDWORD = uint*;
alias PUINT = uint*;
alias LPUINT = uint*;
alias LPCOLORREF = uint*;
alias WINBOOL = int;
alias BOOL = int;
alias INT = int;
alias LONG = int;
alias HFILE = int;
alias HRESULT = int;
alias PWINBOOL = int*;
alias LPWINBOOL = int*;
alias PBOOL = int*;
alias LPBOOL = int*;
alias PINT = int*;
alias LPINT = int*;
alias LPLONG = int*;
alias FLOAT = float ;
alias PFLOAT = float*;
alias PCVOID = const(void)*;
alias LPCVOID = const(void)*;

alias WPARAM = UINT_PTR;
alias LPARAM = LONG_PTR;
alias LRESULT = LONG_PTR;

alias HHOOK = HANDLE;
alias HGLOBAL = HANDLE;
alias HLOCAL = HANDLE;
alias GLOBALHANDLE = HANDLE;
alias LOCALHANDLE = HANDLE;
alias HGDIOBJ = HANDLE;
alias HACCEL = HANDLE;
alias HBITMAP = HGDIOBJ;
alias HBRUSH = HGDIOBJ;
alias HCOLORSPACE = HANDLE;
alias HDC = HANDLE;
alias HGLRC = HANDLE;
alias HDESK = HANDLE;
alias HENHMETAFILE = HANDLE;
alias HFONT = HGDIOBJ;
alias HICON = HANDLE;
alias HINSTANCE = HANDLE;
alias HKEY = HANDLE;
alias HMENU = HANDLE;
alias HMETAFILE = HANDLE;
alias HMODULE = HANDLE;
alias HMONITOR = HANDLE;
alias HPALETTE = HANDLE;
alias HPEN = HGDIOBJ;
alias HRGN = HGDIOBJ;
alias HRSRC = HANDLE;
alias HSTR = HANDLE;
alias HTASK = HANDLE;
alias HWND = HANDLE;
alias HWINSTA = HANDLE;
alias HKL = HANDLE;
alias HCURSOR = HANDLE;
alias PHKEY = HKEY*;

static if (_WIN32_WINNT >= 0x500) {
    alias HTERMINAL = HANDLE;
    alias HWINEVENTHOOK = HANDLE;
}

alias extern (Windows) INT_PTR function() nothrow FARPROC, NEARPROC, PROC;

struct RECT {
    LONG left;
    LONG top;
    LONG right;
    LONG bottom;
}
alias RECTL = RECT;
alias PRECT = RECT*;
alias NPRECT = RECT*;
alias LPRECT = RECT*;
alias PRECTL = RECT*;
alias LPRECTL = RECT*;
alias const(RECT)* LPCRECT, LPCRECTL;

struct POINT {
    LONG x;
    LONG y;
}
alias POINTL = POINT;
alias PPOINT = POINT*;
alias NPPOINT = POINT*;
alias LPPOINT = POINT*;
alias PPOINTL = POINT*;
alias LPPOINTL = POINT*;

struct SIZE {
    LONG cx;
    LONG cy;
}
alias SIZEL = SIZE;
alias PSIZE = SIZE*;
alias LPSIZE = SIZE*;
alias PSIZEL = SIZE*;
alias LPSIZEL = SIZE*;

struct POINTS {
    SHORT x;
    SHORT y;
}
alias PPOINTS = POINTS*;
alias LPPOINTS = POINTS*;

enum : BOOL {
    FALSE = 0,
    TRUE  = 1
}
