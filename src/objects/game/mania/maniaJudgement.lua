local maniaJudgement = Class:extend("maniaJudgement")

function maniaJudgement:new(x,y,size,judgementsTable,parent)
    self.parent = parent
    self.x = x or 0
    self.y = y or 0
    self.size = size or 1
    self.judgementsTable = judgementsTable or (error("fucking dumbass how do you think the judgements object will work without judgements"))
    self.judgements = {}

    self.noStacking = false
end

function maniaJudgement:judge(judgement)
    local image
    for i = 1,#self.judgementsTable do
        if judgement == self.judgementsTable[i].name then
            image = self.judgementsTable[i].image
        end
    end

    if self.noStacking then
        self.judgements = {{image = image, x = self.x, y = self.y, width = self.width, height = self.height, timer = 500, bumped = false}}
        return
    end

    table.insert(self.judgements, {image = image, x = self.x, y = self.y, width = self.width, height = self.height, timer = 500, bumped = false})

    return 
end

function maniaJudgement:judgementAnimation()
    local judgeTween
    for i, Judgement in ipairs(self.judgements) do
        if not Judgement.bumped then
            Judgement.bumped = true
            if judgeTween then Timer.cancel(judgeTween) end
            judgeTween = Timer.tween(Skin.Params["Judgement Bump Time"], Judgement, {y = Judgement.y+Skin.Params["Judgement Bump Amount"]}, Skin.Params["Judgement Bump Tween Type"])
        end
    end
end

function maniaJudgement:update(dt)
    self:judgementAnimation()
    for i, Judgement in ipairs(self.judgements) do
        Judgement.timer = Judgement.timer - 1000*dt  -- remove the judgement when its timer runs out

        if Judgement.timer <= 0 then table.remove(self.judgements, i) break end
    end
end

function maniaJudgement:draw()
    for i, Judgement in ipairs(self.judgements) do
        local image = Judgement.image -- just in case
        if not image then goto continue end
        local x,y = Judgement.x, Judgement.y
        local size = self.size
        
        local ox,oy = image:getWidth()/2, image:getHeight()/2
        local alpha = Judgement.timer/500
        if i == #self.judgements then
            love.graphics.setColor(1,1,1, alpha)

        else
            love.graphics.setColor(0.5,0.5,0.5, alpha)

        end

        love.graphics.draw(Judgement.image, Judgement.x, Judgement.y, 0, size, size, ox, oy)
        ::continue::
    end
    love.graphics.setColor(1,1,1)
   -- love.graphics.print("Judgement Table Length: " .. #self.judgements, 0, 50, nil, 10,10)
end

return maniaJudgement