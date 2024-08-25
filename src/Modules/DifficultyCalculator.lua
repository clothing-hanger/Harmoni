function calculateDifficulty(lanes, songDuration)  -- all it uses is nps 💀
    local totalNoteCount = 0
    for i = 1, #lanes do
        totalNoteCount = totalNoteCount + #lanes[i]
    end
    local nps = totalNoteCount / songDuration
    return nps
end
