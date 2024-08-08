local PreLoader = State()
local SongContents
local DifficultyList
local foundMeta
local chart
local fileName
local songName
local diffName

function PreLoader:enter()
    SongList = love.filesystem.getDirectoryItems("Music")
end

function PreLoader:update(dt)
    foundMeta = false
    frame = plusEq(frame)
    SongContents = love.filesystem.getDirectoryItems("Music/" .. SongList[frame] .. "/")
    for i = 1,#SongContents do
        if getFileExtension(SongContents[i]) == ".qua" then
            table.insert(DifficultyList, SongContents[i])
        end
        if SongContents[i] == "meta.lua" then
            foundMeta = true
        end
    end

    if not foundMeta then
        for i = 1,#DifficultyList do
            chart = Tinyyaml.parse("Music/" .. SongList[frame] .. "/" .. DifficultyList[i])
            fileName = DifficultyList[i]
            songName = chart.Title
            diffName = chart.DifficultyName
        end
    end





end

function PreLoader:draw()
end

return PreLoader


function generateMetaFile(frame)   -- thanks chatgpt lmao
    local songMeta = {
        songName = "",
        difficulties = {}
    }

    -- Ensure the selected song has difficulties listed
    if #DifficultyList == 0 then
        print("No difficulties found for the selected song.")
        return
    end

    -- Iterate through the DifficultyList to get chart details
    for i = 1, #DifficultyList do
        local chartPath = "Music/" .. SongList[frame] .. "/" .. DifficultyList[i]
        local chartContent = love.filesystem.read(chartPath)
        local chart = Tinyyaml.parse(chartContent)
        
        -- Extract details
        local fileName = DifficultyList[i]
        local songName = chart.Title
        local diffName = chart.DifficultyName
        
        -- Set the song name once
        if i == 1 then
            songMeta.songName = songName
        end

        -- Add difficulty information to the meta table
        table.insert(songMeta.difficulties, {fileName = fileName, diffName = diffName})
    end

    -- Generate the meta.lua content
    local metaContent = "return {\n"
    metaContent = metaContent .. '    songName = "' .. songMeta.songName .. '",\n'
    metaContent = metaContent .. '    difficulties = {\n'
    
    for _, diff in ipairs(songMeta.difficulties) do
        metaContent = metaContent .. '        {fileName = "' .. diff.fileName .. '", diffName = "' .. diff.diffName .. '"},\n'
    end
    
    metaContent = metaContent .. '    },\n'
    metaContent = metaContent .. '}\n'

    -- Write the meta.lua file
    local metaFilePath = "Music/" .. SongList[frame] .. "/meta.lua"
    love.filesystem.write(metaFilePath, metaContent)

    print("meta.lua file generated at " .. metaFilePath)
end

-- Example usage: assuming 'frame' is the selected song index
generateMetaFile(SelectedSong)



return {
    songName = "name",
    difficuties = {
        {fileName = "fileName", diffName = "diffName"},
        {fileName = "fileName", diffName = "diffName"},
        {fileName = "fileName", diffName = "diffName"},
        {fileName = "fileName", diffName = "diffName"},
    },
}