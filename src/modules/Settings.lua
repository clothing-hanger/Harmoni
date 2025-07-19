local Settings = {}

Settings.SettingsTable = {
    ["Game"] = {
        meta = { index = 1 },
        description = "These settings affect how the game plays",
        ["Mania"] = {
            meta = { index = 1 },
            settings = {
                ["Scroll Direction"] = {
                    meta = { index = 1 },
                    type = "dropdown",
                    options = { "Up", "Down" },
                    value = "Up",
                    defaultValue = "Up",
                    description = "Direction the notes scroll"
                },
                ["Scroll Speed"] = {
                    meta = { index = 2 },
                    type = "slider",
                    min = 300,
                    max = 3000,
                    value = 480,
                    defaultValue = 480,
                    description = "How quickly the notes travel across the screen (in milliseconds)"
                },
                ["Lane Spacing"] = {
                    meta = { index = 3 },
                    type = "slider",
                    min = 10,
                    max = 130,
                    value = 35,
                    defaultValue = 35,
                    description = "The space between your note lanes"
                },
                ["Lane Height"] = {
                    meta = { index = 4 },
                    type = "slider",
                    min = 10,
                    max = 130,
                    value = 35,
                    defaultValue = 35,
                    description = "The space between your receptors and the edge of your screen"
                },
                ["Skin"] = {
                    meta = { index = 1 },
                    type = "dropdown",
                    options = {
                        "Default Arrow",
                        "Default Arrow Batched",
                    },
                    value = "Default Arrow Batched",
                    defaultValue = "Default Arrow Batched",
                    description = "The skin used for Mania"
                }
            }
        }
    }
}

function Settings:defaultSettings()
    local defaults = {}
    for category, data in pairs(self.SettingsTable) do
        defaults[category] = {}
        for subCategory, subData in pairs(data) do
            if type(subData) == "table" and subData.settings then
                defaults[category][subCategory] = {}
                for settingName, setting in pairs(subData.settings) do
                    defaults[category][subCategory][settingName] = {value = setting.defaultValue}
                end
            end
        end
    end
    return defaults
end

function Settings:loadSettings()
    local settingsFile = love.filesystem.load("Settings/Settings.lua")
    local defaultValues = self:defaultSettings()
    self.loadedSettings = defaultValues -- fallback if no file

    if settingsFile then
        local success, loadedSettings = pcall(settingsFile)
        if success and type(loadedSettings) == "table" then
            self.loadedSettings = self:mergeSettings(defaultValues, loadedSettings)
        else
            print("Error loading settings, reverting to defaults:", loadedSettings)
        end
    else
        print("Settings file not found, creating with defaults.")
    end

    self:writeSettings()
end

function Settings:mergeSettings(defaults, current)
    local merged = {}
    for category, subCategories in pairs(defaults) do
        merged[category] = merged[category] or {}
        for subCategory, settings in pairs(subCategories) do
            merged[category][subCategory] = merged[category][subCategory] or {}
            for settingName, defaultValue in pairs(settings) do
                merged[category][subCategory][settingName] =
                    (current[category] and current[category][subCategory] and current[category][subCategory][settingName])
                    or defaultValue
            end
        end
    end
    return merged
end

function Settings:getValue(category, subCategory, settingName)
    return self.loadedSettings[category][subCategory][settingName].value
end

function Settings:setValue(category, subCategory, settingName, value)
    self.loadedSettings[category][subCategory][settingName] = value
end

function Settings:writeSettings()
    local function indexer(key)
        if tonumber(key) then return "" else return "['" .. key .. "'] = " end
    end

    local function tableToString(tbl, indent)
        indent = indent or ""
        local str = "{"
        for k, v in pairs(tbl) do
            local keyStr = indexer(k)
            if type(v) == "table" then
                str = str .. "\n" .. indent .. keyStr .. tableToString(v, indent .. "  ") .. ","
            elseif type(v) == "string" then
                str = str .. "\n" .. indent .. keyStr .. "\"" .. v .. "\","
            else
                str = str .. "\n" .. indent .. keyStr .. tostring(v) .. ","
            end
        end
        str = str .. "\n" .. indent .. "}"
        return str
    end

    local settingsString = "return " .. tableToString(self.loadedSettings, "  ")
    local success, err = love.filesystem.write("Settings/Settings.lua", settingsString)
    if not success then
        print("Error writing settings file: " .. tostring(err))
    else
        print("Settings saved successfully.")
    end
end

function table.find(t, value)
    for i, v in ipairs(t) do
        if v == value then return i end
    end
    return nil
end

function Settings:addSkinsToSettings(skins)
    local skinSetting = self.SettingsTable.Game.Mania.settings["Skin"]
    if not skinSetting.options then skinSetting.options = {} end

    for _, skin in ipairs(skins) do
        if not table.find(skinSetting.options, skin.name) then
            table.insert(skinSetting.options, skin.name)
        end
    end

    table.sort(skinSetting.options)
end

return Settings
