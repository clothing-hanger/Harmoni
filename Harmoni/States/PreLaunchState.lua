local PreLaunchState = State()

function PreLaunchState:enter()

    skinsList = love.filesystem.getDirectoryItems("Skins/")
    curSelection = 1

end

function PreLaunchState:update(dt)

    if Input:pressed("MenuConfirm") then
        Skin = skinsList[curSelection]
        
        SkinLoader:InitSkin(Skin)
        State.switch(States.TitleState)

    elseif Input:pressed("MenuUp") then
        curSelection = curSelection - 1
    elseif Input:pressed("MenuDown") then
        curSelection = curSelection + 1
    end

    if curSelection > #skinsList then
        curSelection = 1
    elseif curSelection < 1 then
        curSelection = #skinsList
    end
end

function PreLaunchState:draw() 


    love.graphics.print("Select Skin", 65, 20)

        for i = 1,#skinsList do
            if i == curSelection then
                love.graphics.setColor(0,0.5,1)
            else
                love.graphics.setColor(1,1,1)
            end

            love.graphics.rectangle("line", 50, 50*i, 300, 40)
            love.graphics.print(skinsList[i], 65, 50*i)
        end
        love.graphics.setColor(1,1,1)


    love.graphics.setFont(MenuFontBig)
    love.graphics.printf("This is a pre-release build, expect bugs.\n\nThis menu is temporary, just until i get the \nsettings menu right, im gonna make \nsome quick settings here", 150, 125, Inits.GameWidth, "center")

    
end

return PreLaunchState