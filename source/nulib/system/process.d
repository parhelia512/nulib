/**
    Process Handling

    Copyright: Copyright © 2023-2025, Kitsunebi Games
    Copyright: Copyright © 2023-2025, Inochi2D Project
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.system.process;
import nulib.object;
import nulib.system;
import numem;

/**
    A Process ID.
*/
alias PID = uint;

/**
    A Process
*/
class Process : NuObject {
@nogc:
private:
    Handle handle_;

public:

    // Constructor
    this(Handle handle_) { this.handle_ = handle_; }

    /**
        The currently running process
    */
    static @property Process current() {
        version(Windows) {

            return nogc_new!Process(GetCurrentProcess());
        } else version(Posix) {

            return nogc_new!Process(cast(Handle)getpid());
        } else {

            return nogc_new!Process(cast(Handle)0);
        }
    }


    /**
        Gets the process ID of this process.
    */
    @property uint pid() {
        version(Windows) {

            return GetProcessId(handle_);
        } else version(Posix) {

            return cast(uint)handle_;
        } else {

            return 0;
        }
    }

    /**
        Kills the process.
    */
    bool kill() {
        version(Windows) return TerminateProcess(handle_, 0);
        else version(Posix) return cast(bool).kill(cast(uint)handle_, SIGTERM);
        else return false;
    }
}

//
//          Unittests
//
@("Process ID")
unittest {
    assert(Process.current().pid);
}

//
//          Internal Bindings
//
private:

version(Windows) {
extern(Windows) @nogc nothrow:

    // Win32
    extern Handle GetCurrentProcess();
    extern uint GetProcessId(Handle);
    extern bool TerminateProcess(Handle, uint);
    
} else version(Posix) {
extern(C) @nogc nothrow:

    // POSIX
    enum SIGTERM = 15;
    extern uint getpid();
    extern int kill(uint, int);
}