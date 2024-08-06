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
    Objects.Game.Judgement:new()
end

function PlayState:update(dt)
    PlayState:checkInput()
    PlayState:checkMiss()

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
        local judgement = Judgements[JudgementNames[Judgement]]
        print(noteTime <= judgement.Timing)
        if noteTime <= judgement.Timing then
            judgement.Count = plusEq(judgement.Count)
            Objects.Game.Judgement:judge(judgement.Judgement)
            break
        elseif noteTime > Judgements["Miss"].Timing then -- must be a miss         
            Judgements["Miss"].Count = plusEq(Judgements["Miss"].Count)             -- killing myself and its cuz
            Objects.Game.Judgement:judge("Miss")                                    -- of this code right here      
            break                                                                   -- i HARDCODED missing 😭
        end

    end


end

function PlayState:checkInput()
    for i, Lane in ipairs(lanes) do
        if Input:pressed("lane" .. tostring(i)) then

            for q, Note in ipairs(Lane) do
                local noteTime = math.abs((MusicTime - Note.StartTime))
                if Note.Lane == i and noteTime < Judgements["Miss"].Timing and not Note.wasHit then
                    PlayState:judge(noteTime)
                    Note:hit(noteTime)
                    break
                end
            end
        end
    end
end

function PlayState:checkMiss()
    for i, Lane in ipairs(lanes) do
        for q, Note in ipairs(Lane) do
            local noteTime = (MusicTime - Note.StartTime)
            if noteTime > Judgements["Miss"].Timing and not Note.wasHit then
                PlayState:judge(noteTime)
                Note:hit(noteTime)
                break
            end
        end
    end
end

function PlayState:draw()
    love.graphics.print("MusicTime: " .. MusicTime)


    for i = 1,#JudgementNames do
        love.graphics.printf(Judgements[JudgementNames[i]].Count, Inits.GameWidth-100, ((Inits.GameHeight/2)+(25*i)) - (3*25), 100, "right")
    end
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
    Objects.Game.Judgement:draw()
end

return PlayState
