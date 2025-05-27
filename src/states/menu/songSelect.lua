local songSelect = State("songSelect")
local songList = {}
local songButtons = {}
function songSelect:enter()
    self:setupSongList()
end

function songSelect:setupSongList()
    songList = SongListManager.getSongList(musicPath)
    for i = 1,#songList do
        local difficultyList = SongListManager.getDifficultyList(musicPath .. songList[i])

    end
end

function songSelect:update(dt)
end

function songSelect:draw()
    for i, SongButton in ipairs(songButtons) do
        SongButton:draw()
    end
end

return songSelect

--[[
        for j = 1,#difficultyList do
            local songInfo = ChartParse.harmc(musicPath .. songList[i] .. "/" .. difficultyList[j])
            table.insert(songButtons, menuSongButton(100,50,songInfo.meta.title, songInfo.meta.artist, songInfo.meta.charter, songInfo.meta.bpm, songInfo.meta.bannerFile, true))
           -- table.insert(songButtons, menuSongButton(songInfo.meta.title, songInfo.meta.artist, songInfo.meta.charter, songInfo.meta.bpm, musicPath .. songList[i] .. "/" .. difficultyList[j] .. "/cover.png", true))
        end
        --]]