/**
    D header file for POSIX.

    Copyright: Copyright Sean Kelly 2005 - 2009.
    License:   $(HTTP www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
    Authors:   Sean Kelly, Alex Rønne Petersen
    Standards: The Open Group Base Specifications Issue 6, IEEE Std 1003.1, 2004 Edition
*/
module nulib.posix.pthread;
import nulib.posix.ccfg;

version (OSX)
    version = Darwin;
else version (iOS)
    version = Darwin;
else version (TVOS)
    version = Darwin;
else version (WatchOS)
    version = Darwin;

extern(C) nothrow:

//
// Thread (THR)
//
/*
pthread_attr_t
pthread_cond_t
pthread_condattr_t
pthread_key_t
pthread_mutex_t
pthread_mutexattr_t
pthread_once_t
pthread_rwlock_t
pthread_rwlockattr_t
pthread_t
*/

version (CRuntime_Glibc) {
    version (X86) {
        enum __SIZEOF_PTHREAD_ATTR_T = 36;
        enum __SIZEOF_PTHREAD_MUTEX_T = 24;
        enum __SIZEOF_PTHREAD_MUTEXATTR_T = 4;
        enum __SIZEOF_PTHREAD_COND_T = 48;
        enum __SIZEOF_PTHREAD_CONDATTR_T = 4;
        enum __SIZEOF_PTHREAD_RWLOCK_T = 32;
        enum __SIZEOF_PTHREAD_RWLOCKATTR_T = 8;
        enum __SIZEOF_PTHREAD_BARRIER_T = 20;
        enum __SIZEOF_PTHREAD_BARRIERATTR_T = 4;
    } else version (X86_64) {
        static if (size_t.sizeof == 8) {
            enum __SIZEOF_PTHREAD_ATTR_T = 56;
            enum __SIZEOF_PTHREAD_MUTEX_T = 40;
            enum __SIZEOF_PTHREAD_MUTEXATTR_T = 4;
            enum __SIZEOF_PTHREAD_COND_T = 48;
            enum __SIZEOF_PTHREAD_CONDATTR_T = 4;
            enum __SIZEOF_PTHREAD_RWLOCK_T = 56;
            enum __SIZEOF_PTHREAD_RWLOCKATTR_T = 8;
            enum __SIZEOF_PTHREAD_BARRIER_T = 32;
            enum __SIZEOF_PTHREAD_BARRIERATTR_T = 4;
        } else {
            enum __SIZEOF_PTHREAD_ATTR_T = 32;
            enum __SIZEOF_PTHREAD_MUTEX_T = 32;
            enum __SIZEOF_PTHREAD_MUTEXATTR_T = 4;
            enum __SIZEOF_PTHREAD_COND_T = 48;
            enum __SIZEOF_PTHREAD_CONDATTR_T = 4;
            enum __SIZEOF_PTHREAD_RWLOCK_T = 44;
            enum __SIZEOF_PTHREAD_RWLOCKATTR_T = 8;
            enum __SIZEOF_PTHREAD_BARRIER_T = 20;
            enum __SIZEOF_PTHREAD_BARRIERATTR_T = 4;
        }
    } else version (AArch64) {
        enum __SIZEOF_PTHREAD_ATTR_T = 64;
        enum __SIZEOF_PTHREAD_MUTEX_T = 48;
        enum __SIZEOF_PTHREAD_MUTEXATTR_T = 8;
        enum __SIZEOF_PTHREAD_COND_T = 48;
        enum __SIZEOF_PTHREAD_CONDATTR_T = 8;
        enum __SIZEOF_PTHREAD_RWLOCK_T = 56;
        enum __SIZEOF_PTHREAD_RWLOCKATTR_T = 8;
        enum __SIZEOF_PTHREAD_BARRIER_T = 32;
        enum __SIZEOF_PTHREAD_BARRIERATTR_T = 8;
    } else version (ARM) {
        enum __SIZEOF_PTHREAD_ATTR_T = 36;
        enum __SIZEOF_PTHREAD_MUTEX_T = 24;
        enum __SIZEOF_PTHREAD_MUTEXATTR_T = 4;
        enum __SIZEOF_PTHREAD_COND_T = 48;
        enum __SIZEOF_PTHREAD_CONDATTR_T = 4;
        enum __SIZEOF_PTHREAD_RWLOCK_T = 32;
        enum __SIZEOF_PTHREAD_RWLOCKATTR_T = 8;
        enum __SIZEOF_PTHREAD_BARRIER_T = 20;
        enum __SIZEOF_PTHREAD_BARRIERATTR_T = 4;
    } else version (HPPA) {
        enum __SIZEOF_PTHREAD_ATTR_T = 36;
        enum __SIZEOF_PTHREAD_MUTEX_T = 48;
        enum __SIZEOF_PTHREAD_MUTEXATTR_T = 4;
        enum __SIZEOF_PTHREAD_COND_T = 48;
        enum __SIZEOF_PTHREAD_CONDATTR_T = 4;
        enum __SIZEOF_PTHREAD_RWLOCK_T = 64;
        enum __SIZEOF_PTHREAD_RWLOCKATTR_T = 8;
        enum __SIZEOF_PTHREAD_BARRIER_T = 48;
        enum __SIZEOF_PTHREAD_BARRIERATTR_T = 4;
    } else version (IA64) {
        enum __SIZEOF_PTHREAD_ATTR_T = 56;
        enum __SIZEOF_PTHREAD_MUTEX_T = 40;
        enum __SIZEOF_PTHREAD_MUTEXATTR_T = 4;
        enum __SIZEOF_PTHREAD_COND_T = 48;
        enum __SIZEOF_PTHREAD_CONDATTR_T = 4;
        enum __SIZEOF_PTHREAD_RWLOCK_T = 56;
        enum __SIZEOF_PTHREAD_RWLOCKATTR_T = 8;
        enum __SIZEOF_PTHREAD_BARRIER_T = 32;
        enum __SIZEOF_PTHREAD_BARRIERATTR_T = 4;
    } else version (MIPS32) {
        enum __SIZEOF_PTHREAD_ATTR_T = 36;
        enum __SIZEOF_PTHREAD_MUTEX_T = 24;
        enum __SIZEOF_PTHREAD_MUTEXATTR_T = 4;
        enum __SIZEOF_PTHREAD_COND_T = 48;
        enum __SIZEOF_PTHREAD_CONDATTR_T = 4;
        enum __SIZEOF_PTHREAD_RWLOCK_T = 32;
        enum __SIZEOF_PTHREAD_RWLOCKATTR_T = 8;
        enum __SIZEOF_PTHREAD_BARRIER_T = 20;
        enum __SIZEOF_PTHREAD_BARRIERATTR_T = 4;
    } else version (MIPS64) {
        enum __SIZEOF_PTHREAD_ATTR_T = 56;
        enum __SIZEOF_PTHREAD_MUTEX_T = 40;
        enum __SIZEOF_PTHREAD_MUTEXATTR_T = 4;
        enum __SIZEOF_PTHREAD_COND_T = 48;
        enum __SIZEOF_PTHREAD_CONDATTR_T = 4;
        enum __SIZEOF_PTHREAD_RWLOCK_T = 56;
        enum __SIZEOF_PTHREAD_RWLOCKATTR_T = 8;
        enum __SIZEOF_PTHREAD_BARRIER_T = 32;
        enum __SIZEOF_PTHREAD_BARRIERATTR_T = 4;
    } else version (PPC) {
        enum __SIZEOF_PTHREAD_ATTR_T = 36;
        enum __SIZEOF_PTHREAD_MUTEX_T = 24;
        enum __SIZEOF_PTHREAD_MUTEXATTR_T = 4;
        enum __SIZEOF_PTHREAD_COND_T = 48;
        enum __SIZEOF_PTHREAD_CONDATTR_T = 4;
        enum __SIZEOF_PTHREAD_RWLOCK_T = 32;
        enum __SIZEOF_PTHREAD_RWLOCKATTR_T = 8;
        enum __SIZEOF_PTHREAD_BARRIER_T = 20;
        enum __SIZEOF_PTHREAD_BARRIERATTR_T = 4;
    } else version (PPC64) {
        enum __SIZEOF_PTHREAD_ATTR_T = 56;
        enum __SIZEOF_PTHREAD_MUTEX_T = 40;
        enum __SIZEOF_PTHREAD_MUTEXATTR_T = 4;
        enum __SIZEOF_PTHREAD_COND_T = 48;
        enum __SIZEOF_PTHREAD_CONDATTR_T = 4;
        enum __SIZEOF_PTHREAD_RWLOCK_T = 56;
        enum __SIZEOF_PTHREAD_RWLOCKATTR_T = 8;
        enum __SIZEOF_PTHREAD_BARRIER_T = 32;
        enum __SIZEOF_PTHREAD_BARRIERATTR_T = 4;
    } else version (RISCV32) {
        enum __SIZEOF_PTHREAD_ATTR_T = 36;
        enum __SIZEOF_PTHREAD_MUTEX_T = 24;
        enum __SIZEOF_PTHREAD_MUTEXATTR_T = 4;
        enum __SIZEOF_PTHREAD_COND_T = 48;
        enum __SIZEOF_PTHREAD_CONDATTR_T = 4;
        enum __SIZEOF_PTHREAD_RWLOCK_T = 32;
        enum __SIZEOF_PTHREAD_RWLOCKATTR_T = 8;
        enum __SIZEOF_PTHREAD_BARRIER_T = 20;
        enum __SIZEOF_PTHREAD_BARRIERATTR_T = 4;
    } else version (RISCV64) {
        enum __SIZEOF_PTHREAD_ATTR_T = 56;
        enum __SIZEOF_PTHREAD_MUTEX_T = 40;
        enum __SIZEOF_PTHREAD_MUTEXATTR_T = 4;
        enum __SIZEOF_PTHREAD_COND_T = 48;
        enum __SIZEOF_PTHREAD_CONDATTR_T = 4;
        enum __SIZEOF_PTHREAD_RWLOCK_T = 56;
        enum __SIZEOF_PTHREAD_RWLOCKATTR_T = 8;
        enum __SIZEOF_PTHREAD_BARRIER_T = 32;
        enum __SIZEOF_PTHREAD_BARRIERATTR_T = 4;
    } else version (SPARC) {
        enum __SIZEOF_PTHREAD_ATTR_T = 36;
        enum __SIZEOF_PTHREAD_MUTEX_T = 24;
        enum __SIZEOF_PTHREAD_MUTEXATTR_T = 4;
        enum __SIZEOF_PTHREAD_COND_T = 48;
        enum __SIZEOF_PTHREAD_CONDATTR_T = 4;
        enum __SIZEOF_PTHREAD_RWLOCK_T = 32;
        enum __SIZEOF_PTHREAD_RWLOCKATTR_T = 8;
        enum __SIZEOF_PTHREAD_BARRIER_T = 20;
        enum __SIZEOF_PTHREAD_BARRIERATTR_T = 4;
    } else version (SPARC64) {
        enum __SIZEOF_PTHREAD_ATTR_T = 56;
        enum __SIZEOF_PTHREAD_MUTEX_T = 40;
        enum __SIZEOF_PTHREAD_MUTEXATTR_T = 4;
        enum __SIZEOF_PTHREAD_COND_T = 48;
        enum __SIZEOF_PTHREAD_CONDATTR_T = 4;
        enum __SIZEOF_PTHREAD_RWLOCK_T = 56;
        enum __SIZEOF_PTHREAD_RWLOCKATTR_T = 8;
        enum __SIZEOF_PTHREAD_BARRIER_T = 32;
        enum __SIZEOF_PTHREAD_BARRIERATTR_T = 4;
    } else version (S390) {
        enum __SIZEOF_PTHREAD_ATTR_T = 36;
        enum __SIZEOF_PTHREAD_MUTEX_T = 24;
        enum __SIZEOF_PTHREAD_MUTEXATTR_T = 4;
        enum __SIZEOF_PTHREAD_COND_T = 48;
        enum __SIZEOF_PTHREAD_CONDATTR_T = 4;
        enum __SIZEOF_PTHREAD_RWLOCK_T = 32;
        enum __SIZEOF_PTHREAD_RWLOCKATTR_T = 8;
        enum __SIZEOF_PTHREAD_BARRIER_T = 20;
        enum __SIZEOF_PTHREAD_BARRIERATTR_T = 4;
    } else version (SystemZ) {
        enum __SIZEOF_PTHREAD_ATTR_T = 56;
        enum __SIZEOF_PTHREAD_MUTEX_T = 40;
        enum __SIZEOF_PTHREAD_MUTEXATTR_T = 4;
        enum __SIZEOF_PTHREAD_COND_T = 48;
        enum __SIZEOF_PTHREAD_CONDATTR_T = 4;
        enum __SIZEOF_PTHREAD_RWLOCK_T = 56;
        enum __SIZEOF_PTHREAD_RWLOCKATTR_T = 8;
        enum __SIZEOF_PTHREAD_BARRIER_T = 32;
        enum __SIZEOF_PTHREAD_BARRIERATTR_T = 4;
    } else version (LoongArch64) {
        enum __SIZEOF_PTHREAD_ATTR_T = 56;
        enum __SIZEOF_PTHREAD_MUTEX_T = 40;
        enum __SIZEOF_PTHREAD_MUTEXATTR_T = 4;
        enum __SIZEOF_PTHREAD_COND_T = 48;
        enum __SIZEOF_PTHREAD_CONDATTR_T = 4;
        enum __SIZEOF_PTHREAD_RWLOCK_T = 56;
        enum __SIZEOF_PTHREAD_RWLOCKATTR_T = 8;
        enum __SIZEOF_PTHREAD_BARRIER_T = 32;
        enum __SIZEOF_PTHREAD_BARRIERATTR_T = 4;
    } else {
        static assert(false, "Unsupported platform");
    }

    union pthread_attr_t {
        byte[__SIZEOF_PTHREAD_ATTR_T] __size;
        c_long __align;
    }

    private alias __atomic_lock_t = int;

    private struct _pthread_fastlock {
        c_long __status;
        __atomic_lock_t __spinlock;
    }

    private alias _pthread_descr = void*;

    union pthread_cond_t {
        byte[__SIZEOF_PTHREAD_COND_T] __size;
        long __align;
    }

    union pthread_condattr_t {
        byte[__SIZEOF_PTHREAD_CONDATTR_T] __size;
        int __align;
    }

    alias pthread_key_t = uint;

    union pthread_mutex_t {
        byte[__SIZEOF_PTHREAD_MUTEX_T] __size;
        c_long __align;
    }

    union pthread_mutexattr_t {
        byte[__SIZEOF_PTHREAD_MUTEXATTR_T] __size;
        int __align;
    }

    alias pthread_once_t = int;

    struct pthread_rwlock_t {
        byte[__SIZEOF_PTHREAD_RWLOCK_T] __size;
        c_long __align;
    }

    struct pthread_rwlockattr_t {
        byte[__SIZEOF_PTHREAD_RWLOCKATTR_T] __size;
        c_long __align;
    }

    alias pthread_t = c_ulong;
} else version (CRuntime_Musl) {
    version (D_LP64) {
        union pthread_attr_t {
            int[14] __i;
            ulong[7] __s;
        }

        union pthread_cond_t {
            int[12] __i;
            void*[6] __p;
        }

        union pthread_mutex_t {
            int[10] __i;
            void*[5] __p;
        }

        union pthread_rwlock_t {
            int[14] __i;
            void*[7] __p;
        }
    } else {
        union pthread_attr_t {
            int[9] __i;
            uint[9] __s;
        }

        union pthread_cond_t {
            int[12] __i;
            void*[12] __p;
        }

        union pthread_mutex_t {
            int[6] __i;
            void*[6] __p;
        }

        union pthread_rwlock_t {
            int[8] __i;
            void*[8] __p;
        }
    }

    struct pthread_rwlockattr_t {
        uint[2] __attr;
    }

    alias pthread_key_t = uint;

    struct pthread_condattr_t {
        uint __attr;
    }

    struct pthread_mutexattr_t {
        uint __attr;
    }

    alias pthread_once_t = int;

    alias pthread_t = c_ulong;
} else version (Darwin) {
    version (D_LP64) {
        enum __PTHREAD_SIZE__ = 8176;
        enum __PTHREAD_ATTR_SIZE__ = 56;
        enum __PTHREAD_MUTEXATTR_SIZE__ = 8;
        enum __PTHREAD_MUTEX_SIZE__ = 56;
        enum __PTHREAD_CONDATTR_SIZE__ = 8;
        enum __PTHREAD_COND_SIZE__ = 40;
        enum __PTHREAD_ONCE_SIZE__ = 8;
        enum __PTHREAD_RWLOCK_SIZE__ = 192;
        enum __PTHREAD_RWLOCKATTR_SIZE__ = 16;
    } else {
        enum __PTHREAD_SIZE__ = 4088;
        enum __PTHREAD_ATTR_SIZE__ = 36;
        enum __PTHREAD_MUTEXATTR_SIZE__ = 8;
        enum __PTHREAD_MUTEX_SIZE__ = 40;
        enum __PTHREAD_CONDATTR_SIZE__ = 4;
        enum __PTHREAD_COND_SIZE__ = 24;
        enum __PTHREAD_ONCE_SIZE__ = 4;
        enum __PTHREAD_RWLOCK_SIZE__ = 124;
        enum __PTHREAD_RWLOCKATTR_SIZE__ = 12;
    }

    struct pthread_handler_rec {
        void function(void*) __routine;
        void* __arg;
        pthread_handler_rec* __next;
    }

    struct pthread_attr_t {
        c_long __sig;
        byte[__PTHREAD_ATTR_SIZE__] __opaque;
    }

    struct pthread_cond_t {
        c_long __sig;
        byte[__PTHREAD_COND_SIZE__] __opaque;
    }

    struct pthread_condattr_t {
        c_long __sig;
        byte[__PTHREAD_CONDATTR_SIZE__] __opaque;
    }

    alias pthread_key_t = c_ulong;

    struct pthread_mutex_t {
        c_long __sig;
        byte[__PTHREAD_MUTEX_SIZE__] __opaque;
    }

    struct pthread_mutexattr_t {
        c_long __sig;
        byte[__PTHREAD_MUTEXATTR_SIZE__] __opaque;
    }

    struct pthread_once_t {
        c_long __sig;
        byte[__PTHREAD_ONCE_SIZE__] __opaque;
    }

    struct pthread_rwlock_t {
        c_long __sig;
        byte[__PTHREAD_RWLOCK_SIZE__] __opaque;
    }

    struct pthread_rwlockattr_t {
        c_long __sig;
        byte[__PTHREAD_RWLOCKATTR_SIZE__] __opaque;
    }

    private struct _opaque_pthread_t {
        c_long __sig;
        pthread_handler_rec* __cleanup_stack;
        byte[__PTHREAD_SIZE__] __opaque;
    }

    alias pthread_t = _opaque_pthread_t*;
} else version (FreeBSD) {
    alias lwpid_t = int; // non-standard

    alias pthread_attr_t = void*;
    alias pthread_cond_t = void*;
    alias pthread_condattr_t = void*;
    alias pthread_key_t = void*;
    alias pthread_mutex_t = void*;
    alias pthread_mutexattr_t = void*;
    alias pthread_once_t = void*;
    alias pthread_rwlock_t = void*;
    alias pthread_rwlockattr_t = void*;
    alias pthread_t = void*;
} else version (NetBSD) {
    struct pthread_queue_t {
        void* ptqh_first;
        void** ptqh_last;
    }

    alias lwpid_t = int;
    alias pthread_spin_t = ubyte;
    struct pthread_attr_t {
        uint pta_magic;
        int pta_flags;
        void* pta_private;
    }

    struct pthread_spinlock_t {
        uint pts_magic;
        pthread_spin_t pts_spin;
        int pts_flags;
    }

    struct pthread_cond_t {
        uint ptc_magic;
        pthread_spin_t ptc_lock;
        pthread_queue_t ptc_waiters;
        pthread_mutex_t* ptc_mutex;
        void* ptc_private;
    }

    struct pthread_condattr_t {
        uint ptca_magic;
        void* ptca_private;
    }

    struct pthread_mutex_t {
        uint ptm_magic;
        pthread_spin_t ptm_errorcheck;
        ubyte[3] ptm_pad1;
        pthread_spin_t ptm_interlock;
        ubyte[3] ptm_pad2;
        pthread_t ptm_owner;
        void* ptm_waiters;
        uint ptm_recursed;
        void* ptm_spare2;
    }

    struct pthread_mutexattr_t {
        uint ptma_magic;
        void* ptma_private;
    }

    struct pthread_once_t {
        pthread_mutex_t pto_mutex;
        int pto_done;
    }

    struct pthread_rwlock_t {
        uint ptr_magic;

        pthread_spin_t ptr_interlock;

        pthread_queue_t ptr_rblocked;
        pthread_queue_t ptr_wblocked;
        uint ptr_nreaders;
        pthread_t ptr_owner;
        void* ptr_private;
    }

    struct pthread_rwlockattr_t {
        uint ptra_magic;
        void* ptra_private;
    }

    alias pthread_key_t = uint;
    alias pthread_t = void*;
} else version (OpenBSD) {
    alias pthread_attr_t = void*;
    alias pthread_cond_t = void*;
    alias pthread_condattr_t = void*;
    alias int pthread_key_t;
    alias pthread_mutex_t = void*;
    alias pthread_mutexattr_t = void*;

    private struct pthread_once {
        int state;
        pthread_mutex_t mutex;
    }

    alias pthread_once_t = pthread_once;

    alias pthread_rwlock_t = void*;
    alias pthread_rwlockattr_t = void*;
    alias pthread_t = void*;
} else version (DragonFlyBSD) {
    alias lwpid_t = int;

    alias pthread_attr_t = void*;
    alias pthread_cond_t = void*;
    alias pthread_condattr_t = void*;
    alias pthread_key_t = void*;
    alias pthread_mutex_t = void*;
    alias pthread_mutexattr_t = void*;

    private struct pthread_once {
        int state;
        pthread_mutex_t mutex;
    }

    alias pthread_once_t = pthread_once;

    alias pthread_rwlock_t = void*;
    alias pthread_rwlockattr_t = void*;
    alias pthread_t = void*;
} else version (Solaris) {
    alias pthread_t = uint;

    struct pthread_attr_t {
        void* __pthread_attrp;
    }

    struct pthread_cond_t {
        struct ___pthread_cond_flags {
            ubyte[4] __pthread_cond_flags;
            ushort __pthread_cond_type;
            ushort __pthread_cond_magic;
        }

        ___pthread_cond_flags __pthread_cond_flags;
        ulong __pthread_cond_data;
    }

    struct pthread_condattr_t {
        void* __pthread_condattrp;
    }

    struct pthread_rwlock_t {
        int __pthread_rwlock_readers;
        ushort __pthread_rwlock_type;
        ushort __pthread_rwlock_magic;
        pthread_mutex_t __pthread_rwlock_mutex;
        pthread_cond_t __pthread_rwlock_readercv;
        pthread_cond_t __pthread_rwlock_writercv;
    }

    struct pthread_rwlockattr_t {
        void* __pthread_rwlockattrp;
    }

    struct pthread_mutex_t {
        struct ___pthread_mutex_flags {
            ushort __pthread_mutex_flag1;
            ubyte __pthread_mutex_flag2;
            ubyte __pthread_mutex_ceiling;
            ushort __pthread_mutex_type;
            ushort __pthread_mutex_magic;
        }

        ___pthread_mutex_flags __pthread_mutex_flags;

        union ___pthread_mutex_lock {
            struct ___pthread_mutex_lock64 {
                ubyte[8] __pthread_mutex_pad;
            }

            ___pthread_mutex_lock64 __pthread_mutex_lock64;

            struct ___pthread_mutex_lock32 {
                uint __pthread_ownerpid;
                uint __pthread_lockword;
            }

            ___pthread_mutex_lock32 __pthread_mutex_lock32;
            ulong __pthread_mutex_owner64;
        }

        ___pthread_mutex_lock __pthread_mutex_lock;
        ulong __pthread_mutex_data;
    }

    struct pthread_mutexattr_t {
        void* __pthread_mutexattrp;
    }

    struct pthread_once_t {
        ulong[4] __pthread_once_pad;
    }

    alias pthread_key_t = uint;
} else version (CRuntime_Bionic) {
    struct pthread_attr_t {
        uint flags;
        void* stack_base;
        size_t stack_size;
        size_t guard_size;
        int sched_policy;
        int sched_priority;
        version (D_LP64) char[16] __reserved = 0;
    }

    struct pthread_cond_t {
        version (D_LP64)
            int[12] __private;
        else
            int[1] __private;
    }

    alias pthread_condattr_t = c_long;
    alias int pthread_key_t;

    struct pthread_mutex_t {
        version (D_LP64)
            int[10] __private;
        else
            int[1] __private;
    }

    alias pthread_mutexattr_t = c_long;
    alias int pthread_once_t;

    struct pthread_rwlock_t {
        version (D_LP64)
            int[14] __private;
        else
            int[10] __private;
    }

    alias pthread_rwlockattr_t = c_long;
    alias pthread_t = c_long;
} else version (CRuntime_UClibc) {
    version (X86_64) {
        enum __SIZEOF_PTHREAD_ATTR_T = 56;
        enum __SIZEOF_PTHREAD_MUTEX_T = 40;
        enum __SIZEOF_PTHREAD_MUTEXATTR_T = 4;
        enum __SIZEOF_PTHREAD_COND_T = 48;
        enum __SIZEOF_PTHREAD_CONDATTR_T = 4;
        enum __SIZEOF_PTHREAD_RWLOCK_T = 56;
        enum __SIZEOF_PTHREAD_RWLOCKATTR_T = 8;
        enum __SIZEOF_PTHREAD_BARRIER_T = 32;
        enum __SIZEOF_PTHREAD_BARRIERATTR_T = 4;
    } else version (MIPS32) {
        enum __SIZEOF_PTHREAD_ATTR_T = 36;
        enum __SIZEOF_PTHREAD_MUTEX_T = 24;
        enum __SIZEOF_PTHREAD_MUTEXATTR_T = 4;
        enum __SIZEOF_PTHREAD_COND_T = 48;
        enum __SIZEOF_PTHREAD_CONDATTR_T = 4;
        enum __SIZEOF_PTHREAD_RWLOCK_T = 32;
        enum __SIZEOF_PTHREAD_RWLOCKATTR_T = 8;
        enum __SIZEOF_PTHREAD_BARRIER_T = 20;
        enum __SIZEOF_PTHREAD_BARRIERATTR_T = 4;
    } else version (MIPS64) {
        enum __SIZEOF_PTHREAD_ATTR_T = 56;
        enum __SIZEOF_PTHREAD_MUTEX_T = 40;
        enum __SIZEOF_PTHREAD_MUTEXATTR_T = 4;
        enum __SIZEOF_PTHREAD_COND_T = 48;
        enum __SIZEOF_PTHREAD_CONDATTR_T = 4;
        enum __SIZEOF_PTHREAD_RWLOCK_T = 56;
        enum __SIZEOF_PTHREAD_RWLOCKATTR_T = 8;
        enum __SIZEOF_PTHREAD_BARRIER_T = 32;
        enum __SIZEOF_PTHREAD_BARRIERATTR_T = 4;
    } else version (ARM) {
        enum __SIZEOF_PTHREAD_ATTR_T = 36;
        enum __SIZEOF_PTHREAD_MUTEX_T = 24;
        enum __SIZEOF_PTHREAD_MUTEXATTR_T = 4;
        enum __SIZEOF_PTHREAD_COND_T = 48;
        enum __SIZEOF_PTHREAD_COND_COMPAT_T = 12;
        enum __SIZEOF_PTHREAD_CONDATTR_T = 4;
        enum __SIZEOF_PTHREAD_RWLOCK_T = 32;
        enum __SIZEOF_PTHREAD_RWLOCKATTR_T = 8;
        enum __SIZEOF_PTHREAD_BARRIER_T = 20;
        enum __SIZEOF_PTHREAD_BARRIERATTR_T = 4;
    } else {
        static assert(false, "Architecture unsupported");
    }

    union pthread_attr_t {
        byte[__SIZEOF_PTHREAD_ATTR_T] __size;
        c_long __align;
    }

    union pthread_cond_t {
        struct data {
            int __lock;
            uint __futex;
            ulong __total_seq;
            ulong __wakeup_seq;
            ulong __woken_seq;
            void* __mutex;
            uint __nwaiters;
            uint __broadcast_seq;
        }

        data __data;
        byte[__SIZEOF_PTHREAD_COND_T] __size;
        long __align;
    }

    union pthread_condattr_t {
        byte[__SIZEOF_PTHREAD_CONDATTR_T] __size;
        c_long __align;
    }

    alias pthread_key_t = uint;

    struct __pthread_slist_t {
        __pthread_slist_t* __next;
    }

    union pthread_mutex_t {
        struct __pthread_mutex_s {
            int __lock;
            uint __count;
            int __owner;
            /* KIND must stay at this position in the structure to maintain
           binary compatibility.  */
            int __kind;
            uint __nusers;
            union {
                int __spins;
                __pthread_slist_t __list;
            }
        }

        __pthread_mutex_s __data;
        byte[__SIZEOF_PTHREAD_MUTEX_T] __size;
        c_long __align;
    }

    union pthread_mutexattr_t {
        byte[__SIZEOF_PTHREAD_MUTEXATTR_T] __size;
        c_long __align;
    }

    alias pthread_once_t = int;

    struct pthread_rwlock_t {
        struct data {
            int __lock;
            uint __nr_readers;
            uint __readers_wakeup;
            uint __writer_wakeup;
            uint __nr_readers_queued;
            uint __nr_writers_queued;
            version (BigEndian) {
                ubyte __pad1;
                ubyte __pad2;
                ubyte __shared;
                ubyte __flags;
            } else {
                ubyte __flags;
                ubyte __shared;
                ubyte __pad1;
                ubyte __pad2;
            }
            int __writer;
        }

        data __data;
        byte[__SIZEOF_PTHREAD_RWLOCK_T] __size;
        c_long __align;
    }

    struct pthread_rwlockattr_t {
        byte[__SIZEOF_PTHREAD_RWLOCKATTR_T] __size;
        c_long __align;
    }

    alias pthread_t = c_ulong;
} else {
    static assert(false, "Unsupported platform");
}

//
// Barrier (BAR)
//
/*
pthread_barrier_t
pthread_barrierattr_t
*/

version (CRuntime_Glibc) {
    struct pthread_barrier_t {
        byte[__SIZEOF_PTHREAD_BARRIER_T] __size;
        c_long __align;
    }

    struct pthread_barrierattr_t {
        byte[__SIZEOF_PTHREAD_BARRIERATTR_T] __size;
        int __align;
    }
} else version (FreeBSD) {
    alias pthread_barrier_t = void*;
    alias pthread_barrierattr_t = void*;
} else version (NetBSD) {
    alias pthread_barrier_t = void*;
    alias pthread_barrierattr_t = void*;
} else version (OpenBSD) {
    alias pthread_barrier_t = void*;
    alias pthread_barrierattr_t = void*;
} else version (DragonFlyBSD) {
    alias pthread_barrier_t = void*;
    alias pthread_barrierattr_t = void*;
} else version (Darwin) {
} else version (Solaris) {
    struct pthread_barrier_t {
        uint __pthread_barrier_count;
        uint __pthread_barrier_current;
        ulong __pthread_barrier_cycle;
        ulong __pthread_barrier_reserved;
        pthread_mutex_t __pthread_barrier_lock;
        pthread_cond_t __pthread_barrier_cond;
    }

    struct pthread_barrierattr_t {
        void* __pthread_barrierattrp;
    }
} else version (CRuntime_Bionic) {
} else version (CRuntime_Musl) {
    version (D_LP64) {
        union pthread_barrier_t {
            int[8] __i;
            void*[4] __p;
        }
    } else {
        union pthread_barrier_t {
            int[5] __i;
            void*[5] __p;
        }
    }

    struct pthread_barrierattr_t {
        uint __attr;
    }
} else version (CRuntime_UClibc) {
    struct pthread_barrier_t {
        byte[__SIZEOF_PTHREAD_BARRIER_T] __size;
        c_long __align;
    }

    struct pthread_barrierattr_t {
        byte[__SIZEOF_PTHREAD_BARRIERATTR_T] __size;
        int __align;
    }
} else {
    static assert(false, "Unsupported platform");
}

//
// Spin (SPN)
//
/*
pthread_spinlock_t
*/

version (CRuntime_Glibc) {
    alias pthread_spinlock_t = int; // volatile
} else version (FreeBSD) {
    alias pthread_spinlock_t = void*;
} else version (NetBSD) {
    //already defined
} else version (OpenBSD) {
    alias pthread_spinlock_t = void*;
} else version (DragonFlyBSD) {
    alias pthread_spinlock_t = void*;
} else version (Solaris) {
    alias pthread_spinlock_t = pthread_mutex_t;
} else version (CRuntime_UClibc) {
    alias pthread_spinlock_t = int; // volatile
} else version (CRuntime_Musl) {
    alias pthread_spinlock_t = int;
}

//
// Required
//
/*
PTHREAD_CANCEL_ASYNCHRONOUS
PTHREAD_CANCEL_ENABLE
PTHREAD_CANCEL_DEFERRED
PTHREAD_CANCEL_DISABLE
PTHREAD_CANCELED
PTHREAD_COND_INITIALIZER
PTHREAD_CREATE_DETACHED
PTHREAD_CREATE_JOINABLE
PTHREAD_EXPLICIT_SCHED
PTHREAD_INHERIT_SCHED
PTHREAD_MUTEX_INITIALIZER
PTHREAD_ONCE_INIT
PTHREAD_PROCESS_SHARED
PTHREAD_PROCESS_PRIVATE

int pthread_atfork(void function(), void function(), void function());
int pthread_attr_destroy(pthread_attr_t*);
int pthread_attr_getdetachstate(const scope pthread_attr_t*, int*);
int pthread_attr_getschedparam(const scope pthread_attr_t*, sched_param*);
int pthread_attr_init(pthread_attr_t*);
int pthread_attr_setdetachstate(pthread_attr_t*, int);
int pthread_attr_setschedparam(const scope pthread_attr_t*, sched_param*);
int pthread_cancel(pthread_t);
void pthread_cleanup_push(void function(void*), void*);
void pthread_cleanup_pop(int);
int pthread_cond_broadcast(pthread_cond_t*);
int pthread_cond_destroy(pthread_cond_t*);
int pthread_cond_init(const scope pthread_cond_t*, pthread_condattr_t*);
int pthread_cond_signal(pthread_cond_t*);
int pthread_cond_timedwait(pthread_cond_t*, pthread_mutex_t*, const scope timespec*);
int pthread_cond_wait(pthread_cond_t*, pthread_mutex_t*);
int pthread_condattr_destroy(pthread_condattr_t*);
int pthread_condattr_init(pthread_condattr_t*);
int pthread_create(pthread_t*, const scope pthread_attr_t*, void* function(void*), void*);
int pthread_detach(pthread_t);
int pthread_equal(pthread_t, pthread_t);
void pthread_exit(void*);
void* pthread_getspecific(pthread_key_t);
int pthread_join(pthread_t, void**);
int pthread_key_create(pthread_key_t*, void function(void*));
int pthread_key_delete(pthread_key_t);
int pthread_mutex_destroy(pthread_mutex_t*);
int pthread_mutex_init(pthread_mutex_t*, pthread_mutexattr_t*);
int pthread_mutex_lock(pthread_mutex_t*);
int pthread_mutex_trylock(pthread_mutex_t*);
int pthread_mutex_unlock(pthread_mutex_t*);
int pthread_mutexattr_destroy(pthread_mutexattr_t*);
int pthread_mutexattr_init(pthread_mutexattr_t*);
int pthread_once(pthread_once_t*, void function());
int pthread_rwlock_destroy(pthread_rwlock_t*);
int pthread_rwlock_init(pthread_rwlock_t*, const scope pthread_rwlockattr_t*);
int pthread_rwlock_rdlock(pthread_rwlock_t*);
int pthread_rwlock_tryrdlock(pthread_rwlock_t*);
int pthread_rwlock_trywrlock(pthread_rwlock_t*);
int pthread_rwlock_unlock(pthread_rwlock_t*);
int pthread_rwlock_wrlock(pthread_rwlock_t*);
int pthread_rwlockattr_destroy(pthread_rwlockattr_t*);
int pthread_rwlockattr_init(pthread_rwlockattr_t*);
pthread_t pthread_self();
int pthread_setcancelstate(int, int*);
int pthread_setcanceltype(int, int*);
int pthread_setspecific(pthread_key_t, const scope void*);
void pthread_testcancel();
*/
version (CRuntime_Glibc) {
    enum {
        PTHREAD_CANCEL_ENABLE,
        PTHREAD_CANCEL_DISABLE
    }

    enum {
        PTHREAD_CANCEL_DEFERRED,
        PTHREAD_CANCEL_ASYNCHRONOUS
    }

    enum PTHREAD_CANCELED = cast(void*)-1;

    //enum pthread_mutex_t PTHREAD_COND_INITIALIZER = { __LOCK_ALT_INITIALIZER, 0, "", 0 };

    enum {
        PTHREAD_CREATE_JOINABLE,
        PTHREAD_CREATE_DETACHED
    }

    enum {
        PTHREAD_INHERIT_SCHED,
        PTHREAD_EXPLICIT_SCHED
    }

    enum PTHREAD_MUTEX_INITIALIZER = pthread_mutex_t.init;
    enum PTHREAD_ONCE_INIT = pthread_once_t.init;

    enum {
        PTHREAD_PROCESS_PRIVATE,
        PTHREAD_PROCESS_SHARED
    }
} else version (Darwin) {
    enum {
        PTHREAD_CANCEL_ENABLE = 1,
        PTHREAD_CANCEL_DISABLE = 0
    }

    enum {
        PTHREAD_CANCEL_DEFERRED = 2,
        PTHREAD_CANCEL_ASYNCHRONOUS = 0
    }

    enum PTHREAD_CANCELED = cast(void*)-1;

    //enum pthread_mutex_t PTHREAD_COND_INITIALIZER = { __LOCK_ALT_INITIALIZER, 0, "", 0 };

    enum {
        PTHREAD_CREATE_JOINABLE = 1,
        PTHREAD_CREATE_DETACHED = 2
    }

    enum {
        PTHREAD_INHERIT_SCHED = 1,
        PTHREAD_EXPLICIT_SCHED = 2
    }

    enum PTHREAD_MUTEX_INITIALIZER = pthread_mutex_t(0x32AAABA7);
    enum PTHREAD_ONCE_INIT = pthread_once_t(0x30b1bcba);

    enum {
        PTHREAD_PROCESS_PRIVATE = 2,
        PTHREAD_PROCESS_SHARED = 1
    }
} else version (FreeBSD) {
    enum {
        PTHREAD_DETACHED = 0x1,
        PTHREAD_INHERIT_SCHED = 0x4,
        PTHREAD_NOFLOAT = 0x8,

        PTHREAD_CREATE_DETACHED = PTHREAD_DETACHED,
        PTHREAD_CREATE_JOINABLE = 0,
        PTHREAD_EXPLICIT_SCHED = 0,
    }

    enum {
        PTHREAD_PROCESS_PRIVATE = 0,
        PTHREAD_PROCESS_SHARED = 1,
    }

    enum {
        PTHREAD_CANCEL_ENABLE = 0,
        PTHREAD_CANCEL_DISABLE = 1,
        PTHREAD_CANCEL_DEFERRED = 0,
        PTHREAD_CANCEL_ASYNCHRONOUS = 2,
    }

    enum PTHREAD_CANCELED = cast(void*)-1;

    enum PTHREAD_NEEDS_INIT = 0;
    enum PTHREAD_DONE_INIT = 1;

    enum PTHREAD_MUTEX_INITIALIZER = null;
    enum PTHREAD_ONCE_INIT = null;
    enum PTHREAD_ADAPTIVE_MUTEX_INITIALIZER_NP = null;
    enum PTHREAD_COND_INITIALIZER = null;
    enum PTHREAD_RWLOCK_INITIALIZER = null;
} else version (NetBSD) {
    enum PRI_NONE = -1;
    enum {
        PTHREAD_INHERIT_SCHED = 0x0,

        PTHREAD_CREATE_DETACHED = 1,
        PTHREAD_CREATE_JOINABLE = 0,
        PTHREAD_EXPLICIT_SCHED = 1,
    }

    enum {
        PTHREAD_PROCESS_PRIVATE = 0,
        PTHREAD_PROCESS_SHARED = 1,
    }

    enum {
        PTHREAD_CANCEL_ENABLE = 0,
        PTHREAD_CANCEL_DISABLE = 1,
        PTHREAD_CANCEL_DEFERRED = 0,
        PTHREAD_CANCEL_ASYNCHRONOUS = 1,
    }

    enum PTHREAD_CANCELED = cast(void*) 1;

    enum PTHREAD_DONE_INIT = 1;

    enum PTHREAD_MUTEX_INITIALIZER = pthread_mutex_t(0x33330003);

    enum PTHREAD_ONCE_INIT = pthread_once_t(PTHREAD_MUTEX_INITIALIZER);
    enum PTHREAD_COND_INITIALIZER = pthread_cond_t(0x55550005);
    enum PTHREAD_RWLOCK_INITIALIZER = pthread_rwlock_t(0x99990009);
} else version (OpenBSD) {
    enum {
        PTHREAD_DETACHED = 0x1,
        PTHREAD_INHERIT_SCHED = 0x4,
        PTHREAD_NOFLOAT = 0x8,

        PTHREAD_CREATE_DETACHED = PTHREAD_DETACHED,
        PTHREAD_CREATE_JOINABLE = 0,
        PTHREAD_EXPLICIT_SCHED = 0,
    }

    enum {
        PTHREAD_PROCESS_PRIVATE = 0,
        PTHREAD_PROCESS_SHARED = 1,
    }

    enum {
        PTHREAD_CANCEL_ENABLE = 0,
        PTHREAD_CANCEL_DISABLE = 1,
        PTHREAD_CANCEL_DEFERRED = 0,
        PTHREAD_CANCEL_ASYNCHRONOUS = 2,
    }

    enum PTHREAD_CANCELED = cast(void*) 1;

    enum {
        PTHREAD_NEEDS_INIT = 0,
        PTHREAD_DONE_INIT = 1,
    }

    enum PTHREAD_MUTEX_INITIALIZER = null;
    enum PTHREAD_ONCE_INIT = pthread_once_t.init;
    enum PTHREAD_COND_INITIALIZER = null;
    enum PTHREAD_RWLOCK_INITIALIZER = null;
} else version (DragonFlyBSD) {
    enum {
        PTHREAD_DETACHED = 0x1,
        //PTHREAD_SCOPE_SYSTEM        = 0x2,    // defined below
        PTHREAD_INHERIT_SCHED = 0x4,
        PTHREAD_NOFLOAT = 0x8,

        PTHREAD_CREATE_DETACHED = PTHREAD_DETACHED,
        PTHREAD_CREATE_JOINABLE = 0,
        //PTHREAD_SCOPE_PROCESS       = 0,      // defined below
        PTHREAD_EXPLICIT_SCHED = 0,
    }

    enum {
        PTHREAD_PROCESS_PRIVATE = 0,
        PTHREAD_PROCESS_SHARED = 1,
    }

    enum {
        PTHREAD_CANCEL_ENABLE = 0,
        PTHREAD_CANCEL_DISABLE = 1,
        PTHREAD_CANCEL_DEFERRED = 0,
        PTHREAD_CANCEL_ASYNCHRONOUS = 2,
    }

    enum PTHREAD_CANCELED = cast(void*)-1;

    enum PTHREAD_NEEDS_INIT = 0;
    enum PTHREAD_DONE_INIT = 1;

    enum PTHREAD_MUTEX_INITIALIZER = null;
    enum PTHREAD_ONCE_INIT = pthread_once_t.init;
    enum PTHREAD_COND_INITIALIZER = null;
    enum PTHREAD_RWLOCK_INITIALIZER = null;
} else version (Solaris) {
    enum {
        PTHREAD_INHERIT_SCHED = 0x01,
        PTHREAD_NOFLOAT = 0x08,
        PTHREAD_CREATE_DETACHED = 0x40,
        PTHREAD_CREATE_JOINABLE = 0x00,
        PTHREAD_EXPLICIT_SCHED = 0x00,
    }

    enum {
        PTHREAD_PROCESS_PRIVATE = 0,
        PTHREAD_PROCESS_SHARED = 1,
    }

    enum {
        PTHREAD_CANCEL_ENABLE = 0,
        PTHREAD_CANCEL_DISABLE = 1,
        PTHREAD_CANCEL_DEFERRED = 0,
        PTHREAD_CANCEL_ASYNCHRONOUS = 2,
    }

    enum PTHREAD_CANCELED = cast(void*)-19;

    enum PTHREAD_MUTEX_INITIALIZER = pthread_mutex_t.init;
    enum PTHREAD_ONCE_INIT = pthread_once_t.init;
} else version (CRuntime_Bionic) {
    enum {
        PTHREAD_CREATE_JOINABLE,
        PTHREAD_CREATE_DETACHED
    }

    enum PTHREAD_MUTEX_INITIALIZER = pthread_mutex_t.init;
    enum PTHREAD_ONCE_INIT = pthread_once_t.init;

    enum {
        PTHREAD_PROCESS_PRIVATE,
        PTHREAD_PROCESS_SHARED
    }
} else version (CRuntime_Musl) {
    enum {
        PTHREAD_CREATE_JOINABLE = 0,
        PTHREAD_CREATE_DETACHED = 1
    }

    enum PTHREAD_MUTEX_INITIALIZER = pthread_mutex_t.init;
    enum PTHREAD_ONCE_INIT = pthread_once_t.init;

    enum {
        PTHREAD_PROCESS_PRIVATE = 0,
        PTHREAD_PROCESS_SHARED = 1
    }
} else version (CRuntime_UClibc) {
    enum {
        PTHREAD_CANCEL_ENABLE,
        PTHREAD_CANCEL_DISABLE
    }

    enum {
        PTHREAD_CANCEL_DEFERRED,
        PTHREAD_CANCEL_ASYNCHRONOUS
    }

    enum PTHREAD_CANCELED = cast(void*)-1;

    enum PTHREAD_MUTEX_INITIALIZER = pthread_mutex_t.init;
    enum PTHREAD_ONCE_INIT = pthread_once_t.init;

    enum {
        PTHREAD_CREATE_JOINABLE,
        PTHREAD_CREATE_DETACHED
    }

    enum {
        PTHREAD_INHERIT_SCHED,
        PTHREAD_EXPLICIT_SCHED
    }

    enum {
        PTHREAD_PROCESS_PRIVATE,
        PTHREAD_PROCESS_SHARED
    }
} else {
    static assert(false, "Unsupported platform");
}

alias void function(void*) _pthread_cleanup_routine;
alias void function(void*) @nogc _pthread_cleanup_routine_nogc;
version (CRuntime_Glibc) {
    struct _pthread_cleanup_buffer {
        _pthread_cleanup_routine __routine;
        void* __arg;
        int __canceltype;
        _pthread_cleanup_buffer* __prev;
    }

    void _pthread_cleanup_push(_pthread_cleanup_buffer*, _pthread_cleanup_routine, void*);
    void _pthread_cleanup_push(_pthread_cleanup_buffer*, _pthread_cleanup_routine_nogc, void*) @nogc;
    void _pthread_cleanup_pop(_pthread_cleanup_buffer*, int);

    struct pthread_cleanup {
        _pthread_cleanup_buffer buffer = void;

        extern (D) void push(F : _pthread_cleanup_routine)(F routine, void* arg) {
            _pthread_cleanup_push(&buffer, routine, arg);
        }

        extern (D) void pop()(int execute) {
            _pthread_cleanup_pop(&buffer, execute);
        }
    }
} else version (Darwin) {
    struct _pthread_cleanup_buffer {
        _pthread_cleanup_routine __routine;
        void* __arg;
        _pthread_cleanup_buffer* __next;
    }

    struct pthread_cleanup {
        _pthread_cleanup_buffer buffer = void;

        extern (D) void push(F : _pthread_cleanup_routine)(F routine, void* arg) {
            pthread_t self = pthread_self();
            buffer.__routine = routine;
            buffer.__arg = arg;
            buffer.__next = cast(_pthread_cleanup_buffer*) self.__cleanup_stack;
            self.__cleanup_stack = cast(pthread_handler_rec*)&buffer;
        }

        extern (D) void pop()(int execute) {
            pthread_t self = pthread_self();
            self.__cleanup_stack = cast(pthread_handler_rec*) buffer.__next;
            if (execute) {
                buffer.__routine(buffer.__arg);
            }
        }
    }
} else version (FreeBSD) {
    struct _pthread_cleanup_info {
        uintptr_t[8] pthread_cleanup_pad;
    }

    struct pthread_cleanup {
        _pthread_cleanup_info __cleanup_info__ = void;

        extern (D) void push(F : _pthread_cleanup_routine)(F cleanup_routine, void* cleanup_arg) {
            __pthread_cleanup_push_imp(cleanup_routine, cleanup_arg, &__cleanup_info__);
        }

        extern (D) void pop()(int execute) {
            __pthread_cleanup_pop_imp(execute);
        }
    }

    void __pthread_cleanup_push_imp(_pthread_cleanup_routine, void*, _pthread_cleanup_info*);
    void __pthread_cleanup_push_imp(_pthread_cleanup_routine_nogc, void*, _pthread_cleanup_info*) @nogc;
    void __pthread_cleanup_pop_imp(int);
} else version (DragonFlyBSD) {
    struct _pthread_cleanup_info {
        uintptr_t[8] pthread_cleanup_pad;
    }

    struct pthread_cleanup {
        _pthread_cleanup_info __cleanup_info__ = void;

        extern (D) void push()(_pthread_cleanup_routine cleanup_routine, void* cleanup_arg) {
            _pthread_cleanup_push(cleanup_routine, cleanup_arg, &__cleanup_info__);
        }

        extern (D) void pop()(int execute) {
            _pthread_cleanup_pop(execute);
        }
    }

    void _pthread_cleanup_push(_pthread_cleanup_routine, void*, _pthread_cleanup_info*);
    void _pthread_cleanup_pop(int);
} else version (NetBSD) {
    struct _pthread_cleanup_store {
        void*[4] pthread_cleanup_pad;
    }

    struct pthread_cleanup {
        _pthread_cleanup_store __cleanup_info__ = void;

        extern (D) void push()(_pthread_cleanup_routine cleanup_routine, void* cleanup_arg) {
            pthread__cleanup_push(cleanup_routine, cleanup_arg, &__cleanup_info__);
        }

        extern (D) void pop()(int execute) {
            pthread__cleanup_pop(execute, &__cleanup_info__);
        }
    }

    void pthread__cleanup_push(_pthread_cleanup_routine, void*, void*);
    void pthread__cleanup_pop(int, void*);
} else version (OpenBSD) {
    void pthread_cleanup_push(void function(void*), void*);
    void pthread_cleanup_pop(int);
} else version (Solaris) {
    caddr_t _getfp();

    struct _pthread_cleanup_info {
        uintptr_t[4] pthread_cleanup_pad;
    }

    struct pthread_cleanup {
        _pthread_cleanup_info __cleanup_info__ = void;

        extern (D) void push(F : _pthread_cleanup_routine)(F cleanup_routine, void* cleanup_arg) {
            __pthread_cleanup_push(cleanup_routine, cleanup_arg, _getfp(), &__cleanup_info__);
        }

        extern (D) void pop()(int execute) {
            __pthread_cleanup_pop(execute, &__cleanup_info__);
        }
    }

    void __pthread_cleanup_push(_pthread_cleanup_routine, void*, caddr_t, _pthread_cleanup_info*);
    void __pthread_cleanup_push(_pthread_cleanup_routine_nogc, void*, caddr_t, _pthread_cleanup_info*) @nogc;
    void __pthread_cleanup_pop(int, _pthread_cleanup_info*);
} else version (CRuntime_Bionic) {
    struct __pthread_cleanup_t {
        __pthread_cleanup_t* __cleanup_prev;
        _pthread_cleanup_routine __cleanup_routine;
        void* __cleanup_arg;
    }

    void __pthread_cleanup_push(__pthread_cleanup_t*, _pthread_cleanup_routine, void*);
    void __pthread_cleanup_push(__pthread_cleanup_t*, _pthread_cleanup_routine_nogc, void*) @nogc;
    void __pthread_cleanup_pop(__pthread_cleanup_t*, int);

    struct pthread_cleanup {
        __pthread_cleanup_t __cleanup = void;

        extern (D) void push(F : _pthread_cleanup_routine)(F routine, void* arg) {
            __pthread_cleanup_push(&__cleanup, routine, arg);
        }

        extern (D) void pop()(int execute) {
            __pthread_cleanup_pop(&__cleanup, execute);
        }
    }
} else version (CRuntime_Musl) {
    struct __ptcb {
        _pthread_cleanup_routine f;
        void* __x;
        __ptcb* __next;
    }

    void _pthread_cleanup_push(__ptcb*, _pthread_cleanup_routine, void*);
    void _pthread_cleanup_pop(__ptcb*, int);

    struct pthread_cleanup {
        __ptcb __cleanup = void;

        extern (D) void push(F : _pthread_cleanup_routine)(F routine, void* arg) {
            _pthread_cleanup_push(&__cleanup, routine, arg);
        }

        extern (D) void pop()(int execute) {
            _pthread_cleanup_pop(&__cleanup, execute);
        }
    }
} else version (CRuntime_UClibc) {
    struct _pthread_cleanup_buffer {
        _pthread_cleanup_routine __routine;
        void* __arg;
        int __canceltype;
        _pthread_cleanup_buffer* __prev;
    }

    void _pthread_cleanup_push(_pthread_cleanup_buffer*, _pthread_cleanup_routine, void*);
    void _pthread_cleanup_push(_pthread_cleanup_buffer*, _pthread_cleanup_routine_nogc, void*) @nogc;
    void _pthread_cleanup_pop(_pthread_cleanup_buffer*, int);

    struct pthread_cleanup {
        _pthread_cleanup_buffer buffer = void;

        extern (D) void push(F : _pthread_cleanup_routine)(F routine, void* arg) {
            _pthread_cleanup_push(&buffer, routine, arg);
        }

        extern (D) void pop()(int execute) {
            _pthread_cleanup_pop(&buffer, execute);
        }
    }
} else {
    static assert(false, "Unsupported platform");
}

@nogc:

int pthread_cond_broadcast(pthread_cond_t*);
int pthread_cond_destroy(pthread_cond_t*);
int pthread_cond_init(const scope pthread_cond_t*, pthread_condattr_t*) @trusted;
int pthread_cond_signal(pthread_cond_t*);
int pthread_cond_wait(pthread_cond_t*, pthread_mutex_t*);
int pthread_condattr_destroy(pthread_condattr_t*);
int pthread_condattr_init(pthread_condattr_t*);
int pthread_create(pthread_t*, const scope pthread_attr_t*, void* function(void*), void*);
int pthread_detach(pthread_t);
int pthread_equal(pthread_t, pthread_t);
void pthread_exit(void*);
void* pthread_getspecific(pthread_key_t);
int pthread_join(pthread_t, void**);
int pthread_key_create(pthread_key_t*, void function(void*));
int pthread_key_delete(pthread_key_t);
int pthread_mutex_destroy(pthread_mutex_t*);
int pthread_mutex_init(pthread_mutex_t*, pthread_mutexattr_t*) @trusted;
int pthread_mutex_lock(pthread_mutex_t*);
int pthread_mutex_lock(shared(pthread_mutex_t)*);
int pthread_mutex_trylock(pthread_mutex_t*);
int pthread_mutex_trylock(shared(pthread_mutex_t)*);
int pthread_mutex_unlock(pthread_mutex_t*);
int pthread_mutex_unlock(shared(pthread_mutex_t)*);
int pthread_mutexattr_destroy(pthread_mutexattr_t*);
int pthread_mutexattr_init(pthread_mutexattr_t*) @trusted;
int pthread_once(pthread_once_t*, void function());
int pthread_rwlock_destroy(pthread_rwlock_t*);
int pthread_rwlock_init(pthread_rwlock_t*, const scope pthread_rwlockattr_t*);
int pthread_rwlock_rdlock(pthread_rwlock_t*);
int pthread_rwlock_tryrdlock(pthread_rwlock_t*);
int pthread_rwlock_trywrlock(pthread_rwlock_t*);
int pthread_rwlock_unlock(pthread_rwlock_t*);
int pthread_rwlock_wrlock(pthread_rwlock_t*);
int pthread_rwlockattr_destroy(pthread_rwlockattr_t*);
int pthread_rwlockattr_init(pthread_rwlockattr_t*);
pthread_t pthread_self();
int pthread_setcancelstate(int, int*);
int pthread_setcanceltype(int, int*);
int pthread_setspecific(pthread_key_t, const scope void*);
void pthread_testcancel();

//
// Barrier (BAR)
//
/*
PTHREAD_BARRIER_SERIAL_THREAD

int pthread_barrier_destroy(pthread_barrier_t*);
int pthread_barrier_init(pthread_barrier_t*, const scope pthread_barrierattr_t*, uint);
int pthread_barrier_wait(pthread_barrier_t*);
int pthread_barrierattr_destroy(pthread_barrierattr_t*);
int pthread_barrierattr_getpshared(const scope pthread_barrierattr_t*, int*); (BAR|TSH)
int pthread_barrierattr_init(pthread_barrierattr_t*);
int pthread_barrierattr_setpshared(pthread_barrierattr_t*, int); (BAR|TSH)
*/

version (CRuntime_Glibc) {
    enum PTHREAD_BARRIER_SERIAL_THREAD = -1;

    int pthread_barrier_destroy(pthread_barrier_t*);
    int pthread_barrier_init(pthread_barrier_t*, const scope pthread_barrierattr_t*, uint);
    int pthread_barrier_wait(pthread_barrier_t*);
    int pthread_barrierattr_destroy(pthread_barrierattr_t*);
    int pthread_barrierattr_getpshared(const scope pthread_barrierattr_t*, int*);
    int pthread_barrierattr_init(pthread_barrierattr_t*);
    int pthread_barrierattr_setpshared(pthread_barrierattr_t*, int);
} else version (FreeBSD) {
    enum PTHREAD_BARRIER_SERIAL_THREAD = -1;

    int pthread_barrier_destroy(pthread_barrier_t*);
    int pthread_barrier_init(pthread_barrier_t*, const scope pthread_barrierattr_t*, uint);
    int pthread_barrier_wait(pthread_barrier_t*);
    int pthread_barrierattr_destroy(pthread_barrierattr_t*);
    int pthread_barrierattr_getpshared(const scope pthread_barrierattr_t*, int*);
    int pthread_barrierattr_init(pthread_barrierattr_t*);
    int pthread_barrierattr_setpshared(pthread_barrierattr_t*, int);
} else version (DragonFlyBSD) {
    enum PTHREAD_BARRIER_SERIAL_THREAD = -1;
    enum PTHREAD_KEYS_MAX = 256;
    enum PTHREAD_STACK_MIN = 16384;
    enum PTHREAD_THREADS_MAX = c_ulong.max;

    int pthread_barrier_destroy(pthread_barrier_t*);
    int pthread_barrier_init(pthread_barrier_t*, const scope pthread_barrierattr_t*, uint);
    int pthread_barrier_wait(pthread_barrier_t*);
    int pthread_barrierattr_destroy(pthread_barrierattr_t*);
    int pthread_barrierattr_getpshared(const scope pthread_barrierattr_t*, int*);
    int pthread_barrierattr_init(pthread_barrierattr_t*);
    int pthread_barrierattr_setpshared(pthread_barrierattr_t*, int);
} else version (NetBSD) {
    enum PTHREAD_BARRIER_SERIAL_THREAD = 1234567;

    int pthread_barrier_destroy(pthread_barrier_t*);
    int pthread_barrier_init(pthread_barrier_t*, const scope pthread_barrierattr_t*, uint);
    int pthread_barrier_wait(pthread_barrier_t*);
    int pthread_barrierattr_destroy(pthread_barrierattr_t*);
    int pthread_barrierattr_getpshared(const scope pthread_barrierattr_t*, int*);
    int pthread_barrierattr_init(pthread_barrierattr_t*);
    int pthread_barrierattr_setpshared(pthread_barrierattr_t*, int);
} else version (OpenBSD) {
    enum PTHREAD_BARRIER_SERIAL_THREAD = -1;

    int pthread_barrier_destroy(pthread_barrier_t*);
    int pthread_barrier_init(pthread_barrier_t*, const scope pthread_barrierattr_t*, uint);
    int pthread_barrier_wait(pthread_barrier_t*);
    int pthread_barrierattr_destroy(pthread_barrierattr_t*);
    int pthread_barrierattr_getpshared(const scope pthread_barrierattr_t*, int*);
    int pthread_barrierattr_init(pthread_barrierattr_t*);
    int pthread_barrierattr_setpshared(pthread_barrierattr_t*, int);
} else version (Darwin) {
} else version (Solaris) {
    enum PTHREAD_BARRIER_SERIAL_THREAD = -2;

    int pthread_barrier_destroy(pthread_barrier_t*);
    int pthread_barrier_init(pthread_barrier_t*, const scope pthread_barrierattr_t*, uint);
    int pthread_barrier_wait(pthread_barrier_t*);
    int pthread_barrierattr_destroy(pthread_barrierattr_t*);
    int pthread_barrierattr_getpshared(const scope pthread_barrierattr_t*, int*);
    int pthread_barrierattr_init(pthread_barrierattr_t*);
    int pthread_barrierattr_setpshared(pthread_barrierattr_t*, int);
} else version (CRuntime_Bionic) {
} else version (CRuntime_Musl) {
    enum PTHREAD_BARRIER_SERIAL_THREAD = -1;

    int pthread_barrier_destroy(pthread_barrier_t*);
    int pthread_barrier_init(pthread_barrier_t*, const scope pthread_barrierattr_t*, uint);
    int pthread_barrier_wait(pthread_barrier_t*);
    int pthread_barrierattr_destroy(pthread_barrierattr_t*);
    int pthread_barrierattr_getpshared(const scope pthread_barrierattr_t*, int*);
    int pthread_barrierattr_init(pthread_barrierattr_t*);
    int pthread_barrierattr_setpshared(pthread_barrierattr_t*, int);
} else version (CRuntime_UClibc) {
    enum PTHREAD_BARRIER_SERIAL_THREAD = -1;

    int pthread_barrier_destroy(pthread_barrier_t*);
    int pthread_barrier_init(pthread_barrier_t*, const scope pthread_barrierattr_t*, uint);
    int pthread_barrier_wait(pthread_barrier_t*);
    int pthread_barrierattr_destroy(pthread_barrierattr_t*);
    int pthread_barrierattr_getpshared(const scope pthread_barrierattr_t*, int*);
    int pthread_barrierattr_init(pthread_barrierattr_t*);
    int pthread_barrierattr_setpshared(pthread_barrierattr_t*, int);
} else {
    static assert(false, "Unsupported platform");
}

//
// Spinlock (SPI)
//
/*
int pthread_spin_destroy(pthread_spinlock_t*);
int pthread_spin_init(pthread_spinlock_t*, int);
int pthread_spin_lock(pthread_spinlock_t*);
int pthread_spin_trylock(pthread_spinlock_t*);
int pthread_spin_unlock(pthread_spinlock_t*);
*/

version (CRuntime_Glibc) {
    int pthread_spin_destroy(pthread_spinlock_t*);
    int pthread_spin_init(pthread_spinlock_t*, int);
    int pthread_spin_lock(pthread_spinlock_t*);
    int pthread_spin_trylock(pthread_spinlock_t*);
    int pthread_spin_unlock(pthread_spinlock_t*);
} else version (FreeBSD) {
    int pthread_spin_init(pthread_spinlock_t*, int);
    int pthread_spin_destroy(pthread_spinlock_t*);
    int pthread_spin_lock(pthread_spinlock_t*);
    int pthread_spin_trylock(pthread_spinlock_t*);
    int pthread_spin_unlock(pthread_spinlock_t*);
} else version (DragonFlyBSD) {
    int pthread_spin_init(pthread_spinlock_t*, int);
    int pthread_spin_destroy(pthread_spinlock_t*);
    int pthread_spin_lock(pthread_spinlock_t*);
    int pthread_spin_trylock(pthread_spinlock_t*);
    int pthread_spin_unlock(pthread_spinlock_t*);
} else version (NetBSD) {
    int pthread_spin_init(pthread_spinlock_t*, int);
    int pthread_spin_destroy(pthread_spinlock_t*);
    int pthread_spin_lock(pthread_spinlock_t*);
    int pthread_spin_trylock(pthread_spinlock_t*);
    int pthread_spin_unlock(pthread_spinlock_t*);
} else version (OpenBSD) {
    int pthread_spin_init(pthread_spinlock_t*, int);
    int pthread_spin_destroy(pthread_spinlock_t*);
    int pthread_spin_lock(pthread_spinlock_t*);
    int pthread_spin_trylock(pthread_spinlock_t*);
    int pthread_spin_unlock(pthread_spinlock_t*);
} else version (Darwin) {
} else version (Solaris) {
    int pthread_spin_init(pthread_spinlock_t*, int);
    int pthread_spin_destroy(pthread_spinlock_t*);
    int pthread_spin_lock(pthread_spinlock_t*);
    int pthread_spin_trylock(pthread_spinlock_t*);
    int pthread_spin_unlock(pthread_spinlock_t*);
} else version (CRuntime_Bionic) {
} else version (CRuntime_Musl) {
    int pthread_spin_destroy(pthread_spinlock_t*);
    int pthread_spin_init(pthread_spinlock_t*, int);
    int pthread_spin_lock(pthread_spinlock_t*);
    int pthread_spin_trylock(pthread_spinlock_t*);
    int pthread_spin_unlock(pthread_spinlock_t*);
} else version (CRuntime_UClibc) {
    int pthread_spin_destroy(pthread_spinlock_t*);
    int pthread_spin_init(pthread_spinlock_t*, int);
    int pthread_spin_lock(pthread_spinlock_t*);
    int pthread_spin_trylock(pthread_spinlock_t*);
    int pthread_spin_unlock(pthread_spinlock_t*);
} else {
    static assert(false, "Unsupported platform");
}

//
// XOpen (XSI)
//
/*
PTHREAD_MUTEX_DEFAULT
PTHREAD_MUTEX_ERRORCHECK
PTHREAD_MUTEX_NORMAL
PTHREAD_MUTEX_RECURSIVE

int pthread_attr_getguardsize(const scope pthread_attr_t*, size_t*);
int pthread_attr_setguardsize(pthread_attr_t*, size_t);
int pthread_getconcurrency();
int pthread_mutexattr_gettype(const scope pthread_mutexattr_t*, int*);
int pthread_mutexattr_settype(pthread_mutexattr_t*, int);
int pthread_setconcurrency(int);
*/

version (CRuntime_Glibc) {
    enum PTHREAD_MUTEX_NORMAL = 0;
    enum PTHREAD_MUTEX_RECURSIVE = 1;
    enum PTHREAD_MUTEX_ERRORCHECK = 2;
    enum PTHREAD_MUTEX_DEFAULT = PTHREAD_MUTEX_NORMAL;

    int pthread_attr_getguardsize(const scope pthread_attr_t*, size_t*);
    int pthread_attr_setguardsize(pthread_attr_t*, size_t);
    int pthread_getconcurrency();
    int pthread_mutexattr_gettype(const scope pthread_mutexattr_t*, int*);
    int pthread_mutexattr_settype(pthread_mutexattr_t*, int) @trusted;
    int pthread_setconcurrency(int);
} else version (Darwin) {
    enum PTHREAD_MUTEX_NORMAL = 0;
    enum PTHREAD_MUTEX_ERRORCHECK = 1;
    enum PTHREAD_MUTEX_RECURSIVE = 2;
    enum PTHREAD_MUTEX_DEFAULT = PTHREAD_MUTEX_NORMAL;

    int pthread_attr_getguardsize(const scope pthread_attr_t*, size_t*);
    int pthread_attr_setguardsize(pthread_attr_t*, size_t);
    int pthread_getconcurrency();
    int pthread_mutexattr_gettype(const scope pthread_mutexattr_t*, int*);
    int pthread_mutexattr_settype(pthread_mutexattr_t*, int) @trusted;
    int pthread_setconcurrency(int);
} else version (FreeBSD) {
    enum {
        PTHREAD_MUTEX_ERRORCHECK = 1,
        PTHREAD_MUTEX_RECURSIVE = 2,
        PTHREAD_MUTEX_NORMAL = 3,
        PTHREAD_MUTEX_ADAPTIVE_NP = 4,
        PTHREAD_MUTEX_TYPE_MAX
    }
    enum PTHREAD_MUTEX_DEFAULT = PTHREAD_MUTEX_ERRORCHECK;

    int pthread_attr_getguardsize(const scope pthread_attr_t*, size_t*);
    int pthread_attr_setguardsize(pthread_attr_t*, size_t);
    int pthread_getconcurrency();
    int pthread_mutexattr_gettype(pthread_mutexattr_t*, int*);
    int pthread_mutexattr_settype(pthread_mutexattr_t*, int) @trusted;
    int pthread_setconcurrency(int);
} else version (NetBSD) {
    enum {
        PTHREAD_MUTEX_NORMAL = 0,
        PTHREAD_MUTEX_ERRORCHECK = 1,
        PTHREAD_MUTEX_RECURSIVE = 2,
        PTHREAD_MUTEX_TYPE_MAX
    }
    enum PTHREAD_MUTEX_DEFAULT = PTHREAD_MUTEX_ERRORCHECK;

    int pthread_attr_getguardsize(const scope pthread_attr_t*, size_t*);
    int pthread_attr_setguardsize(pthread_attr_t*, size_t);
    int pthread_getconcurrency();
    int pthread_mutexattr_gettype(pthread_mutexattr_t*, int*);
    int pthread_mutexattr_settype(pthread_mutexattr_t*, int) @trusted;
    int pthread_setconcurrency(int);
} else version (OpenBSD) {
    enum {
        PTHREAD_MUTEX_ERRORCHECK = 1,
        PTHREAD_MUTEX_RECURSIVE = 2,
        PTHREAD_MUTEX_NORMAL = 3,
        PTHREAD_MUTEX_ADAPTIVE_NP = 4,
        PTHREAD_MUTEX_TYPE_MAX
    }
    enum PTHREAD_MUTEX_DEFAULT = PTHREAD_MUTEX_ERRORCHECK;

    int pthread_attr_getguardsize(const scope pthread_attr_t*, size_t*);
    int pthread_attr_setguardsize(pthread_attr_t*, size_t);
    int pthread_getconcurrency();
    int pthread_mutexattr_gettype(pthread_mutexattr_t*, int*);
    int pthread_mutexattr_settype(pthread_mutexattr_t*, int) @trusted;
    int pthread_setconcurrency(int);
} else version (DragonFlyBSD) {
    enum {
        PTHREAD_MUTEX_ERRORCHECK = 1,
        PTHREAD_MUTEX_RECURSIVE = 2,
        PTHREAD_MUTEX_NORMAL = 3,
        PTHREAD_MUTEX_TYPE_MAX
    }
    enum PTHREAD_MUTEX_DEFAULT = PTHREAD_MUTEX_ERRORCHECK;

    int pthread_attr_getguardsize(const scope pthread_attr_t*, size_t*);
    int pthread_attr_setguardsize(pthread_attr_t*, size_t);
    int pthread_getconcurrency();
    int pthread_mutexattr_gettype(pthread_mutexattr_t*, int*);
    int pthread_mutexattr_settype(pthread_mutexattr_t*, int) @trusted;
    int pthread_setconcurrency(int);
} else version (Solaris) {
    enum {
        PTHREAD_MUTEX_ERRORCHECK = 2,
        PTHREAD_MUTEX_RECURSIVE = 4,
        PTHREAD_MUTEX_NORMAL = 0,
    }

    enum PTHREAD_MUTEX_DEFAULT = PTHREAD_MUTEX_NORMAL;

    int pthread_attr_getguardsize(const scope pthread_attr_t*, size_t*);
    int pthread_attr_setguardsize(pthread_attr_t*, size_t);
    int pthread_getconcurrency();
    int pthread_mutexattr_gettype(pthread_mutexattr_t*, int*);
    int pthread_mutexattr_settype(pthread_mutexattr_t*, int) @trusted;
    int pthread_setconcurrency(int);
} else version (CRuntime_Bionic) {
    enum PTHREAD_MUTEX_NORMAL = 0;
    enum PTHREAD_MUTEX_RECURSIVE = 1;
    enum PTHREAD_MUTEX_ERRORCHECK = 2;
    enum PTHREAD_MUTEX_DEFAULT = PTHREAD_MUTEX_NORMAL;

    int pthread_attr_getguardsize(const scope pthread_attr_t*, size_t*);
    int pthread_attr_setguardsize(pthread_attr_t*, size_t);
    int pthread_mutexattr_gettype(const scope pthread_mutexattr_t*, int*);
    int pthread_mutexattr_settype(pthread_mutexattr_t*, int) @trusted;
} else version (CRuntime_Musl) {
    enum {
        PTHREAD_MUTEX_NORMAL = 0,
        PTHREAD_MUTEX_RECURSIVE = 1,
        PTHREAD_MUTEX_ERRORCHECK = 2,
        PTHREAD_MUTEX_DEFAULT = PTHREAD_MUTEX_NORMAL,
    }
    int pthread_mutexattr_settype(pthread_mutexattr_t*, int) @trusted;
} else version (CRuntime_UClibc) {
    enum {
        PTHREAD_MUTEX_TIMED_NP,
        PTHREAD_MUTEX_RECURSIVE_NP,
        PTHREAD_MUTEX_ERRORCHECK_NP,
        PTHREAD_MUTEX_ADAPTIVE_NP,
        PTHREAD_MUTEX_NORMAL = PTHREAD_MUTEX_TIMED_NP,
        PTHREAD_MUTEX_RECURSIVE = PTHREAD_MUTEX_RECURSIVE_NP,
        PTHREAD_MUTEX_ERRORCHECK = PTHREAD_MUTEX_ERRORCHECK_NP,
        PTHREAD_MUTEX_DEFAULT = PTHREAD_MUTEX_NORMAL,
        PTHREAD_MUTEX_FAST_NP = PTHREAD_MUTEX_TIMED_NP
    }

    int pthread_attr_getguardsize(const scope pthread_attr_t*, size_t*);
    int pthread_attr_setguardsize(pthread_attr_t*, size_t);
    int pthread_getconcurrency();
    int pthread_mutexattr_gettype(const scope pthread_mutexattr_t*, int*);
    int pthread_mutexattr_settype(pthread_mutexattr_t*, int) @trusted;
    int pthread_setconcurrency(int);
} else {
    static assert(false, "Unsupported platform");
}

//
// Priority (TPI|TPP)
//
/*
PTHREAD_PRIO_INHERIT (TPI)
PTHREAD_PRIO_NONE (TPP|TPI)
PTHREAD_PRIO_PROTECT (TPI)

int pthread_mutex_getprioceiling(const scope pthread_mutex_t*, int*); (TPP)
int pthread_mutex_setprioceiling(pthread_mutex_t*, int, int*); (TPP)
int pthread_mutexattr_getprioceiling(pthread_mutexattr_t*, int*); (TPP)
int pthread_mutexattr_getprotocol(const scope pthread_mutexattr_t*, int*); (TPI|TPP)
int pthread_mutexattr_setprioceiling(pthread_mutexattr_t*, int); (TPP)
int pthread_mutexattr_setprotocol(pthread_mutexattr_t*, int); (TPI|TPP)
*/
version (Darwin) {
    enum {
        PTHREAD_PRIO_NONE,
        PTHREAD_PRIO_INHERIT,
        PTHREAD_PRIO_PROTECT
    }

    int pthread_mutex_getprioceiling(const scope pthread_mutex_t*, int*);
    int pthread_mutex_setprioceiling(pthread_mutex_t*, int, int*);
    int pthread_mutexattr_getprioceiling(const scope pthread_mutexattr_t*, int*);
    int pthread_mutexattr_getprotocol(const scope pthread_mutexattr_t*, int*);
    int pthread_mutexattr_setprioceiling(pthread_mutexattr_t*, int);
    int pthread_mutexattr_setprotocol(pthread_mutexattr_t*, int);
} else version (Solaris) {
    enum {
        PTHREAD_PRIO_NONE = 0x00,
        PTHREAD_PRIO_INHERIT = 0x10,
        PTHREAD_PRIO_PROTECT = 0x20,
    }

    int pthread_mutex_getprioceiling(const scope pthread_mutex_t*, int*);
    int pthread_mutex_setprioceiling(pthread_mutex_t*, int, int*);
    int pthread_mutexattr_getprioceiling(const scope pthread_mutexattr_t*, int*);
    int pthread_mutexattr_getprotocol(const scope pthread_mutexattr_t*, int*);
    int pthread_mutexattr_setprioceiling(pthread_mutexattr_t*, int);
    int pthread_mutexattr_setprotocol(pthread_mutexattr_t*, int);
}

//
// Stack (TSA|TSS)
//
/*
int pthread_attr_getstack(const scope pthread_attr_t*, void**, size_t*); (TSA|TSS)
int pthread_attr_getstackaddr(const scope pthread_attr_t*, void**); (TSA)
int pthread_attr_getstacksize(const scope pthread_attr_t*, size_t*); (TSS)
int pthread_attr_setstack(pthread_attr_t*, void*, size_t); (TSA|TSS)
int pthread_attr_setstackaddr(pthread_attr_t*, void*); (TSA)
int pthread_attr_setstacksize(pthread_attr_t*, size_t); (TSS)
*/

version (CRuntime_Glibc) {
    int pthread_attr_getstack(const scope pthread_attr_t*, void**, size_t*);
    int pthread_attr_getstackaddr(const scope pthread_attr_t*, void**);
    int pthread_attr_getstacksize(const scope pthread_attr_t*, size_t*);
    int pthread_attr_setstack(pthread_attr_t*, void*, size_t);
    int pthread_attr_setstackaddr(pthread_attr_t*, void*);
    int pthread_attr_setstacksize(pthread_attr_t*, size_t);
} else version (Darwin) {
    int pthread_attr_getstack(const scope pthread_attr_t*, void**, size_t*);
    int pthread_attr_getstackaddr(const scope pthread_attr_t*, void**);
    int pthread_attr_getstacksize(const scope pthread_attr_t*, size_t*);
    int pthread_attr_setstack(pthread_attr_t*, void*, size_t);
    int pthread_attr_setstackaddr(pthread_attr_t*, void*);
    int pthread_attr_setstacksize(pthread_attr_t*, size_t);
} else version (FreeBSD) {
    int pthread_attr_getstack(const scope pthread_attr_t*, void**, size_t*);
    int pthread_attr_getstackaddr(const scope pthread_attr_t*, void**);
    int pthread_attr_getstacksize(const scope pthread_attr_t*, size_t*);
    int pthread_attr_setstack(pthread_attr_t*, void*, size_t);
    int pthread_attr_setstackaddr(pthread_attr_t*, void*);
    int pthread_attr_setstacksize(pthread_attr_t*, size_t);
} else version (NetBSD) {
    int pthread_attr_getstack(const scope pthread_attr_t*, void**, size_t*);
    int pthread_attr_getstackaddr(const scope pthread_attr_t*, void**);
    int pthread_attr_getstacksize(const scope pthread_attr_t*, size_t*);
    int pthread_attr_setstack(pthread_attr_t*, void*, size_t);
    int pthread_attr_setstackaddr(pthread_attr_t*, void*);
    int pthread_attr_setstacksize(pthread_attr_t*, size_t);
} else version (OpenBSD) {
    int pthread_attr_getstack(const scope pthread_attr_t*, void**, size_t*);
    int pthread_attr_getstackaddr(const scope pthread_attr_t*, void**);
    int pthread_attr_getstacksize(const scope pthread_attr_t*, size_t*);
    int pthread_attr_setstack(pthread_attr_t*, void*, size_t);
    int pthread_attr_setstackaddr(pthread_attr_t*, void*);
    int pthread_attr_setstacksize(pthread_attr_t*, size_t);
} else version (DragonFlyBSD) {
    int pthread_attr_getstack(const scope pthread_attr_t*, void**, size_t*);
    int pthread_attr_getstackaddr(const scope pthread_attr_t*, void**);
    int pthread_attr_getstacksize(const scope pthread_attr_t*, size_t*);
    int pthread_attr_setstack(pthread_attr_t*, void*, size_t);
    int pthread_attr_setstackaddr(pthread_attr_t*, void*);
    int pthread_attr_setstacksize(pthread_attr_t*, size_t);
} else version (Solaris) {
    int pthread_attr_getstack(const scope pthread_attr_t*, void**, size_t*);
    int pthread_attr_getstackaddr(const scope pthread_attr_t*, void**);
    int pthread_attr_getstacksize(const scope pthread_attr_t*, size_t*);
    int pthread_attr_setstack(pthread_attr_t*, void*, size_t);
    int pthread_attr_setstackaddr(pthread_attr_t*, void*);
    int pthread_attr_setstacksize(pthread_attr_t*, size_t);
} else version (CRuntime_Bionic) {
    int pthread_attr_getstack(const scope pthread_attr_t*, void**, size_t*);
    int pthread_attr_getstackaddr(const scope pthread_attr_t*, void**);
    int pthread_attr_getstacksize(const scope pthread_attr_t*, size_t*);
    int pthread_attr_setstack(pthread_attr_t*, void*, size_t);
    int pthread_attr_setstackaddr(pthread_attr_t*, void*);
    int pthread_attr_setstacksize(pthread_attr_t*, size_t);
} else version (CRuntime_Musl) {
    int pthread_attr_getstack(const scope pthread_attr_t*, void**, size_t*);
    int pthread_attr_setstacksize(pthread_attr_t*, size_t);
} else version (CRuntime_UClibc) {
    int pthread_attr_getstack(const scope pthread_attr_t*, void**, size_t*);
    int pthread_attr_getstackaddr(const scope pthread_attr_t*, void**);
    int pthread_attr_getstacksize(const scope pthread_attr_t*, size_t*);
    int pthread_attr_setstack(pthread_attr_t*, void*, size_t);
    int pthread_attr_setstackaddr(pthread_attr_t*, void*);
    int pthread_attr_setstacksize(pthread_attr_t*, size_t);
} else {
    static assert(false, "Unsupported platform");
}

//
// Shared Synchronization (TSH)
//
/*
int pthread_condattr_getpshared(const scope pthread_condattr_t*, int*);
int pthread_condattr_setpshared(pthread_condattr_t*, int);
int pthread_mutexattr_getpshared(const scope pthread_mutexattr_t*, int*);
int pthread_mutexattr_setpshared(pthread_mutexattr_t*, int);
int pthread_rwlockattr_getpshared(const scope pthread_rwlockattr_t*, int*);
int pthread_rwlockattr_setpshared(pthread_rwlockattr_t*, int);
*/

version (CRuntime_Glibc) {
    int pthread_condattr_getpshared(const scope pthread_condattr_t*, int*);
    int pthread_condattr_setpshared(pthread_condattr_t*, int);
    int pthread_mutexattr_getpshared(const scope pthread_mutexattr_t*, int*);
    int pthread_mutexattr_setpshared(pthread_mutexattr_t*, int);
    int pthread_rwlockattr_getpshared(const scope pthread_rwlockattr_t*, int*);
    int pthread_rwlockattr_setpshared(pthread_rwlockattr_t*, int);
} else version (FreeBSD) {
    int pthread_condattr_getpshared(const scope pthread_condattr_t*, int*);
    int pthread_condattr_setpshared(pthread_condattr_t*, int);
    int pthread_mutexattr_getpshared(const scope pthread_mutexattr_t*, int*);
    int pthread_mutexattr_setpshared(pthread_mutexattr_t*, int);
    int pthread_rwlockattr_getpshared(const scope pthread_rwlockattr_t*, int*);
    int pthread_rwlockattr_setpshared(pthread_rwlockattr_t*, int);
} else version (NetBSD) {
    int pthread_condattr_getpshared(const scope pthread_condattr_t*, int*);
    int pthread_condattr_setpshared(pthread_condattr_t*, int);
    int pthread_mutexattr_getpshared(const scope pthread_mutexattr_t*, int*);
    int pthread_mutexattr_setpshared(pthread_mutexattr_t*, int);
    int pthread_rwlockattr_getpshared(const scope pthread_rwlockattr_t*, int*);
    int pthread_rwlockattr_setpshared(pthread_rwlockattr_t*, int);
} else version (OpenBSD) {
} else version (DragonFlyBSD) {
    int pthread_condattr_getpshared(const scope pthread_condattr_t*, int*);
    int pthread_condattr_setpshared(pthread_condattr_t*, int);
    int pthread_mutexattr_getpshared(const scope pthread_mutexattr_t*, int*);
    int pthread_mutexattr_setpshared(pthread_mutexattr_t*, int);
    int pthread_rwlockattr_getpshared(const scope pthread_rwlockattr_t*, int*);
    int pthread_rwlockattr_setpshared(pthread_rwlockattr_t*, int);
} else version (Darwin) {
    int pthread_condattr_getpshared(const scope pthread_condattr_t*, int*);
    int pthread_condattr_setpshared(pthread_condattr_t*, int);
    int pthread_mutexattr_getpshared(const scope pthread_mutexattr_t*, int*);
    int pthread_mutexattr_setpshared(pthread_mutexattr_t*, int);
    int pthread_rwlockattr_getpshared(const scope pthread_rwlockattr_t*, int*);
    int pthread_rwlockattr_setpshared(pthread_rwlockattr_t*, int);
} else version (Solaris) {
    int pthread_condattr_getpshared(const scope pthread_condattr_t*, int*);
    int pthread_condattr_setpshared(pthread_condattr_t*, int);
    int pthread_mutexattr_getpshared(const scope pthread_mutexattr_t*, int*);
    int pthread_mutexattr_setpshared(pthread_mutexattr_t*, int);
    int pthread_rwlockattr_getpshared(const scope pthread_rwlockattr_t*, int*);
    int pthread_rwlockattr_setpshared(pthread_rwlockattr_t*, int);
} else version (CRuntime_Bionic) {
    int pthread_condattr_getpshared(pthread_condattr_t*, int*);
    int pthread_condattr_setpshared(pthread_condattr_t*, int);
    int pthread_mutexattr_getpshared(pthread_mutexattr_t*, int*);
    int pthread_mutexattr_setpshared(pthread_mutexattr_t*, int);
    int pthread_rwlockattr_getpshared(pthread_rwlockattr_t*, int*);
    int pthread_rwlockattr_setpshared(pthread_rwlockattr_t*, int);
} else version (CRuntime_Musl) {
    int pthread_condattr_getpshared(pthread_condattr_t*, int*);
    int pthread_condattr_setpshared(pthread_condattr_t*, int);
    int pthread_mutexattr_getpshared(pthread_mutexattr_t*, int*);
    int pthread_mutexattr_setpshared(pthread_mutexattr_t*, int);
    int pthread_rwlockattr_getpshared(pthread_rwlockattr_t*, int*);
    int pthread_rwlockattr_setpshared(pthread_rwlockattr_t*, int);
} else version (CRuntime_UClibc) {
    int pthread_condattr_getpshared(const scope pthread_condattr_t*, int*);
    int pthread_condattr_setpshared(pthread_condattr_t*, int);
    int pthread_mutexattr_getpshared(const scope pthread_mutexattr_t*, int*);
    int pthread_mutexattr_setpshared(pthread_mutexattr_t*, int);
    int pthread_rwlockattr_getpshared(const scope pthread_rwlockattr_t*, int*);
    int pthread_rwlockattr_setpshared(pthread_rwlockattr_t*, int);
} else {
    static assert(false, "Unsupported platform");
}