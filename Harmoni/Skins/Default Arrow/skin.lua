print("Skin Loaded!")



skinFolder = "Skins/Default Arrow/"



--IMPORTANT
--Remember to change the skinFolder string, or the skin will point to a different skin's folder


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

NoteLeftTrailImage = love.graphics.newImage(skinFolder .. "NOTES/NoteDownTrailEnd.png")
NoteRightTrailImage = love.graphics.newImage(skinFolder .. "NOTES/NoteDownTrailEnd.png")
NoteUpTrailImage = love.graphics.newImage(skinFolder .. "NOTES/NoteDownTrailEnd.png")
NoteDownTrailImage = love.graphics.newImage(skinFolder .. "NOTES/NoteDownTrailEnd.png")

HoldNoteEndLeftImage = love.graphics.newImage(skinFolder .. "NOTES/NoteDownTrailEnd.png")
HoldNoteEndDownImage = love.graphics.newImage(skinFolder .. "NOTES/NoteDownTrailEnd.png")
HoldNoteEndUpImage = love.graphics.newImage(skinFolder .. "NOTES/NoteDownTrailEnd.png")
HoldNoteEndRightImage = love.graphics.newImage(skinFolder .. "NOTES/NoteDownTrailEnd.png")


SongSelectFrameImage = love.graphics.newImage(skinFolder .. "SONGSELECT/frame.png")
discImage = love.graphics.newImage(skinFolder .. "SONGSELECT/disc.png")
decorationImage = love.graphics.newImage(skinFolder .. "SONGSELECT/clothing hanger.png")
loadingImage = love.graphics.newImage(skinFolder .. "SONGSELECT/loading.png")




judgementHeight = 100
judgementWidth = 325
JudgementPosition = 250
ComboPosition = 125

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