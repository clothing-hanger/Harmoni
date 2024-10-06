---@class HealthBar
local HealthBar = Class:extend()
local tween

function HealthBar:new()
    self.x = Skin.Params["Health Bar X"]
    self.y = Skin.Params["Health Bar Y"]
    self.width = Skin.Params["Health Bar Width"]
    self.height = Skin.Params["Health Bar Height"]
    printableHealth = {health}
end

function HealthBar:update(dt)
    health = clamp(health, 0, 1)

    if health > 0.9 then
        health = health - 0.3*dt
    end

    if tween then Timer.cancel(tween) end
    tween = Timer.tween(0.1, printableHealth, {health-0.001}, "out-quad")

    if printableHealth[1] <= 0 then
        States.Game.PlayState:gameOver()
    end

    if health >= 0.9 then
        Objects.Game.HealthParticle:emit()
    end
end

function  HealthBar:draw()
    love.graphics.translate(Inits.GameWidth/2, Inits.GameHeight/2)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill", self.x, self.y, self.width, -(self.height*printableHealth[1]))
    love.graphics.translate(-Inits.GameWidth/2, -Inits.GameHeight/2)
end

function HealthBar:release()
end

return HealthBar