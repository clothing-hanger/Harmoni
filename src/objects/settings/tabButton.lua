local tabButton = settingsbaseshitthingy:extend("tabButton")

function tabButton:new(name)
    self.name = name

    self.members = {}

    self.x = 25
    self.y = 25

    self.width = 100
    self.height = 100

    self.font = SkinHandler:getFont("Menu", 35)
end

function tabButton:add(member)
    table.insert(self.members, member)
end

function tabButton:remove(member)
    for i, m in ipairs(self.members) do
        if m == member then
            table.remove(self.members, i)
        end
    end
end

function tabButton:mousemoved(x, y)
    for i, member in ipairs(self.members) do
        member:mousemoved(x, y)
    end
end

function tabButton:mousepressed(x, y, button)
    for i, member in ipairs(self.members) do
        member:mousepressed(x, y, button)
    end
end

function tabButton:mousereleased(x, y, button)
    for i, member in ipairs(self.members) do
        member:mousereleased(x, y, button)
    end
end

function tabButton:draw()
    love.graphics.setFont(self.font)
    love.graphics.print(self.name, self.x, self.y)


    -- draw the rectangly thingy!!!! :D im sohappy !!
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

function tabButton:getDimensions()
    -- change this when its a normal button in the #future
    return self.width, self.height --self.font:getWidth(self.name), self.font:getHeight()
end

function tabButton:getWidth()
    return self.width 
end

function tabButton:getHeight()
    return self.height 
end

function tabButton:drawMembers()
    local y = 25
    for i, member in ipairs(self.members) do
        y = y + member:draw(300, y)
    end
end

return tabButton