---@param lanes table The lanes of the generated song
---@param songDuration number The duration of the song in seconds
---@return number nps The nps of thesong
function calculateDifficulty(lanes, songDuration)  -- all it uses is nps 💀
    local totalNoteCount = 0
    for i = 1, #lanes do
        totalNoteCount = totalNoteCount + #lanes[i]
    end
    local nps = totalNoteCount / songDuration
    return nps
end
