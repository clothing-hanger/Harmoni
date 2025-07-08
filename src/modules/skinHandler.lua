local SkinHandler = {}

SkinHandler.__path = ""
SkinHandler.__data = {}

local mt = {}
local restricted = {
    States = setmetatable({}, {
        __index = function(_, key)
            print("Access to States is restricted: " .. key)
        end,
        __newindex = function(_, key, value)
            print("Modification of States is restricted: " .. key .. " = " .. tostring(value))
        end,
    }),
    os = {
        time = os.time,
        date = os.date,
        execute = function() 
            print("os.execute is restricted") 
        end,
    },
    love = {
        graphics = {
            newImage = function(path)
                return love.graphics.newImage(SkinHandler.__path .. path)
            end,
            newFont = function(path, size)
                return love.graphics.newFont(SkinHandler.__path .. path, size)
            end,
        },
        audio = {
            newSource = function(path, type)
                return love.audio.newSource(SkinHandler.__path .. path, type)
            end,
        },
        filesystem = {
            getInfo = function(path)
                return love.filesystem.getInfo(SkinHandler.__path .. path)
            end,
            read = function(path)
                return love.filesystem.read(SkinHandler.__path .. path)
            end,
            exists = function(path)
                return love.filesystem.exists(SkinHandler.__path .. path)
            end,
        },
    },
    Skin = {},
    require = function(moduleName)
        print("Restricted require: " .. moduleName)
    end,
    dofile = function(filePath)
        print("Restricted dofile: " .. filePath)
    end,
}

local skinEnv = {
    newImage = restricted.love.graphics.newImage,
    newFont = restricted.love.graphics.newFont,

    newSource = restricted.love.audio.newSource,

    getInfo = restricted.love.filesystem.getInfo,
    read = restricted.love.filesystem.read,
    exists = restricted.love.filesystem.exists
}

local chunk

function SkinHandler:loadSkin(filePath)
    filePath = ("Skins/" .. filePath .. "/Skin.lua") or "Skins/Default Arrow/Skin.lua"
    self.__path = filePath:gsub("/Skin.lua", "/")

    chunk = love.filesystem.load(filePath)
    print(chunk)
    for k, v in pairs(_G) do
        mt[k] = restricted[k] or v
    end
    for k, v in pairs(skinEnv) do
        mt[k] = v
    end
    setfenv(chunk, mt)
    chunk()

    self.__data = mt

    print(SkinHandler:getImage("Notes", "4K", "Left"))
end

function SkinHandler:getParam(param)
    if self.__data.Skin.Params then
        return self.__data.Skin.Params[param]
    end
end

function SkinHandler:getFont(param)
    if self.__data.Skin.Fonts then
        return self.__data.Skin.Fonts[param]
    end
end

function SkinHandler:getSound(param)
    if self.__data.Skin.Sounds then
        return self.__data.Skin.Sounds[param]
    end
end

function SkinHandler:getColor(param)
    if self.__data.Skin.Colors then
        return self.__data.Skin.Colors[param]
    end
end

function SkinHandler:getImage(...)
    local args = {...}

    local b = SkinHandler.__data.Skin

    for i = 1, #args do
        local key = tostring(args[i])
        if type(b) ~= "table" then return nil end
        b = b[key]
    end

    return b
end

return SkinHandler