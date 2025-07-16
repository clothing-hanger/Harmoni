local ChartParse = {}
---@param harmc string the path to the .HARMC file to parse
---@return table|boolean harmc returns a table with the chart data, or false if there was an error
--- ChartParse.harmc Parses .HARMC files
function ChartParse.harmc(harmc)
    local chart = {}
    local section

    if not love.filesystem.getInfo(harmc, "file") then   -- obviously if the file is either not real or not a file, thats a bad error lmfao, so dont try to parse it
        print("ERROR: ChartParse.harmc(): oopsies :3,,,, harmc was either not found or not a file" .. harmc)
        return false
    end

    for Line in love.filesystem.lines(harmc) do
        -- if line starts with //, then skip it
        if Line:match("^%s*//") then
            goto continue  -- skip this line, just a comment
        end

        if Line:match("^%[.*%]$") then
            section = Line:sub(2, -2)
            if not section then  -- this is bad, dont parse the chart
                print("ERROR: ChartParse.harmc(): oopsies :3,,, a section was not found when parsing: "  .. harmc)
                --                                ^ CH this is why you're gay
                return false
            end
            chart[section] = {}
        elseif section == "meta" then  
                local key, value = Line:match("^(.+):(.+)$")
                if not key then key = "???" end   -- not a super bad error, so we just replace the bad values with "???"
                if not value then value = "???" end
                chart[section][key] = value
        elseif section == "bpm" then   
            local key, startTime, bpm = Line:match("^(%a+):([%d%.]+):([%d%.]+)$")
            if key == "bpm" and startTime and bpm then  -- not a bad error, just skip this one
                table.insert(chart[section], {startTime = tonumber(startTime), bpm = tonumber(bpm)})
            end
        elseif section == "sliderVelocities" then
            local _, startTime, multiplier = Line:match("^(%a+):([%d%.]+):([%d%.]+)$")
            if startTime and multiplier then   -- not a bad error, just skip this one
                table.insert(chart[section], {startTime = tonumber(startTime), multiplier = tonumber(multiplier)})
            end
        elseif section == "hitObjects" then
            local key, startTime, length, lane = Line:match("^(%a+):([%d%.]+):([%d%.]+):([%d%.]+)$")
            if key and startTime and length and lane then   -- not a bad error, just skip this note
                table.insert(chart[section], {type = key, startTime = tonumber(startTime), length = tonumber(length), lane = tonumber(lane)})
            end
        end

        ::continue::
    end

    return chart  -- will return the chart if everything goes well, or will return false if, uhh, everything does not go well
end

---@param harmc string the path to the .HARMC file to parse
---@return table|boolean harmc returns a table with the meta data, or false if there was an error
--- Like ChartParse.harmc, but stops when it escapes the meta section
function ChartParse.harmcMeta(harmc)
    local chart = {}
    local section = "meta"  -- we only want the meta section, so we set it to meta

    if not love.filesystem.getInfo(harmc, "file") then   -- obviously if the file is either not real or not a file, thats a bad error lmfao, so dont try to parse it
        print("ERROR: ChartParse.harmcMeta(): oopsies :3,,,, harmc was either not found or not a file" .. harmc)
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

    return chart  -- will return the chart if everything goes well, or will return false if, uhh, everything does not go well
end
return ChartParse