local screenWipeValues = {x = 0, y = 0, width = 0, height = 0, rotation = 0}
local spinner


-- THIS FILE IS SO FUCKING UGLY :(


function doScreenWipe(dir, func)
    if not spinner then spinner = Skin.Menu["Loading Spinner"] end -- load it here since the skin isnt loaded when this file is initialized
    if dir == "rightIn" then
        screenWipeValues = {x = 0, y = 0, width = 0, height = Inits.GameHeight, rotation = 0}
        Timer.after(0.3, function() Timer.tween(0.5, screenWipeValues, {rotation = 360}, "out-back")
        end)
        
        Timer.tween(0.5, screenWipeValues, {width = Inits.GameWidth}, "out-in-sine", function()

            func()
        end)
    elseif dir == "rightOut" then
        screenWipeValues.x = 0
        screenWipeValues.y = 0
        screenWipeValues.width = Inits.GameWidth
        screenWipeValues.height = Inits.GameHeight
        Timer.tween(0.45, screenWipeValues, {x = Inits.GameWidth}, "in-expo")
    elseif dir == "leftIn" then
        screenWipeValues = {x = Inits.GameWidth, y = 0, width = Inits.GameWidth, height = Inits.GameHeight, rotation = 0}
        Timer.after(0.3, function() Timer.tween(0.5, screenWipeValues, {rotation = -360}, "out-back")
        end)
        
        Timer.tween(0.5, screenWipeValues, {x = 0}, "out-in-sine", function()

            func()
        end)
    elseif dir == "leftOut" then
        screenWipeValues.x = 0
        screenWipeValues.y = 0
        screenWipeValues.width = Inits.GameWidth
        screenWipeValues.height = Inits.GameHeight
        Timer.tween(0.45, screenWipeValues, {width = 0}, "in-expo")
    end
end

function screenWipeDraw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", screenWipeValues.x, screenWipeValues.y, screenWipeValues.width, screenWipeValues.height)
    love.graphics.setColor(1, 1, 1)

    love.graphics.setScissor(screenWipeValues.x, screenWipeValues.y, screenWipeValues.width, screenWipeValues.height)

    if spinner then
        love.graphics.draw(spinner, Inits.GameWidth / 2, Inits.GameHeight / 2, math.rad(screenWipeValues.rotation), 1, 1, spinner:getWidth() / 2, spinner:getHeight() / 2)
    end

    love.graphics.setScissor()
end
