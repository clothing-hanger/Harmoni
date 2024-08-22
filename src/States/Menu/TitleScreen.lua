local TitleScreen = State()

local selection

function TitleScreen:enter()
    selection = 1
end

function TitleScreen:update()
    if Input:pressed("menuUp") then
        selection = minusEq(selection)
    elseif Input:pressed("menuDown") then
        selection = plusEq(selection)
    elseif Input:pressed("menuConfirm") then
        if selection == 1 then
            State.switch(States.Menu.SongSelect)
        elseif selection == 2 then
            State.switch(States.Menu.SettingsMenu)
        end
    end
end

function TitleScreen:draw()
    love.graphics.print("Selection:  " .. selection)
    love.graphics.print("Really good title screen", Inits.GameWidth/2, 150)
    
end

return TitleScreen