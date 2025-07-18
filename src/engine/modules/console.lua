local console = {
    isVisible = false,
    input = "",
    history = {},
    width = 1280,
    maxHistory = 10,
    textPadding = 20,
    font = love.graphics.newFont(12),
    height = 0
}

local utf8 = require("utf8")

local function printToConsole(text, wasCommand, showTimestamp)
    if #console.history >= console.maxHistory then
        table.remove(console.history, 1)
    end

    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    showTimestamp = showTimestamp ~= false

    table.insert(console.history, {
        text = wasCommand and (showTimestamp and text or ">> " .. text) or text,
        timestamp = timestamp,
        wasCommand = wasCommand,
        showTimestamp = showTimestamp
    })
end

-- Utility: string.split
function string:split(sep)
    local fields = {}
    for field in self:gmatch("[^" .. (sep or ":") .. "]+") do
        fields[#fields + 1] = field
    end
    return fields
end

-- Command registry
console.commands = {
    help = {
        name = "Help",
        description = "Lists all available commands.",
        usage = "help [command]",
        callback = function(args)
            if #args == 0 then
                printToConsole("Available commands:")
                for id, cmd in pairs(console.commands) do
                    printToConsole(string.format("%s: %s - %s (Usage: %s)", id, cmd.name, cmd.description, cmd.usage), false, false)
                end
            else
                local command = console.commands[args[1]]
                if command then
                    printToConsole(string.format("%s: %s - %s (Usage: %s)", args[1], command.name, command.description, command.usage), false, false)
                else
                    printToConsole("Command not found: " .. args[1])
                end
            end
        end
    },
    test = {
        name = "Test",
        description = "A test command that does nothing.",
        usage = "test",
        callback = function() printToConsole("This is a test command. It does nothing.") end
    },
    clear = {
        name = "Clear",
        description = "Clears the console history.",
        usage = "clear",
        callback = function()
            console.clear()
            printToConsole("Console cleared.")
        end
    },
    saveFolder = {
        name = "Save Folder",
        description = "Opens the save directory.",
        usage = "saveFolder",
        callback = function()
            local saveDir = love.filesystem.getSaveDirectory()
            os.execute('start "" "' .. saveDir .. '"')
        end
    },
    lua = {
        name = "Lua",
        description = "Runs a Lua command.",
        usage = "lua <code>",
        callback = function(args)
            if #args == 0 then
                printToConsole("Usage: lua <code>")
                return
            end
            local code = table.concat(args, " ")
            local func, err = load(code)
            if not func then
                printToConsole("Error: " .. err)
                return
            end
            local success, result = pcall(func)
            printToConsole(success and tostring(result) or "Error: " .. result)
        end
    }
}

function console.runCommand(command)
    local args = command:split(" ")
    local name = table.remove(args, 1)
    local cmd = console.commands[name]

    if cmd and cmd.callback then
        cmd.callback(args)
    else
        printToConsole("Unknown command: " .. name, false, false)
    end
end

function console.draw()
    local lineHeight = 20
    local height = #console.history * lineHeight + lineHeight
    love.graphics.setColor(0.25, 0.25, 0.25, 0.8)
    love.graphics.rectangle("fill", 0, 0, console.width, height)

    love.graphics.setFont(console.font)
    love.graphics.setColor(1, 1, 1)

    local y = 0
    for _, entry in ipairs(console.history) do
        if entry.showTimestamp then
            love.graphics.print({
                {0.9, 0.9, 0.9}, "[",
                {0.7, 0.7, 0.7}, entry.timestamp,
                {0.9, 0.9, 0.9}, "]: ",
                {1, 1, 1}, entry.text
            }, 10, y)
        else
            love.graphics.print(entry.text, 10, y)
        end
        y = y + lineHeight
        if y > love.graphics.getHeight() - lineHeight then break end
    end

    love.graphics.print({{1, 0, 0}, ">> ", {1, 1, 1}, console.input}, 10, y)
end

function console.clear()
    console.history = {}
    console.input = ""
end

function console.init()
    printToConsole("Console initialized. Type 'help' for a list of commands.")
end

function console.textinput(text)
    if console.isVisible then
        console.input = console.input .. text
    end
end

function console.keypressed(key)
    if not console.isVisible then
        if key == "f7" then console.toggle(false) end
        return
    end

    if key == "backspace" then
        local byteoffset = utf8.offset(console.input, -1)
        if byteoffset then
            console.input = console.input:sub(1, byteoffset - 1)
        end
    elseif key == "return" then
        if console.input ~= "" then
            printToConsole(console.input, true)
            console.runCommand(console.input)
            console.input = ""
        end
    elseif key == "f7" then
        console.toggle(false)
    end
end

function console.toggle(force)
    console.isVisible = force ~= nil and force or not console.isVisible
end

console.init()

return console
