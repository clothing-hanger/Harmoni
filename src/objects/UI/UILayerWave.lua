local UILayerWave = Class:extend("UILayerWave")

function UILayerWave:new(x,y,width,height,layerCount,segments,amplitude,layerSpacing,layerColors)
    if not type(layerColors) == "table" then error("Bad argument #9 (layerColors) to UILayerWave! Table expected, got " .. type(layerColors)) end 
    self.layers = {}

    for i = 1,layerCount do
        self:createLayer(x,y,width,height,segments,amplitude,i,layerSpacing,(layerColors[i] or {1,1,1}), 0.8)
    end
end

    function UILayerWave:update(dt)
        for _, layer in ipairs(self.layers) do
            local points = {}
            local t, px, py

            for i = 0, layer.segments do
                t = i / layer.segments
                px = layer.x + t * layer.width
                py = layer.y + math.sin(t * math.pi * 2 * layer.freqMultiplier + layer.phaseOffset + love.timer.getTime() * layer.speed) * layer.amplitude
                table.insert(points, px)
                table.insert(points, py - _ * layer.spacing or 0)
            end

            -- Bottom right
            table.insert(points, layer.x + layer.width)
            table.insert(points, layer.y + layer.height)

            -- Bottom left
            table.insert(points, layer.x)
            table.insert(points, layer.y + layer.height)

            layer.points = points
        end
    end


function UILayerWave:createLayer(x,y,width,height,segments,amplitude,layerNumber,layerSpacing,color,transparency)
    local layer = {}
    
    layer.layer = layer    --layer.layer = layer ❤️
    layer.x,layer.y = x,y 
    layer.width,layer.height = width, height 

    layer.color = color
    -- how the fuck do i make the top wavy 

    layer.segments = segments or 20    -- i am not gonna pretend that chatgpt didnt write this lmfao,, i have no idea what it happening here 
    layer.amplitude = amplitude or 20

    local points = {}
layer.spacing = layerSpacing or 0

    layer.phaseOffset = math.random() * 2 * math.pi
    layer.freqMultiplier = 1 + (math.random() - 0.5) * 0.5
    layer.speed = 1 + math.random() -- how fast the wave moves

    -- Top edge (wavy)
    local phaseOffset = math.random() * 2 * math.pi        -- random horizontal shift
    local freqMultiplier = 1 + (math.random() - 0.5) * 0.5 -- slight frequency variation

    for i = 0, layer.segments do
        local t = i / layer.segments
        local px = x + t * width
        local py = y + math.sin(t * math.pi * 2 * freqMultiplier + phaseOffset) * layer.amplitude
        table.insert(points, px)
        table.insert(points, py - layerNumber * layerSpacing)
    end

    -- Bottom right
    table.insert(points, x + width)
    table.insert(points, y + height)

    -- Bottom left
    table.insert(points, x)
    table.insert(points, y + height)

    layer.points = points

    table.insert(self.layers, layer)

end

function UILayerWave:draw()
    for _, layer in ipairs(self.layers) do
        local color = layer.color 
        love.graphics.setColor(layer.color)
        love.graphics.polygon("fill", layer.points)
    end

    love.graphics.setColor(1,1,1,1)
end

return UILayerWave