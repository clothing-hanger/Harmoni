local ASSRenderer = Class:extend("ASSRenderer")

local function clamp(n, a, b)
    return n < a and a or (n > b and b or n)
end

local function assHexToRGBA(ass)
    if not ass then return 1,1,1,1 end
    local s = tostring(ass):gsub("^&H",""):gsub("&$","")
    if #s == 6 then s = "00"..s end
    if #s ~= 8 then return 1,1,1,1 end
    local aa = tonumber(s:sub(1,2),16) or 0
    local bb = tonumber(s:sub(3,4),16) or 0
    local gg = tonumber(s:sub(5,6),16) or 0
    local rr = tonumber(s:sub(7,8),16) or 0
    local alpha = 1 - (aa / 255)
    return rr/255, gg/255, bb/255, alpha
end

local function stripRich(s)
    if not s then return "" end
    return (s:gsub("{[^}]-}", ""):gsub("<[^>]->", ""))
end

local function parseNumberList(s)
    local out = {}
    for num in s:gmatch("([%d%.%-]+)") do
        table.insert(out, tonumber(num))
    end
    return out
end

function ASSRenderer:new(x, y, width, height, events)
    self.x, self.y, self.width, self.height = x or 0, y or 0, width or 0, height or 0

    self.events = events or {}
    self.currentLine = 0
    self.lastAudioTime = 0

    self.defaultFont = SkinHandler:getFont("Menu", 40) or love.graphics.getFont() -- idk how their font thingymajig works fully so i hope that its the first one lmfao
    self.defaultSize = 40
    self:prepareEvents()
end

function ASSRenderer:prepareEvents()
    for _, evt in ipairs(self.events) do
        if not evt.time and evt.start then evt.time = evt.start end
        if not evt.endTime and evt["end"] then evt.endTime = evt["end"] end
        if not evt.endTime and evt["end_"] then evt.endTime = evt["end_"] end

        evt.assRaw = evt.assRaw or evt.raw or evt.orig or evt.text or ""

        evt.plain = stripRich(evt.assRaw)
        evt.alpha = 1
        evt.override = {}
    end
end

function ASSRenderer:update(dt, audioTime)
    audioTime = audioTime or 0
    local backward = audioTime < (self.lastAudioTime or 0)
    self.lastAudioTime = audioTime

    if backward then
        for _, ev in ipairs(self.events) do ev.alpha = 1 end
    end

    local active = nil
    for i, ev in ipairs(self.events) do
        if ev.time and ev.endTime then
            if audioTime >= ev.time and audioTime <= ev.endTime then
                active = i
            end
        end
    end
    self.currentLine = active or 0
end

local function overrideBlockIter(evt)
    local s = evt.assRaw or evt.text or ""
    return coroutine.wrap(function()
        for block in s:gmatch("{(.-)}") do
            coroutine.yield(block)
        end
        for block in s:gmatch("<(.-)>") do
            coroutine.yield("<"..block..">")
        end
    end)
end

local function applyASSOverrides(evt, audioTime)
    evt.override = {
        x = nil, y = nil,
        color = {1,1,1,1},
        font = nil,
        size = evt.fontSize or 40,
        align = tonumber(evt.align) or 2,
        fade = nil,
        karaokeSegments = nil,
        margin = {10,10,10,10},
        rotation = 0,
        scaleX = 1,
        scaleY = 1,
        orgX = nil,
        orgY = nil,
        bord = 0,
        shad = 0,
        bold = false,
        italic = false,
        underline = false,
        strike = false,
        verticalText = false,
        shake = false,
    }

    for block in overrideBlockIter(evt) do
        if block:match("<b>") then evt.override.bold = true end
        if block:match("</b>") then evt.override.bold = false end
        if block:match("<i>") then evt.override.italic = true end
        if block:match("</i>") then evt.override.italic = false end
        if block:match("<u>") then evt.override.underline = true end
        if block:match("</u>") then evt.override.underline = false end
        if block:match("<s>") then evt.override.strike = true end
        if block:match("</s>") then evt.override.strike = false end

        local color = block:match("<c=(#%x+)>")
        if color then
            local r = tonumber(color:sub(2,3),16)/255
            local g = tonumber(color:sub(4,5),16)/255
            local b = tonumber(color:sub(6,7),16)/255
            evt.override.color = {r,g,b,1}
        end

        local fontName = block:match("<fontName=(.-)>")
        if fontName then evt.override.font = fontName end
        local fontSize = block:match("<fontSize=(%d+)>")
        if fontSize then evt.override.size = tonumber(fontSize) end

        local align = block:match("<an=(%d)>")
        if align then evt.override.align = tonumber(align) end

        local px, py = block:match("<pos%(([%d%.%-]+),([%d%.%-]+)%)>")
        if px and py then evt.override.x = tonumber(px); evt.override.y = tonumber(py) end
        
        local moveArgs = {}
        local x1, x2, x3, x4 = block:match("<move%(([%d%.%-]+),([%d%.%-]+),([%d%.%-]+),([%d%.%-]+)%)>")
        if x1 and x2 and x3 and x4 then
            x1, x2, x3, x4 = tonumber(x1), tonumber(x2), tonumber(x3), tonumber(x4)
            local totalMoveTime = evt.endTime - evt.time
            if totalMoveTime > 0 then
                local elapsed = audioTime - evt.time
                local t = clamp(elapsed / totalMoveTime, 0, 1)
                evt.override.x = x1 + (x3 - x1) * t
                evt.override.y = x2 + (x4 - x2) * t
            else
                evt.override.x = x3
                evt.override.y = x4
            end
        end

        local f1, f2 = block:match("<fade%(([%d%.%-]+),([%d%.%-]+)%)>")
        if f1 and f2 then evt.override.fade = {tonumber(f1), tonumber(f2)} end

        local rx = block:match("<frx=([%d%.%-]+)>")
        if rx then evt.override.rotation = tonumber(rx) end
        local ry = block:match("<fry=([%d%.%-]+)>")
        if ry then evt.override.rotation = tonumber(ry) end
        local rz = block:match("<frz=([%d%.%-]+)>")
        if rz then evt.override.rotation = tonumber(rz) end
        local sx = block:match("<fax=([%d%.%-]+)>")
        if sx then evt.override.scaleX = tonumber(sx) end
        local sy = block:match("<fay=([%d%.%-]+)>")
        if sy then evt.override.scaleY = tonumber(sy) end

        local ox, oy = block:match("<org%(([%d%.%-]+),([%d%.%-]+)%)>")
        if ox and oy then evt.override.orgX = tonumber(ox); evt.override.orgY = tonumber(oy) end

        local bord = block:match("<bord=([%d%.%-]+)>")
        if bord then evt.override.bord = tonumber(bord) end
        local shad = block:match("<shad=([%d%.%-]+)>")
        if shad then evt.override.shad = tonumber(shad) end

        local vt = block:match("<verticalText>")
        if vt then evt.override.verticalText = true end
        local sh = block:match("<shake>")
        if sh then evt.override.shake = true end
    end
end

function ASSRenderer:draw(audioTime)
    local screenW = (baseScreenRatio and baseScreenRatio.x) or love.graphics.getWidth()
    local screenH = (baseScreenRatio and baseScreenRatio.y) or love.graphics.getHeight()

    if #self.events == 0 then return end
    if self.currentLine == 0 then return end

    local evt = self.events[self.currentLine]
    if not evt or not evt.time or not evt.endTime then return end

    local time = self.lastAudioTime or 0
    applyASSOverrides(evt, time)

    if evt.override.fade then
        local fin = (evt.override.fade[1] or 0)/1000
        local fout = (evt.override.fade[2] or 0)/1000
        local life = audioTime - evt.time
        local remain = evt.endTime - audioTime
        if life < fin then
            evt.alpha = clamp(life / fin, 0, 1)
        elseif remain < fout then
            evt.alpha = clamp(remain / fout, 0, 1)
        else
            evt.alpha = 1
        end
    else
        evt.alpha = 1
    end

    local font = SkinHandler:getFont("Menu", evt.override.size) or self.defaultFont
    love.graphics.setFont(font)

    local text = stripRich(evt.assRaw)
    local w = font:getWidth(text)
    local h = font:getHeight()

    local drawX = evt.override.x or (screenW/2)
    local drawY = evt.override.y or (screenH - h - 80)

    local an = evt.override.align or 2
    if an >= 4 and an <= 6 then drawY = drawY - (screenH/2) end
    if an >= 7 then drawY = drawY - screenH end
    if an % 3 == 1 then
    elseif an % 3 == 2 then
        drawX = drawX - (w/2)
    else
        drawX = drawX - w
    end

    local m = evt.override.margin or {10,10,10,10}
    if drawX < m[1] then drawX = m[1] end
    if drawX + w > screenW - m[2] then drawX = screenW - m[2] - w end
    if drawY < m[3] then drawY = m[3] end
    if drawY + h > screenH - m[4] then drawY = screenH - m[4] - h end

    if evt.override.shake then
        local shakeAmount = 2
        drawX = drawX + love.math.random(-shakeAmount, shakeAmount)
        drawY = drawY + love.math.random(-shakeAmount, shakeAmount)
    end

    local r,g,b,a = unpack(evt.override.color or {1,1,1,1})
    a = (a or 1) * (evt.alpha or 1)

    local shadowOffset = evt.override.shad or 0
    local border = evt.override.bord or 0

    local ox = evt.override.orgX or (drawX + w/2)
    local oy = evt.override.orgY or (drawY + h/2)

    local function drawTextWithEffects(txt, x, y)
        love.graphics.push()
        love.graphics.translate(ox, oy)
        love.graphics.rotate(math.rad(evt.override.rotation or 0))
        love.graphics.scale(evt.override.scaleX or 1, evt.override.scaleY or 1)
        love.graphics.translate(-ox, -oy)

        if shadowOffset > 0 then
            love.graphics.setColor(0,0,0,a)
            love.graphics.print(txt, x + shadowOffset, y + shadowOffset)
        end

        if border > 0 then
            love.graphics.setColor(0,0,0,a)
            for dx=-border,border do
                for dy=-border,border do
                    if dx ~=0 or dy~=0 then
                        love.graphics.print(txt, x+dx, y+dy)
                    end
                end
            end
        end

        love.graphics.setColor(r, g, b, a)
        love.graphics.print(txt, x, y)

        love.graphics.pop()
    end

    local padx = 10
    local pady = 4
    love.graphics.setColor(0, 0, 0, 0.7*a)
    local txtW = font:getWidth(text)
    local newlineCount = select(2, text:gsub("\n","")) + 1
    local txtH = font:getHeight(text) * newlineCount
    love.graphics.rectangle("fill", drawX - padx, drawY - pady, txtW + 2*padx, txtH + 2*pady, 5, 5)

    -- TODO: Fix why my fucking karaoke segmants aint workin g
    --[[ if evt.override.karaokeSegments and #evt.override.karaokeSegments > 0 then
        local cx = drawX
        for i, seg in ipairs(evt.override.karaokeSegments or {}) do
            local segText = seg.text or ""
            local segW = font:getWidth(segText)
            local segDur = seg.dur or ((evt.endTime - evt.time) * 100)
            local segSec = (segDur or 0)/100
            local totalDur = 0
            for _, s in ipairs(evt.override.karaokeSegments) do totalDur = totalDur + (s.dur or 0) end
            local totalSec = (totalDur > 0) and (totalDur / 100) or (evt.endTime - evt.time)
            local startSum = 0
            for j=1,i-1 do startSum = startSum + (evt.override.karaokeSegments[j].dur or 0) end
            local segStart = evt.time + (startSum/100)
            local segEnd = segStart + (seg.dur or 0)/100
            local progress = clamp((time - segStart)/math.max(1e-6, segEnd - segStart),0,1)

            drawTextWithEffects(segText, cx, drawY)
            local fillW = segW * progress
            if fillW > 0 then
                love.graphics.setScissor(math.floor(cx), math.floor(drawY), math.ceil(fillW), math.ceil(h))
                drawTextWithEffects(segText, cx, drawY)
                love.graphics.setScissor()
            end

            cx = cx + segW
        end
    else ]]
        drawTextWithEffects(text, drawX, drawY)
    --[[ end ]]

    if evt.override.underline then
        love.graphics.setColor(r, g, b, a)
        love.graphics.setLineWidth(2)
        love.graphics.line(drawX, drawY+h-4, drawX+w, drawY+h-4)
    end
    if evt.override.strike then
        love.graphics.setColor(r, g, b, a)
        love.graphics.setLineWidth(2)
        love.graphics.line(drawX, drawY + h/2, drawX+w, drawY+h/2)
    end

    love.graphics.setColor(1,1,1,1)
end

return ASSRenderer
