local ChartParse = {}
---@oaram function ChartParse.harmc Parses .HARMC files
---@return ChartParse
---returns a table with the chart data, or false if there was an error
function ChartParse.harmc(harmc)
    local chart = {}
    local section

    if not love.filesystem.getInfo(harmc, "file") then   -- obviously if the file is either not real or not a file, thats a bad error lmfao, so dont try to parse it
        print("ERROR: ChartParse.harmc(): oopsies :3,,,, harmc was either not found or not a file" .. harmc)
        return false
    end

    for Line in love.filesystem.lines(harmc) do
        if Line:match("^%[.*%]$") then 
            section = Line:sub(2, -2)
            if not section then  -- this is bad, dont parse the chart
                print("ERROR: ChartParse.harmc(): oopsies :3,,, a section was not found when parsing: "  .. harmc)
                return false
            end
            chart[section] = {}
        elseif section == "meta" then  
                local key, value = Line:match("^(.+):(.+)$")
                if not key then key = "???" end   -- not a super bad error, so we just replace the bad values with "???"
                if not value then value = "???" end
                chart[section][key] = value
        elseif section == "bpm" then   
            local key, startTime, bpm = Line:match("^(%a+):(%d+):(%d+)$")  
            if key == "bpm" and startTime and bpm then  -- not a bad error, just skip this one
                table.insert(chart[section], {startTime = tonumber(startTime), bpm = tonumber(bpm)})  
            end
        elseif section == "sliderVelocities" then
            local key, startTime, multiplier = Line:match("^(%a+):([%d%.]+):([%d%.]+)$")
            if startTime and multiplier then   -- not a bad error, just skip this one
                table.insert(chart[section], {startTime = tonumber(startTime), multiplier = tonumber(multiplier)})
            end
        elseif section == "hitObjects" then
            local key, startTime, length, lane = Line:match("^(%a+):([%d%.]+):([%d%.]+):(%d+)$")
            if key and startTime and length and lane then   -- not a bad error, just skip this note
                table.insert(chart[section], {type = key, startTime = tonumber(startTime), length = tonumber(length), lane = tonumber(lane)})
            end
        end
    end

    return chart  -- will return the chart if everything goes well, or will return false if, uhh, everything does not go well
end

return ChartParse