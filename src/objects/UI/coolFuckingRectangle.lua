local coolFuckingRectangle = Class:extend("coolFuckingRectangle")

function coolFuckingRectangle:new(x,y,width,height,padding,radius,color1,color2)
    if not color2 then self.color2 = {color1[1]/2,color1[2]/2,color1[3]/2,color1[4] or 1} else self.color2 = color2 end
    self.color1 = color1
    self.outerRadius = radius
    self.alpha = 1
    self.padding = padding
    local xscale = (width-padding)/width
    local yscale = (height-padding)/height
    local theFuckingRadius = radius*math.min(xscale,yscale)
    self.innerRadius = theFuckingRadius

    self.x,self.y,self.width,self.height = x,y,width,height
end

function coolFuckingRectangle:update()
end

function coolFuckingRectangle:draw()
    --outer fucking rectangle
     -- we actually use color 2 for the outer cuz its the backdrop
    local r,g,b = unpack(self.color2)
    love.graphics.setColor(r,g,b,self.alpha)
    love.graphics.rectangle("fill",self.x,self.y,self.width,self.height,self.outerRadius,self.outerRadius)

    --inner fucking rectangle
    local r,g,b = unpack(self.color1)
    love.graphics.setColor(r,g,b,self.alpha)
    local paddingHalf = self.padding/2 -- we cut it in half because it was big and fat
    local paddingFull = self.padding   -- we dont cut it in half because that would make it feel sad :(
    love.graphics.rectangle("fill",self.x+paddingHalf,self.y+paddingHalf,self.width-paddingFull,self.height-paddingFull,self.innerRadius,self.innerRadius)

    love.graphics.setColor(1,1,1,1)
end

return coolFuckingRectangle

