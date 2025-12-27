local markus = State("markus")

function markus:enter()
    self.images = {
        ["markus color"] = love.graphics.newImage("images/markus/color.png"),
        ["markus black and white"] = love.graphics.newImage("images/markus/blackandwhite.png"),
        ["cam"] = love.graphics.newImage("images/markus/cam.png")
    }
    self.alphas = {
        ["markus color"] = 1,
        ["cam"] = 0
    }

    self:tweenAlphas()
end

function markus:tweenAlphas()
    Timer.after(0.5, function()
        Timer.tween(3, self.alphas, {["markus color"] = 0}, "linear", function()
                Timer.tween(3, self.alphas, {["cam"] = 1}, "linear")
        end)
    end)
end


function markus:update(dt)
end

function markus:draw()
    -- draw the black and white first
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.images["markus black and white"])

    -- now the colored one
    love.graphics.setColor(1,1,1,self.alphas["markus color"])
    love.graphics.draw(self.images["markus color"])

    -- now cam last
    love.graphics.setColor(1,1,1,self.alphas["cam"])

    love.graphics.draw(self.images["cam"])

    love.graphics.setColor(1,1,1,1)

end

return markus