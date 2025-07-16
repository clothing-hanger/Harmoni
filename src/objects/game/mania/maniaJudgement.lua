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
            break
        end
    end

    if not image then return end -- no valid judgement image found, skip

    local w, h
    if image.getViewport then
        _, _, w, h = image:getViewport()
    else
        w, h = image:getWidth(), image:getHeight()
    end

    if self.noStacking then
        self.judgements = {{image = image, x = self.x, y = self.y, width = w, height = h, timer = 500, bumped = false}}
        return
    end

    table.insert(self.judgements, {image = image, x = self.x, y = self.y, width = w, height = h, timer = 500, bumped = false})
end


function maniaJudgement:judgementAnimation()
    local tweenType = SkinHandler:getParam("Judgement Bump Tween Type")
    for _, Judgement in ipairs(self.judgements) do
        if not Judgement.bumped then
            Judgement.bumped = true
            Timer.tween(
                SkinHandler:getParam("Judgement Bump Time"),
                Judgement,
                { y = Judgement.y + SkinHandler:getParam("Judgement Bump Amount") },
                tweenType
            )
        end
    end
end

function maniaJudgement:update(dt)
    self:judgementAnimation()
    for i = #self.judgements, 1, -1 do
        local Judgement = self.judgements[i]
        Judgement.timer = Judgement.timer - 1000 * dt
        if Judgement.timer <= 0 then
            table.remove(self.judgements, i)
        end
    end
end

function maniaJudgement:draw()
    for i, Judgement in ipairs(self.judgements) do
        local image = Judgement.image -- just in case

        if not image then goto continue end
        local x,y = Judgement.x, Judgement.y
        local size = self.size

        local judgementBatch = SkinHandler:getBatch("Judgements")
        local alpha = Judgement.timer/500

        local ox,oy

        if judgementBatch then
            local _, _, w, h = image:getViewport()
            ox, oy = w/2, h/2
        else
            ox, oy = image:getWidth()/2, image:getHeight()/2
        end

        if judgementBatch then
            local _, _, w, h = image:getViewport()
            if i == #self.judgements then
                judgementBatch:setColor(1,1,1, alpha)
            else
                judgementBatch:setColor(0.5,0.5,0.5, alpha)
            end
            judgementBatch:add(image, x, y, 0, size, size, ox, oy)
        else

            if i == #self.judgements then
                love.graphics.setColor(1,1,1, alpha)
            else
                love.graphics.setColor(0.5,0.5,0.5, alpha)
            end
            love.graphics.draw(image, x, y, 0, size, size, ox, oy)
        end
        ::continue::
    end
    love.graphics.setColor(1,1,1)
end

return maniaJudgement