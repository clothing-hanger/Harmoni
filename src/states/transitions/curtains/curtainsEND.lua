local t = {}

local left = {baseScreenRatio.x / 2}
local right = {baseScreenRatio.x / 2}

function t:enter(from, to, ...)
    Timer.tween(0.5, left, {0}, "in-out-cubic")
    Timer.tween(0.5, right, {baseScreenRatio.x}, "in-out-cubic", function()
        State.completeTransition()
    end)
end

function t:update(dt) end

function t:draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, left[1], baseScreenRatio.y)
    love.graphics.rectangle("fill", right[1], 0, baseScreenRatio.x - right[1], baseScreenRatio.y)
end

return t
