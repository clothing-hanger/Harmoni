local maniaJudgementCount = Class:extend("maniaJudgementCount")
local args
function maniaJudgementCount:new(args) -- i like table arguments so much more why didnt i do shit this way sooner
    if not args then args = {}; GlobalNotificationsHandler:addNotification("you forgot something lmao", "error") end
    self.x = args.x or 0
    self.y = args.y or 0 
    self.jiggle = args.jiggle or 10
    self.spacing = args.spacing or 10
    self.cornerRadius = args.cornerRadius or 10
    self.squareWidth = args.squareWidth or 50
    self.height = args.height or baseScreenRatio.y
    self.judgemtnbtbsnnsfjjrthsjdfhhdfjkshsdfkjsaklhfdjfsdlgkhjgsfhkljd = {}
end

function maniaJudgementCount:sendJudgements(judgements)
    for i, Judgement in ipairs(judgements) do
        -- we gotta figure out the y position of each of these thingies
        local spacing = self.height/6 -- there are obviously only ever 6 judgements so its safe to hardcode this
        local middleOfSquareThingy = spacing*(i-1)
        
        local x,y = self.x,middleOfSquareThingy-self.squareWidth/2
        local width,height = self.squareWidth,self.squareWidth

        self.judgemtnbtbsnnsfjjrthsjdfhhdfjkshsdfkjsaklhfdjfsdlgkhjgsfhkljd[Judgement.name] = {count = Judgement.count, x = x, y = y, width = width, height = height}

        table.insert({name = Judgement.name, shortName = Judgement.short, count = Judgement.count, x = x, y = y, width = width, height = height})
    end
end

function maniaJudgementCount:update(dt)
end

function maniaJudgementCount:draw()
    for i, Judgement in ipairs(self.judgemtnbtbsnnsfjjrthsjdfhhdfjkshsdfkjsaklhfdjfsdlgkhjgsfhkljd) do
        love.graphics.rectangle("line", Judgement.x, Judgement.y, Judgement.width, Judgement.height)
    end
end

return maniaJudgementCount