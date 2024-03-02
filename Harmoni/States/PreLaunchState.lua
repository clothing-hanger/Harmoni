local PreLaunchState = State()

function PreLaunchState:enter()
    logo = love.graphics.newImage("Images/TITLE/logo.png")

    preLaunchFade = {0}

    Timer.tween(0.5, preLaunchFade, {1}, "out-quad", function()
        Timer.after(2.5, function()
            Timer.tween(0.5, preLaunchFade, {0}, "out-quad", function()
                if not skippedSplash then
                    State.switch(States.TitleState)
                end
            end)
        end)
    end)

end

function PreLaunchState:update(dt)

    if Input:pressed("MenuConfirm") then
        skippedSplash = true        
        State.switch(States.TitleState)
    end

end

function PreLaunchState:draw() 
    love.graphics.setColor(1,1,1,preLaunchFade[1])
    love.graphics.translate(0, -(preLaunchFade[1]*50))

    love.graphics.draw(logo, (Inits.GameWidth/2)-(logo:getWidth()/2), (Inits.GameHeight/2-logo:getHeight()/2)-80)
    love.graphics.setFont(MenuFontBig)
    love.graphics.printf("Harmoni is still in early beta, please report any bugs you find on the GitHub, and consider donating to help development", Inits.GameWidth/2-500, Inits.GameHeight/2, 1000, "center")

    
end

return PreLaunchState