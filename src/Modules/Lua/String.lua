---Gets the file extension from a string
---@param filename string
---@return string
function getFileExtension(filename)
    return filename:match("^.+(%..+)$")
end

---Gets the length of a string
---@param string string
---@return integer
function length(string)
    return #string
end

---Splits a string into a table for each character
---@param str string
---@return table<string>
function splitIntoLetters(str)
    local letters = {}
    for i = 1, #str do
        local letter = str:sub(i, i)
        if letter == " " then letter = "space" end
        table.insert(letters, letter)
    end
    return letters
end