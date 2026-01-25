local volumeControl = Class:extend("volumeControl")

function volumeControl:new()
    self.volumes = {
        --master = {volume = 0.5, x = 300, y = baseScreenRatio.y/2, radius = 200, linewidth = 20}
    }
end

function volumeControl:update(dt)
    local mx,my = cursor:getPosition()
    for i, VolumeControl in pairs(self.volumes) do
        if math.abs(mx-VolumeControl.x) < VolumeControl.radius and math.abs(my-VolumeControl.y) < VolumeControl.radius then
            VolumeControl.hovered = true
        end
    end
end

function volumeControl:wheelmoved(y)
    y = y/150
        for i, VolumeControl in pairs(self.volumes) do
            if VolumeControl.hovered then VolumeControl.volume = VolumeControl.volume+y end
        end
end

function volumeControl:draw()
    for i, VolumeControl in pairs(self.volumes) do
        love.graphics.setLineWidth(VolumeControl.linewidth)

                love.graphics.setColor(rgb({11*VolumeControl.volume,91*VolumeControl.volume,71*VolumeControl.volume}))

        love.graphics.arc("line", VolumeControl.x, VolumeControl.y, VolumeControl.radius+VolumeControl.linewidth/2-1, math.rad(0-90), math.rad(360*VolumeControl.volume-90))
        love.graphics.setColor(1,1,1)
        love.graphics.setColor(rgb({13,13,13}))


        love.graphics.circle("fill", VolumeControl.x, VolumeControl.y, VolumeControl.radius)

    end
end

return volumeControl