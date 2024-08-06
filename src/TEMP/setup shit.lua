LaneWidth = 120
LaneHeight = 110
ScrollSpeed = 1.6
dimSetting = 0.8

love.filesystem.load("Skins/Default Arrow/Skin.lua")()

LanesPositions = {
    Inits.GameWidth/2 - (LaneWidth*1.5),
    Inits.GameWidth/2 - (LaneWidth*0.5),
    Inits.GameWidth/2 + (LaneWidth*0.5),
    Inits.GameWidth/2 + (LaneWidth*1.5),
}

function ResizeLanePositions()
    LanesPositions = {
        Inits.GameWidth/2 - (LaneWidth*1.5),
        Inits.GameWidth/2 - (LaneWidth*0.5),
        Inits.GameWidth/2 + (LaneWidth*0.5),
        Inits.GameWidth/2 + (LaneWidth*1.5),
    }
end

laneCount = 4

function InitializeJudgments()
    print("InitializeJudgments()")

    Judgements = {
        ["Marvelous"] = {Judgement = "Marvelous", Timing = 26, Score = (BestScorePerNote and (BestScorePerNote*(5/5)) or 0), Count = 0, ID = 1},
        ["Perfect"] = {Judgement = "Perfect", Timing = 56, Score = (BestScorePerNote and (BestScorePerNote*(4/5)) or 0), Count = 0, ID = 2},
        ["Great"] = {Judgement = "Great", Timing = 86, Score = (BestScorePerNote and (BestScorePerNote*(3/5)) or 0), Count = 0, ID = 3},
        ["Good"] = {Judgement = "Good", Timing = 106, Score = (BestScorePerNote and (BestScorePerNote*(2/5)) or 0), Count = 0, ID = 4},
        ["Okay"] = {Judgement = "Okay", Timing = 126, Score = (BestScorePerNote and (BestScorePerNote*(1/5)) or 0), Count = 0, ID = 5},
        ["Miss"] = {Judgement = "Miss", Timing = 146, Score = (BestScorePerNote and (BestScorePerNote*(0/5)) or 0), Count = 0, ID = 6},
    }

    local judgementsArray = {}
    for k, v in pairs(Judgements) do
        table.insert(judgementsArray, v)
    end

    table.sort(judgementsArray, function(a, b)
        return a.ID < b.ID
    end)

    JudgementNames = {}
    for i, judgement in ipairs(judgementsArray) do
        table.insert(JudgementNames, judgement.Judgement)
    end
end



