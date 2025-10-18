local quickSettings = Class:extend("quickSettings")

function quickSettings:new(x,y,width,height,openX)
    self.x, self.y = x,y 
    self.width, self.height = width, height 
    self.openX = openX
    self.closedX = x

    self.hovered = false

    self.freezeX = false
end

function quickSettings:update(dt)
    local targetX = self.hovered and self.openX or self.closedX
    self.targetX = targetX
    if not self.freezeX then self.x = self.x + (targetX - self.x) * 10 * dt end
end

function quickSettings:mouseOver()
end

function quickSettings:draw()
    love.graphics.setColor(142/255,143/255,145/255,0.5)
    love.graphics.rectangle("fill", self.x, self.y, self.width+ 100, self.height, 100, 100, 20)
    love.graphics.setColor(1,1,1)

    if not self.targetX then return notificationsHandler:addNotification("THAT ONE BUG HAPPENED!! D:", "error") end

    love.graphics.print("hii!!\n I'm a placeholder!!\n pretend there are quick settings in this menu!!!!" ..
                        "\n\n\n\n\nDEBUG SHIT!!  :3\n" ..
                        tostring(self.hovered) .. "\n" ..
                        self.x .. "\n" ..
                        self.y .. "\n" ..
                        self.targetX, 
                        self.x+100,self.y+100
    )
end

return quickSettings