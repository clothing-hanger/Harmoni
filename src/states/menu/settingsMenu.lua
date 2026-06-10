local settingsMenu = State("settingsMenu")

local tabs = {}
local currentTab = ""
local tabReference

local function sortedPairs(tbl)
    local keys = {}

    for k in pairs(tbl) do
        if k ~= "meta" and k ~= "description" then
            table.insert(keys, k)
        end
    end

    table.sort(keys, function(a, b)
        return (tbl[a].meta and tbl[a].meta.index or 0) < (tbl[b].meta and tbl[b].meta.index or 0)
    end)

    local i = 0
    return function()
        i = i + 1
        local key = keys[i]
        if key then
            return key, tbl[key]
        end
    end
end

function settingsMenu:enter()
    tabs = {}
    local id = 0
    for tabName, tabTabs in sortedPairs(Settings.SettingsTable) do
        id = id + 1
        local spacing = 20
        local tab = settingsTabButton(tabName)
        tab.y = 25 + ((tab.height + spacing) * id)

        for secondaryTabName, secondaryTabs in sortedPairs(tabTabs) do
            if secondaryTabName == "meta" or secondaryTabName == "description" then
                goto continue
            end

            local sep = settingsModeSeperator(secondaryTabName)

            tab:add(sep)

            for theName, bullshit in sortedPairs(secondaryTabs) do
                if theName == "meta" then goto continue end

                local set
                if bullshit.type == "slider" then
                    set = settingsSlider(theName, Settings:getValue(tabName, secondaryTabName, theName), bullshit.min, bullshit.max)
                elseif bullshit.type == "dropdown" then
                    set = settingsDropdown(theName, Settings:getValue(tabName, secondaryTabName, theName), bullshit.options)
                elseif bullshit.type == "toggle" then
                    set = settingsToggle(theName, Settings:getValue(tabName, secondaryTabName, theName))
                end

                if not set then goto continue end

                local built = ''
                built = built .. tabName .. '.'
                built = built .. secondaryTabName .. '.'
                built = built .. theName

                set.reference = built

                tab:add(set)

                ::continue::
            end

            ::continue::
        end

        table.insert(tabs, tab)
    end
end

function settingsMenu:update()
    if Input:pressed("menuBack") then
        State.transition("waveDissolve", States.menu.titleScreen, function()
            Settings:writeSettings()
        end)
    end
end

function settingsMenu:mousepressed(x, y, button)
    x, y = toCanvasCoords(x, y)
    for _, tab in ipairs(tabs) do
        local tx, ty, tw, th = tab.x, tab.y, tab:getDimensions()

        if x >= tx and x <= tx+tw and y >= ty and y <= ty+th then
            currentTab = tab.name
            tabReference = tab
        end
    end

    if not tabReference then return end
    for _, member in ipairs(tabReference.members) do
        member:mousepressed(x, y, button)
    end
end

function settingsMenu:mousereleased(x, y, button)
    x, y = toCanvasCoords(x, y)

    if not tabReference then return end
    for _, member in ipairs(tabReference.members) do
        member:mousereleased(x, y, button)
    end
end

function settingsMenu:mousemoved(x, y)
    x, y = toCanvasCoords(x, y)

    if not tabReference then return end
    for _, member in ipairs(tabReference.members) do
        member:mousemoved(x, y, button)
    end
end

function settingsMenu:draw()
    for _, FUCK in pairs(tabs) do
        FUCK:draw()
    end

    if currentTab ~= "" then
        for _, tab in ipairs(tabs) do
            if tab.name == currentTab then
                tab:drawMembers()
            end
        end
    end
end

return settingsMenu
