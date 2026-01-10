local songScript = {}

songScript.__path = ""
songScript.__events = {}

local mt = {}
local restricted = {
    States = setmetatable({}, {
        __index = function(_, key)
            print("Access to States is restricted: " .. key)
        end,
        __newindex = function(_, key, value)
            print("Modification of States is restricted: " .. key .. " = " .. tostring(value))
        end
    }),
    os = {
        time = os.time,
        date = os.date,
        execute = function()
            print("os.execute is restricted")
        end,
    },
    love = {
        __index = function(_, key)
            print("Access to love is restricted: " .. key)
        end,
    },
    Skin = {},
    require = function(moduleName)
        print("Restricted require: " .. moduleName)
    end,
    dofile = function(filePath)
        print("Restricted dofile: " .. filePath)
    end
}

local scriptEnv = {

}

function songScript:loadScript(path)
    self.__events = {}
    if not love.filesystem.getInfo(path .. "mod.lua") then
        print("Script file not found: " .. path .. "mod.lua")
        return
    end
    self.__path = path or ""
    local chunk = love.filesystem.load(path .. "mod.lua")
    for k, v in pairs(_G) do
        mt[k] = restricted[k] or v
    end
    for k, v in pairs(scriptEnv) do
        mt[k] = v
    end
    setfenv(chunk, mt)
    local success, runErr = pcall(chunk)
    if not success then
        print("Error running script: " .. runErr)
    end
end

function songScript:call(func, ...)
    if type(mt[func]) == "function" then
        local success, err = pcall(mt[func], ...)
        if not success then
            print("Error calling function '" .. func .. "': " .. err)
        end
        return err
    else
        print("Function '" .. func .. "' not found in script")
    end
end

return songScript