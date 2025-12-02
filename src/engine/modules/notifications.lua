local ffi = require("ffi")
local user32 = ffi.load("user32")
local shell32 = ffi.load("shell32")

local module = {}

ffi.cdef[[
typedef unsigned int UINT;
typedef const wchar_t* LPCWSTR;
typedef void* HWND;
typedef unsigned long DWORD;
typedef long HRESULT;

typedef struct _NOTIFYICONDATAW {
    DWORD cbSize;
    HWND hWnd;
    UINT uID;
    UINT uFlags;
    UINT uCallbackMessage;
    void* hIcon;
    wchar_t szTip[128];
    DWORD dwState;
    DWORD dwStateMask;
    wchar_t szInfo[256];
    union {
        UINT uTimeout;
        UINT uVersion;
    };
    wchar_t szInfoTitle[64];
    DWORD dwInfoFlags;
    void* guidItem;
    void* hBalloonIcon;
} NOTIFYICONDATAW;

int Shell_NotifyIconW(UINT dwMessage, NOTIFYICONDATAW* lpdata);

int MultiByteToWideChar(
    UINT CodePage,
    DWORD dwFlags,
    const char* lpMultiByteStr,
    int cbMultiByte,
    wchar_t* lpWideCharStr,
    int cchWideChar
);

HRESULT SetCurrentProcessExplicitAppUserModelID(const wchar_t *AppID);

HWND CreateWindowExW(unsigned long, const wchar_t*, const wchar_t*, unsigned long,
                     int, int, int, int,
                     HWND, void*, void*, void*);
HWND GetActiveWindow();

void* LoadIconW(void*, const wchar_t*);
]]

local NIM_ADD    = 0x00000000
local NIM_MODIFY = 0x00000001
local NIM_DELETE = 0x00000002
local NIF_INFO   = 0x00000010
local NIF_MESSAGE= 0x00000001
local NIF_ICON   = 0x00000002
local NIF_TIP    = 0x00000004

local NIIF_NONE  = 0x00000000
local NIIF_INFO  = 0x00000001
local NIIF_WARNING = 0x00000002
local NIIF_ERROR = 0x00000003

local CP_UTF8 = 65001

local function utf8ToWideFixed(str, size)
    local buf = ffi.new("wchar_t[?]", size)
    local len = 0
    if str and #str > 0 then
        len = ffi.C.MultiByteToWideChar(CP_UTF8, 0, str, #str, buf, size-1)
        if len < 0 then len = 0 end
    end
    buf[len] = 0
    return buf, tonumber(len)
end

local nextUID = 2
local activeNotifs = {}

function module.setAppID(appid)
    if not appid or #appid == 0 then return false, "no appid" end
    local w, len = utf8ToWideFixed(appid, #appid*2 + 4)
    if shell32.SetCurrentProcessExplicitAppUserModelID then
        local hr = shell32.SetCurrentProcessExplicitAppUserModelID(w)
        if hr == 0 then
            module.appid = appid
            return true
        else
            return false, ("SetAppID failed (hr=0x%X)"):format(hr)
        end
    else
        return false, "SetCurrentProcessExplicitAppUserModelID not available"
    end
end

local function getHWND()
    if module.appid then
        if not module.hwnd then
            local wAppID, len = utf8ToWideFixed(module.appid, #module.appid*2 + 4)
            module.hwnd = user32.CreateWindowExW(0, wAppID, wAppID, 0, 0, 0, 0, 0, nil, nil, nil, nil)
        end
        return module.hwnd
    else
        return user32.GetActiveWindow()
    end
end

local WM_USER = 0x0400

function module.showNotification(title, text, timeout_ms, opts)
    opts = opts or {}
    timeout_ms = timeout_ms or 5000

    local uid = nextUID
    nextUID = nextUID + 1

    local hwnd = getHWND()

    local nid = ffi.new("NOTIFYICONDATAW")
    nid.cbSize = ffi.sizeof(nid)
    nid.hWnd = hwnd
    nid.uID = uid
    nid.uFlags = bit.bor(NIF_ICON, NIF_MESSAGE, NIF_TIP)
    nid.uCallbackMessage = WM_USER + 1

    nid.hIcon = user32.LoadIconW(nil, ffi.cast("const wchar_t*", 32512))

    local ok = shell32.Shell_NotifyIconW(NIM_ADD, nid)
    if ok == 0 then
        return nil, "Shell_NotifyIconW failed to add notification"
    end

    local wTitle, titleLen = utf8ToWideFixed(title or "Notification", 64)
    local wText, textLen = utf8ToWideFixed(text or "", 256)

    nid.uFlags = NIF_INFO
    nid.uTimeout = timeout_ms
    nid.dwInfoFlags = opts.infoFlags or NIIF_INFO

    ffi.copy(nid.szInfoTitle, wTitle, titleLen * 2)
    ffi.copy(nid.szInfo, wText, textLen * 2)

    shell32.Shell_NotifyIconW(NIM_MODIFY, nid)

    local now = (love and love.timer and love.timer.getTime and love.timer.getTime()) or os.time()
    local expiry = now + (timeout_ms / 1000)
    activeNotifs[uid] = expiry

    return uid
end


function module.update()
    local now = (love and love.timer and love.timer.getTime and love.timer.getTime()) or os.time()
    for uid, expiry in pairs(activeNotifs) do
        if now >= expiry then
            local nid = ffi.new("NOTIFYICONDATAW")
            nid.cbSize = ffi.sizeof(nid)
            nid.hWnd = nil
            nid.uID = uid
            shell32.Shell_NotifyIconW(NIM_DELETE, nid)
            activeNotifs[uid] = nil
        end
    end
end

function module.clearAll()
    for uid, _ in pairs(activeNotifs) do
        local nid = ffi.new("NOTIFYICONDATAW")
        nid.cbSize = ffi.sizeof(nid)
        nid.hWnd = nil
        nid.uID = uid
        shell32.Shell_NotifyIconW(NIM_DELETE, nid)
        activeNotifs[uid] = nil
    end
end

function module.notify(title, text, timeout_ms, opts)
    return module.showNotification(title, text, timeout_ms, opts)
end

return module
