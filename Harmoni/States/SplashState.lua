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
    skipString = "Press any key to skip\nexcept pronably the power one idk\nand probably not one of the f keys\nor the reset one\nthis isnt a funny joke why am i adding it"
    SplashTimerLength = {0}
    SplashTimer = Timer.tween(3, SplashTimerLength, {1}, linear, function()
        State.switch(States.PreLaunchState)
    end)

    
end

function SplashState:update(dt)

end

function SplashState:draw()
    --love.graphics.setColor(1,1,1,preLaunchFade[1])
    --love.graphics.translate(0, -(preLaunchFade[1]*50))

    love.graphics.draw(logo, (Inits.GameWidth/2)-(logo:getWidth()/2), (Inits.GameHeight/2-logo:getHeight()/2)-80)
    love.graphics.draw(loading, Inits.GameWidth - 100, Inits.GameHeight - 50, math.rad(loadingAngle[1]), 0.5, 0.5, loading:getWidth()/2, loading:getHeight()/2)
    love.graphics.print(skipString, Inits.GameWidth - 265, Inits.GameHeight - 50)
    love.graphics.setFont(MenuFontBig)
    love.graphics.printf("Harmoni is on a temporary (or permanent idk) break from development.\nThe game is still very unfinished, please do not expect a polished (or even fully functional) game.", Inits.GameWidth/2-600, Inits.GameHeight/2, 1200, "center")
   -- love.graphics.printf(#songNamesTable/#songList, Inits.GameWidth/2-500, Inits.GameHeight/2, 1000, "center")
   if metaFileFound then
    love.graphics.setColor(1,1,1)
   else
    love.graphics.setColor(1,1,1,0.3)
   end
    love.graphics.rectangle("fill", 0, Inits.GameHeight+10, Inits.GameWidth * (#songNamesTable/#songList), 30)

    
    
end

return SplashState