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
    self.sliders = {}
    self.toggles = {}

    self.tabs = {
        ["Gameplay"] = {
            id = 1,
            songRate = {isSetting = false, type = "number", min = 0.10, max = 3, value = 1, name = "Song Rate", sname = "SR", description = "How fast the song plays"},--added
            botPlay = {isSetting = false, type = "toggle", value = false, name = "Botplay", sname = "BP", description = "Watch a perfect replay of the song"},--added
            perfect = {isSetting = false, type = "select", options = {"Off", "Marvelous", "Perfect"}, name = "Perfect", sname = "PF", description = "Must hit only the selected Judgement or better"},
            suddenDeath = {isSetting = false, type = "toggle", value = false, name = "Sudden Death", sname = "SD", description = "Must not miss"}, --added
            scrollSpeed = {isSetting = true, type = "number", min = 300, max = 2000, value = convertScrollSpeed(Settings.scrollSpeed), name = "Scroll Speed", description = "Adjust your scroll speed"},
            windows = {isSetting = true, type = "button", name = "Windows", description = "Adjust your input timing windows"},
            noFail = {isSetting = false, type = "toggle", value = false, name = "No Fail", sname = "NF", description = "Can't lose, no matter what"},  --added
        },
        ["Conversion"] = {
            id = 2,
            mirror = {isSetting = false, type = "toggle", value = false, name = "Mirror", description = "Left becomes right, up becomes down"},
            randomize = {isSetting = false, type = "toggle", value = false, name = "Randomize", description = "Randomly swap the note lanes"},
            holdOff = {isSetting = false, type = "toggle", value = false, name = "Hold Off", description = "Turns all hold notes into normal notes"},
        },
        ["Fun"] = {
            id = 3,
            rampUp = {isSetting = false, type = "toggle", value = false, name = "Ramp Up", description = "The song starts at 0.8x speed and ramps up to 1.5x speed by the end"},
            waves = {isSetting = false, type = "toggle", value = false, name = "Waves", description = "The song rate gets faster and slower in waves"},
            fadeOut = {isSetting = false, type = "toggle", value = false, name = "Fade Out", description = "The notes fade out before reaching the receptors"},
            fadeIn = {isSetting = false, type = "toggle", value = false, name = "Fade In", description = "The notes fade in after spawning"},
            accRate = {isSetting = false, type = "toggle", value = false, name = "Accuracy Rate", description = "The song rate is whatever the accuracy is"},
        },
    }

    

    -- Sort tabs by their ids
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

    ModifiersMenu:updateObjects()
    if Input:pressed("menuClickLeft") then
        for i = 1, #self.tabButtons do
            if cursorX > self.tabButtons[i][2] and cursorX < self.tabButtons[i][2] + self.tabWidth then
                if cursorY > self.tabButtons[i][3] and cursorY < self.tabButtons[i][3] + self.tabHeight then
                    ModifiersMenu:setUpMenu(self.tabNames[i])
                end
            end
        end
    end

    
end
function ModifiersMenu:updateObjects()
    for key, Slider in pairs(self.sliders) do
        Slider:update()
        for _, tab in pairs(self.tabs) do
            local modifier = tab[key]
            if modifier and modifier.type == "number" then
                modifier.value = Slider:giveValue()
            end
        end
    end
    for key, Toggle in pairs(self.toggles) do
        Toggle:update()
        for _, tab in pairs(self.tabs) do
            local modifier = tab[key]
            if modifier and modifier.type == "toggle" then
                modifier.value = Toggle:giveValue()
            end
        end
    end
end

function ModifiersMenu:setUpMenu(menu)
    self.sliders = {}
    self.toggles = {}
    local objectNumber = 0
    local selectedTab = self.tabs[menu]
    for i, Modifier in pairs(selectedTab) do
        if i ~= "id" then
            objectNumber = plusEq(objectNumber)

            if Modifier.type == "number" then   -- make sure to not try to do anything with id
                self.sliders[i] = Objects.UI.Slider(self.x+30, self.y+50*objectNumber, self.width-60, Modifier.min, Modifier.max, Modifier.value, Modifier.name, Modifier.description)
            elseif Modifier.type == "toggle" then
                self.toggles[i] = Objects.UI.Toggle(self.x+30, self.y+50*objectNumber, self.width-60, 40, Modifier.value, Modifier.name, Modifier.description)
            end
        end
    end
end

function ModifiersMenu:configureMods()
    for Key, Tab in pairs(self.tabs) do
        for Key1, Modifier in pairs(Tab) do
            if Key1 ~= "id" then
                print(Key1 .. ": " .. tostring(Modifier.value))
                Mods[Key1] = Modifier.value
            end
        end
    end
    Settings.scrollSpeed = convertScrollSpeed(Mods.scrollSpeed)
end


function ModifiersMenu:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(0, 0, 0)
    for i = 1, #self.tabButtons do
        love.graphics.rectangle("line", self.tabButtons[i][2], self.tabButtons[i][3], self.tabWidth, self.tabHeight)
        love.graphics.printf(self.tabNames[i], self.tabButtons[i][2], self.tabButtons[i][3], self.tabWidth, "center")
    end
    for i, Slider in pairs(self.sliders) do
        Slider:draw()
    end
    for i, Toggle in pairs(self.toggles) do
        Toggle:draw()
    end
    love.graphics.setColor(1, 1, 1)
end

return ModifiersMenu
