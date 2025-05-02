/**
 * Helper module for the Windows API
 *
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source: $(DRUNTIMESRC core/sys/windows/_core.d)
 */
module nulib.system.win32.core;


/**
 The core Windows API functions.

 Importing this file is equivalent to the C code:
 ---
 #define WIN32_LEAN_AND_MEAN
 #include "windows.h"
 ---

*/

public import nulib.system.win32.windef;
public import nulib.system.win32.winnt;
public import nulib.system.win32.wincon;
public import nulib.system.win32.winbase;
public import nulib.system.win32.wingdi;
public import nulib.system.win32.winuser;
public import nulib.system.win32.winnls;
public import nulib.system.win32.winver;
public import nulib.system.win32.winnetwk;
public import nulib.system.win32.winsvc;
