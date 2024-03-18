local PreLaunchState = State()

function PreLaunchState:enter()
    logo = love.graphics.newImage("Images/TITLE/logo.png")
    loading = love.graphics.newImage("Images/SHARED/loading.png")
    loadingString = "Loading..."
    preLaunchFade = {1}
    loadingAngle = {0}
    songList = love.filesystem.getDirectoryItems("Music")
    songNamesTable = {}
    frame = 0


        --[[
    Timer.tween(0.5, loadingAngle, {360}, "out-quad")
    Timer.tween(0.5, preLaunchFade, {1}, "out-quad", function()



        loadSongNames()


        Timer.after(2.5, function()
            Timer.tween(0.5, loadingAngle, {0}, "out-quad")
            loadingString = "Loaded!"
            Timer.tween(0.5, preLaunchFade, {0}, "out-quad", function()
                if not skippedSplash then
                    
                end
            end)
        end)
    end)
--]]
    
end

function loadSongNames()

end

function PreLaunchState:update(dt)

    frame = frame + 1
 
      --  for i = #songNamesTable + 1, math.min(#songNamesTable + 10, #songList) do
            diffListQ = {}
            diffListAndOtherShitIdfkQ = love.filesystem.getDirectoryItems("Music/" .. songList[frame] .. "/")
            for q = 1,#diffListAndOtherShitIdfkQ do 
                local file = diffListAndOtherShitIdfkQ[q]
                if file:endsWith("qua") then
                    table.insert(diffListQ, file)
                end
            end 
           -- print(songList[i])
          --  print(diffListQ[1])
        -- print("Music/" .. songList[i] .. "/" .. diffListQ[1])
            if songList[frame] and diffListQ[1] and love.filesystem.getInfo("Music/" .. songList[frame] .. "/" .. diffListQ[1], "file") then
            --    print("found")
                chart = tinyyaml.parse(love.filesystem.read("Music/" .. songList[frame] .. "/" .. diffListQ[1]))
                table.insert(songNamesTable, frame, chart.Title)
            else
             --   print("not found")
                table.insert(songNamesTable, frame, "This song's data is corrupt! Open at your own risk.")
            end
        
      --  end

    if #songNamesTable == #songList then
        State.switch(States.TitleState)

    end


    if Input:pressed("MenuConfirm") then
      --  skippedSplash = true        
       -- State.switch(States.TitleState)
    end
end

function PreLaunchState:draw() 
    love.graphics.setColor(1,1,1,preLaunchFade[1])
    love.graphics.translate(0, -(preLaunchFade[1]*50))

    love.graphics.draw(logo, (Inits.GameWidth/2)-(logo:getWidth()/2), (Inits.GameHeight/2-logo:getHeight()/2)-80)
    love.graphics.draw(loading, Inits.GameWidth - 100, Inits.GameHeight - 50, math.rad(loadingAngle[1]), 0.5, 0.5, loading:getWidth()/2, loading:getHeight()/2)
    love.graphics.print(loadingString, Inits.GameWidth - 200, Inits.GameHeight - 50)
    love.graphics.setFont(MenuFontBig)
    love.graphics.printf("Harmoni is still in early beta, please report any bugs you find on the GitHub, and consider donating to help development", Inits.GameWidth/2-500, Inits.GameHeight/2, 1000, "center")
   -- love.graphics.printf(#songNamesTable/#songList, Inits.GameWidth/2-500, Inits.GameHeight/2, 1000, "center")
    love.graphics.rectangle("fill", 0, Inits.GameHeight+10, Inits.GameWidth * (#songNamesTable/#songList), 30)

    
end

return PreLaunchState