local SongListManager = {}

function SongListManager.getSongList(path)
    if not love.filesystem.getInfo(path, "directory") then
        return {}
    end
    return love.filesystem.getDirectoryItems(path)
end

function SongListManager.getDifficultyList(path)
    local items = love.filesystem.getDirectoryItems(path)
    local list = {}
    for _, item in ipairs(items) do
        if getFileExtension(item) == "harmc" then
            table.insert(list, item)
        end
    end
    return list
end


return SongListManager