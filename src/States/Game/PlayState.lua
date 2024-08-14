local PlayState = State()
Mods = {}

local Directions = {
    "Left",
    "Down",
    "Up",
    "Right",
}

local Receptors = {}

function PlayState:enter()

    quaverParse(SongString)

    --Init local variables
    local myBalls = math.huge


    --Init global variables
    score = 0
    combo = 0
    accuracy = 0
    grade = "-"
    performance = metaData.difficulty*(accuracy/100)
    NPSData = {NPS = {}, HPS = {}}
    health = 1

    
    updateMusicTime = true
    MusicTime = -3000
    for i = 1, #lanes do
        table.insert(Receptors, Objects.Game.Receptor(i))
    end
    PlayState:initObjects()

end

function PlayState:initModifiers()

end

function PlayState:initObjects()
    Objects.Game.Judgement:new()
    Objects.Game.HUD:new()
    Objects.Game.Background:new(background)
    Objects.Game.Background:setDimness(Settings.backgroundDimness, true)
    Objects.Game.ComboAlert:new()
    Objects.Game.Combo:new()
    Objects.Game.HitErrorMeter:new()
    Objects.Game.HealthBar:new()
end

function PlayState:update(dt)
    if Mods.botPlay then PlayState:checkBotInput() else PlayState:checkInput() end

    PlayState:updateObjects(dt)
    performance = metaData.difficulty* math.pow(accuracy/98, 6)

    updateMusicTimeFunction()
    if Song and (MusicTime >= 0 and not Song:isPlaying()) then
        Song:setPitch(Mods.songRate)
        Song:play()
    end
    for i, Lane in ipairs(lanes) do
        for q, Note in ipairs(Lane) do
            if Note.StartTime - MusicTime > 15000 then 
                break
           end
            Note:update()
        end
    end

    if Mods.suddenDeath and Judgements["Miss"].Count > 0 then
        PlayState:gameOver()
    end
    
end

function PlayState:updateObjects(dt)
    Objects.Game.HUD:update(dt)
    Objects.Game.HitErrorMeter:update(dt)
    Objects.Game.HealthBar:update(dt)
end

function PlayState:gameOver()
    if Mods.noFail then return end
    print("fucking loser")
    gameOver = true
    State.switch(States.Menu.SongSelect)
    Song:stop()
    Song = nil

end

function PlayState:judge(noteTime)
    local ConvertedNoteTime = math.abs(noteTime)
    for Judgement = 1, #JudgementNames do
        local judgement = Judgements[JudgementNames[Judgement]]
        if ConvertedNoteTime <= judgement.Timing then
            judgement.Count = judgement.Count + 1
            Objects.Game.Judgement:judge(judgement.Judgement)
            score = score + (BestScorePerNote*judgement.Score)
            health = health + judgement.Health
            PlayState:calculateAccuracy()
            return
        end
    end
    -- must be a miss then lmfao LOSER you SUCK 
    Judgements["Miss"].Count = Judgements["Miss"].Count + 1
    Objects.Game.Judgement:judge("Miss")
    health = health + Judgements["Miss"].Health
    PlayState:calculateAccuracy()
    return
end

function PlayState:calculateAccuracy()
    allHits = (allHits or 0)
    allHits = plusEq(allHits)
    local currentBestPossibleScore = BestScorePerNote*allHits
    accuracy = (score/currentBestPossibleScore)*100 
end

function PlayState:checkInput()
    for i, Lane in ipairs(lanes) do
        if Input:pressed("lane" .. tostring(i)) then
            for q, Note in ipairs(Lane) do
                local NoteTime = (MusicTime - Note.StartTime)
                local ConvertedNoteTime = math.abs(NoteTime)
                if Note.Lane == i and ConvertedNoteTime < Judgements["Miss"].Timing and not Note.wasHit then
                    PlayState:judge(ConvertedNoteTime, false)
                    Note:hit(ConvertedNoteTime)
                    Objects.Game.HitErrorMeter:addHit(NoteTime)
                    if ConvertedNoteTime < Judgements["Okay"].Timing then  -- to figure out whether or not to reset the combo
                        Objects.Game.Combo:incrementCombo(false)  -- false means we dont reset it
                    else
                        Objects.Game.Combo:incrementCombo(true)   -- true means we do reset it
                    end
                    table.insert(NPSData.NPS, 1000)
                    break
                end
            end
        end

        for q, Note in ipairs(Lane) do
            local NoteTime = (MusicTime - Note.StartTime)
            local ConvertedNoteTime = math.abs(NoteTime)
            if NoteTime > Judgements["Miss"].Timing and not Note.wasHit then
                PlayState:judge(ConvertedNoteTime)
                Note:hit(ConvertedNoteTime, true)
                Objects.Game.Combo:incrementCombo(true)
                Objects.Game.HitErrorMeter:addHit(NoteTime)
                break
            end
        end
    end
end

function PlayState:checkBotInput()
    for i, Lane in ipairs(lanes) do
        for q, Note in ipairs(Lane) do
            local NoteTime = (MusicTime - Note.StartTime)
            local ConvertedNoteTime = math.abs(NoteTime)
            if Note.Lane == i and ConvertedNoteTime < 1 and not Note.wasHit then
                PlayState:judge(ConvertedNoteTime, false)
                Note:hit(ConvertedNoteTime)
                Objects.Game.HitErrorMeter:addHit(NoteTime)            
                table.insert(NPSData.NPS, 1000)
                break
            end
        end
    end
end

function PlayState:draw()
    Objects.Game.Background:draw() 
    love.graphics.push()
    love.graphics.translate(0, Settings.laneHeight)
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
    Objects.Game.ComboAlert:draw()
    Objects.Game.Combo:draw()
    Objects.Game.HitErrorMeter:draw()
    Objects.Game.HealthBar:draw()
end

return PlayState
