local t = {}

local time = {0}
local shader

function t:enter(from, to, ...)
    time = {0}
    shader = love.graphics.newShader([[
        extern number progress;
        extern number amplitude;
        extern number frequency;
        vec4 effect(vec4 color, Image tex, vec2 uv, vec2 px) {
            float wave = sin(uv.y * frequency + progress * 10.0) * amplitude;
            if (uv.x > progress + wave) {
                discard;
            } else {
                return Texel(tex, uv);
            }
        }
    ]])
    Timer.tween(0.6, time, {1.2}, "in-out-cubic", function()
        State.completeTransition()
    end)
end

function t:update(dt) end

local lastShader = nil
function t:startDraw()
    shader:send("progress", time[1])
    shader:send("amplitude", 0.03)
    shader:send("frequency", 30)
    lastShader = love.graphics.getShader()
    love.graphics.setShader(shader)
end

function t:stopDraw()
    love.graphics.setShader(lastShader)
end

return t
