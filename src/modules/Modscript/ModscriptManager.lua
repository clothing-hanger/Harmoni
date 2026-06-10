local path = (...):gsub("ModscriptManager", "") .. "."
local Modscript = {}

Modscript.funcs = {}
Modscript.timedFunctions = {}
Modscript.shaders = {}
Modscript.currentShader = ""

Modscript.downscroll = Settings:getValue("Gameplay", "Mania", "Scroll Direction") == "Down"

require(path .. "Modifiers")

currentPlayfield = 1

__defaultPositions = {{
    {x = 0, y = 0},
    {x = 0, y = 0},
    {x = 0, y = 0},
    {x = 0, y = 0}
}}

local activeMods = {{}}
local register = {}
local modArray = {}
local timeline = {}

function __quickRegister(mod)
    __registerMod(mod.name, mod)
end

function __registerMod(modName, mod)    
    register[modName] = mod
    table.insert(modArray, mod)

    for _, name in ipairs(mod:getSubmods()) do
        local submod = BaseSubModifier(name, mod)
        __registerMod(name, submod)
        mod.submods[name] = submod
    end
end

function Modscript:setupDefaultPositions(receptors)
    __defaultPositions = {{}}
    
    for i = 1, #receptors do
        __defaultPositions[1][i] = {x = receptors[i].x, y = receptors[i].y}
    end
end

function Modscript:reset(receptors)
    self:setupDefaultPositions(receptors)
    self.downscroll = Settings:getValue("Gameplay", "Mania", "Scroll Direction") == "Down"
    for i = 1, States.game.gameModeManager.gameMode.playField[1].chart.meta.laneCount do
        States.game.gameModeManager.gameMode.playField[1].lanes[i].y = maniaLaneYOffset
    end

    States.game.gameModeManager.gameMode.ableToModscript = false
    activeMods = {{}}
    register = {}
    modArray = {}
    timeline = {}

    GAME = States.game.gameModeManager.gameMode

    function SetValue(name, val, playfield)
        local playfield = playfield or -1

        if playfield < 0 then
            for i = 1, #States.game.gameModeManager.gameMode.playField do
                SetValue(name, val, i)
            end
        else
            local lmod = register[name]
            if not lmod then
                print("No mod named " .. name)
                return
            end
            local mod = lmod.parent or lmod
            local name = mod.name

            if not activeMods[playfield] then activeMods[playfield] = {} end
            mod:setValue(val, playfield)
            if lmod.parent then
                lmod.parent:setSubmodValue(lmod.name, val, playfield)
            end

            if not table.find(activeMods[playfield], name) then
                print("Activating " .. name .. " on playfield " .. playfield)
                if lmod.name ~= name then
                    table.insert(activeMods[playfield], lmod.name)
                end
                table.insert(activeMods[playfield], name)
            end
        end
    end

    function QueueEase(...)
        Modscript:queueEase(...)
    end
    function QueueSet(...)
        Modscript:queueSet(...)
    end
    function QueueFunc(...)
        Modscript:queueFunc(...)
    end

    function CreatePlayfield(...)
        local gamemode = States.game.gameModeManager.gameMode
        local first = gamemode.playField[1]
        local new = maniaPlayField(first.chart, gamemode)
        new.inputAllowed = false
        new.id = #gamemode.playField + 1
        table.insert(activeMods, {})
        for _, mod in ipairs(modArray) do
            if mod.type == "Mod" then
                table.insert(mod.percents, 0)
                for _, submod in ipairs(mod.submods) do
                    table.insert(submod.percents, 0)
                end
            else
                for _, submod in ipairs(mod.submods) do
                    table.insert(submod.percents, 0)
                end
            end
        end

        table.insert(gamemode.playField, new)
    end

    function RemovePlayfield(id)
        if id < 2 then
            print("Cannot remove main playfield")
            return
        end

        local gamemode = States.game.gameModeManager.gameMode
        table.remove(gamemode.playField, id)

        table.remove(activeMods, id)
        for _, mod in ipairs(modArray) do
            if mod.type == "Mod" then
                table.remove(mod.percents, id)
                for _, submod in ipairs(mod.submods) do
                    table.remove(submod.percents, id)
                end
            else
                for _, submod in ipairs(mod.submods) do
                    table.remove(submod.percents, id)
                end
            end
        end
    end

    function GetMainPlayfieldVertSprite()
        return nil
    end

    function CreatePlayfieldVertSprite(...)
        return nil
    end
end

function Modscript:load(script)
    local receptors = {}
    --[[ self:reset(States.game.gameModeManager.gameMode.playField[1].receptors) ]]
    for i, lane in ipairs(States.game.gameModeManager.gameMode.playField[1].lanes) do
        table.insert(receptors, lane.receptor)
    end
    self:reset(receptors)
    self.downscroll = Settings:getValue("Gameplay", "Mania", "Scroll Direction") == "Down"

    local mods = {
        ConfusionModifier,
        DrunkModifier,
        ReverseModifier,
        BeatModifier,
        TransformModifier,
        MoveModifier,
        StealthModifier
    }

    for _, mod in ipairs(mods) do
        __quickRegister(mod())
    end

    local chunk 
    local ok = tryExcept(
        function()
            chunk = love.filesystem.load(script)()
            States.game.gameModeManager.gameMode.ableToModscript = true
            for i = 1, States.game.gameModeManager.gameMode.playField[1].chart.meta.laneCount do
                States.game.gameModeManager.gameMode.playField[1].lanes[i].y = 110
            end
        end,
        function(e)
            print("FAILED TO LOAD MODSCRIPT | " .. e)
        end
    )

    self.chunk = chunk

    --QueueEase(1, 20, "Drunk", 2, "out-quad")
    --QueueSet(1, "Drunk", 1, 1)

    return ok
end

function Modscript:update(dt)
    for _, mod in ipairs(modArray) do
        mod:update(dt)
    end

    for i, event in ipairs(timeline) do
        if event.finished then
            -- bleh
            table.remove(timeline, i)
        else
            local curDecBeat = States.game.gameModeManager.gameMode.bpmHandler.fullBeatTime/4
            if curDecBeat >= event.startBeat then
                event:run(curDecBeat)
            end
        end
    end
end

function Modscript:updateObject(beat, obj, pos, playfield)
    if not activeMods[playfield] then activeMods[playfield] = {} end
    for _, name in ipairs(activeMods[playfield]) do

        local mod = register[name]
        if not mod then break end

        if obj:isInstanceOf(maniaNote) then
            mod:updateNote(beat, obj, pos, playfield)
        elseif obj:isInstanceOf(maniaReceptor) then
            mod:updateReceptor(beat, obj, pos, playfield)
        end
    end
end

function math.clamp(low, n, high)
    return math.min(math.max(n, low), high)
end

function Modscript:getPos(time, diff, tDiff, beat, data, playfield, obj, exclusions, pos)
    if not data then data = 1 end
    if not activeMods[playfield] then
        activeMods[playfield] = {}
    end
    local exclusions = exclusions or {}
    local pos = pos or Point()

    pos.x = __defaultPositions[math.clamp(1, playfield, #__defaultPositions)][data].x
    pos.y = 110 + diff
    pos.z = 0

    for _, name in ipairs(activeMods[playfield]) do
        if exclusions[name] then goto continue end
        local mod = register[name]
        if not mod or mod.type == "SubMod" then goto continue end
        pos = mod:getPos(time, diff*0.35, tDiff, beat, pos, data, playfield, obj)
        ::continue::
    end

    return pos
end

function Modscript:queueEase(beat, endBeat, modName, val, easeStyle, playfield, startVal)
    local playfield = playfield or -1
    if playfield < 1 then
        for i = 1, #States.game.gameModeManager.gameMode.playField do
            self:queueEase(beat, endBeat, modName, val, easeStyle, i, startVal)
        end
    else
        local ease = easeStyle or Ease.linear
        if type(ease) == "string" then ease = Ease[ease] or Ease.linear end

        table.insert(timeline, {
            startBeat = beat,
            endBeat = endBeat,
            length = endBeat - beat,
            easeFunc = ease,
            startVal = startVal,
            endVal = val,
            modName = modName,
            finished = false,
            playfield = playfield,

            ease = function(self, e, t, b, c, d)
                local time = t / d
                return c * e(time) + b
            end,

            run = function(self, curBeat)
                if curBeat <= self.endBeat then
                    if not self.startVal then
                        if not register[self.modName] then return end
                        self.startVal = register[self.modName]:getValue(self.playfield)
                    end

                    local passed = (curBeat - self.startBeat) / self.length
                    local change = self.endVal - self.startVal
                    local v = self:ease(self.easeFunc, math.clamp(0, passed, 1), self.startVal, change, 1)
                    SetValue(self.modName, v, self.playfield)
                elseif curBeat > self.endBeat then
                    self.finished = true
                    SetValue(self.modName, self.endVal, self.playfield)
                end
            end
        })
    end
end

function Modscript:queueSet(beat, modName, val, playfield)
    local playfield = playfield or -1
    if playfield < 1 then
        for i = 1, #States.game.gameModeManager.gameMode.playField do
            self:queueSet(beat, modName, val, i)
        end
    else
        table.insert(timeline, {
            startBeat = beat,
            val = val,
            mod = register[modName],
            finished = false,
            playfield = playfield,

            run = function(self, curBeat)
                self.finished = true
                SetValue(modName, self.val, self.playfield)
            end
        })
    end
end

function Modscript:queueFunc(beat, func)
    table.insert(timeline, {
        startBeat = beat,
        func = func,
        finished = false,

        run = function(self, curBeat)
            self.finished = true
            self.func()
        end
    })
end

function Modscript:queueEaseP(beat, endBeat, modName, percent, easeStyle, playfield, startVal)
    self:queueEase(beat, endBeat, modName, percent * 0.01, easeStyle, playfield, startVal * 0.01)
end

function Modscript:queueSetP(beat, modName, percent, playfield)
    self:queueSet(beat, modName, percent * 0.01, playfield)
end

function Modscript:call(func, args)
    tryExcept(
        function()
            if _G[func] then
                return _G[func](unpack(args or {}) or {})
            end
        end,
        function(e)
            print("FAILED TO CALL " .. func .. " | " .. e)
        end
    )
end

function Modscript:endSong()
    self.downscroll = Settings:getValue("Gameplay", "Mania", "Scroll Direction") == "Down"
end

return Modscript
