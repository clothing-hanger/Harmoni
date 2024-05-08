print("Skin Loaded!")



skinFolder = "Skins/Default Arrow (white)/"


ReceptorLeftImage = love.graphics.newImage(skinFolder .. "RECEPTORS/ReceptorLeft.png")
ReceptorDownImage = love.graphics.newImage(skinFolder .. "RECEPTORS/ReceptorDown.png")
ReceptorRightImage = love.graphics.newImage(skinFolder .. "RECEPTORS/ReceptorRight.png")
ReceptorUpImage = love.graphics.newImage(skinFolder .. "RECEPTORS/ReceptorUp.png")

ReceptorPressedLeftImage = love.graphics.newImage(skinFolder .. "RECEPTORS/ReceptorPressedLeft.png")
ReceptorPressedDownImage = love.graphics.newImage(skinFolder .. "RECEPTORS/ReceptorPressedDown.png")
ReceptorPressedRightImage = love.graphics.newImage(skinFolder .. "RECEPTORS/ReceptorPressedRight.png")
ReceptorPressedUpImage = love.graphics.newImage(skinFolder .. "RECEPTORS/ReceptorPressedUp.png")

NoteLeftImage = love.graphics.newImage(skinFolder .. "NOTES/NoteLeft.png")
NoteDownImage = love.graphics.newImage(skinFolder .. "NOTES/NoteDown.png")
NoteRightImage = love.graphics.newImage(skinFolder .. "NOTES/NoteRight.png")
NoteUpImage = love.graphics.newImage(skinFolder .. "NOTES/NoteUp.png")

MarvelousImage = love.graphics.newImage(skinFolder .. "JUDGEMENTS/Marvelous.png")
PerfectImage = love.graphics.newImage(skinFolder .. "JUDGEMENTS/Perfect.png")
GreatImage = love.graphics.newImage(skinFolder .. "JUDGEMENTS/Great.png")
GoodImage = love.graphics.newImage(skinFolder .. "JUDGEMENTS/Good.png")
OkayImage = love.graphics.newImage(skinFolder .. "JUDGEMENTS/Okay.png")
MissImage = love.graphics.newImage(skinFolder .. "JUDGEMENTS/Miss.png")


judgementSize = 150




skinLoad = function()
end

skinUpdate = function()
end

skinDrawUnderDim = function()
end

skinDrawAboveDimUnderNotes = function()
end

skinDrawAbove = function()
end