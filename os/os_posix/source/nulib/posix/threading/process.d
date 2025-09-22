/**
    POSIX Implementation for nulib.threading.internal.process

    Copyright:
        Copyright © 2025, Kitsunebi Games
        Copyright © 2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.posix.threading.process;
import nulib.threading.internal.process;
import numem;

class PosixProcess : NativeProcess {
private:
@nogc:
    uint pid_;

public:

    /**
        The ID of the process.
    */
    override @property uint pid() @safe => pid_;

    /**
        Constructs a new PosixProcess.
    */
    this(uint pid) nothrow {
        this.pid_ = pid;
    }

    /**
        Kills the given process.

        Returns:
            $(D true) if the operation succeeded,
            $(D false) otherwise.
    */
    override
    bool kill() @safe {
        return cast(bool).kill(pid_, SIGTERM);
    }
}

extern(C) export
NativeProcess _nu_process_get_self() @nogc @trusted nothrow {
    return nogc_new!PosixProcess(.getpid());
}

//
//          BINDINGS
//
extern(C):

enum SIGTERM = 15;
extern uint getpid() @trusted @nogc nothrow;
extern int kill(uint, int) @trusted @nogc nothrow;