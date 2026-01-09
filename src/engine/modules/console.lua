local utf8 = require("utf8")

local Console = {
    visible = false,

    input = "",
    history = {},
    maxHistory = 200,
    scroll = 0,

    height = 280,
    padding = 12,
    lineSpacing = 4,

    font = love.graphics.newFont(13),
    smallFont = love.graphics.newFont(11),

    colors = {
        bg = {0.08, 0.08, 0.08, 0.9},
        border = {0.2, 0.2, 0.2, 1},
        text = {1, 1, 1, 1},
        dim = {0.7, 0.7, 0.7, 1},
        command = {0.4, 0.8, 1, 1},
        error = {1, 0.4, 0.4, 1},
        system = {0.6, 1, 0.6, 1},
        prompt = {1, 0.6, 0.6, 1}
    }
}

local function timestamp()
    return os.date("%H:%M:%S")
end

local function trim(s)
    return s:match("^%s*(.-)%s*$")
end

local function parseArgs(str)
    local args = {}

    local i = 1
    while i <= #str do
        local c = str:sub(i, i)

        if c == " " then
            i = i + 1
        elseif c == '"' then
            local j = i + 1
            while j <= #str and str:sub(j, j) ~= '"' do
                j = j + 1
            end
            args[#args + 1] = str:sub(i + 1, j - 1)
            i = j + 1
        else
            local j = i
            while j <= #str and str:sub(j, j) ~= " " do
                j = j + 1
            end
            args[#args + 1] = str:sub(i, j - 1)
            i = j
        end
    end

    return args
end

function Console:print(text, kind)
    kind = kind or "text"

    self.history[#self.history + 1] = {
        time = timestamp(),
        text = tostring(text),
        kind = kind
    }

    if #self.history > self.maxHistory then
        table.remove(self.history, 1)
    end
end

function printToConsole(...)
    local vars = {...}
    for i, v in ipairs(vars) do
        if type(v) ~= "string" then
            vars[i] = tostring(v)
        end
    end
    Console:print(table.concat(vars, "\t"), "text")
end

local oldPrint = print
function print(...)
    local info = debug.getinfo(2, "Sl")
    local location = ""
    if info then
        location = string.format("[%s:%d] ", info.short_src, info.currentline)
    end
    local vars = {...}
    for i, v in ipairs(vars) do
        if type(v) ~= "string" then
            vars[i] = tostring(v)
        end
    end
    oldPrint(location .. table.concat(vars, "\t"))
    Console:print(location .. table.concat(vars, "\t"), "text")
end

Console.commands = {}

function Console:addCommand(name, desc, usage, fn)
    self.commands[name] = {
        desc = desc,
        usage = usage,
        fn = fn
    }
end

Console:addCommand("help", "List commands", "help [command]", function(args)
    if args[1] then
        local cmd = Console.commands[args[1]]
        if not cmd then
            Console:print("Unknown command: " .. args[1], "error")
            return
        end
        Console:print(args[1] .. " - " .. cmd.desc, "system")
        Console:print("Usage: " .. cmd.usage, "dim")
        return
    end

    Console:print("Available commands:", "system")
    for name, cmd in pairs(Console.commands) do
        Console:print(string.format("  %-10s - %s", name, cmd.desc), "dim")
    end
end)

Console:addCommand("clear", "Clear console", "clear", function()
    Console.history = {}
    Console.scroll = 0
end)

Console:addCommand("lua", "Run Lua code", "lua <code>", function(args)
    local code = table.concat(args, " ")
    if code == "" then
        Console:print("Usage: lua <code>", "error")
        return
    end

    local env = {
        print = function(...)
            Console:print(table.concat({...}, " "), "system")
        end
    }

    local fn, err = load(code, "console", "t", env)
    if not fn then
        Console:print(err, "error")
        return
    end

    local ok, res = pcall(fn)
    if not ok then
        Console:print(res, "error")
    elseif res ~= nil then
        Console:print(res, "system")
    end
end)

Console:addCommand("saveFolder", "Open save directory", "saveFolder", function()
    local dir = love.filesystem.getSaveDirectory()
    os.execute('start "" "' .. dir .. '"')
end)

function Console:run(line)
    line = trim(line)
    if line == "" then return end

    self:print(">> " .. line, "command")

    local args = parseArgs(line)
    local name = table.remove(args, 1)

    local cmd = self.commands[name]
    if not cmd then
        self:print("Unknown command: " .. name, "error")
        return
    end

    cmd.fn(args)
end

function Console:textinput(t)
    if self.visible then
        self.input = self.input .. t
    end
end

function Console:keypressed(key)
    if key == "f7" then
        self.visible = not self.visible
        return
    end


    if not self.visible then return end

    if key == "backspace" then
        local off = utf8.offset(self.input, -1)
        if off then
            self.input = self.input:sub(1, off - 1)
        end
    elseif key == "return" then
        self:run(self.input)
        self.input = ""
        self.scroll = 0
    elseif key == "pageup" then
        self.scroll = math.min(self.scroll + 3, #self.history)
    elseif key == "pagedown" then
        self.scroll = math.max(self.scroll - 3, 0)
    end
end

function Console:draw()
    if not self.visible then return end

    local w = love.graphics.getWidth()
    local h = self.height
    local y = 0

    love.graphics.setFont(self.font)

    love.graphics.setColor(self.colors.bg)
    love.graphics.rectangle("fill", 0, -5, w, h+5, 8, 8)

    love.graphics.setColor(self.colors.border)
    love.graphics.rectangle("line", 0, -5, w, h+5, 8, 8)

    local lineHeight = self.font:getHeight() + self.lineSpacing
    local maxLines = math.floor((h - 50) / lineHeight)

    local start = math.max(1, #self.history - maxLines - self.scroll)
    local finish = math.min(#self.history, start + maxLines - 1)

    y = self.padding

    for i = start, finish do
        local e = self.history[i]
        local c = self.colors[e.kind] or self.colors.text

        love.graphics.setColor(self.colors.dim)
        love.graphics.print("[" .. e.time .. "]", self.padding, y)

        love.graphics.setColor(c)
        love.graphics.print(e.text, self.padding + 70, y)

        y = y + lineHeight
    end

    love.graphics.setColor(self.colors.border)
    love.graphics.line(
        self.padding,
        h - 32,
        w - self.padding,
        h - 32
    )

    love.graphics.setColor(self.colors.prompt)
    love.graphics.print(">>", self.padding, h - 26)

    love.graphics.setColor(self.colors.text)
    love.graphics.print(self.input, self.padding + 24, h - 26)
end

function Console:init()
    self:print("CONSOLE READY", "system")
end

Console:init()
return Console
