local PlayState = State()

function PlayState:enter()
    quaverParse("Music/" .. SongList[SelectedSong] .. "/" .. DifficultyList[SelectedDifficulty])
    updateMusicTime = true
    
end

function PlayState:update(dt)
    updateMusicTimeFunction()
    for i, Lane in ipairs(lanes) do
        for q, Note in ipairs(Lane) do
            Note:update()
            
        end
    end
end

function PlayState:draw()
    love.graphics.print("MusicTime: " .. MusicTime)

    for i, Lane in ipairs(lanes) do
        for q, Note in ipairs(Lane) do
            Note:draw()
            
        end
    end

end

return PlayState