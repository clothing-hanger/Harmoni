function log(string)
    Log = Log .. tostring(string) .. "\n"
end

function createLog()
    love.filesystem.write("Logs/goddamn it harmoni " .. os.time() .. ".txt", Log)
end