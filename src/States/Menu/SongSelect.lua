local SongSelect = State()
SongList = love.filesystem.getDirectoryItems("Music")
local MenuState

function SongSelect:enter()
    MenuState = "Song"

    SelectedSong = 1
    SelectedDifficulty = 1

    DifficultyList = {}
    SelectedDifficulty = 1


end

function SongSelect:update(dt)
    if Input:pressed("menuDown") then
        SelectedSong = plusEq(SelectedSong)
        SelectedDifficulty = plusEq(SelectedDifficulty)
    elseif Input:pressed("menuUp") then
        SelectedSong = minusEq(SelectedSong)
        SelectedDifficulty = minusEq(SelectedDifficulty)
    elseif Input:pressed("menuConfirm") then
        if MenuState == "Song" then
            MenuState = "Difficulty"
            SongSelect:setupDifficultyList()
        elseif MenuState == "Difficulty" then
            SongString = "Music/" .. SongList[SelectedSong] .. "/" .. DifficultyList[SelectedDifficulty]
            print(SongString)
            State.switch(States.Game.PlayState)
        end
    end

    if SelectedSong > #SongList then SelectedSong = 1 end
    if SelectedSong < 1 then SelectedSong = #SongList end
    
    if SelectedDifficulty > #DifficultyList then SelectedDifficulty = 1 end
    if SelectedDifficulty < 1 then SelectedDifficulty = #DifficultyList end
end

function SongSelect:setupDifficultyList()
    DifficultyList = {}
    local SongContents = love.filesystem.getDirectoryItems("Music/" .. SongList[SelectedSong])
    for i = 1,#SongContents do
        print(getFileExtension(tostring(SongContents[i])))
        if getFileExtension(tostring(SongContents[i])) == ".qua" then
            table.insert(DifficultyList, SongContents[i])
        end
    end
end

function SongSelect:draw()
    if MenuState == "Song" then
        for i = 1,#SongList do
            if i == SelectedSong then love.graphics.setColor(0,1,1) else love.graphics.setColor(1,1,1) end
            love.graphics.print(SongList[i], 300, (100)+(15*i))
        end
    elseif MenuState == "Difficulty" then
        for i = 1,#DifficultyList do
            if i == SelectedDifficulty then love.graphics.setColor(0,1,1) else love.graphics.setColor(1,1,1) end
            love.graphics.print(DifficultyList[i], 300, (100)+(15*i))
        end
    end

end

return SongSelect