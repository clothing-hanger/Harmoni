function setupControls()
    return (require("Libraries.Baton")).new({
        controls = {
            menuUp = {"key:up"},
            menuDown = {"key:down"},
            menuRight = {"key:right"},
            menuLeft = {"key:left"},
            menuConfirm = {"key:return"},
            menuBack = {"key:escape"},

            menuClickLeft = {"mouse:1"},

            lane14K = {"key:" .. keyBinds4k[1]},
            lane24K = {"key:" .. keyBinds4k[2]},
            lane34K = {"key:" .. keyBinds4k[3]},
            lane44K = {"key:" .. keyBinds4k[4]},

            lane17K = {"key:" .. keyBinds7k[1]},
            lane27K = {"key:" .. keyBinds7k[2]},
            lane37K = {"key:" .. keyBinds7k[3]},
            lane47K = {"key:" .. keyBinds7k[4]},
            lane57K = {"key:" .. keyBinds7k[5]},
            lane67K = {"key:" .. keyBinds7k[6]},
            lane77K = {"key:" .. keyBinds7k[7]},

            debugConsoleToggle = {"key:`"}
        }
    })
end