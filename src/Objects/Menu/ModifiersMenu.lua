local ModifiersMenu = Class:extend()

function ModifiersMenu:new()
    self.width = 500
    self.height = Inits.GameHeight - 250
    self.x = 0
    self.y = 240
    self.selectedTab = 1
    self.tabWidth = 160
    self.tabHeight = 30
    self.tabButtons = {}
    self.tabNames = {}

    self.tabs = {
        ["Gameplay"] = {
            id = 1,
            songRate = {isSetting = false, type = "number", min = 0.5, max = 2, value = 1, name = "Song Rate", sname = "SR", description = "How fast the song plays"},
            botPlay = {isSetting = false, type = "boolean", value = false, name = "Botplay", sname = "BP", description = "Watch a perfect replay of the song"},
            perfect = {isSetting = false, type = "select", options = {"Off", "Marvelous", "Perfect"}, name = "Perfect", sname = "PF", description = "Must hit only the selected Judgement or better"},
            suddenDeath = {isSetting = false, type = "boolean", value = false, name = "Sudden Death", sname = "SD", description = "Must not miss"},
            scroll = {isSetting = true, type = "number", min = 100, max = 10000, name = "Scroll Speed", description = "Adjust your scroll speed"},
            windows = {isSetting = true, type = "button", name = "Windows", description = "Adjust your input timing windows"},
        },
        ["Conversion"] = {
            id = 2,
            mirror = {isSetting = false, type = "boolean", value = false, name = "Mirror", description = "Left becomes right, up becomes down"},
            randomize = {isSetting = false, type = "boolean", value = false, name = "Randomize", description = "Randomly swap the note lanes"},
            holdOff = {isSetting = false, type = "boolean", value = false, name = "Hold Off", description = "Turns all hold notes into normal notes"},
        },
        ["Fun"] = {
            id = 3,
            rampUp = {isSetting = false, type = "boolean", value = false, name = "Ramp Up", description = "The song starts at 0.8x speed and ramps up to 1.5x speed by the end"},
            waves = {isSetting = false, type = "boolean", value = false, name = "Waves", description = "The song rate gets faster and slower in waves"},
            fadeOut = {isSetting = false, type = "boolean", value = false, name = "Fade Out", description = "The notes fade out before reaching the receptors"},
            fadeIn = {isSetting = false, type = "boolean", value = false, name = "Fade In", description = "The notes fade in after spawning"},
            accRate = {isSetting = false, type = "boolean", value = false, name = "Accuracy Rate", description = "The song rate is whatever the accuracy is"},
        },
    }

    -- Sort tabs by id and store in self.tabNames
    local sortedTabs = {}
    for name, tab in pairs(self.tabs) do
        table.insert(sortedTabs, {name = name, id = tab.id})
    end
    table.sort(sortedTabs, function(a, b) return a.id < b.id end)

    for _, tab in ipairs(sortedTabs) do
        table.insert(self.tabNames, tab.name)
    end

    for i = 1, #self.tabNames do
        local tabX = (((self.width / #self.tabNames) * i) - ((self.width / #self.tabNames) / 2)) + self.x
        local tabY = 10 + self.y
        table.insert(self.tabButtons, {self.tabNames[i], tabX - (self.tabWidth / 2), tabY})
        print(self.width / #self.tabNames)
    end
end

function ModifiersMenu:update(dt)
    if Input:pressed("menuClickLeft") then
        for i = 1, #self.tabButtons do
            if cursorX > self.tabButtons[i][2] and cursorX < self.tabButtons[i][2] + self.tabWidth then
                if cursorY > self.tabButtons[i][3] and cursorY < self.tabButtons[i][3] + self.tabHeight then
                    print(i)
                end
            end
        end
    end
end

function ModifiersMenu:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(0, 0, 0)
    for i = 1, #self.tabButtons do
        love.graphics.rectangle("line", self.tabButtons[i][2], self.tabButtons[i][3], self.tabWidth, self.tabHeight)
        love.graphics.printf(self.tabNames[i], self.tabButtons[i][2], self.tabButtons[i][3], self.tabWidth, "center")
    end
    love.graphics.setColor(1, 1, 1)
end

return ModifiersMenu
