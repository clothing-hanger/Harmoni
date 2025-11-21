HarmoniVersion = "R-0.2.0"
function love.conf(t)
    local debug = true
    t.console = true
    t.window.title = "Harmoni V." .. HarmoniVersion
    t.identity = "Harmoni Rewrite 0.2.0"  -- we gotta change this eventually. why did i even think putting the version number in identity was a good idea 
    t.window.width =  1280 
    t.window.height = 720
    t.window.resizable = true
    t.window.highdpi = true
    t.window.msaa = 8
    t.window.vsync = 0

    t.modules.physics = false

    if debug then 
        t.window.title = "Harmoni " .. HarmoniVersion .. " |  LÖVE Version " .. (love.getVersion() or "UNKNOWN (how is this possible?")
                                                                                            -- I made this conf.lua when love12 didn't have a codename
                                                                                            -- idk how it ended up like this though? idk
    end
end