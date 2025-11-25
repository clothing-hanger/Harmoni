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

if os == "Windows" then
    ffi.cdef[[
        int _putenv(const char *envstring);
        const char *getenv(const char *name);
    ]]
else
    ffi.cdef[[
        int setenv(const char *name, const char *value, int overwrite);
        const char *getenv(const char *name);
    ]]
end

local function setenv(name, value)
    if os == "Windows" then
        return ffi.C._putenv(name .. "=" .. value)
    else
        return ffi.C.setenv(name, value, 1)
    end
end

local function getenv(name)
    return ffi.string(ffi.C.getenv(name))
end

local CURRENT_VIDEO_VERSION = "1.1"

local installThread = love.thread.newThread([[
require("love.system")
require("love.filesystem")

local os = love.system.getOS()
local arch = love.system.getProcessorCount() > 4 and "x64" or "x86"

local function copyToSave(src, dst)
    local data = love.filesystem.read("data", src)
    love.filesystem.write(dst, data)
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
]])

local CLibs = {}

function CLibs:setupIfNeeded()
    love.filesystem.createDirectory("clibs")
    installThread:start()
end

function CLibs:isInstallationDone()
    return outchannel:peek() ~= nil
end

function CLibs:after()
    outchannel:pop()
    local save = love.filesystem.getSaveDirectory()
    local sep = package.config:sub(1,1)
    local clibs = save .. sep .. "clibs"

    local path = getenv("PATH") or ""
    setenv("PATH", path .. ";" .. clibs)

    local base = love.filesystem.getCRequirePath()
    local newPaths = base .. ";clibs/??" .. ";" .. save .. "/clibs/??"
    love.filesystem.setCRequirePath(newPaths)

    package.cpath = package.cpath
        .. ";" .. save .. sep .. "clibs" .. sep .. "?.dll"
        .. ";" .. save .. sep .. "clibs" .. sep .. "loadall.dll"

    tryExcept(function()
        DLL_Video = require("video")
    end, function(err)
        print("Warning: Could not load video DLL. Video playback will be disabled.")
        print("Error message: " .. err)
    end)

    video = require("objects.game.shared.video")
end

return CLibs
