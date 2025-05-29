function getFileExtension(fileName)
    return fileName:match("%.([^%.]+)$")
end
