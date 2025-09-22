/**
    Processes

    Copyright:
        Copyright © 2023-2025, Kitsunebi Games
        Copyright © 2023-2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.threading.process;
import nulib.threading.internal.process;
import numem;

/**
    A process.
*/
class Process : NuObject {
private:
@nogc:
    NativeProcess process_;

public:

    /**
        The current running process.
    */
    static @property Process thisProcess() @safe => nogc_new!Process(NativeProcess.thisProcess());

    /**
        The ID of the process.
    */
    @property uint pid() @safe => process_.pid;

    // Destructor
    ~this() {
        nogc_delete(process_);
    }

    /**
        Constructs a new high level process from its
        native equiavlent.

        Params:
            process = The native process handle.
    */
    this(NativeProcess process) {
        this.process_ = process;
    }

    /**
        Kills the given process.

        Returns:
            $(D true) if the operation succeeded,
            $(D false) otherwise.
    */
    bool kill() @safe {
        return process_.kill();
    }
}

@("thisProcess")
unittest {
    assert(Process.thisProcess.pid != 0);
}