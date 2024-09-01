local SettingsMenu = State()
local tabButtons 
local tabButtonWidth
local tabButtonHeight
local sliders
local toggles
local selects
local settingWidth
local settingHeight
local tabs = {
    {
        tab = "Gameplay",
        {key = "scrollSpeed", name = "Scroll Speed", type = "number", value = 480, min = 100, max = 2000, description = "How long in milliseconds it takes for a note to reach the receptors"},
        {key = "scrollDirection", name = "Scroll Direction", type = "select", value = "Up", options = {"Up", "Down"}, description = "Direction the notes scroll"},
        {key = "alwaysPlayFirstMiss", name = "Always Play First Miss Sound", type = "toggle", value = true, description = "(NOT ADDED) Always play the miss sound on the first miss, regardless of whether or not miss sounds are enabled"},
        {key = "playMissSound", name = "Play Miss Sounds", type = "toggle", value = true, description = "(NOT ADDED) Play the miss sound when you miss a note"},
        {key = "backgroundDim", name = "Background Dimness", type = "number", value = 80, min = 0, max = 100, description = "How dim the background is during gameplay"},
        {key = "backgroundRed", name = "Low Health Background Redness", type = "toggle", value = true, description = "Turn the background red when you're about to fail"},
        {key = "laneWidth", name = "Lane Width", type = "number", value = 120, min = 50, max = 500, description = "The space between the note lanes"},
        {key = "laneHeight", name = "Lane Height", type = "number", value = 120, min = 50, max = 500, description = "The space between the edge of the screen and the receptors"},
        {key = "backgroundBump", name = "Background Bumping", type = "select", value = "NPS Based", options = {"NPS Based", "BPM Only", "Off"}, description = "(NOT ADDED) Background bumps to the BPM, NPS Based makes it bump more or less depending on the current NPS"},
    },
    {
        tab = "Audio",
        {key = "masterVolume", name = "Master Volume", type = "number", value = 75, min = 0, max = 100, description = "(NOT ADDED) Adjust the master volume"},
        {key = "effectVolume", name = "Effect Volume", type = "number", value = 50, min = 0, max = 100, description = "(NOT ADDED) Adjust the effect volume"},
        {key = "musicVolume", name = "Music Volume", type = "number", value = 100, min = 0, max = 100, description = "(NOT ADDED) Adjust the music volume"},
    },
    {
        tab = "System",
        {key = "framerate", name = "Framerate", type = "select", value = "Unlimited", options = {"Unlimited", "Vsync"}, description = "(NOT ADDED) Unlimited runs the game at the highest framerate it can reach, Vsync makes the framerate match your refresh rate"},
        {key = "windowMode", name = "Window Mode", type = "select", value = "Windowed", options = {"Windowed", "Borderless", "Fullscreen"}, description = "(NOT ADDED) Choose what window mode you want the game to use"},
        {key = "showFramerate", name = "Show Framerate", type = "toggle", value = true, description = "(NOT ADDED) Display current FPS in the bottom right corner"},
    },
    {
        tab = "Keybinds",
        {key = "keyBinds4k", name = "4 Key Keybinds", type = "text", value = "dfjk", description = "Type 4 characters to set as your 4 key keyinds"},
        {key = "keyBinds7k", name = "7 Key Keybinds", type = "text", value = "sdf jkl", description = "Type 7 characters to set as your 7 key keyinds"},
    },
    {
        tab = "Skin (NOT ADDED)"
    },
}



function SettingsMenu:enter()
    tabButtons = {}
    sliders = {}
    toggles = {}
    selects = {}
    textBoxes = {}

    tabButtonWidth = 130
    tabButtonHeight = 50
    settingWidth = 300
    settingHeight = 50
    for Tab = 1,#tabs do
        local tabButtonX =  85
        local tabButtonY = (tabButtonHeight + 15)*(Tab)
        table.insert(tabButtons, {name = tabs[Tab].tab, x = tabButtonX, y = tabButtonY}) --(tabs[Tab].tab) 💀💀💀 god i suck at coding lmfao (but its named so it should be fine.. not really tho its still bad)
    end

    self:checkForMissingSettings()
end

---@param tabname string The tab to setup
function SettingsMenu:setupSettingsTab(tabname)
    sliders = {}
    toggles = {}
    selects = {}
    textBoxes = {}
    local tabName = tabname
    for Tab = 1,#tabs do
        if tabs[Tab].tab == tabName then
            for Setting = 1, #tabs[Tab] do
                if tabs[Tab][Setting].type == "number" then
                    sliders[tabs[Tab][Setting].key] = Objects.UI.Slider(380, (60*Setting), settingWidth, tabs[Tab][Setting].min, tabs[Tab][Setting].max, Settings[tabs[Tab][Setting].key] or tabs[Tab][Setting].value, tabs[Tab][Setting].name, tabs[Tab][Setting].description)
                elseif tabs[Tab][Setting].type == "toggle" then
                    toggles[tabs[Tab][Setting].key] = Objects.UI.Toggle(380, (60*Setting), settingWidth, settingHeight, Settings[tabs[Tab][Setting].key] or tabs[Tab][Setting].value, tabs[Tab][Setting].name, tabs[Tab][Setting].description)
                elseif tabs[Tab][Setting].type == "select" then
                    selects[tabs[Tab][Setting].key] = Objects.UI.Select(380, (60*Setting), settingWidth, settingHeight, tabs[Tab][Setting].options, Settings[tabs[Tab][Setting].key] or tabs[Tab][Setting].value, tabs[Tab][Setting].name, tabs[Tab][Setting].description)
                elseif tabs[Tab][Setting].type == "text" then
                    textBoxes[tabs[Tab][Setting].key] = Objects.UI.TextBox(380, (60*Setting), settingWidth, settingHeight, Settings[tabs[Tab][Setting].key] or tabs[Tab][Setting].value, tabs[Tab][Setting].name, tabs[Tab][Setting].description)
                end
            end
        end
    end
end

function SettingsMenu:checkForMissingSettings()
    local isMissing = false
    print("Check for missing settings")

    for _, tab in ipairs(tabs) do
        for _, option in ipairs(tab) do
            if type(option) == "table" then
                if not Settings[option.key] then
                    Settings[option.key] = option.value
                    isMissing = true
                end
            end
        end
    end

    return isMissing
end

function SettingsMenu:update(dt)

    if Input:pressed("menuClickLeft") then
        for i = 1, #tabButtons do
            local hovered = cursorX > tabButtons[i].x and cursorX < tabButtons[i].x + tabButtonWidth and cursorY > tabButtons[i].y and cursorY < tabButtons[i].y + tabButtonHeight
            if hovered then SettingsMenu:setupSettingsTab(tabButtons[i].name) end
        end
    elseif Input:pressed("menuBack") then
        SettingsMenu:saveSettings()
        State.switch(States.Menu.TitleScreen)
    end

    SettingsMenu:updateObjects()
end


function SettingsMenu:saveSettings()
    savedSettings = "return {\n"
    for Key, Value in pairs(Settings) do
        local settingValue = ""
        if type(Value) == "string" then
            settingValue = "\"" .. Value .. "\""
        elseif type(Value) == "boolean" then
            settingValue = tostring(Value)
        else
            settingValue = Value
        end
        savedSettings = savedSettings .. "    " .. Key .. " = " .. settingValue .. ",\n"
    end
    savedSettings = savedSettings .. "}\n"

    print(savedSettings)
    
    -- Saving the settings to a file
    love.filesystem.write("Settings/Settings.lua", savedSettings)
end

function SettingsMenu:updateObjects()
    for key, Slider in pairs(sliders) do
        Slider:update()
        for Tab = 1, #tabs do
            for Setting = 1, #tabs[Tab] do
                if tabs[Tab][Setting].key == key then
                    tabs[Tab][Setting].value = Slider:giveValue()
                end
            end
        end
    end

    for key, Toggle in pairs(toggles) do
        Toggle:update()
        for Tab = 1, #tabs do
            for Setting = 1, #tabs[Tab] do
                if tabs[Tab][Setting].key == key then
                    tabs[Tab][Setting].value = Toggle:giveValue()
                end
            end
        end
    end

    for key, Select in pairs(selects) do
        Select:update()
        for Tab = 1, #tabs do
            for Setting = 1, #tabs[Tab] do
                if tabs[Tab][Setting].key == key then
                    tabs[Tab][Setting].value = Select:giveValue()
                end
            end
        end
    end

    for key, TextBox in pairs(textBoxes) do
        TextBox:update()
        for Tab = 1, #tabs do
            for Setting = 1, #tabs[Tab] do
                if tabs[Tab][Setting].key == key then
                    tabs[Tab][Setting].value = TextBox:giveValue()
                end
            end
        end
    end

end

---@param TabButton string The tab to draw
function SettingsMenu:TabButtonDraw(TabButton)
    -- not gonna use actual objects for this because this is good enough, 
    -- even if it makes this menu's code a bit less clean (but it already sucks anyway so who cares)
    love.graphics.rectangle("line", tabButtons[TabButton].x, tabButtons[TabButton].y, tabButtonWidth, tabButtonHeight)
    love.graphics.print(tabButtons[TabButton].name, tabButtons[TabButton].x+15, tabButtons[TabButton].y+15)
end

function SettingsMenu:draw()
    love.graphics.setFont(Skin.Fonts["Menu Small"])
    for TabButton = 1,#tabButtons do       
        SettingsMenu:TabButtonDraw(TabButton)
    end

    love.graphics.line(285, 50, 285, Inits.GameHeight-50)

    for i, Slider in pairs(sliders) do
        Slider:draw()
    end

    for i, Toggle in pairs(toggles) do
        Toggle:draw()
    end


    for i, Select in pairs(selects) do
        Select:draw()
    end

    for i, TextBox in pairs(textBoxes) do
        TextBox:draw()
    end

end

return SettingsMenu