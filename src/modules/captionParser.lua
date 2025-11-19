---@diagnostic disable: redundant-return-value
--- By @GuglioIsStupid
--- Parses various caption formats into a lua table
--- Supports the following:
--- - SubRip (.srt)
--- - WebVTT (.vtt)
--- - YouTube SBV (.sbv)
--- - EBU STL (.stl)
--- - ASS (.ass)

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

local function assColorToHex(ass)
    if not ass then return nil end
    local bb, gg, rr = ass:match("&H(%x%x)(%x%x)(%x%x)")
    if not bb then return nil end
    return string.format("#%s%s%s", rr, gg, bb)
end

-- convert ASS formatting to simple tags, now with arguments
---@param str string The string to convert
---@return string The converted string
local function convertASSTags(str)
    if not str then return "" end

    str = str:gsub("\\N", "\n")

    str = str:gsub("{(.-)}", function(block)
        local out = ""

        for tag in block:gmatch("\\[^\\}]+") do
            local b = tag:match("\\b(%d+)")
            if b == "1" then out = out .. "<b>" elseif b == "0" then out = out .. "</b>" end

            local i = tag:match("\\i(%d+)")
            if i == "1" then out = out .. "<i>" elseif i == "0" then out = out .. "</i>" end

            local u = tag:match("\\u(%d+)")
            if u == "1" then out = out .. "<u>" elseif u == "0" then out = out .. "</u>" end

            local s = tag:match("\\s(%d+)")
            if s == "1" then out = out .. "<s>" elseif s == "0" then out = out .. "</s>" end

            local fn = tag:match("\\fn([^\\]+)")
            if fn then out = out .. string.format("<fontName=%q>", fn) end

            local fs = tag:match("\\fs(%d+)")
            if fs then out = out .. string.format("<fontSize=%d>", tonumber(fs)) end

            local clr = tag:match("\\c(&H%x+&)") or tag:match("\\1c(&H%x+&)")
            if clr then out = out .. "<c=" .. assColorToHex(clr) .. ">" end

            for n = 2,4 do
                local c2 = tag:match("\\"..n.."c(&H%x+&)")
                if c2 then out = out .. string.format("<c%d=%s>", n, assColorToHex(c2)) end
            end

            local px, py = tag:match("\\pos%(([%d%.%-]+),([%d%.%-]+)%)")
            if px then out = out .. string.format("<pos(%s,%s)>", px, py) end

            local x1,y1,x2,y2,t1,t2 = block:match("<move%(([%d%.%-]+),([%d%.%-]+),([%d%.%-]+),([%d%.%-]+),([%d%.%-]+),([%d%.%-]+)%)")
            if x1 then
                x1, y1, x2, y2, t1, t2 = tonumber(x1), tonumber(y1), tonumber(x2), tonumber(y2), tonumber(t1), tonumber(t2)
                if x1 then
                    if t1 and t2 then
                        out = out .. string.format("<move(%s,%s,%s,%s,%s,%s)>", x1, y1, x2, y2, t1, t2)
                    else
                        out = out .. string.format("<move(%s,%s,%s,%s)>", x1, y1, x2, y2)
                    end
                end
            else
                local x1,y1,x2,y2 = tag:match("\\move%(([%d%.%-]+),([%d%.%-]+),([%d%.%-]+),([%d%.%-]+)%)")
                if x1 then
                    x1, y1, x2, y2 = tonumber(x1), tonumber(y1), tonumber(x2), tonumber(y2)
                    if x1 then
                        out = out .. string.format("<move(%s,%s,%s,%s)>", x1, y1, x2, y2)
                    end
                end
            end

            local fa, fb = tag:match("\\fad%(([%d%.%-]+),([%d%.%-]+)%)")
            if fa then out = out .. string.format("<fade(%s,%s)>", fa, fb) end

            local f1,f2,f3,f4,f5,f6 = tag:match("\\fade%(([%d%.%-]+),([%d%.%-]+),([%d%.%-]+),([%d%.%-]+),([%d%.%-]+),([%d%.%-]+)%)") -- burp
            if f1 then out = out .. string.format("<fade(%s,%s,%s,%s,%s,%s)>", f1,f2,f3,f4,f5,f6) end

            local inside = tag:match("\\t%((.-)%)")
            if inside then out = out .. string.format("<transform(%s)>", inside) end

            local k = tag:match("\\k(%d+)")
            if k then out = out .. string.format("<karaoke=%s>", k) end

            if tag:match("\\ytvert") then out = out .. "<vertMove>" end
            if tag:match("\\ytshake") then out = out .. "<shake>" end
            if tag:match("\\ytchroma") then out = out .. "<chromatic>" end
            if tag:match("\\ytktGlitch") then out = out .. "<ktGlitch>" end
            if tag:match("\\ytsub") then out = out .. "<sub>" end
            if tag:match("\\ytsup") then out = out .. "<sup>" end
            if tag:match("\\ytpack") then out = out .. "<packed>" end

            if tag:match("\\r") then out = out .. "</>" end
        end

        return out
    end)

    local open_c = 0
    for _ in str:gmatch("<c=") do open_c = open_c + 1 end
    local close_c = 0
    for _ in str:gmatch("</c>") do close_c = close_c + 1 end
    for i = 1, open_c - close_c do
        str = str .. "</c>"
    end

    return str
end

--- Parses ASS formatted captions
--- @param content string The content of the ASS file
--- @return table A table of captions with text, time, and endTime
local function parseASS(content)
    local captions = {}

    local currentSection = ""
    local styles = {}
    local PlayResX, PlayResY = 0, 0

    local formatMap = {}
    local formatCount = 0

    for raw in content:gmatch("[^\r\n]+") do
        local line = raw:match("^%s*(.-)%s*$")

        if line:match("^%[.-%]$") then
            currentSection = line
        end

        if currentSection == "[Script Info]" then
            local key, val = line:match("^(%S+):%s*(.+)")
            if key == "PlayResX" then PlayResX = tonumber(val)
            elseif key == "PlayResY" then PlayResY = tonumber(val) end
        end

        if currentSection == "[V4+ Styles]" then
            local fmt = line:match("^Format:%s*(.+)")
            if fmt then
                styles._format = {}
                local i=1
                for f in fmt:gmatch("([^,]+)") do
                    styles._format[i] = f:lower():gsub("%s+","")
                    i=i+1
                end
            end

            local dat = line:match("^Style:%s*(.+)")
            if dat and styles._format then
                local parts = {}
                local remain = dat
                for i=1, #styles._format-1 do
                    local part, rest = remain:match("^([^,]*),(.*)$")
                    parts[i] = part
                    remain = rest
                end
                parts[#styles._format] = remain

                local styleName = parts[1]
                styles[styleName] = parts
            end
        end

        if currentSection == "[Events]" then
            local fmt = line:match("^Format:%s*(.+)")
            if fmt then
                formatMap = {}
                local i=1
                for f in fmt:gmatch("([^,]+)") do
                    formatMap[f:lower():gsub("%s+","")] = i
                    i=i+1
                end
                formatCount = i-1
            end

            local dia = line:match("^Dialogue:%s*(.+)")
            if dia and formatCount > 0 then
                local parts = {}
                local s = dia
                for i=1, formatCount-1 do
                    local p, r = s:match("^([^,]*),(.*)$")
                    parts[i] = p or s
                    s = r or ""
                end
                parts[formatCount] = s

                for i=1, #parts do
                    parts[i] = parts[i]:match("^%s*(.-)%s*$")
                end

                local startTime = parts[formatMap["start"]]
                local endTime = parts[formatMap["end"]]
                local text = parts[formatMap["text"]]

                if startTime and endTime and text then
                    table.insert(captions, {
                        text = convertASSTags(text),
                        time = assTimeToSeconds(startTime),
                        endTime = assTimeToSeconds(endTime),
                        style = parts[formatMap["style"]],
                        playResX = PlayResX,
                        playResY = PlayResY
                    })
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