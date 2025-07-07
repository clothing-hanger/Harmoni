local Settings = {}

Settings.SettingsTable = {
    ["Game"] = {
        meta = {index = 1},
        description = "These settings affect how the game plays",
        ["Mania"] = {
            meta = {index = 1},
            settings = {
                ["Scroll Direction"] = {
                    meta = {index = 1},
                    type = "dropdown",
                    options = {
                        "Up",
                        "Down",
                    },
                    value = "Up",
                    defaultValue = "Up",
                    description = "Direction the notes scroll"
                },
                ["Scroll Speed"] = {
                    meta = {index = 2},
                    type = "slider",
                    min = 300,
                    max = 3000,
                    value = 600,
                    defaultValue = 600,
                    description = "How quickly the notes travel across the screen (in milliseconds)"
                },
                ["Lane Spacing"] = {
                    meta = {index = 3},
                    type = "slider",
                    min = 10,
                    max = 130,
                    value = 35,
                    defaultValue = 35,
                    description = "The space between your note lanes",
                },
                ["Lane Height"] = {
                    meta = {index = 4},
                    type = "slider",
                    min = 10,
                    max = 130,
                    value = 35,
                    defaultValue = 35,
                    description = "The space between your receptors and the edge of your screen",
                }
            }
        }
    }
}

Settings.defaultSettings = function()

end

Settings.createSettingsFile = function()
    love.filesystem.write("Settings.Settings.lua")
end

return Settings