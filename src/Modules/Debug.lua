local stateString = ""
local cursorTimer


console = {}

commands = {
    {
        name = "help",
        help = "I think you know what this one does lmao",
        func = function()
            local debugHelpTable = {}
            for Key, Command in ipairs(commands) do
                local helpText = Command.name .. "- " .. Command.help
                table.insert(debugHelpTable, helpText)
            end
            consoleWriteLine(debugHelpTable) 
        end
    },
    {
        name = "clear",
        help = "clears the console history",
        func = function()
            console.history = {}
        end
    },
    {
        name = "skipToEnd",
        help = "is SUPPOSED to skip to 5 seconds before the last note BUT IT DOESNT FUCKING WORK",
        func = function()
           -- MusicTime = (metaData.songLengthToLastNote - 5)*1000
          --  Song:seek(metaData.songLengthToLastNote)
        end
    },
    {
        name = "crash",
        help = "causes an intentional crash",
        func = function()
            error("Test Crash")

        end
    },
    {
        name = "get freaky",
        help = "...",
        func = function()
            freakyMode = true
            Skin.Fonts = {
                ["HUD Large"] = love.graphics.newFont("FONTS/papyrus.ttf", 65),
                ["HUD Small"] = love.graphics.newFont("FONTS/papyrus.ttf", 15),
                ["HUD Extra Small"] = love.graphics.newFont("FONTS/papyrus.ttf", 12),
                ["Combo"] = love.graphics.newFont("FONTS/papyrus.ttf", 35),
                ["Menu Large"] = love.graphics.newFont("FONTS/papyrus.ttf", 25),
                ["Menu Small"] = love.graphics.newFont("FONTS/papyrus.ttf", 15),
                ["Menu Extra Small"] = love.graphics.newFont("FONTS/papyrus.ttf", 12),
            }
            defaultFont = love.graphics.newFont("FONTS/papyrus.ttf", 12)

        end
    },
}


function debugInit()
    console.isOpen = false
    console.textInput = ""
    console.width = 500
    console.height = 500
    cursorTimer = 1000
    console.textPrompt = "> "
    console.history = {"Type help for a list of available commands"}
    console.blinkingCursor = "|"
end

function consoleCursorBlink() -- this is so useless lmao
    cursorTimer = 1000
    if console.blinkingCursor == "|" then
        console.blinkingCursor = ""
    else
        console.blinkingCursor = "|"
    end
end


function consoleWriteLine(text)
    if not text then return end

    local function writeTableText(textTable)
        for i = 1,#textTable do
            table.insert(console.history, tostring(textTable[i]))
        end
    end

    if type(text) == "table" then
        writeTableText(text)
    else
        table.insert(console.history, tostring(text))
    end
end

function debugUpdate(dt)
    cursorTimer = cursorTimer - 1000*dt
    if cursorTimer <= 0 then
        consoleCursorBlink()
    end
end

function consoleKeypressed(key)
    if key == "backspace" then
        local byteoffset = utf8.offset(console.textInput, -1)
        if byteoffset then
            console.textInput = string.sub(console.textInput, 1, byteoffset - 1)
        end
    elseif key == "return" then
        table.insert(console.history, console.textInput)
        table.insert(console.history, "")

        consoleExecute(console.textInput)
        console.textInput = ""
    end
end

function consoleExecute(input)
    for Key, Command in ipairs(commands) do
        if Command.name == input then
            Command.func()
            return        -- return so it doesnt try to run it as a function
        end
    end

    local func, err = loadstring(input)
    if func then
        local success, result = pcall(func)
        if success then
            table.insert(console.history, tostring(result))
        else
            table.insert(console.history, "Error: " .. result)
        end
    else
        table.insert(console.history, "Syntax Error: " .. err)
    end

    return    -- return even tho this is useless just cuz the code looks better with it lmao

end

function consoleTextinpput(text)
    cursorTimer = 1000

    console.textInput = console.textInput .. text
end

function debug.printInfo()
    if stateDebugString then stateString = stateDebugString end
    
    love.graphics.translate(0, Inits.GameHeight-200)
    love.graphics.setFont(defaultFont)
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle("fill", 0, 0, 200, 200)
    love.graphics.setColor(1,1,1)
    love.graphics.print(
        "FPS: " .. tostring(love.timer.getFPS()) .. 
        "\nLua Memory (KB): " .. tostring(math.floor(collectgarbage("count"))) ..
        "\nGraphics Memory (MB): " .. tostring(math.floor(love.graphics.getStats().texturememory/1024/1024)) ..
        stateString
    )
    love.graphics.translate(0, -Inits.GameHeight-200)

end


function consoleDraw()
    if not console.isOpen then return end
    love.graphics.setFont(defaultFont)
    love.graphics.setColor(0,0,0,0.8)
    love.graphics.rectangle("fill", 0, 0, console.width, console.height)
    love.graphics.setColor(1,1,1)
    for i = 1,#console.history do
        love.graphics.print(console.history[i], 10, i*15)
    end
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill", 10, console.height + 25, console.width, 15)
    love.graphics.setColor(1,1,1)
    love.graphics.print(console.textPrompt .. console.textInput .. console.blinkingCursor, 10, console.height + 25)






end

function debugDraw()
    consoleDraw()
            
    love.graphics.translate(0, Inits.GameHeight-200)
    love.graphics.setFont(defaultFont)
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle("fill", 0, 0, 200, 200)
    love.graphics.setColor(1,1,1)
    love.graphics.print(
        "FPS: " .. tostring(love.timer.getFPS()) .. 
        "\nLua Memory (KB): " .. tostring(math.floor(collectgarbage("count"))) ..
        "\nGraphics Memory (MB): " .. tostring(math.floor(love.graphics.getStats().texturememory/1024/1024)) .. 
        "\nMusic Time (MS): " .. tostring(MusicTime)
    )
    love.graphics.translate(0, -Inits.GameHeight-200)
end

