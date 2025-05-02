/**
 * Windows API header module
 *
 * Translated from MinGW Windows headers
 *
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source: $(DRUNTIMESRC core/sys/windows/_lm.d)
 */
module nulib.system.win32.lm;


/* removed - now supporting only Win2k up
version (WindowsVista) {
    version = WIN32_WINNT_ONLY;
} else version (Windows2003) {
    version = WIN32_WINNT_ONLY;
} else version (WindowsXP) {
    version = WIN32_WINNT_ONLY;
} else version (WindowsNTonly) {
    version = WIN32_WINNT_ONLY;
}
*/
public import nulib.system.win32.lmcons;
public import nulib.system.win32.lmaccess;
public import nulib.system.win32.lmalert;
public import nulib.system.win32.lmat;
public import nulib.system.win32.lmerr;
public import nulib.system.win32.lmshare;
public import nulib.system.win32.lmapibuf;
public import nulib.system.win32.lmremutl;
public import nulib.system.win32.lmrepl;
public import nulib.system.win32.lmuse;
public import nulib.system.win32.lmstats;
public import nulib.system.win32.lmwksta;
public import nulib.system.win32.lmserver;

version (Windows2000) {
} else {
    public import nulib.system.win32.lmmsg;
}

// FIXME: Everything in these next files seems to be deprecated!
import nulib.system.win32.lmaudit;
import nulib.system.win32.lmchdev; // can't find many docs for functions from this file.
import nulib.system.win32.lmconfig;
import nulib.system.win32.lmerrlog;
import nulib.system.win32.lmsvc;
import nulib.system.win32.lmsname; // in MinGW, this was publicly included by lm.lmsvc
