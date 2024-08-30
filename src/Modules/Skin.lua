Skin = {}

local mt = {}
local restricted = {
    States = setmetatable({}, {
        __index = function() print("Not allowed.") end,
        __newindex = function() print("Not allowed.") end
    }),
    os = {
        time = os.time,
        date = os.date,
    },
}
local chunk

---@param path? string
function Skin:loadSkin(path)
    local path = path or "Skins/Default Arrow/Skin.lua"

    chunk = love.filesystem.load(path)
    for k, v in pairs(_G) do
        mt[k] = restricted[k] or v
    end
    setfenv(chunk, mt)
    chunk()

    setmetatable(Skin, {
        __index = mt.Skin
    })
end