function getFileExtension(fileName)
    print(fileName)
    return filename:match("%.([^%.]+)$")
end
