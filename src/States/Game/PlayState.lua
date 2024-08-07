local PlayState = State()

local Directions = {
    "Left",
    "Down",
    "Up",
    "Right",
}

local Receptors = {}




function PlayState:enter()
    --Init local variables
    local myBalls = math.huge


    --Init global variables
    score = 0
    combo = 0
    accuracy = 0
    grade = "-"
    NPSData = {NPS = {}, HPS = {}}

    
    quaverParse("Music/" .. SongList[SelectedSong] .. "/" .. DifficultyList[SelectedDifficulty])
    updateMusicTime = true
    MusicTime = -2000
    for i = 1, #lanes do
        table.insert(Receptors, Objects.Game.Receptor(i))
    end
    PlayState:initObjects()

end

function PlayState:initObjects()
    Objects.Game.Judgement:new()
    Objects.Game.HUD:new()
    Objects.Game.Background:new(background)
    Objects.Game.Background:setDimness(dimSetting, true)
end

function PlayState:update(dt)
    PlayState:checkInput()
    PlayState:checkMiss()
    PlayState:updateObjects()

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

function PlayState:updateObjects()
    Objects.Game.HUD:update()
end

function PlayState:judge(noteTime)
    print("Playstate:judge(" .. noteTime .. ")")
    local ConvertedNoteTime = math.abs(noteTime)
    print(ConvertedNoteTime)
    for Judgement = 1, #JudgementNames do
        local judgement = Judgements[JudgementNames[Judgement]]
        if ConvertedNoteTime <= judgement.Timing then
            judgement.Count = judgement.Count + 1
            Objects.Game.Judgement:judge(judgement.Judgement)
            score = score + judgement.Score
            PlayState:calculateAccuracy()
            return 
        end
    end
    -- must be a miss then lmfao LOSER you SUCK 
    Judgements["Miss"].Count = Judgements["Miss"].Count + 1
    Objects.Game.Judgement:judge("Miss")
    PlayState:calculateAccuracy()
    return
end

function PlayState:incrementCombo()
    combo = plusEq(combo)
    if combo % 100 == 0 then
        Objects.Game.ComboAlert:doComboAlert(combo)
    end
end

--[[

function PlayState:calculateAccuracy()
    local currentBestPossibleScore
    local hitNotesCount = 0
    for i, Lane in ipairs(lanes) do
        for q, Note in ipairs(Lane) do
            if Note.wasHit then
                hitNotesCount = plusEq(hitNotesCount)        old LOSER code lmao
            end
        end
    end
    currentBestPossibleScore = BestScorePerNote*hitNotesCount
    accuracy = (score/currentBestPossibleScore)*100
end

--]]  
function PlayState:calculateAccuracy()
    local allHits = (allHits or 0)
    local allHits = plusEq(allHits) 
    local currentBestPossibleScore = BestScorePerNote*allHits          --new loser code :(
    accuracy = (score/currentBestPossibleScore)*100 
end

function PlayState:checkInput()
    for i, Lane in ipairs(lanes) do
        if Input:pressed("lane" .. tostring(i)) then

            for q, Note in ipairs(Lane) do
                local noteTime = math.abs((MusicTime - Note.StartTime))
                if Note.Lane == i and noteTime < Judgements["Miss"].Timing and not Note.wasHit then
                    PlayState:judge(noteTime)
                    Note:hit(noteTime)
                    table.insert(NPSData.NPS, 1000)
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
    Objects.Game.Background:draw() 

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
    Objects.Game.HUD:draw()
end

return PlayState
