local SettingsMenu = State()
local tabButtons 
local tabButtonWidth
local tabButtonHeight
local sliders
local toggles
local selects
local sliderWidth
local settingHeight
local tabs = {
    {
        tab = "Gameplay",
        {key = "scrollSpeed", name = "Scroll Speed", type = "number", value = 480, min = 100, max = 10000, description = "How long in milliseconds it takes for a note to reach the receptors"},
        {key = "scrollDirection", name = "Scroll Direction", type = "select", value = "Up", options = {"Up", "Down"}, description = "Direction the notes scroll"},
        {key = "alwaysPlayFirstMiss", name = "Always Play First Miss Sound", type = "toggle", value = true, description = "Always play the miss sound on the first miss, regardless of whether or not miss sounds are enabled"},
        {key = "playMissSound", name = "Play Miss Sounds", type = "toggle", value = true, description = "Play the miss sound when you miss a note"},
        {key = "backgroundDim", name = "Background Dimness", type = "number", value = 80, min = 0, max = 100, description = "How dim the background is during gameplay"},
        {key = "backgroundRed", name = "Low Health Background Redness", type = "toggle", value = true, description = "Make the background red when you are about to fail"},
        {key = "backgroundBump", name = "Background Bumping", type = "select", value = "NPS Based", options = {"NPS Based", "BPM Only", "Off"}, description = "Background bumps to the BPM, NPS Based makes it bump more or less depending on the current NPS"},
    },
    {
        tab = "Audio",
        {key = "master", name = "Master Volume", type = "number", value = 75, min = 0, max = 100, description = "Adjust the master volume"},
        {key = "effectVolume", name = "Effect Volume", type = "number", value = 50, min = 0, max = 100, description = "Adjust the effect volume"},
        {key = "musicVolume", name = "Music Volume", type = "number", value = 100, min = 0, max = 100, description = "Adjust the music volume"},
    },
    {
        tab = "System",
        {key = "framerate", name = "Framerate", type = "select", value = "Unlimited", options = {"Unlimited", "Vsync"}, description = "Unlimited runs the game at the highest framerate it can reach, Vsync makes the framerate match your refresh rate"},
        {key = "windowMode", name = "Window Mode", type = "select", value = "Windowed", options = {"Windowed", "Borderless", "Fullscreen"}, description = "Choose what window mode you want the game to use"},
        {key = "showFramerate", name = "Show Framerate", type = "toggle", value = true, description = "Display current FPS in the bottom right corner"},
    },
}



function SettingsMenu:enter()
    tabButtons = {}
    sliders = {}
    toggles = {}
    selects = {}
    tabButtonWidth = 130
    tabButtonHeight = 50
    sliderWidth = 300
    settingHeight = 50
    for Tab = 1,#tabs do
        local tabButtonX = (((Inits.GameWidth / #tabs) * Tab) - ((Inits.GameWidth / #tabs) / 2)) - tabButtonWidth/2
        local tabButtonY = 100
        table.insert(tabButtons, {tabs[Tab].tab, tabButtonX, tabButtonY})
        print(tabs[Tab].tab)
    end
end

function SettingsMenu:setupSettingsTab(tabname)
    sliders = {}
    toggles = {}
    local tabName = tabname
    for Tab = 1,#tabs do
        if tabs[Tab].tab == tabName then
            for Setting = 1, #tabs[Tab] do
                if tabs[Tab][Setting].type == "number" then
                    sliders[tabs[Tab][Setting].key] = Objects.UI.Slider(Inits.GameWidth/2, 125+(60*Setting), sliderWidth, tabs[Tab][Setting].min, tabs[Tab][Setting].max, tabs[Tab][Setting].value, tabs[Tab][Setting].name)
                end
            end
        end
    end
end

function SettingsMenu:update(dt)

    if Input:pressed("menuClickLeft") then
        for i = 1, #tabButtons do
            local hovered = cursorX > tabButtons[i][2] and cursorX < tabButtons[i][2] + tabButtonWidth and cursorY > tabButtons[i][3] and cursorY < tabButtons[i][3] + tabButtonHeight
            if hovered then SettingsMenu:setupSettingsTab(tabButtons[i][1]) end
        end
    end

    for i, Slider in pairs(sliders) do
        Slider:update()
    end
end

function SettingsMenu:draw()
    for TabButton = 1,#tabButtons do
        love.graphics.rectangle("line", tabButtons[TabButton][2], tabButtons[TabButton][3], tabButtonWidth, tabButtonHeight)
    end

    for i, Slider in pairs(sliders) do
        Slider:draw()
    end
end

return SettingsMenu