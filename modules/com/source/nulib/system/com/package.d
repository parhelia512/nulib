/**
    COM Interface

    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.com;

public import nulib.system.com.com;
public import nulib.system.com.hresult;
public import nulib.system.com.unk;
public import nulib.system.com.uuid;
public import nulib.system.com.objbase :
    CoInitialize,
    CoInitializeEx,
    CoUninitialize,
    CoGetCurrentProcess,
    CoFreeLibrary;