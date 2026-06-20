local toggle = settingsbaseshitthingy:extend("toggle")

function stringSplit(str, sep)  -- shouldnt this be local?
    local t = {}                -- buirger
                                -- sorry :(
    for s in string.gmatch(str, "([^" .. sep .. "]+)") do
        table.insert(t, s)
    end
    return t
end

function toggle:new(name, val, width, height)
    self.name = name

    self.val = val

    self.font = SkinHandler:getFont("Menu", 35)
    self.font2 = SkinHandler:getFont("Menu", 28)


    self.images = {["true"] = love.graphics.newImage("images/UI/true.png"), ["false"] = love.graphics.newImage("images/UI/false.png")}

    self.x = 0
    self.y = 0
    self.width = width or 0
    self.height = height or 0
end

function toggle:mousepressed(x, y, button)
    local w = self.font:getWidth(self.name .. ":   " )
    if x >= self.x+w-5 and x <= self.x+w-5+200 and y >= self.y - 5 and y <= self.y-5+50 then
        self.val = not self.val

        local split = stringSplit(self.reference, ".")
        Settings:setValue(split[1], split[2], split[3], self.val)
    end
end

function toggle:mousereleased(x, y, button)
end

local function capitalize(s)
    return s:sub(1,1):upper() .. s:sub(2):lower()
end

function toggle:draw(width, height, x, y)
    x = x or 0
    y = y or 0

    self.x = x + 15
    self.y = y + 15

    love.graphics.setFont(self.font)
    love.graphics.print(self.name .. ": ", self.x, self.y)
    love.graphics.setFont(self.font2)
    local w = self.font:getWidth(self.name .. ":   " )

    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill", self.x + w - 5, self.y - 5, 200, 50, 5, 5)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line", self.x + w - 5, self.y - 5, 200, 50, 5, 5)
    local function stencil()
        love.graphics.rectangle("fill", self.x + w - 5, self.y - 5, 200, 50, 5, 5)
    end
    love.graphics.stencil(stencil, "replace", 1)
    love.graphics.setStencilTest("greater", 0)
    love.graphics.print(capitalize(tostring(self.val)), self.x + w, self.y + 7)

    local drawImage = self.images[tostring(self.val)]
    local dick, balls = 200/drawImage:getWidth(), 50/drawImage:getHeight()
    love.graphics.draw(drawImage, self.x + w - 5, self.y - 5,0, dick, balls)
    love.graphics.setStencilTest()

    return height -- ??????? 
end

return toggle
