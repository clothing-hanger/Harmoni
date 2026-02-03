local maniaJudgementCount = Class:extend("maniaJudgementCount")
local args
function maniaJudgementCount:new(args) -- i like table arguments so much more why didnt i do shit this way sooner
    if not args then args = {};--[[ GlobalNotificationsHandler:addNotification("you forgot something lmao", "error")--]] end
    self.x = args.x or 0
    self.y = args.y or 0 
    self.jiggle = args.jiggle or 10
    self.spacing = args.spacing or 10
    self.cornerRadius = args.cornerRadius or 10
    self.squareHeight = args.squareHeight or 50
    self.height = args.height or baseScreenRatio.y
    self.judgements = {}

    self.height = SkinHandler:getParam("Judgement Count Height")
    self.x,self.y = SkinHandler:getParam("Judgement Count X"), SkinHandler:getParam("Judgement Count Y")
    self.squareHeight = SkinHandler:getParam("Judgement Count Square Height")
    self.squareWidth = SkinHandler:getParam("Judgement Count Square Width")

    self.font = SkinHandler:getFont("Judgement Counter", 60)

end

function maniaJudgementCount:sendJudgements(judgements)
    for i, Judgement in ipairs(judgements) do
        -- we gotta figure out the y position of each of these thingies
        local spacing = self.height/6 -- there are obviously only ever 6 judgements so its safe to hardcode this
        local middleOfSquareThingy = spacing*(i)
        
        local x,y = self.x,(middleOfSquareThingy-self.squareHeight/2-spacing/2)+self.y
        local width,height = self.squareWidth,self.squareHeight

        local color = SkinHandler:getParam(Judgement.name .. " Color")
        print(Judgement.name .. " Color",color[1])
        table.insert(self.judgements,{color = color, name = Judgement.name, shortName = Judgement.short, count = 0, x = x, y = y, width = width, height = height, liquidAssWidth = 0, liquidAssHeight = 0, liquidAssTextWidth = 1, liquidAssTextHeight = 1})
    end
end

function maniaJudgementCount:incrementJudgement(judgement)
    for i, Judgement in ipairs(self.judgements) do
        if Judgement.name == judgement then
            Judgement.count = Judgement.count+1
            self:liquidAss(Judgement)
            break
        end
    end
end

function maniaJudgementCount:liquidAss(judgement)
    if judgement.tween then Timer.cancel(judgement.tween) end
    judgement.liquidAssWidth = 30
    judgement.liquidAssHeight = -20

    judgement.liquidAssTextWidth = 1.3
    judgement.liquidAssTextHeight  = 0.9
    judgement.tween = Timer.tween(1, judgement, {liquidAssWidth = 0, liquidAssHeight = 0, liquidAssTextWidth = 1, liquidAssTextHeight = 1}, "out-elastic")
end

function maniaJudgementCount:update(dt)
    
end

function maniaJudgementCount:draw()
    for i, Judgement in ipairs(self.judgements) do


        love.graphics.setColor(1,1,1,0.3)
        local x = Judgement.x-Judgement.liquidAssWidth/2
        local y = Judgement.y-Judgement.liquidAssHeight/2
        local width = Judgement.width+Judgement.liquidAssWidth
        local height = Judgement.height+Judgement.liquidAssHeight
        love.graphics.rectangle("fill", x, y, width, height, 12, 12, 10)

        if Judgement.color then love.graphics.setColor(Judgement.color) else love.graphics.setColor(1,0,0) end

        local x = Judgement.x-Judgement.liquidAssWidth/2
        local y = Judgement.y-self.font:getHeight()/2+self.squareHeight/2
        local limit = Judgement.width+Judgement.liquidAssWidth
        love.graphics.printf(Judgement.count, x, y, Judgement.width+Judgement.liquidAssWidth, "center", nil, Judgement.liquidAssTextWidth, Judgement.liquidAssTextHeight)

    end
        love.graphics.setColor(1,1,1,1)

end

return maniaJudgementCount