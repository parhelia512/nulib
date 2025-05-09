/**
 * Windows API header module
 *
 * Translated from MinGW Windows headers
 *
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source: $(DRUNTIMESRC core/sys/windows/_rpcnsip.d)
 */
module nulib.system.win32.rpcnsip;


import nulib.system.win32.rpcdce, nulib.system.win32.rpcdcep, nulib.system.win32.rpcnsi;

struct RPC_IMPORT_CONTEXT_P {
    RPC_NS_HANDLE       LookupContext;
    RPC_BINDING_HANDLE  ProposedHandle;
    RPC_BINDING_VECTOR* Bindings;
}
alias PRPC_IMPORT_CONTEXT_P = RPC_IMPORT_CONTEXT_P*;

extern(Windows) {
    RPC_STATUS I_RpcNsGetBuffer(PRPC_MESSAGE);
    RPC_STATUS I_RpcNsSendReceive(PRPC_MESSAGE, RPC_BINDING_HANDLE*);
    void I_RpcNsRaiseException(PRPC_MESSAGE, RPC_STATUS);
    RPC_STATUS I_RpcReBindBuffer(PRPC_MESSAGE);
    RPC_STATUS I_NsServerBindSearch();
    RPC_STATUS I_NsClientBindSearch();
    void I_NsClientBindDone();
}
