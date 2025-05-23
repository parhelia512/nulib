/**
 * Windows API header module
 *
 * RPC Name Service (RpcNs APIs)
 *
 * Translated from MinGW Windows headers
 *
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source: $(DRUNTIMESRC core/sys/windows/_rpcnsi.d)
 */
module nulib.system.win32.rpcnsi;
import nulib.system.win32.basetyps;
import nulib.system.win32.rpcdcep;
import nulib.system.win32.rpcnsi;
import nulib.system.win32.rpcdce;
import nulib.system.win32.w32api;
import nulib.system.win32.windef;  // for HANDLE
pragma(lib, "rpcns4");


version (ANSI) {} else version = Unicode;
alias RPC_NS_HANDLE = HANDLE;

enum RPC_C_NS_SYNTAX_DEFAULT=0;
enum RPC_C_NS_SYNTAX_DCE=3;
enum RPC_C_PROFILE_DEFAULT_ELT=0;
enum RPC_C_PROFILE_ALL_ELT=1;
enum RPC_C_PROFILE_MATCH_BY_IF=2;
enum RPC_C_PROFILE_MATCH_BY_MBR=3;
enum RPC_C_PROFILE_MATCH_BY_BOTH=4;
enum RPC_C_NS_DEFAULT_EXP_AGE=-1;

extern (Windows) {
    RPC_STATUS RpcNsBindingExportA(uint, ubyte*, RPC_IF_HANDLE,
      RPC_BINDING_VECTOR*, UUID_VECTOR*);
    RPC_STATUS RpcNsBindingUnexportA(uint, ubyte*, RPC_IF_HANDLE,
      UUID_VECTOR*);
    RPC_STATUS RpcNsBindingLookupBeginA(uint, ubyte*, RPC_IF_HANDLE, UUID*,
      uint, RPC_NS_HANDLE*);
    RPC_STATUS RpcNsBindingLookupNext(RPC_NS_HANDLE, RPC_BINDING_VECTOR**);
    RPC_STATUS RpcNsBindingLookupDone(RPC_NS_HANDLE*);
    RPC_STATUS RpcNsGroupDeleteA(uint, ubyte*);
    RPC_STATUS RpcNsGroupMbrAddA(uint, ubyte*, uint, ubyte*);
    RPC_STATUS RpcNsGroupMbrRemoveA(uint, ubyte*, uint, ubyte*);
    RPC_STATUS RpcNsGroupMbrInqBeginA(uint, ubyte*, uint, RPC_NS_HANDLE*);
    RPC_STATUS RpcNsGroupMbrInqNextA(RPC_NS_HANDLE, ubyte**);
    RPC_STATUS RpcNsGroupMbrInqDone(RPC_NS_HANDLE*);
    RPC_STATUS RpcNsProfileDeleteA(uint, ubyte*);
    RPC_STATUS RpcNsProfileEltAddA(uint, ubyte*, RPC_IF_ID*, uint, ubyte*,
      uint, ubyte*);
    RPC_STATUS RpcNsProfileEltRemoveA(uint, ubyte*, RPC_IF_ID*, uint, ubyte*);
    RPC_STATUS RpcNsProfileEltInqBeginA(uint, ubyte*, uint, RPC_IF_ID*, uint,
      uint, ubyte*, RPC_NS_HANDLE*);
    RPC_STATUS RpcNsProfileEltInqNextA(RPC_NS_HANDLE, RPC_IF_ID*, ubyte**,
      uint*, ubyte**);
    RPC_STATUS RpcNsProfileEltInqDone(RPC_NS_HANDLE*);
    RPC_STATUS RpcNsEntryObjectInqNext(RPC_NS_HANDLE, UUID*);
    RPC_STATUS RpcNsEntryObjectInqDone(RPC_NS_HANDLE*);
    RPC_STATUS RpcNsEntryExpandNameA(uint, ubyte*, ubyte**);
    RPC_STATUS RpcNsMgmtBindingUnexportA(uint, ubyte*, RPC_IF_ID*, uint,
      UUID_VECTOR*);
    RPC_STATUS RpcNsMgmtEntryCreateA(uint, ubyte*);
    RPC_STATUS RpcNsMgmtEntryDeleteA(uint, ubyte*);
    RPC_STATUS RpcNsMgmtEntryInqIfIdsA(uint, ubyte*, RPC_IF_ID_VECTOR**);
    RPC_STATUS RpcNsMgmtHandleSetExpAge(RPC_NS_HANDLE, uint);
    RPC_STATUS RpcNsMgmtInqExpAge(uint*);
    RPC_STATUS RpcNsMgmtSetExpAge(uint);
    RPC_STATUS RpcNsBindingImportNext(RPC_NS_HANDLE, RPC_BINDING_HANDLE*);
    RPC_STATUS RpcNsBindingImportDone(RPC_NS_HANDLE*);
    RPC_STATUS RpcNsBindingSelect(RPC_BINDING_VECTOR*, RPC_BINDING_HANDLE*);

version (Unicode) {
} else {
    RPC_STATUS RpcNsEntryObjectInqBeginA(uint, ubyte*, RPC_NS_HANDLE*);
    RPC_STATUS RpcNsBindingImportBeginA(uint, ubyte*, RPC_IF_HANDLE, UUID*,
      RPC_NS_HANDLE*);
}

    RPC_STATUS RpcNsBindingExportW(uint, ushort*, RPC_IF_HANDLE,
      RPC_BINDING_VECTOR*, UUID_VECTOR*);
    RPC_STATUS RpcNsBindingUnexportW(uint, ushort*, RPC_IF_HANDLE,
      UUID_VECTOR*);
    RPC_STATUS RpcNsBindingLookupBeginW(uint, ushort*, RPC_IF_HANDLE, UUID*,
      uint, RPC_NS_HANDLE*);
    RPC_STATUS RpcNsGroupDeleteW(uint, ushort*);
    RPC_STATUS RpcNsGroupMbrAddW(uint, ushort*, uint, ushort*);
    RPC_STATUS RpcNsGroupMbrRemoveW(uint, ushort*, uint, ushort*);
    RPC_STATUS RpcNsGroupMbrInqBeginW(uint, ushort*, uint, RPC_NS_HANDLE*);
    RPC_STATUS RpcNsGroupMbrInqNextW(RPC_NS_HANDLE, ushort**);
    RPC_STATUS RpcNsProfileDeleteW(uint, ushort*);
    RPC_STATUS RpcNsProfileEltAddW(uint, ushort*, RPC_IF_ID*, uint, ushort*,
      uint, ushort*);
    RPC_STATUS RpcNsProfileEltRemoveW(uint, ushort*, RPC_IF_ID*, uint,
      ushort*);
    RPC_STATUS RpcNsProfileEltInqBeginW(uint, ushort*, uint, RPC_IF_ID*,
      uint, uint, ushort*, RPC_NS_HANDLE*);
    RPC_STATUS RpcNsProfileEltInqNextW(RPC_NS_HANDLE, RPC_IF_ID*, ushort**,
      uint*, ushort**);
    RPC_STATUS RpcNsEntryObjectInqBeginW(uint, ushort*, RPC_NS_HANDLE*);
    RPC_STATUS RpcNsEntryExpandNameW(uint, ushort*, ushort**);
    RPC_STATUS RpcNsMgmtBindingUnexportW(uint, ushort*, RPC_IF_ID*, uint,
      UUID_VECTOR*);
    RPC_STATUS RpcNsMgmtEntryCreateW(uint, ushort*);
    RPC_STATUS RpcNsMgmtEntryDeleteW(uint, ushort*);
    RPC_STATUS RpcNsMgmtEntryInqIfIdsW(uint, ushort , RPC_IF_ID_VECTOR**);
    RPC_STATUS RpcNsBindingImportBeginW(uint, ushort*, RPC_IF_HANDLE, UUID*,
      RPC_NS_HANDLE*);
}

version (Unicode) {
    alias RpcNsBindingLookupBegin = RpcNsBindingLookupBeginW;
    alias RpcNsBindingImportBegin = RpcNsBindingImportBeginW;
    alias RpcNsBindingExport = RpcNsBindingExportW;
    alias RpcNsBindingUnexport = RpcNsBindingUnexportW;
    alias RpcNsGroupDelete = RpcNsGroupDeleteW;
    alias RpcNsGroupMbrAdd = RpcNsGroupMbrAddW;
    alias RpcNsGroupMbrRemove = RpcNsGroupMbrRemoveW;
    alias RpcNsGroupMbrInqBegin = RpcNsGroupMbrInqBeginW;
    alias RpcNsGroupMbrInqNext = RpcNsGroupMbrInqNextW;
    alias RpcNsEntryExpandName = RpcNsEntryExpandNameW;
    alias RpcNsEntryObjectInqBegin = RpcNsEntryObjectInqBeginW;
    alias RpcNsMgmtBindingUnexport = RpcNsMgmtBindingUnexportW;
    alias RpcNsMgmtEntryCreate = RpcNsMgmtEntryCreateW;
    alias RpcNsMgmtEntryDelete = RpcNsMgmtEntryDeleteW;
    alias RpcNsMgmtEntryInqIfIds = RpcNsMgmtEntryInqIfIdsW;
    alias RpcNsProfileDelete = RpcNsProfileDeleteW;
    alias RpcNsProfileEltAdd = RpcNsProfileEltAddW;
    alias RpcNsProfileEltRemove = RpcNsProfileEltRemoveW;
    alias RpcNsProfileEltInqBegin = RpcNsProfileEltInqBeginW;
    alias RpcNsProfileEltInqNext = RpcNsProfileEltInqNextW;
} else {
    alias RpcNsBindingLookupBegin = RpcNsBindingLookupBeginA;
    alias RpcNsBindingImportBegin = RpcNsBindingImportBeginA;
    alias RpcNsBindingExport = RpcNsBindingExportA;
    alias RpcNsBindingUnexport = RpcNsBindingUnexportA;
    alias RpcNsGroupDelete = RpcNsGroupDeleteA;
    alias RpcNsGroupMbrAdd = RpcNsGroupMbrAddA;
    alias RpcNsGroupMbrRemove = RpcNsGroupMbrRemoveA;
    alias RpcNsGroupMbrInqBegin = RpcNsGroupMbrInqBeginA;
    alias RpcNsGroupMbrInqNext = RpcNsGroupMbrInqNextA;
    alias RpcNsEntryExpandName = RpcNsEntryExpandNameA;
    alias RpcNsEntryObjectInqBegin = RpcNsEntryObjectInqBeginA;
    alias RpcNsMgmtBindingUnexport = RpcNsMgmtBindingUnexportA;
    alias RpcNsMgmtEntryCreate = RpcNsMgmtEntryCreateA;
    alias RpcNsMgmtEntryDelete = RpcNsMgmtEntryDeleteA;
    alias RpcNsMgmtEntryInqIfIds = RpcNsMgmtEntryInqIfIdsA;
    alias RpcNsProfileDelete = RpcNsProfileDeleteA;
    alias RpcNsProfileEltAdd = RpcNsProfileEltAddA;
    alias RpcNsProfileEltRemove = RpcNsProfileEltRemoveA;
    alias RpcNsProfileEltInqBegin = RpcNsProfileEltInqBeginA;
    alias RpcNsProfileEltInqNext = RpcNsProfileEltInqNextA;
}
