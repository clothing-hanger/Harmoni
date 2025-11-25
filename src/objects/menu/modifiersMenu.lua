---@diagnostic disable: undefined-global
local modifiersMenu = Class:extend()

function modifiersMenu:new(x,y,width,height,paddingX,paddingY)
    self.modifiers = modifiersTable


    self.modnamefont = SkinHandler:getFont("Menu", 40)
    self.x,self.y = x or 0, y or 0
    self.width,self.height = width or 10, height or 10

    self.paddingX = paddingX or 10
    self.paddingY = paddingY or 10


    self.modifierWidth = self.width - (self.paddingX*2) -- modifiers should be as wide as the menu minus the padding on the left and right

    self.modifierHeight = (self.height - self.paddingY * (#self.modifiers + 1))/#self.modifiers
    self:setupModifiers()
end



function modifiersMenu:setupModifiers()
    for i, Modifier in ipairs(self.modifiers) do 
        local x = self.x
local y = self.y + self.paddingY*i + self.modifierHeight*(i-1)

        Modifier.x, Modifier.y = x,y
        
        if type(Modifier.default) == "boolean" then -- we know its a toggle
            Modifier.toggle = toggleSettings(x, y, self.modifierWidth,self.modifierHeight, Modifier.default, Modifier.default)
        end
    end
end

function modifiersMenu:update(dt)
    for i, Modifier in ipairs(self.modifiers) do
        if Modifier.toggle then -- this ones a toggle one (obviously) so we do the toggle shit with it i guess idk 
            if mouseOver(Modifier.toggle) and Input:pressed("menuClickLeft") then Modifier.toggle:onClick() end
            Modifier.toggle:update(dt)
            Modifier.value = Modifier.toggle:getValue("set")
        end
    end


        for i, Modifier in ipairs(self.modifiers) do 

            if Modifier.toggle then Modifier.toggle.x = self.x end end
end

function modifiersMenu:returnMods()
    local tbl = {}
    for i, Modifier in ipairs(self.modifiers) do
        tbl[Modifier.short] = Modifier.value
    end
    return tbl
end


function modifiersMenu:draw()
    love.graphics.setColor(32/255,33/255,35/255) -- stolen from Android (thaanks google)
                                                        -- me when i blatently rip off Material Design
     --   love.graphics.rectangle("fill", self.x, self.y, self.width, self.height + self.paddingY*2)

    for i, Modifier in ipairs(self.modifiers) do
       -- love.graphics.rectangle("line", Modifier.x, Modifier.y, self.modifierWidth, self.modifierHeight)
        if Modifier.toggle then Modifier.toggle:draw() end
        love.graphics.setColor(0,0,0)
        -- get the Y for the text 
        love.graphics.setFont(self.modnamefont)
        local textY = Modifier.y+self.modifierHeight/2-love.graphics.getFont():getHeight()/2
        love.graphics.print(Modifier.name, Modifier.toggle.x+30, textY)
        love.graphics.setColor(1,1,1)
    end

end

return modifiersMenu