/**
    Windows API header module

    Part of the Internet Development SDK,
    Translated from MinGW Windows headers

    License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
*/
module nulib.system.win32.ocidl;
import nulib.system.win32.ole2;
import nulib.system.win32.oleidl; 
import nulib.system.win32.oaidl;
import nulib.system.win32.windef; 
import nulib.system.win32.wtypes;
import nulib.system.win32.objidl;  // for CLIPFORMAT
import nulib.system.win32.wingdi;  // for TEXTMETRICW
import nulib.system.win32.winuser; // for LPMSG
import nulib.system.win32.servprov; // for IServiceProvider
import nulib.system.com;

@Guid!("fc4801a1-2ba9-11cf-a229-00aa003d7352")
interface IBindHost : IUnknown {
    HRESULT CreateMoniker(LPOLESTR szName, IBindCtx pBC, ref IMoniker ppmk, DWORD dwReserved);
    HRESULT MonikerBindToStorage(IMoniker pMk, IBindCtx pBC, void* pBSC, ref IID riid, ref void* ppvObject);
    HRESULT MonikerBindToObject(IMoniker pMk, IBindCtx pBC, void* pBSC, ref IID riid, ref void* ppvObject);
}


//[Yes] #ifndef OLE2ANSI
alias TEXTMETRICOLE = TEXTMETRICW;
//} else {
//alias TEXTMETRICOLE = TEXTMETRIC;
//}
alias LPTEXTMETRICOLE = TEXTMETRICOLE*;

alias OLE_COLOR = DWORD;
alias OLE_HANDLE = UINT;
alias OLE_XPOS_HIMETRIC = int;
alias OLE_YPOS_HIMETRIC = int;
alias OLE_XSIZE_HIMETRIC = int;
alias OLE_YSIZE_HIMETRIC = int;

enum READYSTATE {
    READYSTATE_UNINITIALIZED = 0,
    READYSTATE_LOADING = 1,
    READYSTATE_LOADED = 2,
    READYSTATE_INTERACTIVE = 3,
    READYSTATE_COMPLETE = 4
}

enum PROPBAG2_TYPE {
    PROPBAG2_TYPE_UNDEFINED,
    PROPBAG2_TYPE_DATA,
    PROPBAG2_TYPE_URL,
    PROPBAG2_TYPE_OBJECT,
    PROPBAG2_TYPE_STREAM,
    PROPBAG2_TYPE_STORAGE,
    PROPBAG2_TYPE_MONIKER // = 6
}

struct PROPBAG2 {
    DWORD dwType;
    VARTYPE vt;
    CLIPFORMAT cfType;
    DWORD dwHint;
    LPOLESTR pstrName;
    CLSID clsid;
}

enum QACONTAINERFLAGS {
    QACONTAINER_SHOWHATCHING = 1,
    QACONTAINER_SHOWGRABHANDLES = 2,
    QACONTAINER_USERMODE = 4,
    QACONTAINER_DISPLAYASDEFAULT = 8,
    QACONTAINER_UIDEAD = 16,
    QACONTAINER_AUTOCLIP = 32,
    QACONTAINER_MESSAGEREFLECT = 64,
    QACONTAINER_SUPPORTSMNEMONICS = 128
}

struct QACONTAINER {
    ULONG cbSize = this.sizeof;
    IOleClientSite pClientSite;
    IAdviseSinkEx pAdviseSink;
    IPropertyNotifySink pPropertyNotifySink;
    IUnknown pUnkEventSink;
    DWORD dwAmbientFlags;
    OLE_COLOR colorFore;
    OLE_COLOR colorBack;
    IFont pFont;
    IOleUndoManager pUndoMgr;
    DWORD dwAppearance;
    LONG lcid;
    HPALETTE hpal;
    IBindHost pBindHost;
    IOleControlSite pOleControlSite;
    IServiceProvider pServiceProvider;
}

struct QACONTROL {
    ULONG cbSize = this.sizeof;
    DWORD dwMiscStatus;
    DWORD dwViewStatus;
    DWORD dwEventCookie;
    DWORD dwPropNotifyCookie;
    DWORD dwPointerActivationPolicy;
}

struct POINTF {
    float x;
    float y;
}
alias LPPOINTF = POINTF*;

struct CONTROLINFO {
    ULONG cb;
    HACCEL hAccel;
    USHORT cAccel;
    DWORD dwFlags;
}
alias LPCONTROLINFO = CONTROLINFO*;

struct CONNECTDATA {
    LPUNKNOWN pUnk;
    DWORD dwCookie;
}
alias LPCONNECTDATA = CONNECTDATA*;

struct LICINFO {
    int cbLicInfo;
    BOOL fRuntimeKeyAvail;
    BOOL fLicVerified;
}
alias LPLICINFO = LICINFO*;

struct CAUUID {
    ULONG cElems;
    GUID* pElems;
}
alias LPCAUUID = CAUUID*;

struct CALPOLESTR {
    ULONG cElems;
    LPOLESTR* pElems;
}
alias LPCALPOLESTR = CALPOLESTR*;

struct CADWORD {
    ULONG cElems;
    DWORD* pElems;
}
alias LPCADWORD = CADWORD*;

struct PROPPAGEINFO {
    ULONG cb;
    LPOLESTR pszTitle;
    SIZE size;
    LPOLESTR pszDocString;
    LPOLESTR pszHelpFile;
    DWORD dwHelpContext;
}
alias LPPROPPAGEINFO = PROPPAGEINFO*;

interface IOleControl : IUnknown {
    HRESULT GetControlInfo(LPCONTROLINFO);
    HRESULT OnMnemonic(LPMSG);
    HRESULT OnAmbientPropertyChange(DISPID);
    HRESULT FreezeEvents(BOOL);
}

interface IOleControlSite : IUnknown {
    HRESULT OnControlInfoChanged();
    HRESULT LockInPlaceActive(BOOL);
    HRESULT GetExtendedControl(LPDISPATCH*);
    HRESULT TransformCoords(POINTL*, POINTF*, DWORD);
    HRESULT TranslateAccelerator(LPMSG, DWORD);
    HRESULT OnFocus(BOOL);
    HRESULT ShowPropertyFrame();
}

interface ISimpleFrameSite : IUnknown {
    HRESULT PreMessageFilter(HWND, UINT, WPARAM, LPARAM, LRESULT*, PDWORD);
    HRESULT PostMessageFilter(HWND, UINT, WPARAM, LPARAM, LRESULT*, DWORD);
}

interface IErrorLog : IUnknown {
    HRESULT AddError(LPCOLESTR, LPEXCEPINFO);
}
alias LPERRORLOG = IErrorLog;

interface IPropertyBag : IUnknown {
    HRESULT Read(LPCOLESTR, LPVARIANT, LPERRORLOG);
    HRESULT Write(LPCOLESTR, LPVARIANT);
}
alias LPPROPERTYBAG = IPropertyBag;

interface IPropertyBag2 : IUnknown {
    HRESULT Read(ULONG, PROPBAG2*, LPERRORLOG, VARIANT*, HRESULT*);
    HRESULT Write(ULONG, PROPBAG2*, VARIANT*);
    HRESULT CountProperties(ULONG*);
    HRESULT GetPropertyInfo(ULONG, ULONG, PROPBAG2*, ULONG*);
    HRESULT LoadObject(LPCOLESTR, DWORD, IUnknown, LPERRORLOG);
}
alias LPPROPERTYBAG2 = IPropertyBag2;

interface IPersistPropertyBag : IPersist {
    HRESULT InitNew();
    HRESULT Load(LPPROPERTYBAG, LPERRORLOG);
    HRESULT Save(LPPROPERTYBAG, BOOL, BOOL);
}

interface IPersistPropertyBag2 : IPersist {
    HRESULT InitNew();
    HRESULT Load(LPPROPERTYBAG2, LPERRORLOG);
    HRESULT Save(LPPROPERTYBAG2, BOOL, BOOL);
    HRESULT IsDirty();
}

interface IPersistStreamInit : IPersist {
    HRESULT IsDirty();
    HRESULT Load(LPSTREAM);
    HRESULT Save(LPSTREAM, BOOL);
    HRESULT GetSizeMax(PULARGE_INTEGER);
    HRESULT InitNew();
}

interface IPersistMemory : IPersist {
    HRESULT IsDirty();
    HRESULT Load(PVOID, ULONG);
    HRESULT Save(PVOID, BOOL, ULONG);
    HRESULT GetSizeMax(PULONG);
    HRESULT InitNew();
}

interface IPropertyNotifySink : IUnknown {
    HRESULT OnChanged(DISPID);
    HRESULT OnRequestEdit(DISPID);
}

interface IProvideClassInfo : IUnknown {
    HRESULT GetClassInfo(LPTYPEINFO*);
}

interface IProvideClassInfo2 : IProvideClassInfo {
    HRESULT GetGUID(DWORD, GUID*);
}

interface IConnectionPointContainer : IUnknown {
    HRESULT EnumConnectionPoints(LPENUMCONNECTIONPOINTS*);
    HRESULT FindConnectionPoint(REFIID, LPCONNECTIONPOINT*);
}

interface IEnumConnectionPoints : IUnknown {
    HRESULT Next(ULONG, LPCONNECTIONPOINT*, ULONG*);
    HRESULT Skip(ULONG);
    HRESULT Reset();
    HRESULT Clone(LPENUMCONNECTIONPOINTS*);
}
alias LPENUMCONNECTIONPOINTS = IEnumConnectionPoints;

interface IConnectionPoint : IUnknown {
    HRESULT GetConnectionInterface(IID*);
    HRESULT GetConnectionPointContainer(IConnectionPointContainer*);
    HRESULT Advise(LPUNKNOWN, PDWORD);
    HRESULT Unadvise(DWORD);
    HRESULT EnumConnections(LPENUMCONNECTIONS*);
}
alias LPCONNECTIONPOINT = IConnectionPoint;

interface IEnumConnections : IUnknown {
    HRESULT Next(ULONG, LPCONNECTDATA, PULONG);
    HRESULT Skip(ULONG);
    HRESULT Reset();
    HRESULT Clone(LPENUMCONNECTIONS*);
}
alias LPENUMCONNECTIONS = IEnumConnections;

interface IClassFactory2 : IClassFactory {
    HRESULT GetLicInfo(LPLICINFO);
    HRESULT RequestLicKey(DWORD, BSTR*);
    HRESULT CreateInstanceLic(LPUNKNOWN, LPUNKNOWN, REFIID, BSTR, PVOID*);
}

interface ISpecifyPropertyPages : IUnknown {
    HRESULT GetPages(CAUUID*);
}

interface IPerPropertyBrowsing : IUnknown {
    HRESULT GetDisplayString(DISPID, BSTR*);
    HRESULT MapPropertyToPage(DISPID, LPCLSID);
    HRESULT GetPredefinedStrings(DISPID, CALPOLESTR*, CADWORD*);
    HRESULT GetPredefinedValue(DISPID, DWORD, VARIANT*);
}

interface IPropertyPageSite : IUnknown {
    HRESULT OnStatusChange(DWORD);
    HRESULT GetLocaleID(LCID*);
    HRESULT GetPageContainer(LPUNKNOWN*);
    HRESULT TranslateAccelerator(LPMSG);
}
alias LPPROPERTYPAGESITE = IPropertyPageSite;

interface IPropertyPage : IUnknown {
    HRESULT SetPageSite(LPPROPERTYPAGESITE);
    HRESULT Activate(HWND, LPCRECT, BOOL);
    HRESULT Deactivate();
    HRESULT GetPageInfo(LPPROPPAGEINFO);
    HRESULT SetObjects(ULONG, LPUNKNOWN*);
    HRESULT Show(UINT);
    HRESULT Move(LPCRECT);
    HRESULT IsPageDirty();
    HRESULT Apply();
    HRESULT Help(LPCOLESTR);
    HRESULT TranslateAccelerator(LPMSG);
}


interface IPropertyPage2 : IPropertyPage
{ HRESULT EditProperty(DISPID);
}

interface IFont : IUnknown {
    HRESULT get_Name(BSTR*);
    HRESULT put_Name(BSTR);
    HRESULT get_Size(CY*);
    HRESULT put_Size(CY);
    HRESULT get_Bold(BOOL*);
    HRESULT put_Bold(BOOL);
    HRESULT get_Italic(BOOL*);
    HRESULT put_Italic(BOOL);
    HRESULT get_Underline(BOOL*);
    HRESULT put_Underline(BOOL);
    HRESULT get_Strikethrough(BOOL*);
    HRESULT put_Strikethrough(BOOL);
    HRESULT get_Weight(short*);
    HRESULT put_Weight(short);
    HRESULT get_Charset(short*);
    HRESULT put_Charset(short);
    HRESULT get_hFont(HFONT*);
    HRESULT Clone(IFont*);
    HRESULT IsEqual(IFont);
    HRESULT SetRatio(int, int);
    HRESULT QueryTextMetrics(LPTEXTMETRICOLE);
    HRESULT AddRefHfont(HFONT);
    HRESULT ReleaseHfont(HFONT);
    HRESULT SetHdc(HDC);
}
alias LPFONT = IFont;

interface IFontDisp : IDispatch {
}
alias LPFONTDISP = IFontDisp;

interface IPicture : IUnknown {
    HRESULT get_Handle(OLE_HANDLE*);
    HRESULT get_hPal(OLE_HANDLE*);
    HRESULT get_Type(short*);
    HRESULT get_Width(OLE_XSIZE_HIMETRIC*);
    HRESULT get_Height(OLE_YSIZE_HIMETRIC*);
    HRESULT Render(HDC, int, int, int, int, OLE_XPOS_HIMETRIC,
      OLE_YPOS_HIMETRIC, OLE_XSIZE_HIMETRIC, OLE_YSIZE_HIMETRIC, LPCRECT);
    HRESULT set_hPal(OLE_HANDLE);
    HRESULT get_CurDC(HDC*);
    HRESULT SelectPicture(HDC, HDC*, OLE_HANDLE*);
    HRESULT get_KeepOriginalFormat(BOOL*);
    HRESULT put_KeepOriginalFormat(BOOL);
    HRESULT PictureChanged();
    HRESULT SaveAsFile(LPSTREAM, BOOL, LONG*);
    HRESULT get_Attributes(PDWORD);
}

interface IPictureDisp : IDispatch {
}

interface IOleInPlaceSiteEx : IOleInPlaceSite {
    HRESULT OnInPlaceActivateEx(BOOL*, DWORD);
    HRESULT OnInPlaceDeactivateEx(BOOL);
    HRESULT RequestUIActivate();
}

interface IObjectWithSite : IUnknown {
    HRESULT SetSite(IUnknown);
    HRESULT GetSite(REFIID, void**);
}

interface IOleInPlaceSiteWindowless : IOleInPlaceSiteEx {
    HRESULT CanWindowlessActivate();
    HRESULT GetCapture();
    HRESULT SetCapture(BOOL);
    HRESULT GetFocus();
    HRESULT SetFocus(BOOL);
    HRESULT GetDC(LPCRECT, DWORD, HDC*);
    HRESULT ReleaseDC(HDC);
    HRESULT InvalidateRect(LPCRECT, BOOL);
    HRESULT InvalidateRgn(HRGN, BOOL);
    HRESULT ScrollRect(INT, INT, LPCRECT, LPCRECT);
    HRESULT AdjustRect(LPCRECT);
    HRESULT OnDefWindowMessage(UINT, WPARAM, LPARAM, LRESULT*);
}

interface IAdviseSinkEx : IUnknown {
    void OnDataChange(FORMATETC*, STGMEDIUM*);
    void OnViewChange(DWORD, LONG);
    void OnRename(IMoniker);
    void OnSave();
    void OnClose();
    HRESULT OnViewStatusChange(DWORD);
}

interface IPointerInactive : IUnknown {
    HRESULT GetActivationPolicy(DWORD*);
    HRESULT OnInactiveMouseMove(LPCRECT, LONG, LONG, DWORD);
    HRESULT OnInactiveSetCursor(LPCRECT, LONG, LONG, DWORD, BOOL);
}

interface IOleUndoUnit : IUnknown {
    HRESULT Do(LPOLEUNDOMANAGER);
    HRESULT GetDescription(BSTR*);
    HRESULT GetUnitType(CLSID*, LONG*);
    HRESULT OnNextAdd();
}

interface IOleParentUndoUnit : IOleUndoUnit {
    HRESULT Open(IOleParentUndoUnit);
    HRESULT Close(IOleParentUndoUnit, BOOL);
    HRESULT Add(IOleUndoUnit);
    HRESULT FindUnit(IOleUndoUnit);
    HRESULT GetParentState(DWORD*);
}

interface IEnumOleUndoUnits : IUnknown {
    HRESULT Next(ULONG, IOleUndoUnit*, ULONG*);
    HRESULT Skip(ULONG);
    HRESULT Reset();
    HRESULT Clone(IEnumOleUndoUnits*);
}

interface IOleUndoManager : IUnknown {
    HRESULT Open(IOleParentUndoUnit);
    HRESULT Close(IOleParentUndoUnit, BOOL);
    HRESULT Add(IOleUndoUnit);
    HRESULT GetOpenParentState(DWORD*);
    HRESULT DiscardFrom(IOleUndoUnit);
    HRESULT UndoTo(IOleUndoUnit);
    HRESULT RedoTo(IOleUndoUnit);
    HRESULT EnumUndoable(IEnumOleUndoUnits*);
    HRESULT EnumRedoable(IEnumOleUndoUnits*);
    HRESULT GetLastUndoDescription(BSTR*);
    HRESULT GetLastRedoDescription(BSTR*);
    HRESULT Enable(BOOL);
}
alias LPOLEUNDOMANAGER = IOleUndoManager;

interface IQuickActivate : IUnknown {
    HRESULT QuickActivate(QACONTAINER*, QACONTROL*);
    HRESULT SetContentExtent(LPSIZEL);
    HRESULT GetContentExtent(LPSIZEL);
}
