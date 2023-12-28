function quaverParse(file)
    print("quaverParse()")
    -- huge credits to https://github.com/AGORI-Studios/Rit for this part
        --chart = tinyyaml.parse(love.filesystem.read("Music/" .. songList[selectedSong] .. "/" .. diffList[selectedDiff]))
        chart = tinyyaml.parse(love.filesystem.read(file))


        metaData = {
            name = chart.Title,
            song = chart.AudioFile,
            artist = chart.Artist,
            source = chart.Source, -- not sure what this one even is really
            tags = chart.Tags, -- not gonna be used in this file but im putting it here for now so i dont forget it
            diffName = chart.DifficultyName,
            creator = chart.Creator,
            background = chart.BackgroundFile,
            previewTime = chart.PreviewTime or 0, -- also wont be used here
            noteCount = 0,
            length = 0,
            bpm = 0,   -- idk if ill ever use bpm 😭😭 idk how it works
            inputMode = chart.Mode:gsub("Keys", ""),  -- will be used to make sure its 4 key
        }

        song = love.audio.newSource("Music/" .. songList[selectedSong] .. "/" .. metaData.song, "stream")
        background = love.graphics.newImage("Music/" .. songList[selectedSong] .. "/" .. metaData.background)
    for i = 1,#chart.HitObjects do
        local hitObject = chart.HitObjects[i]
        local startTime = hitObject.StartTime
        local endTime = hitObject.EndTime or 0
        local lane = hitObject.Lane

        if lane == 1 then
            table.insert(lane1, startTime)
        elseif lane == 2 then
            table.insert(lane2, startTime)
        elseif lane == 3 then
            table.insert(lane3, startTime)
        elseif lane == 4 then
            table.insert(lane4, startTime)
        end
        lastNoteTime = startTime -- this should work because the last time its run will be the last note
    end
    songLength = song:getDuration()
    print(songLength)
    songLengthToLastNote = lastNoteTime/1000
    bestScorePerNote = 1000000/(#lane1+#lane2+#lane3+#lane4)
end



function harmoniParse(file) -- don't use this
    chart = love.filesystem.load(file)()
    bestScorePerNote = 1000000/#chart
    for i = 1,#chart do
        if chart[i][2] == 1 then
            table.insert(lane1, chart[i][1])
        elseif chart[i][2] == 2 then
            table.insert(lane2, chart[i][1])
        elseif chart[i][2] == 3 then
            table.insert(lane3, chart[i][1])
        elseif chart[i][2] == 4 then
            table.insert(lane4, chart[i][1])
        end
    end
    song = love.audio.newSource("Music/" .. songList[selectedSong] .. "/audio.mp3", "stream")
    background = love.graphics.newImage("Music/" .. songList[selectedSong] .. "/background.jpg")
    songLength = song:getDuration()
    songLengthToLastNote = lastNoteTime/1000
    lastNoteTime = chart[#chart][1]
end