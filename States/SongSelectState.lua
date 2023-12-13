local SongSelectState = State()

function SongSelectState:enter()
    songList = love.filesystem.getDirectoryItems("Music")
    printableList = ""
    for i = 1,#songList do
        printableList = printableList .. songList[i] .. "\n"
    end
    selectedSong = 1
    inMenu = true
end

function SongSelectState:update(dt)
    if Input:pressed("GameDown") then
        if selectedSong ~= #songList then
            selectedSong = selectedSong + 1
        else
            selectedSong = 1
        end
    elseif Input:pressed("GameUp") then
        if selectedSong == 1 then
            selectedSong = #songList
        else
            selectedSong = selectedSong - 1
        end
    elseif Input:pressed("GameConfirm") then
        State.switch(States.PlayState)
    end
    
        
end

function SongSelectState:draw()
    love.graphics.print(printableList,200,200)
    love.graphics.print(songList[selectedSong], 600, 200)
end

return SongSelectState