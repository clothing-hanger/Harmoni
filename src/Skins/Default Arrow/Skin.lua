---@diagnostic disable: undefined-global
---@
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
        ["HUD Large"] = newFont("FONTS/Novamono-njdg.ttf", 65),
        ["HUD Small"] = newFont("FONTS/Novamono-njdg.ttf", 15),
        ["HUD Extra Small"] = newFont("FONTS/Novamono-njdg.ttf", 12),
        ["Combo"] = newFont("FONTS/SourceCodePro-Medium.ttf", 65),
        ["Menu Large"] = newFont("FONTS/SourceCodePro-Medium.ttf", 25),
        ["Menu Small"] = newFont("FONTS/SourceCodePro-Medium.ttf", 15),
        ["Menu Extra Small"] = newFont("FONTS/SourceCodePro-Medium.ttf", 12),
        ["Judgement Counter"] = newFont("FONTS/Novamono-njdg.ttf", 60)
    },

    Notes = {
        ["4K"] = {
            ["Left"] = newImage("NOTES/NoteLeft.png"),
            ["Down"] = newImage("NOTES/NoteDown.png"),
            ["Right"] = newImage("NOTES/NoteRight.png"),
            ["Up"] = newImage("NOTES/NoteUp.png"),
        },
        ["7K"] = {
            ["Left1"] = newImage("NOTES/NoteLeft.png"),
            ["Down"] = newImage("NOTES/NoteDown.png"),
            ["Left2"] = newImage("NOTES/NoteLeft.png"),
            ["Center"] = newImage("NOTES/NoteUp.png"),
            ["Right1"] = newImage("NOTES/NoteRight.png"),
            ["Up"] = newImage("NOTES/NoteUp.png"),
            ["Right2"] = newImage("NOTES/NoteRight.png"),
        }
    },

    HoldNotes = {
        ["4K"] = {
            ["Left"] = newImage("NOTES/NoteLeftTrail.png"),
            ["Down"] = newImage("NOTES/NoteDownTrail.png"),
            ["Right"] = newImage("NOTES/NoteRightTrail.png"),
            ["Up"] = newImage("NOTES/NoteUpTrail.png"),
        },
        ["7K"] = {
            ["Left1"] = newImage("NOTES/NoteLeftTrail.png"),
            ["Down"] = newImage("NOTES/NoteDownTrail.png"),
            ["Right1"] = newImage("NOTES/NoteRightTrail.png"),
            ["Center"] = newImage("NOTES/NoteUpTrail.png"),
            ["Left2"] = newImage("NOTES/NoteLeftTrail.png"),
            ["Up"] = newImage("NOTES/NoteUpTrail.png"),
            ["Right2"] = newImage("NOTES/NoteRightTrail.png"),
        }
    },

    HoldEndNotes = {
        ["4K"] = {
            ["Left"] = newImage("NOTES/NoteLeftTrail.png"),
            ["Down"] = newImage("NOTES/NoteDownTrail.png"),
            ["Right"] = newImage("NOTES/NoteRightTrail.png"),
            ["Up"] = newImage("NOTES/NoteUpTrail.png"),
        },
        ["7K"] = {
            ["Left1"] = newImage("NOTES/NoteLeftTrail.png"),
            ["Down"] = newImage("NOTES/NoteDownTrail.png"),
            ["Right1"] = newImage("NOTES/NoteRightTrail.png"),
            ["Center"] = newImage("NOTES/NoteUpTrail.png"),
            ["Left2"] = newImage("NOTES/NoteLeftTrail.png"),
            ["Up"] = newImage("NOTES/NoteUpTrail.png"),
            ["Right2"] = newImage("NOTES/NoteRightTrail.png"),
        }
    },

    Receptors = {
        Up = {
            ["4K"] = {
                ["Left"] = newImage("RECEPTORS/ReceptorLeft.png"),
                ["Down"] = newImage("RECEPTORS/ReceptorDown.png"),
                ["Right"] = newImage("RECEPTORS/ReceptorRight.png"),
                ["Up"] = newImage("RECEPTORS/ReceptorUp.png"),
            },
            ["7K"] = {
                ["Left1"] = newImage("RECEPTORS/ReceptorLeft.png"),
                ["Down"] = newImage("RECEPTORS/ReceptorDown.png"),
                ["Right1"] = newImage("RECEPTORS/ReceptorRight.png"),
                ["Center"] = newImage("RECEPTORS/ReceptorUp.png"),
                ["Left2"] = newImage("RECEPTORS/ReceptorLeft.png"),
                ["Up"] = newImage("RECEPTORS/ReceptorUp.png"),
                ["Right2"] = newImage("RECEPTORS/ReceptorRight.png"),
            }
        },
        Down = {
            ["4K"] = {
                ["Left"] = newImage("RECEPTORS/ReceptorPressedLeft.png"),
                ["Down"] = newImage("RECEPTORS/ReceptorPressedDown.png"),
                ["Right"] = newImage("RECEPTORS/ReceptorPressedRight.png"),
                ["Up"] = newImage("RECEPTORS/ReceptorPressedUp.png"),
            },
            ["7K"] = {
                ["Left1"] = newImage("RECEPTORS/ReceptorPressedLeft.png"),
                ["Down"] = newImage("RECEPTORS/ReceptorPressedDown.png"),
                ["Right1"] = newImage("RECEPTORS/ReceptorPressedRight.png"),
                ["Center"] = newImage("RECEPTORS/ReceptorPressedUp.png"),
                ["Left2"] = newImage("RECEPTORS/ReceptorPressedLeft.png"),
                ["Up"] = newImage("RECEPTORS/ReceptorPressedUp.png"),
                ["Right2"] = newImage("RECEPTORS/ReceptorPressedRight.png"),
            }
        }
    },

    Judgements = {
        ["Perfect"] = newImage("JUDGEMENTS/perfect.png"),
        ["Great"] = newImage("JUDGEMENTS/great.png"),
        ["Good"] = newImage("JUDGEMENTS/good.png"),
        ["Alright"] = newImage("JUDGEMENTS/alright.png"),
        ["Awful"] = newImage("JUDGEMENTS/awful.png"),
        ["Miss"] = newImage("JUDGEMENTS/miss.png"),
    },

    Particles = {
        ["Note Splash"] = newImage("PARTICLES/circle.png"),
        ["Combo Alert"] = newImage("PARTICLES/the  o r b.png"),
        ["Health Particle"] = newImage("PARTICLES/lightDot.png"),
    },

    Menu = {
        ["Main Logo"] = newImage("MENU/main logo.png"),
        ["H"] = newImage("MENU/H.png"),
        ["Icon Logo"] = newImage("MENU/logoH.png"),
        ["Loading Spinner"] = newImage("MENU/logoH.png"),
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
