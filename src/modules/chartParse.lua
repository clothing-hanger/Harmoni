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
function ChartParse.harmc(harmc,calculateDifficulty)
    local chart = {}
    chart.scrollSpeedFactors = {} -- to be safe :3c
    chart.meta = { -- safety first!! :3c
        gameMode = "mania"
    }
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

        elseif section == "warnings" then
            local key, value = parts[1], parts[2]
            if not key then goto continue end  -- no need to even set them to ??? cuz like,, 
            if not value then goto continue end            --wtf are we supposed to do?
                                                  -- tell the user theres a content warning and then just say yeah but we dont fucking know what it is
            chart[section][key] = value
            ::continue::
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
            if chart.meta.gameMode == "mania" then
                local key, startTime, endTime, lane = parts[1], parts[2], parts[3], parts[4]
                if key and startTime and endTime and lane then
                    table.insert(chart[section], {
                        type = key,
                        startTime = tonumber(startTime),
                        endTime = tonumber(endTime),
                        lane = tonumber(lane)
                    })
                end
            elseif chart.meta.gameMode == "slider" then
                local key, time, knockback = parts[1], parts[2], parts[3]
                if key and time and knockback then
                    table.insert(chart[section], {
                        type = key,
                        time = tonumber(time),
                        knockback = (knockback == "true")
                    })
                end
            end
                
        end



        ::continue::
    end
    if calculateDifficulty == "generate" then 
        if chart.meta.gameMode == "mania" then if type(maniaChartDifficultyCalculator:calculateDifficulty(chart)) == "number" then chart.meta.difficulty = maniaChartDifficultyCalculator:calculateDifficulty(chart) end end 
    elseif calculateDifficulty == "get" then
        print("Hello!", harmc..".difficulty")
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
            if (section ~= "meta" and section ~= "warnings") then break end  -- we only want the meta and the warnings section, so we break out of the loop if we find another section
        elseif section == "meta" then  
            local key, value = Line:match("^(.+):(.+)$")
            if not key then key = "???" end   -- not a super bad error, so we just replace the bad values with "???"
            if not value then value = "???" end
            chart[key] = value
        elseif section == "warnings" then
            if not chart[section] then chart[section] = {} end
            local type, warning = Line:match("^(.+):(.+)$")
            if not type then goto continue end 
            if not warning then goto continue end
            table.insert(chart[section], {warning = warning, type = type})
           -- chart[section] = warning  -- we actually do add this one as a section since we dont wanna just put these in the same table as the meta data
            ::continue::
        end
    end

    return chart  -- will return the chart if everything goes well, or will return false if, uhh, everything does not go well
end



return ChartParse