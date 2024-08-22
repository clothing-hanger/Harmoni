local Toggle = Class:extend()

function Toggle:new(x, y, width, height, initialState, name, description)
    self.description = description
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.value = initialState or false
    self.name = name
    self.hovered = false
    self.isPressed = false
end

function Toggle:update()
    self.hovered = cursorX > self.x and cursorX < self.x + self.width and cursorY > self.y and cursorY < self.y + self.height
    
    if Input:pressed("menuClickLeft") then
        if self.hovered then
            self.isPressed = true
        end
    else
        if self.isPressed then
            self.isPressed = false
            if self.hovered then
                self.value = not self.value
            end
        end
    end

        

    if self.hovered then 
        cursorText = self.description
    end
end

function Toggle:draw()
    if self.value then
        love.graphics.setColor(0, 1, 0)
    else
        love.graphics.setColor(1, 0, 0)
    end
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(self.name, self.x, self.y + (self.height / 2) - 10, self.width, "center")
end

function Toggle:giveValue()
    return self.value
end

return Toggle