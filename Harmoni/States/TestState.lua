local TestState = State()

function TestState:enter()
    Player = Objects.Game.Player()
end

function TestState:update(dt)
    Player:update(dt)
end

function TestState:draw()
    Player:draw()
end

return TestState