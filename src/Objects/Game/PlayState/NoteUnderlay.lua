
--@class NoteUnderlay
local NoteUnderlay = Class:extend()

function NoteUnderlay:new(lanes)
    self.width = (Settings.laneWidth*lanes)+30 -- add 30 to width for padding (double the amount we subtract)       might make padding skinable later? idk
    self.height = Inits.GameHeight
    self.x,self.y = (Inits.GameWidth/2-((lanes/2)*Settings.laneWidth))-15,0  -- subtract 15 from X for padding
    self.alpha = Settings.noteUnderlay * 0.01
    self.color = Skin.Params["Note Underlay Color"]

    
    table.insert(self.color, self.alpha)
end

function NoteUnderlay:update(dt)
end

function NoteUnderlay:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return NoteUnderlay