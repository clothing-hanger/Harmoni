local modifiersMenu = Class:extend()

function modifiersMenu:new(x,y,width,height,paddingX,paddingY)
    self.modifiers = {
       ["Test Modifier"] = {id = 1, default = false, type = toggle, hoverText = "This is a test modifier. It does nothing. What did you expect?"}
    }

    self.x,self.y = x or 0, y or 0
    self.width,self.height = width or 10, height or 10

    self.paddingX = paddingX or self.width*0.05
    self.paddingY = paddingY or self.height*0.05  -- 5% of the width/height if no padding is specified


    self.modifierWidth = self.width - (self.padding*2) -- modifiers should be as wide as the menu minus the padding on the left and right
    self.modifierHeight = self.height  - self.paddingY*(#self.modifiers+2)  -- we want the modifiers to take up the entire menu, with padding between each mod, plus the top and botton padding
end

function modifiersMenu:setupModifiers()
    for i, Modifier in ipairs(self.modifiers) do 
        local x = self.paddingX
        local y = self.paddingY + self.paddingY + self.modifierHeight
        if Modifier.type == toggle then
            toggle(x,y,self.modifierWidth,self.modifierHeight)
        end
    end
end

function modifiersMenu:update(dt)
end

function modifiersMenu:draw()
end
 
return modifiersMenu