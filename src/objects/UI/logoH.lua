-- i swear theres a good reason this needs to be an object

local logoH = Class:extend("logoH")

function logoH:new(x,y,scale)
    self.image = SkinHandler:getImage("Menu", "H")
    self.x, self.y = x,y
    self.sx, self.sy = scale,scale
end

function logoH:update(dt)

end

function logoH:draw()
    local x,y = self.x,self.y
    local sx,sy = self.sx, self.sy
    local ox,oy = self.image:getWidth()/2, self.image:getHeight()/2

    love.graphics.draw(self.image, x,y,0,sx,sy,ox,oy)
end

return logoH