local achievementHandler = Class:extend()

function achievementHandler:new()
    self.unlockedAchievments = {}  -- we will reset this at each launch :) so no need to save them or anything

    self.achievements = {
        ["first note"] = {text = "Hit your first note!"},
        ["fifth note"] = {text = "Hit your fifth note!"},
        ["tenth note"] = {text = "Hit your tenth note!"},
        ["first miss"] = {text = "Missed your first note..."},
        ["fifth miss"] = {text = "Hit your fifth note..."},
        ["tenth miss"] = {text = "Hit your tenth note..."},
        ["beat song"] = {text = "Beat a song!"},
        ["failed song"] = {text = "Failed a song..."},
        ["first perfect judge"] = {text = "Got your first Perfect!"},
        ["first great judge"] = {text = "Got your first Great!"},
        ["first good judge"] = {text = "Got your first Good!"},
        ["first alright judge"] = {text = "Got your first Alright.."},
        ["first miss judge"] = {text = "Got your first Miss...."},
        ["title screen"] = {text = "Saw the Title Screen!"},
        ["jukebox mode"] = {text = "Opened Jukebox Mode!"},
        ["jukebox song"] = {text = "Listened to a song in Jukebox!"},
        ["jukebox video"] = {text = "Watched a video in Jukebox!"},
        ["select song"] = {text = "Selected a Song in Song Select!"},
        ["started song"] = {text = "Started your first Song!"},
        ["songPreloader"] = {text = "Saw songPreloader do first time processing on a Song!"},
        ["maniaChartDifficultyCalculator"] = {text = "Saw maniaChartDifficultyCalculator fail to calculate difficulty of a Song!"},
        ["left click"] = {text = "Pressed the Left Click button on the Mouse!"},
        ["30 seconds"] = {text = "Ran the game for at least 30 seconds!"},
        ["5 minutes"] = {text = "Ran the game for at least 5 minutes!"},
        ["paused"] = {text = "Paused for the first time!"},
        ["first error"] = {text = "Saw an error for the first time!"},
        ["fifth error"] = {text = "Saw an error for the fifth time!"},
    }

    self.achievementPopups = {}
end

function achievementHandler:update(dt)
end

function achievementHandler:unlockAchievment(achievement)
    for i,Achivement in pairs(self.achievements) do
        if achievement == i then
            if not achievement.unlocked then
                Achivement.unlocked = true
                table.insert(self.achievementPopups,achievementPopup(Achivement.text))
            end
        end
    end
end

function achievementHandler:draw()
    for i, AchievementPopup in ipairs(self.achievementPopups) do
        AchievementPopup:draw()
    end
end

return achievementHandler