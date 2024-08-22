Inits = require("inits")
utf8 = require("utf8")
love.filesystem.createDirectory("Music")
love.filesystem.createDirectory("Settings")

function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0

	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then dt = love.timer.step() end

		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())

			if love.draw then love.draw() end

			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.001) end
	end
end


love.audio.setVolume(0.15)

function toGameScreen(x, y)
    -- converts a position to the game screen
    local ratio = 1
    ratio = math.min(Inits.WindowWidth/Inits.GameWidth, Inits.WindowHeight/Inits.GameHeight)
    local x, y = x - Inits.WindowWidth/2, y - Inits.WindowHeight/2
    x, y = x / ratio, y / ratio
    x, y = x + Inits.GameWidth/2, y + Inits.GameHeight/2

    return x, y
end

function love.load()
    -- Setup Libraries
    require("Modules.Controls") -- this goes with other libs since it inits a lib
    Class = require("Libraries.Class")
    State = require("Libraries.State")
    Tinyyaml = require("Libraries.Tinyyaml")
    Timer = require("Libraries.Timer")
    GameScreen = love.graphics.newCanvas(Inits.GameWidth, Inits.GameHeight)

    -- Initialize Game
    States = require("Modules.States")
    Shaders = require("Modules.Shaders")
    Objects = require("Modules.Objects")
    require("Modules.Math")
    require("Modules.String")
    require("Modules.RGB")
    require("Modules.MusicTime")
    require("Modules.TableToFile")
    require("Modules.Settings")
    require("Modules.Parse")
    require("Modules.Debug")
    require("Modules.Judgements")
    require("Modules.Grades")
    require("Modules.DifficultyCalculator")
    require("Modules.Cursor")

    loadSettings()
    defaultFont = love.graphics.newFont(12)

    State.switch(States.Misc.PreLoader)
    require("TEMP/setup shit")
    debugInit()

end

function love.update(dt)
    cursorText = nil
    if not console.isOpen then Input:update() end
    State.update(dt)
    Timer.update(dt)
    updateCursor(dt)
    debugUpdate(dt)

    mouseTimer = (mouseTimer and mouseTimer - 1000*dt) or 1000
end

function love.wheelmoved(x,y)
    State.wheelmoved(y)
end

function love.mousemoved()
    mouseTimer = 1000
end

function love.textinput(text)
    if console.isOpen then consoleTextinpput(text) end
end

function love.keypressed(key)
    if console.isOpen then
        consoleKeypressed(key)
    end
    if key == "f1" then
        console.isOpen = not console.isOpen
    end
end

function love.draw()
    love.graphics.push()
        love.graphics.setCanvas(GameScreen)
            love.graphics.clear(0,0,0,1)
            State.draw()
        love.graphics.setCanvas()
    love.graphics.pop()

    -- ratio
    local ratio = 1
    ratio = math.min(Inits.WindowWidth/Inits.GameWidth, Inits.WindowHeight/Inits.GameHeight)
    love.graphics.setColor(1,1,1,1)
    -- draw game screen with the calculated ratio and center it on the screen
    love.graphics.setShader(Shaders.CurrentShader)
    love.graphics.draw(GameScreen, Inits.WindowWidth/2, Inits.WindowHeight/2, 0, ratio, ratio, Inits.GameWidth/2, Inits.GameHeight/2)
    cursorTextDraw()

    love.graphics.setShader()

    debugDraw()
end

function love.resize(w, h)
    Inits.WindowWidth = w
    Inits.WindowHeight = h
  
end

function love.quit()

end