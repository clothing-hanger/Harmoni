local skinFolder = "Skins/Default Arrow"
local function skin(path)
    return skinFolder .. "/" .. path
end

return {   -- i need to remove lots of these tbh..
    Params = {
        ["Note Size"] = 125,
        ["Hold Size"] = 125,
        ["HoldEnd Size"] = 125,
        ["Receptor Size"] = 125,
        ["Judgement Size"] = 1,
        ["Judgement Y Offset"] = baseScreenRatio.y/2,
        ["Judgement X Offset"] = 400,
        ["Combo Y Offset"] = -120,
        ["Combo X Offset"] = 0,
        ["Hit Error Meter Y"] = 0,
        ["Hit Error Meter X"] = 0,
        ["Hit Error Meter Height"] = 15,
        ["Hit Error Meter Width"] = 150,
        ["Hit Error Meter Solid"] = false,
        ["Hit Error Meter Fade"] = 1000,
        ["Note Underlay Color"] = rgb {0, 0, 0},
        ["Judgement Counter Bump Amount"] = 50,
        ["Judgement Bump Amount"] = -70,
        ["Judgement Bump Tween Type"] = "out-back",
        ["Judgement Bump Time"] = 0.5,
        ["Judgement Counter Spacing"] = 60,
        ["Judgement Counter X"] = baseScreenRatio.x - 210,
        ["Judgement Counter Y"] = baseScreenRatio.y/2-150,
        ["Health Bar X"] = 350,
        ["Health Bar Y"] = 300,
        ["Health Bar Height"] = 700,
        ["Health Bar Width"] = 15,
        ["Health Bar Direction"] = "vertical",
        ["Marvelous Color"] = rgb {0, 213, 255},
        ["Perfect Color"] = rgb {0, 0, 225},
        ["Great Color"] = rgb {0, 255, 81},
        ["Good Color"] = rgb {0, 153, 81},
        ["Okay Color"] = rgb {210, 13, 81},
        ["Miss Color"] = rgb {209, 0, 0},
    },

    Fonts = {
        ["HUD Large"] = love.graphics.newFont(skin("FONTS/Novamono-njdg.ttf"), 65),
        ["HUD Small"] = love.graphics.newFont(skin("FONTS/Novamono-njdg.ttf"), 15),
        ["HUD Extra Small"] = love.graphics.newFont(skin("FONTS/Novamono-njdg.ttf"), 12),
        ["Combo"] = love.graphics.newFont(skin("FONTS/Novamono-njdg.ttf"), 35),
        ["Menu Large"] = love.graphics.newFont(skin("FONTS/SourceCodePro-Medium.ttf"), 25),
        ["Menu Small"] = love.graphics.newFont(skin("FONTS/SourceCodePro-Medium.ttf"), 15),
        ["Menu Extra Small"] = love.graphics.newFont(skin("FONTS/SourceCodePro-Medium.ttf"), 12),
        ["Judgement Counter"] = love.graphics.newFont(skin("FONTS/Novamono-njdg.ttf"), 60)
    },

    Notes = {
        ["4K"] = {
            ["Left"] = love.graphics.newImage(skin("NOTES/NoteLeft.png")),
            ["Down"] = love.graphics.newImage(skin("NOTES/NoteDown.png")),
            ["Right"] = love.graphics.newImage(skin("NOTES/NoteRight.png")),
            ["Up"] = love.graphics.newImage(skin("NOTES/NoteUp.png")),
        },
        ["7K"] = {
            ["Left1"] = love.graphics.newImage(skin("NOTES/NoteLeft.png")),
            ["Down"] = love.graphics.newImage(skin("NOTES/NoteDown.png")),
            ["Left2"] = love.graphics.newImage(skin("NOTES/NoteLeft.png")),
            ["Center"] = love.graphics.newImage(skin("NOTES/NoteUp.png")),
            ["Right1"] = love.graphics.newImage(skin("NOTES/NoteRight.png")),
            ["Up"] = love.graphics.newImage(skin("NOTES/NoteUp.png")),
            ["Right2"] = love.graphics.newImage(skin("NOTES/NoteRight.png")),
        }
    },

    HoldNotes = {
        ["4K"] = {
            ["Left"] = love.graphics.newImage(skin("NOTES/NoteLeftTrail.png")),
            ["Down"] = love.graphics.newImage(skin("NOTES/NoteDownTrail.png")),
            ["Right"] = love.graphics.newImage(skin("NOTES/NoteRightTrail.png")),
            ["Up"] = love.graphics.newImage(skin("NOTES/NoteUpTrail.png")),
        },
        ["7K"] = {
            ["Left1"] = love.graphics.newImage(skin("NOTES/NoteLeftTrail.png")),
            ["Down"] = love.graphics.newImage(skin("NOTES/NoteDownTrail.png")),
            ["Right1"] = love.graphics.newImage(skin("NOTES/NoteRightTrail.png")),
            ["Center"] = love.graphics.newImage(skin("NOTES/NoteUpTrail.png")),
            ["Left2"] = love.graphics.newImage(skin("NOTES/NoteLeftTrail.png")),
            ["Up"] = love.graphics.newImage(skin("NOTES/NoteUpTrail.png")),
            ["Right2"] = love.graphics.newImage(skin("NOTES/NoteRightTrail.png")),
        }
    },

    HoldEndNotes = {
        ["4K"] = {
            ["Left"] = love.graphics.newImage(skin("NOTES/NoteLeftTrail.png")),
            ["Down"] = love.graphics.newImage(skin("NOTES/NoteDownTrail.png")),
            ["Right"] = love.graphics.newImage(skin("NOTES/NoteRightTrail.png")),
            ["Up"] = love.graphics.newImage(skin("NOTES/NoteUpTrail.png")),
        },
        ["7K"] = {
            ["Left1"] = love.graphics.newImage(skin("NOTES/NoteLeftTrail.png")),
            ["Down"] = love.graphics.newImage(skin("NOTES/NoteDownTrail.png")),
            ["Right1"] = love.graphics.newImage(skin("NOTES/NoteRightTrail.png")),
            ["Center"] = love.graphics.newImage(skin("NOTES/NoteUpTrail.png")),
            ["Left2"] = love.graphics.newImage(skin("NOTES/NoteLeftTrail.png")),
            ["Up"] = love.graphics.newImage(skin("NOTES/NoteUpTrail.png")),
            ["Right2"] = love.graphics.newImage(skin("NOTES/NoteRightTrail.png")),
        }
    },

    Receptors = {
        Up = {
            ["4K"] = {
                ["Left"] = love.graphics.newImage(skin("RECEPTORS/ReceptorLeft.png")),
                ["Down"] = love.graphics.newImage(skin("RECEPTORS/ReceptorDown.png")),
                ["Right"] = love.graphics.newImage(skin("RECEPTORS/ReceptorRight.png")),
                ["Up"] = love.graphics.newImage(skin("RECEPTORS/ReceptorUp.png")),
            },
            ["7K"] = {
                ["Left1"] = love.graphics.newImage(skin("RECEPTORS/ReceptorLeft.png")),
                ["Down"] = love.graphics.newImage(skin("RECEPTORS/ReceptorDown.png")),
                ["Right1"] = love.graphics.newImage(skin("RECEPTORS/ReceptorRight.png")),
                ["Center"] = love.graphics.newImage(skin("RECEPTORS/ReceptorUp.png")),
                ["Left2"] = love.graphics.newImage(skin("RECEPTORS/ReceptorLeft.png")),
                ["Up"] = love.graphics.newImage(skin("RECEPTORS/ReceptorUp.png")),
                ["Right2"] = love.graphics.newImage(skin("RECEPTORS/ReceptorRight.png")),
            }
        },
        Down = {
            ["4K"] = {
                ["Left"] = love.graphics.newImage(skin("RECEPTORS/ReceptorPressedLeft.png")),
                ["Down"] = love.graphics.newImage(skin("RECEPTORS/ReceptorPressedDown.png")),
                ["Right"] = love.graphics.newImage(skin("RECEPTORS/ReceptorPressedRight.png")),
                ["Up"] = love.graphics.newImage(skin("RECEPTORS/ReceptorPressedUp.png")),
            },
            ["7K"] = {
                ["Left1"] = love.graphics.newImage(skin("RECEPTORS/ReceptorPressedLeft.png")),
                ["Down"] = love.graphics.newImage(skin("RECEPTORS/ReceptorPressedDown.png")),
                ["Right1"] = love.graphics.newImage(skin("RECEPTORS/ReceptorPressedRight.png")),
                ["Center"] = love.graphics.newImage(skin("RECEPTORS/ReceptorPressedUp.png")),
                ["Left2"] = love.graphics.newImage(skin("RECEPTORS/ReceptorPressedLeft.png")),
                ["Up"] = love.graphics.newImage(skin("RECEPTORS/ReceptorPressedUp.png")),
                ["Right2"] = love.graphics.newImage(skin("RECEPTORS/ReceptorPressedRight.png")),
            }
        }
    },

    Judgements = {
        ["Perfect"] = love.graphics.newImage(skin("JUDGEMENTS/perfect.png")),
        ["Great"] = love.graphics.newImage(skin("JUDGEMENTS/great.png")),
        ["Good"] = love.graphics.newImage(skin("JUDGEMENTS/good.png")),
        ["Alright"] = love.graphics.newImage(skin("JUDGEMENTS/alright.png")),
        ["Awful"] = love.graphics.newImage(skin("JUDGEMENTS/awful.png")),
        ["Miss"] = love.graphics.newImage(skin("JUDGEMENTS/miss.png")),
    },

    Particles = {
        ["Note Splash"] = love.graphics.newImage(skin("PARTICLES/circle.png")),
        ["Combo Alert"] = love.graphics.newImage(skin("PARTICLES/the  o r b.png")),
        ["Health Particle"] = love.graphics.newImage(skin("PARTICLES/lightDot.png")),
    },

    Menu = {
        ["Main Logo"] = love.graphics.newImage(skin("MENU/main logo.png")),
        ["H"] = love.graphics.newImage(skin("MENU/H.png")),
        ["Icon Logo"] = love.graphics.newImage(skin("MENU/logoH.png")),
        ["Loading Spinner"] = love.graphics.newImage(skin("MENU/logoH.png")),
    },

    Sounds = {
        ["First Miss"] = nil,
        ["Miss"] = nil,
        ["Menu Scroll"] = nil,
        ["Hit Sound"] = nil,
        ["Tap Sound"] = nil,
    },

    Colors = {
        ["Song Button Fill"] = {0, 0, 0, 0.7},
        ["Song Button Line"] = {0.8, 0.8, 0.8, 1},
        ["Song Button Text"] = {1, 1, 1, 1},

        ["Difficulty Button Fill"] = {0, 0, 0, 0.7},
        ["Difficulty Button Line"] = {0.8, 0.8, 0.8, 1},
        ["Difficulty Button Text"] = {1, 1, 1, 1},

        ["Song Info Box Fill"] = {0, 0, 0, 0.7},
        ["Song Info Box Line"] = {0.8, 0.8, 0.8, 1},
        ["Song Info Box Text"] = {1, 1, 1, 1},

        ["List Menu Backing Fill"] = {0, 0, 0, 0.7},
        ["List Menu Backing Line"] = {0.8, 0.8, 0.8, 1},
        ["List Menu Button Fill"] = {0, 0, 0, 0.7},
        ["List Menu Button Line"] = {0.8, 0.8, 0.8, 1},
        ["List Menu Text"] = {1, 1, 1, 1},

        ["Modifiers Menu Backing Fill"] = {0, 0, 0, 0.7},
        ["Modifiers Menu Backing Line"] = {0.8, 0.8, 0.8, 1},
        ["Modifiers Menu Button Fill"] = {0, 0, 0, 0.7},
        ["Modifiers Menu Button Line"] = {0.8, 0.8, 0.8, 1},
        ["Modifiers Menu Text"] = {1, 1, 1, 1},

        ["Song Select Tabs Fill"] = {0, 0, 0, 0.7},
        ["Song Select Tabs Line"] = {0.8, 0.8, 0.8, 1},
        ["Song Select Tabs Text"] = {1, 1, 1, 1},
    },
}
