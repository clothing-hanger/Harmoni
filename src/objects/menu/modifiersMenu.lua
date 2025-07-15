local modifiersMenu = Class:extend()

function modifiersMenu:new(x,y,width,height)
    self.modifiers = {
       ["Test Modifier"] = {id = 1, default = false, type = toggle}
    }
end

function modifiersMenu:setupModifiers()
    for i, Modifier in ipairs(self.modifiers) do 
        if Modifier.type == toggle then
            toggle()
        end
    end
end

function modifiersMenu:update(dt)
end

function modifiersMenu:draw()
end

return modifiersMenu