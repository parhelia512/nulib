/**
    D header file for C99.

    $(C_HEADER_DESCRIPTION pubs.opengroup.org/onlinepubs/009695399/basedefs/_errno.h.html, _errno.h)

    Copyright: Copyright Sean Kelly 2005 - 2009.
    License: Distributed under the
       $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0).
       (See accompanying file LICENSE)
    Authors:   Sean Kelly, Alex Rønne Petersen
    Standards: ISO/IEC 9899:1999 (E)
*/
module nulib.c.errno;

version (OSX)
    version = Darwin;
else version (iOS)
    version = Darwin;
else version (TVOS)
    version = Darwin;
else version (WatchOS)
    version = Darwin;

version (ARM)     version = ARM_Any;
version (AArch64) version = ARM_Any;
version (HPPA)    version = HPPA_Any;
version (MIPS32)  version = MIPS_Any;
version (MIPS64)  version = MIPS_Any;
version (PPC)     version = PPC_Any;
version (PPC64)   version = PPC_Any;
version (RISCV32) version = RISCV_Any;
version (RISCV64) version = RISCV_Any;
version (S390)    version = IBMZ_Any;
version (SPARC)   version = SPARC_Any;
version (SPARC64) version = SPARC_Any;
version (SystemZ) version = IBMZ_Any;
version (X86)     version = X86_Any;
version (X86_64)  version = X86_Any;

@trusted: // Only manipulates errno.
nothrow:
@nogc:

version (CRuntime_Microsoft) {
    extern (C) {
        ref int _errno();
        alias errno = _errno;
    }
} else version (CRuntime_Glibc) {
    extern (C) {
        ref int __errno_location();
        alias errno = __errno_location;
    }
} else version (CRuntime_Musl) {
    extern (C) {
        ref int __errno_location();
        alias errno = __errno_location;
    }
} else version (CRuntime_Newlib) {
    extern (C) {
        ref int __errno();
        alias errno = __errno;
    }
} else version (OpenBSD) {
    // https://github.com/openbsd/src/blob/master/include/errno.h
    extern (C) {
        ref int __errno();
        alias errno = __errno;
    }
} else version (NetBSD) {
    // https://github.com/NetBSD/src/blob/trunk/include/errno.h
    extern (C) {
        ref int __errno();
        alias errno = __errno;
    }
} else version (FreeBSD) {
    extern (C) {
        ref int __error();
        alias errno = __error;
    }
} else version (DragonFlyBSD) {
    extern (C) {
        pragma(mangle, "errno") int __errno;
        ref int __error() {
            return __errno;
        }

        alias errno = __error;
    }
} else version (CRuntime_Bionic) {
    extern (C) {
        ref int __errno();
        alias errno = __errno;
    }
} else version (CRuntime_UClibc) {
    extern (C) {
        ref int __errno_location();
        alias errno = __errno_location;
    }
} else version (Darwin) {
    extern (C) {
        ref int __error();
        alias errno = __error;
    }
} else version (Solaris) {
    extern (C) {
        ref int ___errno();
        alias errno = ___errno;
    }
} else version (Haiku) {
    // https://github.com/haiku/haiku/blob/master/headers/posix/errno.h
    extern (C) {
        ref int _errnop();
        alias errno = _errnop;
    }
}
