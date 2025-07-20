local t = {}
t.endTransition = "states/transitions/slideUp/slideUpEND.lua"

local duration = 0.5
local height = baseScreenRatio.y
local offset = {0}
local switched = false

function t:enter(from, to, ...)
    offset = {-height}
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
    love.graphics.translate(0, -offset[1])
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, baseScreenRatio.x, height)
    love.graphics.pop()
end

return t
