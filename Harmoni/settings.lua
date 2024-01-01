--[[ YOU MUST RESTART HARMONI FOR ANY CHANGED TO TAKE EFFECT ]]

--[[ WINDOW SETTINGS ]]--
startFullscreen = false      -- start in fullscreen (press f11 to toggle)

--[[ SOUND SETTINGS ]]--
defaultVolume = 100      -- default volume percent

--[[ MENU SETTINGS ]]--
menuSongDelayTime = 0.2  -- time to delay song loading when its the current selected song 
--(do not set to 0 or you will have terrible performance) (higher will yeild better performance at the cost of loading times)

--[[ GAMEPLAY SETTINGS ]]--
downScroll = false                -- pretty obvious  (still slightly unfinished, the ui still is designed around upscroll)
speed = 1.6                      -- scroll speed
LaneWidth = 120                   -- how far apart the lanes are (120 has the receptors and notes touching)
backgroundDimSetting = 0.9      -- how dim the background is during gameplay (0 for least dim, 1 for most dim)
BotPlay = false                   -- also pretty obvious  (is stupid sometimes and doesnt hit notes perfectly (and sometimes (rarely) it even misses lmao))
verticalNoteOffset = 10            -- how far away from the top of the screen (or bottom if you use downscroll) the receptors are

--[[ ADVANCED SETTINGS ]]
speed1 = speed  -- leave these all set to speed unless you want the lanes to have different scroll speeds 
speed2 = speed  -- (idk why you would want that but you can do it lmfao)
speed3 = speed
speed4 = speed

disablePrint = true  -- disables the print function (only used for debugging, if you wanna see what this does, set this to false and set t.console to true in conf.lua)
debugOverlay = "NONE"   -- set to "FPS" for FPS viewer, "RAM" for ram usage viewer, or "BOTH" for both
enableSongSearch = false -- press TAB in song select to search
--NOTE- (extremely unfinished, you literally cant start a song after searching, 
--and can never access the full song list after searching, and causes the song select state to be very prone to crashing)



-- DONT TOUCH BELOW THIS!! (unless you just wanna fuck with it i guess)

if downScroll then
    speed = -speed
    speed1 = -speed1
    speed2 = -speed2
    speed3 = -speed3
    speed4 = -speed4
end
if startFullscreen then
    isFullscreen = not isFullscreen
    love.window.setFullscreen(isFullscreen, "exclusive")
end
volume = defaultVolume/100






