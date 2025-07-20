local t = {}

local alpha = {1}

function t:enter(from, to, ...)
    Timer.tween(0.5, alpha, {0}, "in-out-cubic", function()
        State.completeTransition()
    end)
end

function t:update(dt) end

function t:draw()
    love.graphics.setColor(0, 0, 0, alpha[1])
    love.graphics.rectangle("fill", 0, 0, baseScreenRatio.x, baseScreenRatio.y)
end

return t
