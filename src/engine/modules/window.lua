local ffi = require("ffi")
local ffiADV = require("ffi")
local user32, advapi32
local module = {}
local okay = true

if love.system.getOS() ~= "Windows" then
    return false
end

local success, err = pcall(function()
    user32 = ffi.load("user32.dll")
end)

local success, err = pcall(function()
    advapi32 = ffiADV.load("advapi32.dll")
end)

if not success then
    print("Failed to load user32.dll:", err)
    okay = false
end

if not okay then return end

ffi.cdef[[
typedef void* HWND;
typedef const char* LPCSTR;
typedef unsigned long DWORD;
typedef int BOOL;
typedef struct _WINDOWCOMPOSITIONATTRIBDATA {
    int Attribute;
    void* Data;
    size_t SizeOfData;
} WINDOWCOMPOSITIONATTRIBDATA;

HWND FindWindowA(const char* lpClassName, const char* lpWindowName);
BOOL SetWindowCompositionAttribute(HWND hwnd, WINDOWCOMPOSITIONATTRIBDATA* data);

BOOL ShowWindow(HWND hWnd, int nCmdShow);
]]

ffiADV.cdef[[
typedef unsigned long DWORD;
typedef const char* LPCSTR;
typedef void* HKEY;
typedef HKEY* PHKEY;
typedef unsigned long REGSAM;
typedef unsigned long LONG;

LONG RegOpenKeyExA(
    HKEY hKey,
    LPCSTR lpSubKey,
    DWORD ulOptions,
    REGSAM samDesired,
    PHKEY phkResult
);

LONG RegQueryValueExA(
    HKEY hKey,
    LPCSTR lpValueName,
    DWORD* lpReserved,
    DWORD* lpType,
    unsigned char* lpData,
    DWORD* lpcbData
);

LONG RegCloseKey(HKEY hKey);
]]

local WCA_USEDARKMODECOLORS = 26
local ffi_TRUE = ffi.new("int[1]", 1)
local ffi_FALSE = ffi.new("int[1]", 0)

local hwndCache = nil

local HKEY_CURRENT_USER = ffi.cast("void*", 0x80000001)
local KEY_QUERY_VALUE = 0x0001
local SUBKEY = "Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize"
local VALUE_NAME = "AppsUseLightTheme"

local function getWindowHandle()
    if hwndCache ~= nil then return hwndCache end

    local title = love.window.getTitle()
    if not title or title == "" then title = "LÖVE" end

    local hwnd = user32.FindWindowA(nil, title)
    if hwnd == nil then
        print("windowDarkMode: Failed to find HWND for title:", title)
        return nil
    end

    hwndCache = hwnd
    return hwnd
end

function module.setDarkMode(enable)
    local hwnd = getWindowHandle()
    if hwnd == nil then
        print("windowDarkMode: HWND not found (window may not exist yet)")
        return false
    end

    local darkMode = enable and ffi_TRUE or ffi_FALSE
    local data = ffi.new("WINDOWCOMPOSITIONATTRIBDATA")
    data.Attribute = WCA_USEDARKMODECOLORS
    data.Data = darkMode
    data.SizeOfData = ffi.sizeof(darkMode)

    local ok, err = pcall(function()
        user32.SetWindowCompositionAttribute(hwnd, data)
    end)

    if not ok then
        print("windowDarkMode: Failed to set dark mode:", err)
        return false
    end

    return true
end

function module.isDarkMode()
    local phKey = ffiADV.new("HKEY[1]")
    local result = advapi32.RegOpenKeyExA(
        HKEY_CURRENT_USER,
        SUBKEY,
        0,
        KEY_QUERY_VALUE,
        phKey
    )

    if result ~= 0 then
        return false
    end

    local data = ffiADV.new("DWORD[1]")
    local dataSize = ffiADV.new("DWORD[1]", ffiADV.sizeof("DWORD"))

    result = advapi32.RegQueryValueExA(
        phKey[0],
        VALUE_NAME,
        nil,
        nil,
        ffiADV.cast("unsigned char*", data),
        dataSize
    )

    advapi32.RegCloseKey(phKey[0])

    if result == 0 then
        return data[0] == 0
    else
        return false
    end
end

function module.getWindowHandle()
    return getWindowHandle()
end

function module.showWindow()
    local hwnd = getWindowHandle()
    if hwnd == nil then
        print("windowDarkMode: HWND not found (window may not exist yet)")
        return false
    end

    local SW_SHOW = 5
    user32.ShowWindow(hwnd, SW_SHOW)
    return true
end

function module.hideWindow()
    local hwnd = getWindowHandle()
    if hwnd == nil then
        print("windowDarkMode: HWND not found (window may not exist yet)")
        return false
    end

    local SW_HIDE = 0
    user32.ShowWindow(hwnd, SW_HIDE)
    return true
end

return module
