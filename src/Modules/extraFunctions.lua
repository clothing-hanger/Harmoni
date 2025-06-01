function getFileExtension(fileName)
    return fileName:match("%.([^%.]+)$")
end

function getAverageColor(imageData)
    local r, g, b = 0, 0, 0
    local width, height = imageData:getDimensions()
    local totalPixels = width * height

    for y = 0, height - 1 do
        for x = 0, width - 1 do
            local pr, pg, pb = imageData:getPixel(x, y)
            r = r + pr
            g = g + pg
            b = b + pb
        end
    end

    r = r / totalPixels
    g = g / totalPixels
    b = b / totalPixels

    return {r, g, b}
end

function drawGradientRect(x, y, width, height, color1, color2, vertical)  -- stolen lol
    local vertices
    if vertical then
        vertices = {
            {x, y,         0, 0, color1[1], color1[2], color1[3], color1[4] or 1},
            {x + width, y, 0, 0, color1[1], color1[2], color1[3], color1[4] or 1},
            {x + width, y + height, 0, 0, color2[1], color2[2], color2[3], color2[4] or 1},
            {x, y + height,         0, 0, color2[1], color2[2], color2[3], color2[4] or 1},
        }
    else
        vertices = {
            {x, y,         0, 0, color1[1], color1[2], color1[3], color1[4] or 1},
            {x + width, y, 0, 0, color2[1], color2[2], color2[3], color2[4] or 1},
            {x + width, y + height, 0, 0, color2[1], color2[2], color2[3], color2[4] or 1},
            {x, y + height,         0, 0, color1[1], color1[2], color1[3], color1[4] or 1},
        }
    end
    
    love.graphics.setColor(1,1,1)

    local mesh = love.graphics.newMesh(vertices, "fan", "static")
    love.graphics.draw(mesh)
end

function toLinear(c)   -- stolen too 
    if c <= 0.04045 then
        return c / 12.92
    else
        return ((c + 0.055) / 1.055) ^ 2.4
    end
end

function getTextColor(r, g, b)    -- also stolen lol
    local r_lin = toLinear(r)
    local g_lin = toLinear(g)
    local b_lin = toLinear(b)

    local luminance = 0.2126 * r_lin + 0.7152 * g_lin + 0.0722 * b_lin

    -- Return white for dark backgrounds, black for light ones
    if luminance > 0.2 then
        return {0, 0, 0}  -- black
    else
        return {1, 1, 1}  -- white
    end
end

function lerp(a, b, t)
    return a + (b - a) * t
end

function lerpAngle(a, b, t) 
    local diff = (b - a + math.pi) % (2 * math.pi) - math.pi
    return a + diff * t
end
