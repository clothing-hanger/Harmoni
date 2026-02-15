local AchievementGranter = Class:extend()

function AchievementGranter:new(handler)
    self.handler = handler
    self.noteCount = 0
    self.missCount = 0
    self.errorCount = 0
    self.playTime = 0
end

function AchievementGranter:update(dt)
    self.playTime = self.playTime + dt

    if self.playTime >= 30 then
        self.handler:unlock("30 seconds")
    end
end

function AchievementGranter:noteHit() -- maybe its better to not have a separate granter??
    self.noteCount = self.noteCount + 1

    if self.noteCount == 1 then
        self.handler:unlock("first note")
    elseif self.noteCount == 10 then
        self.handler:unlock("tenth note")
    elseif self.noteCount == 50 then
        self.handler:unlock("fiftieth note")
    elseif self.noteCount == 70 then
        self.handler:unlock("seventieth note")
    elseif self.noteCount == 100 then
        self.handler:unlock("hundredth note")
    elseif self.noteCount == 200 then
        self.handler:unlock("two hundredth note")
    elseif self.noteCount == 300 then
        self.handler:unlock("three hundredth note")
    elseif self.noteCount == 400 then
        self.handler:unlock("four hundredth note")
    elseif self.noteCount == 500 then
        self.handler:unlock("five hundredth note")
    elseif self.noteCount == 600 then
        self.handler:unlock("six hundredth note")
    elseif self.noteCount == 700 then
        self.handler:unlock("seven hundredth note")
    elseif self.noteCount == 800 then
        self.handler:unlock("eight hundredth note")
    elseif self.noteCount == 900 then
        self.handler:unlock("nine hundredth note")
    elseif self.noteCount == 1000 then
        self.handler:unlock("thousandth note")
    end
end

function AchievementGranter:miss()
    self.missCount = self.missCount + 1

    if self.missCount == 1 then
        self.handler:unlock("first miss")
    elseif self.missCount == 10 then
        self.handler:unlock("tenth miss")
    elseif self.missCount == 50 then
        self.handler:unlock("fiftieth miss")
    elseif self.missCount == 70 then
        self.handler:unlock("seventieth miss")
    elseif self.missCount == 100 then
        self.handler:unlock("hundredth miss")
    elseif self.missCount == 200 then
        self.handler:unlock("two hundredth miss")
    end
end

function AchievementGranter:error()
    self.errorCount = self.errorCount + 1
end

return AchievementGranter