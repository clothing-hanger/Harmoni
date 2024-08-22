function setupControls()
    Input = (require("Libraries.Baton")).new({
        controls = {
            menuUp = {"key:up"},
            menuDown = {"key:down"},
            menuRight = {"key:right"},
            menuLeft = {"key:left"},
            menuConfirm = {"key:return"},
            menuBack = {"key:escape"},

            menuClickLeft = {"mouse:1"},

            lane1 = {"key:" .. keyBinds4k[1]},
            lane2 = {"key:" .. keyBinds4k[2]},
            lane3 = {"key:" .. keyBinds4k[3]},
            lane4 = {"key:" .. keyBinds4k[4]},


            debugConsoleToggle = {"key:`"}
        }
    })
end