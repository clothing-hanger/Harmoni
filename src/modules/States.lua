return {
    menu = {
        titleScreen = require("states.menu.titleScreen"),
        songSelect = require("states.menu.songSelect"),
        gameTransition = require("states.menu.gameTransition"),
        jukebox = require("states.menu.Jukebox"),
        settingsMenu = require("states.menu.settingsMenu"),
        preloadState = require("states.menu.preloadState"),
    },
    game = {
        gameModeManager = require("states.game.gameModeManager"),
        resultsState = require("States.Game.resultsState")
    },
}