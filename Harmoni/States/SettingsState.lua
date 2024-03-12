local SettingsState = State()
local AllDirections = {
    "Left",
    "Down",
    "Up",
    "Right",
}


function setDefaultSettings()
    print(love.filesystem.getSaveDirectory())
    notification("Default Settings Restored", notifInfoIcon)
    startFullscreen = false
    defaultVolume = 0.02
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
    backgroundBlurSetting = 0
    instantPause = false
    bgBumpSetting = true
    currentSkin = "Skins/Default Arrow/"
    notification("Default Settings Loaded", notifInfoIcon)

end

function writeSettings()
    if startFullscreen then
        love.window.setFullscreen(startFullscreen, "exclusive")
    else
        love.window.setFullscreen(false)
    end

    local luaStr = "return {\n"
    luaStr = luaStr .. "\tlastNoteTime = " .. tostring(lastNoteTime) .. ",\n"
    luaStr = luaStr .. "\tmenuSongDelayTime = " .. tostring(menuSongDelayTime) .. ",\n"
    luaStr = luaStr .. "\tdownScroll = " .. tostring(downScroll) .. ",\n"
    luaStr = luaStr .. "\tspeed = " .. tostring(speed) .. ",\n"
    luaStr = luaStr .. "\tLaneWidth = " .. tostring(LaneWidth) .. ",\n"
    luaStr = luaStr .. "\tbackgroundDimSetting = " .. tostring(backgroundDimSetting) .. ",\n"
    luaStr = luaStr .. "\tBotPlay = " .. tostring(BotPlay) .. ",\n"
    luaStr = luaStr .. "\tverticalNoteOffset = " .. tostring(verticalNoteOffset) .. ",\n"
    luaStr = luaStr .. "\tbackgroundBlurSetting = " .. tostring(backgroundBlurSetting) .. ",\n"
    luaStr = luaStr .. "\tinstantPause = " .. tostring(instantPause) .. ",\n"
    luaStr = luaStr .. "\tbgBumpSetting = " .. tostring(bgBumpSetting) .. ",\n"
    luaStr = luaStr .. "\tcurrentSkin = " .."'" .. Skin .. "',\n"
    luaStr = luaStr .. "\tdefaultVolume = " .. tostring(defaultVolume) .. ",\n"
    luaStr = luaStr .. "}"

    love.filesystem.write("settings", luaStr)
    notification("Settings Saved", notifInfoIcon)
end

function loadSettings()
    if love.filesystem.getInfo("settings") then
        local settings = love.filesystem.load("settings")()
        print("settings loaded idfk")

        for k, v in pairs(settings) do
            _G[k] = v

        end



        for i = 1, 4 do
            _G["speed" .. i] = math.abs(speed)
        end

        if downScroll then
            speed = -speed
            speed1 = -speed1
            speed2 = -speed2
            speed3 = -speed3
            speed4 = -speed4
        end

        Skin = currentSkin
        print(Skin)

        love.audio.setVolume(defaultVolume)
        volume = defaultVolume
                
        love.filesystem.load(Skin .. "/skin.lua")()
        currentSkin = Skin:gsub("skin.lua", "")
        
    else
        setDefaultSettings()
        Skin = currentSkin
        love.filesystem.load(Skin .. "skin.lua")()
        currentSkin = Skin:gsub("skin.lua", "")
        writeSettings()
    end
end

loadSettings()

Tabs = {
    {"Gameplay", "Down Scroll, Scroll Speed, Note Lane Width, Background Dim, Bot Play, Note Lane Height, Background Blur, ...."},
    {"Menu", "Song Select Song Delay"},
    {"System", "Default Volume, Fullscreen"},
    {"Skins", "Skins affect the way the game looks"},
    {"Open Game Folder", "Open the folder Harmoni saves data to (Screenshots, Music, and Save Date are here)"},
}

Gameplay = {
    {"Down Scroll",  downScroll, "Notes scroll downward when this is enabled"},
    {"Scroll Speed", speed, "How fast notes scroll"},
    {"Note Lane Width", LaneWidth, "The space between the note lanes"},
    {"Background Dim", backgroundDimSetting, "How dark the background is during gameplay"},
    {"Bot Play", BotPlay, "Watch a perfect playthrough of the song"},
    {"Note Lane Height", verticalNoteOffset, "The space between the receptors and edge of the screen"},
    {"Background Blur", backgroundBlurSetting, "How blurred the background is during gameplay"},
    {"Instant Pause", instantPause, "Skip the 0.3 second timer before pausing when you press the pause button"},
    {"Background Bumping", bgBumpSetting, "Background bumps depending on how high the combo is"},
}

Menu = {
    {"Song Select Song Delay", menuSongDelayTime, "How long (in seconds) it takes before the Song Select menu loads the selected song"}
}

System = {
    {"Default Volume", defaultVolume, "The volume the game is set to when launced"},
    {"Fullscreen", startFullscreen, "Fullscreen or Window"}
}


Skins = love.filesystem.getDirectoryItems("Skins/")





function SettingsState:enter()

    CurSettingsMenu = "Tabs"
    
    previewSkin = false


    selectedSetting = 1
    printableSetting = {selectedSetting}

    loadSkinPreview()

    blurEffect = moonshine(moonshine.effects.boxblur)
    blurEffect.boxblur.radius = 0


end


function SettingsState:update(dt)
    blurEffect.boxblur.radius = Gameplay[7][2]


    if love.window.getFullscreen() then
        System[2][2] = true
    else
        System[2][2] = false
    end


    if CurSettingsMenu == "Tabs" then
        if selectedSetting > #Tabs then
            selectedSetting = 1
        end
        if selectedSetting < 1 then
            selectedSetting = #Tabs
        end
    elseif CurSettingsMenu == "Gameplay" then
        if selectedSetting > #Gameplay then
            selectedSetting = 1
        end
        if selectedSetting < 1 then
            selectedSetting = #Gameplay
        end
    elseif CurSettingsMenu == "Menu" then
        if selectedSetting > #Menu then
            selectedSetting = 1
        end
        if selectedSetting < 1 then
            selectedSetting = #Menu
        end
    elseif CurSettingsMenu == "System" then
        if selectedSetting > #System then
            selectedSetting = 1
        end
        if selectedSetting < 1 then
            selectedSetting = #System
        end
    elseif CurSettingsMenu == "Skins" then
        if selectedSetting > #Skins then
            selectedSetting = 1
        end
        if selectedSetting < 1 then
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
        saveSettings()

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
            curTab = selectedSetting
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
                love.window.setFullscreen(System[2][2], "exclusive")
            elseif type(System[selectedSetting][2]) == "number" then
                editingNumberSetting = not editingNumberSetting
            end
        elseif CurSettingsMenu == "Skins" then
                Skin = "Skins/"..Skins[selectedSetting].."/"
                
                print(Skin .. "skin.lua")
                love.filesystem.load(Skin .. "skin.lua")()
                currentSkin = Skin .. "skin.lua"
                loadSkinPreview()
                notification("Skin Loaded", notifInfoIcon)


        end
    elseif Input:pressed("MenuBack") then
        if editingNumberSetting then
            editingNumberSetting = not editingNumberSetting
        elseif CurSettingsMenu ~= "Tabs" then
            CurSettingsMenu = "Tabs"
            selectedSetting = curTab
        else
            saveSettings()
            writeSettings()
            State.switch(States.TitleState)
        end
    end


    


    if Input:pressed("MenuUp") then
        if editingNumberSetting then
            if CurSettingsMenu == "Gameplay" then
                settingEditAmount = 1
                if selectedSetting == 2 or selectedSetting == 4 then
                    settingEditAmount = 0.1
                end

                if selectedSetting == 2 or selectedSetting == 4 then
                    settingEditAmount = 0.1
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
    saveSettings()

end
function loadSkinPreview()

    print("Switch Skin")
    

    previewSkin = false 
    ReceptorDown = ReceptorDownImage
    ReceptorLeft = ReceptorLeftImage
    ReceptorUp = ReceptorUpImage
    ReceptorRight = ReceptorRightImage
    NoteDown = NoteDownImage
    NoteLeft = NoteLeftImage
    NoteUp = NoteUpImage
    NoteRight = NoteRightImage

    MenuMusic:stop()

    if randomDifficulty then
        selectedDifficulty = randomDifficulty
    end

    
    local ok = quaverParse(("Music/" .. songList[selectedSong] .. "/" .. diffList[selectedDifficulty]))
    if not ok then
        State.switch(States.TitleState)
    end

        MusicTime = 0
        MenuMusic = love.audio.newSource("Music/" .. songList[selectedSong] .. "/" .. metaData.song, "stream")
        MenuMusic:play()

    previewSkin = true
end

function saveSettings()

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
    backgroundBlurSetting = Gameplay[7][2]
    instantPause = Gameplay[8][2]
    bgBumpSetting = Gameplay[9][2]

    if downScroll then
        speed = -speed
        speed1 = -speed1
        speed2 = -speed2
        speed3 = -speed3
        speed4 = -speed4
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
    blurEffect(function()

    love.graphics.draw(background, Inits.GameWidth/2, Inits.GameHeight/2, nil, Inits.GameWidth/background:getWidth()+(logoSize-1)/6,Inits.GameHeight/background:getHeight()+(logoSize-1)/6, background:getWidth()/2, background:getHeight()/2)
    end)
    love.graphics.setColor(0,0,0,Gameplay[4][2])
    love.graphics.rectangle("fill", 0, 0, Inits.GameWidth, Inits.GameHeight)
    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(MenuFontSmall)
    if CurSettingsMenu == "Tabs" then
        for i = 1,#Tabs do
            if selectedSetting == i then
                love.graphics.setColor(0,0,0,0.9)
                love.graphics.rectangle("fill", 50, 60*i, 500, 50, 7, 7)
                love.graphics.setColor(0,1,1,1)
                love.graphics.rectangle("line", 50, 60*i, 500, 50, 7, 7)
                love.graphics.print(Tabs[i][1], 55, 60*i+10)
            else
                love.graphics.setColor(1,1,1,0.9)
                love.graphics.rectangle("fill", 50, 60*i, 500, 50, 7, 7)
                love.graphics.setColor(0,0,0,0.9)
                love.graphics.rectangle("line", 50, 60*i, 500, 50, 7, 7)
                love.graphics.print(Tabs[i][1], 55, 60*i+10)        
            end
        end
        love.graphics.setColor(1,1,1,1)
        love.graphics.rectangle("fill", 60, Inits.GameHeight-60, Inits.GameWidth-120, 50, 7, 7)
        love.graphics.setColor(0,1,1,1)

        love.graphics.rectangle("line", 60, Inits.GameHeight-60, Inits.GameWidth-120, 50, 7, 7)
        love.graphics.setColor(0,0,0,1)
        if selectedSetting > 0 and selectedSetting <= #Tabs then
            love.graphics.setFont(MenuFontSmall)
            love.graphics.printf(Tabs[selectedSetting][2], 60, Inits.GameHeight-50, Inits.GameWidth-120, "center")
        end
    elseif CurSettingsMenu == "Gameplay" then
        for i = 1,#Gameplay do
            if selectedSetting == i then
                love.graphics.setColor(0,0,0,0.9)
                love.graphics.rectangle("fill", 50, 60*i, 500, 50, 7, 7)
                love.graphics.setColor(0,1,1,1)
                love.graphics.rectangle("line", 50, 60*i, 500, 50, 7, 7)
                love.graphics.print(Gameplay[i][1] .. ": " .. tostring(Gameplay[i][2]), 55, 60*i+10)
            else
                love.graphics.setColor(1,1,1,0.9)
                love.graphics.rectangle("fill", 50, 60*i, 500, 50, 7, 7)
                love.graphics.setColor(0,0,0,0.9)
                love.graphics.rectangle("line", 50, 60*i, 500, 50, 7, 7)
                love.graphics.print(Gameplay[i][1] .. ": " .. tostring(Gameplay[i][2]), 55, 60*i+10)
            end
        end
        love.graphics.setColor(1,1,1,1)
        love.graphics.rectangle("fill", 60, Inits.GameHeight-60, Inits.GameWidth-120, 50, 7, 7)
        love.graphics.setColor(0,1,1,1)

        love.graphics.rectangle("line", 60, Inits.GameHeight-60, Inits.GameWidth-120, 50, 7, 7)
        love.graphics.setColor(0,0,0,1)
        if selectedSetting > 0 and selectedSetting <= #Gameplay then
            love.graphics.printf(Gameplay[selectedSetting][3], 60, Inits.GameHeight-50, Inits.GameWidth-120, "center")
        end
    elseif CurSettingsMenu == "Menu" then

        for i = 1,#Menu do
            if selectedSetting == i then
                love.graphics.setColor(0,0,0,0.9)
                love.graphics.rectangle("fill", 50, 60*i, 500, 50, 7, 7)
                love.graphics.setColor(0,1,1,1)
                love.graphics.rectangle("line", 50, 60*i, 500, 50, 7, 7)
                love.graphics.print(Menu[i][1] .. ": " .. tostring(Menu[i][2]), 55, 60*i+10)
            else
                love.graphics.setColor(1,1,1,0.9)
                love.graphics.rectangle("fill", 50, 60*i, 500, 50, 7, 7)
                love.graphics.setColor(0,0,0,0.9)
                love.graphics.rectangle("line", 50, 60*i, 500, 50, 7, 7)
                love.graphics.print(Menu[i][1] .. ": " .. tostring(Menu[i][2]), 55, 60*i+10)
            end
        end
        love.graphics.setColor(1,1,1,1)
        love.graphics.rectangle("fill", 60, Inits.GameHeight-60, Inits.GameWidth-120, 50, 7, 7)
        love.graphics.setColor(0,1,1,1)

        love.graphics.rectangle("line", 60, Inits.GameHeight-60, Inits.GameWidth-120, 50, 7, 7)
        love.graphics.setColor(0,0,0,1)
        if selectedSetting > 0 and selectedSetting <= #Menu then
            love.graphics.printf(Menu[selectedSetting][3], 60, Inits.GameHeight-50, Inits.GameWidth-120, "center")
        end    
    elseif CurSettingsMenu == "System" then

        for i = 1,#System do
            if selectedSetting == i then
                love.graphics.setColor(0,0,0,0.9)
                love.graphics.rectangle("fill", 50, 60*i, 500, 50, 7, 7)
                love.graphics.setColor(0,1,1,1)
                love.graphics.rectangle("line", 50, 60*i, 500, 50, 7, 7)
                love.graphics.print(System[i][1] .. ": " .. tostring(System[i][2]), 55, 60*i+10)
            else
                love.graphics.setColor(1,1,1,0.9)
                love.graphics.rectangle("fill", 50, 60*i, 500, 50, 7, 7)
                love.graphics.setColor(0,0,0,0.9)
                love.graphics.rectangle("line", 50, 60*i, 500, 50, 7, 7)
                love.graphics.print(System[i][1] .. ": " .. tostring(System[i][2]), 55, 60*i+10)
            end
        end
        love.graphics.setColor(1,1,1,1)
        love.graphics.rectangle("fill", 60, Inits.GameHeight-60, Inits.GameWidth-120, 50, 7, 7)
        love.graphics.setColor(0,1,1,1)

        love.graphics.rectangle("line", 60, Inits.GameHeight-60, Inits.GameWidth-120, 50, 7, 7)
        love.graphics.setColor(0,0,0,1)

        if selectedSetting > 0 and selectedSetting <= #System then
            love.graphics.printf(System[selectedSetting][3], 60, Inits.GameHeight-50, Inits.GameWidth-120, "center")
        end
    elseif CurSettingsMenu == "Skins" then
        for i = 1,#Skins do
            if selectedSetting == i then
                love.graphics.setColor(0,0,0,0.9)
                love.graphics.rectangle("fill", 50, 60*i, 500, 50, 7, 7)
                love.graphics.setColor(0,1,1,1)
                love.graphics.print(Skins[i], 55, 60*i+10)
                love.graphics.rectangle("line", 50, 60*i, 500, 50, 7, 7)
            else
                love.graphics.setColor(1,1,1,0.9)
                love.graphics.rectangle("fill", 50, 60*i, 500, 50, 7, 7)
                love.graphics.setColor(0,0,0,0.9)
                love.graphics.rectangle("line", 50, 60*i, 500, 50, 7, 7)
                love.graphics.print(Skins[i], 55, 60*i+10)
            end
        end
    end


  
    love.graphics.rectangle("line", -400, 1050, 300, 150, 7, 7)
    love.graphics.setColor(1,1,1,1)
    if previewSkin then
        love.graphics.translate(270,verticalNoteOffset)


        for i = 1,4 do
            love.graphics.draw(_G["Receptor" .. AllDirections[i]], Inits.GameWidth/2-(LaneWidth*2)+(LaneWidth*(i-1)), not downScroll and 0 or 575,nil,125/_G["Receptor" .. AllDirections[i]]:getWidth(),125/_G["Receptor" .. AllDirections[i]]:getHeight())
        end
        if downScroll then
            for i, lane in ipairs(lanes) do
                for k, note in ipairs(lane) do

                    if -(MusicTime - note[1])*_G["speed" .. i]   -(MusicTime - note[1])*_G["speed" .. i] < Inits.GameHeight+400 then
                        if MenuMusic:isPlaying() then 
                            love.graphics.draw(_G["Note" .. AllDirections[i]], Inits.GameWidth/2-(LaneWidth*2)+(LaneWidth*(i-1)), -(MusicTime - note[1])*_G["speed" .. i],nil,125/_G["Note" .. AllDirections[i]]:getWidth(),125/_G["Note" .. AllDirections[i]]:getHeight())
                        end
                    end
                end
            end
        else
            for i, lane in ipairs(lanes) do
                for k, note in ipairs(lane) do

                    if -(MusicTime - note[1])*_G["speed" .. i]   -(MusicTime - note[1])*_G["speed" .. i] > 0 then
                        if MenuMusic:isPlaying() then 
                            love.graphics.draw(_G["Note" .. AllDirections[i]], Inits.GameWidth/2-(LaneWidth*2)+(LaneWidth*(i-1)), -(MusicTime - note[1])*_G["speed" .. i],nil,125/_G["Note" .. AllDirections[i]]:getWidth(),125/_G["Note" .. AllDirections[i]]:getHeight())
                        end
                    end
                end
            end
        end

    end


end



return SettingsState