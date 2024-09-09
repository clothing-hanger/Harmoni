local judgementBarGraph = Class:extend()

function judgementBarGraph:new()
    self.x = 1080
    self.y = 700
    self.width = 540
    self.height = 400
    self.barWidth = 60
    
end

function judgementBarGraph:update()
    
    if Input:down("menuLeft") then
        self.x = self.x - 1
    elseif Input:down("menuRight") then
        self.x = self.x + 1
    elseif Input:down("menuUp") then
        self.y = self.y - 1
    elseif Input:down("menuDown") then
        self.y = self.y + 1
    end

    print(self.y .. " " .. self.x)

end
function judgementBarGraph:draw()
    local padding = 40

    -- Draw the background
    love.graphics.setColor(0,0,0,0.9)
    love.graphics.rectangle("fill", self.x, self.y - self.height, self.width, self.height)
    love.graphics.setColor(1,1,1,1)

    local totalBars = #JudgementNames
    local spacing = self.width / totalBars

    -- Find the maximum count to scale heights
    local maxCount = 0
    for _, judgementName in ipairs(JudgementNames) do
        local judgement = Judgements[judgementName]
        if judgement.Count > maxCount then
            maxCount = judgement.Count
        end
    end

    for Judgement = 1, totalBars do
        local judgement = Judgements[JudgementNames[Judgement]]
        local barHeight = judgement.Count
        love.graphics.setColor(judgement.Color)

        -- Scale the bar height to fit within self.height with padding
        local scaledBarHeight = (barHeight / maxCount) * (self.height - 2 * padding)
        
        -- Adjusted barX calculation
        local barX = ((spacing * (Judgement - 0.5)) - self.barWidth / 2) + self.x
        
        -- Calculate the y position to include padding
        local barY = self.y - self.height + padding + (self.height - scaledBarHeight - 2 * padding)

        love.graphics.setFont(Skin.Fonts["Menu Large"])

        love.graphics.printf(judgement.Count, barX, barY-20, self.barWidth, "center")

        love.graphics.rectangle("fill", barX, barY+20, self.barWidth, scaledBarHeight)
    end
end



return judgementBarGraph