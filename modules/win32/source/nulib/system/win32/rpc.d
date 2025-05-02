/**
 * Windows API header module
 *
 * Translated from MinGW Windows headers
 *
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source: $(DRUNTIMESRC core/sys/windows/_rpc.d)
 */
module nulib.system.win32.rpc;
public import nulib.system.win32.rpcdce;  // also pulls in rpcdcep
public import nulib.system.win32.rpcnsi;
public import nulib.system.win32.rpcnterr;
public import nulib.system.win32.winerror;
public import nulib.system.com;
import nulib.system.com.objbase :
    MIDL_user_allocate,
    MIDL_user_free;


/* Moved to rpcdecp (duplicate definition).
    typedef void *I_RPC_HANDLE;
    alias RPC_STATUS = long;
    // Moved to rpcdce:
    RpcImpersonateClient
    RpcRevertToSelf
*/

alias midl_user_allocate = MIDL_user_allocate;
alias midl_user_free = MIDL_user_free;

extern (Windows) nothrow @nogc {
    int I_RpcMapWin32Status(RPC_STATUS);
}
