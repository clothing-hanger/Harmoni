local Judgement = Class:extend()

function Judgement:new()
    self.x = Skin.Params["Judgement X Offset"]
    self.y = Skin.Params["Judgement Y Offset"]
    self.image = Skin.Judgements["Marvelous"]
    self.alpha = {0}
    self.r = 0
    self.size = Skin.Params["Judgement Size"]
    self.animationValues = {w = 0, h = 0, x = 0, y = 0}
end

function Judgement:update(dt)
end

function Judgement:judge(judgement)
    print("FDHIAJFJIHDJHIFKD")
    self.alpha = {1}
    self.image = Skin.Judgements[judgement]
    self.animationValues = {w = 0, h = 0, x = 0, y = 0}
    if self.tween then Timer.cancel(self.tween) end
    self.tween = Timer.tween(0.25, self.animationValues, {y = -15, w = 0.05, h = 0.05}, "out-back", function ()
        Timer.tween(0.25, self.animationValues, {y = 15, w = 0.05, h = 0.05}, "out-quad")
        Timer.tween(0.15, self.alpha, {0}, "out-quad")
    end)
end

function Judgement:draw()
    love.graphics.translate(Inits.WindowWidth/2, Inits.WindowHeight/2)
    love.graphics.setColor(1, 1, 1, self.alpha[1])
    love.graphics.draw(self.image, self.x + self.animationValues.x, self.y + self.animationValues.y, self.r, Skin.Params["Judgement Size"] + self.animationValues.w, Skin.Params["Judgement Size"] + self.animationValues.h, self.image:getWidth()/2, self.image:getHeight()/2)
end

function Judgement:release()
end

return Judgement