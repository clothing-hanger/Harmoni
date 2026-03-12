local Move = BaseModifier:extend()
Move.name = "MoveX"
Move.percents = {0} -- add more with each playfield
Move.submods = {}
Move.parent = nil
Move.active = false

function Move:getPos(time, visualDiff, timeDiff, beat, pos, data, playfield, obj)
    local moveXPert = self:getValue(playfield)

    local leftSide = -850
    local rightSide = 850

    local convertedPos = moveXPert * (rightSide - leftSide) / 2

    local p = States.game.gameModeManager.gameMode.playField[playfield]
    p.offset.x = convertedPos

    return pos
end

function Move:getSubmods()
    local subMods = {"MoveY"}

    for i = 1, States.game.gameModeManager.gameMode.playField[1].chart.meta.laneCount do
        table.insert(subMods, "AMove" .. i .. "X")
        table.insert(subMods, "AMove" .. i .. "Y")
    end

    return subMods
end

return Move