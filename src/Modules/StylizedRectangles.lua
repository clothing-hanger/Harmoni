function beveledRectangle(width, height, x, y, cornerRadius, cornerSegments, borderSize, fillColor1, fillColor2, borderColor1, borderColor2, fillGradient, borderGradient, direction)
    local width = width or error("missing width argument to beveledRectanlge")
    local height = height or error("missing height argument to beveledRectanlge")
    local x = x or error("missing x argument to beveledRectanlge")
    local y = y or error("too lazy to type error message")
    local cornerRadius = cornerRadius or error("blah blah blah")  -- should prob type real error messages here.. too lazy tho
    local cornerSegments = cornerSegments or error("error")
    local borderSize = borderSize or error("this function has so many arguments")
    local fillColor1 = fillColor1 or error(".")
    local fillColor2 = fillColor2 or error(".")
    local borderColor1 = borderColor1 or error(".")
    local borderColor2 = borderColor2 or error(".")

    local fillGradient = fillGradient or false -- dont wanna error when this ones left off because we can just default to no gradient 
                                               --(most likely gonna not be using the gradient much anyway)
    local borderGradient = borderGradient or false
    local direction =  "horizontal"



    
    -- fill rectangle
    love.graphics.setColor(fillColor1)
    --love.graphics.rectangle("fill", x, y, width, height, cornerRadius, cornerSegments)
    gradient(x, y, width, height, fillColor1, fillColor2, direction)



    -- border rectangle
    local oldLineWidth = love.graphics.getLineWidth()
    love.graphics.setLineWidth(borderSize)
    love.graphics.setColor(borderColor2)
    love.graphics.rectangle("line", x, y, width, height, cornerRadius, cornerSegments)
    love.graphics.setLineWidth(oldLineWidth)
end