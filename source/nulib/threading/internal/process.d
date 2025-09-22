/**
    Processes

    Copyright:
        Copyright © 2023-2025, Kitsunebi Games
        Copyright © 2023-2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.threading.internal.process;
import numem;

/**
    A process.
*/
abstract
class NativeProcess : NuObject {
public:
@nogc:

    /**
        The current running process.
    */
    static @property NativeProcess thisProcess() @safe => _nu_process_get_self();

    /**
        The ID of the process.
    */
    abstract @property uint pid() @safe;

    /**
        Kills the given process.

        Returns:
            $(D true) if the operation succeeded,
            $(D false) otherwise.
    */
    abstract bool kill() @safe;
}

//
//          FOR IMPLEMENTORS
//

private extern(C):
import core.attribute : weak;

version(linux) {

    // Needed on Linux because we can't specify load order.
    extern(C)
    extern NativeProcess _nu_process_get_self() @nogc @trusted nothrow;
} else {
    
    /*
        Optional helper which gets the current running process.
    */
    extern(C) export
    NativeProcess _nu_process_get_self() @weak @nogc @trusted nothrow {
        return null;
    }
}