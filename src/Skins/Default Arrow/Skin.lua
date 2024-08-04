
Skin = {}
SkinFolder = "Skins/Default Arrow/"

Skin.Params = {
    ["Note Size"] = 125
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

