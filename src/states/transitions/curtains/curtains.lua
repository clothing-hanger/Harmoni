local t = {}
t.endTransition = "states/transitions/curtains/curtainsEND.lua"

local left = {0}
local right = {baseScreenRatio.x}
local switched = false

function t:enter(from, to, ...)
    Timer.tween(0.5, left, {baseScreenRatio.x / 2}, "in-out-cubic")
    Timer.tween(0.5, right, {baseScreenRatio.x / 2}, "in-out-cubic", function()
        if not switched then
            switched = true
            State.completeTransition()
        end
    end)
end

function t:update(dt) end

function t:draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, left[1], baseScreenRatio.y)
    love.graphics.rectangle("fill", right[1], 0, baseScreenRatio.x - right[1], baseScreenRatio.y)
end

return t
