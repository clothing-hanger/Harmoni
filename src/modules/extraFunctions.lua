function getFileExtension(fileName)
    return fileName:match("%.([^%.]+)$")
end

function getAverageColor(imageData)
    local r, g, b, count = 0, 0, 0, 0
    local width, height = imageData:getDimensions()

    for y = 0, height - 1 do
        for x = 0, width - 1 do
            local pr, pg, pb, pa = imageData:getPixel(x, y)
            if pa > 0 then  -- skip fully transparent
                r = r + pr
                g = g + pg
                b = b + pb
                count = count + 1
            end
        end
    end

    if count == 0 then return {0, 0, 0} end
    return {r / count, g / count, b / count}
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

-- https://www.love2d.org/wiki/Gradients

function drawMultiGradientRect(x, y, width, height, colors, vertical)
    -- colors: a table like { {r, g, b, a}, {r, g, b, a}, ... }
    if #colors < 2 then
        error("You need at least two colors for a gradient!")
    end

    love.graphics.setColor(1, 1, 1, 1) -- Reset color

    -- Create the vertices
    local vertices = {}
    local steps = #colors - 1

    for i = 1, steps do
        local t0 = (i - 1) / steps
        local t1 = i / steps

        local c0 = colors[i]
        local c1 = colors[i + 1]

        if vertical then
            local y0 = y + height * t0
            local y1 = y + height * t1

            -- Top quad
            table.insert(vertices, { x,         y0, 0, 0, c0[1], c0[2], c0[3], c0[4] or 1 })
            table.insert(vertices, { x + width, y0, 0, 0, c0[1], c0[2], c0[3], c0[4] or 1 })
            table.insert(vertices, { x + width, y1, 0, 0, c1[1], c1[2], c1[3], c1[4] or 1 })

            table.insert(vertices, { x,         y0, 0, 0, c0[1], c0[2], c0[3], c0[4] or 1 })
            table.insert(vertices, { x + width, y1, 0, 0, c1[1], c1[2], c1[3], c1[4] or 1 })
            table.insert(vertices, { x,         y1, 0, 0, c1[1], c1[2], c1[3], c1[4] or 1 })
        else
            local x0 = x + width * t0
            local x1 = x + width * t1

            -- Side quad
            table.insert(vertices, { x0, y,         0, 0, c0[1], c0[2], c0[3], c0[4] or 1 })
            table.insert(vertices, { x1, y,         0, 0, c1[1], c1[2], c1[3], c1[4] or 1 })
            table.insert(vertices, { x1, y + height, 0, 0, c1[1], c1[2], c1[3], c1[4] or 1 })

            table.insert(vertices, { x0, y,         0, 0, c0[1], c0[2], c0[3], c0[4] or 1 })
            table.insert(vertices, { x1, y + height, 0, 0, c1[1], c1[2], c1[3], c1[4] or 1 })
            table.insert(vertices, { x0, y + height, 0, 0, c0[1], c0[2], c0[3], c0[4] or 1 })
        end
    end

    local mesh = love.graphics.newMesh(vertices, "triangles", "static")
    love.graphics.draw(mesh)
end

function createMultiGradientRectMesh(x, y, width, height, colors, vertical)
        -- colors: a table like { {r, g, b, a}, {r, g, b, a}, ... }
    if #colors < 2 then
        error("You need at least two colors for a gradient!")
    end

    love.graphics.setColor(1, 1, 1, 1) -- Reset color

    -- Create the vertices
    local vertices = {}
    local steps = #colors - 1

    for i = 1, steps do
        local t0 = (i - 1) / steps
        local t1 = i / steps

        local c0 = colors[i]
        local c1 = colors[i + 1]

        if vertical then
            local y0 = y + height * t0
            local y1 = y + height * t1

            -- Top quad
            table.insert(vertices, { x,         y0, 0, 0, c0[1], c0[2], c0[3], c0[4] or 1 })
            table.insert(vertices, { x + width, y0, 0, 0, c0[1], c0[2], c0[3], c0[4] or 1 })
            table.insert(vertices, { x + width, y1, 0, 0, c1[1], c1[2], c1[3], c1[4] or 1 })

            table.insert(vertices, { x,         y0, 0, 0, c0[1], c0[2], c0[3], c0[4] or 1 })
            table.insert(vertices, { x + width, y1, 0, 0, c1[1], c1[2], c1[3], c1[4] or 1 })
            table.insert(vertices, { x,         y1, 0, 0, c1[1], c1[2], c1[3], c1[4] or 1 })
        else
            local x0 = x + width * t0
            local x1 = x + width * t1

            -- Side quad
            table.insert(vertices, { x0, y,         0, 0, c0[1], c0[2], c0[3], c0[4] or 1 })
            table.insert(vertices, { x1, y,         0, 0, c1[1], c1[2], c1[3], c1[4] or 1 })
            table.insert(vertices, { x1, y + height, 0, 0, c1[1], c1[2], c1[3], c1[4] or 1 })

            table.insert(vertices, { x0, y,         0, 0, c0[1], c0[2], c0[3], c0[4] or 1 })
            table.insert(vertices, { x1, y + height, 0, 0, c1[1], c1[2], c1[3], c1[4] or 1 })
            table.insert(vertices, { x0, y + height, 0, 0, c0[1], c0[2], c0[3], c0[4] or 1 })
        end
    end

    return love.graphics.newMesh(vertices, "triangles", "static")
end

function tryExcept(try, catch, finally)   -- thank you rit (i hate rit so MUCH I HATE RIT!!!!)
    local status, exception = pcall(try)
    if not status and catch then
        catch(exception)
    end
    if finally then
        finally()
    end

    return status, exception
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

function getDistance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function lerpAngle(a, b, t)
    local diff = (b - a + math.pi) % (2 * math.pi) - math.pi
    return a + diff * t
end

function getDirectory(path)
    local dir = path:match("^(.*)[/\\]")
    return dir or ""
end


---@param colors table<number, number, number>
---@return table<number, number, number> colorsRGB
function rgb(colors)  -- stolen from old harmoni cuz i hate the guy who made old harmoni so i steal from them 
    return {colors[1]/255, colors[2]/255, colors[3]/255}
end

function isEven(number)    -- borrring
    return number % 2 == 0
end

function REALisEven(number)
    local even = false
    for i = 0,math.abs(number) do
        even = not even
    end
    return even
end

function chance(chance)
    return love.math.random(1, 100) <= chance
end

function getFolderLocation(pathToFile)
    return pathToFile:match("^(.*)/[^/]*$")  -- this returns the path a file is in,, idk how often this will be used but i have a need for it right now 
end

function saveTableToFile(table, path)
    local string = "return {\n"
    for i,v in pairs(table) do
        string = string .. tostring(i) .. " = " .. tostring(v) .. ",\n"
    end
    string = string .. "}"
    local ok = love.filesystem.write(path, string)
end