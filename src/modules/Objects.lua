--game
    --mania
    maniaLane = require("objects.game.mania.maniaLane")
    maniaNote = require("objects.game.mania.maniaNote")
    maniaPlayField = require("objects.game.mania.maniaPlayField")
    maniaReceptor = require("objects.game.mania.maniaReceptor")
    maniaJudgement = require("objects.game.mania.maniaJudgement")
    maniaComboCount = require("objects.game.mania.maniaComboCount")
    maniaHealthBar = require("objects.game.mania.maniaHealthBar")
    maniaHUD = require("objects.game.mania.maniaHUD")

    --shared game thingies
    sharedBackground = require("objects.game.shared.sharedBackground")
    video = require("objects.game.shared.video")

    --menu
    menuSongButton = require("objects.menu.songButton")
    modifiersMenu = require("objects.menu.modifiersMenu")
        notificationsHandler = require("objects.menu.notificationsHandler")
        quickSettings = require("objects.menu.quickSettings")
        countdownBar = require("objects.menu.countdownBar")
    lyricsDisplay = require("Objects.Menu.lyricsDisplay")
    jukeboxSongButton = require("Objects.Menu.jukeboxSongButton")

    --UI
    UIsquiglyLine = require("objects.UI.UIsquiglyLine")  -- UIslop
    cursor = require("objects.UI.cursor")
    SMWCloudThingyAnimation = require("objects.UI.notGivingAwayWhatThisIs")
    UITimeRemaing = require("objects.UI.UITimeRemaining")
    toggle = require("objects.UI.toggle")
    buttonSlideOut = require("objects.UI.buttonSlideOut")
    notification = require("objects.UI.notification")
    UILayerWave = require("objects.UI.UILayerWave")  -- UIslop the fucking sequel 
    UISquigleCircle = require("objects.UI.UISquigleCircle")  -- i dont even need to say it again
    throbbert = require("objects.UI.throbbert")
    toggleSettings = require("objects.UI.toggleSettings")
    UIlogoH = require("objects.UI.logoH")