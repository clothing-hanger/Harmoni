function getFileExtension(filename)
    return filename:match("^.+(%..+)$")
end

function length(string)
    return #string
end