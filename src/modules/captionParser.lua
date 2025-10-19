---@diagnostic disable: redundant-return-value
--- By @GuglioIsStupid
--- Parses various caption formats into a lua table
--- Supports the following:
--- - SubRip (.srt)

--- Output example:
--[[
{
    {text = "Piece by piece", time = 19, endTime = 21},
    ...
}
]]

local captionParser = {}

--- TIMESTAMP CONVERSIONS

---@param timestamp string The timestamp in SRT format (e.g., "00:01:23,456" for HH:MM:SS,mmm)
---@return number The timestamp in seconds
local function srtTimeToSeconds(timestamp)
    local hours, minutes, seconds = timestamp:match("(%d+):(%d+):(%d+),(%d+)")
    if not hours or not minutes or not seconds then
        return 0
    end

    hours = tonumber(hours)
    minutes = tonumber(minutes)
    seconds = tonumber(seconds)
    local ms = tonumber(timestamp:match(",(%d+)")) or 0
    return hours * 3600 + minutes * 60 + seconds + ms / 1000
end

---@param timestamp string The timestamp in SBV format (e.g., "0:00:01.000" for H:MM:SS.mmm)
---@return number The timestamp in seconds
local function sbvTimeToSeconds(timestamp)
    local hours, minutes, seconds = timestamp:match("(%d+):(%d+):(%d+)%.(%d+)")
    if not hours or not minutes or not seconds then
        return 0
    end

    hours = tonumber(hours)
    minutes = tonumber(minutes)
    seconds = tonumber(seconds)
    local ms = tonumber(timestamp:match("%.(%d+)")) or 0
    return hours * 3600 + minutes * 60 + seconds + ms / 1000
end

---@param timestamp string The timestamp in STL format (e.g., "00:00:01:00" for HH:MM:SS:FF)
---@return number The timestamp in seconds
local function stlTimeToSeconds(timestamp)
    local hours, minutes, seconds, frames = timestamp:match("(%d+):(%d+):(%d+):(%d+)")
    if not hours or not minutes or not seconds or not frames then
        return 0
    end

    hours = tonumber(hours)
    minutes = tonumber(minutes)
    seconds = tonumber(seconds)
    local frameCount = tonumber(frames) or 0

    -- https://docs.inqscribe.com/2.2/format_stl.html
    return hours * 3600 + minutes * 60 + seconds + frameCount / 30
end

---@param timestamp string The timestamp in ASS format (e.g., "0:00:01.00" for H:MM:SS.cc)
---@return number The timestamp in seconds
local function assTimeToSeconds(timestamp)
    local h, m, s, cs = timestamp:match("(%d+):(%d+):(%d+)%.(%d+)")
    if not h or not m or not s then return 0 end
    return tonumber(h) * 3600 + tonumber(m) * 60 + tonumber(s) + (tonumber(cs) or 0) / 100
end

---@param seconds number The time in seconds
---@return string The timestamp in SRT format (HH:MM:SS,mmm)
local function secondsToSRTTime(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = math.floor(seconds % 60)
    local ms = math.floor((seconds * 1000) % 1000)
    return string.format("%02d:%02d:%02d,%03d", h, m, s, ms)
end

---@param seconds number The time in seconds
---@return string The timestamp in SBV format (H:MM:SS.mmm)
local function secondsToSBVTime(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = math.floor(seconds % 60)
    local ms = math.floor((seconds * 1000) % 1000)
    return string.format("%d:%02d:%02d.%03d", h, m, s, ms)
end

---@param t number The time in seconds
---@return string The timestamp in STL format (HH:MM:SS:FF)
local function secondsToSTLTime(t)
    local h = math.floor(t / 3600)
    local m = math.floor((t % 3600) / 60)
    local s = math.floor(t % 60)
    local f = math.floor((t * 30) % 30) -- assuming 30 fps
    return string.format("%02d:%02d:%02d:%02d", h, m, s, f)
end

---@param seconds number The time in seconds
---@return string The timestamp in ASS format (H:MM:SS.cc)
local function secondsToASSTime(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = math.floor(seconds % 60)
    local cs = math.floor((seconds * 100) % 100)
    return string.format("%d:%02d:%02d.%02d", h, m, s, cs)
end


--- CAPTION PARSERS

--- Parses SRT formatted captions
--- @param content string The content of the SRT file
--- @return table A table of captions with text, time, and endTime
local function parseSRT(content)
    local captions = {}

    -- Normalize line endings
    content = content:gsub("\r\n", "\n"):gsub("\r", "\n")

    -- Split into blocks (separated by blank lines)
    for block in content:gmatch("([^\n]+%s*[^\n]*)%s*\n\n") do
        local lines = {}
        for line in block:gmatch("[^\n]+") do
            table.insert(lines, line)
        end

        if #lines >= 2 then
            local timeLine = nil
            local startIndex = 1

            -- If first line looks like a number, skip it
            if lines[1]:match("^%d+$") and lines[2]:match("%-%->") then
                timeLine = lines[2]
                startIndex = 3
            elseif lines[1]:match("%-%->") then
                timeLine = lines[1]
                startIndex = 2
            end

            if timeLine then
                local startTime, endTime = timeLine:match("(%d+:%d+:%d+,%d+)%s*-->%s*(%d+:%d+:%d+,%d+)")
                if startTime and endTime then
                    local text = table.concat(lines, "\n", startIndex)
                    table.insert(captions, {
                        text = text,
                        time = srtTimeToSeconds(startTime),
                        endTime = srtTimeToSeconds(endTime)
                    })
                end
            end
        end
    end

    return captions
end

--- Parses VTT formatted captions
--- @param content string The content of the VTT file
--- @return table A table of captions with text, time, and endTime
local function parseVTT(content)
    content = content:gsub("WEBVTT\r?\n\r?\n", "")
    content = content:gsub("%.(%d%d%d)", ",%1")
    return parseSRT(content)
end

--- Parses SBV formatted captions
--- @param content string The content of the SBV file
--- @return table A table of captions with text, time, and endTime
local function parseSBV(content)
    local lines = {}
    for line in content:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    local captions = {}
    local i = 1
    while i <= #lines do
        local timecode = lines[i]
        local textLines = {}
        local j = i + 1
        while j <= #lines and lines[j] ~= "" do
            table.insert(textLines, lines[j])
            j = j + 1
        end

        local startTime, endTime = timecode:match("(%d+:%d+:%d+%.%d+),(%d+:%d+:%d+%.%d+)")
        if startTime and endTime then
            table.insert(captions, {
                text = table.concat(textLines, "\n"),
                time = sbvTimeToSeconds(startTime),
                endTime = sbvTimeToSeconds(endTime)
            })
        end

        i = j + 1
    end

    return captions
end

--- Parses STL formatted captions
--- @param content string The content of the STL file
--- @return table A table of captions with text, time, and endTime
local function parseSTL(content)
    local lines = {}
    for line in content:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
    local captions = {}
    for _, line in ipairs(lines) do
        local timecode, text = line:match("//(%d+:%d+:%d+:%d+),(%d+:%d+:%d+:%d+)%s+(.*)")
        if timecode and text then
            local startTimeStr, endTimeStr = timecode:match("(%d+:%d+:%d+:%d+),(%d+:%d+:%d+:%d+)")
            local time = stlTimeToSeconds(startTimeStr)
            local endTime = stlTimeToSeconds(endTimeStr)
            table.insert(captions, {
                text = text:gsub("|", "\n"),
                time = stlTimeToSeconds(startTimeStr),
                endTime = stlTimeToSeconds(endTimeStr)
            })
        end
    end

    return captions
end

--- Parses ASS formatted captions
--- @param content string The content of the ASS file
--- @return table A table of captions with text, time, and endTime
local function parseASS(content) -- haha it says ass
    -- Who knows? Maybe we can implement the cool looking captions...
    -- Idk im too lazy for that tho
    local captions = {}
    local formatMap = {}
    local inEvents = false

    for line in content:gmatch("[^\r\n]+") do
        line = line:match("^%s*(.-)%s*$")

        if line:match("^%[Events%]") then
            inEvents = true
        elseif inEvents then
            local fmt = line:match("^Format:%s*(.+)")
            if fmt then
                formatMap = {}
                local i = 1
                for field in fmt:gmatch("[^,]+") do
                    field = field:match("^%s*(.-)%s*$"):lower()
                    formatMap[field] = i
                    i = i + 1
                end
            else
                local dia = line:match("^Dialogue:%s*(.+)")
                if dia and next(formatMap) then
                    local parts = {}
                    for field in dia:gmatch("([^,]*)") do
                        table.insert(parts, field)
                    end

                    local startTime = parts[formatMap["start"]]
                    local endTime = parts[formatMap["end"]]
                    local text = table.concat(parts, ",", formatMap["text"])

                    if startTime and endTime and text then
                        text = text:gsub("\\N", "\n")
                        text = text:gsub("{.-}", "")

                        table.insert(captions, {
                            text = text,
                            time = assTimeToSeconds(startTime),
                            endTime = assTimeToSeconds(endTime)
                        })
                    end
                end
            end
        end
    end

    return captions
end

--- MAIN

--- Parses captions from various formats
--- @param content string The content of the caption file
--- @param format string The format of the caption file
--- | "srt"
--- | "vtt"
--- | "sbv"
--- | "stl"
--- | "ass"
--- | "lua"
--- @return table A table of captions
function captionParser.parse(content, format)
    if format == "srt" then
        return parseSRT(content)
    elseif format == "vtt" then
        return parseVTT(content)
    elseif format == "sbv" then
        return parseSBV(content)
    elseif format == "stl" then
        return parseSTL(content)
    elseif format == "ass" then
        return parseASS(content)
    elseif format == "lua" then
        return love.filesystem.load(content)()
    else
        error("Unsupported caption format: " .. tostring(format))
    end
end

--- Converts a table of captions back into a specific caption format.
--- If endTime is nil, it ends just before the next caption’s start time.
--- @param captions table A table of { text, time, endTime }
--- @param format string
--- | "srt"
--- | "vtt"
--- | "sbv"
--- | "ass"
--- @return string The formatted caption content
function captionParser.serialize(captions, format)
    if not captions or #captions == 0 then return "" end

    table.sort(captions, function(a, b) return a.time < b.time end)

    for i = 1, #captions do
        local cap = captions[i]
        if not cap.endTime then
            local nextCap = captions[i + 1]
            if nextCap then
                cap.endTime = nextCap.time - 0.001
            else
                cap.endTime = cap.time + 2
            end
        end
    end

    local out = {}

    if format == "srt" then
        for i, cap in ipairs(captions) do
            table.insert(out, string.format("%d\n%s-->%s\n%s\n\n",
                i,
                secondsToSRTTime(cap.time),
                secondsToSRTTime(cap.endTime),
                cap.text)
            )
        end

        return table.concat(out):gsub("\n+$", "\n")
    elseif format == "vtt" then
        table.insert(out, "WEBVTT\n\n")
        for _, cap in ipairs(captions) do
            local startTime = secondsToSRTTime(cap.time):gsub(",", ".")
            local endTime = secondsToSRTTime(cap.endTime):gsub(",", ".")
            table.insert(out, string.format("%s --> %s\n%s\n\n",
                startTime, endTime, cap.text))
        end

        return table.concat(out):gsub("\n+$", "\n")
    elseif format == "sbv" then
        for _, cap in ipairs(captions) do
            table.insert(out, string.format("%s,%s\n%s\n\n",
                secondsToSBVTime(cap.time),
                secondsToSBVTime(cap.endTime),
                cap.text))
        end

        return table.concat(out):gsub("\n+$", "\n")
    elseif format == "ass" then
        table.insert(out, "[Script Info]\nScriptType: v4.00+\nCollisions: Normal\nPlayResY: 720\nPlayResX: 1280\n\n[V4+ Styles]\nFormat: Name, Fontname, Fontsize, PrimaryColour, SecondaryColour, OutlineColour, BackColour, Bold, Italic, Underline, StrikeOut, ScaleX, ScaleY, Spacing, Angle, BorderStyle, Outline, Shadow, Alignment, MarginL, MarginR, MarginV, Encoding\nStyle: Default,Arial,36,&H00FFFFFF,&H000000FF,&H00000000,&H00000000,0,0,0,0,100,100,0,0,1,1,0,2,10,10,10,1\n\n[Events]\nFormat: Layer, Start, End, Style, Name, MarginL, MarginR, MarginV, Effect, Text\n")
        for _, cap in ipairs(captions) do
            table.insert(out, string.format("Dialogue: 0,%s,%s,Default,,0,0,0,,%s\n",
                secondsToASSTime(cap.time),
                secondsToASSTime(cap.endTime),
                cap.text:gsub("\n", "\\N")))
        end

        return table.concat(out)
    elseif format == "stl" then
        table.insert(out, "$ Tape Position :\n")
        for _, cap in ipairs(captions) do
            table.insert(out, string.format("//%s,%s %s\n",
                secondsToSTLTime(cap.time),
                secondsToSTLTime(cap.endTime),
                cap.text:gsub("\n", "|")))
        end

        return table.concat(out)
    else
        error("Unsupported output format: " .. tostring(format))
    end

    return table.concat(out)
end

return captionParser