local SongSelect = State()

function SongSelect:enter()

    SongList = love.filesystem.getDirectoryItems("Music")
    SelectedSong = 1

    DifficultyList = love.filesystem.getDirectoryItems("Music/" .. SongList[SelectedSong])
    SelectedDifficulty = 1


    State.switch(States.Game.PlayState)    
end

function SongSelect:update(dt)
end

function SongSelect:draw()
end

return SongSelect