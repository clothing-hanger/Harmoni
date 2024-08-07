LaneWidth = 120
LaneHeight = 110
ScrollSpeed = 2
dimSetting = 0.8

love.filesystem.load("Skins/Default Arrow/Skin.lua")()

LanesPositions = {
    Inits.GameWidth/2 - (LaneWidth*1.5),
    Inits.GameWidth/2 - (LaneWidth*0.5),
    Inits.GameWidth/2 + (LaneWidth*0.5),
    Inits.GameWidth/2 + (LaneWidth*1.5),
}

function ResizeLanePositions()
    LanesPositions = {
        Inits.GameWidth/2 - (LaneWidth*1.5),
        Inits.GameWidth/2 - (LaneWidth*0.5),
        Inits.GameWidth/2 + (LaneWidth*0.5),
        Inits.GameWidth/2 + (LaneWidth*1.5),
    }
end

laneCount = 4




