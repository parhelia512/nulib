/**
    POSIX Implementation for nulib.threading.internal.semaphore

    Copyright:
        Copyright © 2025, Kitsunebi Games
        Copyright © 2025, Inochi2D Project
    
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module nulib.posix.threading.semaphore;
import nulib.threading.internal.semaphore;
import nulib.posix.common;
import numem;

/**
    Native implementation of a semaphore.
*/
abstract
class PosixSemaphore : NativeSemaphore {
private:
@nogc:
    version(Darwin) semaphore_t sem_;
    else version(Posix) sem_t sem_;

public:

    /// Destructor
    ~this() {
        version(Darwin) {
            assert(
                semaphore_destroy(mach_task_self(), sem_) == KERN_SUCCESS, 
                "Failed to destroy semaphore!"
            );
        } else {
            assert(sem_destroy(&sem_) == 0, "Failed to destroy semaphore!");
        }
    }

    /**
        Constructs a new Posix Semaphore.
    */
    this(uint count) {
        version(Darwin) {
            assert(
                semaphore_create(mach_task_self(), &sem_, SYNC_POLICY_FIFO, count) == KERN_SUCCESS, 
                "Failed to create semaphore!"
            );
        } else {
            assert(sem_init(&sem_, 0, count) == 0, "Failed to create semaphore!");
        }
    }

    /**
        Signals the semaphore.

        Note:
            Control is not transferred to the waiter.
    */
    override
    void signal() {
        version(Darwin) {
            assert(semaphore_signal(sem_) == KERN_SUCCESS, "Failed to signal semaphore!");
        } else {
            assert(sem_post(&sem_) == 0, "Failed to signal semaphore!");
        }
    }

    /**
        Suspends the thread until the semaphore is signaled,
        or the timeout is reached.

        Params:
            timeout =   Timeout in miliseconds to block the 
                        calling thread before giving up.

        Returns:
            $(D true) if the semaphore was signaled in time,
            $(D false) otherwise.
    */
    override
    bool await(ulong timeout = 0) {
        version(Darwin) {
            if (timeout == 0) {
                while(true) {
                    auto rc = semaphore_wait(sem_);
                    if (!rc)
                        return true;
                    
                    if (rc == KERN_ABORTED && errno == EINTR)
                        continue;
                    
                    assert(0, "Unable to wait for semaphore!");
                    return false;
                }
            }

            mach_timespec_t t;
            t.tv_sec = timeout / 1000;
            t.tv_nsec = timeout % 1000;
            auto rc = semaphore_timedwait(sem_);
            while(true) {
                auto rc = semaphore_timedwait(sem_, t);
                if (!rc)
                    return true;

                if (rc == KERN_OPERATION_TIMED_OUT)
                    return false;
                
                if (rc == KERN_ABORTED && errno == EINTR)
                    continue;
                
                assert(0, "Unable to wait for semaphore!");
                return false;
            }
        } else {
            if (timeout == 0) {
                auto rc = sem_wait(&sem_);
                if (!rc)
                    return true;
                
                assert(errno == EINTR, "Unable to wait for semaphore!");
                return false;
            }

            timespec t;
            cast(void)clock_gettime(0, &t);
            t.secs += timeout / 1000;
            t.nsecs = (t.nsecs + timeout) % 1000;
            while(true) {
                if (!sem_timedwait(&sem_, &t))
                    return true;
                
                if (errno == ETIMEDOUT)
                    return false;
                    
                if (errno == EINTR)
                    continue;

                assert(0, "Unable to wait for semaphore!");
                return false;
            }
        }
    }

    /**
        Checks if the semaphore is signalled then
        awaits on it if is.

        Returns:
            $(D true) if the semaphore was signalled,
            $(D false) otherwise.
    */
    override
    bool tryAwait() {
        version(Darwin) {
            mach_timespec_t t;
            t.tv_sec = 0;
            t.tv_nsec = 0;
            while(true) {
                auto rc = semaphore_timedwait(sem_, t);
                if (!rc)
                    return true;

                if (rc == KERN_OPERATION_TIMED_OUT)
                    return false;
                
                if (rc == KERN_ABORTED && __error() == EINTR)
                    continue;
                
                assert(0, "Unable to wait for semaphore!");
                return false;
            }
        } else {
            while(true) {
                if (!sem_trywait(&sem_))
                    return true;
                
                if (errno == EAGAIN)
                    return false;
                        
                if (errno == EINTR)
                    continue;

                assert(0, "Unable to wait for semaphore!");
                return false;
            }
        }
    }
}


extern(C) export
NativeSemaphore _nu_semaphore_new(uint count) @trusted @nogc nothrow {
    return null;
}

//
//          BINDINGS
//
extern(C) @nogc nothrow:

version(Darwin) {
    alias semaphore_t = uint;
    alias task_t = uint;

    alias kern_return_t = int;
    enum kern_return_t KERN_SUCCESS = 0;
    enum SYNC_POLICY_FIFO           = 0x0;
    enum KERN_ABORTED               = 14; // Aborted (Kernel)
    enum KERN_OPERATION_TIMED_OUT   = 49; // Timed Out (Kernel)

    alias clock_res_t = int;
    struct mach_timespec_t {
        uint        tv_sec;
        clock_res_t tv_nsec;
    }

    extern task_t mach_task_self();
    extern kern_return_t semaphore_create(task_t, semaphore_t*, int, int);
    extern kern_return_t semaphore_destroy(task_t, semaphore_t);
    extern kern_return_t semaphore_signal(semaphore_t);
    extern kern_return_t semaphore_wait(semaphore_t);
    extern kern_return_t semaphore_timedwait(semaphore_t, mach_timespec_t);

} else version(Posix) {

    struct sem_t {
        void[32] internal_;
    }

    struct timespec {
        long secs;
        long nsecs;
    }

    enum SEM_FAILED = cast(sem_t*) null;

    extern int sem_destroy(sem_t*);
    extern int sem_init(sem_t*, int, uint);
    extern int sem_post(sem_t*);
    extern int sem_trywait(sem_t*);
    extern int sem_timedwait(sem_t*, const scope timespec*);
    extern int sem_wait(sem_t*);
    extern int clock_gettime(int, const scope timespec*);
}