local button = Class:extend()

function button:new(args)
    if not args then GlobalNotificationsHandler("Button creaeted with no arguments table", "error") end
    if type(args) ~= "table" then GlobalNotificationsHandler("Button created with non table argument", "error") end

    self.x = args.x or 0
    self.y = args.y or 0
    self.width = args.width or 10
    self.height = args.height or 10 
    
end

function button:update()
end

function button:onClick()
end

function button:draw()
end

return button