function convertQuaverChart(file)
    if not file then return end

    local chart = Tinyyaml.parse(love.filesystem.read(file))

    local metaData = {
        title = chart.Title,
        audioFile = chart.AudioFile,
        artist = chart.Artist,
        source = chart.Source, -- what is this
        tags = chart.Tags, -- pain
        difficultyName = chart.difficultyName,
        creator = chart.Creator,
        backgroundFile = chart.backgroundFile,
        bannerFile = chart.bannerFile,
        songPreviewTime = chart.SongPreviewTime,
        
        noteCount = 0,
        holdNoteCount = 0,
        songLength = 0,
        songBpm = 0,
        inputMode = chart.Mode:gsub("Keys", ""),
    }
    

    

end

