--[[
State.lua - @GuglioIsStupid

Heavily modified for use with Harmoni
]]

---@alias State table
---@class state
local state = {}
state.__index = state
state.__storage = {}
state.__transitions = {}

local current, last, substate = nil, nil, nil
state.inSubstate = false

-- Transition system internals
local activeTransition = nil
local transitionTarget = nil
local transitionArgs = nil

local canvas = nil

local callback = nil

-- Internal switch logic
local function switch(newstate, ...)
    if current and current.exit then
        current:exit()
    end
    last = current
    current = newstate
    if current.enter then
        current:enter(last, ...)
    end
    collectgarbage("collect")
    return current
end

-- Internal pop logic
local function pop(newstate, ...)
    if current and current.exit then current:exit() end
    last = current
    current = newstate
    if current.reload then current:reload(last, ...) end
    return current
end

function state.switch(newstate, ...)
    if not canvas then 
        canvas = love.graphics.newCanvas(baseScreenRatio.x, baseScreenRatio.y)
    end
    assert(type(newstate) == "table", "Called state.switch with invalid or no state")
    return switch(newstate, ...)
end

function state.push(newstate, ...)
    assert(type(newstate) == "table", "Called state.push with invalid or no state")
    table.insert(state.__storage, current)
    return switch(newstate, ...)
end

function state.pop()
    assert(#state.__storage > 0, "Called state.pop with no states in storage")
    return pop(table.remove(state.__storage))
end

function state.popAll()
    assert(#state.__storage > 0, "Called state.popAll with no states in storage")
    return pop(table.remove(state.__storage, 1))
end

function state.current() return current end
function state.last() return last end
function state.currentSubstate() return substate end

function state.returnToLast()
    assert(last, "Called state.returnToLast with no last state")
    return switch(last)
end

function state.substate(newstate, ...)
    assert(type(newstate) == "table", "Called state.substate with invalid or no state")
    substate = newstate
    state.inSubstate = true
    if substate.enter then substate:enter(...) end
    return substate
end

--[[ function state.resize(w, h)
    canvas = love.graphics.newCanvas(w, h)
end ]]

function state.killSubstate(...)
    if substate and substate.exit then substate:exit() end
    substate = nil
    state.inSubstate = false
    if current and current.substateReturn then current:substateReturn(...) end
end

function state.addTransition(name, file)
    assert(type(name) == "string", "State transition name must be a string")
    assert(type(file) == "string", "State transition file must be a string")

    state.__transitions[name] = love.filesystem.load(file)
    if not state.__transitions[name] then
        error("Failed to load state transition: " .. name .. " from file: " .. file)
    end
    return state.__transitions[name]
end

function state.transition(name, newstate, cb, ...)
    transitionArgs = {...}
    if type(cb) ~= "function" then
        -- its an argument
        transitionArgs = {cb, ...}
        cb = nil
    else
        callback = cb
    end
    assert(type(name) == "string", "Called state.transition with invalid transition name")
    assert(type(newstate) == "table", "Called state.transition with invalid newstate")

    local transition = state.__transitions[name]
    assert(transition, "Transition not found: " .. name)

    activeTransition = transition()
    transitionTarget = newstate

    if activeTransition.enter then
        activeTransition:enter(current, newstate, ...)
    end
end

function state.completeTransition()
    if not activeTransition then return end
    local newstate = transitionTarget
    local args = transitionArgs

    if activeTransition.endTransition then
        switch(newstate, nil, unpack(args))

        local nextTransitionLoader = love.filesystem.load(activeTransition.endTransition)
        if not nextTransitionLoader then
            error("Failed to load endTransition: " .. tostring(activeTransition.endTransition))
        end

        activeTransition = nextTransitionLoader()
        activeTransition.endTransition = nil

        if activeTransition.enter then
            activeTransition:enter(current, newstate, unpack(args))
        end

        return nil
    end

    if callback then
        callback(newstate, unpack(args))
        callback = nil
    end

    activeTransition = nil
    transitionTarget = nil
    transitionArgs = nil
    return nil
end

function state.killTransition()
    activeTransition = nil
    transitionTarget = nil
    transitionArgs = nil
    callback = nil
end

function state.isTransitioning()
    return activeTransition ~= nil
end

local function new(name)
    name = name or ("State." .. string.format("%x", love.math.random(0, 0xFFFFFFFF)))
    return setmetatable({
        __name = name,
        __forceCallEnter = true,
    }, {
        __tostring = function() return name end,
        __call = function(self, ...) return state.switch(self, ...) end
    })
end

local unpack = table.unpack or unpack

setmetatable(state, {
    __index = function(_, func)
        return function(...)
            local args = {...}
            if func == "draw" then
                local lastCanvas = love.graphics.getCanvas()
                love.graphics.setCanvas({canvas, stencil = true, depth = false})
                love.graphics.clear(0, 0, 0, 1)
                if current and current.draw then current:draw(unpack(args)) end
                if substate and substate.draw then substate:draw(unpack(args)) end
                if activeTransition and activeTransition.draw then
                    activeTransition:draw(activeTransition, unpack(args))
                    love.graphics.setColor(1, 1, 1, 1)
                end
                love.graphics.setCanvas(lastCanvas)
                if activeTransition and activeTransition.startDraw then
                    activeTransition:startDraw()
                end
                love.graphics.draw(canvas, 0, 0)
                if activeTransition and activeTransition.stopDraw then
                    activeTransition:stopDraw()
                end
            else
                if current and current[func] then current[func](current, unpack(args)) end
                if substate and substate[func] then substate[func](substate, unpack(args)) end
                if activeTransition and activeTransition[func] then
                    activeTransition[func](activeTransition, unpack(args))
                end
            end
        end
    end,
    __call = function(_, name) return new(name) end
})

return state
