local screenWipeValues = {x = 0, y = 0, width = 0, height = 0, rotation = 0}
local spinner

local wipeDuration = 0.5
local rotationDuration = 0.5
local delayBeforeRotation = 0.3

local function applyTween(tweenParams, callback)
    Timer.tween(wipeDuration, screenWipeValues, tweenParams, "out-in-sine", callback)
end

local function applyRotation(rotation, delay)
    Timer.after(delay, function()
        Timer.tween(rotationDuration, screenWipeValues, {rotation = rotation}, "out-back")
    end)
end

function doScreenWipe(dir, func)
    if not spinner then
        spinner = Skin.Menu["Loading Spinner"]
    end
    
    if dir == "rightIn" then
        screenWipeValues = {x = 0, y = 0, width = 0, height = Inits.GameHeight, rotation = 0}
        applyRotation(360, delayBeforeRotation)
        applyTween({width = Inits.GameWidth}, func)
        
    elseif dir == "rightOut" then
        screenWipeValues = {x = 0, y = 0, width = Inits.GameWidth, height = Inits.GameHeight}
        Timer.tween(0.45, screenWipeValues, {x = Inits.GameWidth}, "in-expo")
    
    elseif dir == "leftIn" then
        screenWipeValues = {x = Inits.GameWidth, y = 0, width = Inits.GameWidth, height = Inits.GameHeight, rotation = 0}
        applyRotation(-360, delayBeforeRotation)
        applyTween({x = 0}, func)
    
    elseif dir == "leftOut" then
        screenWipeValues = {x = 0, y = 0, width = Inits.GameWidth, height = Inits.GameHeight}
        Timer.tween(0.45, screenWipeValues, {width = 0}, "in-expo")
    end
end

function screenWipeDraw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", screenWipeValues.x, screenWipeValues.y, screenWipeValues.width, screenWipeValues.height)
    love.graphics.setColor(1, 1, 1)

    love.graphics.setScissor(screenWipeValues.x, screenWipeValues.y, screenWipeValues.width, screenWipeValues.height)

    if spinner then
        love.graphics.draw(spinner, Inits.GameWidth / 2, Inits.GameHeight / 2, math.rad(screenWipeValues.rotation or 0), 1, 1, spinner:getWidth() / 2, spinner:getHeight() / 2)
    end

    love.graphics.setScissor()
end
