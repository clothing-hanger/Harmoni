---@class Select
local Select = Class:extend()

---@param x number The x position
---@param y number The y position
---@param width number The width
---@param height number The height
---@param options table<any> Table of options
---@param value any The starting value
---@param name string The name of the Select
---@param description string The description of the Select
function Select:new(x, y, width, height, options, value, name, description)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.options = options
    self.selected = value or options[1]
    self.expanded = false
    self.name = name
    self.hovered = false
    self.description = description
end

function Select:update()
    self.hovered = cursorX > self.x and cursorX < self.x + self.width and cursorY > self.y and cursorY < self.y + self.height

    if self.hovered then 
        cursorText = self.description
    end
    if Input:pressed("menuClickLeft") then
        if self.expanded then
            for i, option in ipairs(self.options) do
                local optionX = self.x + (i * self.width)
                if cursorX >= optionX and cursorX <= optionX + self.width and cursorY >= self.y and cursorY <= self.y + self.height then
                    self.selected = option
                    self.expanded = false
                    break
                end
            end
        end
        if self.hovered then
            self.expanded = not self.expanded
        else
            self.expanded = false  -- close it when you click outside of the selections
        end
    end

end

function Select:draw()
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    love.graphics.printf(self.name .. ": " .. self.selected, self.x + 10, self.y + 10, self.width-20, "center")

    --selections 
    
    if self.expanded then
        for i, option in ipairs(self.options) do
            local optionX = self.x + (i * self.width)
            love.graphics.rectangle("line", optionX, self.y, self.width, self.height)
            love.graphics.printf(option, optionX + 10, self.y + 10, self.width-20, "center")
        end
    end
    
end

function Select:giveValue()
    return self.selected
end

return Select
