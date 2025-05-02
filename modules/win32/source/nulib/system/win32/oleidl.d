/**
 * Windows API header module
 *
 * Translated from MinGW Windows headers
 *
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source: $(DRUNTIMESRC core/sys/windows/_oleidl.d)
 */
module nulib.system.win32.oleidl;
import nulib.system.com;
import nulib.system.win32.basetyps;
import nulib.system.win32.objidl;
import nulib.system.win32.windef;
import nulib.system.win32.winuser;
import nulib.system.win32.wtypes;
import nulib.system.win32.wingdi; // for LPLOGPALETTE
import nulib.system.com;

enum MK_ALT = 32;

enum BINDSPEED {
    BINDSPEED_INDEFINITE = 1,
    BINDSPEED_MODERATE,
    BINDSPEED_IMMEDIATE
}

enum OLEWHICHMK {
    OLEWHICHMK_CONTAINER = 1,
    OLEWHICHMK_OBJREL,
    OLEWHICHMK_OBJFULL
}

enum OLEGETMONIKER {
    OLEGETMONIKER_ONLYIFTHERE = 1,
    OLEGETMONIKER_FORCEASSIGN,
    OLEGETMONIKER_UNASSIGN,
    OLEGETMONIKER_TEMPFORUSER
}

enum USERCLASSTYPE {
    USERCLASSTYPE_FULL = 1,
    USERCLASSTYPE_SHORT,
    USERCLASSTYPE_APPNAME
}

enum DROPEFFECT {
    DROPEFFECT_NONE   = 0,
    DROPEFFECT_COPY   = 1,
    DROPEFFECT_MOVE   = 2,
    DROPEFFECT_LINK   = 4,
    DROPEFFECT_SCROLL = 0x80000000
}

struct OLEMENUGROUPWIDTHS {
    LONG[6] width;
}
alias LPOLEMENUGROUPWIDTHS = OLEMENUGROUPWIDTHS*;

alias HOLEMENU = HGLOBAL;

enum OLECLOSE {
    OLECLOSE_SAVEIFDIRTY,
    OLECLOSE_NOSAVE,
    OLECLOSE_PROMPTSAVE
}

struct OLEVERB {
    LONG lVerb;
    LPWSTR lpszVerbName;
    DWORD fuFlags;
    DWORD grfAttribs;
}
alias LPOLEVERB = OLEVERB*;

alias BORDERWIDTHS = RECT;
alias LPBORDERWIDTHS = LPRECT;
alias LPCBORDERWIDTHS = LPCRECT;

alias LPOLEINPLACEFRAMEINFO = OLEINPLACEFRAMEINFO*;
struct OLEINPLACEFRAMEINFO {
    UINT cb;
    BOOL fMDIApp;
    HWND hwndFrame;
    HACCEL haccel;
    UINT cAccelEntries;
}

alias LPENUMOLEVERB = IEnumOLEVERB;
interface IEnumOLEVERB : IUnknown
{
      HRESULT Next(ULONG,OLEVERB*,ULONG*);
      HRESULT Skip(ULONG);
      HRESULT Reset();
      HRESULT Clone(IEnumOLEVERB*);
}


alias LPPARSEDISPLAYNAME = IParseDisplayName;
interface IParseDisplayName : IUnknown {
    HRESULT ParseDisplayName(IBindCtx,LPOLESTR,ULONG*,IMoniker*);
}

alias LPOLECONTAINER = IOleContainer;
interface IOleContainer : IParseDisplayName {
    HRESULT EnumObjects(DWORD,IEnumUnknown*);
    HRESULT LockContainer(BOOL);
}

interface IOleItemContainer : IOleContainer {
    HRESULT GetObject(LPOLESTR,DWORD,IBindCtx,REFIID,void**);
    HRESULT GetObjectStorage(LPOLESTR,IBindCtx,REFIID,void**);
    HRESULT IsRunning(LPOLESTR);
}

alias LPOLECLIENTSITE = IOleClientSite;
interface IOleClientSite : IUnknown {
    HRESULT SaveObject();
    HRESULT GetMoniker(DWORD,DWORD,LPMONIKER*);
    HRESULT GetContainer(LPOLECONTAINER*);
    HRESULT ShowObject();
    HRESULT OnShowWindow(BOOL);
    HRESULT RequestNewObjectLayout();
}

alias LPOLEOBJECT = IOleObject;
interface IOleObject : IUnknown {
    HRESULT SetClientSite(LPOLECLIENTSITE);
    HRESULT GetClientSite(LPOLECLIENTSITE*);
    HRESULT SetHostNames(LPCOLESTR,LPCOLESTR);
    HRESULT Close(DWORD);
    HRESULT SetMoniker(DWORD,LPMONIKER);
    HRESULT GetMoniker(DWORD,DWORD,LPMONIKER*);
    HRESULT InitFromData(LPDATAOBJECT,BOOL,DWORD);
    HRESULT GetClipboardData(DWORD,LPDATAOBJECT*);
    HRESULT DoVerb(LONG,LPMSG,LPOLECLIENTSITE,LONG,HWND,LPCRECT);
    HRESULT EnumVerbs(LPENUMOLEVERB*);
    HRESULT Update();
    HRESULT IsUpToDate();
    HRESULT GetUserClassID(LPCLSID);
    HRESULT GetUserType(DWORD,LPOLESTR*);
    HRESULT SetExtent(DWORD,SIZEL*);
    HRESULT GetExtent(DWORD,SIZEL*);
    HRESULT Advise(LPADVISESINK,PDWORD);
    HRESULT Unadvise(DWORD);
    HRESULT EnumAdvise(LPENUMSTATDATA*);
    HRESULT GetMiscStatus(DWORD,PDWORD);
    HRESULT SetColorScheme(LPLOGPALETTE);
}

alias LPOLEWINDOW = IOleWindow;
interface IOleWindow : IUnknown {
    HRESULT GetWindow(HWND*);
    HRESULT ContextSensitiveHelp(BOOL);
}

alias LPOLEINPLACEUIWINDOW = IOleInPlaceUIWindow;
interface IOleInPlaceUIWindow : IOleWindow {
    HRESULT GetBorder(LPRECT);
    HRESULT RequestBorderSpace(LPCBORDERWIDTHS);
    HRESULT SetBorderSpace(LPCBORDERWIDTHS);
    HRESULT SetActiveObject(LPOLEINPLACEACTIVEOBJECT,LPCOLESTR);
}

alias LPOLEINPLACEOBJECT = IOleInPlaceObject;
interface IOleInPlaceObject : IOleWindow {
    HRESULT InPlaceDeactivate();
    HRESULT UIDeactivate();
    HRESULT SetObjectRects(LPCRECT,LPCRECT);
    HRESULT ReactivateAndUndo();
}

alias LPOLEINPLACEACTIVEOBJECT = IOleInPlaceActiveObject;
interface IOleInPlaceActiveObject : IOleWindow {
    HRESULT TranslateAccelerator(LPMSG);
    HRESULT OnFrameWindowActivate(BOOL);
    HRESULT OnDocWindowActivate(BOOL);
    HRESULT ResizeBorder(LPCRECT,LPOLEINPLACEUIWINDOW,BOOL);
    HRESULT EnableModeless(BOOL);
}

alias LPOLEINPLACEFRAME = IOleInPlaceFrame;
interface IOleInPlaceFrame : IOleInPlaceUIWindow {
    HRESULT InsertMenus(HMENU,LPOLEMENUGROUPWIDTHS);
    HRESULT SetMenu(HMENU,HOLEMENU,HWND);
    HRESULT RemoveMenus(HMENU);
    HRESULT SetStatusText(LPCOLESTR);
    HRESULT EnableModeless(BOOL);
    HRESULT TranslateAccelerator(LPMSG,WORD);
}

alias LPOLEINPLACESITE = IOleInPlaceSite;
interface IOleInPlaceSite : IOleWindow {
    HRESULT CanInPlaceActivate();
    HRESULT OnInPlaceActivate();
    HRESULT OnUIActivate();
    HRESULT GetWindowContext(IOleInPlaceFrame,IOleInPlaceUIWindow,LPRECT,LPRECT,LPOLEINPLACEFRAMEINFO);
    HRESULT Scroll(SIZE);
    HRESULT OnUIDeactivate(BOOL);
    HRESULT OnInPlaceDeactivate();
    HRESULT DiscardUndoState();
    HRESULT DeactivateAndUndo();
    HRESULT OnPosRectChange(LPCRECT);
}

alias LPOLEADVISEHOLDER = IOleAdviseHolder;
interface IOleAdviseHolder : IUnknown {
    HRESULT Advise(LPADVISESINK,PDWORD);
    HRESULT Unadvise(DWORD);
    HRESULT EnumAdvise(LPENUMSTATDATA*);
    HRESULT SendOnRename(LPMONIKER);
    HRESULT SendOnSave();
    HRESULT SendOnClose();
}

alias LPDROPSOURCE = IDropSource;
interface IDropSource : IUnknown {
    HRESULT QueryContinueDrag(BOOL,DWORD);
    HRESULT GiveFeedback(DWORD);
}

alias LPDROPTARGET = IDropTarget;
interface IDropTarget : IUnknown {
    HRESULT DragEnter(LPDATAOBJECT,DWORD,POINTL,PDWORD);
    HRESULT DragOver(DWORD,POINTL,PDWORD);
    HRESULT DragLeave();
    HRESULT Drop(LPDATAOBJECT,DWORD,POINTL,PDWORD);
}

extern (Windows) {
    alias __IView_pfncont = BOOL function(ULONG_PTR) ;
}

alias LPVIEWOBJECT = IViewObject;
interface IViewObject : IUnknown {
    HRESULT Draw(DWORD,LONG,PVOID,DVTARGETDEVICE*,HDC,HDC,LPCRECTL,LPCRECTL,__IView_pfncont pfnContinue,ULONG_PTR);
    HRESULT GetColorSet(DWORD,LONG,PVOID,DVTARGETDEVICE*,HDC,LPLOGPALETTE*);
    HRESULT Freeze(DWORD,LONG,PVOID,PDWORD);
    HRESULT Unfreeze(DWORD);
    HRESULT SetAdvise(DWORD,DWORD,IAdviseSink);
    HRESULT GetAdvise(PDWORD,PDWORD,IAdviseSink*);
}

alias LPVIEWOBJECT2 = IViewObject2;
interface IViewObject2 : IViewObject {
    HRESULT GetExtent(DWORD,LONG,DVTARGETDEVICE*,LPSIZEL);
}

alias LPOLECACHE = IOleCache;
interface IOleCache : IUnknown {
    HRESULT Cache(FORMATETC*,DWORD,DWORD*);
    HRESULT Uncache(DWORD);
    HRESULT EnumCache(IEnumSTATDATA*);
    HRESULT InitCache(LPDATAOBJECT);
    HRESULT SetData(FORMATETC*,STGMEDIUM*,BOOL);
}

alias LPOLECACHE2 = IOleCache2;
interface IOleCache2 : IOleCache {
    HRESULT UpdateCache(LPDATAOBJECT,DWORD,LPVOID);
    HRESULT DiscardCache(DWORD);
}

alias LPOLECACHECONTROL = IOleCacheControl;
interface IOleCacheControl : IUnknown {
    HRESULT OnRun(LPDATAOBJECT);
    HRESULT OnStop();
}
