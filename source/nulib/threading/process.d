/**
    Processes

    Copyright:
        Copyright © 2023-2025, Kitsunebi Games
        Copyright © 2023-2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.threading.process;
import numem;

/**
    A process.
*/
abstract
class Process : NuObject {
public:
@nogc:

    /**
        The current running process.
    */
    static @property Process thisProcess() => _nu_process_get_self();

    /**
        The ID of the process.
    */
    abstract @property uint pid();

    /**
        Kills the given process.

        Returns:
            $(D true) if the operation succeeded,
            $(D false) otherwise.
    */
    abstract bool kill();
}

//
//          FOR IMPLEMENTORS
//

private extern(C):
import core.attribute : weak;

/*
    Optional helper which gets the current running process.
*/
Process _nu_process_get_self() @weak @nogc nothrow { return null; }