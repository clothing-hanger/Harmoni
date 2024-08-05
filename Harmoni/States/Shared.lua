local Shared = State()          -- unused

function Shared:enter()
    volumeOpacity = {0}
end

function Shared:update(dt)
    volumeOpacity[1] = volumeOpacity[1] - 25*dt
end

function SharedDraw()
    love.graphics.rectangle()
end

return Shared