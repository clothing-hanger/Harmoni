local settingsMenu = State("settingsMenu")

function settingsMenu:enter()

    self.testSettings = {
        toggleSettings(100,100,500,100,false,true)
    }
end

function settingsMenu:update()
    self:checkForSettingClicks()
end

function settingsMenu:checkForSettingClicks()
    for i, Setting in ipairs(self.testSettings) do
        local cursorX,cursorY = cursor:getPosition()
        if cursorX >= Setting.x and cursorX <= Setting.x+Setting.width then
            if cursorY >= Setting.y and cursorY <= Setting.y+Setting.height then
                Setting:onClick()
            end
        end
    end
end

function settingsMenu:draw()
    for i, Setting in ipairs(self.testSettings) do
        Setting:draw()
    end
end

return settingsMenu