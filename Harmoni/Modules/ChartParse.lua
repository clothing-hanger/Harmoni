function quaverParse(file)
    
    if not love.filesystem.getInfo(file, "file") then
        notification("Chart File Not Found!", notifErrorIcon)
        log("Chart File Not Found For Song " .. selectedSong)
        return false
    end


    
    
    print("quaverParse()")
    -- huge credits to https://github.com/AGORI-Studios/Rit for this part
        chart = tinyyaml.parse(love.filesystem.read(file))
        lanes = {}
        timingPointsTable = {}
        scrollVelocities = {}
        totalNoteCount = 0
        holdNoteCount = 0
        for i = 1,7 do
            table.insert(lanes, {})
        end
        banner = nil
        metaData = {
            name = chart.Title,
            song = chart.AudioFile,
            artist = chart.Artist,
            source = chart.Source, -- not sure what this one even is really
            tags = chart.Tags, -- not gonna be used in this file but im putting it here for now so i dont forget it
            diffName = chart.DifficultyName,
            creator = chart.Creator,
            background = chart.BackgroundFile,
            banner = chart.BannerFile or nil,
            previewTime = (chart.SongPreviewTime or 0) / Modifiers[2], -- also wont be used here
            noteCount = 0,
            length = 0,
            bpm = 0,
            inputMode = chart.Mode:gsub("Keys", ""),  -- will be used to make sure its 4 key
        }
        

        

        if love.filesystem.getInfo("Music/" .. songList[selectedSong] .. "/" .. metaData.song, "file") then
            song = love.audio.newSource("Music/" .. songList[selectedSong] .. "/" .. metaData.song, "stream")
        else
            notification("Audio Failed to Load! Chart Loading Cancelled.", notifErrorIcon)
            log("Audio File Not Found For Song " .. selectedSong)
            return
        end


        if love.filesystem.getInfo("Music/" .. songList[selectedSong] .. "/" .. metaData.background, "file") then
            background = love.graphics.newImage("Music/" .. songList[selectedSong] .. "/" .. metaData.background)
        else
            notification("Background Failed to Load! Incorrect Background Will be Displayed.", notifErrorIcon)
            log("Background File Not Found For Song " .. selectedSong)

        end


        if tostring(metaData.inputMode) == "7" then
            sevenKey = true
        else
            fourKey = true
        end
        if tostring(metaData.inputMode) == "7" then
            notification("7 Key Not Supported! (yet)", notifErrorIcon)
            return false
        end
       -- if metaData.banner and love.filesystem.getInfo("Music/" .. songList[selectedSong] .. "/" .. metaData.banner) then           this works but it looks ugly so i just commented out this
       --     banner = love.graphics.newImage("Music/" .. songList[selectedSong] .. "/" .. metaData.banner)
       --     print("Banner")
       -- end
        firstNoteTime = nil

        initialScrollVelocity = chart.initialScrollVelocity or 1


        for i = 1,#chart.TimingPoints do    -- ?????? why does this not work 😭😭😭😭          why did i type this it literally does work??
            local timingPoint = chart.TimingPoints[i]
            local startTime = timingPoint.StartTime
            local bpm = (timingPoint.Bpm or 0) / Modifiers[2]
            table.insert(timingPointsTable, {startTime, bpm})
            -- if bpm and startTime then 
                --print(" TimingPoint " ..bpm .. "    " .. startTime)
            -- end 

            if i == 1 then
                metaData.bpm = timingPoint.Bpm / Modifiers[2]
                --print(timingPoint.Bpm)
            end
        end
    

        for i = 1,#chart.HitObjects do
            local hitObject = chart.HitObjects[i]
            local startTime = (hitObject.StartTime or 0) --/ Modifiers[2]
            if not startTime then goto continue end
            local endTime = hitObject.EndTime or 0
            local lane = hitObject.Lane

            totalNoteCount = totalNoteCount + 1
            if endTime > 0 then
                holdNoteCount = holdNoteCount + 1
            end


            if Modifiers[4] then
            	lane = 5 - lane
            end

            local note = Objects.Game.Note(startTime, lane, endTime)
            table.insert(lanes[lane], note)
            
            if not firstNoteTime and startTime then
                firstNoteTime = math.floor(startTime*0.0001)
                print("first note time: ".. firstNoteTime)
            end
            
            lastNoteTime = startTime -- this should work because the last time its run will be the last note      
            ::continue::
        end
        

        for i = 1, #chart.SliderVelocities do
            local velocity = chart.SliderVelocities[i]
            local startTime = (velocity.StartTime or 0) / Modifiers[2]
            local velocityChange = velocity.Multiplier

            

            table.insert(scrollVelocities, {startTime = startTime, multiplier = velocityChange})
        end
 
        print("Total Note Count: ".. totalNoteCount)
        songLength = song:getDuration()
        print(songLength)
        songLengthToLastNote = lastNoteTime*0.001
        bestScorePerNote = 1000000/(#lanes[1]+#lanes[2]+#lanes[3]+#lanes[4])
        holdNotePercent = math.ceil((holdNoteCount / totalNoteCount)*100)

        currentBpm = metaData.bpm
        if currentBpm then
	        print("BPM: "..currentBpm)
        end
    return true
end



function harmoniParse(file) -- don't use this
    log("why did this code run lmfao")
    chart = love.filesystem.load(file)()
    bestScorePerNote = 1000000/#chart

    for i = 1,#chart do
        table.insert(lanes[chart[i][2]], chart[i][1])
    end

    song = love.audio.newSource("Music/" .. songList[selectedSong] .. "/audio.mp3", "stream")
    background = love.graphics.newImage("Music/" .. songList[selectedSong] .. "/background.jpg")
    songLength = song:getDuration()
    songLengthToLastNote = lastNoteTime/1000
    lastNoteTime = chart[#chart][1]
end