
Skin = {}
SkinFolder = "Skins/Default Arrow/"

Skin.Params = {
    ["Note Size"] = 125,
    ["Judgement Size"] = 0.4,
    ["Judgement Y Offset"] = -150,    -- remember, negative numbers go higher on the screen, positive goes lower
    ["Judgement X Offset"] = 0,       -- nothing weird with X, lower goes left higher goes right
}

Skin.Notes = {
    ["Left"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteLeft.png"),
    ["Down"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteDown.png"),
    ["Right"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteRight.png"),
    ["Up"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteUp.png"),
}

Skin.Receptors = {
    Up = {
        ["Left"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorLeft.png"),
        ["Down"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorDown.png"),
        ["Right"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorRight.png"),
        ["Up"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorUp.png"),
    },
    Down = {
        ["Left"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorPressedLeft.png"),
        ["Down"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorPressedDown.png"),
        ["Right"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorPressedRight.png"),
        ["Up"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorPressedUp.png"),
    }
}

Skin.Judgements = {
    ["Marvelous"] = love.graphics.newImage(SkinFolder .. "JUDGEMENTS/Marvelous.png"),
    ["Perfect"] = love.graphics.newImage(SkinFolder .. "JUDGEMENTS/Perfect.png"),
    ["Great"] = love.graphics.newImage(SkinFolder .. "JUDGEMENTS/Great.png"),
    ["Good"] = love.graphics.newImage(SkinFolder .. "JUDGEMENTS/Good.png"),
    ["Okay"] = love.graphics.newImage(SkinFolder .. "JUDGEMENTS/Okay.png"),
    ["Miss"] = love.graphics.newImage(SkinFolder .. "JUDGEMENTS/Miss.png"),
    
}