local settingsMenu = State("settingsMenu")

local tabs = {}
local currentTab = ""

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
    local id = 0
    for tabName, tabTabs in sortedPairs(Settings.SettingsTable) do
        id = id + 1

        local tab = settingsTabButton(tabName)
        tab.y = 25 + (65 * id)

        for secondaryTabName, secondaryTabs in sortedPairs(tabTabs) do
            if secondaryTabName == "meta" or secondaryTabName == "description" then
                goto continue
            end

            local sep = settingsModeSeperator(secondaryTabName)

            tab:add(sep)

            for theName, bullshit in sortedPairs(secondaryTabs.settings) do
                print(theName)
                local set
                if bullshit.type == "slider" then
                    set = settingsSlider(theName, bullshit.value, bullshit.min, bullshit.max)
                elseif bullshit.type == "dropdown" then
                    set = settingsDropdown(theName, bullshit.value, bullshit.options)
                end

                tab:add(set)
            end


            ::continue::
        end

        table.insert(tabs, tab)
    end
end

function settingsMenu:update()

end

function settingsMenu:mousepressed(x, y, button)
    for _, tab in ipairs(tabs) do
        local tx, ty, tw, th = tab.x, tab.y, tab:getDimensions()

        if x >= tx and x <= tx+tw and y >= ty-th and y <= ty then
            currentTab = tab.name
        end

        for _, member in ipairs(tab.members) do
            member:mousepressed(x, y, button)
        end
    end
end

function settingsMenu:mousereleased(x, y, button)
    for _, tab in ipairs(tabs) do
        for _, member in ipairs(tab.members) do
            member:mousereleased(x, y, button)
        end
    end
end

function settingsMenu:mousemoved(x, y)
    for _, tab in ipairs(tabs) do
        for _, member in ipairs(tab.members) do
            member:mousemoved(x, y)
        end
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