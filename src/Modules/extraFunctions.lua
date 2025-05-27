function getFileExtension(fileName)
    print(fileName)
    return fileName:match("%.([^%.]+)$")
end
