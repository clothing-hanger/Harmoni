local gameModeManager = State()

function gameModeManager:enter(s,mode,chart,fullchart,mods)
    self.gameMode = {} -- i hate that this has to be a table 😭😭      -ch
                       -- Literally why does it have to be a table?
                       -- because its FUNNY guglio,,,,, but you would never understand   -ch
                       -- stfu
                       -- no lol     -ch
                       -- kladsjhdsajklcxzkljmn
                       -- ok       -ch
    printToConsole("Game Mode Manager Entered with mode: " .. mode)
    if mode == "mania" then
        self.gameMode = {mania(chart, self, fullchart, mods)}
    elseif mode == "slider" then
        self.gameMode = {slider(chart, self, fullchart)}
    end
    self.gameOver = false

    cursor.fadeOutWhenIdle = true    -- why dont we just add a check to the cursor to see if we are in gamemodemanager
                                     -- because its not like the cursor will only ever fade out in gamemodemanager

    gameModeManager:initializeSong()
end


function gameModeManager:initializeSong()
    MusicTime = -100000 -- we set this to something wild just so that it wont somehow reach 0 before we want
end

function gameModeManager:startSong(countdown)
    MusicTime = 0 - (countdown or 0)*1000
end

function gameModeManager:update(dt)
    if not self.gameOver then
        MusicTime = MusicTimeManager.updateMusicTime(MusicTime, dt)
        if MusicTimeManager.needsResync(self.gameMode[1].song) then
            MusicTime = MusicTimeManager.resyncMusicTime(self.gameMode[1].song)
        end
    end

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