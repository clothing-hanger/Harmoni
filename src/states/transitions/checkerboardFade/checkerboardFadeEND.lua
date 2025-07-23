local t = {}

local blocks = {}
local cols, rows = 8, 8
local cellW, cellH

function t:enter(from, to, ...)
    print("Entering checkerboardFade transition from " .. tostring(from) .. " to " .. tostring(to))
    cellW = baseScreenRatio.x / cols
    cellH = baseScreenRatio.y / rows
    blocks = {}

    for y = 0, rows - 1 do
        for x = 0, cols - 1 do
            local delay = (x + y) * 0.03
            local alpha = {1}
            table.insert(blocks, {x = x, y = y, alpha = alpha})
            Timer.after(delay, function()
                Timer.tween(0.3, alpha, {0}, "linear")
            end)
        end
    end

    Timer.after((cols + rows) * 0.03 + 0.15, function()
        State.completeTransition()
    end)
end

function t:update(dt) end

function t:draw()
    love.graphics.setColor(0, 0, 0)
    for _, b in ipairs(blocks) do
        love.graphics.setColor(0, 0, 0, b.alpha[1])
        love.graphics.rectangle("fill", b.x * cellW, b.y * cellH, cellW, cellH)
    end
end

return t
