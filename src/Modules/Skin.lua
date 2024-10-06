---@diagnostic disable: missing-parameter
Skin = {}

SkinFolder = ""

local mt = {}
local restricted = {
    States = setmetatable({}, {
        __index = function() print("Not allowed.") end,
        __newindex = function() print("Not allowed.") end
    }),
    os = {
        time = os.time,
        date = os.date,
        execute = function() print("Why do you need os.execute? Not allowed.") end
    },
    love = {
        graphics = {
            newImage = function(path)
                return love.graphics.newImage(SkinFolder .. path)
            end,
            newFont = function(path, size)
                return love.graphics.newFont(SkinFolder .. path, size)
            end
        },
        audio = {
            newSource = function(path, sourceType)
                return love.audio.newSource(SkinFolder .. path, sourceType)
            end
        },
        filesystem = {
            load = function(path)
                return love.filesystem.load(SkinFolder .. path)
            end
        }
    },
    Skin = {},
    require = function()
        print("Not allowed.")
    end,
    dofile = function()
        print("Not allowed.")
    end
}
local skinEnv = {
    newImage = function(path)
        return love.graphics.newImage(SkinFolder .. path)
    end,
    newFont = function(path, size)
        return love.graphics.newFont(SkinFolder .. path, size)
    end,
    newAudioSource = function(path, sourceType)
        return love.audio.newSource(SkinFolder .. path, sourceType)
    end
}

local chunk

---@param path? string
function Skin:loadSkin(path)
    local path = path or "Skins/Default Arrow/Skin.lua"
    SkinFolder = path:gsub("Skin.lua", "")

    chunk = love.filesystem.load(path)
    for k, v in pairs(_G) do
        mt[k] = restricted[k] or v
    end
    for k, v in pairs(skinEnv) do
        mt[k] = v
    end
    setfenv(chunk, mt)
    chunk()

    setmetatable(Skin, {
        __index = mt.Skin
    })
end