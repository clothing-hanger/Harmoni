function saveScore()
    local saveData = "local ScoreData = {Score = ".. Score .. "Accuracy = " .. Accuracy .. "}"
    love.filesystem.write("Saves/" .. songList[selectedSong] .. "/" .. diffList[selectedDifficulty] .."/" .. saveNumber .. ".lua", saveData)
end