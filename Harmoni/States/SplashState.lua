local SplashState = State()
local SplashTimerLength
local SplashTimer
local logo
local loading
local skipString
local loadingAngle

function SplashState:enter()
    logo = love.graphics.newImage("Images/TITLE/logo.png")
    loading = love.graphics.newImage("Images/SHARED/loading.png")
    skipString = "Press any key to skip"
    SplashTimerLength = {0}
    loadingAngle = {0}
    SplashTimer = Timer.tween(10, SplashTimerLength, {1}, linear, function()
        State.switch(States.PreLaunchState)
    end)

    
end


function SplashState:update(dt)

end

function skipSplash()  -- has to be global sadly 
    if SplashTimer then
        Timer.cancel(SplashTimer)
        State.switch(States.PreLaunchState)
    end
end

function SplashState:draw()
    --love.graphics.setColor(1,1,1,preLaunchFade[1])
    --love.graphics.translate(0, -(preLaunchFade[1]*50))

    love.graphics.draw(logo, (Inits.GameWidth/2)-(logo:getWidth()/2), (Inits.GameHeight/2-logo:getHeight()/2)-80)
    love.graphics.setFont(MenuFontBig)
    love.graphics.printf("Harmoni is on a temporary (or permanent idk) break from development.\nThe game is still very unfinished, please do not expect a polished (or even fully functional) game.\n\n\nPress any key to skip.", Inits.GameWidth/2-600, Inits.GameHeight/2, 1200, "center")
   -- love.graphics.printf(#songNamesTable/#songList, Inits.GameWidth/2-500, Inits.GameHeight/2, 1000, "center")
    love.graphics.setColor(1,1,1)
   -- love.graphics.rectangle("fill", 0,0, 100, 100)

    love.graphics.rectangle("fill", 0, Inits.GameHeight-40, Inits.GameWidth*SplashTimerLength[1], 30)

    
    
end

return SplashState