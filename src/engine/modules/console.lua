local console = {}

console.isVisible = false
console.input = ""
console.history = {}
console.width = 1280
console.maxHistory = 10
console.textPadding = 20
console.font = love.graphics.newFont(12)
console.height = 0
-- calculate height with padding

local function printToConsole(text, wasCommand, showTimestamp)
    if #console.history >= console.maxHistory then
        table.remove(console.history, 1)
    end
    showTimestamp = showTimestamp ~= nil and showTimestamp or true
    if not wasCommand then
        table.insert(console.history, {text = text, timestamp = os.date("%Y-%m-%d %H:%M:%S", os.time()), wasCommand = false, showTimestamp = showTimestamp})
    else
        if showTimestamp then
            table.insert(console.history, {
                text = text,
                timestamp = os.date("%Y-%m-%d %H:%M:%S", os.time()),
                wasCommand = true,
                showTimestamp = showTimestamp
            })
        else
            table.insert(console.history, {
                text = ">> " .. text,
                timestamp = os.date("%Y-%m-%d %H:%M:%S", os.time()),
                wasCommand = true,
                showTimestamp = showTimestamp
            })
        end
    end
end

function string:split(sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) fields[#fields + 1] = c end)
    return fields
end

console.commands = {
    help = {
        name = "Help",
        description = "Lists all available commands.",
        usage = "help [command | optional]",
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
        callback = function(args)
            printToConsole("This is a test command. It does nothing.")
        end
    },
    clear = {
        name = "Clear",
        description = "Clears the console history.",
        usage = "clear",
        callback = function(args)
            console.clear()
            printToConsole("Console cleared.")
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
            if not success then
                printToConsole("Error: " .. result)
            else
                if tostring(result) ~= "nil" then
                    printToConsole(tostring(result))
                end
            end
        end
    }
}

function console.runCommand(command)
    local args = command:split(" ")
    local name = args[1]
    local cmd = console.commands[name]

    if cmd then
        table.remove(args, 1) -- remove the command name
        if cmd.callback then
            cmd.callback(args)
        else
            printToConsole("Command '" .. name .. "' has no callback function.", false, false)
        end
    else
        printToConsole("Unknown command: " .. name, false, false)
    end
end

function console.draw()
    love.graphics.setColor(0.25, 0.25, 0.25, 0.8)
    love.graphics.rectangle("fill", 0, 0, console.width, #console.history * 20 + 20)
    love.graphics.setFont(console.font)
    love.graphics.setColor(1, 1, 1)
    local y = 0
    for i = 1, #console.history do
        local entry = console.history[i]
        if entry.showTimestamp then
            love.graphics.print({{0.9, 0.9, 0.9}, "[", {0.7, 0.7, 0.7}, entry.timestamp, {0.9, 0.9, 0.9}, "]: ", {1, 1, 1}, entry.text}, 10, y)
        else
            love.graphics.print(entry.text, 10, y)
        end
        y = y + 20
        if y > love.graphics.getHeight() - 20 then
            break
        end
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
    if not console.isVisible then return end
    console.input = console.input .. text
end

local utf8 = require("utf8")
function console.keypressed(key)
    if key == "backspace" then
        if not console.isVisible then return end

        local byteoffset = utf8.offset(console.input, -1)
        if byteoffset then
            console.input = string.sub(console.input, 1, byteoffset - 1)
        end
    elseif key == "return" then
        if not console.isVisible then return end

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