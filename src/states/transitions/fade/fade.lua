local t = {}
t.endTransition = "states/transitions/fade/fadeEND.lua"

local alpha = {0}
local duration = 0.5
local switched = false

function t:enter(from, to, ...)
    alpha = {0}
    Timer.tween(duration, alpha, {1}, "in-out-cubic", function()
        if not switched then
            switched = true
            State.completeTransition()
        end
    end)
end

function t:update(dt) end

function t:draw()
    love.graphics.setColor(0, 0, 0, alpha[1])
    love.graphics.rectangle("fill", 0, 0, baseScreenRatio.x, baseScreenRatio.y)
end

return t
