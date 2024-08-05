local QuaverImportScreen = State()
local os = love.system.getOS()
local importer = lovefs()
local sep = os == "Windows" and "\\" or "/"
local songsFolder = love.filesystem.getSaveDirectory() .. sep .. "Music"
local frame = 0 


-- TODO: Make the following code work in a thread.

function QuaverImportScreen:enter()
    log("QuaverImportScreen Entered")
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
                            log(dir .. sep .. file, songsFolder .. sep .. song .. sep .. file)
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
                        log(dir .. sep .. file, songsFolder .. sep .. song .. sep .. file)
                    end
                end
            end
        end
        
    preLaunchFade = {0}
        log("QuaverImportScreen Exited")
        wipeFade("in")
        State.switch(States.PreLaunchState)
    end
end

function QuaverImportScreen:draw()
    love.graphics.setFont(MenuFontBig)
    love.graphics.printf("Hang tight, Harmoni is importing your songs.\n The game might appear to be frozen, but it's not, it's trying its best just give it time lmao\n" .. loadingEasterEgg, Inits.GameWidth/2-600, Inits.GameHeight/2, 1200, "center")
end

return QuaverImportScreen