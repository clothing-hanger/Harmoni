---@diagnostic disable: undefined-global

Skin = {   -- i need to remove lots of these tbh..
    Params = {
        ["Note Size"] = 125,
        ["Hold Size"] = 125,
        ["HoldEnd Size"] = 125,
        ["Receptor Size"] = 125,

        ["Judgement Size"] = 1.5,
        ["Judgement Y Offset"] = getScreenCenter().y,
        ["Judgement X Offset"] = getScreenCenter().x-500,

        ["Combo Y Offset"] = getScreenCenter().y,
        ["Combo X Offset"] = getScreenCenter().x+500,
        ["Combo Format"] = "Full",
        ["Remove Combo Stack"] = true,

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
        ["Judgement Counter X"] = getScreenCenter().x - 210,
        ["Judgement Counter Y"] = getScreenCenter().y-150,

        ["Health Bar X Offset"] = getScreenCenter().x+650,
        ["Health Bar Y Offset"] = getScreenDimensions().height-100,
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
        ["Menu Extra Large"] = newFont("FONTS/astonpoliz.regular.ttf", 50),
        ["Menu Large"] = newFont("FONTS/astonpoliz.regular.ttf", 25),
        ["Menu Small"] = newFont("FONTS/astonpoliz.regular.ttf", 15),
        ["Menu Extra Small"] = newFont("FONTS/astonpoliz.regular.ttf", 12),
        ["Judgement Counter"] = newFont("FONTS/Novamono-njdg.ttf", 60),
    },

    Notes = {
        ["4K"] = {
            ["Left"] = newQuad("Arrows", 602, 0, 300, 300),
            ["Down"] = newQuad("Arrows", 301, 0, 300, 300),
            ["Right"] = newQuad("Arrows", 903, 0, 300, 300),
            ["Up"] = newQuad("Arrows", 0, 301, 300, 300),
        },
        ["7K"] = {
            ["Left1"] = newQuad("Arrows", 602, 0, 300, 300),
            ["Down"] = newQuad("Arrows", 301, 0, 300, 300),
            ["Right1"] = newQuad("Arrows", 903, 0, 300, 300),
            ["Center"] = newQuad("Arrows", 903, 0, 300, 300),
            ["Left2"] = newQuad("Arrows", 602, 0, 300, 300),
            ["Up"] = newQuad("Arrows", 0, 301, 300, 300),
            ["Right2"] = newQuad("Arrows", 903, 0, 300, 300),
        }
    },

    Receptors = {
        Up = {
            ["4K"] = {
                ["Left"] = newQuad("Arrows", 602, 301, 300, 300),
                ["Down"] = newQuad("Arrows", 301, 301, 300, 300),
                ["Right"] = newQuad("Arrows", 903, 602, 300, 300),
                ["Up"] = newQuad("Arrows", 301, 903, 300, 300),
            },
            ["7K"] = {
                ["Left1"] = newQuad("Arrows", 602, 301, 300, 300),
                ["Down"] = newQuad("Arrows", 301, 301, 300, 300),
                ["Right1"] = newQuad("Arrows", 903, 602, 300, 300),
                ["Center"] = newQuad("Arrows", 903, 602, 300, 300),
                ["Left2"] = newQuad("Arrows", 602, 301, 300, 300),
                ["Up"] = newQuad("Arrows", 301, 903, 300, 300),
                ["Right2"] = newQuad("Arrows", 903, 602, 300, 300),
            }
        },
        Down = {
            ["4K"] = {
                ["Left"] = newQuad("Arrows", 0, 602, 300, 300),
                ["Down"] = newQuad("Arrows", 903, 301, 300, 300),
                ["Up"] = newQuad("Arrows", 602, 602, 300, 300),
                ["Right"] = newQuad("Arrows", 301, 602, 300, 300),
            },
            ["7K"] = {
                ["Left1"] = newQuad("Arrows", 0, 602, 300, 300),
                ["Down"] = newQuad("Arrows", 903, 301, 300, 300),
                ["Right1"] = newQuad("Arrows", 602, 602, 300, 300),
                ["Center"] = newQuad("Arrows", 602, 602, 300, 300),
                ["Left2"] = newQuad("Arrows", 0, 602, 300, 300),
                ["Up"] = newQuad("Arrows", 903, 301, 300, 300),
                ["Right2"] = newQuad("Arrows", 602, 602, 300, 300),
            }
        }
    },

    Judgements = {
        ["Perfect"] = newQuad("Judgements", 0, 332, 349, 59),
        ["Great"] = newQuad("Judgements", 0, 272, 242, 59),
        ["Good"] = newQuad("Judgements", 0, 212, 335, 59),
        ["Alright"] = newQuad("Judgements", 0, 151, 209, 60),
        ["Awful"] = newQuad("Judgements", 0, 79, 295, 71),
        ["Miss"] = newQuad("Judgements", 0, 0, 237, 78),
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
