local toggle = Class:extend()


function toggle:new(x,y,width,height,text,hoverText,default)
    self.x,self.y = x or 0, y or 0
    self.width,self.height = width or 10,height or 0
    self.text = text or ""
    self.hoverText = hoverText or ""
    self.toggleState = default or false

    self.color = {}
    self.color.on,self.color.off = {1,0,0,1},{0,1,0,1}
end

function toggle:update()
end

function toggle:onClick()
    self.toggle = not self.toggle
end

function toggle:returnState()
    return self.toggleState
end

function toggle:draw()
    love.graphics.setColor((self.toggleState and self.color.on) or self.color.off)
    love.graphics.rectangle("fill",self.x,self.y,self.width,self.height)
end

return toggle