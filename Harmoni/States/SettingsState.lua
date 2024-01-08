local SettingsState = State()
settings = {
    {"Full Screen", false},
    {"Default Volume", 100},
    {"Song Select Song Delay", 0.2},
    {"Down Scroll", false},
    {"Scroll Speed", 1.6},
    {"Note Lane Width", 125},
    {"Backgroud Dim", 0.9},
    {"Bot Play", false},
    {"Note Lane Height", 10},
    {"Disable Print", true},
    {"Debug Overlay", false},
    {"Enable Song Search", false}
}

function SettingsState:enter()


    selectedSetting = 1
    printableSetting = {selectedSetting}

end

function SettingsState:update(dt)
    if selectedSetting < 1 then
        selectedSetting = #settings
    elseif selectedSetting > #settings then
        selectedSetting = 1
    end
    if Input:pressed("MenuUp") then
        if editingNumberSetting then
            settings[selectedSetting][2] = settings[selectedSetting][2] - 1
        else
            selectedSetting = selectedSetting - 1
        end
    elseif Input:pressed("MenuDown") then
        if editingNumberSetting then
            settings[selectedSetting][2] = settings[selectedSetting][2] + 1
        else
            selectedSetting = selectedSetting + 1
        end
    elseif Input:pressed("MenuConfirm") then
        if type(settings[selectedSetting][2]) == "boolean" then
            settings[selectedSetting][2] = not settings[selectedSetting][2]
        elseif type(settings[selectedSetting][2]) == "number" then
            editingNumberSetting = not editingNumberSetting
        elseif type(settings[selectedSetting][2]) == "string" then
            editingStringSetting = not editingStringSetting
        end
    elseif Input:pressed("MenuBack") then
        saveSettings()
        State.switch(States.TitleState)
    end


    
    SettingsState:tweenSettingsList()

end

function saveSettings()
    startFullscreen = settings[1][2]
    defaultVolume = settings[2][2]
    menuSongDelayTime = settings[3][2]
    downScroll = settings[4][2]
    speed = settings[5][2]
    speed1 = settings[5][2]
    speed2 = settings[5][2]
    speed3 = settings[5][2]
    speed4 = settings[5][2]
    LaneWidth = settings[6][2]
    backgroundDimSetting = settings[7][2]
    BotPlay = settings[8][2]
    verticalNoteOffset = settings[9][2]
    love.filesystem.write("settings.lua",
                                        "\nstartFullscreen = " .. tostring(settings[1][2])..
                                        "\ndefaultVolume = " .. tostring(settings[2][2])..
                                        "\nmenuSongDelayTime = " .. tostring(settings[3][2])..
                                        "\ndownScroll = " .. tostring(settings[4][2])..
                                        "\nspeed = " .. tostring(settings[5][2])..
                                        "\nspeed1 = " .. tostring(settings[5][2])..
                                        "\nspeed2 = " .. tostring(settings[5][2])..
                                        "\nspeed3 = " .. tostring(settings[5][2])..
                                        "\nspeed4 = " .. tostring(settings[5][2])..
                                        "\nLaneWidth = " .. tostring(settings[6][2])..
                                        "\nbackgroundDimSetting = " .. tostring(settings[7][2])..
                                        "\nBotPlay = " .. tostring(settings[8][2])..
                                        "\nverticalNoteOffset = " .. tostring(settings[9][2])
    )
    if downScroll then
        speed = -speed
        speed1 = -speed1
        speed2 = -speed2
        speed3 = -speed3
        speed4 = -speed4
    end
    if startFullscreen then
        isFullscreen = not isFullscreen
        love.window.setFullscreen(isFullscreen, "exclusive")
    end
    --volume = defaultVolume/100    
end

function SettingsState:tweenSettingsList()
    if settingsListTween then
        Timer.cancel(settingsListTween)
    end
    settingsListTween = Timer.tween(0.1, printableSetting, {selectedSetting}, "out-quad")
end

function SettingsState:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.push()
    love.graphics.translate(0, -printableSetting[1]*50+Inits.GameHeight/2)
    love.graphics.setFont(MenuFontSmall)
    for i = 1,#settings do
        love.graphics.rectangle("line", 50, 50*i, 50, 40)
        love.graphics.print(settings[i][1] .. ": " .. tostring(settings[i][2]), 50, 50*i)
    end
    love.graphics.pop()
end

return SettingsState