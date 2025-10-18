function love.conf(t)
    local debug = false
    t.console = true
    t.window.title = "Harmoni Rewrite 0.2.0"
    t.identity = "Harmoni Rewrite 0.2.0"
    t.window.width =  1280 
    t.window.height = 720
    t.window.resizable = true
    t.window.highdpi = true
    t.window.msaa = 8
    t.window.vsync = 0

    t.modules.physics = false

    if debug then 
        t.window.title = "Harmoni Rewrite 0.2.0  |   LÖVE Version " .. (love.getVersion() or "UNKNOWN (how is this possible?")
                                                                                            -- I made this conf.lua when love12 didn't have a codename
                                                                                            -- idk how it ended up like this though? idk
    end
end