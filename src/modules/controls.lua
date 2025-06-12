function setupControls()
    return (require("engine.lib.Baton")).new({
        controls = {
            menuUp = {"key:up", "button:dpup"},
            menuDown = {"key:down", "button:dpdown"},
            menuRight = {"key:right", "button:dpright"},
            menuLeft = {"key:left", "button:dpleft"},
            menuConfirm = {"key:return", "button:a"},
            menuBack = {"key:escape", "button:b"},

            menuClickLeft = {"mouse:1"},

            lane14K = {"key:d"},
            lane24K = {"key:f"},
            lane34K = {"key:j"},
            lane44K = {"key:k"},

            debugConsoleToggle = {"key:`"}
        },
        joystick = love.joystick.getJoysticks()[1]
    })
end