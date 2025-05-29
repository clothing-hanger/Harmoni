local songSelect = State()
local songList = {}
local selectedSong = 1
local selectedDifficulty = 1
local menuState = "song"
local difficultyList = {}

function songSelect:enter(test)
    self:setUpSongList()
end

function songSelect:setUpSongList()
    songList = SongListManager.getSongList(musicPath)
end

function songSelect:setUpDifficultyList()
  --  print(musicPath .. songList[selectedSong])
    difficultyList = SongListManager.getDifficultyList(musicPath .. songList[selectedSong])
end


function songSelect:update(dt)
    if menuState == "song" then
        self:menuStateSongUpdate(dt)
    elseif menuState == "difficulty" then
        self:menuStateDifficultyUpdate(dt)
    end
end

function songSelect:menuStateSongUpdate(dt)
    if Input:pressed("menuConfirm") then
        menuState = "difficulty"
        self:setUpDifficultyList()
    elseif Input:pressed("menuDown") then
        selectedSong = selectedSong+1
    elseif Input:pressed("menuUp") then
        selectedSong = selectedSong-1
    end
end

function songSelect:menuStateDifficultyUpdate(dt)
    if Input:pressed("menuConfirm") then
        menuState = "difficulty"
        self:setUpDifficultyList()
    elseif Input:pressed("menuDown") then
        selectedDifficulty = selectedDifficulty+1
    elseif Input:pressed("menuUp") then
        selectedDifficulty = selectedDifficulty-1
    end
end

function songSelect:draw()
    if menuState == "song" then
        self:menuStateSongDraw()
    elseif menuState == "difficulty" then
        self:menuStateDifficultyDraw()
    end
end

function songSelect:menuStateSongDraw()
    for i = 1,#songList do
        local color = ((selectedSong == i) and {1,0,0}) or {1,1,1}
        love.graphics.setColor(color)
        love.graphics.print(songList[i], 100, 100+(10*i))
        love.graphics.setColor(1,1,1)
    end
end

function songSelect:menuStateDifficultyDraw()
    for i = 1,#difficultyList do
        local color = ((selectedSong == i) and {1,0,0}) or {1,1,1}
        love.graphics.setColor(color)
        love.graphics.print(difficultyList[i], 100, 100+(10*i))
        love.graphics.setColor(1,1,1)
    end
end

return songSelect