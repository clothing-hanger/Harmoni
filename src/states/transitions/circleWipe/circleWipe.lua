local t = {}
t.endTransition = "states/transitions/circleWipe/circleWipeEND.lua"

local radius = {0}
local maxRadius
local switched = false

function t:enter(from, to, ...)
    local w, h = baseScreenRatio.x, baseScreenRatio.y
    maxRadius = math.sqrt(w^2 + h^2)
    radius = {maxRadius}
    Timer.tween(0.5, radius, {0}, "in-out-cubic", function()
        if not switched then
            switched = true
            State.completeTransition()
        end
    end)
end

function t:update(dt) end

function t:draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.stencil(function()
        love.graphics.circle("fill", baseScreenRatio.x / 2, baseScreenRatio.y / 2, radius[1])
    end, "replace", 1)
    love.graphics.setStencilTest("less", 1)
    love.graphics.rectangle("fill", 0, 0, baseScreenRatio.x, baseScreenRatio.y)
    love.graphics.setStencilTest()
end

return t
