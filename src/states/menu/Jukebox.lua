local jukebox = State("jukebox")

function jukebox:enter()
    State.switch(States.menu.titleScreen)
end

function jukebox:update(dt)
end

function jukebox:draw()
end

return jukebox