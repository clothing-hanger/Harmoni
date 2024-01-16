local SettingsState = State()


function setDefaultSettings()

    print("Default Settings")
    startFullscreen = false
    volume = 15
    menuSongDelayTime = 0.2
    downScroll = false
    speed = 1.6
    speed1 = speed
    speed2 = speed
    speed3 = speed
    speed4 = speed
    LaneWidth = 125
    backgroundDimSetting = 0.9
    BotPlay = false
    verticalNoteOffset = 10

end
setDefaultSettings()

Tabs = {
    "Gameplay",
    "Menu",
    "System",
    "Skins"
}

Gameplay = {
    {"Down Scroll",  downScroll},
    {"Scroll Speed", speed},
    {"Note Lane Width", LaneWidth},
    {"Background Dim", backgroundDimSetting},
    {"Bot Play", BotPlay},
    {"Note Lane Height", verticalNoteOffset}
}

Menu = {
    {"Song Select Song Delay", menuSongDelayTime}
}

System = {
    {"Default Volume", volume},
    {"Fullscreen", startFullscreen}
}

Skins = love.filesystem.getDirectoryItems("Skins/")



function SettingsState:enter()

    CurSettingsMenu = "Tabs"
    


    selectedSetting = 1
    printableSetting = {selectedSetting}

end


function SettingsState:update(dt)
    if selectedSetting < 1 then
        selectedSetting = 1
    end
    if CurSettingsMenu == "Tabs" then
        if selectedSetting > #Tabs then
            selectedSetting = #Tabs
        end
    elseif CurSettingsMenu == "Gameplay" then
        if selectedSetting > #Gameplay then
            selectedSetting = #Gameplay
        end
    elseif CurSettingsMenu == "Menu" then
        if selectedSetting > #Menu then
            selectedSetting = #Menu
        end
    elseif CurSettingsMenu == "System" then
        if selectedSetting > #System then
            selectedSetting = #System
        end
    elseif CurSettingsMenu == "Skins" then
        if selectedSetting > #Skins then
            selectedSetting = #Skins
        end
    end
    if Input:pressed("MenuUp") then
        if not editingNumberSetting then
            selectedSetting = selectedSetting - 1

        end

    elseif Input:pressed("MenuDown") then
        if not editingNumberSetting then
        selectedSetting = selectedSetting + 1
        end

    elseif Input:pressed("MenuConfirm") then
        if CurSettingsMenu == "Tabs" then

            if selectedSetting == 1 then
                CurSettingsMenu = "Gameplay"
            elseif selectedSetting == 2 then
                CurSettingsMenu = "Menu"
            elseif selectedSetting == 3 then
                CurSettingsMenu = "System"
            elseif selectedSetting == 4 then
                CurSettingsMenu = "Skins"
            end
            selectedSetting = 1

        elseif CurSettingsMenu == "Gameplay" then
            if type(Gameplay[selectedSetting][2]) == "boolean" then
                Gameplay[selectedSetting][2] = not Gameplay[selectedSetting][2]
            elseif type(Gameplay[selectedSetting][2]) == "number" then
                editingNumberSetting = not editingNumberSetting
            end
        elseif CurSettingsMenu == "Menu" then
            if type(Menu[selectedSetting][2]) == "boolean" then
                Menu[selectedSetting][2] = not Menu[selectedSetting][2]
            elseif type(Menu[selectedSetting][2]) == "number" then
                editingNumberSetting = not editingNumberSetting
            end
        elseif CurSettingsMenu == "System" then
            if type(System[selectedSetting][2]) == "boolean" then
                System[selectedSetting][2] = not System[selectedSetting][2]
            elseif type(System[selectedSetting][2]) == "number" then
                editingNumberSetting = not editingNumberSetting
            end
        elseif CurSettingsMenu == "Skins" then
            Skin = "Skins/"..Skins[selectedSetting].."/"
            
            print(Skin .. "skin.lua")
            love.filesystem.load(Skin .. "skin.lua")()
        end
    elseif Input:pressed("MenuBack") then
        if editingNumberSetting then
            editingNumberSetting = not editingNumberSetting
        elseif CurSettingsMenu ~= "Tabs" then
            CurSettingsMenu = "Tabs"
        else
            saveSettings()
            State.switch(States.TitleState)
        end
    end


    


    if Input:pressed("MenuUp") then
        if editingNumberSetting then
            if CurSettingsMenu == "Gameplay" then
                settingEditAmount = 1
                if selectedSetting == 2 or selectedSetting == 4 then
                    settingEditAmount = 0.1
                else
                    settingEditAmount = 1
                end
                Gameplay[selectedSetting][2] = Gameplay[selectedSetting][2]-settingEditAmount
            elseif CurSettingsMenu == "Menu" then
                settingEditAmount = 0.1
                Menu[selectedSetting][2] = Menu[selectedSetting][2]-settingEditAmount
            elseif CurSettingsMenu == "System" then
                settingEditAmount = 1
                System[selectedSetting][2] = System[selectedSetting][2]-settingEditAmount
            end
                
        end
    elseif Input:pressed("MenuDown") then
        if editingNumberSetting then
            if CurSettingsMenu == "Gameplay" then
                settingEditAmount = 1
                if selectedSetting == 2 or selectedSetting == 4 then
                    settingEditAmount = 0.1
                else
                    settingEditAmount = 1
                end
                Gameplay[selectedSetting][2] = Gameplay[selectedSetting][2]+settingEditAmount
            elseif CurSettingsMenu == "Menu" then
                settingEditAmount = 0.1
                Menu[selectedSetting][2] = Menu[selectedSetting][2]+settingEditAmount
            elseif CurSettingsMenu == "System" then
                settingEditAmount = 1
                System[selectedSetting][2] = System[selectedSetting][2]+settingEditAmount
            end
                
        end
    end


    
    SettingsState:tweenSettingsList()

end

function saveSettings()

    if Menu[1][2] < 0.01 then
        Menu[1][2] = 0.01
    end

    startFullscreen = System[2][2]
    menuSongDelayTime = Menu[1][2]
    downScroll = Gameplay[1][2]
    speed = Gameplay[2][2]
    speed1 = speed
    speed2 = speed
    speed3 = speed
    speed4 = speed
    LaneWidth = Gameplay[3][2]
    backgroundDimSetting = Gameplay[4][2]
    BotPlay = Gameplay[5][2]
    verticalNoteOffset = Gameplay[6][2]

    if downScroll then
        speed = -speed
        speed1 = -speed1
        speed2 = -speed2
        speed3 = -speed3
        speed4 = -speed4
    end
    if startFullscreen then
        love.window.setFullscreen(startFullscreen, "exclusive")
    else
        love.window.setFullscreen(false)
    end

end

function SettingsState:tweenSettingsList()
    if settingsListTween then
        Timer.cancel(settingsListTween)
    end
    settingsListTween = Timer.tween(0.1, printableSetting, {selectedSetting}, "out-quad")
end

function SettingsState:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(background, Inits.GameWidth/2, Inits.GameHeight/2, nil, Inits.GameWidth/background:getWidth()+(logoSize-1)/6,Inits.GameHeight/background:getHeight()+(logoSize-1)/6, background:getWidth()/2, background:getHeight()/2)

    love.graphics.setFont(MenuFontSmall)
    if CurSettingsMenu == "Tabs" then
        for i = 1,#Tabs do
            if selectedSetting == i then
                love.graphics.setColor(0,0,0,0.9)
                love.graphics.rectangle("fill", 50, 60*i, 500, 50)
                love.graphics.setColor(0,1,1,1)
                love.graphics.rectangle("line", 50, 60*i, 500, 50)
                love.graphics.print(Tabs[i], 55, 60*i+10)
            else
                love.graphics.setColor(1,1,1,0.9)
                love.graphics.rectangle("fill", 50, 60*i, 500, 50)
                love.graphics.setColor(0,0,0,0.9)
                love.graphics.rectangle("line", 50, 60*i, 500, 50)
                love.graphics.print(Tabs[i], 55, 60*i+10)        
            end
        end
    elseif CurSettingsMenu == "Gameplay" then
        for i = 1,#Gameplay do
            if selectedSetting == i then
                love.graphics.setColor(0,0,0,0.9)
                love.graphics.rectangle("fill", 50, 60*i, 500, 50)
                love.graphics.setColor(0,1,1,1)
                love.graphics.rectangle("line", 50, 60*i, 500, 50)
                love.graphics.print(Gameplay[i][1] .. ": " .. tostring(Gameplay[i][2]), 55, 60*i+10)
            else
                love.graphics.setColor(1,1,1,0.9)
                love.graphics.rectangle("fill", 50, 60*i, 500, 50)
                love.graphics.setColor(0,0,0,0.9)
                love.graphics.rectangle("line", 50, 60*i, 500, 50)
                love.graphics.print(Gameplay[i][1] .. ": " .. tostring(Gameplay[i][2]), 55, 60*i+10)
            end
        end
    elseif CurSettingsMenu == "Menu" then

        for i = 1,#Menu do
            if selectedSetting == i then
                love.graphics.setColor(0,0,0,0.9)
                love.graphics.rectangle("fill", 50, 60*i, 500, 50)
                love.graphics.setColor(0,1,1,1)
                love.graphics.rectangle("line", 50, 60*i, 500, 50)
                love.graphics.print(Menu[i][1] .. ": " .. tostring(Menu[i][2]), 55, 60*i+10)
            else
                love.graphics.setColor(1,1,1,0.9)
                love.graphics.rectangle("fill", 50, 60*i, 500, 50)
                love.graphics.setColor(0,0,0,0.9)
                love.graphics.rectangle("line", 50, 60*i, 500, 50)
                love.graphics.print(Menu[i][1] .. ": " .. tostring(Menu[i][2]), 55, 60*i+10)
            end
        end
    elseif CurSettingsMenu == "System" then

        for i = 1,#System do
            if selectedSetting == i then
                love.graphics.setColor(0,0,0,0.9)
                love.graphics.rectangle("fill", 50, 60*i, 500, 50)
                love.graphics.setColor(0,1,1,1)
                love.graphics.rectangle("line", 50, 60*i, 500, 50)
                love.graphics.print(System[i][1] .. ": " .. tostring(System[i][2]), 55, 60*i+10)
            else
                love.graphics.setColor(1,1,1,0.9)
                love.graphics.rectangle("fill", 50, 60*i, 500, 50)
                love.graphics.setColor(0,0,0,0.9)
                love.graphics.rectangle("line", 50, 60*i, 500, 50)
                love.graphics.print(System[i][1] .. ": " .. tostring(System[i][2]), 55, 60*i+10)
            end
        end
    elseif CurSettingsMenu == "Skins" then
        for i = 1,#Skins do
            if selectedSetting == i then
                love.graphics.setColor(0,0,0,0.9)
                love.graphics.rectangle("fill", 50, 60*i, 500, 50)
                love.graphics.setColor(0,1,1,1)
                love.graphics.rectangle("line", 50, 60*i, 500, 50)
                love.graphics.print(Skins[i], 55, 60*i+10)
            else
                love.graphics.setColor(1,1,1,0.9)
                love.graphics.rectangle("fill", 50, 60*i, 500, 50)
                love.graphics.setColor(0,0,0,0.9)
                love.graphics.rectangle("line", 50, 60*i, 500, 50)
                love.graphics.print(Skins[i], 55, 60*i+10)
            end
        end
    end

end

return SettingsState