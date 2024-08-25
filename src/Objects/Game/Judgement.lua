---@class Judgement
local Judgement = Class:extend()

function Judgement:new()
    self.judgements = {}
end

function Judgement:judge(judgement)
    if 1 == 1 then return end


    local newJudgement = {
        x = Skin.Params["Judgement X Offset"],
        y = Skin.Params["Judgement Y Offset"],
        image = Skin.Judgements[judgement],
        judgement = judgement,
        alpha = {1},
        r = 0,
        animationValues = {w = 0, h = 0, x = 0, y = 0}
    }
    

    local fallTime = 0.25
    local fallAmount = 25
    local fadeTime = 0.5
    local jumpTime = 0.25
    if judgement == "Miss" then 
        newJudgement.r = love.math.random(-50,50)
        fadeTime = 0.5
        fallAmount = 150
        fallTime = 0.5
        jumpTime = 0
    end
    table.insert(self.judgements, 1, newJudgement)  -- Insert the new judgement at the front

    Timer.tween(jumpTime, newJudgement.animationValues, {y = -15, w = 0.05, h = 0.05}, "out-back", function()
        Timer.tween(fallTime, newJudgement.animationValues, {y = fallAmount, w = 0.05, h = 0.05}, "out-quad")
        Timer.tween(fadeTime, newJudgement.alpha, {0}, "out-quad", function()
            for i, j in ipairs(self.judgements) do
                if j == newJudgement then
                    table.remove(self.judgements, i)
                    break
                end
            end
        end)
    end)
end

function Judgement:update(dt)
end

function Judgement:draw()
    love.graphics.translate(Inits.GameWidth/2, Inits.GameHeight/2)
    for i, judgement in ipairs(self.judgements) do
        local alphaModifier = 1 - (i - 1) * 0.6  -- Decrease alpha for older judgements
        local effectiveAlpha = judgement.alpha[1] * math.max(alphaModifier, 0.1)  -- Ensure it doesn't go below a certain level
        if judgement.judgement == "Miss" then
            effectiveAlpha = judgement.alpha[1] * 2
        end
        love.graphics.setColor(1, 1, 1, effectiveAlpha)
        love.graphics.draw(
            judgement.image, 
            judgement.x + judgement.animationValues.x, 
            judgement.y + judgement.animationValues.y, 
            math.rad(judgement.r), 
            Skin.Params["Judgement Size"] + judgement.animationValues.w, 
            Skin.Params["Judgement Size"] + judgement.animationValues.h, 
            judgement.image:getWidth()/2, 
            judgement.image:getHeight()/2
        )
    end
    love.graphics.translate(-Inits.GameWidth/2, -Inits.GameHeight/2)
    love.graphics.setColor(1,1,1)
end

function Judgement:release()
end

return Judgement
