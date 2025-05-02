/**
    AclUI.h Header Module

    Translated from Windows 10 Kit 10.0.19041.0

    License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors: Luna Nielsen
*/
module nulib.system.win32.aclui;
import nulib.system.win32.w32api;
import nulib.system.win32.sdkddkver;
import nulib.system.win32.accctrl;
import nulib.system.win32.w32api;
import nulib.system.win32.basetyps;
import nulib.system.win32.prsht;
import nulib.system.win32.windef;
import nulib.system.win32.winuser;
import nulib.system.com;

pragma(lib, "aclui");

alias PSI_OBJECT_INFO = SI_OBJECT_INFO*;
alias LPSI_OBJECT_INFO = SI_OBJECT_INFO*;
alias LPCSI_OBJECT_INFO = const(SI_OBJECT_INFO)*;
struct SI_OBJECT_INFO {
    DWORD dwFlags;
    HINSTANCE hInstance;
    LPWSTR pszServerName;
    LPWSTR pszObjectName;
    LPWSTR pszPageTitle;
    GUID guidObjectType;
}

// values for SI_OBJECT_INFO.dwFlags
enum DWORD SI_EDIT_PERMS = 0x00000000,
    SI_EDIT_OWNER = 0x00000001,
    SI_EDIT_AUDITS = 0x00000002,
    SI_CONTAINER = 0x00000004,
    SI_READONLY = 0x00000008,
    SI_ADVANCED = 0x00000010,
    SI_RESET = 0x00000020,
    SI_OWNER_READONLY = 0x00000040,
    SI_EDIT_PROPERTIES = 0x00000080,
    SI_OWNER_RECURSE = 0x00000100,
    SI_NO_ACL_PROTECT = 0x00000200,
    SI_NO_TREE_APPLY = 0x00000400,
    SI_PAGE_TITLE = 0x00000800,
    SI_SERVER_IS_DC = 0x00001000,
    SI_RESET_DACL_TREE = 0x00004000,
    SI_RESET_SACL_TREE = 0x00008000,
    SI_OBJECT_GUID = 0x00010000,
    SI_EDIT_EFFECTIVE = 0x00020000,
    SI_RESET_DACL = 0x00040000,
    SI_RESET_SACL = 0x00080000,
    SI_RESET_OWNER = 0x00100000,
    SI_NO_ADDITIONAL_PERMISSION = 0x00200000,
    SI_MAY_WRITE = 0x10000000,
    SI_EDIT_ALL = SI_EDIT_PERMS | SI_EDIT_OWNER | SI_EDIT_AUDITS;

alias PSI_ACCESS = SI_ACCESS*;
alias LPSI_ACCESS = SI_ACCESS*;
alias LPCSI_ACCESS = const(SI_ACCESS)*;
struct SI_ACCESS {
    const(GUID)* pguid;
    ACCESS_MASK mask;
    LPCWSTR pszName;
    DWORD dwFlags;
}

// values for SI_ACCESS.dwFlags
enum DWORD 
    SI_ACCESS_SPECIFIC = 0x00010000,
    SI_ACCESS_GENERAL = 0x00020000,
    SI_ACCESS_CONTAINER = 0x00040000,
    SI_ACCESS_PROPERTY = 0x00080000;


alias PSI_INHERIT_TYPE = SI_INHERIT_TYPE*;
alias LPSI_INHERIT_TYPE = SI_INHERIT_TYPE*;
alias LPCSI_INHERIT_TYPE = const(SI_INHERIT_TYPE)*;
struct SI_INHERIT_TYPE {
    const(GUID)* pguid;
    ULONG dwFlags;
    LPCWSTR pszName;
}

alias PSI_PAGE_TYPE = SI_PAGE_TYPE*;
alias LPSI_PAGE_TYPE = SI_PAGE_TYPE*;
alias LPCSI_PAGE_TYPE = const(SI_PAGE_TYPE)*;
enum SI_PAGE_TYPE {
    SI_PAGE_PERM,
    SI_PAGE_ADVPERM,
    SI_PAGE_AUDIT,
    SI_PAGE_OWNER,
    SI_PAGE_EFFECTIVE,
    SI_PAGE_TAKEOWNERSHIP,
    SI_PAGE_SHARE,
}

alias PSI_PAGE_ACTIVATED = SI_PAGE_ACTIVATED*;
alias LPSI_PAGE_ACTIVATED = SI_PAGE_ACTIVATED*;
alias LPCSI_PAGE_ACTIVATED = const(SI_PAGE_ACTIVATED)*;
enum SI_PAGE_ACTIVATED {
    SI_SHOW_DEFAULT = 0,
    SI_SHOW_PERM_ACTIVATED,
    SI_SHOW_AUDIT_ACTIVATED,
    SI_SHOW_OWNER_ACTIVATED,
    SI_SHOW_EFFECTIVE_ACTIVATED,
    SI_SHOW_SHARE_ACTIVATED,
    SI_SHOW_CENTRAL_POLICY_ACTIVATED,
}

enum DOBJ_RES_CONT =           0x00000001L;
enum DOBJ_RES_ROOT =           0x00000002L;
enum DOBJ_VOL_NTACLS =         0x00000004L;     /// NTFS or OFS
enum DOBJ_COND_NTACLS =        0x00000008L;     /// Conditional aces supported.
enum DOBJ_RIBBON_LAUNCH =      0x00000010L;     /// Invoked from explorer ribbon.

enum uint PSPCB_SI_INITDIALOG = WM_USER + 1;

alias P = SID_INFO_LIST*;
alias LP = SID_INFO_LIST*;
alias LPC = const(SID_INFO_LIST)*;
struct SID_INFO {
    SID*    pSid;
    PWSTR   pwzCommonName;
    
    /**
        Used for selecting icon, e.g. "User" or "Group"
    */
    PWSTR   pwzClass;

    /**
        Optional, may be NULL
    */
    PWSTR   pwzUPN;
}

alias PSID_INFO_LIST = SID_INFO_LIST*;
alias LPSID_INFO_LIST = SID_INFO_LIST*;
alias LPCSID_INFO_LIST = const(SID_INFO_LIST)*;
struct SID_INFO_LIST {
    ULONG       cItems;
    SID_INFO*   aSidInfo;
}

alias PSECURITY_OBJECT = SECURITY_OBJECT*;
alias LPSECURITY_OBJECT = SECURITY_OBJECT*;
alias LPCSECURITY_OBJECT = const(SECURITY_OBJECT)*;
struct SECURITY_OBJECT {
    PWSTR pwszName;
    PVOID pData;
    DWORD cbData;
    PVOID pData2;
    DWORD cbData2;
    DWORD Id;
    BOOLEAN fWellKnown;
}

enum DWORD SECURITY_OBJECT_ID_OBJECT_SD =      1;
enum DWORD SECURITY_OBJECT_ID_SHARE =          2;
enum DWORD SECURITY_OBJECT_ID_CENTRAL_POLICY = 3;
enum DWORD SECURITY_OBJECT_ID_CENTRAL_ACCESS_RULE = 4;

alias PEFFPERM_RESULT_LIST = EFFPERM_RESULT_LIST*;
alias LPEFFPERM_RESULT_LIST = EFFPERM_RESULT_LIST*;
alias LPCEFFPERM_RESULT_LIST = const(EFFPERM_RESULT_LIST)*;
struct EFFPERM_RESULT_LIST {
    BOOLEAN fEvaluated;
    ULONG cObjectTypeListLength;
    PVOID pObjectTypeList;
    ACCESS_MASK* pGrantedAccessList;
}

extern (Windows) nothrow @nogc {
    HPROPSHEETPAGE CreateSecurityPage(ISecurityInformation psi);
    BOOL EditSecurity(HWND hwndOwner, ISecurityInformation psi);
    
    static if (NTDDI_VERSION >= NTDDI_VISTA) {
        HRESULT EditSecurityAdvanced(HWND hwndOwner, ISecurityInformation psi, SI_PAGE_TYPE uSIPage);
    }
}

@Guid!("965FC360-16FF-11d0-91CB-00AA00BBB723")
interface ISecurityInformation : IUnknown {
    HRESULT GetObjectInformation(ref SI_OBJECT_INFO) pure;
    HRESULT GetSecurity(SECURITY_INFORMATION, ref SECURITY_DESCRIPTOR*, BOOL) pure;
    HRESULT SetSecurity(SECURITY_INFORMATION, ref SECURITY_DESCRIPTOR) pure;
    HRESULT GetAccessRights(const(GUID)*, DWORD, ref SI_ACCESS*, ULONG*, ULONG*) pure;
    HRESULT MapGeneric(const(GUID)*, UCHAR*, ACCESS_MASK*) pure;
    HRESULT GetInheritTypes(ref SI_INHERIT_TYPE*, ULONG*) pure;
    HRESULT PropertySheetPageCallback(HWND, UINT, SI_PAGE_TYPE) pure;
}


@Guid!("c3ccfdb4-6f88-11d2-a3ce-00c04fb1782a")
interface ISecurityInformation2 : IUnknown {
    BOOLEAN IsDaclCanonical(in PACL pDacl) pure;
    HRESULT LookupSids(ulong cSids, SID* rgpSids, out void* ppdo) pure;
}

@Guid!("3853DC76-9F35-407c-88A1-D19344365FBC")
interface IEffectivePermission : IUnknown {
    HRESULT GetEffectivePermission(
        const(GUID)* pguidObjectType,
        SID* pUserSid,
        LPCWSTR pszServerName,
        ref SECURITY_DESCRIPTOR pSD,
        ref void* ppObjectTypeList,
        ref ULONG pcObjectTypeListLength,
        ref PACCESS_MASK ppGrantedAccessList,
        ref ULONG pcGrantedAccessListLength
    ) pure;
}

@Guid!("FC3066EB-79EF-444b-9111-D18A75EBF2FA")
interface ISecurityObjectTypeInfo : IUnknown {
    HRESULT GetInheritSource(
        SECURITY_INFORMATION si,
        ref ACL pACL,
        ref INHERITED_FROM* ppInheritArray
    ) pure;
}

// Windows Vista+
static if (NTDDI_VERSION >= NTDDI_VISTA) {

    @Guid!("E2CDC9CC-31BD-4f8f-8C8B-B641AF516A1A")
    interface ISecurityInformation3 : IUnknown {
        HRESULT GetFullResourceName(out LPWSTR ppszResourceName) pure;
        HRESULT OpenElevatedEditor(HWND hWnd, SI_PAGE_TYPE uPage) pure;
    }

}

// Windows 8+
static if (NTDDI_VERSION >= NTDDI_WIN8) {

    @Guid!("EA961070-CD14-4621-ACE4-F63C03E583E4")
    interface ISecurityInformation4 : IUnknown {
        HRESULT GetSecondarySecurity(ref SECURITY_OBJECT* pSecurityObjects, PULONG pSecurityObjectCount) pure;
    }

    @Guid!("941FABCA-DD47-4FCA-90BB-B0E10255F20D")
    interface IEffectivePermission2 : IUnknown {
        HRESULT ComputeEffectivePermissionWithSecondarySecurity(
            SID* pSid,
            SID* pDeviceSid,
            PCWSTR pszServerName,
            SECURITY_OBJECT* pSecurityObjects,
            DWORD dwSecurityObjectCount,
            TOKEN_GROUPS* pUserGroups,
            AUTHZ_SID_OPERATION* pAuthzUserGroupsOperations,
            TOKEN_GROUPS* pDeviceGroups,
            AUTHZ_SID_OPERATION* pAuthzDeviceGroupsOperations,
            AUTHZ_SECURITY_ATTRIBUTES_INFORMATION* pAuthzUserClaims,
            AUTHZ_SECURITY_ATTRIBUTE_OPERATION* pAuthzUserClaimsOperations,
            AUTHZ_SECURITY_ATTRIBUTES_INFORMATION* pAuthzDeviceClaims,
            AUTHZ_SECURITY_ATTRIBUTE_OPERATION* pAuthzDeviceClaimsOperations,
            EFFPERM_RESULT_LIST* pEffpermResultLists
        );
    }

}
