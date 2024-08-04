local PlayState = State()

local Directions = {
    "Left",
    "Down",
    "Up",
    "Right",
}

local Receptors = {}

function PlayState:enter()
    quaverParse("Music/" .. SongList[SelectedSong] .. "/" .. DifficultyList[SelectedDifficulty])
    updateMusicTime = true
    for i = 1,#lanes do
        table.insert(Receptors, Objects.Game.Receptor(i))
    end

end

function PlayState:update(dt)
    updateMusicTimeFunction()
    if MusicTime >= 0 and not Song:isPlaying() then
        Song:play()
    end
    for i, Lane in ipairs(lanes) do
        for q, Note in ipairs(Lane) do
            Note:update()
        end
    end
end

function PlayState:draw()
    love.graphics.print("MusicTime: " .. MusicTime)

    for i, Receptor in ipairs(Receptors) do
        Receptor:draw()
    end

    for i, Lane in ipairs(lanes) do
        for q, Note in ipairs(Lane) do
            Note:draw()
        end
    end

end

return PlayState