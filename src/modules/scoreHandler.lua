local scoreHandler = {}

scoreHandler.Scores = {trueScore = 0,printableScore = 0}
scoreHandler.valuesAndShitIDK = {maxScore = 1000000}
 local judgements = require("modules.maniaJudgements") -- lol this is bad i think

function scoreHandler:resetScore(bigLongThrobbingFuckingPenis)
    local args = bigLongThrobbingFuckingPenis
    self.Scores = {
        trueScore = args.score or 0,
        printableScore = args.score or 0,
        trueAccuracy = args.accuracy or 0, 
        printableAccuracy = args.accuracy or 0,
        highestPossible = 0,
        truePerformanceRating = args.performanceRating or 0, 
        printablePerformanceRating = args.performanceRating or 0, 
        difficultyRating = args.difficulty
    }

    print("scoreHandler difficultyRating",self.Scores.difficultyRating)
end


function scoreHandler:getScorePerJudgment(noteCount)
    local noteCount = noteCount or 1  
    local maxScorePerNote = self.valuesAndShitIDK.maxScore / noteCount
        self.valuesAndShitIDK.maxScorePerNote = maxScorePerNote

           -- print("maxscorepernote",maxScorePerNote*judgements[1].score)

    return {
        perfect = maxScorePerNote*judgements[1].score,
        great = maxScorePerNote*judgements[2].score,
        good = maxScorePerNote*judgements[3].score,   -- this is fucking gross but it works   (and its prob just gonna go unused lmfao)
        alright = maxScorePerNote*judgements[4].score,
        awful = maxScorePerNote*judgements[5].score,
        miss = maxScorePerNote*judgements[6].score
    }
end


function scoreHandler:getScore(arg)
    if arg == "true" then
        return self.Scores.trueScore
    elseif arg == "printable" then
        return math.min(math.ceil(self.Scores.printableScore), self.valuesAndShitIDK.maxScore)
    else
        return self.Scores
    end
end


function scoreHandler:getAccuracy(arg)
    if arg == "true" then
        return self.Scores.trueAccuracy
    elseif arg == "printable" then
        return math.min(math.ceil(self.Scores.printableAccuracy),100)
    else
        return self.Scores
    end
end


function scoreHandler:getPerformanceRating(arg)
        if arg == "true" then
        return self.Scores.truePerformanceRating
    elseif arg == "printable" then
        return math.min(math.ceil(self.Scores.printablePerformanceRating),100)
    else
        return self.Scores
    end
end


function scoreHandler:addScore(score)
    local score = (score*self.valuesAndShitIDK.maxScorePerNote)
    self.Scores.highestPossible = self.Scores.highestPossible + self.valuesAndShitIDK.maxScorePerNote


    self.Scores.trueScore =     math.abs(math.max(-1,math.min(scoreHandler.valuesAndShitIDK.maxScore, self.Scores.trueScore + score)))

    self.Scores.trueAccuracy = (self.Scores.trueScore/self.Scores.highestPossible)*100

    if self.scoreTween then
        Timer.cancel(self.scoreTween)
    end
    self.scoreTween = Timer.tween(0.8, self.Scores, {printableScore = self.Scores.trueScore, printableAccuracy = self.Scores.trueAccuracy}, "out-quad")

    -- performance rating garbage 
    self.Scores.truePerformanceRating = self.Scores.difficultyRating*math.pow(self.Scores.trueAccuracy/(95/100),4.75) -- i do not know what this equation does.
end

function scoreHandler:setupPerformanceRating(dr)  -- literally just to add the song's diff into the values table
    scoreHandler.valuesAndShitIDK.difficultyRating = dr--pepper  🤤😋😋
end


return scoreHandler