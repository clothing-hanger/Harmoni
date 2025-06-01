local screenMiddle = love.graphics.getWidth() / 2
musicPath = "Music/"
maniaNoteSize = 30
maninaLaneGap = 30
maniaScrollSpeed = 2

defaultFont = love.graphics.newFont(12)

songButtonFontLarge = love.graphics.newFont("fonts/astonpoliz.regular.ttf", 35)
songButtonFontSmall = love.graphics.newFont("fonts/astonpoliz.regular.ttf", 25)

songSelectSongInfoFontLarge = love.graphics.newFont("fonts/astonpoliz.regular.ttf", 35)
songSelectSongInfoFontSmall = love.graphics.newFont("fonts/astonpoliz.regular.ttf", 25)

maniaLanePositions = {
    screenMiddle - (maniaNoteSize*2.5) - (maninaLaneGap*1.5),
    screenMiddle - (maniaNoteSize*1.5) - (maninaLaneGap*0.5),
    screenMiddle + (maniaNoteSize*1.5) + (maninaLaneGap*0.5),
    screenMiddle + (maniaNoteSize*2.5) + (maninaLaneGap*1.5),
}

