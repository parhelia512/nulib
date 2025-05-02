/**
    Windows API header module

    Translated from MinGW Windows headers

    License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
*/
module nulib.system.win32.objidl;
import nulib.system.win32.windef;
import nulib.system.win32.basetyps;
import nulib.system.win32.oleidl;
import nulib.system.win32.wtypes;
import nulib.system.win32.winbase; // for FILETIME
import nulib.system.win32.rpcdce;



enum STGM_DIRECT           = 0;
enum STGM_TRANSACTED       = 0x10000L;
enum STGM_SIMPLE           = 0x8000000L;
enum STGM_READ             = 0;
enum STGM_WRITE            = 1;
enum STGM_READWRITE        = 2;
enum STGM_SHARE_DENY_NONE  = 0x40;
enum STGM_SHARE_DENY_READ  = 0x30;
enum STGM_SHARE_DENY_WRITE = 0x20;
enum STGM_SHARE_EXCLUSIVE  = 0x10;
enum STGM_PRIORITY         = 0x40000L;
enum STGM_DELETEONRELEASE  = 0x4000000;
enum STGM_NOSCRATCH        = 0x100000;
enum STGM_CREATE           = 0x1000;
enum STGM_CONVERT          = 0x20000;
enum STGM_NOSNAPSHOT       = 0x200000;
enum STGM_FAILIFTHERE      = 0;

enum ASYNC_MODE_COMPATIBILITY = 1;
enum ASYNC_MODE_DEFAULT       = 0;

enum STGTY_REPEAT = 256;
enum STG_TOEND = 0xFFFFFFFF;
enum STG_LAYOUT_SEQUENTIAL  = 0;
enum STG_LAYOUT_INTERLEAVED = 1;

enum COM_RIGHTS_EXECUTE            = 1;
enum COM_RIGHTS_SAFE_FOR_SCRIPTING = 2;

enum STGOPTIONS_VERSION = 2;

enum STGFMT {
    STGFMT_STORAGE = 0,
    STGFMT_FILE = 3,
    STGFMT_ANY = 4,
    STGFMT_DOCFILE = 5
}

struct STGOPTIONS {
    USHORT usVersion;
    USHORT reserved;
    ULONG ulSectorSize;
    const(WCHAR)* pwcsTemplateFile;
}

enum REGCLS {
    REGCLS_SINGLEUSE = 0,
    REGCLS_MULTIPLEUSE = 1,
    REGCLS_MULTI_SEPARATE = 2
}

struct STATSTG {
    LPOLESTR pwcsName;
    DWORD type;
    ULARGE_INTEGER cbSize;
    FILETIME mtime;
    FILETIME ctime;
    FILETIME atime;
    DWORD grfMode;
    DWORD grfLocksSupported;
    CLSID clsid;
    DWORD grfStateBits;
    DWORD reserved;
}

enum STGTY {
    STGTY_STORAGE = 1,
    STGTY_STREAM,
    STGTY_LOCKBYTES,
    STGTY_PROPERTY
}

enum STREAM_SEEK {
    STREAM_SEEK_SET,
    STREAM_SEEK_CUR,
    STREAM_SEEK_END
}

struct INTERFACEINFO {
    LPUNKNOWN pUnk;
    IID iid;
    WORD wMethod;
}

alias LPINTERFACEINFO = INTERFACEINFO*;

enum CALLTYPE {
    CALLTYPE_TOPLEVEL = 1,
    CALLTYPE_NESTED,
    CALLTYPE_ASYNC,
    CALLTYPE_TOPLEVEL_CALLPENDING,
    CALLTYPE_ASYNC_CALLPENDING
}

enum PENDINGTYPE {
    PENDINGTYPE_TOPLEVEL = 1,
    PENDINGTYPE_NESTED
}

enum PENDINGMSG {
    PENDINGMSG_CANCELCALL = 0,
    PENDINGMSG_WAITNOPROCESS,
    PENDINGMSG_WAITDEFPROCESS
}

alias SNB = OLECHAR**;

enum DATADIR {
    DATADIR_GET = 1,
    DATADIR_SET
}

alias CLIPFORMAT = WORD;
alias LPCLIPFORMAT = CLIPFORMAT*;

struct DVTARGETDEVICE {
    DWORD tdSize;
    WORD tdDriverNameOffset;
    WORD tdDeviceNameOffset;
    WORD tdPortNameOffset;
    WORD tdExtDevmodeOffset;
    BYTE[1] tdData;
}

struct FORMATETC {
    CLIPFORMAT cfFormat;
    DVTARGETDEVICE* ptd;
    DWORD dwAspect;
    LONG lindex;
    DWORD tymed;
}

alias LPFORMATETC = FORMATETC*;

struct RemSTGMEDIUM {
    DWORD tymed;
    DWORD dwHandleType;
    ULONG pData;
    uint pUnkForRelease;
    uint cbData;
    BYTE[1] data;
}

struct HLITEM {
    ULONG uHLID;
    LPWSTR pwzFriendlyName;
}

struct STATDATA {
    FORMATETC formatetc;
    DWORD grfAdvf;
    IAdviseSink pAdvSink;
    DWORD dwConnection;
}

struct STATPROPSETSTG {
    FMTID fmtid;
    CLSID clsid;
    DWORD grfFlags;
    FILETIME mtime;
    FILETIME ctime;
    FILETIME atime;
}

enum EXTCONN {
    EXTCONN_STRONG = 1,
    EXTCONN_WEAK = 2,
    EXTCONN_CALLABLE = 4
}

struct MULTI_QI {
    const(IID)* pIID;
    IUnknown pItf;
    HRESULT hr;
}

struct AUTH_IDENTITY {
    USHORT* User;
    ULONG UserLength;
    USHORT* Domain;
    ULONG DomainLength;
    USHORT* Password;
    ULONG PasswordLength;
    ULONG Flags;
}

struct COAUTHINFO {
    DWORD dwAuthnSvc;
    DWORD dwAuthzSvc;
    LPWSTR pwszServerPrincName;
    DWORD dwAuthnLevel;
    DWORD dwImpersonationLevel;
    AUTH_IDENTITY* pAuthIdentityData;
    DWORD dwCapabilities;
}

struct COSERVERINFO {
    DWORD dwReserved1;
    LPWSTR pwszName;
    COAUTHINFO* pAuthInfo;
    DWORD dwReserved2;
}

struct BIND_OPTS {
    DWORD cbStruct;
    DWORD grfFlags;
    DWORD grfMode;
    DWORD dwTickCountDeadline;
}

alias LPBIND_OPTS = BIND_OPTS*;

struct BIND_OPTS2 {
    DWORD cbStruct;
    DWORD grfFlags;
    DWORD grfMode;
    DWORD dwTickCountDeadline;
    DWORD dwTrackFlags;
    DWORD dwClassContext;
    LCID locale;
    COSERVERINFO* pServerInfo;
}

alias LPBIND_OPTS2 = BIND_OPTS2*;

enum BIND_FLAGS {
    BIND_MAYBOTHERUSER = 1,
    BIND_JUSTTESTEXISTENCE
}

struct STGMEDIUM {
    DWORD tymed;
    union {
        HBITMAP hBitmap;
        PVOID hMetaFilePict;
        HENHMETAFILE hEnhMetaFile;
        HGLOBAL hGlobal;
        LPWSTR lpszFileName;
        LPSTREAM pstm;
        LPSTORAGE pstg;
    }

    LPUNKNOWN pUnkForRelease;
}

alias LPSTGMEDIUM = STGMEDIUM*;

enum LOCKTYPE {
    LOCK_WRITE = 1,
    LOCK_EXCLUSIVE = 2,
    LOCK_ONLYONCE = 4
}

alias RPCOLEDATAREP = uint;

struct RPCOLEMESSAGE {
    PVOID reserved1;
    RPCOLEDATAREP dataRepresentation;
    PVOID Buffer;
    ULONG cbBuffer;
    ULONG iMethod;
    PVOID[5] reserved2;
    ULONG rpcFlags;
}

alias PRPCOLEMESSAGE = RPCOLEMESSAGE*;

enum MKSYS {
    MKSYS_NONE,
    MKSYS_GENERICCOMPOSITE,
    MKSYS_FILEMONIKER,
    MKSYS_ANTIMONIKER,
    MKSYS_ITEMMONIKER,
    MKSYS_POINTERMONIKER
}

enum MKREDUCE {
    MKRREDUCE_ALL,
    MKRREDUCE_ONE = 196608,
    MKRREDUCE_TOUSER = 131072,
    MKRREDUCE_THROUGHUSER = 65536
}

struct RemSNB {
    uint ulCntStr;
    uint ulCntChar;
    OLECHAR[1] rgString = 0;
}

enum ADVF {
    ADVF_NODATA = 1,
    ADVF_PRIMEFIRST = 2,
    ADVF_ONLYONCE = 4,
    ADVFCACHE_NOHANDLER = 8,
    ADVFCACHE_FORCEBUILTIN = 16,
    ADVFCACHE_ONSAVE = 32,
    ADVF_DATAONSTOP = 64
}

enum TYMED {
    TYMED_HGLOBAL = 1,
    TYMED_FILE = 2,
    TYMED_ISTREAM = 4,
    TYMED_ISTORAGE = 8,
    TYMED_GDI = 16,
    TYMED_MFPICT = 32,
    TYMED_ENHMF = 64,
    TYMED_NULL = 0
}

enum SERVERCALL {
    SERVERCALL_ISHANDLED,
    SERVERCALL_REJECTED,
    SERVERCALL_RETRYLATER
}

struct CAUB {
    ULONG cElems;
    ubyte* pElems;
}

struct CAI {
    ULONG cElems;
    short* pElems;
}

struct CAUI {
    ULONG cElems;
    USHORT* pElems;
}

struct CAL {
    ULONG cElems;
    int* pElems;
}

struct CAUL {
    ULONG cElems;
    ULONG* pElems;
}

struct CAFLT {
    ULONG cElems;
    float* pElems;
}

struct CADBL {
    ULONG cElems;
    double* pElems;
}

struct CACY {
    ULONG cElems;
    CY* pElems;
}

struct CADATE {
    ULONG cElems;
    DATE* pElems;
}

struct CABSTR {
    ULONG cElems;
    BSTR* pElems;
}

struct CABSTRBLOB {
    ULONG cElems;
    BSTRBLOB* pElems;
}

struct CABOOL {
    ULONG cElems;
    VARIANT_BOOL* pElems;
}

struct CASCODE {
    ULONG cElems;
    SCODE* pElems;
}

struct CAH {
    ULONG cElems;
    LARGE_INTEGER* pElems;
}

struct CAUH {
    ULONG cElems;
    ULARGE_INTEGER* pElems;
}

struct CALPSTR {
    ULONG cElems;
    LPSTR* pElems;
}

struct CALPWSTR {
    ULONG cElems;
    LPWSTR* pElems;
}

struct CAFILETIME {
    ULONG cElems;
    FILETIME* pElems;
}

struct CACLIPDATA {
    ULONG cElems;
    CLIPDATA* pElems;
}

struct CACLSID {
    ULONG cElems;
    CLSID* pElems;
}

alias LPPROPVARIANT = PROPVARIANT*;

struct CAPROPVARIANT {
    ULONG cElems;
    LPPROPVARIANT pElems;
}

struct PROPVARIANT {
    VARTYPE vt;
    WORD wReserved1;
    WORD wReserved2;
    WORD wReserved3;
    union {
        CHAR cVal = 0;
        UCHAR bVal;
        short iVal;
        USHORT uiVal;
        VARIANT_BOOL boolVal;
        int lVal;
        ULONG ulVal;
        float fltVal;
        SCODE scode;
        LARGE_INTEGER hVal;
        ULARGE_INTEGER uhVal;
        double dblVal;
        CY cyVal;
        DATE date;
        FILETIME filetime;
        CLSID* puuid;
        BLOB blob;
        CLIPDATA* pclipdata;
        LPSTREAM pStream;
        LPSTORAGE pStorage;
        BSTR bstrVal;
        BSTRBLOB bstrblobVal;
        LPSTR pszVal;
        LPWSTR pwszVal;
        CAUB caub;
        CAI cai;
        CAUI caui;
        CABOOL cabool;
        CAL cal;
        CAUL caul;
        CAFLT caflt;
        CASCODE cascode;
        CAH cah;
        CAUH cauh;
        CADBL cadbl;
        CACY cacy;
        CADATE cadate;
        CAFILETIME cafiletime;
        CACLSID cauuid;
        CACLIPDATA caclipdata;
        CABSTR cabstr;
        CABSTRBLOB cabstrblob;
        CALPSTR calpstr;
        CALPWSTR calpwstr;
        CAPROPVARIANT capropvar;
    }
}

struct PROPSPEC {
    ULONG ulKind;
    union {
        PROPID propid;
        LPOLESTR lpwstr;
    }
}

struct STATPROPSTG {
    LPOLESTR lpwstrName;
    PROPID propid;
    VARTYPE vt;
}

enum PROPSETFLAG {
    PROPSETFLAG_DEFAULT,
    PROPSETFLAG_NONSIMPLE,
    PROPSETFLAG_ANSI,
    PROPSETFLAG_UNBUFFERED = 4
}

struct STORAGELAYOUT {
    DWORD LayoutType;
    OLECHAR* pwcsElementName;
    LARGE_INTEGER cOffset;
    LARGE_INTEGER cBytes;
}

struct SOLE_AUTHENTICATION_SERVICE {
    DWORD dwAuthnSvc;
    DWORD dwAuthzSvc;
    OLECHAR* pPrincipalName;
    HRESULT hr;
}

enum OLECHAR* COLE_DEFAULT_PRINCIPAL = cast(OLECHAR*)(-1);

enum EOLE_AUTHENTICATION_CAPABILITIES {
    EOAC_NONE = 0,
    EOAC_MUTUAL_AUTH = 0x1,
    EOAC_SECURE_REFS = 0x2,
    EOAC_ACCESS_CONTROL = 0x4,
    EOAC_APPID = 0x8,
    EOAC_DYNAMIC = 0x10,
    EOAC_STATIC_CLOAKING = 0x20,
    EOAC_DYNAMIC_CLOAKING = 0x40,
    EOAC_ANY_AUTHORITY = 0x80,
    EOAC_MAKE_FULLSIC = 0x100,
    EOAC_REQUIRE_FULLSIC = 0x200,
    EOAC_AUTO_IMPERSONATE = 0x400,
    EOAC_DEFAULT = 0x800,
    EOAC_DISABLE_AAA = 0x1000,
    EOAC_NO_CUSTOM_MARSHAL = 0x2000
}

struct SOLE_AUTHENTICATION_INFO {
    DWORD dwAuthnSvc;
    DWORD dwAuthzSvc;
    void* pAuthInfo;
}

enum void* COLE_DEFAULT_AUTHINFO = cast(void*)(-1);

struct SOLE_AUTHENTICATION_LIST {
    DWORD cAuthInfo;
    SOLE_AUTHENTICATION_INFO* aAuthInfo;
}

alias LPENUMFORMATETC = IEnumFORMATETC;
@Guid!("00000103-0000-0000-C000-000000000046")
interface IEnumFORMATETC : IUnknown {
    HRESULT Next(ULONG, FORMATETC*, ULONG*);
    HRESULT Skip(ULONG);
    HRESULT Reset();
    HRESULT Clone(IEnumFORMATETC*);
}

alias LPENUMHLITEM = IEnumHLITEM;
@Guid!("79eac9c6-baf9-11ce-8c82-00aa004ba90b")
interface IEnumHLITEM : IUnknown {
    HRESULT Next(ULONG, HLITEM*, ULONG*);
    HRESULT Skip(ULONG);
    HRESULT Reset();
    HRESULT Clone(IEnumHLITEM*);
}

alias LPENUMSTATDATA = IEnumSTATDATA;
@Guid!("00000105-0000-0000-C000-000000000046")
interface IEnumSTATDATA : IUnknown {
    HRESULT Next(ULONG, STATDATA*, ULONG*);
    HRESULT Skip(ULONG);
    HRESULT Reset();
    HRESULT Clone(IEnumSTATDATA*);
}

alias LPENUMSTATSTG = IEnumSTATSTG;
@Guid!("0000000d-0000-0000-C000-000000000046")
interface IEnumSTATSTG : IUnknown {
    HRESULT Next(ULONG, STATSTG*, ULONG*);
    HRESULT Skip(ULONG);
    HRESULT Reset();
    HRESULT Clone(IEnumSTATSTG*);
}

alias LPENUMSTATPROPSETSTG = IEnumSTATPROPSETSTG;
@Guid!("0000013B-0000-0000-C000-000000000046")
interface IEnumSTATPROPSETSTG : IUnknown {
    HRESULT Next(ULONG, STATPROPSETSTG*, ULONG*);
    HRESULT Skip(ULONG);
    HRESULT Reset();
    HRESULT Clone(IEnumSTATPROPSETSTG*);
}

alias LPENUMSTATPROPSTG = IEnumSTATPROPSTG;
@Guid!("00000139-0000-0000-C000-000000000046")
interface IEnumSTATPROPSTG : IUnknown {
    HRESULT Next(ULONG, STATPROPSTG*, ULONG*);
    HRESULT Skip(ULONG);
    HRESULT Reset();
    HRESULT Clone(IEnumSTATPROPSTG*);
}

alias LPENUMSTRING = IEnumString;
@Guid!("00000101-0000-0000-C000-000000000046")
interface IEnumString : IUnknown {
    HRESULT Next(ULONG, LPOLESTR*, ULONG*);
    HRESULT Skip(ULONG);
    HRESULT Reset();
    HRESULT Clone(IEnumString*);
}

alias LPENUMMONIKER = IEnumMoniker;
@Guid!("00000102-0000-0000-C000-000000000046")
interface IEnumMoniker : IUnknown {
    HRESULT Next(ULONG, IMoniker*, ULONG*);
    HRESULT Skip(ULONG);
    HRESULT Reset();
    HRESULT Clone(IEnumMoniker*);
}

alias LPENUMUNKNOWN = IEnumUnknown;
@Guid!("00000100-0000-0000-C000-000000000046")
interface IEnumUnknown : IUnknown {
    HRESULT Next(ULONG, IUnknown*, ULONG*);
    HRESULT Skip(ULONG);
    HRESULT Reset();
    HRESULT Clone(IEnumUnknown*);
}

alias LPSEQUENTIALSTREAM = ISequentialStream;
@Guid!("0c733a30-2a1c-11ce-ade5-00aa0044773d")
interface ISequentialStream : IUnknown {
    HRESULT Read(void*, ULONG, ULONG*);
    HRESULT Write(void*, ULONG, ULONG*);
}

alias LPSTREAM = IStream;
@Guid!("0000000c-0000-0000-C000-000000000046")
interface IStream : ISequentialStream {
    HRESULT Seek(LARGE_INTEGER, DWORD, ULARGE_INTEGER*);
    HRESULT SetSize(ULARGE_INTEGER);
    HRESULT CopyTo(IStream, ULARGE_INTEGER, ULARGE_INTEGER*, ULARGE_INTEGER*);
    HRESULT Commit(DWORD);
    HRESULT Revert();
    HRESULT LockRegion(ULARGE_INTEGER, ULARGE_INTEGER, DWORD);
    HRESULT UnlockRegion(ULARGE_INTEGER, ULARGE_INTEGER, DWORD);
    HRESULT Stat(STATSTG*, DWORD);
    HRESULT Clone(LPSTREAM*);
}

alias LPMARSHAL = IMarshal;
@Guid!("00000003-0000-0000-C000-000000000046")
interface IMarshal : IUnknown {
    HRESULT GetUnmarshalClass(REFIID, PVOID, DWORD, PVOID, DWORD, CLSID*);
    HRESULT GetMarshalSizeMax(REFIID, PVOID, DWORD, PVOID, DWORD, ULONG*);
    HRESULT MarshalInterface(IStream, REFIID, PVOID, DWORD, PVOID, DWORD);
    HRESULT UnmarshalInterface(IStream, REFIID, void**);
    HRESULT ReleaseMarshalData(IStream);
    HRESULT DisconnectObject(DWORD);
}

alias LPSTDMARSHALINFO = IStdMarshalInfo;
@Guid!("00000018-0000-0000-C000-000000000046")
interface IStdMarshalInfo : IUnknown {
    HRESULT GetClassForHandler(DWORD, PVOID, CLSID*);
}

alias LPMALLOC = IMalloc;
@Guid!("00000002-0000-0000-C000-000000000046")
interface IMalloc : IUnknown {
    void* Alloc(SIZE_T);
    void* Realloc(void*, SIZE_T);
    void Free(void*);
    SIZE_T GetSize(void*);
    int DidAlloc(void*);
    void HeapMinimize();
}

alias LPMALLOCSPY = IMallocSpy;
@Guid!("0000001d-0000-0000-C000-000000000046")
interface IMallocSpy : IUnknown {
    SIZE_T PreAlloc(SIZE_T);
    void* PostAlloc(void*);
    void* PreFree(void*, BOOL);
    void PostFree(BOOL);
    SIZE_T PreRealloc(void*, SIZE_T, void**, BOOL);
    void* PostRealloc(void*, BOOL);
    void* PreGetSize(void*, BOOL);
    SIZE_T PostGetSize(SIZE_T, BOOL);
    void* PreDidAlloc(void*, BOOL);
    int PostDidAlloc(void*, BOOL, int);
    void PreHeapMinimize();
    void PostHeapMinimize();
}

alias LPMESSAGEFILTER = IMessageFilter;
@Guid!("00000016-0000-0000-C000-000000000046")
interface IMessageFilter : IUnknown {
    DWORD HandleInComingCall(DWORD, HTASK, DWORD, LPINTERFACEINFO);
    DWORD RetryRejectedCall(HTASK, DWORD, DWORD);
    DWORD MessagePending(HTASK, DWORD, DWORD);
}

alias LPPERSIST = IPersist;
@Guid!("0000010c-0000-0000-C000-000000000046")
interface IPersist : IUnknown {
    HRESULT GetClassID(CLSID*);
}

alias LPPERSISTSTREAM = IPersistStream;
@Guid!("00000109-0000-0000-C000-000000000046")
interface IPersistStream : IPersist {
    HRESULT IsDirty();
    HRESULT Load(IStream);
    HRESULT Save(IStream, BOOL);
    HRESULT GetSizeMax(PULARGE_INTEGER);
}

alias LPRUNNINGOBJECTTABLE = IRunningObjectTable;
@Guid!("00000010-0000-0000-C000-000000000046")
interface IRunningObjectTable : IUnknown {
    HRESULT Register(DWORD, LPUNKNOWN, LPMONIKER, PDWORD);
    HRESULT Revoke(DWORD);
    HRESULT IsRunning(LPMONIKER);
    HRESULT GetObject(LPMONIKER, LPUNKNOWN*);
    HRESULT NoteChangeTime(DWORD, LPFILETIME);
    HRESULT GetTimeOfLastChange(LPMONIKER, LPFILETIME);
    HRESULT EnumRunning(IEnumMoniker*);
}

alias LPBINDCTX = IBindCtx;
@Guid!("0000000e-0000-0000-C000-000000000046")
interface IBindCtx : IUnknown {
    HRESULT RegisterObjectBound(LPUNKNOWN);
    HRESULT RevokeObjectBound(LPUNKNOWN);
    HRESULT ReleaseBoundObjects();
    HRESULT SetBindOptions(LPBIND_OPTS);
    HRESULT GetBindOptions(LPBIND_OPTS);
    HRESULT GetRunningObjectTable(IRunningObjectTable*);
    HRESULT RegisterObjectParam(LPOLESTR, IUnknown);
    HRESULT GetObjectParam(LPOLESTR, IUnknown*);
    HRESULT EnumObjectParam(IEnumString*);
    HRESULT RevokeObjectParam(LPOLESTR);
}

alias LPMONIKER = IMoniker;
@Guid!("0000000f-0000-0000-C000-000000000046")
interface IMoniker : IPersistStream {
    HRESULT BindToObject(IBindCtx, IMoniker, REFIID, PVOID*);
    HRESULT BindToStorage(IBindCtx, IMoniker, REFIID, PVOID*);
    HRESULT Reduce(IBindCtx, DWORD, IMoniker*, IMoniker*);
    HRESULT ComposeWith(IMoniker, BOOL, IMoniker*);
    HRESULT Enum(BOOL, IEnumMoniker*);
    HRESULT IsEqual(IMoniker);
    HRESULT Hash(PDWORD);
    HRESULT IsRunning(IBindCtx, IMoniker, IMoniker);
    HRESULT GetTimeOfLastChange(IBindCtx, IMoniker, LPFILETIME);
    HRESULT Inverse(IMoniker*);
    HRESULT CommonPrefixWith(IMoniker, IMoniker*);
    HRESULT RelativePathTo(IMoniker, IMoniker*);
    HRESULT GetDisplayName(IBindCtx, IMoniker, LPOLESTR*);
    HRESULT ParseDisplayName(IBindCtx, IMoniker, LPOLESTR, ULONG*, IMoniker*);
    HRESULT IsSystemMoniker(PDWORD);
}

alias LPPERSISTSTORAGE = IPersistStorage;
@Guid!("0000010a-0000-0000-C000-000000000046")
interface IPersistStorage : IPersist {
    HRESULT IsDirty();
    HRESULT InitNew(LPSTORAGE);
    HRESULT Load(LPSTORAGE);
    HRESULT Save(LPSTORAGE, BOOL);
    HRESULT SaveCompleted(LPSTORAGE);
    HRESULT HandsOffStorage();
}

alias LPPERSISTFILE = IPersistFile;
@Guid!("0000010b-0000-0000-C000-000000000046")
interface IPersistFile : IPersist {
    HRESULT IsDirty();
    HRESULT Load(LPCOLESTR, DWORD);
    HRESULT Save(LPCOLESTR, BOOL);
    HRESULT SaveCompleted(LPCOLESTR);
    HRESULT GetCurFile(LPOLESTR*);
}

// Async UUID: 00000150-0000-0000-C000-000000000046
alias LPADVISESINK = IAdviseSink;
@Guid!("0000010f-0000-0000-C000-000000000046")
interface IAdviseSink : IUnknown {
    HRESULT QueryInterface(REFIID, PVOID*);
    ULONG AddRef();
    ULONG Release();
    void OnDataChange(FORMATETC*, STGMEDIUM*);
    void OnViewChange(DWORD, LONG);
    void OnRename(IMoniker);
    void OnSave();
    void OnClose();
}

// Async UUID: 00000150-0000-0000-C000-000000000046
alias LPADVISESINK2 = IAdviseSink2;
@Guid!("00000151-0000-0000-C000-000000000046")
interface IAdviseSink2 : IAdviseSink {
    void OnLinkSrcChange(IMoniker);
}

alias LPDATAOBJECT = IDataObject;
@Guid!("0000010e-0000-0000-C000-000000000046")
interface IDataObject : IUnknown {
    HRESULT GetData(FORMATETC*, STGMEDIUM*);
    HRESULT GetDataHere(FORMATETC*, STGMEDIUM*);
    HRESULT QueryGetData(FORMATETC*);
    HRESULT GetCanonicalFormatEtc(FORMATETC*, FORMATETC*);
    HRESULT SetData(FORMATETC*, STGMEDIUM*, BOOL);
    HRESULT EnumFormatEtc(DWORD, IEnumFORMATETC*);
    HRESULT DAdvise(FORMATETC*, DWORD, IAdviseSink, PDWORD);
    HRESULT DUnadvise(DWORD);
    HRESULT EnumDAdvise(IEnumSTATDATA*);
}

alias LPDATAADVISEHOLDER = IDataAdviseHolder;
@Guid!("00000110-0000-0000-C000-000000000046")
interface IDataAdviseHolder : IUnknown {
    HRESULT Advise(IDataObject, FORMATETC*, DWORD, IAdviseSink, PDWORD);
    HRESULT Unadvise(DWORD);
    HRESULT EnumAdvise(IEnumSTATDATA*);
    HRESULT SendOnDataChange(IDataObject, DWORD, DWORD);
}

alias LPSTORAGE = IStorage;
@Guid!("0000000b-0000-0000-C000-000000000046")
interface IStorage : IUnknown {
    HRESULT CreateStream(LPCWSTR, DWORD, DWORD, DWORD, IStream);
    HRESULT OpenStream(LPCWSTR, PVOID, DWORD, DWORD, IStream);
    HRESULT CreateStorage(LPCWSTR, DWORD, DWORD, DWORD, IStorage);
    HRESULT OpenStorage(LPCWSTR, IStorage, DWORD, SNB, DWORD, IStorage);
    HRESULT CopyTo(DWORD, IID*, SNB, IStorage);
    HRESULT MoveElementTo(LPCWSTR, IStorage, LPCWSTR, DWORD);
    HRESULT Commit(DWORD);
    HRESULT Revert();
    HRESULT EnumElements(DWORD, PVOID, DWORD, IEnumSTATSTG);
    HRESULT DestroyElement(LPCWSTR);
    HRESULT RenameElement(LPCWSTR, LPCWSTR);
    HRESULT SetElementTimes(LPCWSTR, FILETIME*, FILETIME*, FILETIME*);
    HRESULT SetClass(REFCLSID);
    HRESULT SetStateBits(DWORD, DWORD);
    HRESULT Stat(STATSTG*, DWORD);
}

// FIXME: GetClassID from IPersist not there - what to do about it?
alias LPROOTSTORAGE = IRootStorage;
@Guid!("00000012-0000-0000-C000-000000000046")
interface IRootStorage : IPersist {
    HRESULT QueryInterface(REFIID, PVOID*);
    ULONG AddRef();
    ULONG Release();
    HRESULT SwitchToFile(LPOLESTR);
}

alias LPRPCCHANNELBUFFER = IRpcChannelBuffer;
@Guid!("D5F56B60-593B-101A-B569-08002B2DBF7A")
interface IRpcChannelBuffer : IUnknown {
    HRESULT GetBuffer(RPCOLEMESSAGE*, REFIID);
    HRESULT SendReceive(RPCOLEMESSAGE*, PULONG);
    HRESULT FreeBuffer(RPCOLEMESSAGE*);
    HRESULT GetDestCtx(PDWORD, PVOID*);
    HRESULT IsConnected();
}

alias LPRPCPROXYBUFFER = IRpcProxyBuffer;
@Guid!("D5F56A34-593B-101A-B569-08002B2DBF7A")
interface IRpcProxyBuffer : IUnknown {
    HRESULT Connect(IRpcChannelBuffer);
    void Disconnect();
}

alias LPRPCSTUBBUFFER = IRpcStubBuffer;
@Guid!("D5F56AFC-593B-101A-B569-08002B2DBF7A")
interface IRpcStubBuffer : IUnknown {
    HRESULT Connect(LPUNKNOWN);
    void Disconnect();
    HRESULT Invoke(RPCOLEMESSAGE*, LPRPCSTUBBUFFER);
    LPRPCSTUBBUFFER IsIIDSupported(REFIID);
    ULONG CountRefs();
    HRESULT DebugServerQueryInterface(PVOID*);
    HRESULT DebugServerRelease(PVOID);
}

alias LPPSFACTORYBUFFER = IPSFactoryBuffer;
@Guid!("D5F569D0-593B-101A-B569-08002B2DBF7A")
interface IPSFactoryBuffer : IUnknown {
    HRESULT CreateProxy(LPUNKNOWN, REFIID, LPRPCPROXYBUFFER*, PVOID*);
    HRESULT CreateStub(REFIID, LPUNKNOWN, LPRPCSTUBBUFFER*);
}

alias LPLOCKBYTES = ILockBytes;
@Guid!("0000000a-0000-0000-C000-000000000046")
interface ILockBytes : IUnknown {
    HRESULT ReadAt(ULARGE_INTEGER, PVOID, ULONG, ULONG*);
    HRESULT WriteAt(ULARGE_INTEGER, PCVOID, ULONG, ULONG*);
    HRESULT Flush();
    HRESULT SetSize(ULARGE_INTEGER);
    HRESULT LockRegion(ULARGE_INTEGER, ULARGE_INTEGER, DWORD);
    HRESULT UnlockRegion(ULARGE_INTEGER, ULARGE_INTEGER, DWORD);
    HRESULT Stat(STATSTG*, DWORD);
}

alias LPEXTERNALCONNECTION = IExternalConnection;
@Guid!("00000019-0000-0000-C000-000000000046")
interface IExternalConnection : IUnknown {
    HRESULT AddConnection(DWORD, DWORD);
    HRESULT ReleaseConnection(DWORD, DWORD, BOOL);
}

alias LPRUNNABLEOBJECT = IRunnableObject;
@Guid!("00000126-0000-0000-C000-000000000046")
interface IRunnableObject : IUnknown {
    HRESULT GetRunningClass(LPCLSID);
    HRESULT Run(LPBINDCTX);
    BOOL IsRunning();
    HRESULT LockRunning(BOOL, BOOL);
    HRESULT SetContainedObject(BOOL);
}

alias LPROTDATA = IROTData;
@Guid!("f29f6bc0-5021-11ce-aa15-00006901293f")
interface IROTData : IUnknown {
    HRESULT GetComparisonData(PVOID, ULONG, PULONG);
}

alias LPCHANNELHOOK = IChannelHook;
@Guid!("1008c4a0-7613-11cf-9af1-0020af6e72f4")
interface IChannelHook : IUnknown {
    void ClientGetSize(REFGUID, REFIID, PULONG);
    void ClientFillBuffer(REFGUID, REFIID, PULONG, PVOID);
    void ClientNotify(REFGUID, REFIID, ULONG, PVOID, DWORD, HRESULT);
    void ServerNotify(REFGUID, REFIID, ULONG, PVOID, DWORD);
    void ServerGetSize(REFGUID, REFIID, HRESULT, PULONG);
    void ServerFillBuffer(REFGUID, REFIID, PULONG, PVOID, HRESULT);
}

alias LPPROPERTYSTORAGE = IPropertyStorage;
@Guid!("00000138-0000-0000-C000-000000000046")
interface IPropertyStorage : IUnknown {
    HRESULT ReadMultiple(ULONG, PROPSPEC*, PROPVARIANT*);
    HRESULT WriteMultiple(ULONG, PROPSPEC*, PROPVARIANT*, PROPID);
    HRESULT DeleteMultiple(ULONG, PROPSPEC*);
    HRESULT ReadPropertyNames(ULONG, PROPID*, LPWSTR*);
    HRESULT WritePropertyNames(ULONG, PROPID*, LPWSTR*);
    HRESULT DeletePropertyNames(ULONG, PROPID*);
    HRESULT SetClass(REFCLSID);
    HRESULT Commit(DWORD);
    HRESULT Revert();
    HRESULT Enum(IEnumSTATPROPSTG*);
    HRESULT Stat(STATPROPSTG*);
    HRESULT SetTimes(FILETIME*, FILETIME*, FILETIME*);
}

alias LPPROPERTYSETSTORAGE = IPropertySetStorage;
@Guid!("0000013A-0000-0000-C000-000000000046")
interface IPropertySetStorage : IUnknown {
    HRESULT Create(REFFMTID, CLSID*, DWORD, DWORD, LPPROPERTYSTORAGE*);
    HRESULT Open(REFFMTID, DWORD, LPPROPERTYSTORAGE*);
    HRESULT Delete(REFFMTID);
    HRESULT Enum(IEnumSTATPROPSETSTG*);
}

alias LPCLIENTSECURITY = IClientSecurity;
@Guid!("0000013D-0000-0000-C000-000000000046")
interface IClientSecurity : IUnknown {
    HRESULT QueryBlanket(PVOID, PDWORD, PDWORD, OLECHAR**, PDWORD, PDWORD, RPC_AUTH_IDENTITY_HANDLE**, PDWORD*);
    HRESULT SetBlanket(PVOID, DWORD, DWORD, LPWSTR, DWORD, DWORD, RPC_AUTH_IDENTITY_HANDLE*, DWORD);
    HRESULT CopyProxy(LPUNKNOWN, LPUNKNOWN*);
}

alias LPSERVERSECURITY = IServerSecurity;
@Guid!("0000013E-0000-0000-C000-000000000046")
interface IServerSecurity : IUnknown {
    HRESULT QueryBlanket(PDWORD, PDWORD, OLECHAR**, PDWORD, PDWORD, RPC_AUTHZ_HANDLE*, PDWORD*);
    HRESULT ImpersonateClient();
    HRESULT RevertToSelf();
    HRESULT IsImpersonating();
}

alias LPCLASSACTIVATOR = IClassActivator;
@Guid!("00000140-0000-0000-C000-000000000046")
interface IClassActivator : IUnknown {
    HRESULT GetClassObject(REFCLSID, DWORD, LCID, REFIID, PVOID*);
}

alias LPFILLLOCKBYTES = IFillLockBytes;
@Guid!("99caf010-415e-11cf-8814-00aa00b569f5")
interface IFillLockBytes : IUnknown {
    HRESULT FillAppend(void*, ULONG, PULONG);
    HRESULT FillAt(ULARGE_INTEGER, void*, ULONG, PULONG);
    HRESULT SetFillSize(ULARGE_INTEGER);
    HRESULT Terminate(BOOL);
}

alias LPPROGRESSNOTIFY = IProgressNotify;
@Guid!("a9d758a0-4617-11cf-95fc-00aa00680db4")
interface IProgressNotify : IUnknown {
    HRESULT OnProgress(DWORD, DWORD, BOOL, BOOL);
}

alias LPLAYOUTSTORAGE = ILayoutStorage;
@Guid!("0e6d4d90-6738-11cf-9608-00aa00680db4")
interface ILayoutStorage : IUnknown {
    HRESULT LayoutScript(STORAGELAYOUT*, DWORD, DWORD);
    HRESULT BeginMonitor();
    HRESULT EndMonitor();
    HRESULT ReLayoutDocfile(OLECHAR*);
}

alias LPGLOBALINTERFACETABLE = IGlobalInterfaceTable;
@Guid!("00000146-0000-0000-C000-000000000046")
interface IGlobalInterfaceTable : IUnknown {
    HRESULT RegisterInterfaceInGlobal(IUnknown, REFIID, DWORD*);
    HRESULT RevokeInterfaceFromGlobal(DWORD);
    HRESULT GetInterfaceFromGlobal(DWORD, REFIID, void**);
}

extern(Windows) @nogc nothrow:

HRESULT CoGetClassObject(REFCLSID, DWORD, COSERVERINFO*, REFIID, PVOID*);
HRESULT CoRegisterClassObject(REFCLSID, LPUNKNOWN, DWORD, DWORD, PDWORD);
HRESULT CoRevokeClassObject(DWORD);
HRESULT CoGetMarshalSizeMax(ULONG*, REFIID, LPUNKNOWN, DWORD, PVOID, DWORD);
HRESULT CoMarshalInterface(LPSTREAM, REFIID, LPUNKNOWN, DWORD, PVOID, DWORD);
HRESULT CoUnmarshalInterface(LPSTREAM, REFIID, PVOID*);
HRESULT CoMarshalHresult(LPSTREAM, HRESULT);
HRESULT CoUnmarshalHresult(LPSTREAM, HRESULT*);
HRESULT CoReleaseMarshalData(LPSTREAM);
HRESULT CoDisconnectObject(LPUNKNOWN, DWORD);
HRESULT CoLockObjectExternal(LPUNKNOWN, BOOL, BOOL);
HRESULT CoGetStandardMarshal(REFIID, LPUNKNOWN, DWORD, PVOID, DWORD, LPMARSHAL*);
HRESULT CoGetStdMarshalEx(LPUNKNOWN, DWORD, LPUNKNOWN*);
BOOL CoIsHandlerConnected(LPUNKNOWN);
BOOL CoHasStrongExternalConnections(LPUNKNOWN);
HRESULT CoMarshalInterThreadInterfaceInStream(REFIID, LPUNKNOWN, LPSTREAM*);
HRESULT CoGetInterfaceAndReleaseStream(LPSTREAM, REFIID, PVOID*);
HRESULT CoCreateFreeThreadedMarshaler(LPUNKNOWN, LPUNKNOWN*);
HINSTANCE CoLoadLibrary(LPOLESTR, BOOL);
void CoFreeLibrary(HINSTANCE);
void CoFreeAllLibraries();
void CoFreeUnusedLibraries();
HRESULT CoCreateInstance(REFCLSID, LPUNKNOWN, DWORD, REFIID, PVOID*);
HRESULT CoCreateInstanceEx(REFCLSID, IUnknown, DWORD, COSERVERINFO*, DWORD, MULTI_QI*);
HRESULT StringFromCLSID(REFCLSID, LPOLESTR*);
HRESULT CLSIDFromString(LPOLESTR, LPCLSID);
HRESULT StringFromIID(REFIID, LPOLESTR*);
HRESULT IIDFromString(LPOLESTR, LPIID);
BOOL CoIsOle1Class(REFCLSID);
HRESULT ProgIDFromCLSID(REFCLSID, LPOLESTR*);
HRESULT CLSIDFromProgID(LPCOLESTR, LPCLSID);
int StringFromGUID2(REFGUID, LPOLESTR, int);
HRESULT CoCreateGuid(GUID*);
BOOL CoFileTimeToDosDateTime(FILETIME*, LPWORD, LPWORD);
BOOL CoDosDateTimeToFileTime(WORD, WORD, FILETIME*);
HRESULT CoFileTimeNow(FILETIME*);
HRESULT CoRegisterMessageFilter(LPMESSAGEFILTER, LPMESSAGEFILTER*);
HRESULT CoGetTreatAsClass(REFCLSID, LPCLSID);
HRESULT CoTreatAsClass(REFCLSID, REFCLSID);
HRESULT DllGetClassObject(REFCLSID, REFIID, PVOID*);
HRESULT DllCanUnloadNow();
PVOID CoTaskMemAlloc(SIZE_T);
PVOID CoTaskMemRealloc(PVOID, SIZE_T);
void CoTaskMemFree(PVOID);
HRESULT CreateDataAdviseHolder(LPDATAADVISEHOLDER*);
HRESULT CreateDataCache(LPUNKNOWN, REFCLSID, REFIID, PVOID*);
HRESULT StgCreateDocfile(const(OLECHAR)*, DWORD, DWORD, IStorage*);
HRESULT StgCreateDocfileOnILockBytes(ILockBytes, DWORD, DWORD, IStorage*);
HRESULT StgOpenStorage(const(OLECHAR)*, IStorage, DWORD, SNB, DWORD, IStorage*);
HRESULT StgOpenStorageOnILockBytes(ILockBytes, IStorage, DWORD, SNB, DWORD, IStorage*);
HRESULT StgIsStorageFile(const(OLECHAR)*);
HRESULT StgIsStorageILockBytes(ILockBytes);
HRESULT StgSetTimes(OLECHAR *, FILETIME *, FILETIME *, FILETIME *);
HRESULT StgCreateStorageEx(const(WCHAR)*, DWORD, DWORD, DWORD, STGOPTIONS*, void*, REFIID, void**);
HRESULT StgOpenStorageEx(const(WCHAR)*, DWORD, DWORD, DWORD, STGOPTIONS*, void*, REFIID, void**);
HRESULT BindMoniker(LPMONIKER, DWORD, REFIID, PVOID*);
HRESULT CoGetObject(LPCWSTR, BIND_OPTS*, REFIID, void**);
HRESULT MkParseDisplayName(LPBINDCTX, LPCOLESTR, ULONG*, LPMONIKER*);
HRESULT MonikerRelativePathTo(LPMONIKER, LPMONIKER, LPMONIKER*, BOOL);
HRESULT MonikerCommonPrefixWith(LPMONIKER, LPMONIKER, LPMONIKER*);
HRESULT CreateBindCtx(DWORD, LPBINDCTX*);
HRESULT CreateGenericComposite(LPMONIKER, LPMONIKER, LPMONIKER*);
HRESULT GetClassFile (LPCOLESTR, CLSID*);
HRESULT CreateFileMoniker(LPCOLESTR, LPMONIKER*);
HRESULT CreateItemMoniker(LPCOLESTR, LPCOLESTR, LPMONIKER*);
HRESULT CreateAntiMoniker(LPMONIKER*);
HRESULT CreatePointerMoniker(LPUNKNOWN, LPMONIKER*);
HRESULT GetRunningObjectTable(DWORD, LPRUNNINGOBJECTTABLE*);
HRESULT CoInitializeSecurity(PSECURITY_DESCRIPTOR, LONG, SOLE_AUTHENTICATION_SERVICE*, void*, DWORD, DWORD, void*, DWORD, void*);
HRESULT CoGetCallContext(REFIID, void**);
HRESULT CoQueryProxyBlanket(IUnknown*, DWORD*, DWORD*, OLECHAR**, DWORD*, DWORD*, RPC_AUTH_IDENTITY_HANDLE*, DWORD*);
HRESULT CoSetProxyBlanket(IUnknown*, DWORD, DWORD, OLECHAR*, DWORD, DWORD, RPC_AUTH_IDENTITY_HANDLE, DWORD);
HRESULT CoCopyProxy(IUnknown*, IUnknown**);
HRESULT CoQueryClientBlanket(DWORD*, DWORD*, OLECHAR**, DWORD*, DWORD*, RPC_AUTHZ_HANDLE*, DWORD*);
HRESULT CoImpersonateClient();
HRESULT CoRevertToSelf();
HRESULT CoQueryAuthenticationServices(DWORD*, SOLE_AUTHENTICATION_SERVICE**);
HRESULT CoSwitchCallContext(IUnknown*, IUnknown**);
HRESULT CoGetInstanceFromFile(COSERVERINFO*, CLSID*, IUnknown*, DWORD, DWORD, OLECHAR*, DWORD, MULTI_QI*);
HRESULT CoGetInstanceFromIStorage(COSERVERINFO*, CLSID*, IUnknown*, DWORD, IStorage*, DWORD, MULTI_QI*);
ULONG CoAddRefServerProcess();
ULONG CoReleaseServerProcess();
HRESULT CoResumeClassObjects();
HRESULT CoSuspendClassObjects();
HRESULT CoGetPSClsid(REFIID, CLSID*);
HRESULT CoRegisterPSClsid(REFIID, REFCLSID);