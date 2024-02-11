function quaverParse(file)
    
    if not love.filesystem.getInfo(file) then
        love.window.showMessageBox("Chart not loaded", "The chart failed to load. sorry lmao i suck at coding", "error")
        return 
    end
    
    print("quaverParse()")
    -- huge credits to https://github.com/AGORI-Studios/Rit for this part
        chart = tinyyaml.parse(love.filesystem.read(file))
        lanes = {}
        for i = 1,4 do
            table.insert(lanes, {})
        end
        metaData = {
            name = chart.Title,
            song = chart.AudioFile,
            artist = chart.Artist,
            source = chart.Source, -- not sure what this one even is really
            tags = chart.Tags, -- not gonna be used in this file but im putting it here for now so i dont forget it
            diffName = chart.DifficultyName,
            creator = chart.Creator,
            background = chart.BackgroundFile,
            previewTime = chart.SongPreviewTime or 0, -- also wont be used here
            noteCount = 0,
            length = 0,
            bpm = 0,   -- idk if ill ever use bpm 😭😭 idk how it works
            inputMode = chart.Mode:gsub("Keys", ""),  -- will be used to make sure its 4 key
        }

        if tostring(metaData.inputMode) == "7" and curScreen ~= "songSelect" then
            love.window.showMessageBox("Unsupported Chart Type", "7 Key charts are not properly supported. Please choose a different chart or difficulty.", "error")
            return false
        end
        song = love.audio.newSource("Music/" .. songList[selectedSong] .. "/" .. metaData.song, "stream")
        background = love.graphics.newImage("Music/" .. songList[selectedSong] .. "/" .. metaData.background)
    for i = 1,#chart.HitObjects do
        local hitObject = chart.HitObjects[i]
        local startTime = hitObject.StartTime
        local endTime = hitObject.EndTime or 0
        local lane = hitObject.Lane

        if lane > 4 then
            return false
        end
        table.insert(lanes[lane], startTime)
        --print(lane, #lanes[lane])
        lastNoteTime = startTime -- this should work because the last time its run will be the last note
    end
    songLength = song:getDuration()
    print(songLength)
    songLengthToLastNote = lastNoteTime/1000
    bestScorePerNote = 1000000/(#lanes[1]+#lanes[2]+#lanes[3]+#lanes[4])

    return true
end



function harmoniParse(file) -- don't use this
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