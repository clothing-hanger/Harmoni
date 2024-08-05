function InitializeGame() 
      -- eventually most of the stuff above and inside of love.load() main will be moved here                     no it wont lmao
end
marvTiming = 23
perfTiming = 40
greatTiming = 74
goodTiming = 103
okayTiming = 127
missTiming = 160



function initFreakyMode()
      fontDosis65 = love.graphics.newFont("Fonts/papyrus.ttf", 65)
      fontDosis60 = love.graphics.newFont("Fonts/papyrus.ttf", 60)
      fontDosis45 = love.graphics.newFont("Fonts/papyrus.ttf", 45)
      fontPoland150 = love.graphics.newFont("Fonts/papyrus.ttf", 150)
      fontPoland50 = love.graphics.newFont("Fonts/papyrus.ttf", 50)
      MediumFont = love.graphics.newFont("Fonts/papyrus.ttf", 50)
      MediumFontSolid = love.graphics.newFont("Fonts/papyrus.ttf", 25)
      MediumFontBacking = love.graphics.newFont("Fonts/papyrus.ttf", 50)
      MenuFontBig = love.graphics.newFont("Fonts/papyrus.ttf", 30)
      MenuFontSmall = love.graphics.newFont("Fonts/papyrus.ttf", 20)
      MenuFontExtraSmall = love.graphics.newFont("Fonts/papyrus.ttf", 16)
      NotificationFont = love.graphics.newFont("Fonts/papyrus.ttf", 14)
      MenuFontExtraBig = love.graphics.newFont("Fonts/papyrus.ttf", 50)
      DefaultFont = love.graphics.newFont("Fonts/papyrus.ttf", 12)

      versionNumber = "Freakoni Beta 2.5"

      love.window.setTitle(versionNumber)
      love.window.setIcon(love.image.newImageData("Images/ICONS/tongue.png"))

      Modifiers[2] = 0.75

end
