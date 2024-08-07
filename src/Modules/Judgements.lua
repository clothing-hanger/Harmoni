function InitializeJudgments()
    print("InitializeJudgments()")

    Judgements = {
        ["Marvelous"] = {Judgement = "Marvelous", Timing = 26, Score = 1, Count = 0, ID = 1},
        ["Perfect"] = {Judgement = "Perfect", Timing = 56, Score = 4/5, Count = 0, ID = 2},
        ["Great"] = {Judgement = "Great", Timing = 86, Score = 3/5, Count = 0, ID = 3},
        ["Good"] = {Judgement = "Good", Timing = 106, Score = 2/5, Count = 0, ID = 4},
        ["Okay"] = {Judgement = "Okay", Timing = 126, Score = 1/5, Count = 0, ID = 5},
        ["Miss"] = {Judgement = "Miss", Timing = 146, Score = 0, Count = 0, ID = 6},
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