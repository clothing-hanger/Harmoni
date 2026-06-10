local Settings = {}

Settings.SettingsTable = {
    ["Gameplay"] = {
        meta = {index = 1},
        description = "These settings affect how the game plays",
        ["Mania"] = {
            meta = {index = 1},
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
            ["Enable Hitsounds"] = {
                meta = {index = 3},
                type = "toggle",
                value = true,
                defaultValue = true,
                description = "Play a sound when a Note is hit",
            },
            ["Enable Keysounds"] = {
                meta = {index = 4},
                type = "toggle",
                value = true,
                defaultValue = true,
                description = "Play a sound when a keybind is pressed",
            },
            ["Enable Combo Break Sound"] = {
                meta = {index = 5},
                type = "toggle",
                value = true,
                defaultValue = true,
                description = "Play a sound when a combo over 5 is broken",
            },
            ["Background Brightness"] = {
                meta = {index = 6},
                type = "slider",
                min = 0,
                max = 100,
                value = 80,
                defaultValue = 80,
                description = "How bright the background is during gameplay",
            }
        }
    },
    ["Menu"] = {
        meta = {index = 2},
        description = "These settings affect how menus function", -- i dont know what else to put here,this really isnt a good desc of what these do but whatever
        ["Title Screen"] = {
            ["Enable Bubbles"] = {
                meta = {index = 1},
                type = "toggle",
                value = true,
                defaultValue = true,
                description = "Enables the bubble decorations in the Title Screen",
            },
            ["Enable Squiglly Lines"] = {
                meta = {index = 2},
                type = "toggle",
                value = true,
                defaultValue = true,
                description = "Enables the squiggly line decorations in the Title Screen",
            },
            ["Auto Play Music"] = {
                meta = {index = 3},
                type = "toggle",
                value = true,
                defaultValue = true,
                description = "Automatically select and play full songs while idle on the Title Screen",
            },                      
        },
        ["Song Select"] = {
            ["Enable Bubbles"] = {
                meta = {index = 1},
                type = "toggle",
                value = true,
                defaultValue = true,
                description = "Enables the bubble decorations in the Song Select",
            },
            ["Enable Squiglly Lines"] = {
                meta = {index = 2},
                type = "toggle",
                value = true,
                defaultValue = true,
                description = "Enables the squiggly line decorations in the Song Select",
            },   
        },
    },
    ["Keybinds"] = {
        meta = {index = 3},
        description = "Adjust your Keybinds here",
        ["Mania"] = {
            meta = {index = 1},
             -- idk what to put here
        }
    },
    ["Audio"] = {
        meta = {index = 4},
        description = "Adjust volume levels here",
        ["Menu"] = {
            meta = {index = 1},
            ["Music Volume"] = {
                meta = {index = 1},
                type = "slider",
                min = 0,
                max = 100,
                value = 80,
                defaultValue = 80,
                description = "Volume of music played in menus",
            },
            ["Effect Volume"] = {
                meta = {index = 2},
                type = "slider",
                min = 0,
                max = 100,
                value = 80,
                defaultValue = 80,
                description = "Volume of sound effects played in menus",
            }                        
        },
        ["Game"] = {
            meta = {index = 2},
            ["Music Volume"] = {
                meta = {index = 1},
                type = "slider",
                min = 0,
                max = 100,
                value = 80,
                defaultValue = 80,
                description = "Volume of music played during gameplay",
            },
            ["Hitsound Volume"] = {
                meta = {index = 2},
                type = "slider",
                min = 0,
                max = 100,
                value = 80,
                defaultValue = 80,
                description = "Volume of hitsounds",
            },
            ["Keysound Volume"] = {
                meta = {index = 3},
                type = "slider",
                min = 0,
                max = 100,
                value = 80,
                defaultValue = 80,
                description = "Volume of keysounds",
            },
            ["Combo Break Volume"] = {
                meta = {index = 4},
                type = "slider",
                min = 0,
                max = 100,
                value = 80,
                defaultValue = 80,
                description = "Volume of Combo Breaks",
            }  

        }
    },
    ["Skin"] = {
        meta = {index = 5},
        description = "Choose your Skin and adjust Skin related settings",
        ["Mania"] = {
            meta = {index = 1},
            ["Skin"] = {
                meta = { index = 1 },
                type = "dropdown",
                options = {
                    "Default Arrow",
                    "Default Arrow Batched",
                },
                value = "Default Arrow Batched",
                defaultValue = "Default Arrow Batched",
                description = "PLACEHOLDER!!!"
            },
            ["Lane Spacing"] = {
                meta = { index = 2 },
                type = "slider",
                min = 10,
                max = 130,
                value = 35,
                defaultValue = 35,
                description = "The space between your note lanes"
            },
            ["Lane Height"] = {
                meta = { index = 3 },
                type = "slider",
                min = 10,
                max = 130,
                value = 35,
                defaultValue = 35,
                description = "The space between your receptors and the edge of your screen"                
            }
        }
    },
    ["System"] = {
        meta = {index = 6},
        description = "Adjust system related settings", -- what a great description, holy shit im actually gonna kill myself
        [" "] = {
            meta = {index = 1},
            ["Framerate Limit"] = {
                meta = {index = 1},
                type = "dropdown",
                options = {
                    "VSync*2",
                    "VSync",
                    "Unlimited",
                    "Custom",
                },
                value = "VSync*2",
                defaultValue = "VSync*2",
                description = "Max framerate the game will be allowed to reach (does not affect UPS)",
            },
            ["Lower FPS when Inactive"] = {
                meta = {index = 2},
                type = "toggle",
                value = true,
                defaultValue = true,
                description = "Cap FPS to 10 when window is not in focus",
            },
            ["Enable Discord Rich Presence"] = {
                meta = {index = 3},
                type = "toggle",
                value = true,
                defaultValue = true,
                description = "Enables discord activity sharing for Harmoni"
            },
            ["Open Save Folder"] = {
                meta = {index = 4},
                type = "button", -- this doesnt exist yet
                func = function() print("open save folder") end,
                description = "Opens Harmoni's save directory"
            },
            ["Open Logs Folder"] = {
                meta = {index = 4},
                type = "button", -- this doesnt exist yet
                func = function() print("open log folder") end,
                description = "Opens Harmoni's logs directory"
            },
            ["Generate Log"] = {
                meta = {index = 5},
                type = "button",
                func = function() print("generate log") end,
                description = "Generates a log" -- who would have guessed "generate log" generates a log
            }
        }
    },
    ["Debug"] = {
        meta = {index = 7},
        description = "Developer shit",
        [" "] = {
            meta = {index = 1},
            ["Enable Debug Overlay"] = {
                meta = {index = 1},
                type = "toggle",
                value = true,
                defaultValue = true,
                description = "it does exactly what the fucking setting name says it does.",
            },
            ["crash the fucking game"] = {
                meta = {index = 2},
                type = "button",
                func = function() error("forced crash") end,
                description = "i fucking wonder what this button does",
            },       
        }
    }
}

function Settings:defaultSettings()
    local defaults = {}

    local function recurse(src, dst)
        for key, value in pairs(src) do
            if type(value) == "table" then
                if value.defaultValue ~= nil then
                    dst[key] = {
                        value = value.defaultValue
                    }
                elseif key ~= "meta" and key ~= "description" then
                    dst[key] = {}
                    recurse(value, dst[key])

                    if next(dst[key]) == nil then
                        dst[key] = nil
                    end
                end
            end
        end
    end

    recurse(self.SettingsTable, defaults)

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
    self.loadedSettings[category][subCategory][settingName] = {value = value}
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
    local skinSetting = self.SettingsTable.Skin.Mania["Skin"]
    if not skinSetting.options then skinSetting.options = {} end

    for _, skin in ipairs(skins) do
        if not table.find(skinSetting.options, skin.name) then
            table.insert(skinSetting.options, skin.name)
        end
    end

    table.sort(skinSetting.options)
end

return Settings
