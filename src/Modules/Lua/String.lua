function getFileExtension(filename)
    return filename:match("^.+(%..+)$")
end

function length(string)
    return #string
end

function splitIntoLetters(str)
    local letters = {}
    for i = 1, #str do
        local letter = str:sub(i, i)
        if letter == " " then letter = "space" end
        table.insert(letters, letter)
    end
    return letters
end