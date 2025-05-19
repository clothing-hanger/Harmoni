local gameModeManager = State()

function gameModeManager:enter(mode)
    self.gameMode = {mania()}
end

function gameModeManager:update(dt)

end

function gameModeManager:draw()
    for i, gameMode in ipairs(self.gameMode) do
        gameMode:draw()
    end

end

return gameModeManager