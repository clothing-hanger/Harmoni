---@diagnostic disable: undefined-global
local modifiersMenu = Class:extend()

function modifiersMenu:new(x,y,width,height,paddingX,paddingY)
    self.modifiers = modifiersTable

    self.x,self.y = x or 0, y or 0
    self.width,self.height = width or 10, height or 10

    self.paddingX = paddingX or self.width*0.05
    self.paddingY = paddingY or self.height*0.05  -- 5% of the width/height if no padding is specified


    self.modifierWidth = self.width - (self.paddingX*2) -- modifiers should be as wide as the menu minus the padding on the left and right

    self.modifierHeight = (self.height - self.paddingY * (#self.modifiers + 1))/#self.modifiers
    self:setupModifiers()
end



function modifiersMenu:setupModifiers()
    for i, Modifier in ipairs(self.modifiers) do 
        local x = self.paddingX
        local y = (self.paddingY + self.paddingY + self.modifierHeight*i) + self.y

        Modifier.x, Modifier.y = x,y
        
        if type(Modifier.default) == "boolean" then -- we know its a toggle
            Modifier.toggle = toggleSettings(x, y, 500,100, Modifier.default, Modifier.default)
        end
    end
end

function modifiersMenu:update(dt)
    for i, Modifier in ipairs(self.modifiers) do
        if Modifier.toggle then -- this ones a toggle one (obviously) so we do the toggle shit with it i guess idk 
            if mouseOver(Modifier.toggle) and Input:pressed("menuClickLeft") then Modifier.toggle:onClick() end
            Modifier.toggle:update()
            Modifier.value = Modifier.toggle:getValue("set")
        end
    end
end

function modifiersMenu:returnMods()
    local tbl = {}
    for i, Modifier in ipairs(self.modifiers) do
        tbl[Modifier.short] = Modifier.value
    end
    return tbl
end


function modifiersMenu:draw()
    for i, Modifier in ipairs(self.modifiers) do
       -- love.graphics.rectangle("line", Modifier.x, Modifier.y, self.modifierWidth, self.modifierHeight)
        if Modifier.toggle then Modifier.toggle:draw() end
        love.graphics.setColor(0,0,0)
        love.graphics.print(Modifier.name, Modifier.x, Modifier.y)
        love.graphics.setColor(1,1,1)
    end
end

return modifiersMenu