function quaverParse(file)
    
    if not love.filesystem.getInfo(file, "file") then
        print("Chart File Not Found!", notifErrorIcon)
        print("Chart File Not Found For Song " .. SelectedSong)
        return false
    end


    
    
    print("quaverParse(" .. file .. ")")
    -- huge credits to https://github.com/AGORI-Studios/Rit for this part
        chart = Tinyyaml.parse(love.filesystem.read(file))
        lanes = {}
        timingPointsTable = {}
        scrollVelocities = {}
        totalNoteCount = 0
        holdNoteCount = 0
        for i = 1,4 do
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
            previewTime = (chart.SongPreviewTime or 0), --/ Modifiers[2], -- also wont be used here
            noteCount = 0,
            length = 0,
            bpm = 0,
            inputMode = chart.Mode:gsub("Keys", ""),  -- will be used to make sure its 4 key
        }
        

        

        if love.filesystem.getInfo("Music/" .. SongList[SelectedSong] .. "/" .. metaData.song, "file") then
            Song = love.audio.newSource("Music/" .. SongList[SelectedSong] .. "/" .. metaData.song, "stream")
        else
            print("Audio Failed to Load! Chart Loading Cancelled.", notifErrorIcon)
            print("Audio File Not Found For Song " .. SelectedSong)
            return
        end


        if love.filesystem.getInfo("Music/" .. SongList[SelectedSong] .. "/" .. metaData.background, "file") then
            background = love.graphics.newImage("Music/" .. SongList[SelectedSong] .. "/" .. metaData.background)
        else
            print("Background Failed to Load! Incorrect Background Will be Displayed.", notifErrorIcon)
            print("Background File Not Found For Song " .. SelectedSong)

        end


        if tostring(metaData.inputMode) == "7" then
            sevenKey = true
        else
            fourKey = true
        end
        if tostring(metaData.inputMode) == "7" then
            print("7 Key Not Supported! (yet) (nevermind it never will be lmao)", notifErrorIcon)
            return false
        end
       -- if metaData.banner and love.filesystem.getInfo("Music/" .. SongList[SelectedSong] .. "/" .. metaData.banner) then           this works but it looks ugly so i just commented out this
       --     banner = love.graphics.newImage("Music/" .. SongList[SelectedSong] .. "/" .. metaData.banner)
       --     print("Banner")
       -- end
        firstNoteTime = nil

        initialScrollVelocity = chart.initialScrollVelocity or 1


        for i = 1,#chart.TimingPoints do    -- ?????? why does this not work 😭😭😭😭          why did i type this it literally does work??
            local timingPoint = chart.TimingPoints[i]
            local startTime = timingPoint.StartTime
            local bpm = (timingPoint.Bpm or 0)-- / Modifiers[2]
            table.insert(timingPointsTable, {startTime, bpm})
            if bpm and startTime then
                --print(" TimingPoint " ..bpm .. "    " .. startTime)
            end

            if i == 1 then
                metaData.bpm = timingPoint.Bpm --/ Modifiers[2]
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

            --[[
            if Modifiers[4] then
                if lane == 1 then
                    lane = 4
                elseif lane == 2 then
                    lane = 3
                elseif lane == 3 then
                    lane = 2
                else
                    lane = 1
                end
            end
--]]
            local note = Objects.Game.Note(lane, startTime, endTime)
            table.insert(lanes[lane], note)
            
            if not firstNoteTime and startTime then
                firstNoteTime = math.floor(startTime/1000)
                print("first note time: ".. firstNoteTime)
            end
            
            lastNoteTime = startTime -- this should work because the last time its run will be the last note      
            ::continue::
        end
        

        for i = 1, #chart.SliderVelocities do
            local velocity = chart.SliderVelocities[i]
            local startTime = (velocity.StartTime or 0) --/ Modifiers[2]
            local velocityChange = velocity.Multiplier

            

            table.insert(scrollVelocities, {startTime = startTime, multiplier = velocityChange})
        end
 
        print("Total Note Count: ".. totalNoteCount)
        songLength = Song:getDuration()
        print(songLength)
        songLengthToLastNote = lastNoteTime/1000
        bestScorePerNote = 1000000/(#lanes[1]+#lanes[2]+#lanes[3]+#lanes[4])
        holdNotePercent = math.ceil((holdNoteCount / totalNoteCount)*100)

        currentBpm = metaData.bpm
        if currentBpm then
        print("BPM: "..currentBpm)
        end
    return true
end