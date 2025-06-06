local gameModeManager = State()

function gameModeManager:enter(s,mode,chart)
    self.gameMode = {} -- i hate that this has to be a table 😭😭
                       -- Literally why does it have to be a table?
    if mode == "mania" then
        self.gameMode = {mania(chart)}
    end
    
    gameModeManager:initializeSong()

end
function gameModeManager:initializeSong()
    MusicTime = -2000 -- should this be moved to the gamemode itself? maybe.. idk 
end

function gameModeManager:update(dt)
    MusicTime = MusicTimeManager.updateMusicTime(MusicTime, dt)
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