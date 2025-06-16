local testObject = setmetatable({}, {__index = Object}) -- test object 

function testObject:new(x,y,w,h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
end

function testObject:update(dt)
    self.x = self.x + 1
    self.y = self.y + 1
end

function testObject:draw()
    print("Drawing testObject")
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor(1, 1, 1, 1)
end

return testObject
