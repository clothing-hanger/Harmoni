local testState = State()

function testState:enter()
end

function testState:update(dt)
end

function testState:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", 0, 0, 100, 100)
end

return testState