local maniaChartDifficultyCalculator = {}

function maniaChartDifficultyCalculator:calculateDifficulty(chart)
    if not chart then return "fuck you asshole" end -- im sure returning a string from a function that is expected to return a number wont cause any problems!

        --we need to break the song into 5 second chunks
        --we do that by doing something idfk what tho 
        local chart = chart
        local chunks = {}

        local lastNoteTime = chart.hitObjects[#chart.hitObjects].startTime

        print(lastNoteTime)
        --local 
        for i, hitObject in ipairs(chart.hitObjects) do
            
        end

end

return maniaChartDifficultyCalculator