local scoreHandler = {}

scoreHandler.Scores = {trueScore = 0, printableScore = 0}
scoreHandler.valuesAndShitIDK = {maxScore = 1000000}
 local judgements = require("modules.maniaJudgements") -- lol this is bad i think

function scoreHandler:resetScore()
    self.Scores = {trueScore = 0, printableScore = 0}
end

function scoreHandler:getScorePerJudgment(noteCount)
    local noteCount = noteCount or 1  
    local maxScorePerNote = self.valuesAndShitIDK.maxScore / noteCount
    
    return {
        perfect = maxScorePerNote*judgements[1].score,
        great = maxScorePerNote*judgements[2].score,
        good = maxScorePerNote*judgements[3].score,   -- this is fucking gross but it works
        alright = maxScorePerNote*judgements[4].score,
        awful = maxScorePerNote*judgements[5].score,
        miss = maxScorePerNote*judgements[6].score
    }

end

function scoreHandler:getScore(arg)
    if arg == "true" then
        return self.Scores.trueScore
    elseif arg == "printable" then
        return self.Scores.printableScore
    else
        return self.Scores
    end
end
function scoreHandler:addScore(score)
    self.Scores.trueScore = self.Scores.trueScore + score
  --  self.tween = Timer.tween(0.1, self.Scores, {printableScore})
end


return scoreHandler