local bob = Class:extend("bobSongSelect")
local dt



--[[
THIS IS NOT A REAL GAME FEATURE LOL!!!!
as development goes on i am gonna add one of those stupid ass "SpoOSkY hAUnteD GamE" thingies to harmoni
but instead of it being scary, its just a chill dude
he HATES music tho so being in a rhythm game is hell

DEVELOPMENT WILL NOT FOCUS MUCH ON THIS,,, BUT 
it will be a whole ass mode 💀💀 bob mode 💀💀💀 its a joke mode obviously and its gonna be hidden
idk how it will be unlocked yet or anything OR EVEN IF WE KEEP HIM (but i already love bob so we are keeping him)
BUT development will kinda (not really "kinda" actually, thats why i said huge turn in the server) have to change from now on with bob mode in mind, 
meaning maayybbe we are gonna have to redo some shit to let bob work better with it

AGAIN, BOB MODE WILL BE A HIDDEN UNLOCKABLE, BOB WILL NOT BE ENABLED BY DEFAULT AND BOB IS NOT SUPPOSED TO TAKEN SERIOUSLY

with bob mode enabled he just kinda does shit, stuff that does mess with the game a lot tho (we gotta figure out what that stuff is cuz IDFK lol)
bob will be fucking awesome though, and he absolutely WILL be shown on the steam page and shit and he WILL be a big (and mostly unseen) part of harmoni
]]

-- you WILL love bob.
function bob:new(x,y,spooked,scared,terrified,tooclose,cursor)
    self.x,self.y = x,y
    self.spooked = spooked or 2000
    self.scared = scared or 1000
    self.terrified = terrified or 100
    self.tooClose = tooclose or 10
    self.mood = "Idle"
    self.distance = 9999999999999 -- big ass number so bob doesnt freak tf out on frame 1


    self.moodTable = {
    {name = "Panic", distance = 2},
    {name = "Too Close", distance = self.tooClose},
    {name = "Terrified", distance = self.terrified},
    {name = "Scared", distance = self.scared},
    {name = "Spooked", distance = self.spooked},
    {name = "Idle", distance = 99999999},
    }
end

function bob:update()
     dt = love.timer.getDelta()
    self.cursorX, self.cursorY = toCanvasCoords(Mouse.x, Mouse.y)
    self.distance = getDistance(self.cursorX, self.cursorY, self.x, self.y)
    self:updateMood()
end

function bob:updateMood()
    for i = 1,#self.moodTable do
        local moodDistance, moodName = self.moodTable[i].distance, self.moodTable[i].name
        if self.distance <= moodDistance then self.mood = moodName break end
    end

    if self.mood == "Idle" then self:idleFunc()
    elseif self.mood == "Spooked" then self:spookedFunc()
    elseif self.mood == "Scared" then self:scaredFunc()
    elseif self.mood == "Terrified" then self:terrifiedFunc()
    elseif self.mood == "Too Close" then self:tooCloseFunc()
    elseif self.mood == "Panic" then self:panicFunc()
    elseif self.mood == "Idle" then self:idleFun()
    end
end


function bob:idleFunc()
   printToConsole("i feel fine")
end

function bob:spookedFunc()
    self.spookTimer = self.spookTimer or 0
    self.spookTimer = self.spookTimer + dt

    if self.spookTimer > 5 then 
        love.window.showMessageBox("the bob :)", "your cursor kinda scares me,,\n can you please keep it away? sorry :((")
        self.spookTimer = 0
    end
end

function bob:scaredFunc()
    self.scareTimer = self.scareTimer or 0
    self.scareTimer = self.scareTimer + dt

    if self.scareTimer > 1 then 
        love.window.showMessageBox("the bob :/", "your cursor is scaring me :(\n please keep it away from me,,,\n im sorry :(")
        self.scareTimer = 0
    end
end

function bob:terrifiedFunc()
    self.terrifyTimer = self.terrifyTimer or 0
    self.terrifyTimer = self.terrifyTimer + dt

    if self.terrifyTimer > 0.5 then 
        love.window.showMessageBox("the bob :(", "please its really scaring me")
        self.terrifyTimer = 0
    end

end

function bob:tooCloseFunc()
    self.tooCloseTimer = self.tooCloseTimer or 0
    self.tooCloseTimer = self.tooCloseTimer + dt

    if self.tooCloseTimer > 1 then 
        love.window.showMessageBox("the bob :(", "Your cursor is too close")
        self.tooCloseTimer = 0
    end
end

function bob:panicFunc()
    error("your cursor scared me too much now i shit my pants FUCK YOU asshole")
end


function bob:shake(time,intensity)
    local sy,syp,syn,sx,sxp,sxn,frame
    frame = 0
    sx,sy = 0,0 -- we init these out here so the first shake does nothing
    syp,syn = sy,-sy
    sxp,sxn = sx,-sx
    Timer.during(time, function()
        frame = frame+1
        self.x = (frame == 1 and self.x+sxp) or (frame == 2 and self.x+sxn) or self.x -- we do the positive shake on frame 1 only, and negative on 2
        self.y = (frame == 1 and self.y+syp) or (frame == 2 and self.y+syn) or self.x  -- we do nothing here if frame is 3
        if frame == 3 then -- reset the shake values and reset frame counter on frame 3
            frame = 0
            sy = love.math.random(0,intensity)
            sx = love.math.random(0,intensity)
            syp,syn = sy,-sy
            sxp,sxn = sx,-sx
        end
    end)
end


function bob:draw()
    love.graphics.circle("fill", self.x, self.y, 30)
    love.graphics.draw(spongebirth, self.x, self.y,0, 1,1,spongebirth:getWidth()/2,spongebirth:getHeight()/2)
       -- love.graphics.circle("line", self.cursorX, self.cursorY, 30)

end


return bob