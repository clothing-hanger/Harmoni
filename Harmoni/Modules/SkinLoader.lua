local function InitSkin(_, skinName)
    print("Loading Skin: " .. skinName)
    love.filesystem.load("Skins/" .. skinName .. "/Skin.lua")()

    -- Load Images
    ReceptorLeft = love.graphics.newImage(skinFolder .."/" .. ReceptorLeftImage)
    ReceptorDown = love.graphics.newImage(skinFolder .."/" .. ReceptorDownImage)
    ReceptorRight = love.graphics.newImage(skinFolder .."/" .. ReceptorRightImage)
    ReceptorUp = love.graphics.newImage(skinFolder .."/" .. ReceptorUpImage)

    ReceptorLeftPressed = love.graphics.newImage(skinFolder .."/" .. ReceptorPressedLeftImage)
    ReceptorDownPressed = love.graphics.newImage(skinFolder .."/" .. ReceptorPressedDownImage)
    ReceptorRightPressed = love.graphics.newImage(skinFolder .."/" .. ReceptorPressedRightImage)
    ReceptorUpPressed = love.graphics.newImage(skinFolder .."/" .. ReceptorPressedUpImage)
    
    NoteLeft = love.graphics.newImage(skinFolder .."/" .. NoteLeftImage)
    NoteDown = love.graphics.newImage(skinFolder .."/" .. NoteDownImage)
    NoteRight = love.graphics.newImage(skinFolder .."/" .. NoteRightImage)
    NoteUp = love.graphics.newImage(skinFolder .."/" .. NoteUpImage)

    Marvelous = love.graphics.newImage(skinFolder .."/" .. MarvelousImage)
    Perfect = love.graphics.newImage(skinFolder .."/" .. PerfectImage)
    Great = love.graphics.newImage(skinFolder .."/" .. GreatImage)
    Good = love.graphics.newImage(skinFolder .."/" .. GoodImage)
    Okay = love.graphics.newImage(skinFolder .."/" .. OkayImage)
    Miss = love.graphics.newImage(skinFolder .."/" .. MissImage)
end

return {
    InitSkin = InitSkin
}