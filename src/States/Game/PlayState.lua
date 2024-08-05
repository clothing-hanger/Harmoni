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
    for i = 1, #lanes do
        table.insert(Receptors, Objects.Game.Receptor(i))
    end
end

function PlayState:update(dt)
    PlayState:checkInput()

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

function PlayState:judge(noteTime)
    print("Playstate:judge(" .. noteTime .. ")")
    local ConvertedNoteTime = math.abs(noteTime)
    print(ConvertedNoteTime)

    for Judgement = 1, #JudgementNames do
        local judgment = Judgements[JudgementNames[Judgement]]
        if noteTime <= judgment.Timing then
            return judgment.Score
        end
    end

    for i = 1, #JudgementNames do
        if ConvertedNoteTime <= Judgements[JudgementNames[i]].Timing then
            Score = Score + Judgements[JudgementNames[i]].Score
            Judgements[JudgementNames[i]].Count = Judgements[JudgementNames[i]].Count + 1
            break
        end
    end
end

function PlayState:checkInput()
    for i, Lane in ipairs(lanes) do
        if Input:pressed("lane" .. tostring(i)) then

            for q, Note in ipairs(Lane) do
                local noteTime = math.abs((MusicTime - Note.StartTime))
                if Note.Lane == i and noteTime < Judgements["Miss"].Timing then
                    PlayState:judge(noteTime)
                    Note:hit(noteTime)
                    break
                end
            end
        end
    end
end

function PlayState:draw()
    love.graphics.print("MusicTime: " .. MusicTime)

    love.graphics.push()
    love.graphics.translate(0, LaneHeight)
    for i, Receptor in ipairs(Receptors) do
        Receptor:draw()
    end
    for i, Lane in ipairs(lanes) do
        for q, Note in ipairs(Lane) do
            Note:draw()
        end
    end
    love.graphics.pop()
end

return PlayState
