local SMWCloudThingyAnimation = Class:extend("SMWCloudThingyAnimation")


function SMWCloudThingyAnimation:new(rows, width, height, x, y, rowMinWidth, rowMaxWidth)
    self.rows = {}
    self.x = x or 0
    self.y = y or 0
    self.rowMinWidth, self.rowMaxWidth = rowMinWidth or 300, rowMaxWidth or 3000

    local previousNonFilledCenter = nil
    local maxCenterOffset = 1 -- PLEASE keep the row centers close (i have no idea if this even works)  
                              ---- IT DOESNT FUCKKING WORK but i dont care if we get lucky it wont be broken       ill fix it later
    for i = 1, rows do

        local filled = not isEven(i)  
        local rowHeight = height / rows
        local rowWidth = love.math.random(self.rowMinWidth, self.rowMaxWidth)
        local center

        if not filled and previousNonFilledCenter then
            center = previousNonFilledCenter + love.math.random(-maxCenterOffset, maxCenterOffset)
            center = math.max(self.x + width / 10, math.min(center, self.x + width - width / 10))
        else
            center = love.math.random(self.x + width / 10, self.x + width - width / 10)
        end

        table.insert(self.rows, {
            filled = filled,
            height = rowHeight,
            center = center,
            width = rowWidth
        })
        print(filled)
        if not filled then
            previousNonFilledCenter = center
        end

        if i > 1 and filled then  -- we do greater than 2 because row 2 is a connecting row 
            local prevFilledCenter = self.rows[i - 2].center
            local filledCenter = prevFilledCenter + love.math.random(-rowWidth / 2, rowWidth / 2)
            filledCenter = math.max(self.x + width / 10, math.min(filledCenter, self.x + width - width / 10))
            self.rows[i].center = filledCenter
        end
        print(filled)
    end

    -- now we do the connecting rows :(

    for i = 1,#self.rows do
        if not self.rows[i].filled then -- we need to find halfway between the previous and the next rows centers
            print(self.rows[i].filled)
            local previousCenter = self.rows[i-1].center
            local nextCenter = self.rows[i+1] and self.rows[i+1].center or 1
            print(previousCenter, nextCenter)
            local halfwayCenter = (previousCenter + nextCenter) / 2
            print(i)
            self.rows[i].center = halfwayCenter
            self.rows[i].width = 10
        end
    end
end

function SMWCloudThingyAnimation:update(dt)
end

function SMWCloudThingyAnimation:draw(dt)
    love.graphics.setColor(0,0,0)

    for i, Row in ipairs(self.rows) do


        if Row.filled then goto filled else goto connecting end

        ::filled::
        -- draw the half on the left
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("fill", Row.center - (Row.width/2), (i-1) * Row.height, Row.width/2, Row.height)

        -- draw the circle on the left side 
        love.graphics.circle("fill", Row.center - (Row.width/2), (i-1) * Row.height+Row.height/2, Row.height/2)

        --draw the half on the right
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("fill", Row.center, (i-1) * Row.height, Row.width/2, Row.height)

        -- and the right circle too
        love.graphics.circle("fill", Row.center + (Row.width/2), (i-1) * Row.height+Row.height/2, Row.height/2)

        goto continue

        ::connecting:: 
        local center = Row.center

        -- this is gonna SUCK we have to make circles and shit and then mask them away or whatever its called I DONT FUCKING KNOW

        love.graphics.stencil(function()
            love.graphics.circle("fill", center-60, (i-1) * Row.height+Row.height/2, Row.height/2)
            --love.graphics.setColor(1,0,0)
            love.graphics.circle("fill", center+60, (i-1) * Row.height+Row.height/2, Row.height/2)
        end, "replace", 1)

        love.graphics.setStencilTest("notequal", 1)
        love.graphics.rectangle("fill", Row.center - 60, (i-1) * Row.height, 120, Row.height)

        love.graphics.setColor(1, 0, 0)
        --love.graphics.circle("line", Row.center, (i-1) * Row.height + Row.height / 2, 5)
        ::continue::
    end

    love.graphics.setColor(1,1,1)
end

return SMWCloudThingyAnimation
