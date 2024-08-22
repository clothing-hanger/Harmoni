function loadSettings()
    settingsFile = love.filesystem.load("Settings/Settings.lua")

    if not settingsFile then
        States.Menu.SettingsMenu:saveSettings()  -- sets up default settings
    end

    Settings = settingsFile()
    print(Settings.backgroundDim)
    
    LanesPositions = {
        Inits.GameWidth/2 - (Settings.laneWidth*1.5),
        Inits.GameWidth/2 - (Settings.laneWidth*0.5),
        Inits.GameWidth/2 + (Settings.laneWidth*0.5),
        Inits.GameWidth/2 + (Settings.laneWidth*1.5),
    }

    keyBinds4k = splitIntoLetters(Settings.keyBinds4k)

    setupControls()

end

love.filesystem.load("Skins/Default Arrow/Skin.lua")()





function convertScrollSpeed(speed)
    local convertedSpeed = (Inits.GameHeight) / speed
    return convertedSpeed
end


