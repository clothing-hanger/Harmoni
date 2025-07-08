Skin = {   -- i need to remove lots of these tbh..
    Params = {
        ["Note Size"] = 125,
        ["Hold Size"] = 125,
        ["HoldEnd Size"] = 125,
        ["Receptor Size"] = 125,
        ["Judgement Size"] = 1,
        ["Judgement Y Offset"] = baseScreenRatio.y/2,
        ["Judgement X Offset"] = baseScreenRatio.x/2-500,
        ["Combo Y Offset"] = baseScreenRatio.y/2,
        ["Combo X Offset"] = baseScreenRatio.x/2+500,
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
        ["Health Bar X Offset"] = baseScreenRatio.x/2+650,
        ["Health Bar Y Offset"] = baseScreenRatio.y-100,
        ["Health Bar Height"] = 1250,
        ["Health Bar Width"] = 40,
        ["Health Bar Direction"] = "vertical",
        ["Marvelous Color"] = rgb {0, 213, 255},
        ["Perfect Color"] = rgb {0, 0, 225},
        ["Great Color"] = rgb {0, 255, 81},
        ["Good Color"] = rgb {0, 153, 81},
        ["Okay Color"] = rgb {210, 13, 81},
        ["Miss Color"] = rgb {209, 0, 0},
    },

    Fonts = {
        ["HUD Large"] = love.graphics.newFont("FONTS/Novamono-njdg.ttf", 65),
        ["HUD Small"] = love.graphics.newFont("FONTS/Novamono-njdg.ttf", 15),
        ["HUD Extra Small"] = love.graphics.newFont("FONTS/Novamono-njdg.ttf", 12),
        ["Combo"] = love.graphics.newFont("FONTS/SourceCodePro-Medium.ttf", 65),
        ["Menu Large"] = love.graphics.newFont("FONTS/SourceCodePro-Medium.ttf", 25),
        ["Menu Small"] = love.graphics.newFont("FONTS/SourceCodePro-Medium.ttf", 15),
        ["Menu Extra Small"] = love.graphics.newFont("FONTS/SourceCodePro-Medium.ttf", 12),
        ["Judgement Counter"] = love.graphics.newFont("FONTS/Novamono-njdg.ttf", 60)
    },

    Notes = {
        ["4K"] = {
            ["Left"] = love.graphics.newImage("NOTES/NoteLeft.png"),
            ["Down"] = love.graphics.newImage("NOTES/NoteDown.png"),
            ["Right"] = love.graphics.newImage("NOTES/NoteRight.png"),
            ["Up"] = love.graphics.newImage("NOTES/NoteUp.png"),
        },
        ["7K"] = {
            ["Left1"] = love.graphics.newImage("NOTES/NoteLeft.png"),
            ["Down"] = love.graphics.newImage("NOTES/NoteDown.png"),
            ["Left2"] = love.graphics.newImage("NOTES/NoteLeft.png"),
            ["Center"] = love.graphics.newImage("NOTES/NoteUp.png"),
            ["Right1"] = love.graphics.newImage("NOTES/NoteRight.png"),
            ["Up"] = love.graphics.newImage("NOTES/NoteUp.png"),
            ["Right2"] = love.graphics.newImage("NOTES/NoteRight.png"),
        }
    },

    HoldNotes = {
        ["4K"] = {
            ["Left"] = love.graphics.newImage("NOTES/NoteLeftTrail.png"),
            ["Down"] = love.graphics.newImage("NOTES/NoteDownTrail.png"),
            ["Right"] = love.graphics.newImage("NOTES/NoteRightTrail.png"),
            ["Up"] = love.graphics.newImage("NOTES/NoteUpTrail.png"),
        },
        ["7K"] = {
            ["Left1"] = love.graphics.newImage("NOTES/NoteLeftTrail.png"),
            ["Down"] = love.graphics.newImage("NOTES/NoteDownTrail.png"),
            ["Right1"] = love.graphics.newImage("NOTES/NoteRightTrail.png"),
            ["Center"] = love.graphics.newImage("NOTES/NoteUpTrail.png"),
            ["Left2"] = love.graphics.newImage("NOTES/NoteLeftTrail.png"),
            ["Up"] = love.graphics.newImage("NOTES/NoteUpTrail.png"),
            ["Right2"] = love.graphics.newImage("NOTES/NoteRightTrail.png"),
        }
    },

    HoldEndNotes = {
        ["4K"] = {
            ["Left"] = love.graphics.newImage("NOTES/NoteLeftTrail.png"),
            ["Down"] = love.graphics.newImage("NOTES/NoteDownTrail.png"),
            ["Right"] = love.graphics.newImage("NOTES/NoteRightTrail.png"),
            ["Up"] = love.graphics.newImage("NOTES/NoteUpTrail.png"),
        },
        ["7K"] = {
            ["Left1"] = love.graphics.newImage("NOTES/NoteLeftTrail.png"),
            ["Down"] = love.graphics.newImage("NOTES/NoteDownTrail.png"),
            ["Right1"] = love.graphics.newImage("NOTES/NoteRightTrail.png"),
            ["Center"] = love.graphics.newImage("NOTES/NoteUpTrail.png"),
            ["Left2"] = love.graphics.newImage("NOTES/NoteLeftTrail.png"),
            ["Up"] = love.graphics.newImage("NOTES/NoteUpTrail.png"),
            ["Right2"] = love.graphics.newImage("NOTES/NoteRightTrail.png"),
        }
    },

    Receptors = {
        Up = {
            ["4K"] = {
                ["Left"] = love.graphics.newImage("RECEPTORS/ReceptorLeft.png"),
                ["Down"] = love.graphics.newImage("RECEPTORS/ReceptorDown.png"),
                ["Right"] = love.graphics.newImage("RECEPTORS/ReceptorRight.png"),
                ["Up"] = love.graphics.newImage("RECEPTORS/ReceptorUp.png"),
            },
            ["7K"] = {
                ["Left1"] = love.graphics.newImage("RECEPTORS/ReceptorLeft.png"),
                ["Down"] = love.graphics.newImage("RECEPTORS/ReceptorDown.png"),
                ["Right1"] = love.graphics.newImage("RECEPTORS/ReceptorRight.png"),
                ["Center"] = love.graphics.newImage("RECEPTORS/ReceptorUp.png"),
                ["Left2"] = love.graphics.newImage("RECEPTORS/ReceptorLeft.png"),
                ["Up"] = love.graphics.newImage("RECEPTORS/ReceptorUp.png"),
                ["Right2"] = love.graphics.newImage("RECEPTORS/ReceptorRight.png"),
            }
        },
        Down = {
            ["4K"] = {
                ["Left"] = love.graphics.newImage("RECEPTORS/ReceptorPressedLeft.png"),
                ["Down"] = love.graphics.newImage("RECEPTORS/ReceptorPressedDown.png"),
                ["Right"] = love.graphics.newImage("RECEPTORS/ReceptorPressedRight.png"),
                ["Up"] = love.graphics.newImage("RECEPTORS/ReceptorPressedUp.png"),
            },
            ["7K"] = {
                ["Left1"] = love.graphics.newImage("RECEPTORS/ReceptorPressedLeft.png"),
                ["Down"] = love.graphics.newImage("RECEPTORS/ReceptorPressedDown.png"),
                ["Right1"] = love.graphics.newImage("RECEPTORS/ReceptorPressedRight.png"),
                ["Center"] = love.graphics.newImage("RECEPTORS/ReceptorPressedUp.png"),
                ["Left2"] = love.graphics.newImage("RECEPTORS/ReceptorPressedLeft.png"),
                ["Up"] = love.graphics.newImage("RECEPTORS/ReceptorPressedUp.png"),
                ["Right2"] = love.graphics.newImage("RECEPTORS/ReceptorPressedRight.png"),
            }
        }
    },

    Judgements = {
        ["Perfect"] = love.graphics.newImage("JUDGEMENTS/perfect.png"),
        ["Great"] = love.graphics.newImage("JUDGEMENTS/great.png"),
        ["Good"] = love.graphics.newImage("JUDGEMENTS/good.png"),
        ["Alright"] = love.graphics.newImage("JUDGEMENTS/alright.png"),
        ["Awful"] = love.graphics.newImage("JUDGEMENTS/awful.png"),
        ["Miss"] = love.graphics.newImage("JUDGEMENTS/miss.png"),
    },

    Particles = {
        ["Note Splash"] = love.graphics.newImage("PARTICLES/circle.png"),
        ["Combo Alert"] = love.graphics.newImage("PARTICLES/the  o r b.png"),
        ["Health Particle"] = love.graphics.newImage("PARTICLES/lightDot.png"),
    },

    Menu = {
        ["Main Logo"] = love.graphics.newImage("MENU/main logo.png"),
        ["H"] = love.graphics.newImage("MENU/H.png"),
        ["Icon Logo"] = love.graphics.newImage("MENU/logoH.png"),
        ["Loading Spinner"] = love.graphics.newImage("MENU/logoH.png"),
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
