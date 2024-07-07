local CreditsState = State()
--i like how in this whole game there are absolutely no useful comments at all
function CreditsState:enter()

    log("CreditsState Entered")
    selectedCredit = 1

    Credits = {
        {"CH", "Lead Programmer", "https://www.youtube.com/channel/UCR0avx7eHcQqn9fqYfcQUFQ"},
        {"GuglioIsStupid", "Rewrote Notes / added SV support", "https://ilovefemboys.org/"},  -- this is guglios real website link 💀💀
        {"Swan/The Quaver Team", "Quaver Map Format (not affiliated with Harmoni)", "https://quavergame.com/"},
        {"AM7999", "Github README", "https://github.com/am7999"},
        {"The Love2D Team", "Love2D", "https://www.love2d.org"},
        {"Sapple", "fortcock", "https://twitter.com/oldsockslott/status/1577437966288330753"},
    }

    Quotes = {
        "idk",
        "\n\n\n\n\n\nWishlist Rit on Steam!\n\n(this is the only one who i had to censor the quote)",
        "Quaver- The ultimate community-driven, and open-source competitive rhythm game available on Steam.\n\n\nnot related to Harmoni, but I'm crediting Quaver because Harmoni uses Quaver charts",
        "You know, README writing isn't hard",
        "Hi there! LÖVE is an *awesome* framework you can use to make 2D games in Lua. It's free, open-source, and works on Windows, macOS, Linux, Android, my balls, and iOS.",
        ""
    }
    guglioTimestamp = 1692216180



    guglioQuotes = {
        "Girlfriend lookin' real ***** with a whole in her head",
        "finally a mouth big enough",
        "You can find it on ******* just by searching 'cute goth boy ***** pumpkin on Halloween'",
        "I gotta get on my knees",
        "Water is almost as good as piss",
        "It's just his ***** that are huge, he has a small ****\nHis ***** are fucking massive",
        "I need some of that Quagmire ****",
        "Oh what I would do to just get a suckle of that ****",
        "AINT NO WAY GITHUB COPILOT JUST OPENED GANGNAM STYLE",
        "im gonna **** a basketball brb",
        "My **** hang",
        "I'm trying to find a video file, BUT I JUST KEEP GETTING KEVIN HART",
        "send me some fnf ***** pls",
        "17 when an act o iver rights as an source to the sea, T Le Maori people  -Guglio",
        "Bowser is smashable",
        "Foreskin gamer.",
        "I follow people everywhere",
        "I swear to god, if this window is homophobic Goku",
        "I already made out with you, it's too late",
        "11",
        "#WorshipTrump #TrumpXObamaFurryArt",
        "Y'all got any #TrumpXObamaFurryArt",
        "haiii!! :33 haii!! :3c",
        "Day " .. (guglioDays or "") .. " of pissing on my cat until Rit is finished", -- this quote must stay at the end of the table

    }



    SappleQuotes = {
        "No >:3\noops\nwrong emote",
        "This is how my balls talk to each other",
        "And then it smells like- like a spooky microwave!",
        "I have like 30 different pictures of Sonic feet\nI'm not lying by the way\nEvery day I've been getting more and more\nand now I have like 30",
        "It was like 3 meat, but if 3 meat was vegan, so 3 vegan",
        "You know how in the pistachio commercials there's that elephant that says \"touch my nuts\"? There's Sonic the Hedgehog",
        "There should be a SpongeBob episode where Mr. Krabs gets mad at SpongeBob and yells \"Mr. Squidward\" and then Squidward starts taking off his pants",
        "A doctor a day gives you a lemon that's gay",
        "It's so easy, its like giving cocaine to a baby",
        "I used to fuck microwaves",
        "more fish more fish more fish more fish more fish more fish more fish more fish more fish more fish",
        "I know there's actually some good games on here but whenever I search \"furry sex\" nothing shows up",
        "Holy fuck I forgot I favorited the Mario shaking his ass",
        "I woke up sitting criss-cross apple sauce and one thing led to another and then I was eating my toes",
        "Jesus after Taco Bell: \"holy shit\"",
        "I'm so tired I could fuck a horse",
        "i love scat its so hot",
        "nuh uh",
    }

    

    curSappleQuote = love.math.random(1,#SappleQuotes)

    SappleQuoteTween = {0}
    if not guglioQuoteTimer then
        self:chooseGuglioQuote()
    end
    if not SappleQuoteTimer then
        self:chooseSappleQuote()
    end
end

function CreditsState:chooseGuglioQuote()
    local oldGuglioQuote = curGuglioQuote
    local newGuglioQuote = love.math.random(1,#guglioQuotes)
    if newGuglioQuote == oldGuglioQuote then
        CreditsState:chooseGuglioQuote()
    else
        curGuglioQuote = newGuglioQuote
        guglioQuoteTween = {0}
        guglioQuoteTimer = Timer.tween(2, guglioQuoteTween, {1}, "linear", function()
            CreditsState:chooseGuglioQuote()
        end)
    end

end

function CreditsState:chooseSappleQuote()
    local oldSappleQuote = curSappleQuote
    local newSappleQuote = love.math.random(1,#SappleQuotes)

    local nuhUhOrQuote = love.math.random(1,12)


    if newSappleQuote == oldSappleQuote then
        CreditsState:chooseSappleQuote()
    else
        curSappleQuote = newSappleQuote
        SappleQuoteTween = {0}

        if nuhUhOrQuote ~= 1 then
            curSappleQuote = #SappleQuotes
        end
        SappleQuoteTimer = Timer.tween(1, SappleQuoteTween, {1}, "linear", function()
            CreditsState:chooseSappleQuote()
        end)
    end

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


    currentTimestamp = os.time()
    unconvertedDays = currentTimestamp - guglioTimestamp
    guglioMinutes = unconvertedDays / 60
    guglioHours = guglioMinutes / 60
    guglioDays = guglioHours / 24

    guglioQuotes[#guglioQuotes] = "Day " .. (string.format("%.5f", (guglioDays or 0))) .. " of pissing on my cat until Rit is finished"

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
            love.graphics.translate(-300,-20)
            for i = 1, #Credits do
                if i == selectedCredit then
                    love.graphics.setColor(selectedButtonFillColor)
                    love.graphics.rectangle("fill", Inits.GameWidth/2-200, 100*i, 400, 50, 7, 7, 50)
                    love.graphics.setColor(0,1,1,1)
                    love.graphics.printf(Credits[i][1], Inits.GameWidth/2-200, (100*i)+3 , 400, "center")
                    love.graphics.rectangle("line", Inits.GameWidth/2-200, 100*i, 400, 50, 7, 7, 50)
                else
                    love.graphics.setColor(nonSelectedButtonFillColor)
                    love.graphics.rectangle("fill", Inits.GameWidth/2-200, 100*i, 400, 50, 7, 7, 50)
                    love.graphics.setColor(selectedButtonFillColor)
                    love.graphics.printf(Credits[i][1], Inits.GameWidth/2-200, (100*i)+3 , 400, "center")
                    love.graphics.rectangle("line", Inits.GameWidth/2-200, 100*i, 400, 50, 7, 7, 50)
                end
            end
        love.graphics.pop()
        love.graphics.push()
        love.graphics.translate(-50,0)
            love.graphics.setColor(selectedButtonFillColor)

            love.graphics.rectangle("fill", 670, 100, 600, 50, 7, 7, 50)
            love.graphics.setColor(0,1,1,1)
            love.graphics.rectangle("line", 670, 100, 600, 50, 7, 7, 50)

            love.graphics.printf(Credits[selectedCredit][2], 670, 105, 600, "center")

            love.graphics.setColor(nonSelectedButtonFillColor)
            love.graphics.rectangle("fill", 670, 160, 600, 400, 7, 7, 50)
            love.graphics.setColor(0,1,1,1)
            love.graphics.rectangle("line", 670, 160, 600, 400, 7, 7, 50)
            love.graphics.setColor(0,0,0,1)

            if selectedCredit == 2 then
                love.graphics.printf(guglioQuotes[curGuglioQuote], 670, 165, 600, "center")
            elseif selectedCredit == 6 then
                love.graphics.printf(SappleQuotes[curSappleQuote], 670, 165, 600, "center")
            end
            love.graphics.printf(Quotes[selectedCredit], 670, 165, 600, "center")
            
            

        love.graphics.pop()
    love.graphics.pop()


end

return CreditsState