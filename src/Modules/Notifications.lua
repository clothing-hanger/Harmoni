local notifications = {}

function notification(string, type)
    table.insert(notifications, {notification = string, x = 200, y = 0, width = 400, height = 50, time = 5000, alive = true}) -- idk what else to name it other than alive lmao
end

function notificationUpdate(dt)
    for Key, Notification in pairs(notifications) do
        Notification.y = Key*Notification.height+10 -- add 10 for the space between the notifs
        Notification.time = Notification.time-1000*dt
        if Notification.time <= 0 then Notification.alive = false end
      --  if Notification.alive then Notification.x = math.max(Notification.x - 10*dt, 0) end
      if Notification.alive then 
        Notification.x = math.max(Notification.x - 2000*dt, 0)
      else
        Notification.x = Notification.x + 2000*dt
      end

      if Notification.x > 250 then table.remove(notifications, Key) end
        
    end
end

function notificationDraw()
    love.graphics.setFont(Skin.Fonts["Menu Small"])
    for Key, Notification in pairs(notifications) do
        love.graphics.setColor(0,0,0,0.8)
        love.graphics.rectangle("fill", Notification.x+Inits.GameWidth-(Notification.width+10), Notification.y, Notification.width, Notification.height)
        love.graphics.setColor(1,1,1)

        love.graphics.rectangle("line", Notification.x+Inits.GameWidth-(Notification.width+10), Notification.y, Notification.width, Notification.height)
        love.graphics.print(Notification.notification, (Notification.x+Inits.GameWidth-(Notification.width+10)+15), Notification.y + Notification.height/2-8)
    end
end
