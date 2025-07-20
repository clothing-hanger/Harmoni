local t = {}
t.endTransition = "states/transitions/slideRight/slideRightEND.lua"

local duration = 0.5
local width = baseScreenRatio.x
local offset = {0}
local switched = false

function t:enter(from, to, ...)
    width = baseScreenRatio.x
    offset = {width}

    Timer.tween(duration, offset, {0}, "in-out-cubic", function()
        if not switched then
            switched = true
            State.completeTransition()
        end
    end)
end

function t:update(dt) end

function t:draw()
    love.graphics.push()
    love.graphics.translate(-offset[1], 0)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, width, baseScreenRatio.y)
    love.graphics.pop()
end

return t
