local notification = Class:extend("notification")

function notification:new(x,y,width,height,text,type)
    self.x = x
    self.y = y
    self.width = width
    self.text = text or "Ignore me! I'm not supposed to show up!"
    self.height = height
    self:setupColorAndImage(type)
    self.timer = 5
end

function notification:update(dt)
    self.timer = self.timer - dt
end

function notification:setupColorAndImage(type) -- yes i know i could use a table for this but i dont want to
    if type == "error" then
        self.color = {1,0,0}
    elseif type == "warning" then
        self.color = {1,1,0}
    elseif type == "info" then
        self.color = {1,1,1}
    elseif type == "success" then
        self.color = {0,1,0}
    else
        self.color = {1,1,1} -- default color
    end
end

function notification:draw()
    self.color[4] = 1
    love.graphics.setColor(self.color)
    local function stencilShape()
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 4,4)
    end
    love.graphics.stencil(stencilShape, "replace", 1)

    love.graphics.setStencilTest( "greater", 0)
    -- first we draw te background

    love.graphics.setColor(0,0,0,1)  -- we do this to darken the background a bit
    love.graphics.rectangle("fill",self.x, self.y, self.width, self.height)
    self.color[4] = 0.75
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill",self.x, self.y, self.width, self.height)

    -- the we draw the tiny rectangle on the left
    self.color[4] = 1
    love.graphics.setColor(self.color)

    love.graphics.rectangle("fill",self.x, self.y, 10, self.height)

    -- now we draw the text 
    love.graphics.setColor(1,1,1,1)
    local textX, textY = self.x + 15, self.y + self.height / 2 - love.graphics.getFont():getHeight() / 2
    love.graphics.printf(self.text, textX, textY, self.width - 15, "left")

    -- now we draw the time bar
    love.graphics.setColor(0.2,0.2,0.2,1)
    love.graphics.rectangle("fill", self.x, self.y+self.height-3, self.width*(self.timer/5), 5)

    love.graphics.setColor(1,1,1)
    love.graphics.setStencilTest()
end

return notification
