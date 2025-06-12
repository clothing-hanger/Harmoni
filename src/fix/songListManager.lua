local SongListManager = {}

function SongListManager.getSongList(path)
    local list = love.filesystem.getDirectoryItems(path)
    return list
end

function SongListManager.getDifficultyList(path)
    local listWithOtherShit = love.filesystem.getDirectoryItems(path)
    local list = {}
    for i = 1,#listWithOtherShit do
        if getFileExtension(listWithOtherShit[i]) == "harmc" then
            table.insert(list, listWithOtherShit[i])
        end
    end
    return list
end

return SongListManager