local ChartParse = {}

function ChartParse.harmc(harmc)
    local chart = {}
    local section

    for Line in love.filesystem.lines(harmc) do
        if Line:match("^%[.*%]$") then 
            section = Line:sub(2, -2)
            chart[section] = {}
        elseif section == "meta" then
                local key, value = Line:match("^(.+):(.+)$")
                chart[section][key] = value
        elseif section == "bpm" then
            local key, startTime, bpm = Line:match("^(%a+):(%d+):(%d+)$")
            if key == "bpm" then
                table.insert(chart[section], {
                    startTime = tonumber(startTime),
                    bpm = tonumber(bpm)
                })
            end
        elseif section == "sliderVelocities" then
            local key, startTime, multiplier = Line:match("^(%a+):([%d%.]+):([%d%.]+)$")
            table.insert(chart[section], {startTime = tonumber(startTime), multiplier = tonumber(multiplier)})
        elseif section == "hitObjects" then
            local key, startTime, length, lane = Line:match("^(%a+):([%d%.]+):([%d%.]+):(%d+)$")
            if key and startTime and length and lane then
                table.insert(chart[section], {type = key, startTime = tonumber(startTime), length = tonumber(length), lane = tonumber(lane)})
            end
        end
    end
    

    return chart
end

return ChartParse