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

--- CAPTION PARSERS

--- Parses SRT formatted captions
--- @param content string The content of the SRT file
--- @return table A table of captions with text, time, and endTime
local function parseSRT(content)
    local lines = {}
    for line in content:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    local captions = {}
    local i = 1
    while i <= #lines do
        local timecode = lines[i + 1]
        local textLines = {}
        local j = i + 2
        while j <= #lines and lines[j] ~= "" do
            table.insert(textLines, lines[j])
            j = j + 1
        end

        local startTime, endTime = timecode:match("(%d+:%d+:%d+,%d+)%s*-->%s*(%d+:%d+:%d+,%d+)")
        if startTime and endTime then
            table.insert(captions, {
                text = table.concat(textLines, "\n"),
                time = srtTimeToSeconds(startTime),
                endTime = srtTimeToSeconds(endTime)
            })
        end

        i = j + 1
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

return captionParser