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
elseif os == "Linux" or os == "OSX" then
    ffi.cdef[[
int setenv(const char *name, const char *value, int overwrite);
const char *getenv(const char *name);
]]
end

function setenv(name, value)
    if os == "Windows" then
        return ffi.C._putenv(name .. "=" .. value)
    else
        return ffi.C.setenv(name, value, 1)
    end
end

function getenv(name)
    return ffi.string(ffi.C.getenv(name))
end

local installThread = love.thread.newThread([[
require("love.system")
require("love.filesystem")

local function copyToSave(src)
    local data = love.filesystem.read("data", src)
    local filename = src:match("clibs[/\\][^/\\]+[/\\](.+)$")
    print(filename)
    love.filesystem.write("clibs/"..filename, data)
end

local os = love.system.getOS()
local arch = love.system.getProcessorCount() > 4 and "x64" or "x86"
for _, file in ipairs(love.filesystem.getDirectoryItems("clibs/" .. os .. arch)) do
    if not love.filesystem.getInfo("clibs/"..file) then
        copyToSave("clibs/"..os .. arch .. "/" ..file)
    end
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
    tryExcept(function()
        local save = love.filesystem.getSaveDirectory()
        local base = love.filesystem.getCRequirePath()

        local newPaths = base .. ";clibs/??" .. ";" .. save .. "/clibs/??"

        local sep = package.config:sub(1,1)
        local save = love.filesystem.getSaveDirectory()
        local clibs = save .. sep .. "clibs"

        local path = getenv("PATH") or "" -- this is just a temporary path change, its only available for this session !! do not fear !!
        setenv("PATH", path .. ";" .. clibs)

        love.filesystem.setCRequirePath(newPaths)
        package.cpath = package.cpath
            .. ";" .. save .. sep .. "clibs" .. sep .. "?.dll"
            .. ";" .. save .. sep .. "clibs" .. sep .. "loadall.dll"
        DLL_Video = require("video")
    end, function(err)
        print("Warning: Could not load video DLL. Video playback will be disabled.")
        print("Error message: " .. err)
    end)
    video = require("objects.game.shared.video")
end

return CLibs