function gradient(x, y, width, height, color1, color2, direction)
    local mesh

    if direction == "vertical" then
        -- Vertical gradient (color1 at top, color2 at bottom)
        mesh = love.graphics.newMesh({
            {0, 0, 0, 0, color1[1], color1[2], color1[3], color1[4]},      -- Top-left
            {width, 0, 0, 0, color1[1], color1[2], color1[3], color1[4]},  -- Top-right
            {width, height, 0, 0, color2[1], color2[2], color2[3], color2[4]},-- Bottom-right
            {0, height, 0, 0, color2[1], color2[2], color2[3], color2[4]},  -- Bottom-left
        }, "fan")
    elseif direction == "horizontal" then
        -- Horizontal gradient (color1 on left, color2 on right)
        mesh = love.graphics.newMesh({
            {0, 0, 0, 0, color1[1], color1[2], color1[3], color1[4]},      -- Top-left
            {width, 0, 0, 0, color2[1], color2[2], color2[3], color2[4]},  -- Top-right
            {width, height, 0, 0, color2[1], color2[2], color2[3], color2[4]},-- Bottom-right
            {0, height, 0, 0, color1[1], color1[2], color1[3], color1[4]},  -- Bottom-left
        }, "fan")
    end

    -- Draw the mesh at the specified x and y
    love.graphics.draw(mesh, x, y)
end