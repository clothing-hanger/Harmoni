LaneWidth = 120
ScrollSpeed = 1.6

love.filesystem.load("Skins/Default Arrow/Skin.lua")()

LanesPositions = {
    Inits.GameWidth/2 - (LaneWidth*1.5),
    Inits.GameWidth/2 - (LaneWidth*0.5),
    Inits.GameWidth/2 + (LaneWidth*0.5),
    Inits.GameWidth/2 + (LaneWidth*1.5)
}

