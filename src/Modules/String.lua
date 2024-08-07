function getFileExtension(filename)
    return filename:match("^.+(%..+)$")
end