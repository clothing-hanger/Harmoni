return {
    Game = {
        Note = require("Objects.Game.Note"),
        Receptor = require("Objects.Game.Receptor"),
        ScrollVelocity = require("Objects.Game.ScrollVelocity"),
        Judgement = require("Objects.Game.Judgement"),
        Background = require("Objects.Game.Background"),
        HUD = require("Objects.Game.HUD"),
        ComboAlert = require("Objects.Game.ComboAlert"),
        Combo = require("Objects.Game.Combo"),
        HitErrorMeter = require("Objects.Game.HitErrorMeter"),
        HealthBar = require("Objects.Game.HealthBar"),
    },
    Menu = {
        SongButton = require("Objects.Menu.SongButton"),
        DifficultyButton = require("Objects.Menu.DifficultyButton"),
        ModifiersMenu = require("Objects.Menu.ModifiersMenu"),
        ListMenu = require("Objects.Menu.ListMenu"),
    },
    Misc = {
        -- imagine being the Objects.Misc table lmao stupid ass empty useless fuck
    },
    UI = {
        Slider = require("Objects.UI.Slider"),
        Toggle = require("Objects.UI.Toggle"),
        Select = require("Objects.UI.Select"),
        TextBox = require("Objects.UI.TextBox"),
    },
}