
Skin = {}
SkinFolder = "Skins/Default Arrow/"



Skin.Params = {
    ["Note Size"] = 125,                          -- size of the notes, pretty obvious i think
    ["Hold Size"] = 125,                          -- ditto
    ["HoldEnd Size"] = 125,                       -- ditto
    ["Receptor Size"] = 125,                      -- do you even need to ask
    ["Judgement Size"] = 0.4,                     -- same as above
    ["Judgement Y Offset"] = -150,                -- Y position of the judgmement (0 is center of the screen, higher number means lower on screen)         
    ["Judgement X Offset"] = 0,                   -- X position of the judgmement (0 is center of the screen, higher number means further right on screen)
    ["Combo Y Offset"] = -120,                    -- same as judgement positions but for the combo display
    ["Combo X Offset"] = 0,                       -- same again
    ["Hit Error Meter Y"] = 0,                    -- also same, but for hit error graph
    ["Hit Error Meter X"] = 0,                    -- you get it by now
    ["Hit Error Meter Height"] = 15,              -- how tall the hit error graph is
    ["Hit Error Meter Width"] = 150,               -- how wide the hit error graph is
    ["Hit Error Meter Solid"] = false,            -- if true, the graph will be made of colored rectangles to show where the judgment windows are, hits will be black, if false, the only visible part of the graph will be the hits, and they will be colored as the color of the judgmement they are
    ["Hit Error Meter Fade"] = 1000,              -- how long in milliseconds a hit will take to fade from the hit error graph
    ["Health Bar X"] = 350,
    ["Health Bar Y"] = 300,
    ["Health Bar Height"] = 700,
    ["Health Bar Width"] = 15,
    ["Health Bar Direction"] = "vertical",
    ["Marvelous Color"] = rgb({0, 213, 255}),     -- color of marvelous (used for judgment display and hit error graph)
    ["Perfect Color"] = rgb({0,  0, 225}),        -- color of perfect
    ["Great Color"] = rgb({0, 255, 81}),          -- color of great
    ["Good Color"] = rgb({0, 153, 81}),           -- color of good
    ["Okay Color"] = rgb({210, 13, 81}),          -- color of okay
    ["Miss Color"] = rgb({209, 0, 0}),            -- color of miss
}


Skin.Fonts = {
    ["HUD Large"] = love.graphics.newFont(SkinFolder .. "FONTS/SourceCodePro-Medium.ttf", 65),
    ["HUD Small"] = love.graphics.newFont(SkinFolder .. "FONTS/SourceCodePro-Medium.ttf", 15),
    ["HUD Extra Small"] = love.graphics.newFont(SkinFolder .. "FONTS/SourceCodePro-Medium.ttf", 12),
    ["Combo"] = love.graphics.newFont(SkinFolder .. "FONTS/SourceCodePro-Medium.ttf", 35),
    ["Menu Large"] = love.graphics.newFont(SkinFolder .. "FONTS/SourceCodePro-Medium.ttf", 25),
    ["Menu Small"] = love.graphics.newFont(SkinFolder .. "FONTS/SourceCodePro-Medium.ttf", 15),
    ["Menu Extra Small"] = love.graphics.newFont(SkinFolder .. "FONTS/SourceCodePro-Medium.ttf", 12),
}

Skin.Notes = {
    ["4K"] = {
        ["Left"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteLeft.png"),
        ["Down"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteDown.png"),
        ["Right"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteRight.png"),
        ["Up"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteUp.png"),
    },
    ["7K"] = {
        ["Left1"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteLeft.png"),
        ["Down"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteDown.png"),
        ["Left2"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteLeft.png"),
        ["Center"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteUp.png"),
        ["Right1"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteRight.png"),
        ["Up"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteUp.png"),
        ["Right2"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteRight.png"),
    }
}

Skin.HoldNotes = {
    ["4K"] = {
        ["Left"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteLeftTrail.png"),
        ["Down"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteDownTrail.png"),
        ["Right"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteRightTrail.png"),
        ["Up"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteUpTrail.png"),
    },
    ["7K"] = {
        ["Left1"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteLeftTrail.png"),
        ["Down"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteDownTrail.png"),
        ["Right1"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteRightTrail.png"),
        ["Center"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteUpTrail.png"),
        ["Left2"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteLeftTrail.png"),
        ["Up"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteUpTrail.png"),
        ["Right2"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteRightTrail.png"),
    }
}

Skin.HoldEndNotes = {
    ["4K"] = {
        ["Left"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteLeftTrail.png"),
        ["Down"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteDownTrail.png"),
        ["Right"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteRightTrail.png"),
        ["Up"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteUpTrail.png"),
    },
    ["7K"] = {
        ["Left1"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteLeftTrail.png"),
        ["Down"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteDownTrail.png"),
        ["Right1"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteRightTrail.png"),
        ["Center"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteUpTrail.png"),
        ["Left2"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteLeftTrail.png"),
        ["Up"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteUpTrail.png"),
        ["Right2"] = love.graphics.newImage(SkinFolder .. "NOTES/NoteRightTrail.png"),
    }
}

Skin.Receptors = {
    Up = {
        ["4K"] = {
            ["Left"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorLeft.png"),
            ["Down"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorDown.png"),
            ["Right"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorRight.png"),
            ["Up"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorUp.png"),
        },
        ["7K"] = {
            ["Left1"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorLeft.png"),
            ["Down"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorDown.png"),
            ["Right1"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorRight.png"),
            ["Center"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorUp.png"),
            ["Left2"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorLeft.png"),
            ["Up"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorUp.png"),
            ["Right2"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorRight.png"),
        }
    },
    Down = {
        ["4K"] = {
            ["Left"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorPressedLeft.png"),
            ["Down"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorPressedDown.png"),
            ["Right"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorPressedRight.png"),
            ["Up"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorPressedUp.png"),
        },
        ["7K"] = {
            ["Left1"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorPressedLeft.png"),
            ["Down"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorPressedDown.png"),
            ["Right1"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorPressedRight.png"),
            ["Center"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorPressedUp.png"),
            ["Left2"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorPressedLeft.png"),
            ["Up"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorPressedUp.png"),
            ["Right2"] = love.graphics.newImage(SkinFolder .. "RECEPTORS/ReceptorPressedRight.png"),
        }
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

Skin.Menu = {
    ["Loading Spinner"] = love.graphics.newImage(SkinFolder .. "MENU/logoH.png"),
}

Skin.Sounds = {
    ["First Miss"] = nil,  -- miss sound, exclusive to the first miss
    ["Miss"] = nil,        -- general miss sound
    ["Menu Scroll"] = nil, --sound for scrolling (you should use a quick click for this)
    ["Hit Sound"] = nil,   -- sound for hitting notes
    ["Tap Sound"] = nil,   -- sound for tapping keys, but not hitting notes
}