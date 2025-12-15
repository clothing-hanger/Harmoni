return {
    menu = {
        titleScreen = require("states.menu.titleScreen"),
        songSelect = require("states.menu.songSelect"),
        gameTransition = require("states.menu.gameTransition"),
        jukebox = require("states.menu.Jukebox"),
        settingsMenu = require("states.menu.settingsMenu"),
        preloadState = require("states.menu.preloadState"),
        songPreloader = require("states.menu.songPreloader"),
        splash = require("states.menu.splash")
    },
    game = {
        gameModeManager = require("states.game.gameModeManager"),
        resultsState = require("states.game.resultsState"),
        sand = require("states.game.sand")
    },
    extra = {
        america = require("states.extra.america")
    }
}