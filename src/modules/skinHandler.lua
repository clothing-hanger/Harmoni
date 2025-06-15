local SkinHandler = {}

function SkinHandler:loadSkin(skinName)
    local skinLuaPathwithoutLuaLmao = "Skins." .. skinName .. ".Skin"
    local skinLuaPathwithLuaLmao = skinLuaPathwithoutLuaLmao .. ".lua"

    print("Loading skin: " .. skinLuaPathwithLuaLmao)
 
   -- if not love.filesystem.getInfo(skinLuaPathwithLuaLmao .. ".lua", "file") then  -- add .lua here cuz require is fucking stupid
   --     error("Skin not found: " .. skinLuaPathwithLuaLmao)  -- remember to fucking remove this later lmao
   -- end

    local skin = require(skinLuaPathwithoutLuaLmao)

    return skin
end

return SkinHandler