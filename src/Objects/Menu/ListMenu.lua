---@class ListMenu
local ListMenu = Class:extend()

---@param x? number The x position
---@param y? number The y position
---@param width? number the width
---@param height? number the height
---@param name? string the name of the item
function ListMenu:new(x, y, width, height, name)
    self.x = x or 0
    self.y = y or 240
    self.width = width or 500
    self.height = height or (Inits.GameHeight - 250)
    self.name = name or ""
    self.items = {}
    self.hovered = false
    self.scrollOffset = 0
    self.scrollSpeed = 35
end

---@param item table {text: string}
function ListMenu:addItem(item) -- {text = itemtext}
    item.id = #self.items + 1 -- add 1 because 0 indexing SUCKS you should DIE if you ever do it!!!!!!!!!
    item.height = 50
    item.y = (item.height + 10) * item.id
    table.insert(self.items, item)
end

function ListMenu:update(dt)
    self.hovered = cursorX > self.x and cursorX < self.x + self.width and cursorY > self.y and cursorY < self.y + self.height

    if self.scrollTarget then
        local targetOffset = self.scrollTarget
        self.scrollOffset = self.scrollOffset + (targetOffset - self.scrollOffset) * self.scrollSpeed * dt
        if math.abs(self.scrollOffset - targetOffset) < 1 then
            self.scrollOffset = targetOffset
            self.scrollTarget = nil
        end
    end
end

function ListMenu:wheelmoved(y)
    if not self.hovered then return end
    self.scrollTarget = self.scrollOffset - y * 50
end

function ListMenu:draw()
    love.graphics.setColor(Skin.Colors["List Menu Backing Fill"])
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    love.graphics.setColor(Skin.Colors["List Menu Backing Line"])
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

    -- Set the scissor to the visible area
    local scissorX = self.x
    local scissorY = self.y
    local scissorWidth = self.width
    local scissorHeight = self.height

    love.graphics.setScissor(scissorX, scissorY, scissorWidth, scissorHeight)

    for _, item in ipairs(self.items) do
        local itemY = item.y - self.scrollOffset
        if itemY + item.height > scissorY and itemY < scissorY + scissorHeight then
            love.graphics.setColor(Skin.Colors["List Menu Button Fill"])
            love.graphics.rectangle("fill", self.x + 15, itemY, self.width - 30, item.height)

            love.graphics.setColor(Skin.Colors["List Menu Button Line"])
            love.graphics.rectangle("line", self.x + 15, itemY, self.width - 30, item.height)
        end
    end

    -- Reset scissor to allow drawing outside the visible area
    love.graphics.setScissor()

    love.graphics.setColor(1, 1, 1)
end

return ListMenu
