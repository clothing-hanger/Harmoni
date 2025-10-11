local resultsState = State("resultsState")

function resultsState:enter(s, parent, accuracy, image)
    self.parent = parent
    self.grades = require("modules.maniaGrades")
    self.accuracy = accuracy or 100
    self.x, self.y = baseScreenRatio.x / 2, baseScreenRatio.y / 2
    self.width, self.height = 700, 700
    self.rectX, self.rectY = self.x - (self.width / 2), self.y - (self.height / 2)
    self.arcX, self.arcY = self.x, self.y
    self.arcR = 300
    self.rectRC = 90
    self.background = self.parent.BG
    self.bump = 1
    self.hitSound = love.audio.newSource("sounds/hit.mp3", "static")     --THIS SOUND IS A PLACEHOLDER
    self.arcLineWidth = 20

    self.printableAccuracy = 0
    

    self.accuracyCircleAngle = (self.printableAccuracy / 100) * 2 * math.pi
    self:tweenArc(self.accuracyCircleAngleFinal)
    self.lastGradeMet = nil
end

function resultsState:update(dt)
        self.rectX, self.rectY = self.x - (self.width / 2), self.y - (self.height / 2)
        self.accuracyCircleAngle = (self.printableAccuracy / 100) * 2 * math.pi



        for i, Grade in ipairs (self.grades) do
            if Grade.accuracy <= self.printableAccuracy and not Grade.hit then
                Grade.hit = true
                self:onGradeReached(Grade.grade)
            end
        end

end

function resultsState:onGradeReached(grade)
    self.bump = 1.05
    if self.bumpTimer then Timer.cancel(self.bumpTimer) end
    self.bumpTimer = Timer.tween(0.5, self, {bump = 1}, "out-quad")

    local hitClone = self.hitSound:clone()
    hitClone:setPitch(self.printableAccuracy / 100)
    hitClone:play()

    print(grade)
end

function resultsState:tweenArc(amount)
    Timer.tween(2.5, self, {printableAccuracy = self.accuracy}, "out-quad", function() 
    self:expandRectangle()

    end)
end

function resultsState:moveArcUp(amount)
    Timer.tween(1,self, {arcY = self.arcY-amount}, "out-quad")
end

function resultsState:expandRectangle()
    local newHeight = 1100
    local difference = newHeight - self.height
        self:moveArcUp(difference/2)

    Timer.tween(1,self,{height = newHeight}, "out-quad")
end

function resultsState:draw()
    
    love.graphics.draw(self.background)
    love.graphics.push()
        love.graphics.translate(self.x, self.y)
        love.graphics.scale(self.bump or 1, self.bump or 1)
                love.graphics.translate(-self.x, -self.y)

        love.graphics.setColor(0, 0, 0, 0.9)
        love.graphics.rectangle("fill", self.rectX, self.rectY, self.width, self.height, self.rectRC, self.rectRC)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(self.arcLineWidth)

        local function stencilFunc()
            love.graphics.circle("fill", self.arcX, self.arcY, self.arcR - 10)
        end
        love.graphics.stencil(stencilFunc, "replace", 1)
        love.graphics.setStencilTest("less", 1)

        love.graphics.arc("line", self.arcX, self.arcY, self.arcR, -math.pi/2, -math.pi/2 + self.accuracyCircleAngle)
    love.graphics.pop()
    love.graphics.setStencilTest()
end

return resultsState
