local AchievementHandler = Class:extend()

local rarityOrder = {
    common = 1,
    uncommon = 2,
    rare = 3,
    epic = 4,
    legendary = 5,
    mythical = 6,
    unique = 7
}

function AchievementHandler:new()
    self.achievements = {}
    self.achievementPopups = {}
    self.popupQueue = {}
    self.currentPopup = nil

    local function create(id, text, rarity)
        self.achievements[id] = {
            id = id,
            text = text,
            rarity = rarity or "common",
            unlocked = false
        }
    end

    create("first note", "Hit your first note!", "common")
    create("fifth note", "Hit your fifth note!", "uncommon")
    create("tenth note", "Hit your tenth note!", "rare")
    create("fiftieth note", "Hit your fiftieth note!", "epic")
    create("seventieth note", "Hit your seventieth note!", "legendary")
    create("hundredth note", "Hit your hundredth note!", "mythical")
    create("two hundredth note", "Hit your two hundredth note!", "unique")
    create("three hundredth note", "Hit your three hundredth note!", "common")
    create("four hundredth note", "Hit your four hundredth note!", "uncommon")
    create("five hundredth note", "Hit your five hundredth note!", "rare")
    create("six hundredth note", "Hit your six hundredth note!", "epic")
    create("seven hundredth note", "Hit your seven hundredth note!", "legendary")
    create("eight hundredth note", "Hit your eight hundredth note!", "mythical")
    create("nine hundredth note", "Hit your nine hundredth note!", "unique")
    create("thousandth note", "Hit your thousandth note!", "common")

    create("first miss", "Missed your first note...", "common")
    create("fifth miss", "Hit your fifth note...", "uncommon")
    create("tenth miss", "Hit your tenth note...", "rare")
    create("fiftieth miss", "Hit your fiftieth note...", "epic")
    create("hundredth miss", "Hit your hundredth note...", "legendary")
    create("two hundredth miss", "Hit your two hundredth note...", "mythical")

    create("beat song", "Beat a song!", "common")
    create("failed song", "Failed a song...", "common")
    create("first perfect judge", "Got your first Perfect!", "unique")
    create("first great judge", "Got your first Great!", "common")
    create("first good judge", "Got your first Good!", "common")
    create("first alright judge", "Got your first Alright..", "common")
    create("first awful judge", "Got your first Awful...", "common")
    create("first miss judge", "Got your first Miss....", "mythical")

    create("title screen", "Saw the Title Screen!", "common")
    create("touched a squishy circle", "Touched a Squishy Circle on the Title Screen!", "rare")
    create("touched a squishy arrow", "Touched a Squishy Arrow on the Title Screen!", "rare")
    create("touched a spinning circle", "Touched a Spinning Circle on the Title Screen!", "legendary")
    create("touched a spinning arrow", "Touched a Spinning Arrow on the Title Screen!", "mythical")

    create("jukebox mode", "Opened Jukebox Mode!        ", "common")
    create("jukebox song", "Listened to a song in Jukebox!", "common")
    create("jukebox video", "Watched a video in Jukebox!", "rare")
    create("jukebox fullscreen video", "Watched a fullscreen video in Jukebox!", "legendary")

    create("select song", "Selected a Song in Song Select!", "common")
    create("started song", "Started your first Song!", "common")
    create("songPreloader", "Saw songPreloader do first time processing on a Song!", "rare")
    create("maniaChartDifficultyCalculator", "Saw maniaChartDifficultyCalculator fail to calculate difficulty of a Song!", "legendary")

    create("left click", "Pressed the Left Click button on the Mouse!", "common")

    create("30 seconds", "Ran the game for at least 30 seconds!", "common")
    create("5 minutes", "Ran the game for at least 5 minutes!", "rare")

    create("paused", "Paused for the first time!", "common")
    create("unpaused", "Unpaused for the first time!", "common")
    create("paused for 30 seconds", "Paused for at least 30 seconds!", "rare")

    create("first error", "Saw an error for the first time!", "common")
    create("fifth error", "Saw an error for the fifth time!", "rare")
    create("tenth error", "Saw an error for the tenth time!", "legendary")

    create("first common achievement", "Unlocked your first common achievement!", "uncommon")
    create("first uncommon achievement", "Unlocked your first uncommon achievement!", "rare")
    create("first rare achievement", "Unlocked your first rare achievement!", "epic")
    create("first epic achievement", "Unlocked your first epic achievement!", "legendary")
    create("first legendary achievement", "Unlocked your first legendary achievement!", "mythical")
    create("first mythical achievement", "Unlocked your first mythical achievement!", "unique")
    create("first unique achievement", "Unlocked your first unique achievement!", "common") -- common because FUCK you
end

function AchievementHandler:unlock(id)
    local achievement = self.achievements[id]
    if not achievement then return end
    if achievement.unlocked then return end

    achievement.unlocked = true
    table.insert(self.popupQueue, achievement)

    if achievement.id:match("^first") and achievement.id:match("achievement$") then return end

    if achievement.rarity == "common" then
        if not self.unlockedCommon then
            self.unlockedCommon = true
            self:unlock("first common achievement")
        end
    elseif achievement.rarity == "uncommon" then
        if not self.unlockedUncommon then
            self.unlockedUncommon = true
            self:unlock("first uncommon achievement")
        end
    elseif achievement.rarity == "rare" then
        if not self.unlockedRare then
            self.unlockedRare = true
            self:unlock("first rare achievement")
        end
    elseif achievement.rarity == "epic" then
        if not self.unlockedEpic then
            self.unlockedEpic = true
            self:unlock("first epic achievement")
        end
    elseif achievement.rarity == "legendary" then
        if not self.unlockedLegendary then
            self.unlockedLegendary = true
            self:unlock("first legendary achievement")
        end
    elseif achievement.rarity == "mythical" then
        if not self.unlockedMythical then
            self.unlockedMythical = true
            self:unlock("first mythical achievement")
        end
    elseif achievement.rarity == "unique" then
        if not self.unlockedUnique then
            self.unlockedUnique = true
            self:unlock("first unique achievement")
        end
    end
end

function AchievementHandler:update(dt)
    if not self.currentPopup and #self.popupQueue > 0 then
        local nextAchievement = table.remove(self.popupQueue, 1)
        self.currentPopup = AchievementPopup(nextAchievement.text, nextAchievement.rarity)
    end

    if self.currentPopup then
        self.currentPopup:update(dt)
        if self.currentPopup.dead then
            self.currentPopup = nil
        end
    end
end

function AchievementHandler:draw()
    if self.currentPopup then
        self.currentPopup:draw()
    end
end

return AchievementHandler