local HitErrorMeter = Class:extend()
local hits

function HitErrorMeter:new()
    self.x, self.y = Skin.Params["Hit Error Meter X"], Skin.Params["Hit Error Meter Y"]
    self.width, self.height = Skin.Params["Hit Error Meter Width"], Skin.Params["Hit Error Meter Height"]
    self.solid = Skin.Params["Hit Error Meter Solid"]
    self.fadeTime = Skin.Params["Hit Error Meter Fade"]
    hits = {}

end

function HitErrorMeter:update(dt)

end

function HitErrorMeter:addHit(noteTime)
    table.insert(hits, {noteTime, 500})
end

function HitErrorMeter:draw()
    love.graphics.translate(Inits.WindowWidth/2, Inits.WindowHeight/2)
    love.graphics.setColor(1,1,1)
    for i = 1,#hits do
        love.graphics.rectangle("fill", hits[i][1], self.y, 5, self.height)
    end

    love.graphics.rectangle("fill", 0, 0, 10, 10)

    love.graphics.translate(-Inits.WindowWidth/2, -Inits.WindowHeight/2)
end

function HitErrorMeter:release()

end

return HitErrorMeter