local t = {}
local alpha = 0
local duration = 0.5
local timer = 0
local phase = "fadeout"  -- phases: "fadeout", "fadein"

function t:enter(from, to, ...)
    alpha = 0
    timer = 0
    phase = "fadeout"
end

function t:update(dt)
    timer = timer + dt

    if phase == "fadeout" then
        alpha = math.min(1, timer / duration)
        if alpha >= 1 then
            State.completeTransition() -- switch states here
            timer = 0
            phase = "fadein"
        end
    elseif phase == "fadein" then
        alpha = 1 - math.min(1, timer / duration)
        if alpha <= 0 then
            activeTransition = nil -- end transition
        end
    end
end

function t:draw()
    -- Draw underlying states normally, then overlay fade rect
    love.graphics.setColor(0, 0, 0, alpha)
    love.graphics.rectangle("fill", 0, 0, baseScreenRatio.x, baseScreenRatio.y)
    love.graphics.setColor(1,1,1,1)
end

return t