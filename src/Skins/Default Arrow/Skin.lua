
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
    ["Hit Error Meter Width"] = 150,              -- how wide the hit error graph is
    ["Hit Error Meter Solid"] = false,            -- if true, the graph will be made of colored rectangles to show where the judgment windows are, hits will be black, if false, the only visible part of the graph will be the hits, and they will be colored as the color of the judgmement they are
    ["Hit Error Meter Fade"] = 1000,              -- how long in milliseconds a hit will take to fade from the hit error graph
    ["Note Underlay Color"] = rgb {0, 0, 0},
    ["Health Bar X"] = 350,                       -- X position of the health bar
    ["Health Bar Y"] = 300,                       -- Y position of the health bar
    ["Health Bar Height"] = 700,                  -- Height of the health bar
    ["Health Bar Width"] = 15,                    -- Width of the health bar
    ["Health Bar Direction"] = "vertical",        -- Direction of the health bar (vertical, horizontal)
    ["Marvelous Color"] = rgb {0, 213, 255},      -- color of marvelous (used for judgment display and hit error graph)
    ["Perfect Color"] = rgb {0,  0, 225},         -- color of perfect
    ["Great Color"] = rgb {0, 255, 81},           -- color of great
    ["Good Color"] = rgb {0, 153, 81},            -- color of good
    ["Okay Color"] = rgb {210, 13, 81},           -- color of okay
    ["Miss Color"] = rgb {209, 0, 0},             -- color of miss
}

Skin.Fonts = {
    ["HUD Large"] = newFont("FONTS/Novamono-njdg.ttf", 65),
    ["HUD Small"] = newFont("FONTS/Novamono-njdg.ttf", 15),
    ["HUD Extra Small"] = newFont("FONTS/Novamono-njdg.ttf", 12),
    ["Combo"] = newFont("FONTS/Novamono-njdg.ttf", 35),
    ["Menu Large"] = newFont("FONTS/SourceCodePro-Medium.ttf", 25),
    ["Menu Small"] = newFont("FONTS/SourceCodePro-Medium.ttf", 15),
    ["Menu Extra Small"] = newFont("FONTS/SourceCodePro-Medium.ttf", 12),
}

Skin.Notes = {
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
}

Skin.HoldNotes = {
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
}

Skin.HoldEndNotes = {
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
}

Skin.Receptors = {
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
}

Skin.Judgements = {
    ["Marvelous"] = newImage("JUDGEMENTS/Marvelous.png"),
    ["Perfect"] = newImage("JUDGEMENTS/Perfect.png"),
    ["Great"] = newImage("JUDGEMENTS/Great.png"),
    ["Good"] = newImage("JUDGEMENTS/Good.png"),
    ["Okay"] = newImage("JUDGEMENTS/Okay.png"),
    ["Miss"] = newImage("JUDGEMENTS/Miss.png"),
}

Skin.Particles = {
    ["Note Splash"] = newImage("PARTICLES/circle.png"),
    ["Combo Alert"] = newImage("PARTICLES/eclipse.png"),
}

Skin.Menu = {
    ["Main Logo"] = newImage("Menu/main logo.png"),
    ["H"] = newImage("Menu/H.png"),
    ["Icon Logo"]  = newImage("Menu/logoH.png"),
    ["Loading Spinner"] = newImage("MENU/logoH.png"),
}

Skin.Sounds = {
    ["First Miss"] = nil,  -- miss sound, exclusive to the first miss
    ["Miss"] = nil,        -- general miss sound
    ["Menu Scroll"] = nil, --sound for scrolling (you should use a quick click for this)
    ["Hit Sound"] = nil,   -- sound for hitting notes
    ["Tap Sound"] = nil,   -- sound for tapping keys, but not hitting notes
}

