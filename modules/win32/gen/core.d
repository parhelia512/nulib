/**
    Win32 Core Definitions

    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.win32.core;
public import numem;
public import nulib.uuid;

/**
    Windows calls them GUIDs.
*/
alias GUID = UUID;

/**
    Attribute which specifies which DLL the function came from.
*/
struct DllImport {

    /**
        Name of the DLL.
    */
    string name;
}