local SkinHandler = {}

SkinHandler.__path = ""
SkinHandler.__data = {}
SkinHandler.__sheets = {}
SkinHandler.info = {}
SkinHandler.batches = {}

local mt = {}
local restricted = {
    States = setmetatable({}, {
        __index = function(_, key)
           printToConsole("Access to States is restricted: " .. key)
        end,
        __newindex = function(_, key, value)
           printToConsole("Modification of States is restricted: " .. key .. " = " .. tostring(value))
        end
    }),
    os = {
        time = os.time,
        date = os.date,
        execute = function()
           printToConsole("os.execute is restricted")
        end,
    },
    love = {
        graphics = {
            newImage = function(path)
                return love.graphics.newImage(SkinHandler.__path .. path)
            end,
            newQuad = function(sheet, x, y, width, height)
                return love.graphics.newQuad(x, y, width, height, SkinHandler.__sheets[sheet]:getDimensions())
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
       printToConsole("Restricted require: " .. moduleName)
    end,
    dofile = function(filePath)
       printToConsole("Restricted dofile: " .. filePath)
    end,
}

local skinEnv = {
    newImage = restricted.love.graphics.newImage,
    newFont = restricted.love.graphics.newFont,
    newQuad = restricted.love.graphics.newQuad,

    newSource = restricted.love.audio.newSource,

    getInfo = restricted.love.filesystem.getInfo,
    read = restricted.love.filesystem.read,
    exists = restricted.love.filesystem.exists,

    getScreenCenter = function()
        return { x = baseScreenRatio.x / 2, y = baseScreenRatio.y / 2 }
    end,
    getScreenDimensions = function()
        return { width = baseScreenRatio.x, height = baseScreenRatio.y }
    end
}

local chunk

function SkinHandler:loadSkin(filePath)
    filePath = ("Skins/" .. filePath .. "/Skin.lua") or "Skins/Default Arrow/Skin.lua"
    self.__path = filePath:gsub("/Skin.lua", "/")
    self.__sheets = {}
    self.info = {
        hasBatchedArrows = false, -- if arrows, receptors and notes are batched
        hasBatchedReceptors = false, -- if receptors are batched
        hasBatchedNotes = false, -- if notes are batched
        hasBatchedJudgements = false, -- if judgements are batched
    }

    if love.filesystem.getInfo(self.__path .. "arrowsSheet.png") then
        self.__sheets.Arrows = love.graphics.newImage(self.__path .. "arrowsSheet.png")
    end

    if love.filesystem.getInfo(self.__path .. "receptorsSheet.png") then
        self.__sheets.Receptors = love.graphics.newImage(self.__path .. "receptorsSheet.png")
    end

    if love.filesystem.getInfo(self.__path .. "notesSheet.png") then
        self.__sheets.Notes = love.graphics.newImage(self.__path .. "notesSheet.png")
    end

    if love.filesystem.getInfo(self.__path .. "judgementsSheet.png") then
        self.__sheets.Judgements = love.graphics.newImage(self.__path .. "judgementsSheet.png")
    end

    self.info.hasBatchedArrows = self.__sheets.Arrows ~= nil
    self.info.hasBatchedReceptors = self.__sheets.Receptors ~= nil
    self.info.hasBatchedNotes = self.__sheets.Notes ~= nil
    self.info.hasBatchedJudgements = self.__sheets.Judgements ~= nil

    if self.info.hasBatchedArrows then
        self.batches.Arrows = love.graphics.newSpriteBatch(self.__sheets.Arrows, 1000, "stream")
    end
    if self.info.hasBatchedReceptors then
        self.batches.Receptors = love.graphics.newSpriteBatch(self.__sheets.Receptors, 1000, "stream")
    end
    if self.info.hasBatchedNotes then
        self.batches.Notes = love.graphics.newSpriteBatch(self.__sheets.Notes, 1000, "stream")
    end
    if self.info.hasBatchedJudgements then
        self.batches.Judgements = love.graphics.newSpriteBatch(self.__sheets.Judgements, 1000, "stream")
    end

    chunk = love.filesystem.load(filePath)
    for k, v in pairs(_G) do
        mt[k] = restricted[k] or v
    end
    for k, v in pairs(skinEnv) do
        mt[k] = v
    end
    setfenv(chunk, mt)
    chunk()

    self.__data = mt
end

function SkinHandler:getAllSkins()
    local skins = {}
    for _, file in ipairs(love.filesystem.getDirectoryItems("Skins")) do
        if love.filesystem.getInfo("Skins/" .. file .. "/Meta.lua") then
            local data = love.filesystem.load("Skins/" .. file .. "/Meta.lua")()
            if data then
                data.path = file
                table.insert(skins, data)
            end
        end
    end

    return skins
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

function SkinHandler:getBatch(name)
    if self.batches[name] then
        return self.batches[name]
    end
end

function SkinHandler:getSheet(name)
    if self.__sheets[name] then
        return self.__sheets[name]
    end
end

return SkinHandler