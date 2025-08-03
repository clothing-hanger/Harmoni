local notificationsHandler = Class:extend("notificationsHandler")

function notificationsHandler:new()
    self.notifications = {}
    self.notificationHeight = 50
    self.notificationWidth = 250

end

function notificationsHandler:addNotification(text, type)
    table.insert(self.notifications,1, notification(7, 7, self.notificationWidth, self.notificationHeight, text, type))
end

function notificationsHandler:update(dt)
    for i, Notification in ipairs(self.notifications) do
        Notification.targetY = 7 + (i - 1) * (self.notificationHeight + 5)
        Notification.targetX = -self.notificationWidth
        
        local speed = 20
        Notification.y = Notification.y + (Notification.targetY - Notification.y) * math.min(speed * dt, 1)
        Notification:update(dt)

        if Notification.timer<=0 then
            Notification.x = Notification.x + (Notification.targetX - Notification.x) * math.min(speed * dt, 1)
            if Notification.x <= Notification.targetX then table.remove(self.notifications, i) end
        end
        
    end

end
function notificationsHandler:draw()
    for i, Notification in ipairs(self.notifications) do
        Notification:draw()
    end
end

return notificationsHandler