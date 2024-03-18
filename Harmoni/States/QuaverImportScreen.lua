local QuaverImportScreen = State()
local os = love.system.getOS()
local importer = lovefs()
local sep = os == "Windows" and "\\" or "/"
local songsFolder = love.filesystem.getSaveDirectory() .. sep .. "Music"
local frame = 0 


-- TODO: Make the following code work in a thread.

function QuaverImportScreen:enter()
    if MenuMusic:isPlaying() then
        MenuMusic:stop()
    end
    frame = 0
end

function QuaverImportScreen:update(dt)
    frame = frame + 1 

    if frame == 2 then
        for _, drive in ipairs(importer.drives) do
            local path = drive .. "SteamLibrary"
            if importer:isDirectory(path) then
                importer:cd(path)
                importer:cd("steamapps")
                importer:cd("common")
                importer:cd("Quaver")
                if importer:exists("Songs") then
                    importer:cd("Songs")
                    local lastDir = importer.current
                    local dir, lFolders = importer:ls()

                    for _, song in ipairs(lFolders) do
                        importer:cd(song)
                        love.filesystem.createDirectory("Music/" .. song)
                        local dir, _, lFiles = importer:ls()
                        for _, file in ipairs(lFiles) do
                            importer:copy(dir .. sep .. file, songsFolder .. sep .. song .. sep .. file)
                        end

                        importer:cd(lastDir)
                    end
                end
            end

            importer:cd(drive)
            importer:cd("Program Files (x86)")
            importer:cd("Steam")
            importer:cd("steamapps")
            importer:cd("common")
            importer:cd("Quaver")
            if importer:exists("Songs") then
                importer:cd("Songs")
                local lastDir = importer.current
                local dir, lFolders = importer:ls()

                for _, song in ipairs(lFolders) do
                    importer:cd(song)
                    love.filesystem.createDirectory("Music/" .. song)
                    local dir, _, lFiles = importer:ls()
                    for _, file in ipairs(lFiles) do
                        importer:copy(dir .. sep .. file, songsFolder .. sep .. song .. sep .. file)
                    end
                end
            end
        end
        
    preLaunchFade = {0}

        State.switch(States.PreLaunchState)
    end
end

function QuaverImportScreen:draw()
    love.graphics.printf("Importing Quaver songs...", 0, Inits.GameHeight/2-100, Inits.GameWidth/2, "center", 0, 2, 2)
end

return QuaverImportScreen