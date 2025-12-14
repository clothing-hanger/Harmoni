local maniaChartDifficultyCalculator = {}

local npsWindowWidth = 5  -- the "window" size for nps for adding difficulty score for a chunk,, im bad at explaing but like hopefully you understand what i mean here
local npsWindowScoreIncrease = 0.5  -- how much to add per window that is reached
local chunkLength = 5 -- how long, in seconds, each chunk is
local difficultyMarkiplier = 15 -- we multiply the difficulty by this to make it look less stupid or something idk..


function maniaChartDifficultyCalculator:calculateDifficulty(chart)
    if not chart then GlobalNotificationsHandler:addNotification("fuck you asshole", "error"); return "fuck" end
    local difficulty
    --we need to break the song into 5 second chunks
    --we do that by doing something idfk what tho 
    -- math
    chart = chart
    local chunks = self:breakChartIntoChunks(chart)

    if not chunks then GlobalNotificationsHandler:addNotification("Diff calc failed! (case 1)" .. chart.meta.title .. " - " ..chart.meta.difficultyName, "error")return "fuck" end
    local chunkDifficultyScores = {}
    for i, Chunk in ipairs(chunks) do
      -- print(i, Chunk, #Chunk, Chunk[1].startTime)

        -- we need to check the nps of this chunk
        local chunkNps = self:getNpsOfChunk(Chunk)
      --  print(chunkNps)

        -- now we just check what window that nps falls into, and add however much difficulty score that determines
        local npsWindowsPassed = chunkNps/npsWindowWidth
       -- print(npsWindowsPassed)

        local chunkDifficultyScore = npsWindowScoreIncrease*npsWindowsPassed
        table.insert(chunkDifficultyScores, chunkDifficultyScore)
    end

    -- now we get the average of those scores 
    local averageChunkDifficulty = self:getAverageOfChunkDifficultyScores(chunkDifficultyScores)

    -- do the thingy :3
    difficulty = averageChunkDifficulty*difficultyMarkiplier 
    return  math.floor(difficulty * 100 + 0.5) / 100
end

function maniaChartDifficultyCalculator:breakChartIntoChunks(chart)
    local hitObjects = chart.hitObjects 
    table.sort(hitObjects, function(a, b) return a.startTime < b.startTime end)  -- sort it for safety 
    local lastNoteTime
    if not hitObjects then
        if not hitObjects[#hitObjects] then
            if not hitObjects[#hitObjects].startTime then
                return
            end
        end
    end
    if hitObjects and hitObjects[#hitObjects] and hitObjects[#hitObjects].startTime then  lastNoteTime= hitObjects[#hitObjects].startTime else return false end

    local chunkLengthInMilliseconds = chunkLength*1000
    local totalChunks = math.ceil(lastNoteTime/chunkLengthInMilliseconds)

    local chunks = {}

    for i = 1,totalChunks do
        table.insert(chunks, {})
    end

    for i = 1,totalChunks do
        local chunkTimeWindow = chunkLengthInMilliseconds*(i-1)
        local chunkTimeWindowEnd = chunkTimeWindow + chunkLengthInMilliseconds
        for h, HitObject in ipairs(hitObjects) do
            if HitObject.startTime >= chunkTimeWindow and HitObject.startTime < chunkTimeWindowEnd then table.insert(chunks[i], HitObject) end
        end
    end

    return chunks
end

function maniaChartDifficultyCalculator:getNpsOfChunk(chunk)
    -- the number of notes are obviously the notes per chunk length, so all we have to do here is convert npcl into nps
    return #chunk/chunkLength
end

function maniaChartDifficultyCalculator:getAverageOfChunkDifficultyScores(scores)
    local totalCount = #scores
    local totalScore = 0
    for i = 1,#scores do
        totalScore = totalScore + scores[i]
    end
    return totalScore/totalCount
end

return maniaChartDifficultyCalculator