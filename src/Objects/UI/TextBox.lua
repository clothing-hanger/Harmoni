local TextBox = Class:extend()

function TextBox:new(x, y, width, height, initialText, name, description)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.text = initialText or ""
    self.name = name
    self.description = description or ""
    self.active = false
    self.hovered = false
end

function TextBox:update(dt)
    self.hovered = cursorX > self.x and cursorX < self.x + self.width and cursorY > self.y and cursorY < self.y + self.height

    if Input:pressed("menuClickLeft") then
        if self.hovered then
            self.active = true
            love.keyboard.setTextInput(true)
        else
            self.active = false
            love.keyboard.setTextInput(false)
        end
    end

    if self.hovered then 
        cursorText = self.description
    end
end

function TextBox:textinput(text)
    if self.active then
        self.text = self.text .. text
    end
end

function TextBox:keypressed(key)
    if self.active then
        if key == "backspace" then
            -- Remove the last character from the text
            self.text = self.text:sub(1, -2)
        elseif key == "return" then
            -- Optionally, deactivate the text box when pressing enter
            self.active = false
            love.keyboard.setTextInput(false)
        end
    end
end

function TextBox:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    love.graphics.printf(self.text, self.x + 5, self.y + (self.height / 2) - 10, self.width - 10, "left")
end

function TextBox:giveValue()
    return self.text
end

return TextBox
