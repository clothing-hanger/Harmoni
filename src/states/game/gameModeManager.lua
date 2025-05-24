local gameModeManager = State()

function gameModeManager:enter(s,mode,chart)
    if mode == "mania" then
        self.gameMode = {mania(chart)}

    end
    
    gameModeManager:initializeSong()

end
function gameModeManager:initializeSong()
    MusicTime = -2000
end

function gameModeManager:update(dt)
    MusicTime = updateMusicTime(MusicTime, dt)
    for i, gameMode in ipairs(self.gameMode) do
        gameMode:update(dt)
    end
end

function gameModeManager:draw()
    for i, gameMode in ipairs(self.gameMode) do
        gameMode:draw()
        love.graphics.print(MusicTime, 0, 0)
    end

end

return gameModeManager