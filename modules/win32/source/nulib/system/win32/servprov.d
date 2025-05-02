/**
    Windows API header module

    Translated from MinGW API for MS-Windows 3.10

    License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
*/
module nulib.system.win32.servprov;
import nulib.system.win32.basetyps;
import nulib.system.win32.windef;
import nulib.system.win32.wtypes;
import nulib.system.com;

@Guid!("6d5140c1-7436-11ce-8034-00aa006009fa")
interface IServiceProvider : IUnknown {
    HRESULT QueryService(ref GUID guidService, ref IID riid, void** ppvObject);
}
