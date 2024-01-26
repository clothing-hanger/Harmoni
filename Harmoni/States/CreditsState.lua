local CreditsState = State()

function CreditsState:enter()

    selectedCredit = 1

    Credits = {
        {"c l o t h i n g h a n g e r", "Lead Programmer", "PLACEHOLDER"},
        {"GuglioIsStupid", "Love2D Project Template, Support", "PLACEHOLDER"},
        {"Swan", "Quaver Map Format", "PLACEHOLDER"},
        {"AM7999", "Github README", "PLACEHOLDER"},
        {"The Love2D Team", "Love2D", "https://www.love2d.org"},
    }

    Quotes = {
        "PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER",
        "PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER",
        "PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER",
        "PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER",
        "PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER PLACEHOLDER",
    }

end

function CreditsState:update(dt)
    if Input:pressed("MenuUp") then
        selectedCredit = selectedCredit - 1
    elseif Input:pressed("MenuDown") then
        selectedCredit = selectedCredit + 1
    elseif Input:pressed("MenuBack") then
        State.switch(States.TitleState)
    elseif Input:pressed("MenuConfirm") then
        love.system.openURL(Credits[selectedCredit][3])
    end


    if selectedCredit > #Credits then
        selectedCredit = 1
    elseif selectedCredit < 1 then
        selectedCredit = #Credits
    end
end

function CreditsState:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(background, Inits.GameWidth/2, Inits.GameHeight/2, nil, Inits.GameWidth/background:getWidth()+(logoSize-1)/6,Inits.GameHeight/background:getHeight()+(logoSize-1)/6, background:getWidth()/2, background:getHeight()/2)
    love.graphics.setColor(0,0,0,Gameplay[4][2])
    love.graphics.rectangle("fill", 0, 0, Inits.GameWidth, Inits.GameHeight)
    love.graphics.setFont(MenuFontBig)
    love.graphics.push()
    love.graphics.translate(-40,0)
        love.graphics.push()
            love.graphics.translate(-300,0)
            for i = 1, #Credits do
                if i == selectedCredit then
                    love.graphics.setColor(0,0,0,0.9)
                    love.graphics.rectangle("fill", Inits.GameWidth/2-200, 100*i, 400, 50)
                    love.graphics.setColor(0,1,1,1)
                    love.graphics.printf(Credits[i][1], Inits.GameWidth/2-200, (100*i)+3 , 400, "center")
                    love.graphics.rectangle("line", Inits.GameWidth/2-200, 100*i, 400, 50)
                else
                    love.graphics.setColor(1,1,1,0.9)
                    love.graphics.rectangle("fill", Inits.GameWidth/2-200, 100*i, 400, 50)
                    love.graphics.setColor(0,0,0,0.9)
                    love.graphics.printf(Credits[i][1], Inits.GameWidth/2-200, (100*i)+3 , 400, "center")
                    love.graphics.rectangle("line", Inits.GameWidth/2-200, 100*i, 400, 50)
                end
            end
        love.graphics.pop()
        love.graphics.push()
        love.graphics.translate(-50,0)
            love.graphics.setColor(0,0,0,0.9)

            love.graphics.rectangle("fill", 670, 100, 600, 50)
            love.graphics.setColor(0,1,1,1)
            love.graphics.rectangle("line", 670, 100, 600, 50)

            love.graphics.printf(Credits[selectedCredit][2], 670, 105, 600, "center")

            love.graphics.setColor(1,1,1,0.9)
            love.graphics.rectangle("fill", 670, 160, 600, 400)
            love.graphics.setColor(0,1,1,1)
            love.graphics.rectangle("line", 670, 160, 600, 400)
            love.graphics.setColor(0,0,0,1)

            love.graphics.printf(Quotes[selectedCredit], 670, 165, 600, "center")

        love.graphics.pop()
    love.graphics.pop()


end

return CreditsState