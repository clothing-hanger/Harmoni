function loadSettings()
    settingsFile = love.filesystem.load("Settings/Settings.lua")
    Settings = settingsFile()
    print(Settings.backgroundDim)
    
    LanesPositions = {
        Inits.GameWidth/2 - (Settings.laneWidth*1.5),
        Inits.GameWidth/2 - (Settings.laneWidth*0.5),
        Inits.GameWidth/2 + (Settings.laneWidth*0.5),
        Inits.GameWidth/2 + (Settings.laneWidth*1.5),
    }

end

love.filesystem.load("Skins/Default Arrow/Skin.lua")()





function convertScrollSpeed(speed)
    local convertedSpeed = (Inits.GameHeight) / speed
    return convertedSpeed
end


