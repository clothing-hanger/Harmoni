local sep = package.config:sub(1,1)
package.cpath = package.cpath .. string.format(";.%sclibs%s?.dll", sep, sep)
local os = love.system.getOS()
local ext = ({
    Windows = ".dll",
    Linux   = ".so",
    OSX     = ".dylib"
})[os] or ".dll"

local outchannel = love.thread.getChannel("clib_install_done")
local ffi = require("ffi")

local WIN_LOAD_LIBRARY_SEARCH_DEFAULT_DIRS = 0x00001000
local WIN_LOAD_LIBRARY_SEARCH_USER_DIRS = 0x00000400

if os == "Windows" then
    ffi.cdef[[
        int _putenv(const char *envstring);
        const char *getenv(const char *name);
        int SetDllDirectoryW(const wchar_t *lpPathName);
        void* AddDllDirectory(const wchar_t* NewDirectory);
        int SetDefaultDllDirectories(unsigned long DirectoryFlags);
    ]]
else
    ffi.cdef[[
        int setenv(const char *name, const char *value, int overwrite);
        const char *getenv(const char *name);
    ]]
end

local function toWide(str)
    local w = ffi.new("wchar_t[?]", #str + 1)
    for i = 1, #str do
        w[i - 1] = str:byte(i)
    end
    w[#str] = 0
    return w
end

local function setenv(name, value)
    if os == "Windows" then
        return ffi.C._putenv(name .. "=" .. value)
    else
        return ffi.C.setenv(name, value, 1)
    end
end

local function getenv(name)
    -- windows can return null pointers, so we need to handle that
    -- (like what the fuck windows)
    local res = ffi.C.getenv(name)
    if res == nil then
        return nil
    else
        return ffi.string(res)
    end
end

local save = love.filesystem.getSaveDirectory()
local clibs = save .. sep .. "clibs"
--[[ ffi.C.SetDllDirectoryW(toWide(clibs)) ]]

local CURRENT_VIDEO_VERSION = "2.2"

local installThread
local installThreadCode = [[
require("love.system")
require("love.filesystem")

local os = love.system.getOS()
local arch = jit and jit.arch or love.system.getProcessorCount() > 4 and "x64" or "x86"

local function copyToSave(src, dst)
    local data, err = love.filesystem.read("data", src)
    if not data then
        error("Failed to read " .. src .. ": " .. err)
    end
    assert(love.filesystem.write(dst, data))
end

-- Check version
local saveDir = love.filesystem.getSaveDirectory()
local versionPath = saveDir .. "/videoversion.txt"
local needUpdate = true

if love.filesystem.getInfo("videoversion.txt") then
    local ver = love.filesystem.read("videoversion.txt")
    if ver:match("^(%S+)") == "]] .. CURRENT_VIDEO_VERSION .. [[" then
        needUpdate = false
    end
end

if needUpdate then
    for _, file in ipairs(love.filesystem.getDirectoryItems("clibs/" .. os .. arch)) do
        copyToSave("clibs/"..os..arch.."/"..file, "clibs/"..file)
    end
    love.filesystem.write("videoversion.txt", "]] .. CURRENT_VIDEO_VERSION .. [[\n")
end

love.thread.getChannel("clib_install_done"):push(true)
]]

local CLibs = {}

function CLibs:setupIfNeeded()
    love.filesystem.createDirectory("clibs")
    installThread = love.thread.newThread(installThreadCode)
    installThread:start()
    print("Setting up C Libraries...")
end

function CLibs:isInstallationDone()
    return outchannel:peek() ~= nil
end

function CLibs:after()
    print("Finalizing C Libraries setup...")
    outchannel:pop()

    if not package.cpath:find(clibs, 1, true) then
        package.cpath = package.cpath .. ";" .. clibs .. sep .. "?.dll"
    end

    local path = getenv("PATH")
    if not path then path = "" end
    ffi.C.SetDefaultDllDirectories(
        WIN_LOAD_LIBRARY_SEARCH_DEFAULT_DIRS + WIN_LOAD_LIBRARY_SEARCH_USER_DIRS
    )

    local cookie = ffi.C.AddDllDirectory(toWide(clibs))
    assert(cookie ~= nil, "AddDllDirectory failed")
    print("Updated PATH environment variable.")

    local base = love.filesystem.getCRequirePath()
    local newPaths = base .. ";clibs/??" .. ";" .. save .. "/clibs/??"
    love.filesystem.setCRequirePath(newPaths)
    print("Updated love.filesystem C require path.")

    tryExcept(function()
        local libname = "video"
        if os == "Linux" then
            libname = "libvideo"
        end
        print("Loading video DLL: " .. libname .. ext)
        love.timer.sleep(0.1)
        DLL_Video = require(libname)
        print("Successfully loaded video DLL.")
    end, function(err)
        print("Warning: Could not load video DLL. Video playback will be disabled.")
        print("Error message: " .. err)
    end)

    print("Requiring video module...")
    video = require("objects.game.shared.video")

    print("C Libraries setup complete.")
end

return CLibs
