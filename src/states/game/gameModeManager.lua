local gameModeManager = State()

function gameModeManager:enter(s,mode,chart)
    if mode == "mania" then
        self.gameMode = {mania(chart)}

    end
end

function gameModeManager:update(dt)

end

function gameModeManager:draw()
    for i, gameMode in ipairs(self.gameMode) do
        gameMode:draw()
    end

end

return gameModeManager