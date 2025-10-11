local LocaleHandler = {}

LocaleHandler.__path = {}

LocaleHandler.__data = {}
LocaleHandler.__sheets = {}

LocaleHandler.info = {}

local mt = {} -- ????

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
           printToConsole("os.execute is restricted")  -- but it would be so funny...
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


function LocaleHandler:loadLocale(file)
    local file = (file or "en-US.lua")
    local filepath = "language/" .. (file)
    local chunk = love.filesystem.load(filepath)

    for k, v in pairs(_G) do
        mt[k] = restricted[k] or v
    end

    setfenv(chunk, mt)
    chunk()
    
    self.__data = {
        Locale = mt.Language
    }
end

function LocaleHandler:getAllLocales()
    local locales = {}
    local data
    for _, file in ipairs(love.filesystem.getDirectoryItems("language")) do
        if getFileExtension(file) == "lua" then
            data = love.filesystem.load(file)
        end
        if data then
            data.path = file
            table.insert(locales, data) 
        end
    end
    return locales
end

function LocaleHandler:getText(category, text)
    if self.__data.Locale[category] then
        if self.__data.Locale[category][text] then
            return self.__data.Locale[category][text]
        else
            return "???"
        end
    else return "???" end
end

return LocaleHandler