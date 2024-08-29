function loadSettings()
    settingsFile = love.filesystem.load("Settings/Settings.lua")

    if not settingsFile then
        States.Menu.SettingsMenu:saveSettings()  -- sets up default settings
    end
        
    -- check for missing settings
    Settings = settingsFile()
   -- local hasMissing = States.Menu.SettingsMenu:checkForMissingSettings()
    print(tostring(hasMissing))
    if hasMissing then
    --    States.Menu.SettingsMenu:saveSettings()
    end
    
    LanesPositions = {
        ["4K"] = {
            Inits.GameWidth/2 - (Settings.laneWidth*1.5),
            Inits.GameWidth/2 - (Settings.laneWidth*0.5),
            Inits.GameWidth/2 + (Settings.laneWidth*0.5),
            Inits.GameWidth/2 + (Settings.laneWidth*1.5),
        },
        ["7K"] = {
            Inits.GameWidth/2 - (Settings.laneWidth*3),
            Inits.GameWidth/2 - (Settings.laneWidth*2),
            Inits.GameWidth/2 - (Settings.laneWidth),
            Inits.GameWidth/2,
            Inits.GameWidth/2 + (Settings.laneWidth),
            Inits.GameWidth/2 + (Settings.laneWidth*2),
            Inits.GameWidth/2 + (Settings.laneWidth*3),
        }
    }

    if Settings.keyBinds4k then
        keyBinds4k = splitIntoLetters(Settings.keyBinds4k)
    else
        Settings.keyBinds4k = splitIntoLetters("dfjk")
    end
    if Settings.keyBinds7k then
        keyBinds7k = splitIntoLetters(Settings.keyBinds7k)
    else
        keyBinds7k = splitIntoLetters("sdf jkl")
    end

    Input = setupControls()
end

love.filesystem.load("Skins/Default Arrow/Skin.lua")()

---@param speed number The speed in ms
---@return number convertedScrollspeed the speed in pixels/ms
function convertScrollSpeed(speed)
    local convertedSpeed = (Inits.GameHeight) / speed
    return convertedSpeed
end
