local PreLoader = State()
local SongContents
local DifficultyList = {}
local foundMeta
local chart
local fileName
local songName
local diffName
local frame
local metaString


function PreLoader:enter()
    SongList = love.filesystem.getDirectoryItems("Music")
    frame = 0
end

function PreLoader:update(dt)
    foundMeta = false
    metaString = ""
    frame = plusEq(frame)
    SongContents = love.filesystem.getDirectoryItems("Music/" .. SongList[frame] .. "/")
    DifficultyList = {}
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
            chart = Tinyyaml.parse(love.filesystem.read("Music/" .. SongList[frame] .. "/" .. DifficultyList[i]))
            if i == 1 then
                metaString = string.format("return {\nsongName = \"%s\",\ndifficulties = {\n", chart.Title)
            end 
            metaString = metaString .. string.format(
                "{fileName = \"%s\", diffName = \"%s\", artistName = \"%s\", charterName = \"%s\", background = \"%s\"},\n", 
                DifficultyList[i], 
                chart.DifficultyName, 
                chart.Artist, 
                chart.Creator, 
                chart.BackgroundFile
            )
            if i == #DifficultyList then
                metaString = metaString .. "metaVersion = 1\n},\n}\n"
            end
        end
        love.filesystem.write("Music/" .. SongList[frame] .. "/meta.lua", metaString)

    else
        print("Meta Found")
    end
    if frame == #SongList then State.switch(States.Menu.SongSelect) end
end


function PreLoader:draw()
end

return PreLoader




