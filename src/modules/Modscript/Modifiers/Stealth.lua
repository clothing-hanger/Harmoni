local Stealth = BaseModifier:extend()
Stealth.name = "Stealth" -- we don't actually use the base mod, just the submods
Stealth.percents = {0} -- add more with each playfield
Stealth.submods = {}
Stealth.parent = nil
Stealth.active = false

function Stealth:updateNote(beat, note, pos, playfield)
    local playfield = playfield or 1
    
    local stealthWhite = self:getSubmodValue("Note" .. note.lane .. "StealthWhite", playfield) + self:getSubmodValue("StealthWhite" .. note.lane, playfield) + self:getSubmodValue("StealthWhite", playfield)
    note.stealthWhite = stealthWhite

    local stealthOpacity = self:getSubmodValue("Note" .. note.lane .. "StealthOpacity", playfield) + self:getSubmodValue("StealthOpacity" .. note.lane, playfield) + self:getSubmodValue("StealthOpacity", playfield)
    note.stealthOpacity = stealthOpacity
end

function Stealth:updateReceptor(beat, receptor, pos, playfield)
    local stealthWhite = self:getSubmodValue("Receptor" .. receptor.lane .. "StealthWhite", playfield) + self:getSubmodValue("StealthWhite" .. receptor.lane, playfield) + self:getSubmodValue("StealthWhite", playfield)
    receptor.stealthWhite = stealthWhite

    local stealthOpacity = self:getSubmodValue("Receptor" .. receptor.lane .. "StealthOpacity", playfield) + self:getSubmodValue("StealthOpacity" .. receptor.lane, playfield) + self:getSubmodValue("StealthOpacity", playfield)
    receptor.stealthOpacity = stealthOpacity
end

function Stealth:getSubmods()
    local subMods = {"StealthWhite", "StealthOpacity"}

    for i = 1, States.game.gameModeManager.gameMode.playField[1].chart.meta.laneCount do
        table.insert(subMods, "Note" .. i .. "StealthWhite")
        table.insert(subMods, "Receptor" .. i .. "StealthWhite")

        table.insert(subMods, "Note" .. i .. "StealthOpacity")
        table.insert(subMods, "Receptor" .. i .. "StealthOpacity")

        table.insert(subMods, "StealthWhite" .. i)
        table.insert(subMods, "StealthOpacity" .. i)
    end

    return subMods
end

return Stealth