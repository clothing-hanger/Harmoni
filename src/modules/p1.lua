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

local settingsFileTemplate = { -- What gets saved
    Game = {
        Mania = {
            ["Scroll Direction"] = {
                value = "Up",
            },
            ["Scroll Speed"] = {
                value = 600
            },
            ["Lane Spacing"] = {
                value = 35
            },
            ["Lane Height"] = {
                value = 35
            }
        }
    }
}

function Settings:defaultSettings()
    local defaultSettings = {}
    for category, data in pairs(Settings.SettingsTable) do
        defaultSettings[category] = {}
        for subCategory, subData in pairs(data) do
            if subData.settings then
                defaultSettings[category][subCategory] = {}
                for settingName, settingData in pairs(subData.settings) do
                    defaultSettings[category][subCategory][settingName] = {
                        value = settingData.defaultValue
                    }
                end
            end
        end
    end
    return defaultSettings
end

function Settings:loadSettings()
    -- push the values into Settings.SettingsTable
    local settingsFile = love.filesystem.load("Settings/Settings.lua")
    if settingsFile then
        local success, loadedSettings = pcall(settingsFile)
        if success then
            self.SettingsTable = loadedSettings
        else
            print("Error loading settings: " .. loadedSettings)
        end
    else
        print("Settings file not found, creating default settings.")
        self.SettingsTable = self:defaultSettings()
    end
end

function Settings:checkForMissingSettings()
    local missingSettings = {}
    for category, data in pairs(self.SettingsTable) do
        if not settingsFileTemplate[category] then
            missingSettings[category] = true
        else
            for subCategory, subData in pairs(data) do
                if not settingsFileTemplate[category][subCategory] then
                    missingSettings[subCategory] = true
                else
                    for settingName, settingData in pairs(subData.settings or {}) do
                        if not settingsFileTemplate[category][subCategory][settingName] then
                            missingSettings[settingName] = true
                        end
                    end
                end
            end
        end
    end

    return missingSettings
end

function Settings:createSettingsFile()
    local missingSettings = self:checkForMissingSettings()
    if next(missingSettings) then
        print("Missing settings detected, creating settings file with defaults.")
        table.save(self:defaultSettings(), "Settings/Settings.lua")
        self:loadSettings() -- Reload the settings after creating the file
    else
        print("No missing settings detected.")
    end
end

setmetatable(Settings, {
    -- make it check Settings.SettingsTable first, then Settings.defaultSettings, then lastly THIS
    __index = function(t, key)
        if t.SettingsTable[key] then
            return t.SettingsTable[key]
        elseif t.defaultSettings()[key] then
            return t.defaultSettings()[key]
        else
            return rawget(t, key)
        end
    end
})

return Settings