love.filesystem.load("Skins/Default Arrow/Skin.lua")()

function convertScrollSpeed(speed)
    print("unconverted scroll speed:" .. speed)
    local convertedSpeed = (Inits.GameHeight) / speed
    print("converted scroll speed:" .. convertedSpeed)
    return convertedSpeed
end


settingsData = {
    ["Gameplay"] = {
        id = 1,
        scrollSpeed = {type = "number", value = 480, min = 100, max = 10000, name = "Scroll Speed", description = "How long in milliseconds it takes the notes to reach the receptors"},
        backgroundDimness = {type = "number", value = 80, min = 0, max = 100, name = "Background Dimness", description = "How dim the background in"},
        laneWidth = {type = "number", value = 120, min = 30, max = 500, name = "Lane Width", description = "The distance between the note lanes"},
        laneHeight = {type = "number", value = 110, min = 0, max = Inits.GameHeight/2, description = "The distance between the receptors and the edge of the screen"},
    },
    ["Key Binds"] = {
        id = 2,
        ["4 Key"] = {
            lane1 = "d",
            lane2 = "f",
            lane3 = "j",
            lane4 = "k",
        },
        ["7 Key"] = {
            lane1 = "s",
            lane2 = "d",
            lane3 = "f",
            lane4 = "space",
            lane5 = "j",
            lane6 = "k",
            lane7 = "l"
        },
    },
}

Settings = {}

for category, SettingsTab in pairs(settingsData) do
    if category ~= "Key Binds" then
        for settingKey, setting in pairs(SettingsTab) do
            if settingKey ~= "id" then
                print(setting)
                Settings[settingKey] = setting.value
            end
        end
    end
end

Settings.scrollSpeed = convertScrollSpeed(Settings.scrollSpeed)
Settings.backgroundDimness = Settings.backgroundDimness/100

LanesPositions = {
    Inits.GameWidth/2 - (Settings.laneWidth*1.5),
    Inits.GameWidth/2 - (Settings.laneWidth*0.5),
    Inits.GameWidth/2 + (Settings.laneWidth*0.5),
    Inits.GameWidth/2 + (Settings.laneWidth*1.5),
}
