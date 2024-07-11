debugMode = true  

function love.conf(t)
    t.window.title = "Harmoni"
    t.identity = "harmoni"
    t.window.width = 1280
    t.window.height = 720
    t.window.vsync = false
    t.window.resizable = true
    if debugMode then
        t.console = true
    end
end  