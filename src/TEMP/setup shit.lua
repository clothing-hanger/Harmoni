function convertScrollSpeed(speed)
    return Inits.GameHeight / speed
end

BotPlay = true
LaneWidth = 120
LaneHeight = 110
ScrollSpeed = convertScrollSpeed(480)
dimSetting = 0.8

love.filesystem.load("Skins/Default Arrow/Skin.lua")()

LanesPositions = {
    Inits.GameWidth/2 - (LaneWidth*1.5),
    Inits.GameWidth/2 - (LaneWidth*0.5),
    Inits.GameWidth/2 + (LaneWidth*0.5),
    Inits.GameWidth/2 + (LaneWidth*1.5),
}



 




laneCount = 4




