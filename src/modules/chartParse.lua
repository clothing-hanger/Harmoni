local ChartParse = {}

local function split(str, sep)
    local t = {}
    for s in string.gmatch(str, "([^" .. sep .. "]+)") do
        table.insert(t, s)
    end
    return t
end

---@param harmc string the path to the .HARMC file to parse
---@return table|boolean harmc returns a table with the chart data, or false if there was an error
--- ChartParse.harmc Parses .HARMC files
function ChartParse.harmc(harmc)
    local chart = {}
    chart.scrollSpeedFactors = {} -- to be safe :3c
    local section

    if not love.filesystem.getInfo(harmc, "file") then
        printToConsole("ERROR: ChartParse.harmc(): oopsies :3,,,, harmc was either not found or not a file " .. harmc)
        return false
    end

    for Line in love.filesystem.lines(harmc) do
        -- skip comments
        if Line:match("^%s*//") then goto continue end

        -- new section
        if Line:match("^%[.*%]$") then
            section = Line:sub(2, -2)
            chart[section] = {}
            goto continue
        end

        if not section then goto continue end

        local parts = split(Line, ":")

        if section == "meta" then
            local key, value = parts[1], parts[2]
            if not key then key = "???" end
            if not value then value = "???" end
            chart[section][key] = value

        elseif section == "bpm" then
            local key, startTime, bpm = parts[1], parts[2], parts[3]
            if key == "bpm" and startTime and bpm then
                table.insert(chart[section], {startTime = tonumber(startTime), bpm = tonumber(bpm)})
            end

        elseif section == "sliderVelocities" then
            local _, startTime, multiplier = parts[1], parts[2], parts[3]
            if startTime and multiplier then
                table.insert(chart[section], {startTime = tonumber(startTime), multiplier = tonumber(multiplier)})
            end
        elseif section == "scrollSpeedFactors" then
            local _, startTime, factor = parts[1], parts[2], parts[3]
            if startTime and factor then
                table.insert(chart[section], {startTime = tonumber(startTime), multiplier = tonumber(factor)})
            end

        elseif section == "hitObjects" then
            local key, startTime, endTime, lane = parts[1], parts[2], parts[3], parts[4]
            if key and startTime and endTime and lane then
                table.insert(chart[section], {
                    type = key,
                    startTime = tonumber(startTime),
                    endTime = tonumber(endTime),
                    lane = tonumber(lane)
                })
            end
        end

        ::continue::
    end

    return chart
end

---@param harmc string the path to the .HARMC file to parse
---@return table|boolean harmc returns a table with the meta data, or false if there was an error
--- Like ChartParse.harmc, but stops when it escapes the meta section
function ChartParse.harmcMeta(harmc)
    print("harmc",harmc)
    local chart = {}
    local section = "meta"  -- we only want the meta section, so we set it to meta

    if not love.filesystem.getInfo(harmc, "file") then   -- obviously if the file is either not real or not a file, thats a bad error lmfao, so dont try to parse it
       printToConsole("ERROR: ChartParse.harmcMeta(): oopsies :3,,,, harmc was either not found or not a file" .. harmc)
        return false
    end

    for Line in love.filesystem.lines(harmc) do
        if Line:match("^%[.*%]$") then
            section = Line:sub(2, -2)
            if section ~= "meta" then break end  -- we only want the meta section, so we break out of the loop if we find another section
        elseif section == "meta" then  
            local key, value = Line:match("^(.+):(.+)$")
            if not key then key = "???" end   -- not a super bad error, so we just replace the bad values with "???"
            if not value then value = "???" end
            chart[key] = value
        end
    end

   --if chart then chart["meta"].difficultyRating = maniaChartDifficultyCalculator:calculateDifficulty(chart) or 0 else chart["meta"].difficultyRating = 0 end

    -- why did i think this could work when chart here doesnt have any notes 
    -- we need a better way of doing this,, the notes being calculated every time is slow but we need to find the chart's difficulty too
    -- and storing the difficutly in some cached data is bad because we dont want people editing that 
    -- gugglliooo help :((
    -- just hash the modified at time or smth - guglio

    return chart  -- will return the chart if everything goes well, or will return false if, uhh, everything does not go well
end
return ChartParse