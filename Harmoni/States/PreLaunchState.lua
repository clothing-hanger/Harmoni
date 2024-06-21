local PreLaunchState = State()

function PreLaunchState:enter()
    log("PreLaunchState Entered")
    logo = love.graphics.newImage("Images/TITLE/logo.png")
    loading = love.graphics.newImage("Images/SHARED/loading.png")
    preLaunchFade = {1}
    loadingAngle = {0}
    pastPreLaunch = false
    songList = love.filesystem.getDirectoryItems("Music")
    loadingString = "Loading...   0/" .. #songList
    loadingEasterEggs = {
        "Harmoni runs on hamsters running in little wheels, this might take a while.",
        "lmao imagine cancelling a game",
        "delete the game it would be funny i think",
    }
    if love.math.random(0,2000) == 0 then
        loadingEasterEggs = {
            "my penis and my balls",
            "Sonisc pean its",
        }
    end

    
    loadingEasterEgg = loadingEasterEggs[love.math.random(1,#loadingEasterEggs)]

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
    metaFileFound = false
      --  for i = #songNamesTable + 1, math.min(#songNamesTable + 10, #songList) do
            diffListQ = {}
            diffListAndOtherShitIdfkQ = love.filesystem.getDirectoryItems("Music/" .. songList[frame] .. "/")
            for q = 1,#diffListAndOtherShitIdfkQ do 

                local file = diffListAndOtherShitIdfkQ[q]
                if file:endsWith("qua") then
                    table.insert(diffListQ, file)
                end

                if file == "meta.lua" then
                    metaFileFound = true
                end
            end 
           -- print(songList[i])
          --  print(diffListQ[1])
        -- print("Music/" .. songList[i] .. "/" .. diffListQ[1])
            if songList[frame] and diffListQ[1] and love.filesystem.getInfo("Music/" .. songList[frame] .. "/" .. diffListQ[1], "file") then
            --    print("found")
                if metaFileFound then
                    songName = love.filesystem.load("Music/" .. songList[frame] .. "/" .."meta.lua")()
                    table.insert(songNamesTable, frame, songName)
                else
                    chart = tinyyaml.parse(love.filesystem.read("Music/" .. songList[frame] .. "/" .. diffListQ[1]))
                    love.filesystem.write("Music/" .. songList[frame] .. "/" .."meta.lua", "return " .. "\"" .. chart.Title .."\"")
                    table.insert(songNamesTable, frame, chart.Title)
                end
            else
             --   print("not found")
                table.insert(songNamesTable, frame, "This song's data is corrupt!")
                log("Song processed on frame " .. frame .. " is corrupted.")


                recursivelyDelete("Music/" .. songList[frame])

                table.remove(songNamesTable, frame)
                table.remove(songList, frame)
            end

            loadingString = "Loading...   " .. #songNamesTable .."/" .. #songList

        
      --  end

    if #songNamesTable == #songList then
        pastPreLaunch = true
        wipeFade("in")
        State.switch(States.TitleState)

    end

end

function PreLaunchState:draw() 
    love.graphics.setColor(1,1,1,preLaunchFade[1])
    love.graphics.translate(0, -(preLaunchFade[1]*50))

    love.graphics.draw(logo, (Inits.GameWidth/2)-(logo:getWidth()/2), (Inits.GameHeight/2-logo:getHeight()/2)-80)
    love.graphics.draw(loading, Inits.GameWidth - 100, Inits.GameHeight - 50, math.rad(loadingAngle[1]), 0.5, 0.5, loading:getWidth()/2, loading:getHeight()/2)
    love.graphics.print(loadingString, Inits.GameWidth - 265, Inits.GameHeight - 50)
    love.graphics.setFont(MenuFontBig)
    love.graphics.printf("Hang tight, Harmoni is processing your songs. \n This could take a little longer if the song has never been processed before. \n(Grey bar means the song is being first-time processed)\n\n " .. loadingEasterEgg, Inits.GameWidth/2-600, Inits.GameHeight/2, 1200, "center")
   -- love.graphics.printf(#songNamesTable/#songList, Inits.GameWidth/2-500, Inits.GameHeight/2, 1000, "center")
   if metaFileFound then
    love.graphics.setColor(1,1,1)
   else
    love.graphics.setColor(1,1,1,0.3)
   end
    love.graphics.rectangle("fill", 0, Inits.GameHeight+10, Inits.GameWidth * (#songNamesTable/#songList), 30)

    
end

return PreLaunchState