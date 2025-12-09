local button = Class:extend()

function button:new(args)  -- im trying out doing args this way cuz it seems better
    if not args then GlobalNotificationsHandler("Button creaeted with no arguments table", "error") end
    if type(args) ~= "table" then GlobalNotificationsHandler("Button created with non table argument", "error") end

    self.x = args.x or 0
    self.y = args.y or 0
    self.width = args.width or 10
    self.height = args.height or 10 

    self.link = args.link or nil
    self.hasImage = args.hasImage or false
    self.parts = args.parts or {}
    self.scales = args.scales or {} -- table of scaleLARGE and scaleSMALL
    if #self.scales == 0 then
        for i=1, #self.parts do
            self.scales[i] = {scaleLARGE = 1.5, scaleSMALL = 1}
        end
    end
    for _, scale in ipairs(self.scales) do
        scale.scale = scale.scaleSMALL
    end

    self.func = args.func or function() end

    self.colors = args.colors or {}
    if #self.colors ~= #self.parts then
        for i=1, #self.parts do
            self.colors[i] = args.colors[1] or {1,1,1}
        end
    end

    for i, color in ipairs(self.colors) do
        if type(color[1]) == "number" then
            local base = { color[1], color[2], color[3], color[4] or 1 }
            self.colors[i] = {
                base,
                {1, 1, 1},
                {1, 1, 1}
            }
        end
    end

    self.scaleTimers = {}
    self.colorTimers = {}
end

function button:update()
    local mx,my = cursor:getPosition()
    if mx >= self.x and mx <= self.x+self.width and my >= self.y and my<= self.y+self.height then
        self.hovered = true
    else
        self.hovered = false
    end
    if self.hovered and Input:pressed("menuClickLeft") then
        self:onClick()
    end

    for i, part in ipairs(self.scales) do
        if self.scaleTimers[i] then Timer.cancel(self.scaleTimers[i]) end
        if self.colorTimers[i] then Timer.cancel(self.colorTimers[i]) end 
        local r,g,b 
        if self.hovered then
            r,g,b = unpack(self.colors[i][1])
            self.colorTimers[i] = Timer.tween(0.01, self.colors[i][3], {[1] = r, [2] = g, [3] = b})
            self.scaleTimers[i] = Timer.tween(0.05, part, {scale = self.scales[i].scaleLARGE})
        else
            r,g,b = unpack(self.colors[i][2])
            self.colorTimers[i] = Timer.tween(0.1, self.colors[i][3], {[1] = r, [2] = g, [3] = b})
            self.scaleTimers[i] = Timer.tween(0.1, part, {scale = self.scales[i].scaleSMALL})
        end
    end
end

function button:onClick()
    self.func(self)
end

function button:draw()
    love.graphics.push()
    love.graphics.translate(self.x+self.width/2, self.y+self.height/2)
    for i, part in ipairs(self.parts) do
        love.graphics.scale(self.scales[i].scale or 1)

        if self.hasImage then
            local scaleX,scaleY = self.width/part:getWidth(), self.height/part:getHeight()

            love.graphics.setColor(self.colors[i][3])
            if part then love.graphics.draw(part, -(self.width/2), -(self.height/2) ,nil,scaleX,scaleY) end
        end

        love.graphics.scale(1/(self.scales[i].scale or 1))
    end
    love.graphics.setColor(1,1,1,1)
    love.graphics.pop()
end

return button