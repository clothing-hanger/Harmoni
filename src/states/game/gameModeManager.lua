local gameModeManager = State()

function gameModeManager:enter(s,mode,chart)
    self.gameMode = {} -- i hate that this has to be a table 😭😭      -ch
                       -- Literally why does it have to be a table?
                       -- because its FUNNY guglio,,,,, but you would never understand   -ch
                       -- stfu
                       -- no lol     -ch
                       -- kladsjhdsajklcxzkljmn
                       -- ok       -ch
   printToConsole("Game Mode Manager Entered with mode: " .. mode)
    if mode == "mania" then
        self.gameMode = {mania(chart, self)}
    end

    cursor.fadeOutWhenIdle = true    -- why dont we just add a check to the cursor to see if we are in gamemodemanager

    gameModeManager:initializeSong()

end


function gameModeManager:initializeSong()
    MusicTime = -100000 -- we set this to something wild just so that it wont somehow reach 0 before we want
end

function gameModeManager:startSong(countdown)
    MusicTime = 0 - (countdown or 0)*1000
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
    end

end

function gameModeManager:exit()
    cursor.fadeOutWhenIdle = false
    cursor.fadeOutAlpha = 1
end

return gameModeManager